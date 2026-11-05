# Skill template

```markdown
---
name: <REPO>-<VERB-NOUN>
description: <What it does, one or two sentences.> Use when <trigger phrases people actually type, e.g.
  "deploy to the tablet", "/<REPO>-deploy">. <When NOT to use it, and what to use instead.>
---

# <NAME>

> **Bootstrap:** read `CLAUDE.md` and <THE ONE OR TWO DOCS THIS SKILL DEPENDS ON>. <HARD RULES, e.g. "never push",
> "main session only", "owner approves first — it spends money".>

## Docs
- FOLLOW: <DOCS WHOSE RULES THIS SKILL OBEYS>
- UPDATE: <DOCS THIS SKILL KEEPS CURRENT, or "none">

## Steps
1. <Concrete, checkable step: the command, what to read in its output, what counts as success.>
2. <…  A step with a scar says so in one line: "(2026-11-02: a merge was pushed with gate exit 1 on screen.)">

## Success criteria
<What observably proves the skill did its job. Required.>

## Scope & non-goals
<What it does NOT do, and which skill does. Required.>

## Input contract            <!-- only for skills dispatched to agents -->
<What the dispatcher must supply; if missing, return DECISION_NEEDED — don't guess.>

## Ambiguity protocol        <!-- only for skills dispatched to agents -->
<When to stop and ask vs. proceed with a stated assumption.>

## Output
<Exactly what the final report contains — numbers, shas read from git, what was NOT done.>
```

Rules of thumb:
- **Right-size, then enforce:** Success criteria and Scope always; Input contract and Ambiguity protocol only for
  agent-dispatched skills. (Requiring all four everywhere hit 97% non-compliance.)
- The description is a routing hint: when to use it, in the words people type. No ` #` in an unquoted description.
- One skill, one job.
- Counts live in the file that derives them, not in the skill (restated counts drift).
- Use only labels that exist.
- A missing primitive (bounded wait, status probe) goes in `scripts/` with a header, a timeout and an exit-code
  contract; the skill calls it.
