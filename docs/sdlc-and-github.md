# The SDLC on GitHub — why it looks like this

Rules: [`way-of-working.md`](../user-level/way-of-working.md) §3–4. Labels: [`template/docs/issue-labels.md`](../template/docs/issue-labels.md).

## The lifecycle

```
(none) ──triage──▶ DesignDoc ──build units──▶ ReadyToImplement ──landed, gate green──▶ ReadyToVerify ──verified──▶ CLOSED
                       │                           ▲      │                                   │
                       └─▶ DesignReview ──D<n>─────┘      └── FastTrack (<1h, one file, known cause) skips DesignDoc
                                                                        failed verify ◀───────┘ (same issue goes back)
```

Every producing phase has a checking phase: design → design review, implement → review, test → test validation.

Entry/exit criteria and time-boxes per stage: the table in `issue-labels.md`.

## Why this strict

- Issues, not memory or chat, hold the roadmap: they're visible from every machine and to the board.
- One repo (2026-10): filing outran closing by **+96 in six weeks**, `DesignDoc` sat a median **18 days**, and **77**
  issues closed still labelled `ReadyToImplement` — the board was wrong the whole time they were open.
- Another filed 181 and closed 73 in four weeks; *findings go on the issue that owns their class* took it from
  **104 to 29** open. In the first repo, 10% of new issues were review follow-ups (4% elsewhere).
- A sibling closes **61%** of issues the same day via FastTrack.

## Labels are an API

- Observatory's board reads label **names** from `gh`, and its Overseer creates `ReadyToImplement` and `auto-filed`.
  A rename breaks a board on another machine.
- Skills were found applying `P0`, `Feature`, `NeedsArchitectReview` — labels that exist nowhere. Check `gh label list`.
- Two taxonomies ran for 12 days and contradicted each other; the one with a consumer (the board) won. A label nobody
  renders is rot.
- Create the set with `template/scripts/setup-labels.sh` (never renames or deletes).

## Closing keywords

GitHub's parser closed issues five times on "not half-fixed: #352", "rather than fixes #352" and "This does not close
#528". Auto-close also skips verification. Write "issue N"; close by hand with the proof comment.

## Findings and backlog

- An issue that collects every new finding in its class never closes — split on a real boundary (shipped /
  blocked-on-decision / needs another contract), not on length.
- Bots don't file until proven: a dispatch bot misfiled 6 of 6.
- If the last 7 days filed more than they closed, the session is a burn-down.

## Decisions

Beyond the `D<n>` log, keep a "point of no return" list: what is crossed and not to be reopened.

## Branches and pushing

Per repo, in its CLAUDE.md. Patterns that work:
- **Direct to the working branch, push on green** — only with a gate proving the pushed tree was tested (one repo's
  pre-push hook compares a green run's content key with the pushed tree).
- **Three tiers:** `Next` (every green unit), `main` (owner promotes), `ReleaseCandidate-*` (owner cuts). A
  `Next`–`main` gap is health, not drift.
- **Nothing parked in branches or worktrees** — "branches are how we lose work". PRs plus a worktree pool: see
  [history](history.md).
