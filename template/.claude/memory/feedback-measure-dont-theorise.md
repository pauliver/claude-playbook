---
name: feedback-measure-dont-theorise
description: An unmeasured cause is a question, not a finding — measure before asserting, name the competing explanation, and say NOT DIAGNOSED rather than guess; "flaky" is never a diagnosis
metadata:
  type: feedback
---

State a hypothesis as a question until measured; name the competing explanation and the measurement that separates
them, or say **NOT DIAGNOSED**. Never write an unmeasured cause into a commit or issue. "Flaky" is not a diagnosis.

**Why:** in one two-day stretch every unmeasured causal claim was wrong; a mount probe documented as "tens of
seconds" actually wedged a terminal for fifteen minutes.

**How to apply:** check runaway processes, CPU, load and backups before blaming the code. Tag findings MEASURED or
REASONED. Cross-check numbers against a fact the tool didn't produce. Measure the thing, not its proxy.
