---
name: Work item
about: A bug, feature or chore. One lane of work, verifiable by someone who did not build it.
labels: []
---

<!--
One label per axis (docs/issue-labels.md — boards read the names; never invent one):
  Stage: DesignDoc | DesignReview | ReadyToImplement | ReadyToVerify      Type: bug | enhancement | chore | epic | security | documentation
  Area:  area:<one>                                                        Priority (rare): north-star
Under ~1h, one file, known cause: skip DesignDoc and write "FastTrack: <reason>" below.
-->

## What and why
<!-- From the USER's point of view. Numbers if you have them, and how they were measured. -->

## Evidence
<!-- Logs, screenshots, the command and its output. Tag each claim MEASURED or REASONED. -->

## Done when
- [ ] A test that fails without the fix: `<test name>`
- [ ] The gate is green (`scripts/run-full-tests.sh`), quoted with host + OS
- [ ] Verify: <exact steps on a real host / device / user path, and the number to read>

## Docs to read / update

## Out of scope
<!-- What NOT to touch; files another lane owns. -->
