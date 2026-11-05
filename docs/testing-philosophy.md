# Testing philosophy — the evidence

Rules: [`way-of-working.md`](../user-level/way-of-working.md) §1–2. Gate skeleton:
[`template/scripts/run-full-tests.sh`](../template/scripts/run-full-tests.sh).

## 1. A green build is not a working feature

The most expensive trust failure across every repo:
- A relay transport was "built, wired and two-OS green" while **every production dial failed** — its five dial-site
  tests fabricated the record they checked.
- Every layer of a photo app was green while every filter chip in the UI was inert. Layer tests don't compose into
  workflow truth.
- A game repo counted ~25 "it may not have worked" corrections before the rule became law.
- 35 Rust tests and 100 of 524 Dart "passes" early-returned on a missing fixture and printed ok. A missing real-host
  fixture is now a FAIL when the gate asks for real-host tests.

## 2. A test must be able to fail

- **Mutation is the test of a test.** Record it in the commit ("removed the cap reset → 2 fail / 33; restored →
  green"); hash the file to prove it applied, or a no-op mutation reads like a surviving mutant.
- **Decorative tests are worse than none** — they read as coverage: an assertion over a possibly-empty list; an
  expected value computed by the code under test; an input that never reaches its branch; a PASS that is an absence.
- **A source-scan guard pins a spelling, never a value** — pair it with a behavioural test.
- **Try to fool a new gate before trusting it:** six defects in one night, five inside the new gates.

## 3. The gate

- **One command for everything:** one repo's documented test commands silently ran 0 of 2,600 tests in its second
  solution. The fix was to stop documenting raw commands as the gate.
- **SUMMARY last, also in a git-ignored `*-last.log`** — one block for an agent or someone on a phone. One gate per
  machine (a lock that refuses, not queues).
- **Tiers** where the full gate is long: the fast tier prints what it skips; the full gate runs on named triggers (a
  release, ~25 closed issues, a change that touches everything). "A green fast tier is a statement about your edit;
  a green gate is a statement about the tree."
- **TIER 0 ratchets:** seconds-long scripts, each born from a paid-for mistake (silent skips, `?? 0`, unread toolchain
  pins, rotted doc claims), each with a self-test negative control.
- **No CI** by decision — so a green gate is one OS's verdict. A macOS-green epic hit **11 failures** on its first
  Windows run, five waves in.
- **Detached long gates:** a terminal relaunch killed a background task 58 minutes in.

## 4. Red, slow and flaky

- "Passes alone" is weak: re-run under deliberate saturation a dozen times and count. A timing assertion that only
  passes on a calm box is not passing. "Pre-existing" needs a baseline run on the parent sha.
- **Slow is a defect** — the owner's line: "If any test or script goes over 30 we need to dig in."

## 5. Measure, don't theorise

In one repo, every causal hypothesis asserted without measurement over two days was wrong. So: a cause is a question
until measured; name the competing explanation and the measurement that separates them; cross-check numbers against a
fact the tool didn't produce; measure the thing, not its proxy; tag MEASURED vs REASONED; stamp re-measurable numbers `(measured <sha>, <date>, <OS>)` once.

## 6. Regressions

- Keep a **last-known-good sha per subsystem**; `git diff <lkg>` before live debugging — six build cycles were lost
  to one added call the diff found in seconds.
- A regression fix ships a **class guard**: a repro through the real path, a guard for the class, a mutation proving
  what it catches.
- Number incidents (symptom, LKG, breaking change, diagnosing command, root cause, fix, lesson). A "consider adding X"
  line is a task — file it.

## 7. Design for testability

Every capability is a library with its own headless tests; the app is a thin wiring shell; I/O sits behind seams with
recorded fixtures; unit and integration are separate lanes; untrusted parsers are quarantined and fail loudly on
unknown formats.
