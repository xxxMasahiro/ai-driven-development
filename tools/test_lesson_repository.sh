#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=tools/lib/lesson_common.sh
source "$ROOT/tools/lib/lesson_common.sh"
# shellcheck source=tools/lib/ci_evidence.sh
source "$ROOT/tools/lib/ci_evidence.sh"
# shellcheck source=tools/lib/as_built_evidence.sh
source "$ROOT/tools/lib/as_built_evidence.sh"
cd "$ROOT"

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
      printf 'Unknown test_lesson_repository option: %s\n' "$1" >&2
      exit 1
      ;;
  esac
done

aggregate_evidence_id="lesson_repository_aggregate"
aggregate_command_identity="test_lesson_repository_v1"
aggregate_evidence_inputs=(
  AGENTS.MD
  docs
  learning
  lesson
  skills
  reviews
  templates
  tools
  .github/workflows
  dashboard-control-center
  package.json
  package-lock.json
  playwright.config.js
  vite.config.mjs
  tests
)

if [[ "$use_evidence" == "true" ]]; then
  export CI_EVIDENCE_USE=1
fi
if [[ "$write_evidence" == "true" ]]; then
  export CI_EVIDENCE_WRITE=1
fi

if [[ "$use_evidence" == "true" ]]; then
  if ci_evidence_verify_success "$aggregate_evidence_id" "$aggregate_command_identity" "${aggregate_evidence_inputs[@]}" >/dev/null 2>&1; then
    printf 'Lesson repository same-run aggregate evidence accepted.\n'
    printf 'Lesson repository test passed.\n'
    exit 0
  fi
fi

./tools/check_lesson_structure.sh
./tools/check_document_organization.sh
./tools/check_learner_display.sh
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
as_built_evidence_run_docs_check
as_built_evidence_run_sync_contract_check
./tools/check_test_plan_coverage.sh
./tools/check_security_invariants.sh
WORKFLOW_PAIR_SINGLE_FILE_REASON="aggregate test may run while remediation documents are being edited together" ./tools/check_workflow_pair_sync.sh
./tools/check_review_protocol.sh
./tools/check_developer_memory_requirements.sh
./tools/menu >/dev/null
./tools/dashboard all >/dev/null
./tools/as-built-sync status >/dev/null
./tools/illustrations list >/dev/null
./tools/test_docs_tour.sh
./tools/test_as_built_sync_contract.sh
./tools/test_test_plan.sh
./tools/test_security_invariants.sh
./tools/test_git_workflow_policy.sh
./tools/git-hooks status >/dev/null
./tools/test_git_hooks.sh
./tools/resource-guard status >/dev/null
./tools/resource-guard summary >/dev/null
./tools/resource-guard summary --short >/dev/null
./tools/test_resource_guard.sh
./tools/test_resource_guard_summary.sh
./tools/test_resource_cleanup.sh
./tools/test_git_hooks_parallel.sh
./tools/test_fixture_copy.sh
./tools/test_ci_evidence.sh
./tools/test_ci_timing.sh
./tools/dashboard-data >/dev/null
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_control_center.sh
./tools/test_ci_final_gate.sh
./tools/test_ci_pipeline_acceleration.sh
./tools/check_ci_workflow_structure.sh
./tools/product-improvement status >/dev/null
./tools/external-integration status >/dev/null
./tools/product-repository-cleanup status >/dev/null
./tools/git-workflow status >/dev/null
./tools/git-workflow cleanup-plan >/dev/null
if [[ "$write_evidence" == "true" || "${CI_EVIDENCE_WRITE:-0}" == "1" ]]; then
  ./tools/test_lesson_playwright.sh --use-evidence --write-evidence
else
  ./tools/test_lesson_playwright.sh --use-evidence
fi
./tools/test_menu_prerequisites.sh
./tools/test_product_gate_tools.sh
./tools/test_product_repository_cleanup.sh
./tools/test_product_security.sh
./tools/test_lesson_start_position.sh
./tools/test_lesson.sh
./tools/test_lesson14.sh

if [[ "$write_evidence" == "true" || "${CI_EVIDENCE_WRITE:-0}" == "1" ]]; then
  ci_evidence_record_success "$aggregate_evidence_id" "$aggregate_command_identity" "${aggregate_evidence_inputs[@]}"
fi

printf 'Lesson repository test passed.\n'
