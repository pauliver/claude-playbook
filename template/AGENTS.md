# AGENTS.md — <PROJECT NAME>

For any AI coding agent (Claude Code reads `CLAUDE.md` first; others start here).

1. Read `CLAUDE.md`: rules, gate, branch, map.
2. Before dispatching or acting as a subagent: `.claude/howtowork.md`.
3. Labels and lifecycle: `docs/issue-labels.md`. Never invent or rename a label.
4. Gate: `bash scripts/run-full-tests.sh`. Green is not working — verify on the real host.
5. Only the session that owns the working branch pushes, closes issues or verifies — never your own work.

Per-folder `AGENTS.md` files (≲150 lines) hold that folder's case law: what owns what, the traps, the tests.
