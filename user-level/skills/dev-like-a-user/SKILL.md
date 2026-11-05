---
name: dev-like-a-user
description: Product-first polish loop — feature checklist with before-screenshots, study comparable products, audit the real product as a user, file issues by domain then dedupe, fix with use-test checkpoints, re-audit. Use for "make it feel like a real product", polish passes, "use it like a user and fix what's wrong".
---

# dev-like-a-user

1. **Vision:** a Spec issue with the **feature checklist** (what a user must observably be able to do) and
   before-screenshots.
2. **Research** 3–5 comparable products: what users now expect. Note, don't copy.
3. **Audit** the real product through the user's path on the real device: each checklist line working / rough /
   broken, with screenshots you looked at.
4. **Issues:** generate in parallel by domain (UX, correctness, performance, content…), then **dedupe serially** onto
   one owner per class.
5. **Fix loop** (`fix-issue` → `verify-independently`) with checkpoints: every **5** fixes a use-test walking the
   checklist (before → after); every **10** "what did the agent do by hand that a tool could do?" → tool issues;
   every **20** performance proposals.
6. **Re-audit;** report the before/after table, ending with what needs the owner's eyes and hands —
   engineering-green is not "good".
