# CLAUDE.md — <PROJECT NAME>

<!-- Keep this SHORT: rules every session needs, plus pointers. The general way of working is loaded from
     ~/.claude/way-of-working.md — record only where THIS repo differs or adds. Rewrite stale lines; never append
     "STATUS: actually…". -->

<ONE PARAGRAPH: what this is, who it's for, stack, platforms. Status in one line, dated.>

**North star:** "<ONE SENTENCE, IN THE OWNER'S WORDS>" — see `docs/issue-labels.md` §north-star.

## Rules for working in this repo

1. **Memory lives in the repo:** `.claude/memory/` (index `MEMORY.md`, loaded below), one fact per file, committed.
2. **Branch and push:** work lands on `<main|Next>`. <KEEP ONE, DELETE THE OTHER:>
   - *Standing authorization:* a gate-green unit of work IS the authorization to commit and push to `<BRANCH>`.
     Promotion to `<main>` and releases stay the owner's call.
   - *Push when told:* commit freely; push only when the owner asks.
3. **The gate is `scripts/run-full-tests.sh`** — the only verdict. Quote its SUMMARY (host + OS) when claiming green.
4. **Issues on `<OWNER/REPO>` are the source of truth.** Labels: `docs/issue-labels.md` — never rename or invent one.
5. **Before dispatching a subagent,** read `.claude/howtowork.md`.
6. **<REPO-SPECIFIC INVARIANT, e.g. "never edit a frozen version", "the delete path needs human confirmation">.**

## Common commands

```bash
<BUILD COMMAND>
<FAST TEST LANE — iteration only>
bash scripts/run-full-tests.sh        # THE gate
bash scripts/wrap-up-check.sh         # are we done for now?
```

## Where things are

| Path | What |
| --- | --- |
| `docs/` | Process docs: `issue-labels.md`, testing, … |
| `DesignDoc/` | Design source of truth; decision log `DesignDoc/decisions.md` (D1…) |
| `.claude/` | Memory, agents, skills, routing (`howtowork.md`), hooks, plans |
| `scripts/` | The gate, label setup, wrap-up check |

## Never commit

Secrets, tokens, `.env`, signing keys, personal data, logs, build output, `.claude/settings.local.json`,
`.claude/.observatory-hooks.jsonl`.

@.claude/memory/MEMORY.md
