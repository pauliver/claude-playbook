---
name: wrong-output-debug
description: Root-cause a WRONG value (colour, image, number, layout, black screen, off count) with four laws against false confirmation — ground truth first, whole region, multiple runs, one symptom can have two owners. Use for "it renders wrong", "the number is off", "it shows black". Repo's own symptom playbook first.
---

# wrong-output-debug

Before touching code, write in the issue:
```
OBSERVED: <what it produces, measured — the real buffer/value, not a description>
EXPECTED: <what it should produce, derived from the source — show the arithmetic>
```

## The four laws
1. **Ground truth BEFORE hypothesis:** derive EXPECTED from the source (decode the texture to its on-screen colour;
   count the raw rows). A hypothesis formed first will find support.
2. **Whole region, never filtered to expectation** — an agent sampled only dark pixels and "confirmed" a dark road
   that was 98% washed white.
3. **Multiple runs for races:** ≥3; ANY bad run is a failure.
4. **One symptom can have two owners:** after a fix helps, re-measure against EXPECTED.

## Also
- **A verdict names a symptom, not a cause** ("BLACK_SCREEN" was once a menu composited on top): pull the real buffer
  (a ~90 KB PNG is not pure black), then rule out causes one class at a time.
- Compare against known-bad baselines too; time-box blind visual debugging, then instrument (way-of-working §2, §7).
- Track a revert-to-isolate on the issue — one was never re-applied.
- Record RULED-OUT causes so nobody re-proposes them.
