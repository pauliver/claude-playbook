---
name: owner-question
description: Ask the owner one open decision in their format (one at a time, user's point of view, buttons, recommended first), then record it as a numbered decision. Main session only — subagents list questions in their report. Use for user-visible behaviour, scope, cost, rules, architecture, anything irreversible.
---

# owner-question

Each question must stand alone — the owner may be reading it on a phone.

1. **One at a time:** ask, record, then the next (batches of 4 were tried and dropped).
2. **Frame it in 1–2 paragraphs from the USER's view**, with numbers: **use** (what they experience),
   **architecture** (briefly), **performance/cost** (time, compute, tokens, money, risk).
3. **Buttons** (AskUserQuestion): 2–4 options, each 1–2 sentences on user and cost impact; **recommended first, label
   ending "(Rec.)"**. Grep the decision log first — cite an existing answer instead of asking.
4. **Record immediately:**
   - Decision log (e.g. `design/<ver>/00-decisions.md`, `DesignDoc/decisions.md`, or the issue):
     `| D<n> | title | decision | why + options considered | Owner, <date> |` — a number outside agents' reserved
     ranges; annotate (never delete) what it supersedes; quote the owner's reason verbatim.
   - Issue `DesignReview` → `ReadyToImplement`; drop `needs-decision`/`Blocked`.
   - Generalises beyond this feature → a `feedback-*` memory in the repo.
   - Commit (push if the repo's rules say so).
5. **Tell running agents** whose work it changes (`SendMessage`).

**Agents never ask the owner:** a subagent stops at the decision and lists it in its report (question, options,
recommendation); the main session asks.
