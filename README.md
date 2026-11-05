# claude-playbook — how we work with AI

An opinionated way of working with Claude Code, distilled from ten months of daily use across a dozen repos (an
agent-built C++ engine, a multi-device terminal manager, a photo library, games, tools). Every rule has a scar behind
it; `docs/` holds the stories and the numbers.

## The laws

1. **A green build is not a working feature.** Done means observed working on the real host, through the user's path.
2. **Never self-verify.** Every producing phase has a checking phase, done by someone else.
3. **A test must be able to fail.** See it red, or mutate the code and watch it go red.
4. **Measure, don't theorise.** An unmeasured cause is a question. "Flaky" is not a diagnosis.
5. **Issues are the source of truth.** Labels are an API. Closed is done, with Root cause / Fix / Verified.
6. **Memory lives in the repo.** Commit it and load it.
7. **Keep going.** Finish the lifecycle. Ask decisions last, one at a time, as buttons.
8. **One copy of every fact.**

## Install

```bash
git clone https://github.com/pauliver/claude-playbook.git ~/Projects/claude-playbook
```

```bash
cd ~/Projects/claude-playbook && scripts/install-user-level.sh --dry-run
```

```bash
scripts/install-user-level.sh --with-guard
```

```bash
scripts/adopt-repo.sh ~/Projects/my-repo --dry-run
```

Then, in the repo, ask Claude to *"use the adopt-playbook skill"*: it audits what's there, asks what only you know
(north star, branch, push authority, areas) and fills in the rest. Nothing that differs is overwritten without
`--force`, and anything replaced is backed up.

## What's in it

| Part | Contents | Installs to |
| --- | --- | --- |
| `user-level/way-of-working.md` | The portable rules | `~/.claude/`, imported from `~/.claude/CLAUDE.md` |
| `user-level/agents/` | `producer` `implementer` `qa-verifier` `fresh-eyes-reviewer` `architect` `ops-director` | `~/.claude/agents/` |
| `user-level/skills/` | 19: `session-start` `wrap-up` `owner-question` `review-fresh-eyes` `fix-issue` `verify-independently` `plan-feature` `work-loop` `land-agent-work` `agent-forensics` `hostile-review` `audit-codebase` `health-check` `context-update` `harness-review` `wrong-output-debug` `consolidation-passes` `dev-like-a-user` `adopt-playbook` | `~/.claude/skills/` |
| `template/` | `CLAUDE.md`/`AGENTS.md` skeletons, seed memories, routing guide, personas, machine-guard hook, gate script, label setup, wrap-up check, issue templates | each repo, via `scripts/adopt-repo.sh` |
| `docs/` | The reasoning and the evidence | read here |
| `scripts/` | `install-user-level.sh` `adopt-repo.sh` `check-playbook.sh` | — |

This repo is the source; `~/.claude/` and each repo hold installs. Change a rule here, re-run the installer, and run
`scripts/check-playbook.sh` (links, frontmatter, script syntax, guard self-test) before committing.

## Read next

| Doc | What it covers |
| --- | --- |
| [`user-level/way-of-working.md`](user-level/way-of-working.md) | **The rules.** Short enough to load into every session |
| [`docs/sdlc-and-github.md`](docs/sdlc-and-github.md) | Issue lifecycle, labels as an API, closing, findings, decisions, branches |
| [`docs/producer-and-agents.md`](docs/producer-and-agents.md) | The Producer, roles, personas, the subagent brief, landing work, concurrency |
| [`docs/testing-philosophy.md`](docs/testing-philosophy.md) | Done means verified; tests that can fail; the gate; red, slow and flaky |
| [`docs/memory-and-docs.md`](docs/memory-and-docs.md) | In-repo memory, its format and hygiene, where each fact lives, handoffs |
| [`docs/working-with-the-owner.md`](docs/working-with-the-owner.md) | Autonomy, questions as buttons, reporting, wrap-up, the live system |
| [`docs/machine-safety.md`](docs/machine-safety.md) | Commands that freeze a whole machine, and the hook that blocks them |
| [`docs/observatory.md`](docs/observatory.md) | The terminal/fleet harness this runs in, and what a repo needs to join |
| [`docs/lessons-learned.md`](docs/lessons-learned.md) | Hard-won lessons, one line each |
| [`docs/history.md`](docs/history.md) | How it evolved, and what didn't survive |
