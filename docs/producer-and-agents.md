# The Producer, its agents, and personas

Rules: [`way-of-working.md`](../user-level/way-of-working.md) §5. Agents: [`user-level/agents/`](../user-level/agents/).
Routing template: [`template/.claude/howtowork.md`](../template/.claude/howtowork.md).

## The shape

```
                       main session = PRODUCER        ← triage · decompose · route · gate · land · push
                     (never implements; the only one that pushes, closes issues, moves labels)
          ┌──────────────┬──────────────┼───────────────┬──────────────────┐
     implementer    qa-verifier   fresh-eyes-reviewer   architect      x-* personas
     (one lane,     (independent,  (one slice,         (risky designs) (expert lenses:
      commits by     never the      read-only,                           design & review only)
      pathspec)      implementer)   reviewed_sha)
```

It began as a coordinator-only rule in the oldest repo. The owner: "it should never be a sub-agent, it should
always be the one I work with directly". The main session plays Producer and spawns the `producer` agent for big triage.

| Agent | Does | Never |
| --- | --- | --- |
| `producer` | triage, one-lane issues with Done-when + Verify, route, brief, gate risky changes | implement |
| `implementer` | one issue: test-first, gate, negative proof, pathspec commit, report | push, close, verify itself |
| `qa-verifier` | criterion-by-criterion verification, drives-production proof, verdict comment | verify its own work; commit |
| `fresh-eyes-reviewer` | read-only review of one slice at a sha; MEASURED/REASONED; CLEAN list | commit, file issues |
| `architect` | design docs, risky-change review, hard block vs recommendation | implement |
| `ops-director` | keep CLAUDE.md, memory, skills, agents, labels honest | edit product code; destroy unreported |
| `x-*` personas | expert lenses for design and hostile review | implement |

## Personas

Lenses modeled on a real practitioner's work or a role. Sections: deliverables grant (docs and issues, never product
code), bootstrap, lens, "On <repo>", optimizes for, pushes back on, doesn't do (naming the neighbouring persona),
output format. Template: [`template/docs/persona-template.md`](../template/docs/persona-template.md); examples
`template/.claude/agents/x-perf.md`, `x-systems.md`, `x-ux.md`.
- **Route them, don't trim them:** an audit of 30 agents found only 6 ever spawned — never routed, not dead. Keep
  descriptions ~220 chars and trigger-shaped.
- Personas need Write for their reports, so "read-only" lives in the brief.
- Not registered this session? Paste the body into a `general-purpose` agent.
- Park them in `.claude/agents-parked/` — `.claude/agents/` is scanned recursively.

## The brief — the evidence behind each line

1. **"DO NOT PUSH" first:** an implementer pushed after its own suite passed; a QA agent read "pushes only on your
   PASS" as an instruction, pushed three commits and closed the issue.
2. **What not to re-derive:** 7 of the 15 most expensive turns in one corpus were agent re-entries (~0.5M tokens
   each), mostly rework.
3. **Worktree base check:** `isolation: "worktree"` cuts from `origin/HEAD` — measured 169, 270 and 735 commits behind
   the working branch. Two agents sharing a scratch dir overwrote each other's script. Heredocs, `$VAR`, `cd … &&`
   and subshells drew 879 refused commands across 95 of 137 worktree subagents.
4. **Reporting contract:** two backgrounded reviewers over a diff with two real defects went idle with no report,
   which read as a clean bill of health. An agent once reported five shas that didn't exist.

## Landing (`land-agent-work`)

- Provenance scan: two of five harvested patches in one day carried a mutation left in mid-test (`lock (new object())`).
- Gate on a clean checkout — an agent's uncommitted edits make the gate lie both ways.
- Push conditionally on the gate's exit code in the same command: a merge was once pushed with `gate exit 1` just above.

## Concurrency and cost

- Five agents each running the full suite: 341 build processes, load 140 on 16 cores, every timing garbage.
- Lanes split by file ownership: 24 commits from 4 agents, zero conflicts — yet semantic conflicts still need one
  reviewer over the integrated range.
- A subagent costs ~40k tokens of context before it reads a file — hence inline by default.
- Teams for breadth ("have someone re-implement it without looking at ours"); subagents for side quests and
  adversarial "prove me wrong" checks.
- Bare model aliases in agent files: dated pins rot into spawn failures for a whole fleet.
