# Repo-specific skills

Generic skills (`wrap-up`, `fix-issue`, `review-fresh-eyes`, …) are user-level. Add one HERE only when it carries this
repo's knowledge, prefixed with the repo name so it can't collide (e.g. `<REPO>-deploy-device`).

Good candidates:
- `<REPO>-check` — what "green" must include beyond the gate (e.g. frozen-version replays byte-identical).
- `<REPO>-deploy-<DEVICE>` — build signed, install, launch, move issues to ReadyToVerify with what to check.
- `<REPO>-release` — the one release command, its version scheme, when the owner must approve.
- `<REPO>-work-review` — the generic review plus THIS repo's paid-for defect classes (the most valuable kind).
- `<SYMPTOM>-playbook` — symptom-indexed: mechanism, discriminating check, fix, and a RULED-OUT list.

Shape: `docs/skill-template.md`. When a session's steps drift from the skill, fix the skill in that session.
