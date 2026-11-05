---
name: health-check
description: Fast read-only repo scorecard — "is this repo in good shape right now?" Scores Git, Build/Test, Process layer and Issues (25 each) into HEALTHY / NEEDS ATTENTION / CRITICAL with ranked actions. Use at session start on an unfamiliar repo, before a release, or "how are we doing". Repo's own wins.
---

# health-check

Read-only; probes in parallel; one screen. **Points only for checks you ran and passed.**

| Area (25 each) | Checks |
| --- | --- |
| Git | tree clean · on the working branch, synced · nothing unpushed > 1 day · no stray worktrees, stashes, merged-but-undeleted branches (local + origin) · no large blobs/build output tracked · `.gitignore` covers `*-last.log`, `.claude/settings.local.json`, `.claude/.observatory-hooks.jsonl`, build dirs |
| Build & test | latest `*-last.log` recent and green (sha, host, OS) · no new warnings vs baseline · no zero-test lane · skips named. Fast tier only if cheap; never a gate beside another |
| Process layer | `CLAUDE.md` current (spot-check 5 paths/commands) and < ~40 KB · `MEMORY.md` loaded, entries resolve, < ~200 lines · `.claude/settings.json` committed · referenced skills/agents exist · no rule stated twice with different answers |
| Issues | labels match `docs/issue-labels.md` and the fleet set · every open issue has a Stage · nothing parked in `Verified` · no `ReadyToVerify` > 1 week without a comment · filed vs closed, 7 days · north-star ≤ ~15 |

**Verdict:** HEALTHY ≥ 85 · NEEDS ATTENTION 60–84 · CRITICAL < 60. A P0-class problem (work at risk unpushed, secrets
tracked, gate red on main, no remote) forces CRITICAL. Per area: ✅ ≥ 80% · ⚠️ 40–79% · ❌ < 40%. Then **Issues
found**, ranked: severity + the one action that fixes each.
