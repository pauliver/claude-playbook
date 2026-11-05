#!/usr/bin/env bash
# =====================================================================================================================
#  adopt-repo.sh — copy the repo template into an existing repo WITHOUT overwriting anything, then report the gaps.
#
#  It copies only files that don't exist yet, appends missing .gitignore lines, and never commits, pushes, or creates
#  labels (run template/scripts/setup-labels.sh yourself — labels are read by external boards). Fill in the
#  <PLACEHOLDERS> afterwards, or let Claude do it with the `adopt-playbook` skill.
#
#  Usage: scripts/adopt-repo.sh <path-to-repo> [--dry-run]
# =====================================================================================================================
set -euo pipefail
src="$(cd "$(dirname "$0")/.." && pwd)/template"
repo="${1:?usage: $0 <path-to-repo> [--dry-run]}"; dry=0; [[ "${2:-}" == "--dry-run" ]] && dry=1
repo="$(cd "$repo" && git rev-parse --show-toplevel)"
echo "repo: $repo"
vis="$(cd "$repo" && gh repo view --json visibility -q .visibility 2>/dev/null || echo 'NO REMOTE / unknown')"
echo "visibility: $vis"
[[ "$vis" == "PUBLIC" ]] && echo "  ⚠ PUBLIC repo: put no machine names, paths, IPs or personal details in anything you add."

added=0; kept=0
while IFS= read -r -d '' f; do
  rel="${f#$src/}"
  [[ "$rel" == "gitignore-additions.txt" ]] && continue
  if [[ -e "$repo/$rel" ]]; then echo "  exists   $rel"; kept=$((kept+1)); continue; fi
  echo "  add      $rel"; added=$((added+1))
  (( dry )) && continue
  mkdir -p "$(dirname "$repo/$rel")"; cp -p "$f" "$repo/$rel"
done < <(find "$src" -type f -print0 | sort -z)

echo ".gitignore:"
while IFS= read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  if [[ -f "$repo/.gitignore" ]] && grep -qxF "$line" "$repo/.gitignore"; then continue; fi
  echo "  append   $line"
  (( dry )) || printf '%s\n' "$line" >> "$repo/.gitignore"
done < "$src/gitignore-additions.txt"

echo
echo "added: $added   already present (left alone): $kept"
(( dry )) && echo "DRY RUN — nothing written."
cat <<EOF
Next:
  1. Fill the <PLACEHOLDERS> in CLAUDE.md, .claude/howtowork.md, docs/issue-labels.md (north star, areas, branch).
  2. Configure scripts/run-full-tests.sh — it FAILS until you do.
  3. bash scripts/setup-labels.sh <owner/repo> 'area:x=…'      (creates/refreshes only; never renames)
  4. If the repo already had its own memory folder elsewhere, merge it into .claude/memory/ and the index.
  5. Commit by pathspec. Or ask Claude: "use the adopt-playbook skill on this repo".
EOF
