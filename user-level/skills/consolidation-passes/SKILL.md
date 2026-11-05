---
name: consolidation-passes
description: Refactor or de-duplicate working code in bounded passes — audit the copies, extract ONE shared component per pass, review by another agent, independent gate, land before the next pass. Use for "collapse these N copies", "two systems own one behaviour", large refactors of working code.
---

# consolidation-passes

Refactor working code only to remove a real defect class (two owners of one behaviour is the commonest).

1. **Audit** (read-only): every copy, where they diverge, which callers use which, which is most correct. Pick the
   survivor; file an epic, one line per pass.
2. **One pass = ONE extraction** (or ONE set of callers moved to the survivor), call sites migrated in the same pass.
   Behaviour unchanged — characterization tests first if coverage is thin.
3. **Review by another agent** (`fresh-eyes-reviewer`), hunting lost guards: a merged validator keeps the union of the
   happy paths and the *intersection* of the guards.
4. **Independent gate**, run by the coordinator, not the implementer.
5. **Accept only on** reviewer PASS + green gate + commit landed; then the next pass.
6. **Stop rule:** a pass that would ADD a bespoke system → STOP and re-plan.
7. **Migrate before delete:** remove the old copy only once every caller is migrated and verified.
