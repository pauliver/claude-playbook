---
name: feedback-verify-on-the-real-host
description: A green build is not a working feature — done means observed on the real host/device through the user's path; report "verified by <method>" or "NOT yet verified"
metadata:
  type: feedback
---

**A green build proves the tree, not the product.** Observe the user's real path at least once (a screenshot you
looked at, a state dump, a log line, a number) and report **"verified by <method>"** or **"NOT yet verified — needs
<X>"**. Committed but unverified = `ReadyToVerify`.

**Why:** the most common trust failure — ~25 "it may not have worked" corrections in one repo; one feature was "built,
wired and two-OS green" while every production call failed.

**How to apply:** `ok: true` isn't proof — compare before and after. A deploy is proved by a new capability, not a
version string. Manufacture the event (simulator, sandbox copy, second instance). A different agent signs off.
