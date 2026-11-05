# `.claude/` — this repo's AI process layer

| Path | What | In git? |
| --- | --- | --- |
| `memory/` | One fact per file + `MEMORY.md` index, loaded from `CLAUDE.md` | **yes, always** |
| `howtowork.md` | Routing: which agent/persona/skill for which job; repo brief rules | yes |
| `agents/` | Repo workers (`<repo>-*`) and personas (`x-*`); generic roles live in `~/.claude/agents/` | yes |
| `skills/` | Repo-specific skills only; generic ones are user-level | yes |
| `hooks/` | `machine-guard.py` (self-test: `python3 hooks/machine-guard.py --self-test`) | yes |
| `plans/` | `NNN-slug.md` with a status header; superseded, never overwritten | yes |
| `notes/` | Dated evidence: audits, bake-offs, forensics | yes |
| `work/` | Handoffs: `state-<date>.md` (repo state, first commands, traps, owed memories) | yes |
| `settings.json` | Model pin, env, permissions, hooks | yes |
| `settings.local.json` | Machine-local overrides; Observatory's event hooks | **no** |
| `.observatory-hooks.jsonl` | Observatory's hook event log | **no** |
| `worktrees/` | Agent worktrees (remove once landed) | **no** |

Never here: daemon runtime state, logs, tokens, personal data.
