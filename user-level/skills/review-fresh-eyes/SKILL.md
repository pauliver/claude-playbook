---
name: review-fresh-eyes
description: Adversarial review of the work JUST done (session diff, range, working tree) by fresh-eyes agents per slice — provenance scan, findings verified by executing something, fixes test-first, MEASURED/REASONED report with a CLEAN list. Use for "review what we just did", "double-check it", before a deploy. Repo's own wins.
---

# review-fresh-eyes

Self-review in the same context is biased; the fan-out is the point. Measured: per-change review caught four defects in
seven commits, two of which would have shipped a feature **100% broken while looking healthy** — all by running
something, none by reading.

## 0. Provenance — first, for code from a subagent, worktree or patch (~30 s)
Grep the diff for `lock (new `, `if (true)`, `if (false)`, `&& false`, `|| true`, commented-out
`return`/`throw`/`await`, empty `catch {}`, `Skip =`, `.only(`, `TimeSpan.Zero`, `int.MaxValue`; then **read every
removed (`-`) line** — a deleted guard is invisible to a scan of added text.

## 1. Scope
Default `<base>..HEAD`, base = the commit before the session's first change (`git merge-base` with the working branch);
or the user's range, or `git diff`. List changed **non-test** files with line deltas; tests are coverage evidence.

## 2. Fan out
- Proportionate: a 3-file fix → **one** reviewer; a feature + hardening → **2–3**. More is noise.
- One `fresh-eyes-reviewer` per subsystem slice (or `general-purpose` told to read
  `~/.claude/agents/fresh-eyes-reviewer.md` and act as it), **all in one message**.
- Brief: range, sha, files, "review ONLY these + their immediate call paths", the invariant each change relies on (for
  a feature, its worst failure — "can it ever fire the destructive action wrongly?"), the lens list below, and the
  contract: findings with scenario, severity, MEASURED/REASONED, plus a CLEAN list.
- **Get the report back:** `run_in_background: false`, or end the brief with *"Deliver your report with SendMessage to
  main — your plain final text reaches nobody."* A reviewer that returns nothing is **NO review**.
- Reviewers test only their affected project in their own worktree; **you** run the full gate once, serially, in the
  main tree.

## 3. Verify and fix
1. **Verify every finding** in the code; discard false positives with the reason. Settle code-reading hypotheses by
   executing something (test, mutation, repro).
2. **Fix confirmed ones test-first** (repro red, minimal in-idiom fix, green). A conscious trade-off gets a code comment
   if it would stop a future wrong "fix".
3. **Gate.** Run mutations under the full lane, not an isolated filter (timing-dependent tests behave differently
   under load).
4. **Commit and push per the repo's rules.** Not fixing now → a checklist line on the issue owning its class.

## 4. Report
Confirmed findings (severity, fix status, sha) · declined ones with the reason · test gaps filled · every finding
**MEASURED or REASONED**, kept so in the retelling · **"Checked and found CLEAN"**: each lens and how · which
reviewers returned, by name (a missing one = slice unreviewed) · nothing survived → say so plainly.

## Lens list
The `fresh-eyes-reviewer` hunt list (correctness · races · leaks · unbounded growth · hot-path rescans · blocking calls
· missing coverage · security/trust · error handling · **wired-but-dead** · **inert lane** · **decorative tests** ·
**checkable claims**), plus **north-star divergence**, duplicate owners of one behaviour, and **unknown rendered as
zero**.
