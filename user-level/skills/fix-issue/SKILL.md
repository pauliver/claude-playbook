---
name: fix-issue
description: Implement one GitHub issue end to end — verify the number, read it all, claim it, extend the existing owner, test first, gate, negative proof, pathspec commit, push per repo rules, comment the landing, move to ReadyToVerify. Stops before verification. Use for "fix issue N", "implement issue N". Repo's own wins.
---

# fix-issue

1. **Resolve the number:** `gh issue view N --json title,state,labels` — ledger numbers collide with issue numbers (one
   collision closed the wrong issue).
2. **Read it all,** every comment. Extract Done-when (missing → infer, note it). Over ~half a day, no plan →
   `plan-feature`.
3. **Check what's decided:** decision log, memory, the folder's `AGENTS.md`.
4. **Fetch and claim:** `git pull --rebase`; claimed elsewhere → STOP, pick other work; else a one-line claim comment
   (machine + time) and move the label.
5. **Extend the owner** of the behaviour — never a parallel copy.
6. **Test first;** see it fail for the right reason.
7. **Implement:** scoped diff, no gold-plating, stubs or test-only branches.
8. **Gate** (`scripts/run-full-tests.sh` or the repo's); read the SUMMARY.
9. **Negative proof:** break the fix → red → restore → green.
10. **Commit** by pathspec (message per way-of-working §4: claim subject, negative proof, gate line, "issue N").
11. **Push** only with standing authority on green (re-gate after a rebase); else say it's ready to push.
12. **Comment the landing** (shas, gate line, what to verify); move to `ReadyToVerify`. Close instead only if
    verification was executed, nothing real-host remains, and the repo lets implementers close.
13. **Stop:** "Ready for independent verification." Never verify your own work — route to `verify-independently` /
    `qa-verifier`.
