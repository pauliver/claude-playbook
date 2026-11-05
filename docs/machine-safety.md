# Machine safety — commands that take a whole machine down

Rules: [`way-of-working.md`](../user-level/way-of-working.md) §8. Everything here was measured on a real Mac in 2026.

## A timeout bounds your wait, never the syscall

A thread blocked on a network filesystem (SMB, NFS, a NAS, a backup share) sits in an **uninterruptible kernel wait**
(state `U`/`D`). SIGTERM isn't delivered; **SIGKILL doesn't reap it**. The harness's 120 s timeout reports exit 143
and kills nothing; Ctrl-C, a new tab or killing the shell don't reach it either. It ends when the server answers or
the session times out. **The only defence is to not issue the call.**

| Call | Cost |
| --- | --- |
| `find $HOME -maxdepth 5 …` (a NAS share mounted inside the home directory) | the terminal, on every attached device, dead ~15 min |
| `sync` / `os.sync()` | state `U` for 6+ min, `kill -9` not reaped |
| a web framework's default builder → `FileSystemWatcher` → `sync(2)` on macOS | two test servers wedged ~6 min |
| `/sbin/mount` while a backup to the NAS was stuck | 11–19+ min in `U`, beside `backupd` and the menu bar |

## Rules for agents (copy into user-level CLAUDE.md if any share is mounted)

| Do not | Do instead |
| --- | --- |
| `find`/`du`/`ls -R`/`grep -r`/`rg`/`tree` rooted at `$HOME`, `~`, `/`, `/Users` | root at the project, or `find -x` / `du -x` |
| the agent's Grep/Glob with a path of `~` or `/` (ripgrep walks) | a path inside the project |
| bare `df` / `df -h` (stats every mount) | `df <one local path>` |
| `lsof` with no target | `lsof -p <pid>`, or `netstat -anv -p tcp` for ports |
| `sync`, in any form | nothing — you never need it |
| `ls`/`stat`/tab-completion under any mount point (`/Volumes`, `/net`, …) | `/sbin/mount` once — not in a loop, not during a backup |
| content reads (`cat`, `shasum`, `open`) in cloud-synced folders (`~/Library/Mobile Documents`, `~/Library/CloudStorage`, synced Desktop/Documents) | nothing — **a read downloads a cloud-only file** |
| `tmutil listbackups` / `latestbackup` / `destinationinfo` / `compare` | `tmutil listlocalsnapshotdates /`, `tmutil isexcluded <path>` |

**Enforce, don't document** — prose rules get skipped:
1. `permissions.deny` in `~/.claude/settings.json` for exact spellings (`Bash(find /Users/<you>:*)`, `Bash(find ~:*)`,
   `Bash(find /:*)`, `Bash(df)`, `Bash(df -h)`, …).
2. A `PreToolUse` hook on `Bash|Grep|Glob` that exits 2 for any walk rooted at an ancestor of a mount
   (`template/.claude/hooks/machine-guard.sh`). It catches mistakes, not every spelling.

## Other machine-level traps

- **A toolchain upgrade un-agrees a licence.** After an Xcode upgrade `xcrun` refuses *before* running the tool, so
  `devicectl`, the linker (`cargo build`), `flutter test` and the iOS build fail together while the device looks
  fine. Several unrelated tools failing at once is the signature. Compare
  `defaults read /Library/Preferences/com.apple.dt.Xcode IDEXcodeVersionForAgreedToGMLicense` with
  `defaults read /Applications/Xcode.app/Contents/Info.plist CFBundleShortVersionString`; the fix
  (`sudo xcodebuild -license`) needs a human.
- **Build servers that never exit:** set `MSBUILDDISABLENODEREUSE=1` and `-p:UseSharedCompilation=false` in the repo's
  `.claude/settings.json` `env` block (87 idle nodes, 9.4 GB in one day of subagents).
- **Killing by name** (`pkill dotnet`, "everything whose parent is 1") also kills launchd agents that won't restart
  after a clean exit. Match the exact image; exclude anything in `launchctl list`.
- **Case-insensitive APFS:** staging `App.app` beside an `App.App/` folder deletes the folder. Build into `artifacts/`.
- **Parallel load corrupts measurements:** five agents running the full suite put a 16-core Mac at load 140.
