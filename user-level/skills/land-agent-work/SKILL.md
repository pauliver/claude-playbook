---
name: land-agent-work
description: Land a finished subagent's work — read its report as a skeptic, check its commits yourself, provenance-scan, merge, gate on a clean checkout, push only the verified sha, close or move its issues, remove the worktree and branch. Use every time an agent reports done. Repo's own wins.
---

# land-agent-work

Only the main session (or Producer) pushes, closes issues and moves labels. Every step is a scar.

1. **Read the report as a skeptic:** claims to check, anything unsure (owner questions → `owner-question`), files
   outside its lane, decisions it added. **An agent that returned nothing did no work.**
2. **Read the commits yourself:** `git log --oneline <base>..<branch>` (worktree) or `git log --oneline
   origin/<main>..<main>` — agents have reported shas typed before the commit existed.
3. **Provenance scan:** grep the diff for `lock (new `, `if (true)`, `if (false)`, `&& false`, `|| true`,
   commented-out `return`/`throw`, `catch {}`, `Skip =`, `.only(` — and **read every removed line**. An agent stopped
   between "mutate" and "restore" ships the mutation looking green.
3b. **Accept or reject:** `success_criteria_met` with evidence per criterion and same-binary proof for tests, or send
   it back. **Re-derive risk from the changed paths** (a `.mm` change "verified on Windows" was caught so).
4. **Merge:** `git merge --no-ff <branch> -m "Merge <what> (#issues)"`. Append-only log conflicts: keep both sides'
   rows, sorted, deduped. Anything else: read both sides; never discard another's work.
5. **Gate on a CLEAN checkout** — if an agent may still be editing the main tree, `git worktree add --detach
   <scratch>/verify <sha>`. Big or risky → `qa-verifier`.
6. **Push only the verified sha, gated in the same command:** `bash scripts/run-full-tests.sh && git push origin
   <sha>:<branch>` (a merge was once pushed with `gate exit 1` on screen). Privacy rule → `gh repo view --json
   visibility` first.
7. **Issues:** test-verified, nothing a human must see → close with `Root cause / Fix (sha) / Verified`. Needs a user
   or real host → `ReadyToVerify` with exactly what to check. Tick epic lines; follow-ups onto the issue owning their
   class.
8. **Atomic:** land → confirm the issue moved/closed (never before the code lands) → release the lane. Stop the
   finished agent; dispatch the next issue.
9. **Clean up** after merge + push: `git worktree remove <path>`, `git branch -d <branch>` (stray `worktree-agent-*`
   branches are wrap-up's commonest find).
10. Update the plan/status doc if the map changed; save any lesson as a repo memory.
