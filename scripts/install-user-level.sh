#!/usr/bin/env bash
# =====================================================================================================================
#  install-user-level.sh — install the portable way of working into ~/.claude (every repo, this machine).
#
#  Installs:  ~/.claude/way-of-working.md       (the rules; imported from ~/.claude/CLAUDE.md)
#             ~/.claude/agents/<role>.md         (producer, qa-verifier, fresh-eyes-reviewer, implementer, architect, ops-director)
#             ~/.claude/skills/<skill>/SKILL.md  (wrap-up, owner-question, review-fresh-eyes, fix-issue, …)
#  Optional:  --with-guard  → ~/.claude/hooks/machine-guard.py (prints the settings.json snippet; never edits settings)
#
#  Safe by default: never overwrites a file that differs without --force (it shows the diff summary instead), never
#  deletes anything, and backs up any file it replaces to ~/.claude/backups/playbook-<timestamp>/.
#
#  Usage: scripts/install-user-level.sh [--dry-run] [--force] [--with-guard]
# =====================================================================================================================
set -euo pipefail
src="$(cd "$(dirname "$0")/.." && pwd)"
dst="${CLAUDE_HOME:-$HOME/.claude}"
dry=0; force=0; guard=0
for a in "$@"; do case "$a" in
  --dry-run) dry=1 ;; --force) force=1 ;; --with-guard) guard=1 ;;
  *) echo "unknown option: $a" >&2; exit 2 ;; esac; done
backup="$dst/backups/playbook-$(date +%Y%m%dT%H%M%S)"
changed=0; skipped=0

put() {  # src-file dst-file
  local s="$1" d="$2"
  if [[ -f "$d" ]] && cmp -s "$s" "$d"; then echo "  same     ${d/#$HOME/~}"; return; fi
  if [[ -f "$d" && $force -eq 0 ]]; then
    echo "  DIFFERS  ${d/#$HOME/~}  (kept; re-run with --force to replace — $(diff "$d" "$s" | grep -c '^[<>]') lines differ)"
    skipped=$((skipped+1)); return
  fi
  echo "  install  ${d/#$HOME/~}"
  changed=$((changed+1))
  (( dry )) && return
  mkdir -p "$(dirname "$d")"
  if [[ -f "$d" ]]; then mkdir -p "$backup/$(dirname "${d#$dst/}")"; cp -p "$d" "$backup/${d#$dst/}"; fi
  cp "$s" "$d"
}

echo "way of working:"
put "$src/user-level/way-of-working.md" "$dst/way-of-working.md"

echo "agents:"
for f in "$src"/user-level/agents/*.md; do put "$f" "$dst/agents/$(basename "$f")"; done

echo "skills:"
for d in "$src"/user-level/skills/*/; do
  n="$(basename "$d")"
  for f in "$d"*; do put "$f" "$dst/skills/$n/$(basename "$f")"; done
done

echo "CLAUDE.md import:"
line='@~/.claude/way-of-working.md'
if [[ -f "$dst/CLAUDE.md" ]] && grep -qF "$line" "$dst/CLAUDE.md"; then
  echo "  present  ~/.claude/CLAUDE.md already imports it"
elif [[ -f "$dst/CLAUDE.md" ]]; then
  echo "  append   $line → ~/.claude/CLAUDE.md"
  if (( ! dry )); then
    mkdir -p "$backup"; cp -p "$dst/CLAUDE.md" "$backup/CLAUDE.md"
    printf '\n## The way of working (every repo)\n\n%s\n' "$line" >> "$dst/CLAUDE.md"
  fi
else
  echo "  create   ~/.claude/CLAUDE.md from user-level/CLAUDE.md.example"
  (( dry )) || cp "$src/user-level/CLAUDE.md.example" "$dst/CLAUDE.md"
fi

if (( guard )); then
  echo "machine guard:"
  put "$src/template/.claude/hooks/machine-guard.py" "$dst/hooks/machine-guard.py"
  (( dry )) || chmod +x "$dst/hooks/machine-guard.py"
  cat <<'EOF'
  To enable it for every project, add this to ~/.claude/settings.json (merge into any existing "hooks"):
    "hooks": { "PreToolUse": [ { "matcher": "Bash|Grep|Glob",
      "hooks": [ { "type": "command", "command": "python3 ~/.claude/hooks/machine-guard.py", "timeout": 10 } ] } ] }
  Self-test first:  python3 ~/.claude/hooks/machine-guard.py --self-test
EOF
fi

echo
(( dry )) && echo "DRY RUN — nothing written."
echo "installed/updated: $changed   kept (differs): $skipped"
[[ -d "$backup" ]] && echo "backups: $backup"
echo "Agent types and skills load at session start — restart Claude Code sessions to pick them up."
