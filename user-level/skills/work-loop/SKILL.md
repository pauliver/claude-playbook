---
name: work-loop
description: Autonomous loop over the issue board — resume unfinished work, verify ReadyToVerify, take the next unclaimed ReadyToImplement (north-star first) via fix-issue, get it independently verified, land it, repeat. Use with /loop or for "keep going until done", "work the board". Repo's own wins.
---

# work-loop

## Each iteration
1. **Boot:** `git fetch && git status` (another machine moved?); the in-flight file (`INFLIGHT.md`/`STATUS.md`) and
   memory index. **Resume in-progress work first;** never start on a dirty tree; re-attach to a long job you can't
   prove dead, never restart it.
2. **Finish before starting:** verify `ReadyToVerify` issues (`verify-independently`, different agent) and close them.
   Every wait is a verification slot.
3. **Select:** the issue named in the prompt, else the best unclaimed `ReadyToImplement` (north-star, then oldest),
   else a `DesignDoc` past its time-box. Read it fully; no plan and > half a day → `plan-feature`.
4. **Execute** with `fix-issue`.
5. **Verify** by a different agent (`verify-independently`); land it (`land-agent-work` if a subagent built it).
6. **Record:** memory (immediately), the issue comment, the in-flight file.
7. **One-line status:** what landed (sha, issue), what's next.

## Pacing
Short waits (~60–120 s) on a sentinel or notification while anything is in flight — never sleep-polls or
cache-warming waits. Retry API overload with backoff and a heartbeat; the owner is not the watchdog.

## Stop only when
- The owner's queue is empty → hand over what needs a human (play-tests, device checks, decisions).
- An owner decision blocks everything left (`owner-question`, after all independent work).
- Something destructive or irreversible is next.
- The owner said pause.

Context limits are not a stop (way-of-working law 7).

## Graceful pause
Commit green halves (pathspec, no sweeping WIP commit), put the rest in the in-flight file, update memory, comment
each touched issue with its next step, run `wrap-up`.
