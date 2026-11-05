# Observatory — the harness around all of this

Observatory is the owner's own (private) tool for using Claude from any device. This page says what it provides, so
the rest of the playbook makes sense, and what a repo needs to take part. Everything else works without it.

## What it does

| Piece | What it gives you |
| --- | --- |
| **TT** (Terminal Tray) | a per-machine daemon that hosts the terminals Claude Code sessions run in |
| **TM** (Terminal Manager) | one client (desktop, tablet, phone) showing every session as a card — Running, Idle, Waiting-on-decision, API error, Subagents running — fanned out to every device like tmux multi-attach |
| **Remote decisions** | question menus, plan approvals and permission prompts become tappable cards |
| **Auto-resume** | after usage-limit resets, API overloads and dropped connections |
| **Remote exec** | runs allow-listed commands (e.g. the gate) in a repo on another paired machine |
| **The Overseer** | watches sessions, nudges stalled ones with phase-gate questions ("You said done — what evidence shows each exit criterion is met?"), answers routine push/fix asks from precedent (never promotion, deletes or relaunches), files `auto-filed` issues |
| **Fleet board** | issues as lanes by Stage label, chips for `size/*`, `URGENT`, `Blocked`/`Suspended`, `Tested*`; plus rows from each repo's `MEMORY.md` |

## What a repo needs to take part

1. **Exact label names** (`template/scripts/setup-labels.sh`) — the board reads names.
2. **`.claude/memory/MEMORY.md`** committed at that path, one line per memory.
3. **One gate script** (`scripts/run-full-tests.sh`, plus `.cmd` on Windows) writing `run-full-tests-last.log`, so
   remote exec can allow-list it.
4. **Gitignore** `.claude/settings.local.json` and `.claude/.observatory-hooks.jsonl` (the TT writes hooks into both).
5. **Long jobs detached** (`nohup` + sentinel line): a TT relaunch kills everything a session owns.

## What it changed about how we work

- Questions are stand-alone buttons, because they're answered on a phone.
- "Never sweep `$HOME`": the terminal is shared, so one wedged `find` froze it on every device for ~15 minutes.
- The Overseer's nudges are the SDLC's phase gates said aloud: "is it all on github?", "anything to commit?".
- Push and fix asks are effectively always "yes" — don't end a turn asking them.

Without Observatory, skip the hooks and the board; keep the labels, the gate script and committed memory anyway.
