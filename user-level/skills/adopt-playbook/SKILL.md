---
name: adopt-playbook
description: Bring a repo up to the way of working — audit it against the playbook (CLAUDE.md, loaded memory, settings, gate, labels, templates, wrap-up check, machine guard), then add only what's missing from the template, never overwriting. Use for a new repo, "set this repo up properly", "apply our process here".
---

# adopt-playbook

Template: the playbook's `template/` (conventionally `~/Projects/claude-playbook/template/`).

## 1. Audit (read-only) — report the gap table before changing anything
| Piece | Must have |
| --- | --- |
| `CLAUDE.md` | what the repo is, gate command, working branch + push authority, a map |
| Memory | `.claude/memory/MEMORY.md` committed and **loaded** (`@.claude/memory/MEMORY.md` or auto-memory symlink); machine-local memories moved in |
| Settings | committed `.claude/settings.json` (model, env, permissions, hooks); `settings.local.json` gitignored |
| Gate | `scripts/run-full-tests.sh` (+ `.cmd` on Windows), SUMMARY last, into a gitignored `*-last.log` |
| Labels | fleet set via `template/scripts/setup-labels.sh` (creates/refreshes only) + `area:*`; `docs/issue-labels.md` with areas and north star |
| Issue templates | `.github/ISSUE_TEMPLATE/` with Done-when + Verify |
| Wrap-up | `scripts/wrap-up-check.sh` |
| Machine guard | the PreToolUse hook, if the machine has network mounts |
| Agents | `.claude/howtowork.md` routing table (+ repo workers/personas) if it uses agents |
| `.gitignore` | `.claude/settings.local.json`, `.claude/.observatory-hooks.jsonl`, `.claude/worktrees/`, `*-last.log`, build output |

## 2. Ask the owner (`owner-question`, one at a time)
North-star sentence · working branch + push authority · public or private (public: no machine names, paths, IPs or
personal details) · the areas.

## 3. Add what's missing — never overwrite
Copy from the template, fill in the repo's real commands and areas, merge into existing files by hand. CLAUDE.md is
rules + pointers; link the way of working, don't restate it.

## 4. Prove it
The gate must FAIL until configured (an unconfigured gate that passes is a lie); run `wrap-up-check.sh` and
`health-check`. Pathspec commit; push per the owner's answer — or open a PR, or one issue with the gap table.
