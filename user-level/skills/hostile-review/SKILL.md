---
name: hostile-review
description: Brutal multi-expert review of a file, module or range — 3–4 x-* personas attack in parallel (≥5 defects each); findings deduped, spot-checked, challenged by an independent verifier; SHIP / SHIP WITH FIXES / DO NOT SHIP. Use before shipping critical, lifecycle- or concurrency-heavy code. Repo's own wins.
---

# hostile-review

Why: 33 green headless tests once missed 3 critical lifecycle bugs that only this review caught.

1. **Target:** a file (+ header/test), a range (`git diff`), or a module (files + hot paths), plus the design doc
   stating its intent.
2. **3–4 personas** matching the risk (performance, architecture/API, concurrency/netcode, UX, data, security, QA
   adversary); **state the roster and why.** Unregistered `.claude/agents/x-*` → `general-purpose` with "Read
   `.claude/agents/<x>.md` and act as that persona".
3. **Spawn all in one message.** Brief: read-only, target, intent, "Find **at least 5 concrete defects**; can't find
   5? Read it again." Each finding: file + symbol, defect, **why it bites** (scenario), fix. Include performance,
   correctness, architecture, maintainability and **test accommodation** (production code that exists only for a
   test). Backgrounded → SendMessage to main.
4. **Synthesize:** dedupe; rank P0 crash/data/security · P1 perf/correctness under real conditions · P2 architecture
   smell · P3 style. Record dissent; adjudicate with reasons.
5. **Spot-check** the top P0/P1 file:lines yourself; an **independent verifier** gets only claims + code paths and
   tries to refute each P1+.
6. **Write up** (`DesignDoc/HostileReview-<target>-<date>.md` or `.claude/notes/`): verdict, findings with raised-by,
   P0/P1 detail, dissent, CLEAN areas. Unresolved P0 → **DO NOT SHIP**.
7. **Route:** P0/P1 onto owning issues. Fix P1/P2 test-first; P3s in one comment (a behaviour-changing P3 needs a
   feature's gate). Never edit design/status docs from a review.
