# How this evolved (March → November 2026)

~16,000 prompts across a dozen repos: process by hand → automate the harness → maximum parallelism → evidence →
encode it so the prompts get shorter.

| Phase | Months | Main repos | What changed |
| --- | --- | --- | --- |
| **1. Process by hand** | Mar | the oldest repo (an agent-built C++ engine), a helper-tools repo | Personas, skills, issue lock files, sibling "slot" clones, a Coordinator → **Producer** that only coordinates (top-level: nesting is one level deep). Many prompts were reminders: "don't forget to lock issues", "use the sdlc". The engine repo later moved to per-agent git with PRs and a worktree slot pool; its scars (fabricated test claims, silent idles, an issue closed before its PR merged) are why "the main session pushes and closes". |
| **2. The harness** | Apr | an agent-harness repo, a QA-agent repo | Merge only after an independent GO. Implementer, reviewer and verifier became distinct identities. Model tiering; local models vs Claude per role. First overnight runs. |
| **3. Maximum parallelism** | May (~3,700 prompts) | a game-engine repo, the helper repo, Observatory begins | Agent teams, hostile multi-persona reviews, "ultrathink" on ~15% of prompts, device relaunch loops. |
| **4. Evidence** | Jun–Sep | Observatory, a photo-library app, a second-brain/notes repo, a game repo | Real-device verification, `/loop` "until done", the review prompt (×45) and wrap-up checklist (×44). The Overseer nudges toward evidence. Subagents for side quests and "prove me wrong"; one agent per box at high usage. |
| **5. Encoded** | Oct–Nov | a disk-space tool, a party game | Fewer, shorter, decision-centred sessions. Questions as buttons became standard. A new repo gets the whole layer on day one, copied from the game repo and Observatory. |

## What the data says about encoding

- Process reminders ("file an issue", "lock it", "use the SDLC") were constant in March–April and **almost vanished
  once they lived in skills and CLAUDE.md.**
- The prompts still retyped were the unencoded ones — wrap-up, post-work review, questions-as-buttons. They're skills now.
- Median prompt length fell from ~67 characters to 43–50: the owner says less because the layer says more.

## What did not survive

- **Issue lock files and emoji states** → a claim comment, the Stage label, one writer per area.
- **Branch-per-issue + PRs + LFS** → direct-to-working-branch with an honest gate in most repos. The exception is the
  oldest repo, whose merge gate must build the PR head on the *other* OS; its costs (62 dead branches pruned to 5,
  14 leaked worktrees, ~136 GB of slot builds, squash merges breaking `git log`) are why others chose otherwise. Choose
  per repo and write it in CLAUDE.md.
- **A `stage:*` label set** → the CamelCase set the board renders.
- **"Optimize the docs for weaker agents"** → "gates first". A check beats a paragraph.
- **CI on GitHub Actions** → deleted: the jobs had never once been scheduled, and gave false confidence.
- **Many subagents by default** → inline by default ("they keep stalling out").
- **Memories at user level** → moved into each repo.

## Still open

- Repos restate the same process text and it drifts; this playbook and `way-of-working.md` exist to fix that.
- Prose rules that should be mechanical: closing keywords (a commit-msg hook), `git add -A` and kill-by-name (a
  PreToolUse guard), label drift (a label lint).
