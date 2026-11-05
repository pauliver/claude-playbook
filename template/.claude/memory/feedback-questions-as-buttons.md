---
name: feedback-questions-as-buttons
description: Owner decisions are asked one at a time — 1–2 paragraphs from the user's view, then buttons with the recommended option first — and recorded as numbered decisions
metadata:
  type: feedback
---

Ask the owner **one question at a time** (skill `owner-question`): 1–2 paragraphs from the user's view (use,
architecture, performance/cost), then **buttons**, each option 1–2 sentences, **recommended first, marked "(Rec.)"**.

**Why:** the owner asked for exactly this and may read on a phone, so a question must stand alone on screen. Batches
of four were tried first and replaced.

**How to apply:** grep the decision log first — never re-ask. Ask LAST, after all work that doesn't depend on the
answer. Record each answer at once as `D<n>` with the owner's words and the date. Subagents never ask; they list
open questions in their report.
