---
name: verify-independently
description: Independently verify a fix or feature — clean build of the exact sha, per-criterion evidence with numbers, regression check, verdict on the issue; PASS closes, FAIL returns to ReadyToImplement. Never by the implementer. Use for "verify issue N", "sign off", any ReadyToVerify issue. Repo's own wins.
---

# verify-independently

**Independence first:** if this session or agent implemented it, STOP and dispatch `qa-verifier` (or `general-purpose`
told to read `~/.claude/agents/qa-verifier.md`).

1. **Pin the target:** Done-when, `Verify:` line, and the commit range from the landing comment; check the shas exist
   (`git log`).
2. **Clean build of that sha** (detached worktree if the main tree is shared or dirty).
3. **Gate:** green full gate already recorded on this exact sha (host + OS) → don't re-run, attack the claims; else run
   it once.
4. **Each criterion:** steps / expected / **observed, with numbers**, on the user's real path — observed state, not a
   return value; look at screenshots before citing them.
5. **Test honesty** (way-of-working §1–2): new tests ran, by name, from a binary built after the last commit; negative
   proof recorded (or do one); no test-only branch; skips didn't rise. Trust your own clean build over the
   implementer's runtime claims.
5b. **Completeness:** map every planned item (phases, checkboxes, Done-when lines) to a commit. Missing →
   **VERIFY_PARTIAL** with the list. Design/exploration issues: findings committed, next steps filed?
6. **Regression:** neighbours by blast radius.
7. **Post the verdict** on the issue (template in `qa-verifier.md`): host, OS, sha, what was NOT checked.
8. **PASS** → close `Root cause: … / Fix: <sha> / Verified: <how, where, numbers>`; tick the epic line.
   **FAIL** → exact failing steps; the SAME issue back to `ReadyToImplement`.
   **Needs the owner's hands** → a line on the owner-sitting issue (or `needs-human`); stays `ReadyToVerify` with a
   pointer.
