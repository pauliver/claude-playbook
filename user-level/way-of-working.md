# The way of working — every repo, every machine

The portable rules for working with Claude. Each one has a scar behind it; the evidence is in the playbook's `docs/`.
**A repo's own `CLAUDE.md` wins where it is more specific** (branch, gate, areas). Source:
`claude-playbook/user-level/way-of-working.md` → installed as `~/.claude/way-of-working.md`.

## 0. The laws

1. **A green build is not a working feature.** Done = observed working on the real host, via the user's path. Say
   "verified by <method>" or "NOT yet verified".
2. **Never self-verify.** Every producing phase has a checking phase, done by someone else.
3. **A test must be able to fail.** See it red first. A PASS that is an absence must prove it looked.
4. **Measure, don't theorise.** An unmeasured cause is a question. Say NOT DIAGNOSED.
5. **Issues are the source of truth.** Labels move with the work; close with Root cause / Fix (sha) / Verified.
6. **Memory lives in the repo**, committed. Machine-local memory makes one machine right and the rest wrong.
7. **Keep going.** Stop only for an owner decision, a hard blocker, or something destructive. Context limits aren't one.
8. **One copy of every fact.** Point, don't restate.

## 1. Evidence

| Claim | Proof |
| --- | --- |
| builds / tests pass | the gate SUMMARY, with host + OS |
| works | an observation of the real path: a screenshot you *looked at*, a state dump, a number |
| deployed | a capability that didn't exist before — never a version string |
| N of M covered | the remainder, named |

- `ok: true` isn't proof the state changed — compare before/after. "Working" means the real use (gameplay, not the menu).
- Green gate = the **tree** is good; a live walk = the **product** works. Say which, and which OS.
- **Unknown is not zero** — render UNKNOWN, never `0` or "done".
- **No stubs or fakes** in committed code: implement, delete, or fail loudly.
- **Reproduce on current main first**; can't reproduce → close with the evidence.
- **Fresh binary or no claim:** built after the last commit, new tests listed by name from it. Zero tests = void.
- Rebuild from latest before showing the owner, or say "this is the OLD build".
- A missing deliverable is **FAIL**, never "PASS with a note".
- **Manufacture the event** (simulator, sandbox copy, second instance) — don't wait for it. Drive both ends yourself.
- Committed but not real-host verified = `ReadyToVerify`; the builder's session verifies within ~24 h. Owner-only
  checks go on ONE owner-sitting issue.

## 2. Testing

- **One gate, one command, every OS** (`scripts/run-full-tests.sh`). Every lane reports counts; SUMMARY last, in a
  git-ignored `*-last.log`. Raw test commands are for iterating — a subset of the gate is not the gate.
- **Green** = exit 0 + every expected test ran + skips didn't rise. Zero tests is a failure.
- **Red first;** record the negative proof in the commit ("mutation: X → 3 red; restored → green"), and prove the
  mutation applied.
- A red gate is a real defect. **"Flaky" is not a diagnosis** — name the mechanism or re-run under load and count.
- No test-only branches in production; inject environment through seams.
- **Gates over-flag** — a false alarm is fine, a false pass is not. Fix false reds; never loosen to silence noise.
  Suppressions need an issue and an expiry. Retries must report their count.
- Compare against known-**bad** baselines too. A verdict names a symptom, not a cause.
- Regression fix → a class guard, proven by mutation, through the user's real path.
- **Slow is a defect** — measure (runaway process? backup? load?) before blaming the code.
- Gate the **merged** tree; re-gate after every rebase; don't edit what a running gate builds.
- Long jobs: `nohup … ; echo EXIT=$? >> log`, wait on the sentinel. Never pipe a verdict into `tail`; gate the push on
  the verdict in the same command.
- Design for seams: no component needs the app to be testable; unit and integration lanes separate.
- No CI unless the repo says so. A green gate is one OS's verdict.

## 3. GitHub SDLC

- **Labels are an API** — Observatory's board reads the names. Never rename or invent; add only `area:*`. Full scheme:
  the repo's `docs/issue-labels.md`.
  - **Stage:** `DesignDoc` → `DesignReview` → `ReadyToImplement` → (`ReadyToTest`) → `ReadyToVerify` → closed.
  - **Type:** `bug` `enhancement` `chore` `epic` `security` `documentation` · **Area:** `area:*` · **Priority:** `north-star` (rare).
  - **Modifiers:** `Blocked` + `needs-decision`/`needs-hardware`, `needs-human`, `auto-filed`, `before-public-release`.
  - **Board chips, leave alone:** `URGENT` `Suspended` `Tested*` `size/*` `wontfix` (a repo may gate on `Tested*`).
- **Closed is done:** `Root cause / Fix: <sha> / Verified: <how, where, numbers>`. Failed verify → same issue back to
  `ReadyToImplement`. `Verified` is not a parking lot.
- The session doing the work moves the label, when it happens.
- **Issues are the work log:** search first; file before or as work starts; comment each landing with its sha.
  `gh issue view N` before acting on a number.
- **Findings:** fixed now → a commit; otherwise a checklist line on the issue that owns the class. Never a
  "follow-ups" issue. Watch filed vs closed weekly.
- `DesignDoc` only when the fix is unknown (~2-day box). `FastTrack: <reason>` for <1 h, one file, known cause.
- **Decisions** are `D<n>` in one log, owner's words + date. Grep it before asking.
- Plans: `.claude/plans/NNN-slug.md`, never overwritten. A multi-phase plan is also one tracking issue.

## 4. Git

- The repo's CLAUDE.md names the working branch and push authority. With standing authority, don't ask "push?".
  Without it: commit freely, push when told.
- **Nothing lives on one machine.** Push; no long-lived branches; merge lanes the same day; delete merged
  worktrees and branches.
- **Stage by name** — never `git add -A` / `commit -a` on a shared tree.
- **No closing keywords near `#N`** in commits or PR bodies, even negated. Write "issue N"; close with proof.
- **Clean ≠ destroy.** `git status` + `git stash list` before anything destructive. Prove a branch redundant by
  reverse-applying its patch on `origin/main` (squash merges make ancestry lie). `git ls-remote` is the truth about
  remote branches. Never drop a stash you didn't make; park WIP as a pushed commit, not a stash.
- Another AI tool's work: cherry-pick, never merge its branch.
- Commit subject = a claim; body = why, numbers, negative proof, gate line; Co-Authored-By trailer.
- Pull/rebase before a work block. Read shas from `git log`, never from an agent's prose. A rejected push → rebase,
  re-gate, push (not force).
- Prefer `gh` over raw git https. Prove a remote target before mutating it.

## 5. Agents

- **Inline by default.** Subagents (~40k tokens each) only for an independent build lane, an independent review, a
  sweep, or an adversarial "prove me wrong".
- **The Producer** triages, splits work into one-lane issues, routes, briefs and gates — it never implements, and it
  must be the **top-level** session (nesting is one level; a subagent Producer's dispatches silently fail). Never
  `/loop` an orchestrator. Its full protocol: `~/.claude/agents/producer.md`.
- **Roles:** `implementer` builds one lane · `qa-verifier` verifies (never the builder) · `fresh-eyes-reviewer` reviews
  a slice · `architect` reviews risky designs · `ops-director` keeps `.claude/` honest · `x-*` personas advise only.
- Agent types load at session start; otherwise use `general-purpose` + "Read `<agent file>` and act as that agent".
- **Every brief** opens with "DO NOT PUSH — EVER. Don't close, label or comment on issues. Commit only your own files
  by pathspec." It carries SUCCESS_CRITERIA (echoed back verbatim), scope and what not to re-derive, and the reporting
  contract (shas from `git log`; `success_criteria_met` with evidence; SendMessage if backgrounded). Template:
  `producer.md`. Worktrees are cut from `origin/HEAD`: push first and include a base-sha check.
- **Land** with `land-agent-work`: distrust the report, read the commits, re-derive risk from the changed paths, gate
  a clean checkout, push only what you verified.
- **A dead agent looks like a clean one.** Notifications aren't guaranteed: after ~20 min, check commits, output
  mtime and lock. A reviewer that returned nothing is no review. Stop finished agents at once.
- **Concurrency:** integration is serial; review parallelises. Width = min(RAM at ~8 GB/session, CPU). One build lane
  per box; split lanes by file ownership; verify a batch before dispatching the next. At ~90% weekly usage: one agent.
- **Models:** the heavier model decides, the lighter does. Bare aliases (`opus`/`sonnet`/`haiku`) — dated pins rot.
  Never silently fall back. LLM players/testers: the cheapest model that works, piloted for cost first.

## 6. Memory and docs

- `.claude/memory/<slug>.md`: one fact; frontmatter `name`, `description`, `metadata.type`; body = rule → **Why**
  (dated scar, numbers) → **How to apply**. Index `MEMORY.md`, one line each, **< ~22 KB** (the tail is cut past
  ~24 KB). Load it from CLAUDE.md (`@.claude/memory/MEMORY.md`) or symlink auto-memory to it.
- Write memories when learned. Machine-local memory holds only a pointer to the repo.
- **Correct a claim at the claim**, the same day — a note elsewhere decays like the doc. Archive superseded memories
  with a reason; migrate before deleting anything.
- **Memory isn't enforcement:** a rule broken twice becomes a check, hook or script.
- One home per fact: rules → CLAUDE.md (short) · process → `docs/` · state → one overwritten STATUS file · decisions
  → D-log · lessons → memory · findings → the owning issue. Numbers carry `(measured <sha>, <date>, <OS>)`, once.
- Handoffs go in the repo (`.claude/work/state-<date>.md`), never only in a conversation.

## 7. Working with the owner

- **Autonomy:** execute to the end of the plan. Don't ask the owner to do what a tool can; never end a turn on a step
  you could take; never defer to "a fresh session". Honor an explicit pause.
- **Ask decisions last**, one at a time, with `owner-question`: user's-view framing, buttons, recommended first.
  Record the D-number. It must read standalone on a phone.
- **Report:** red first; numbers with their derivation; MEASURED vs REASONED; tree vs product; what wasn't checked.
  "Unverified" beats a confident guess. A clean review is a valid result.
- No time estimates — talk scope, risk, order.
- Owner live and approved → be decisive. Machine-checkable work goes solo; eyes-only work (visuals, feel) is batched.
- **Anti-thrash:** 5+ reads with no action → say what you're looking for. 3 failed attempts → step back. Same bug 3+
  times → trace the whole pipeline. N bugs, one symptom → look for one root cause.
- Never document fiction: unbuilt is PLANNED.
- Don't add risk to working code without a visible gain; when fixing, do the real fix.
- **Wrap up** (`wrap-up`): pushed · memories saved · issues true · fresh-eyes review · nothing stray · nothing left running.
- Shut down what you launched; kill only PIDs you started; never type into a client the owner is using.
- A prompt typed twice belongs in a skill.

## 8. Shell and machine

- **Never walk `$HOME` or `/`** (find/du/grep -r/rg/Grep/Glob) — network mounts block unkillably; a timeout doesn't
  bound the syscall. Root at the project or `find -x`. No bare `df`, untargeted `lsof`, `sync`. Don't read
  cloud-synced files. (The machine-guard hook enforces this.)
- Bounded waits (~4 min) on a sentinel or PID; no sleep-polling, no `pgrep -f` loops. Re-attach, don't restart.
- Chain with `&&`; `set -o pipefail`; absolute paths for shadowed tools (`/usr/bin/log`).
- **Secrets never enter a repo, issue or prompt.** Hand `sudo`/TTY steps to the owner as exact commands.
- Irreplaceable data is never deleted, deduped or expired.

## 9. Installed skills and agents

**Skills:** `session-start` · `wrap-up` · `owner-question` · `land-agent-work` · `agent-forensics` ·
`review-fresh-eyes` · `audit-codebase` · `hostile-review` · `plan-feature` · `fix-issue` · `verify-independently` ·
`work-loop` · `health-check` · `context-update` · `harness-review` · `wrong-output-debug` · `consolidation-passes` ·
`dev-like-a-user` · `adopt-playbook`.
**Agents:** `producer` · `implementer` · `qa-verifier` · `fresh-eyes-reviewer` · `architect` · `ops-director`.
A repo's own skill or agent for the same job wins — it carries that repo's defect classes.
