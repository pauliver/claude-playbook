# Issue labels

> **Labels are an API.** A board (Observatory's, or any tool reading `gh`) renders lanes by label **name**; renaming
> one or inventing a near-duplicate (`stage:ready`, `todo`) silently drops cards into `Unlabeled`. **Never rename or
> invent a Stage, Type, Priority or modifier label.** Create them with `scripts/setup-labels.sh` (never renames or
> deletes).

## Four axes, at most one label from each

| Axis | Labels | Rule |
| --- | --- | --- |
| **Stage** | `DesignDoc` `DesignReview` `ReadyToImplement` `ReadyToTest` `ReadyToVerify` `Verified` | One, or none (= untriaged) |
| **Type** | `bug` `enhancement` `chore` `epic` `security` `documentation` | One. Boards show the first match in this order, so an `epic` never also carries `enhancement` |
| **Area** | `area:<name>` — this repo's list, below | One. Local; boards ignore it |
| **Priority** | `north-star` | Optional, rare, has a test (below) |

**Modifiers, only when true:**
- `Blocked` + its reason: `needs-decision` (an open owner call — not one a recorded decision answers) or
  `needs-hardware` (no simulator, sandbox copy or fixture can show it).
- `auto-filed` — filed by an automated agent.
- `before-public-release` — a gate, not a stage: everything that must happen before the repo's visibility changes.

**Board chips** — `URGENT`, `Suspended`, `TestedMac`/`TestediOS`/`TestedWindows`, `wontfix` — are externally read.
Leave them alone.

## Closed is done

Don't park issues in `Verified`; close the same day the check passes, with exactly:

```
Root cause: <one or two sentences — the mechanism, not the symptom>
Fix: <sha(s)>
Verified: <how, where (host/device/OS), and the NUMBERS you read>
```

A failed verification sends the **same** issue back to `ReadyToImplement`.

## Stages

| Stage | Enter when | Leave when | Time-box |
| --- | --- | --- | --- |
| *(none)* | just filed | filer sets Type + Stage + Area | same session |
| `DesignDoc` | real work, fix **not** yet known | doc lists build units, each naming its failing test → `ReadyToImplement`; or close as not planned | ~2 working days, one review round |
| `DesignReview` | only an owner decision is missing | decision recorded as `D<n>` → `ReadyToImplement` | ~1 day |
| `ReadyToImplement` | fix known and agreed, sized for **one** agent lane | landed, test seen failing first, gate green → `ReadyToVerify` | ≤3 lanes at once |
| `ReadyToTest` | *optional* separate test lane | independent tester signs off → `ReadyToVerify` | — |
| `ReadyToVerify` | committed and deployed, **not yet verified on a real host/device** | verifier runs the `Verify:` line, posts numbers, closes | ~24 h |

- **FastTrack:** under ~1 h, one file, known cause → skip `DesignDoc`; write `FastTrack: <reason>` in the body.
- **Owner-only checks** (device in hand, real account, destructive real-host action) collect as lines on **one**
  owner-sitting issue in `ReadyToVerify`.
- **The label moves when the work moves**, by the session doing it — one audit found a third of a month's closed
  issues still labelled `ReadyToImplement`.

## `north-star`

This project's north star, in the owner's words:

> *"<THE ONE SENTENCE>"*

Apply only if the issue stands between the project and that sentence. Past ~15 open, it has stopped discriminating:
re-cut it.

## Findings go to their owner

A finding you won't fix now goes onto the **existing issue that owns its class**, as a checklist line. Open a new
issue only when nobody owns the class. Watch filed-vs-closed per week; a backlog that only grows is a signal.

## This repo's areas

| Label | Covers |
| --- | --- |
| `area:<NAME>` | <WHAT> |
