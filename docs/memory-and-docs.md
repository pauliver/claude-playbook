# Memory, docs, and where each fact lives

Rules: [`way-of-working.md`](../user-level/way-of-working.md) §6.

## Why memory lives in the repo

Claude Code's auto-memory is machine-local (`~/.claude/projects/<dir>/memory/`). The correct branch-promotion rule once
sat in one laptop's memory while two in-repo docs told every other machine to push to `main`.

Commit `.claude/memory/` and load it one of two ways:
- **Import:** `@.claude/memory/MEMORY.md` in `CLAUDE.md` (plus `@memory/<file>.md` for the few always needed).
- **Symlink:** `ln -s <repo>/.claude/memory ~/.claude/projects/<dir>/memory`. In a worktree the symlink still points
  at the shared checkout — write to the worktree's copy.

A memory that isn't loaded is decoration: one repo committed a memory folder no session ever read.

## The format

```markdown
---
name: <slug = file stem>          # claim-sentence slugs work well: a-test-that-cannot-fail
description: <one line with the hook and, ideally, a number>
metadata:
  type: feedback | project | reference | user
---

<The rule, in one or two sentences.>

**Why:** <the dated scar — what happened, measured, the owner's words quoted>
**How to apply:** <what to do differently, concretely>
Related: [[other-memory]]
```

Index lines (`- [Title](file.md) — hook`) should carry the rule itself; the files are rarely opened. Group them (how
we work / project state / architecture & gotchas / reference). Observatory's board parses `MEMORY.md`, so its path and
format are an interface.

## Evidence for the hygiene rules

- **Encoding works:** "don't forget to file / lock / update issues" reminders were constant for two months and nearly
  vanished once encoded in skills.
- **Lint the layer** once it grows: frontmatter present, every file indexed, `[[links]]` resolve, backticked paths
  exist, size caps — against a baseline that may only shrink.
- **Not memory:** line numbers and API shapes (comments, tests), priorities (GitHub), counts (the file that derives
  them), anything already in CLAUDE.md.
- **Say it once:** one CLAUDE.md reached 1,003 lines, ~25% of it universal, so every session paid ~24k tokens for other
  products' detail; a shared file plus per-product indexes fixed it. Another audit found six count defects, each a
  number restated elsewhere — under a warning saying "do not carry them forward".
- **Line citations rot:** three went stale in one session. An audit agent once re-stamped a stale doc "verified accurate".

## Where each fact lives

| Fact | Home |
| --- | --- |
| Rules true now | `CLAUDE.md` — present tense, short; product detail in per-area indexes |
| How we work (portable) | `~/.claude/way-of-working.md` — never restated in a repo |
| This repo's process | `docs/` (`issue-labels.md`, `testing.md`) |
| Current state / in flight | ONE overwritten `STATUS.md` / `INFLIGHT.md` |
| Direction | the plan doc |
| Owner decisions | the `D<n>` log |
| Lessons that change a future action | a memory |
| A finding during work | a comment on the issue that owns its class |
| Evidence (audits, bake-offs, forensics) | `.claude/notes/<date>-<topic>.md` |
| Handoffs | `.claude/work/state-<date>.md` |
| A re-measurable number | ONE place, stamped `(measured <sha>, <date>, <OS>)` |

## Handoffs

`.claude/work/state-<date>.md`: first commands to run, exact repo state (pushed / unpushed / uncommitted), device
state, traps already paid for, memories owed, agents in flight. "A pointer to a dead agent is worse than no pointer:
it reads like the work is done and parked somewhere."
