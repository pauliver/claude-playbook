---
name: feedback-memories-live-in-repo
description: Every memory about this project goes in .claude/memory/ in the repo and is committed; machine-local memory holds only a pointer
metadata:
  type: feedback
---

Every project memory lives in **`.claude/memory/`**, indexed in `MEMORY.md`, committed. Machine-local
`~/.claude/projects/<dir>/memory/` holds only a pointer here (or is a symlink to this folder).

**Why:** a memory one machine can read makes that machine confident and the rest wrong — a correct branch rule once
sat in one laptop's local memory while two in-repo docs told every other machine to push to `main`.

**How to apply:** write the file, add one index line, commit it by pathspec (a blind `git add -A` sweeps memory edits
into unrelated commits). In a worktree, write to its `.claude/memory/`. Fix a wrong memory the same day; mark
superseded ones rather than deleting. Related: [[feedback-wrap-up-protocol]].
