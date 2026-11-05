---
name: feedback-wrap-up-protocol
description: "Wrap up / what's next / are we done" is answered by RUNNING five checks — pushed, memories, issues, fresh-eyes review, nothing stray — and saying plainly what is not done
metadata:
  type: feedback
---

"What's next, or are we done?" is answered point by point (skill `wrap-up`; mechanical half `scripts/wrap-up-check.sh`):
1. Work committed and pushed. 2. Memories saved in-repo and pushed. 3. Issues moved or closed (Root cause / Fix /
Verified). 4. Fresh-eyes review (`review-fresh-eyes`): perf, blocking I/O, duplicate paths, north-star drift — fixed
test-first or filed on the owning issue. 5. No stray worktrees, branches (local or origin) or stashes.

**Why:** the owner typed this checklist 44 times before it became a skill. Done = another machine can resume from
GitHub alone.

**How to apply:** run the checks (`git status`, `git log origin/<b>..<b>`, `git worktree list`,
`git ls-remote --heads origin`, `git stash list`, open issues) — never answer from memory.
