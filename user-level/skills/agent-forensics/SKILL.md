---
name: agent-forensics
description: Read-only post-mortem of a subagent that failed, stalled, looped, left a mess or reported done with nothing to show — gather evidence (worktrees, locks, branches, reflog, issue timeline, artifacts) before touching anything, classify it, recommend RETRY / DECOMPOSE / MANUAL / CLEANUP / ESCALATE.
---

# agent-forensics

**Preserve evidence:** no `git checkout`, `clean`, `reset`, worktree removal or rebuild until diagnosed. Thin data →
"insufficient evidence", not a guess.

## Gather
1. `git worktree list`; per worktree `git -C <wt> status --porcelain`, `log --oneline -5`, `stash list`; lock/claim
   files; output mtimes (`ls -la` — never `cat` a transcript).
2. `git ls-remote --heads origin` vs local: commits never landed.
3. `gh issue view N --comments`: claim, landing comment, label history.
4. `git reflog` around the failure.
5. The last gate log, compiler errors, an error repeating.

## Classify
| class | signature |
| --- | --- |
| `orphaned_work` | changes uncommitted/staged in a worktree, agent gone |
| `orphaned_branch` | commits pushed, never landed or reported |
| `build_loop` | same error across 3+ builds — the approach is wrong, not the typo |
| `merge_conflict` | rebase/merge abandoned mid-way |
| `wrong_branch` / `wrong_base` | stale base (worktrees are cut from `origin/HEAD`) or wrong branch |
| `missing_file` | stalled on a path/script that doesn't exist |
| `escalation_loop` | blocked on a decision it couldn't make, asking repeatedly |
| `silent_idle` | commits exist, never reported |
| `hung` | no commits, stale mtimes, still "running" |

## Report
```
FORENSICS_DONE
CLASSIFICATION: <class>
ROOT_CAUSE:     <one or two sentences, MEASURED or REASONED>
EVIDENCE:       <the commands and what they showed>
RECOVERABLE_WORK: <shas, worktree paths, stashes — and how to land them>
RECOMMENDATION: RETRY (same brief) | DECOMPOSE (smaller issues) | MANUAL | CLEANUP | ESCALATE (owner)
BRIEF FIX:      <what the next brief must say so this doesn't recur>
```
A recurring class is a missing guard: fix the brief template or add a check, and save a memory.
