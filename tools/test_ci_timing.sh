#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# SYNC-ID: ci_timing_auto_improvement_plan
# Runtime evidence for tools/lib/ci_timing.sh, tools/ci-timing,
# tools/check_ci_status.sh, .github/workflows/ci.yml,
# tools/check_ci_workflow_structure.sh, and tools/test_ci_timing.sh.
# Related tests include tools/test_ci_timing.sh,
# tools/test_ci_pipeline_acceleration.sh, and
# tools/check_as_built_sync_contract.sh.

TEST_REPO="$TMP_DIR/repo"
TIMING_DIR="$TMP_DIR/timing"
mkdir -p "$TEST_REPO"
git -C "$TEST_REPO" init -q
git -C "$TEST_REPO" config user.name "CI Timing Test"
git -C "$TEST_REPO" config user.email "ci-timing@example.com"
printf 'input\n' >"$TEST_REPO/input.txt"
git -C "$TEST_REPO" add input.txt
git -C "$TEST_REPO" commit -q -m "Initial timing fixture"

run_timing() {
  LESSON_ROOT="$TEST_REPO" \
  CI_TIMING_DIR="$TIMING_DIR" \
  CI_EVIDENCE_RUN_ID="${TEST_RUN_ID:-timing-run-1}" \
  GITHUB_WORKFLOW="Timing Test" \
  GITHUB_JOB="${TEST_JOB_ID:-aggregate-and-full-hooks}" \
  "$ROOT/tools/ci-timing" "$@"
}

run_timing status | grep 'Status: not-initialized' >/dev/null
run_timing run aggregate_fixture \
  --display-name "Aggregate Fixture" \
  --command-id "aggregate-fixture-v1" \
  --mode aggregate \
  --evidence used \
  --inputs input.txt \
  -- bash -c 'exit 0'

report="$TIMING_DIR/ci-timing.tsv"
[[ -f "$report" ]]
grep -F $'check_id	display_name	command_id	mode	start_epoch' "$report" >/dev/null
grep -F 'aggregate_fixture' "$report" >/dev/null
grep -F 'Aggregate Fixture' "$report" >/dev/null
grep -F 'aggregate-fixture-v1' "$report" >/dev/null
grep -F 'Timing Test' "$report" >/dev/null
grep -F 'aggregate-and-full-hooks' "$report" >/dev/null

if run_timing run failing_fixture --command-id failing-v1 --inputs input.txt -- bash -c 'exit 7'; then
  printf 'ci-timing run swallowed a failing command\n' >&2
  exit 1
fi
set +e
run_timing run failing_status_fixture --command-id failing-status-v1 --inputs input.txt -- bash -c 'exit 7' >/dev/null
status="$?"
set -e
if [[ "$status" != "7" ]]; then
  printf 'ci-timing run did not preserve wrapped failure status: %s\n' "$status" >&2
  exit 1
fi
grep -F 'failing_fixture' "$report" >/dev/null
awk -F '\t' '$1 == "failing_fixture" && $8 == "7" { found = 1 } END { exit found ? 0 : 1 }' "$report"

custom_report="$TMP_DIR/custom-report.tsv"
LESSON_ROOT="$TEST_REPO" \
CI_TIMING_DIR="$TIMING_DIR" \
CI_TIMING_REPORT="$custom_report" \
CI_EVIDENCE_RUN_ID="timing-run-report-leak" \
GITHUB_WORKFLOW="Timing Test" \
GITHUB_JOB="aggregate-and-full-hooks" \
"$ROOT/tools/ci-timing" run report_scope_fixture \
  --display-name "Report Scope Fixture" \
  --command-id "report-scope-fixture-v1" \
  --mode aggregate \
  --inputs input.txt \
  -- bash -c '[[ -z "${CI_TIMING_REPORT:-}" ]]'
[[ -f "$custom_report" ]]
grep -F 'report_scope_fixture' "$custom_report" >/dev/null

run_timing run evidence_fixture \
  --display-name "Evidence Fixture" \
  --command-id "evidence-fixture-v1" \
  --mode aggregate \
  --inputs input.txt \
  -- bash -c 'exit 0'

proposal_output="$(run_timing propose --input "$report" --slow-threshold 0)"
grep -F 'CI timing improvement proposals' <<<"$proposal_output" >/dev/null
grep -F 'slow-check: aggregate_fixture' <<<"$proposal_output" >/dev/null
grep -F 'developer approval is required' <<<"$proposal_output" >/dev/null

missing_output="$(run_timing propose --input "$report" --slow-threshold 999999)"
grep -F 'evidence-candidate: evidence_fixture' <<<"$missing_output" >/dev/null

BROKEN_REPORT="$TMP_DIR/broken-report.tsv"
printf 'bad-header\n' >"$BROKEN_REPORT"
if run_timing propose --input "$BROKEN_REPORT" >/dev/null 2>&1; then
  printf 'malformed timing header was accepted\n' >&2
  exit 1
fi

head -n 1 "$report" >"$BROKEN_REPORT"
printf 'broken\tBroken\tbroken-v1\taggregate\t1\t2\tbad\t0\t%s\t%s\t%s\t%s\tnone\tTiming Test\taggregate-and-full-hooks\ttiming-run-1\t%s\t2026-06-01T00:00:00Z\n' \
  "$(printf 'a%.0s' {1..64})" \
  "$(printf 'b%.0s' {1..64})" \
  "$(printf 'c%.0s' {1..64})" \
  "$(printf 'd%.0s' {1..64})" \
  "$(git -C "$TEST_REPO" rev-parse HEAD)" >>"$BROKEN_REPORT"
if run_timing propose --input "$BROKEN_REPORT" >/dev/null 2>&1; then
  printf 'malformed timing numeric field was accepted\n' >&2
  exit 1
fi

BROKEN_DIR="$TMP_DIR/broken-timing"
mkdir -p "$BROKEN_DIR"
printf 'not marked\n' >"$BROKEN_DIR/file.txt"
if LESSON_ROOT="$TEST_REPO" CI_TIMING_DIR="$BROKEN_DIR" "$ROOT/tools/ci-timing" run broken -- bash -c 'exit 0' >/dev/null 2>&1; then
  printf 'unmarked non-empty timing directory was accepted\n' >&2
  exit 1
fi
set +e
LESSON_ROOT="$TEST_REPO" CI_TIMING_DIR="$BROKEN_DIR" "$ROOT/tools/ci-timing" run broken-failure -- bash -c 'exit 7' >/dev/null 2>&1
status="$?"
set -e
if [[ "$status" != "7" ]]; then
  printf 'ci-timing did not preserve wrapped failure status when timing write failed: %s\n' "$status" >&2
  exit 1
fi

printf 'CI timing tests passed.\n'
