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
    if ($3 != "implemented") {
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
  "source_files"
  "source_commands"
  "warnings"
  "partial_failures[].source"
  "partial_failures[].status"
  "partial_failures[].reason"
  "partial_failures[].required_command"
  "summary.mode"
  "summary.next_safe_action"
  "summary.guidance_items[].surface"
  "summary.guidance_items[].audience"
  "summary.guidance_items[].priority"
  "summary.guidance_items[].message"
  "summary.guidance_items[].related_command"
  "summary.blocking_items[].source"
  "summary.blocking_items[].status"
  "summary.blocking_items[].reason"
  "summary.blocking_items[].required_command"
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
  "maintenance.as_built_sync_status"
  "maintenance.workflow_pair_status"
  "maintenance.developer_memory_status"
  "maintenance.skills_status"
  "git_workflow.policy_status"
  "git_workflow.settings_status"
  "git_workflow.gate_status"
  "git_workflow.approval_status"
  "security.policy_status"
  "security.gate_status"
  "security.dangerous_action_approval"
  "actions.command_previews[].intent"
  "actions.command_previews[].target"
  "actions.command_previews[].risk_level"
  "actions.command_previews[].requires_approval"
  "actions.command_previews[].approval_gate_id"
  "actions.command_previews[].argv"
  "actions.command_previews[].command_text"
  "actions.command_previews[].execution_mode"
  "actions.command_previews[].non_executable"
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
require_enum_contains "summary.guidance_items[].surface" "lesson"
require_enum_contains "summary.guidance_items[].surface" "workflow"
require_enum_contains "summary.guidance_items[].audience" "non_engineer"
require_enum_contains "summary.guidance_items[].audience" "engineer"
require_enum_contains "summary.guidance_items[].priority" "attention"
require_enum_contains "actions.command_previews[].execution_mode" "preview_only"

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
