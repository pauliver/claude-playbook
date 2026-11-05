---
name: audit-codebase
description: Opt-in, heavy whole-codebase audit — read-only lanes per subsystem and lens in capped batches, every blocker/major verified by executing something, one ranked report filed onto owning issues. For "audit everything", "full audit". Recent diff → review-fresh-eyes. Repo's own wins.
---

# audit-codebase

## 0. Before
- Owner opted in? It costs hundreds of thousands of tokens; not at ~90% weekly usage.
- Record the **audited sha** (detached worktree, clean status).
- Every lane gets **KNOWN AND INTENTIONAL — do not report** (decision log, rejected findings, documented trade-offs)
  and **CONTESTED — re-derive**. Not re-deriving is the biggest token saving.

## 1. Lanes — READ-ONLY (no commits, pushes, issues or shared-tree builds; own scratch prefix)
- **Subsystem:** one per module / `area:*`.
- **Lens:** correctness · concurrency · leaks/unbounded growth · hot paths · blocking I/O · security/trust · error
  handling · wired-but-dead · inert lanes · decorative tests · doc/comment claims · duplicate owners ·
  unknown-as-zero · north-star divergence · toolchain pins · test-suite honesty (skips, zero-test lanes,
  fixture-absent "passes").
- **Persona (optional):** an `x-*` per domain.

## 2. Batches
4–5 lanes, wait, next (survives rate limits). A Workflow script (`batchSize`, resume) only if the owner opted into
workflows; else the Agent tool. Roll call by name — a dead lane is unaudited, not clean.

## 3. Verify
- Each **blocker/major** → a skeptic told to **refute** it, given only the claim and code path. It survives only if
  reproduced (test, mutation, measurement).
- Two lanes finding one defect independently is the strongest signal.
- Spot-check every cited file:line — agents hallucinate them.

## 4. Synthesize
- Dedupe; rank P0 (data loss, security, crash, wrong numbers someone acts on) → P3.
- Report in the repo (`.claude/notes/<date>-audit.md` or `DesignDoc/Audit-<date>/`): findings (id, severity, file +
  symbol, scenario, MEASURED/REASONED, raising lanes), dissent, **checked-and-CLEAN** per lens, what was NOT covered.
- P0/P1 → checklist lines on owning issues (new only if unowned) + one umbrella issue. Never edit design/status docs
  from an audit.
- Fixes come afterwards, test-first, as normal lanes.
