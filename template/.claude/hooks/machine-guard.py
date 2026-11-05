#!/usr/bin/env python3
"""
machine-guard.py — Claude Code PreToolUse hook (Bash | Grep | Glob) that BLOCKS commands that can wedge a machine:
recursive walks rooted at $HOME or / (they descend into network mounts), bare `df`, `sync`, untargeted `lsof`, and
anything under a network mount point.

Why a hook: a thread blocked in a network-filesystem call is an UNINTERRUPTIBLE kernel wait — SIGKILL doesn't reap it,
timeouts kill nothing. `find $HOME -maxdepth 5` froze a terminal on every attached device for ~15 minutes. The only
defence is not issuing the call. Guards against mistakes, not every possible spelling.

Wire it in .claude/settings.json (project) or ~/.claude/settings.json (every project):
  "hooks": {"PreToolUse": [{"matcher": "Bash|Grep|Glob",
     "hooks": [{"type": "command", "command": "python3 \"$CLAUDE_PROJECT_DIR\"/.claude/hooks/machine-guard.py", "timeout": 10}]}]}

Exit 0 = allow (silent). Exit 2 = block; stderr is shown to the agent as the reason.
Extra mount roots: MACHINE_GUARD_MOUNTS="/path/one:/path/two". Disable for one session: MACHINE_GUARD_OFF=1.
Self-test: python3 machine-guard.py --self-test
"""
import json
import os
import re
import shlex
import sys

HOME = os.path.realpath(os.path.expanduser("~"))
MOUNT_ROOTS = ["/Volumes", os.path.join(HOME, "mnt"), "/net", "/mnt", "/media", "/System/Volumes/Data/Volumes"]
MOUNT_ROOTS += [p for p in os.environ.get("MACHINE_GUARD_MOUNTS", "").split(":") if p]
# Walking any of these (or an ancestor of them) crosses into every mount beneath.
WIDE_ROOTS = {"/", "/Users", "/home", HOME, "/System/Volumes/Data", "/private"}

WALKERS = {"find", "du", "tree", "fd", "fdfind", "rg", "ag", "ack"}
RECURSIVE_IF_FLAG = {  # command -> regex over a flag that makes it recursive
    "grep": re.compile(r"^-([a-zA-Z]*[rR][a-zA-Z]*)$|^--recursive$|^--dereference-recursive$"),
    "egrep": re.compile(r"^-([a-zA-Z]*[rR][a-zA-Z]*)$|^--recursive$"),
    "ls": re.compile(r"^-[a-zA-Z]*R[a-zA-Z]*$|^--recursive$"),
    "cp": re.compile(r"^-[a-zA-Z]*[rR][a-zA-Z]*$"),
    "rsync": re.compile(r"^-[a-zA-Z]*[ra][a-zA-Z]*$|^--recursive$|^--archive$"),
    "chmod": re.compile(r"^-[a-zA-Z]*R[a-zA-Z]*$"),
    "chown": re.compile(r"^-[a-zA-Z]*R[a-zA-Z]*$"),
}
ONE_DEVICE = {"find": {"-x", "-xdev", "-mount"}, "du": {"-x"}}


def norm(path, cwd):
    p = os.path.expandvars(os.path.expanduser(path))
    if not os.path.isabs(p):
        p = os.path.join(cwd, p)
    p = os.path.normpath(p)
    try:
        # realpath may itself stat; only resolve when the prefix is clearly local (not under a mount root)
        if not any(p == m or p.startswith(m.rstrip("/") + "/") for m in MOUNT_ROOTS):
            p = os.path.realpath(p)
    except OSError:
        pass
    return p


def under_mount(p):
    return any(p == m or p.startswith(m.rstrip("/") + "/") for m in MOUNT_ROOTS)


def is_wide(p):
    return p in WIDE_ROOTS or p.rstrip("/") in WIDE_ROOTS


def segments(command):
    # split on ; && || | & and newlines, roughly; good enough to find each command's argv
    for seg in re.split(r"\|\||&&|[;|&\n]", command):
        seg = seg.strip()
        if not seg:
            continue
        try:
            argv = shlex.split(seg, comments=True)
        except ValueError:
            argv = seg.split()
        # strip env assignments and wrappers
        while argv and (re.match(r"^[A-Za-z_][A-Za-z0-9_]*=", argv[0]) or argv[0] in
                        {"sudo", "nice", "time", "command", "exec", "nohup", "timeout", "gtimeout", "caffeinate"}):
            head = argv.pop(0)
            if head in {"timeout", "gtimeout"} and argv and re.match(r"^[0-9.]+[smhd]?$", argv[0]):
                argv.pop(0)
        if argv:
            yield argv


def check_bash(command, cwd):
    for argv in segments(command):
        cmd = os.path.basename(argv[0])
        args = argv[1:]
        if cmd in ("cd", "pushd"):  # follow directory changes within one command line
            cwd = norm(args[0], cwd) if args and args[0] != "-" else HOME
            continue
        flags = [a for a in args if a.startswith("-")]
        paths = [a for a in args if not a.startswith("-")]

        if cmd == "sync":
            return "`sync` can block for minutes in an uninterruptible wait on a network mount. You never need it."
        if cmd == "df" and not paths:
            return "bare `df` stats EVERY mounted filesystem; one dead share hangs it. Use `df <one local path>`."
        if cmd == "lsof" and not any(f in ("-p", "-i") or f.startswith("-p") or f.startswith("-i") for f in flags):
            return "untargeted `lsof` stats every mount. Use `lsof -p <pid>` or `netstat -anv -p tcp`."

        recursive = cmd in WALKERS or (cmd in RECURSIVE_IF_FLAG and any(RECURSIVE_IF_FLAG[cmd].match(f) for f in flags))
        targets = [norm(p, cwd) for p in paths if p.startswith(("/", "~", "$", ".")) or "/" in p]
        if cmd in {"rg", "ag", "ack", "fd", "fdfind", "tree"} and not targets:
            targets = [norm(".", cwd)]
        if cmd == "find" and not targets:
            targets = [norm(".", cwd)]

        for t in targets:
            if under_mount(t) and (recursive or cmd in {"ls", "stat", "xattr", "du", "cat", "head", "tail", "shasum", "md5"}):
                return f"`{cmd}` touches {t}, under a network mount root. Calls there can block unkillably."
        if recursive:
            if cmd in ONE_DEVICE and set(flags) & ONE_DEVICE[cmd]:
                continue  # stays on one device: cannot cross into a mount
            for t in targets:
                if is_wide(t):
                    return (f"`{cmd}` walks {t}, which contains network mounts. Root it at the project directory, "
                            f"or use `find -x` / `du -x` to stay on one device.")
    return None


def check_search_tool(tool_input, cwd):
    p = tool_input.get("path") or cwd
    t = norm(p, cwd)
    if is_wide(t) or under_mount(t):
        return f"Grep/Glob are recursive walks; {t} contains (or is) a network mount. Give a path inside the project."
    return None


def decide(event):
    tool = event.get("tool_name", "")
    ti = event.get("tool_input", {}) or {}
    cwd = event.get("cwd") or os.getcwd()
    if tool == "Bash":
        return check_bash(ti.get("command", ""), cwd)
    if tool in ("Grep", "Glob"):
        return check_search_tool(ti, cwd)
    return None


def self_test():
    proj = os.path.join(HOME, "Projects", "x")
    cases = [
        ("Bash", f"find {HOME} -maxdepth 5 -name '*.db'", True),
        ("Bash", "find ~ -name foo", True),
        ("Bash", f"find {HOME} -x -maxdepth 5 -name foo", False),
        ("Bash", "find . -name '*.cs'", False),
        ("Bash", "find / -name foo", True),
        ("Bash", "du -sh ~", True),
        ("Bash", "du -xsh ~", True),  # combined flags are not parsed as -x: conservative block
        ("Bash", "du -sh .", False),
        ("Bash", "df", True),
        ("Bash", "df -h", True),
        ("Bash", "df -h .", False),
        ("Bash", "sync", True),
        ("Bash", "lsof", True),
        ("Bash", "lsof -p 123", False),
        ("Bash", "grep -rn foo ~", True),
        ("Bash", "grep -rn foo src", False),
        ("Bash", "grep foo ~/notes.txt", False),
        ("Bash", "ls -la /Volumes/share", True),
        ("Bash", f"ls {HOME}/mnt/nas", True),
        ("Bash", "ls -la", False),
        ("Bash", "git status && rg TODO", False),
        ("Bash", "cd / && rg TODO", True),
        ("Bash", "cd src && rg TODO", False),
        ("Bash", "timeout 60 find ~ -name x", True),
        ("Grep", {"path": HOME}, True),
        ("Grep", {"path": proj}, False),
        ("Glob", {"path": "/"}, True),
    ]
    bad = 0
    for tool, inp, want_block in cases:
        ti = {"command": inp} if tool == "Bash" else inp
        got = decide({"tool_name": tool, "tool_input": ti, "cwd": proj}) is not None
        mark = "ok " if got == want_block else "BAD"
        bad += got != want_block
        print(f"{mark} {'BLOCK' if got else 'allow'}  {tool}: {inp}")
    print(f"{len(cases) - bad}/{len(cases)} passed")
    return 1 if bad else 0


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "--self-test":
        sys.exit(self_test())
    if os.environ.get("MACHINE_GUARD_OFF") == "1":
        sys.exit(0)
    try:
        event = json.load(sys.stdin)
    except Exception:
        sys.exit(0)  # never block on a malformed event; the guard must not become the outage
    reason = decide(event)
    if reason:
        print(f"machine-guard: BLOCKED. {reason}", file=sys.stderr)
        sys.exit(2)
    sys.exit(0)


if __name__ == "__main__":
    main()
