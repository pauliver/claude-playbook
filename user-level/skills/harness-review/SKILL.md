---
name: harness-review
description: Review an agent harness, eval or LLM pipeline assuming the model is competent and the HARNESS is the suspect — turn endings, invisible caps, prompt bytes, tool seams, retries, the grader's false PASSes, exit codes. Use when a model "fails", before trusting an eval number, or after changing a runner/grader.
---

# harness-review

**The harness is the suspect** — a harness defect and a model deficiency produce the same FAIL row. For every finding
ask: *if the harness were perfect, would this number differ?*

0. **Freeze:** read-only, no rebuilds mid-run. Start from the worst real failures: could a competent model get here?
1. **Every way a turn ENDS** (return, break, throw, cap): reachable by a competent model? Finished work discarded?
   Can the grader tell it from giving up? Running out of rounds must never look like finishing.
2. **Invisible caps:** for each (rounds, tokens, time, tool calls), is the model told it exists, its value, and what to
   do near it?
3. **Read the assembled prompt bytes** at the failing size: what's cut, is truncation marked, do instructions conflict,
   does it promise tools that don't exist?
4. **Seams:** tool descriptions match behaviour; a failed tool ≠ an empty result; truncation says so and offers a
   handle; errors say what to do differently.
5. **Retries:** one that changes nothing is a replay; recovery must keep gathered context.
6. **Audit the grader harder than the model.** Map each task's intent to the line that scores it; hunt the **false
   PASS** first. Denylists can't express structural rules; dormant fields wake when the grade mode changes. Classify
   rows pass / model / engine / harness and drop engine/harness rows from the denominator. Ground truth is a claim;
   keep the answer key outside every read root. Grade the intent, not its proxy.
7. **Exit codes propagate** through the driver; reporting never destroys a measurement.
8. **Confounds go in the results file. Hunt inversions mechanically** — a stronger arm failing where a weaker passed
   is a harness smell until proven otherwise.
8b. **Superpowers:** what could the harness give the model (perception, reach, memory, a HUD of its budget)? Caps per
   profile; report which bind.
9. **Review the FIXES:** a guard that can't fire reads like a fix — assert the recovery HAPPENED. A metric that can't
   be false is worse than none. New budgets must compose with existing timeouts (grep them).
10. **Transcripts written synchronously and durably** — a crash must not lose the evidence.
11. **Read the words,** weighted to PASSES (where false passes live). Beware fixtures pinned to a constant the code
    also uses.

**Write-up:** severity = damage to measurement integrity (CRITICAL = wrong numbers someone will act on). Each finding:
file + symbol, a scenario where a competent model loses, a fix sketch; say what's safe. A defect no step caught
becomes a new step here.
