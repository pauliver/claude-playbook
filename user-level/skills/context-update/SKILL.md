---
name: context-update
description: Refresh a repo's AI layer (CLAUDE.md, AGENTS.md, memory, skills, agents, labels doc) — recon for drift, mine transcripts for recurring errors, rewrite at the claims, prove it with cold-boot probes. Use after a new agent, 5+ new skills, a process change, ~50 closed issues, or "update memories and CLAUDE.md".
---

# context-update

## 1. Recon (read-only, parallel)
2–4 read-only agents (or `ops-director`): CLAUDE.md + AGENTS.md · memory + index · skills + agents · labels doc vs
`gh label list`. Each returns a **TOP-10 ranked by how badly a weaker agent would be misled**: missing paths,
hardcoded counts, contradictions, future systems in present tense, retired workflows, nonexistent labels applied,
memories that disagree.

## 1b. Transcript forensics (optional, high value)
Mine `~/.claude/projects/<repo-dir>/*.jsonl` for recurring errors: edit-before-read after compaction, guessed paths or
names, sleep-polls, refused commands, repeated owner corrections. A missing guard becomes a hook, script or check, not
prose.

## 2. Sweep
- **Critical drift is a rewrite, not a patch** — a weaker model follows the body, not a note under it.
- One owner per rule; delete second copies of counts and point at what derives them.
- **Never remove a load-bearing rule in a cleanup** — find its scar first.
- CLAUDE.md holds what every session needs; area detail goes to per-area indexes; AGENTS.md ≲ 150 lines.
- Memory hygiene per way-of-working §6: frontmatter, every file indexed, superseded → `_deprecated/` with a reason,
  machine-local project memories moved in, index under ~200 lines.
- Scripted replacements must be idempotent; grep afterwards for inverted meanings.

## 3. Prove it
2–3 **cold-boot probes on `haiku`** with realistic prompts ("You're asked to fix issue N: produce your plan and the
files you'd read first. Do NOT write code."). Did the layer route them to the right docs, skills, gate and branch?
Each wrong turn marks the next fix.

## 3b. Enforcement audit
- Walk the issue lifecycle: does each step have a mechanism (does close refuse without proof)? Do `.sh`/`.cmd` twins
  enforce the same gates (one `.cmd` twin lacked the Verified gate)? Is every "never" in CLAUDE.md backed by a hook,
  check or test?
- Measure each agent's always-on context; cut the biggest.
- **Philosophy over mechanics:** a pass of only path/count fixes probably missed the testing standards, evidence rules
  and trust hierarchies sessions keep re-deriving. "The skill tells agents WHAT to do; the memory tells them WHY and
  WHEN to deviate."
- Migrate before delete. Re-run any pass whose inputs changed.

## 4. Land
Pathspec commits (docs-only: no build), push per the repo's rules, comment on the tracking issue with what changed and
what the probes showed.
