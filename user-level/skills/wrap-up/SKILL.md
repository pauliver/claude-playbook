---
name: wrap-up
description: The Wrap-Up Protocol — answer "what's next, or are we done?" with measured facts — pushed, memories in the repo, issues true, fresh-eyes review ran, nothing stray or left running. Use for "wrap up", "are we done", "what's next", "next steps", before ending a stretch or switching machines.
---

# wrap-up

Done = another session, on any machine, can pick it up from GitHub and the repo alone. **Run every check for real.**

1. **Committed and pushed:** `git status`, `git log origin/<branch>..<branch>`, to the branch the repo names (e.g.
   `Next` where promoting `main` is the owner's call).
2. **Memories in the repo:** owner corrections, measured facts and traps are `.claude/memory/` files indexed in
   `MEMORY.md`, committed — not machine-local.
3. **Issues true:** every piece of work has one at the right Stage; finished work closed with `Root cause / Fix (sha) /
   Verified` or in `ReadyToVerify` with what to check; follow-ups on the issue owning their class.
4. **Fresh-eyes review** of the stretch (`review-fresh-eyes` or the repo's own), findings fixed test-first or filed.
   Docs-only stretches skip it.
5. **Nothing stray:** `git worktree list` (running agents' worktrees are fine — say so), `git ls-remote --heads origin`
   + local branches, `git stash list` (empty). Prove redundancy by content first (see `session-start`), record the
   tip sha, and ask before deleting anything you didn't create.
6. **Nothing left running** that you launched — prove it from the process list and ports, not an agent's "clean
   shutdown".

`scripts/wrap-up-check.sh`, if present, checks 1, 3 (counts) and 5, exiting non-zero when anything isn't done.

## Answer
Each point **DONE / NOT DONE** with evidence (sha, count, command output) and why not. Then **What's next:** the 1–3
highest-value moves (north-star first) and what waits on the owner (decisions via `owner-question`).
