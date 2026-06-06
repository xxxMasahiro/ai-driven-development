#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=tools/lib/lesson_common.sh
source "$ROOT/tools/lib/lesson_common.sh"
# shellcheck source=tools/lib/ci_evidence.sh
source "$ROOT/tools/lib/ci_evidence.sh"

use_evidence="false"
write_evidence="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --use-evidence)
      use_evidence="true"
      shift
      ;;
    --write-evidence)
      write_evidence="true"
      shift
      ;;
    *)
      printf 'Unknown test_lesson_playwright option: %s\n' "$1" >&2
      exit 1
      ;;
  esac
done

playwright_evidence_inputs=(
  package.json
  package-lock.json
  playwright.config.js
  tests/playwright/dashboard.spec.js
  tools/test_lesson_playwright.sh
  tools/resource-guard
  tools/lib/resource_guard.sh
)
playwright_evidence_id="playwright_dashboard"
playwright_command_identity="test_lesson_playwright_v1"

if [[ "$use_evidence" == "true" ]]; then
  playwright_source_job="${CI_EVIDENCE_PLAYWRIGHT_SOURCE_JOB:-}"
  if [[ -z "$playwright_source_job" && -n "${GITHUB_RUN_ID:-}" ]]; then
    playwright_source_job="playwright-tests"
  elif [[ -z "$playwright_source_job" && -n "${CI_EVIDENCE_RUN_ID:-}" ]]; then
    playwright_source_job="playwright-local"
  fi
  if CI_EVIDENCE_EXPECT_SOURCE_JOB="$playwright_source_job" ci_evidence_verify_success "$playwright_evidence_id" "$playwright_command_identity" "${playwright_evidence_inputs[@]}" >/dev/null 2>&1; then
    printf 'Playwright same-run evidence accepted.\n'
    printf 'Lesson Playwright checks passed.\n'
    exit 0
  fi
fi

if [[ ! -x "$ROOT/node_modules/.bin/playwright" ]]; then
  printf 'Playwright dependencies are not installed.\n' >&2
  printf 'Run npm install, then run: npm run test:dashboard\n' >&2
  exit 1
fi

workers="$("$ROOT/tools/resource-guard" recommend-jobs --profile playwright --value-only)"
(cd "$ROOT" && PLAYWRIGHT_WORKERS="$workers" npm run test:dashboard)

if [[ "$write_evidence" == "true" || "${CI_EVIDENCE_WRITE:-0}" == "1" ]]; then
  ci_evidence_record_success "$playwright_evidence_id" "$playwright_command_identity" "${playwright_evidence_inputs[@]}"
fi

printf 'Lesson Playwright checks passed.\n'
