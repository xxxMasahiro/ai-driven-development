#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

workflow_block() {
  local file="$1"
  local job="$2"
  awk -v job="$job" '
    $0 == "  " job ":" {
      in_job = 1
      print
      next
    }
    in_job && $0 ~ /^  [A-Za-z0-9_-]+:$/ {
      exit
    }
    in_job {
      print
    }
  ' "$file"
}

require_file_contains() {
  local file="$1"
  local pattern="$2"
  if ! grep -Fq -- "$pattern" "$file"; then
    printf 'Missing required workflow text in %s: %s\n' "$file" "$pattern" >&2
    return 1
  fi
}

require_job() {
  local file="$1"
  local job="$2"
  if [[ -z "$(workflow_block "$file" "$job")" ]]; then
    printf 'Missing required job in %s: %s\n' "$file" "$job" >&2
    return 1
  fi
}

require_job_contains() {
  local file="$1"
  local job="$2"
  local pattern="$3"
  if ! workflow_block "$file" "$job" | grep -Fq -- "$pattern"; then
    printf 'Missing required text in %s job %s: %s\n' "$file" "$job" "$pattern" >&2
    return 1
  fi
}

reject_job_contains() {
  local file="$1"
  local job="$2"
  local pattern="$3"
  if workflow_block "$file" "$job" | grep -Fq -- "$pattern"; then
    printf 'Forbidden workflow text in %s job %s: %s\n' "$file" "$job" "$pattern" >&2
    return 1
  fi
}

check_main_ci() {
  local file="$ROOT/.github/workflows/ci.yml"
  local job
  local required_jobs=(
    syntax-checks
    structure-docs-checks
    policy-regression-tests
    lesson-cli-tests
    playwright-tests
    aggregate-and-full-hooks
  )

  for job in "${required_jobs[@]}"; do
    require_job "$file" "$job"
  done

  require_job_contains "$file" syntax-checks "bash -n tools/check_ci_workflow_structure.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/lib/ci_evidence.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/lib/ci_timing.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/lib/as_built_evidence.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/test-plan"
  require_job_contains "$file" syntax-checks "bash -n tools/check_test_plan_coverage.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/fixture-copy"
  require_job_contains "$file" syntax-checks "bash -n tools/test_fixture_copy.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/ci-evidence"
  require_job_contains "$file" syntax-checks "bash -n tools/ci-timing"
  require_job_contains "$file" syntax-checks "bash -n tools/ci-final-gate"
  require_job_contains "$file" syntax-checks "bash -n tools/ci-playwright-setup"
  require_job_contains "$file" syntax-checks "bash -n tools/test_ci_evidence.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/test_ci_timing.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/test_ci_final_gate.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/test_ci_pipeline_acceleration.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/test_lesson_start_position.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/test_lesson14.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/check_security_invariants.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/product-security"
  require_job_contains "$file" syntax-checks "bash -n tools/lib/dashboard_data.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/dashboard-data"
  require_job_contains "$file" syntax-checks "bash -n tools/test_dashboard_schema.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/test_dashboard_data.sh"
  require_job_contains "$file" structure-docs-checks "./tools/check_lesson_structure.sh"
  require_job_contains "$file" structure-docs-checks "./tools/check_as_built_docs.sh"
  require_job_contains "$file" structure-docs-checks "./tools/check_test_plan_coverage.sh"
  require_job_contains "$file" structure-docs-checks "./tools/check_security_invariants.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_resource_guard_summary.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_test_plan.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_git_hooks_parallel.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_fixture_copy.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_ci_evidence.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_ci_timing.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_dashboard_schema.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_dashboard_data.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_ci_final_gate.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_ci_pipeline_acceleration.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_security_invariants.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_lesson_start_position.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_product_gate_tools.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_product_security.sh"
  require_job_contains "$file" policy-regression-tests "./tools/check_ci_workflow_structure.sh"
  require_job_contains "$file" lesson-cli-tests "./tools/test_lesson.sh"
  require_job_contains "$file" playwright-tests "actions/setup-node@v6"
  require_job_contains "$file" playwright-tests "actions/cache@v4"
  require_job_contains "$file" playwright-tests "cache: npm"
  require_job_contains "$file" playwright-tests "path: ~/.cache/ms-playwright"
  require_job_contains "$file" playwright-tests "./tools/ci-playwright-setup"
  reject_job_contains "$file" playwright-tests "npm install"
  reject_job_contains "$file" playwright-tests "npx playwright install chromium"
  require_job_contains "$file" playwright-tests 'CI_EVIDENCE_DIR: ${{ runner.temp }}/ci-evidence'
  require_job_contains "$file" playwright-tests "CI_EVIDENCE_SOURCE_JOB: playwright-tests"
  require_job_contains "$file" playwright-tests "./tools/test_lesson_playwright.sh --write-evidence"
  require_job_contains "$file" playwright-tests "actions/upload-artifact@v4"
  require_job_contains "$file" playwright-tests "include-hidden-files: true"
  require_job_contains "$file" aggregate-and-full-hooks "needs:"
  require_job_contains "$file" aggregate-and-full-hooks "- syntax-checks"
  require_job_contains "$file" aggregate-and-full-hooks "- structure-docs-checks"
  require_job_contains "$file" aggregate-and-full-hooks "- policy-regression-tests"
  require_job_contains "$file" aggregate-and-full-hooks "- lesson-cli-tests"
  require_job_contains "$file" aggregate-and-full-hooks "- playwright-tests"
  require_job_contains "$file" aggregate-and-full-hooks "actions/setup-node@v6"
  require_job_contains "$file" aggregate-and-full-hooks "actions/cache@v4"
  require_job_contains "$file" aggregate-and-full-hooks "actions/download-artifact@v4"
  require_job_contains "$file" aggregate-and-full-hooks "cache: npm"
  require_job_contains "$file" aggregate-and-full-hooks "path: ~/.cache/ms-playwright"
  require_job_contains "$file" aggregate-and-full-hooks "./tools/ci-playwright-setup"
  reject_job_contains "$file" aggregate-and-full-hooks "npm install"
  reject_job_contains "$file" aggregate-and-full-hooks "npx playwright install chromium"
  require_job_contains "$file" aggregate-and-full-hooks "RESOURCE_GUARD_SKIP_LOCAL_CHECK: \"1\""
  require_job_contains "$file" aggregate-and-full-hooks 'CI_EVIDENCE_DIR: ${{ runner.temp }}/ci-evidence'
  require_job_contains "$file" aggregate-and-full-hooks "CI_EVIDENCE_SOURCE_JOB: aggregate-and-full-hooks"
  require_job_contains "$file" aggregate-and-full-hooks "CI_EVIDENCE_PLAYWRIGHT_SOURCE_JOB: playwright-tests"
  require_job_contains "$file" aggregate-and-full-hooks 'CI_TIMING_DIR: ${{ runner.temp }}/ci-timing'
  require_job_contains "$file" aggregate-and-full-hooks "./tools/ci-timing run lesson_aggregate"
  require_job_contains "$file" aggregate-and-full-hooks "./tools/test_lesson_repository.sh --use-evidence --write-evidence"
  require_job_contains "$file" aggregate-and-full-hooks "./tools/ci-timing run git_hooks_full_no_cache"
  require_job_contains "$file" aggregate-and-full-hooks "./tools/git-hooks run --mode full --no-cache --jobs 4"
  require_job_contains "$file" aggregate-and-full-hooks "Upload CI timing report"
  require_job_contains "$file" aggregate-and-full-hooks 'ci-timing-${{ github.run_id }}-${{ github.run_attempt }}'
}

check_lesson14_ci() {
  local file="$ROOT/.github/workflows/lesson14-ci.yml"
  local job
  local required_jobs=(
    syntax-checks
    lesson14-structure-sync
    policy-regression-tests
    lesson14-cli-tests
    playwright-tests
    lesson14-final-gate
    aggregate-and-full-hooks
  )

  for job in "${required_jobs[@]}"; do
    require_job "$file" "$job"
  done

  require_job_contains "$file" syntax-checks "bash -n tools/check_ci_workflow_structure.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/lib/ci_evidence.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/lib/ci_timing.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/lib/as_built_evidence.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/test-plan"
  require_job_contains "$file" syntax-checks "bash -n tools/check_test_plan_coverage.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/fixture-copy"
  require_job_contains "$file" syntax-checks "bash -n tools/test_fixture_copy.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/ci-evidence"
  require_job_contains "$file" syntax-checks "bash -n tools/ci-timing"
  require_job_contains "$file" syntax-checks "bash -n tools/ci-final-gate"
  require_job_contains "$file" syntax-checks "bash -n tools/ci-playwright-setup"
  require_job_contains "$file" syntax-checks "bash -n tools/test_ci_evidence.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/test_ci_timing.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/test_ci_final_gate.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/test_ci_pipeline_acceleration.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/test_lesson_start_position.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/check_security_invariants.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/product-security"
  require_job_contains "$file" syntax-checks "bash -n tools/lib/dashboard_data.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/dashboard-data"
  require_job_contains "$file" syntax-checks "bash -n tools/test_dashboard_schema.sh"
  require_job_contains "$file" syntax-checks "bash -n tools/test_dashboard_data.sh"
  require_job_contains "$file" lesson14-structure-sync "./tools/check_lesson14_structure.sh"
  require_job_contains "$file" lesson14-structure-sync "./tools/check_lesson14_sync.sh"
  require_job_contains "$file" lesson14-structure-sync "./tools/check_test_plan_coverage.sh"
  require_job_contains "$file" lesson14-structure-sync "./tools/check_security_invariants.sh"
  require_job_contains "$file" policy-regression-tests "./tools/check_test_plan_coverage.sh"
  require_job_contains "$file" policy-regression-tests "./tools/check_security_invariants.sh"
  require_job_contains "$file" policy-regression-tests "./tools/check_ci_workflow_structure.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_ci_pipeline_acceleration.sh"
  require_job_contains "$file" policy-regression-tests "./tools/test_ci_timing.sh"
  require_job_contains "$file" policy-regression-tests "Lesson14 CI keeps the policy-regression-tests job context"
  require_job_contains "$file" policy-regression-tests "common policy regressions are provided by CI / policy-regression-tests"
  reject_job_contains "$file" policy-regression-tests "./tools/test_docs_tour.sh"
  reject_job_contains "$file" policy-regression-tests "./tools/test_git_workflow_policy.sh"
  reject_job_contains "$file" policy-regression-tests "./tools/test_git_hooks.sh"
  reject_job_contains "$file" policy-regression-tests "./tools/test_product_gate_tools.sh"
  require_job_contains "$file" lesson14-cli-tests "./tools/test_lesson14.sh"
  require_job_contains "$file" playwright-tests "needs:"
  require_job_contains "$file" playwright-tests "- syntax-checks"
  require_job_contains "$file" playwright-tests "- lesson14-structure-sync"
  require_job_contains "$file" playwright-tests "- policy-regression-tests"
  require_job_contains "$file" playwright-tests "Shared Playwright coverage compatibility gate"
  require_job_contains "$file" playwright-tests "./tools/check_lesson14_structure.sh"
  require_job_contains "$file" playwright-tests "./tools/check_lesson14_sync.sh"
  require_job_contains "$file" playwright-tests "./tools/check_ci_workflow_structure.sh"
  require_job_contains "$file" playwright-tests "browser coverage is provided by CI / playwright-tests"
  reject_job_contains "$file" playwright-tests "npm install"
  reject_job_contains "$file" playwright-tests "npx playwright install chromium"
  reject_job_contains "$file" playwright-tests "./tools/test_lesson_playwright.sh"
  require_job_contains "$file" lesson14-final-gate "needs:"
  require_job_contains "$file" lesson14-final-gate "- syntax-checks"
  require_job_contains "$file" lesson14-final-gate "- lesson14-structure-sync"
  require_job_contains "$file" lesson14-final-gate "- policy-regression-tests"
  require_job_contains "$file" lesson14-final-gate "- lesson14-cli-tests"
  require_job_contains "$file" lesson14-final-gate "./tools/check_lesson14_structure.sh"
  require_job_contains "$file" lesson14-final-gate "./tools/check_lesson14_sync.sh"
  require_job_contains "$file" lesson14-final-gate "./tools/test_lesson_start_position.sh"
  require_job_contains "$file" lesson14-final-gate "./tools/test_lesson14.sh"
  require_job_contains "$file" lesson14-final-gate "./tools/check_ci_workflow_structure.sh"
  require_job_contains "$file" aggregate-and-full-hooks "needs:"
  require_job_contains "$file" aggregate-and-full-hooks "- syntax-checks"
  require_job_contains "$file" aggregate-and-full-hooks "- lesson14-structure-sync"
  require_job_contains "$file" aggregate-and-full-hooks "- policy-regression-tests"
  require_job_contains "$file" aggregate-and-full-hooks "- lesson14-cli-tests"
  require_job_contains "$file" aggregate-and-full-hooks "- playwright-tests"
  require_job_contains "$file" aggregate-and-full-hooks "- lesson14-final-gate"
  require_job_contains "$file" aggregate-and-full-hooks "Compatibility aggregate and full-hooks gate"
  require_job_contains "$file" aggregate-and-full-hooks "./tools/check_lesson14_structure.sh"
  require_job_contains "$file" aggregate-and-full-hooks "./tools/check_lesson14_sync.sh"
  require_job_contains "$file" aggregate-and-full-hooks "./tools/test_lesson_start_position.sh"
  require_job_contains "$file" aggregate-and-full-hooks "./tools/check_ci_workflow_structure.sh"
  require_job_contains "$file" aggregate-and-full-hooks "common aggregate/full-hooks coverage is provided by CI / aggregate-and-full-hooks"
  reject_job_contains "$file" aggregate-and-full-hooks "./tools/test_lesson_repository.sh"
  reject_job_contains "$file" aggregate-and-full-hooks "./tools/git-hooks run --mode full --no-cache"
}

require_file_contains "$ROOT/.github/workflows/ci.yml" "concurrency:"
require_file_contains "$ROOT/.github/workflows/lesson14-ci.yml" "concurrency:"
for workflow_file in "$ROOT/.github/workflows/ci.yml" "$ROOT/.github/workflows/lesson14-ci.yml"; do
  if grep -Eq 'actions/(checkout|setup-node|cache|upload-artifact|download-artifact)@v[123]' "$workflow_file"; then
    printf 'Deprecated Node-action major version in %s\n' "$workflow_file" >&2
    exit 1
  fi
  if grep -Fq 'continue-on-error: true' "$workflow_file"; then
    printf 'CI workflow must not use continue-on-error: true: %s\n' "$workflow_file" >&2
    exit 1
  fi
done
check_main_ci
check_lesson14_ci

printf 'CI workflow structure check passed.\n'
