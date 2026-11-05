---
name: session-start
description: Start-of-session protocol (the mirror of wrap-up) — inventory git, stashes, worktrees, remote branches and in-flight issues; reconcile branches by content; clean only unambiguous residue; brief "session ready" with what to do first. Use at session start, after switching machines, or when the producer boots.
---

# session-start

START and END (`wrap-up`) inventory the same surfaces. START detects, reports and brings up; anything not proven
redundant is reported, not removed (way-of-working §4).

1. `git fetch --prune`; `git pull --rebase` (or say why not). Note what moved on origin.
2. **Worktrees:** `git worktree list`. Per extra one: agent still running (lock, fresh mtime)? If not,
   `git -C <wt> status --porcelain` — its uncommitted work may be the only copy. Report; don't remove.
3. **Stashes:** `git stash list`; `git stash show -p stash@{n} | head` each; report owner/age/contents. **Never drop**
   (one held 400+ never-committed assets).
4. **Branches:** `git ls-remote --heads origin` (`git branch -r` once showed 17 "open" that were 3) plus local. In-flight
   today → keep. Otherwise reverse-apply from a clean `origin/main` checkout (squash merges defeat ancestry checks):
   ```bash
   mb=$(git merge-base origin/main origin/$b)
   git diff "$mb" "origin/$b" | git apply --reverse --check -p1 && echo "$b REDUNDANT"
   ```
   Applies → redundant: record the tip sha; delete at END, or now if unambiguous. Fails → check per file; on a
   high-churn file it often means "landed, then main moved on" — eyeball it.
5. **In flight:** `ReadyToVerify` (finish first), your `ReadyToImplement` claims, `DesignDoc` past its time-box,
   unstaged issues, `needs-decision`; the in-flight/STATUS file and newest handoff note.
6. **Toolchain sanity** (e.g. the Xcode-licence check on macOS) before a multi-hour build.
7. **Brief "Session ready":** repo state, anything ambiguous for the owner, the first 1–3 things to do.
