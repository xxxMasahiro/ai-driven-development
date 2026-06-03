#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

assert_contains() {
  local haystack="$1"
  local needle="$2"
  if [[ "$haystack" != *"$needle"* ]]; then
    printf 'Expected output to contain: %s\n' "$needle" >&2
    printf 'Actual output:\n%s\n' "$haystack" >&2
    exit 1
  fi
}

assert_fails_with() {
  local expected="$1"
  shift
  local output status
  set +e
  output="$("$@" 2>&1)"
  status=$?
  set -e
  if [[ "$status" -eq 0 ]]; then
    printf 'Expected command to fail, but it succeeded: %s\n' "$*" >&2
    exit 1
  fi
  assert_contains "$output" "$expected"
}

write_fixture() {
  local fixture="$1"
  mkdir -p "$fixture/docs/as-built" "$fixture/docs/workflow" "$fixture/tools" "$fixture/.githooks" "$fixture/.github/workflows"

cat >"$fixture/docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv" <<'EOF'
# sync_id	status	title	required_artifacts	required_tests	required_docs	runtime_evidence
sample_sync	implemented	Sample sync	artifact-one.txt	tools/sample_test.sh	docs/as-built/REQUIREMENTS.md,docs/as-built/SPECIFICATION.md,docs/as-built/IMPLEMENTATION_PLAN.md,docs/workflow/TASK_TRACKER.md,docs/workflow/HANDOFF.md	tools/test_lesson_repository.sh,.githooks/pre-commit,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
planned_sync	planned	Planned sync	none	none	docs/as-built/REQUIREMENTS.md,docs/as-built/SPECIFICATION.md,docs/as-built/IMPLEMENTATION_PLAN.md,docs/workflow/TASK_TRACKER.md,docs/workflow/HANDOFF.md	docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv
EOF

cat >"$fixture/docs/workflow/GIT_HOOKS_POLICY.tsv" <<'EOF'
# key	allowed_values	default_value	label	description
hook_mode	full|fast|minimal	fast	Git hooks mode	Test policy.
EOF

  touch "$fixture/artifact-one.txt"
  cat >"$fixture/tools/sample_test.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'sample test passed\n'
EOF
  chmod +x "$fixture/tools/sample_test.sh"

  for file in \
    docs/as-built/REQUIREMENTS.md \
    docs/as-built/SPECIFICATION.md \
    docs/as-built/IMPLEMENTATION_PLAN.md \
    docs/workflow/TASK_TRACKER.md \
    docs/workflow/HANDOFF.md
  do
    cat >"$fixture/$file" <<'EOF'
# Fixture

## As-Built Sync Contract Records

```text
SYNC-ID: sample_sync
STATUS: implemented
ARTIFACTS: artifact-one.txt
TESTS: tools/sample_test.sh

SYNC-ID: planned_sync
STATUS: planned
ARTIFACTS: none
TESTS: none
```
EOF
  done

  printf './tools/sample_test.sh\n' >"$fixture/tools/test_lesson_repository.sh"
  printf './tools/sample_test.sh\n' >"$fixture/.githooks/pre-commit"
  printf './tools/sample_test.sh\n' >"$fixture/.github/workflows/ci.yml"
  printf './tools/sample_test.sh\n' >"$fixture/.github/workflows/lesson14-ci.yml"
}

copy_fixture() {
  local source="$1"
  local target="$2"
  mkdir -p "$target"
  cp -a "$source/." "$target/"
}

run_check() {
  local fixture="$1"
  AS_BUILT_SYNC_ROOT="$fixture" AS_BUILT_SYNC_CONTRACT_FILE="$fixture/docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv" "$ROOT/tools/check_as_built_sync_contract.sh"
}

BASE="$TMP_DIR/base"
write_fixture "$BASE"

run_check "$BASE" >/dev/null
status_output="$(AS_BUILT_SYNC_ROOT="$BASE" AS_BUILT_SYNC_CONTRACT_FILE="$BASE/docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv" "$ROOT/tools/as-built-sync" status)"
assert_contains "$status_output" "SYNC-ID: sample_sync"
assert_contains "$status_output" "Document blocks: 5/5 present"
assert_contains "$status_output" "Active test wiring: 4/4 present"
assert_contains "$status_output" "SYNC-ID: planned_sync"
assert_contains "$status_output" "Artifacts: 0/0 present"
assert_contains "$status_output" "Tests: 0/0 present"
assert_contains "$status_output" "Active test wiring: 0/0 present"
assert_contains "$status_output" "As-built sync contract check passed."

RUNNER_WIRING="$TMP_DIR/runner-wiring"
copy_fixture "$BASE" "$RUNNER_WIRING"
cat >"$RUNNER_WIRING/.githooks/pre-commit" <<'EOF'
./tools/git-hooks run
EOF
cat >"$RUNNER_WIRING/docs/workflow/GIT_HOOK_CHECKS.tsv" <<'EOF'
# check_id	modes	command	description
sample_test	full|fast	./tools/sample_test.sh	Sample test.
EOF
run_check "$RUNNER_WIRING" >/dev/null
runner_status_output="$(AS_BUILT_SYNC_ROOT="$RUNNER_WIRING" AS_BUILT_SYNC_CONTRACT_FILE="$RUNNER_WIRING/docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv" "$ROOT/tools/as-built-sync" status)"
assert_contains "$runner_status_output" "Active test wiring: 4/4 present"

RUNNER_FULL_ONLY="$TMP_DIR/runner-full-only"
copy_fixture "$RUNNER_WIRING" "$RUNNER_FULL_ONLY"
cat >"$RUNNER_FULL_ONLY/docs/workflow/GIT_HOOK_CHECKS.tsv" <<'EOF'
# check_id	modes	command	description
sample_test	full	./tools/sample_test.sh	Full-only sample test.
EOF
assert_fails_with "missing active test wiring for tools/sample_test.sh in .githooks/pre-commit" run_check "$RUNNER_FULL_ONLY"
full_only_status_output="$(AS_BUILT_SYNC_ROOT="$RUNNER_FULL_ONLY" AS_BUILT_SYNC_CONTRACT_FILE="$RUNNER_FULL_ONLY/docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv" "$ROOT/tools/as-built-sync" status 2>&1 || true)"
assert_contains "$full_only_status_output" "Active test wiring: 3/4 present"

RUNNER_POLICY_DEFAULT="$TMP_DIR/runner-policy-default"
copy_fixture "$RUNNER_FULL_ONLY" "$RUNNER_POLICY_DEFAULT"
sed -i 's/^hook_mode\tfull|fast|minimal\tfast\t/hook_mode\tfull|fast|minimal\tfull\t/' "$RUNNER_POLICY_DEFAULT/docs/workflow/GIT_HOOKS_POLICY.tsv"
run_check "$RUNNER_POLICY_DEFAULT" >/dev/null
policy_default_status_output="$(AS_BUILT_SYNC_ROOT="$RUNNER_POLICY_DEFAULT" AS_BUILT_SYNC_CONTRACT_FILE="$RUNNER_POLICY_DEFAULT/docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv" "$ROOT/tools/as-built-sync" status)"
assert_contains "$policy_default_status_output" "Active test wiring: 4/4 present"

RUNNER_TRAILING_INVALID="$TMP_DIR/runner-trailing-invalid"
copy_fixture "$RUNNER_WIRING" "$RUNNER_TRAILING_INVALID"
cat >"$RUNNER_TRAILING_INVALID/docs/workflow/GIT_HOOK_CHECKS.tsv" <<'EOF'
# check_id	modes	command	description
sample_test	fast|bogus	./tools/sample_test.sh	Trailing invalid mode must not count as active wiring.
EOF
assert_fails_with "missing active test wiring for tools/sample_test.sh in .githooks/pre-commit" run_check "$RUNNER_TRAILING_INVALID"
trailing_invalid_status_output="$(AS_BUILT_SYNC_ROOT="$RUNNER_TRAILING_INVALID" AS_BUILT_SYNC_CONTRACT_FILE="$RUNNER_TRAILING_INVALID/docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv" "$ROOT/tools/as-built-sync" status 2>&1 || true)"
assert_contains "$trailing_invalid_status_output" "Active test wiring: 3/4 present"

MISSING_BLOCK="$TMP_DIR/missing-block"
copy_fixture "$BASE" "$MISSING_BLOCK"
cat >"$MISSING_BLOCK/docs/workflow/HANDOFF.md" <<'EOF'
# Missing block
EOF
assert_fails_with "expected one SYNC-ID block for sample_sync" run_check "$MISSING_BLOCK"

MIXED_STATUS="$TMP_DIR/mixed-status"
copy_fixture "$BASE" "$MIXED_STATUS"
sed -i 's/^STATUS: implemented$/STATUS: planned/' "$MIXED_STATUS/docs/as-built/SPECIFICATION.md"
assert_fails_with "status mismatch for sample_sync" run_check "$MIXED_STATUS"

UNKNOWN_SYNC="$TMP_DIR/unknown-sync"
copy_fixture "$BASE" "$UNKNOWN_SYNC"
cat >>"$UNKNOWN_SYNC/docs/workflow/TASK_TRACKER.md" <<'EOF'

```text
SYNC-ID: stale_sync
STATUS: implemented
ARTIFACTS: stale.txt
TESTS: tools/stale_test.sh
```
EOF
assert_fails_with "unknown SYNC-ID block in docs/workflow/TASK_TRACKER.md: stale_sync" run_check "$UNKNOWN_SYNC"

EXTRA_ARTIFACT="$TMP_DIR/extra-artifact"
copy_fixture "$BASE" "$EXTRA_ARTIFACT"
sed -i 's/^ARTIFACTS: artifact-one.txt$/ARTIFACTS: artifact-one.txt, stale.txt/' "$EXTRA_ARTIFACT/docs/as-built/REQUIREMENTS.md"
assert_fails_with "unexpected stale.txt in docs/as-built/REQUIREMENTS.md ARTIFACTS for sample_sync" run_check "$EXTRA_ARTIFACT"

EXTRA_TEST="$TMP_DIR/extra-test"
copy_fixture "$BASE" "$EXTRA_TEST"
sed -i 's#^TESTS: tools/sample_test.sh$#TESTS: tools/sample_test.sh, tools/stale_test.sh#' "$EXTRA_TEST/docs/as-built/SPECIFICATION.md"
assert_fails_with "unexpected tools/stale_test.sh in docs/as-built/SPECIFICATION.md TESTS for sample_sync" run_check "$EXTRA_TEST"

MISSING_ARTIFACT="$TMP_DIR/missing-artifact"
copy_fixture "$BASE" "$MISSING_ARTIFACT"
rm "$MISSING_ARTIFACT/artifact-one.txt"
assert_fails_with "missing required artifact: artifact-one.txt" run_check "$MISSING_ARTIFACT"

INERT_WIRING="$TMP_DIR/inert-wiring"
copy_fixture "$BASE" "$INERT_WIRING"
printf 'echo ./tools/sample_test.sh\n' >"$INERT_WIRING/.github/workflows/ci.yml"
assert_fails_with "missing active test wiring for tools/sample_test.sh" run_check "$INERT_WIRING"

MISSING_WIRING="$TMP_DIR/missing-wiring"
copy_fixture "$BASE" "$MISSING_WIRING"
printf '# ./tools/sample_test.sh\n' >"$MISSING_WIRING/.github/workflows/lesson14-ci.yml"
assert_fails_with "missing active test wiring for tools/sample_test.sh" run_check "$MISSING_WIRING"

printf 'As-built sync contract tests passed.\n'
