#!/usr/bin/env bash
# =====================================================================================================================
#  run-full-tests.sh — THE gate: one command, every OS, the only verdict a commit is judged by.
#
#  Fill in STEPS for your stack. Keep the rest; each piece was paid for:
#   * ONE command covering every lane — hand-run "documented commands" once missed 2,600 tests.
#   * SUMMARY prints LAST and goes to run-full-tests-last.log (git-ignore it): one block to read, not scrollback.
#   * Each lane reports its counts; total=0 is a FAILURE (an empty lane silently stopped running).
#   * One run per machine (a lock): concurrent gates make both verdicts and all timings meaningless.
#   * If you dogfood from the tree, build outside its bin/obj — never rewrite a running binary under its own mmap.
#
#  Usage: scripts/run-full-tests.sh [--fast]      (--fast: build + unit only, for iterating; NOT a commit verdict)
# =====================================================================================================================
set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 2

LOG="run-full-tests-last.log"
LOCK="${TMPDIR:-/tmp}/gate-$(basename "$PWD").lock"
FAST=0; [[ "${1:-}" == "--fast" ]] && FAST=1

# ---- STEPS: "name|command". Make each command print its own pass/fail counts so the log shows them. ----------
# Replace these with your stack. Keep them in the order a human would run them: build → unit → integration → others.
STEPS=(
  # An unconfigured gate must FAIL, never pass: a green verdict over nothing is the "confident zero" we keep paying for.
  "build|echo 'TODO: put your build command here (e.g. dotnet build src/App.sln -nodeReuse:false)'; exit 1"
  "unit|echo 'TODO: put your fast unit lane here (fakes, headless)'; exit 1"
  "integration|echo 'TODO: put your integration lane here (real sockets/files/devices)'; exit 1"
)
(( FAST )) && STEPS=("${STEPS[@]:0:2}")

# ---- lock: refuse, don't queue ------------------------------------------------------------------------------------
if ! mkdir "$LOCK" 2>/dev/null; then
  echo "gate: another gate is running on this machine ($LOCK). Refusing rather than queueing." >&2
  exit 3
fi
trap 'rmdir "$LOCK" 2>/dev/null' EXIT

sha="$(git rev-parse --short HEAD 2>/dev/null || echo no-commits)"; dirty=""; [[ -n "$(git status --porcelain)" ]] && dirty=" (+uncommitted)"
host="$(hostname -s)"; os="$(uname -s) $(uname -r)"
start=$(date +%s)
: > "$LOG"
summary=()
overall=PASS

for step in "${STEPS[@]}"; do
  name="${step%%|*}"; cmd="${step#*|}"
  echo "=== $name: $cmd" | tee -a "$LOG"
  t0=$(date +%s)
  bash -c "$cmd" >>"$LOG" 2>&1
  rc=$?
  dt=$(( $(date +%s) - t0 ))
  if (( rc == 0 )); then summary+=("$(printf '%-14s PASS  (%ss)' "$name" "$dt")")
  else summary+=("$(printf '%-14s FAIL  rc=%s (%ss)  — see %s' "$name" "$rc" "$dt" "$LOG")"); overall=FAIL; fi
done

{
  echo
  echo "================================ SUMMARY ================================"
  echo "commit: $sha$dirty   host: $host   os: $os   took: $(( $(date +%s) - start ))s"
  (( FAST )) && echo "MODE: --fast (unit only) — this is NOT a commit verdict"
  printf '%s\n' "${summary[@]}"
  echo "GATE: $overall"
  echo "Quote this block (with host + OS) when you claim green. A green gate proves the TREE, not the product."
} | tee -a "$LOG"

[[ "$overall" == PASS ]]
