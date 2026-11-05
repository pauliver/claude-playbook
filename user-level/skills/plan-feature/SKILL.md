---
name: plan-feature
description: Turn a feature or vague goal into a design doc plus ordered GitHub issues, each sized for one agent lane with Done-when, Verify, docs and dependencies — never code. Use for "plan this", "break this down", "how should we build X", or anything over ~a day. Repo's own wins.
---

# plan-feature

1. **State the user-facing experience** in 1–2 sentences. Too vague → 2–3 questions via `owner-question`; owner away →
   write your best reading and mark it.
2. **Survey:** design docs, decision log (reuse; never silently contradict), memory, issues/epics already owning part
   of it (`gh issue list --search`).
3. **Map the modules.** Crossing a module boundary or a load-bearing contract (public interface, schema/ABI/wire
   format, persistence, trust boundary, anything destructive) → `architect`.
4. **Design doc** (`DesignDoc/` or `design/`), decision-dense: problem (user's view, which part of the north star);
   architecture (owner module, public surface, dependency impact, failure modes); **phases, each shippable and
   testable alone**; tunables and where they live; risks; rejected alternatives; open owner questions.
5. **File issues** in dependency order (parallel `gh` calls where independent). Each:
   - Stage `ReadyToImplement` (or `DesignDoc`/`DesignReview`), one Type, one `area:*`.
   - **What and why** (user's view, numbers) · **Done when** (failing-first test, gate, user-visible check) ·
     **Verify:** (exact real-host check, the number to read) · **Docs to read/update** · **Out of scope** ·
     `blocked-by #N`.
   - **One lane** (one agent, one sitting); split cross-file wiring — oversized issues produce nothing.
   - Several → an `epic` checklist (`- [ ] #N`) that closes when empty.
6. **Mark the critical path** and what can run in parallel (disjoint files).
7. **Report:** doc path, epic, ordered issue numbers (only ones `gh` returned), what's parallel, what needs the owner.

Only labels that exist (`gh label list`) — never `P0`, `Feature`, `NeedsArchitectReview`; the board reads names.
