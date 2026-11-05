# How to work in this repo: agents, personas, skills

*Read before dispatching any subagent. General rules (brief format, never self-verify, concurrency):
`~/.claude/way-of-working.md` §5. This file is the routing for THIS repo.*

- **Workers do the work:** one lane each, commit their own files by pathspec, **never push**.
- **Personas (`x-*`) advise:** design docs, critiques, issues — **never product code**. Say "read-only" in the brief.

| Agent | Lane | Model |
| --- | --- | --- |
| `producer` or `<REPO>-producer` | Big/vague work: triage, split into issues, route, brief. Never implements | opus |
| `implementer` or `<REPO>-<AREA>-programmer` | One issue-sized lane: test-first, gate, pathspec commit | opus |
| `qa-verifier` or `<REPO>-qa` | **Independent verification — never the agent that built it** | sonnet |
| `fresh-eyes-reviewer` | One diff slice, read-only, returns `reviewed_sha` | opus |
| `architect` | Risky design review; design docs | opus |
| `ops-director` | The `.claude` layer, labels, workspace hygiene | sonnet |
| `x-<EXPERT>` (`.claude/agents/`) | <DOMAIN LENS, e.g. performance / UX / netcode> | opus |

Unprefixed agents are user-level. **Agent types load at session start:** if one is missing from the Agent tool, use
`general-purpose` with the model above and brief line 1: *"Read `.claude/agents/<name>.md` (or
`~/.claude/agents/<name>.md`) and act as that agent."* For skills: *"Follow `<path>/SKILL.md`."*

## Routing
| Job | Who | Then |
| --- | --- | --- |
| New idea, milestone, "what's next?" | `producer` (`plan-feature`) | workers |
| A bug or feature issue | `implementer` (`fix-issue`) | `qa-verifier`, then `land-agent-work` |
| Crosses modules / touches a contract | `architect` first | workers |
| Something users touch | a UX persona reviews | `qa-verifier`, then the device check |
| Review what just changed | `review-fresh-eyes` | fix test-first |
| An open decision | `owner-question` — **main session only** | record the D-number |
| Repo-wide search | `Explore` | — |
| Research (prior art, APIs) | `general-purpose` with web tools | an issue or a doc |

## Repo-specific brief additions
- Gate: `<COMMAND>`; what "green" must include here.
- Single-lane files: `<e.g. the decision log, the app shell>`.
- Decision numbers: reserve a range per agent (e.g. "D200–D219 only") so parallel work can't collide.
- Device/host rules: `<e.g. only the main session installs on the owner's device>`.
