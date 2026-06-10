#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCHEMA="$ROOT/docs/workflow/DASHBOARD_DATA_SCHEMA.tsv"
missing=0

report() {
  printf '%s\n' "$1" >&2
  missing=1
}

require_path() {
  local path="$1"
  if ! awk -F '\t' -v path="$path" '$1 !~ /^#/ && $2 == path { found = 1 } END { exit found ? 0 : 1 }' "$SCHEMA"; then
    report "missing dashboard schema path: $path"
  fi
}

require_enum_contains() {
  local path="$1"
  local token="$2"
  if ! awk -F '\t' -v path="$path" -v token="$token" '
    $1 !~ /^#/ && $2 == path {
      split($5, values, /\|/)
      for (i in values) {
        if (values[i] == token) found = 1
      }
    }
    END { exit found ? 0 : 1 }
  ' "$SCHEMA"; then
    report "missing enum token for $path: $token"
  fi
}

[[ -f "$SCHEMA" ]] || {
  printf 'missing dashboard schema: %s\n' "$SCHEMA" >&2
  exit 1
}

awk -F '\t' '
  $1 ~ /^#/ { next }
  NF != 7 {
    printf "invalid dashboard schema column count on line %d: %d\n", NR, NF > "/dev/stderr"
    invalid = 1
    next
  }
  {
    for (i = 1; i <= 7; i++) {
      if ($i == "") {
        printf "empty dashboard schema field on line %d column %d\n", NR, i > "/dev/stderr"
        invalid = 1
      }
    }
    if ($3 != "implemented" && $3 != "planned") {
      printf "unexpected dashboard schema status on line %d: %s\n", NR, $3 > "/dev/stderr"
      invalid = 1
    }
    if (seen[$2]++) {
      printf "duplicate dashboard schema path on line %d: %s\n", NR, $2 > "/dev/stderr"
      invalid = 1
    }
    if ($2 == "git_workflow.status" || $2 == "security.status") {
      printf "unsafe aggregate status path on line %d: %s\n", NR, $2 > "/dev/stderr"
      invalid = 1
    }
  }
  END { exit invalid ? 1 : 0 }
' "$SCHEMA" || missing=1

required_paths=(
  "schema_version"
  "generated_at"
  "snapshot_id"
  "content_hash"
  "source_files"
  "source_commands"
  "warnings"
  "selected_context"
  "selected_context.menu_id"
  "selected_context.workflow_context"
  "selected_context.target_repository"
  "selected_context.target_repository.name"
  "selected_context.target_repository.path_state"
  "selected_context.product_type"
  "selected_context.current_step_id"
  "selected_context.current_step_label"
  "selected_context.current_step_index"
  "selected_context.current_step_total"
  "selected_context.updated_at"
  "selected_context.git_status"
  "selected_context.ci_status"
  "selected_context.security_status"
  "selected_context.evidence_status"
  "selected_context.next_safe_action"
  "selected_context.blockers"
  "available_contexts[]"
  "available_contexts[].menu_id"
  "available_contexts[].workflow_context"
  "available_contexts[].target_repository_name"
  "available_contexts[].status"
  "partial_failures[].source"
  "partial_failures[].status"
  "partial_failures[].reason"
  "partial_failures[].required_command"
  "summary.mode"
  "summary.next_safe_action"
  "summary.primary_action.title"
  "summary.primary_action.description"
  "summary.primary_action.target"
  "summary.primary_action.expected_result"
  "summary.primary_action.risk_level"
  "summary.primary_action.status"
  "summary.primary_action.source"
  "summary.category_metrics.overview"
  "summary.category_metrics.lessons"
  "summary.category_metrics.workflow"
  "summary.category_metrics.maintenance"
  "summary.category_metrics.security"
  "summary.category_metrics.*.total"
  "summary.category_metrics.*.healthy"
  "summary.category_metrics.*.warning"
  "summary.category_metrics.*.problem"
  "summary.category_metrics.*.percent"
  "summary.category_metrics.*.unit"
  "summary.category_metrics.*.status"
  "summary.guidance_items[].surface"
  "summary.guidance_items[].audience"
  "summary.guidance_items[].priority"
  "summary.guidance_items[].message"
  "summary.guidance_items[].related_command"
  "summary.blocking_items[].source"
  "summary.blocking_items[].status"
  "summary.blocking_items[].reason"
  "summary.blocking_items[].required_command"
  "summary.manual_followups[].source"
  "summary.manual_followups[].status"
  "summary.manual_followups[].reason"
  "summary.manual_followups[].required_command"
  "lessons.step_1_7"
  "lessons.step_1_7.points"
  "lessons.step_1_7.warnings"
  "lessons.step_1_7.next_learning_action"
  "lessons.step_1_14"
  "lessons.step_1_14.points"
  "lessons.step_1_14.warnings"
  "lessons.step_1_14.next_learning_action"
  "lessons.advanced"
  "lessons.advanced.points"
  "lessons.advanced.warnings"
  "lessons.advanced.next_learning_action"
  "development.product_repository.status"
  "development.documents.status"
  "development.git_sync_status"
  "development.ci_status"
  "development.git_operations[]"
  "development.git_operations[].id"
  "development.git_operations[].label"
  "development.git_operations[].status"
  "development.git_operations[].mode"
  "development.git_operations[].detail"
  "development.product_authority"
  "development.product_authority.status"
  "development.product_authority.repository.status"
  "development.product_authority.repository.configured_name"
  "development.product_authority.repository.blocker_scope"
  "development.product_authority.product_summary"
  "development.product_authority.product_summary.status"
  "development.product_authority.product_summary.name"
  "development.product_authority.product_summary.display_name"
  "development.product_authority.product_summary.display_name.ja"
  "development.product_authority.product_summary.display_name.en"
  "development.product_authority.product_summary.description"
  "development.product_authority.product_summary.source_documents"
  "development.product_authority.product_summary.source_path"
  "development.product_authority.manifest_summary"
  "development.product_authority.manifest_summary.required_missing"
  "development.product_authority.manifest_summary.optional_missing"
  "development.product_authority.evidence_summary"
  "development.product_authority.evidence_summary.items[].source_id"
  "development.product_authority.evidence_summary.items[].status"
  "development.product_authority.evidence_summary.items[].freshness_state"
  "development.product_authority.evidence_summary.items[].authority"
  "development.product_authority.product_operation_blockers"
  "development.product_authority.product_operation_blockers[].source"
  "development.product_authority.product_operation_blockers[].status"
  "development.product_authority.product_operation_blockers[].required_command"
  "maintenance.as_built_sync_status"
  "maintenance.workflow_pair_status"
  "maintenance.developer_memory_status"
  "maintenance.skills_status"
  "maintenance.evidence_rows[]"
  "maintenance.evidence_rows[].id"
  "maintenance.evidence_rows[].label"
  "maintenance.evidence_rows[].importance"
  "maintenance.evidence_rows[].status"
  "maintenance.evidence_rows[].reference"
  "git_workflow.policy_status"
  "git_workflow.settings_status"
  "git_workflow.gate_status"
  "git_workflow.approval_status"
  "security.policy_status"
  "security.gate_status"
  "security.dangerous_action_approval"
  "security.approvals[]"
  "security.approvals[].id"
  "security.approvals[].label"
  "security.approvals[].status"
  "security.approvals[].detail"
  "security.approvals[].last_checked"
  "security.dangerous_operations[]"
  "security.dangerous_operations[].id"
  "security.dangerous_operations[].label"
  "security.dangerous_operations[].status"
  "security.dangerous_operations[].detail"
  "security.dangerous_operations[].last_checked"
  "actions.command_previews[].intent"
  "actions.command_previews[].target"
  "actions.command_previews[].risk_level"
  "actions.command_previews[].requires_approval"
  "actions.command_previews[].approval_gate_id"
  "actions.command_previews[].argv"
  "actions.command_previews[].command_text"
  "actions.command_previews[].execution_mode"
  "actions.command_previews[].non_executable"
  "actions.command_preview_groups[]"
  "actions.command_preview_groups[].id"
  "actions.command_preview_groups[].label"
  "actions.command_preview_groups[].risk_level"
  "actions.command_preview_groups[].preview_count"
)

for path in "${required_paths[@]}"; do
  require_path "$path"
done

require_enum_contains "git_workflow.policy_status" "ready"
require_enum_contains "git_workflow.gate_status" "passed"
require_enum_contains "git_workflow.approval_status" "approval_required"
require_enum_contains "security.policy_status" "ready"
require_enum_contains "security.gate_status" "passed"
require_enum_contains "security.dangerous_action_approval" "approval_required"
require_enum_contains "summary.mode" "unknown"
require_enum_contains "selected_context.menu_id" "step_1_14"
require_enum_contains "selected_context.workflow_context" "free-development"
require_enum_contains "selected_context.git_status" "not_run"
require_enum_contains "selected_context.ci_status" "manual_required"
require_enum_contains "selected_context.security_status" "blocked"
require_enum_contains "development.git_operations[].status" "approval_required"
require_enum_contains "maintenance.evidence_rows[].status" "stale"
require_enum_contains "security.approvals[].status" "approval_required"
require_enum_contains "security.dangerous_operations[].status" "blocked"
require_enum_contains "available_contexts[].status" "ready"
require_enum_contains "summary.guidance_items[].surface" "lesson"
require_enum_contains "summary.guidance_items[].surface" "workflow"
require_enum_contains "summary.guidance_items[].audience" "non_engineer"
require_enum_contains "summary.guidance_items[].audience" "engineer"
require_enum_contains "summary.guidance_items[].priority" "attention"
require_enum_contains "summary.primary_action.risk_level" "low"
require_enum_contains "summary.primary_action.status" "approval_required"
require_enum_contains "summary.category_metrics.*.status" "ready"
require_enum_contains "summary.manual_followups[].status" "optional"
require_enum_contains "development.product_authority.status" "not_run"
require_enum_contains "development.product_authority.status" "stale"
require_enum_contains "development.product_authority.repository.blocker_scope" "product_operations"
require_enum_contains "development.product_authority.product_summary.status" "ready"
require_enum_contains "development.product_authority.product_summary.status" "missing"
require_enum_contains "development.product_authority.evidence_summary.items[].status" "not_run"
require_enum_contains "development.product_authority.evidence_summary.items[].status" "stale"
require_enum_contains "development.product_authority.evidence_summary.items[].freshness_state" "not_collected"
require_enum_contains "development.product_authority.evidence_summary.items[].authority" "not_collected"
require_enum_contains "development.product_authority.product_operation_blockers[].status" "not_run"
require_enum_contains "development.product_authority.product_operation_blockers[].status" "stale"
require_enum_contains "actions.command_previews[].execution_mode" "preview_only"
require_enum_contains "actions.command_preview_groups[].risk_level" "critical"

if ! awk -F '\t' '$1 !~ /^#/ && $2 == "source_files" && $5 == "relative-path-list" { found = 1 } END { exit found ? 0 : 1 }' "$SCHEMA"; then
  report "source_files must use relative-path-list"
fi

if ! awk -F '\t' '$1 !~ /^#/ && $2 == "actions.command_previews[].non_executable" && $5 == "true" { found = 1 } END { exit found ? 0 : 1 }' "$SCHEMA"; then
  report "command previews must be explicitly non-executable"
fi

if [[ $missing -ne 0 ]]; then
  printf '\nDashboard schema test failed.\n' >&2
  exit 1
fi

printf 'Dashboard schema test passed.\n'
