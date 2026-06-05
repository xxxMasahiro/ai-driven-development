#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

require_file_contains() {
  local file="$1"
  local pattern="$2"
  if ! grep -Fq -- "$pattern" "$file"; then
    printf 'missing required text in %s: %s\n' "$file" "$pattern" >&2
    return 1
  fi
}

reject_file_contains() {
  local file="$1"
  local pattern="$2"
  if grep -Fq -- "$pattern" "$file"; then
    printf 'forbidden text in %s: %s\n' "$file" "$pattern" >&2
    return 1
  fi
}

require_parallel_kind() {
  local check_id="$1"
  local expected="$2"
  local actual
  actual="$(
    awk -F '\t' -v check_id="$check_id" '
      $1 !~ /^#/ && $1 == check_id { print $3; found = 1; exit }
      END { if (!found) exit 1 }
    ' docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv
  )" || {
    printf 'missing Git hook parallel classification: %s\n' "$check_id" >&2
    return 1
  }
  if [[ "$actual" != "$expected" ]]; then
    printf 'unexpected Git hook execution kind for %s: expected %s, got %s\n' "$check_id" "$expected" "$actual" >&2
    return 1
  fi
}

dry_run_output="$(./tools/ci-playwright-setup --dry-run)"
grep -F 'npm ci --prefer-offline --no-audit --no-fund' <<<"$dry_run_output" >/dev/null
grep -F 'install chromium only when Playwright cannot resolve an existing executable' <<<"$dry_run_output" >/dev/null
grep -F 'stale or missing cache installs chromium normally' <<<"$dry_run_output" >/dev/null

for workflow in .github/workflows/ci.yml .github/workflows/lesson14-ci.yml; do
  reject_file_contains "$workflow" 'actions/checkout@v3'
  reject_file_contains "$workflow" 'actions/setup-node@v3'
  reject_file_contains "$workflow" 'actions/cache@v3'
  reject_file_contains "$workflow" 'actions/upload-artifact@v3'
  reject_file_contains "$workflow" 'actions/download-artifact@v3'
  reject_file_contains "$workflow" 'continue-on-error: true'
  require_file_contains "$workflow" 'actions/checkout@v6'
  require_file_contains "$workflow" './tools/test_ci_pipeline_acceleration.sh'
  require_file_contains "$workflow" 'tools/ci-timing'
  require_file_contains "$workflow" 'tools/test_ci_timing.sh'
done

require_file_contains .github/workflows/ci.yml './tools/ci-playwright-setup'
require_file_contains .github/workflows/ci.yml './tools/ci-timing run lesson_aggregate'
require_file_contains .github/workflows/ci.yml './tools/ci-timing run git_hooks_full_no_cache'
require_file_contains .github/workflows/ci.yml 'lesson-aggregate:'
require_file_contains .github/workflows/ci.yml 'git-hooks-full-no-cache:'
require_file_contains .github/workflows/ci.yml 'final-gate:'
require_file_contains .github/workflows/ci.yml 'if: ${{ always() }}'
require_file_contains .github/workflows/ci.yml 'Verify split prerequisites'
require_file_contains .github/workflows/ci.yml 'LESSON_AGGREGATE_RESULT: ${{ needs.lesson-aggregate.result }}'
require_file_contains .github/workflows/ci.yml 'GIT_HOOKS_FULL_NO_CACHE_RESULT: ${{ needs.git-hooks-full-no-cache.result }}'
require_file_contains .github/workflows/ci.yml 'Split prerequisite failed:'
require_file_contains .github/workflows/ci.yml 'CI_TIMING_REPORT: ${{ runner.temp }}/ci-timing/lesson-aggregate.tsv'
require_file_contains .github/workflows/ci.yml 'CI_TIMING_REPORT: ${{ runner.temp }}/ci-timing/git-hooks-full-no-cache.tsv'
require_file_contains .github/workflows/ci.yml 'CI_EVIDENCE_SOURCE_JOB: lesson-aggregate'
require_file_contains .github/workflows/ci.yml 'CI_EVIDENCE_SOURCE_JOB: git-hooks-full-no-cache'
require_file_contains .github/workflows/ci.yml 'CI_FINAL_GATE_REQUIRE_HOOK_EVIDENCE: "1"'
require_file_contains .github/workflows/ci.yml 'CI_EVIDENCE_EXPECT_SOURCE_JOB: git-hooks-full-no-cache'
require_file_contains .github/workflows/ci.yml 'ci-evidence-git-hooks-${{ github.run_id }}-${{ github.run_attempt }}'
require_file_contains .github/workflows/ci.yml 'ci-timing-part-lesson-aggregate-${{ github.run_id }}-${{ github.run_attempt }}'
require_file_contains .github/workflows/ci.yml 'ci-timing-part-git-hooks-full-no-cache-${{ github.run_id }}-${{ github.run_attempt }}'
require_file_contains .github/workflows/ci.yml 'merge-multiple: true'
require_file_contains .github/workflows/ci.yml 'Upload CI timing report'
require_file_contains .github/workflows/ci.yml 'ci-timing-${{ github.run_id }}-${{ github.run_attempt }}'
reject_file_contains .github/workflows/ci.yml 'npm install'
reject_file_contains .github/workflows/ci.yml 'npx playwright install chromium'

require_file_contains .github/workflows/lesson14-ci.yml 'Lesson14 CI keeps the policy-regression-tests job context'
require_file_contains .github/workflows/lesson14-ci.yml 'common policy regressions are provided by CI / policy-regression-tests'
require_file_contains .github/workflows/lesson14-ci.yml 'CI_COMMON_COVERAGE_SOURCE: ci-split-common-coverage'
reject_file_contains .github/workflows/lesson14-ci.yml './tools/test_docs_tour.sh'
reject_file_contains .github/workflows/lesson14-ci.yml './tools/test_git_workflow_policy.sh'
reject_file_contains .github/workflows/lesson14-ci.yml './tools/test_git_hooks.sh'
reject_file_contains .github/workflows/lesson14-ci.yml './tools/test_product_gate_tools.sh'

require_parallel_kind test_lesson_start_position parallel
require_parallel_kind test_lesson parallel
require_parallel_kind test_lesson14 parallel
require_parallel_kind test_lesson_repository final-gate

require_file_contains tools/check_ci_workflow_structure.sh 'tools/ci-playwright-setup'
require_file_contains tools/check_ci_workflow_structure.sh 'tools/ci-timing'
require_file_contains tools/check_ci_workflow_structure.sh 'tools/test_ci_pipeline_acceleration.sh'
require_file_contains tools/check_ci_workflow_structure.sh 'tools/test_ci_timing.sh'
require_file_contains tools/test_lesson_repository.sh './tools/test_ci_pipeline_acceleration.sh'
require_file_contains tools/test_lesson_repository.sh './tools/test_ci_timing.sh'
require_file_contains docs/workflow/TEST_PLAN_MANIFEST.tsv 'tools/ci-playwright-setup'
require_file_contains docs/workflow/TEST_PLAN_MANIFEST.tsv 'tools/ci-timing'
require_file_contains docs/workflow/GIT_HOOK_CHECKS.tsv 'test_ci_pipeline_acceleration'
require_file_contains docs/workflow/GIT_HOOK_CHECKS.tsv 'test_ci_timing'
require_file_contains docs/workflow/FINAL_GATE_COVERAGE.tsv './tools/test_ci_pipeline_acceleration.sh'
require_file_contains docs/workflow/FINAL_GATE_COVERAGE.tsv './tools/test_ci_timing.sh'

printf 'CI pipeline acceleration tests passed.\n'
