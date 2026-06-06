#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
export LESSON_CONFIG="$ROOT/lesson/LESSON_CONFIG_14_DAYS.tsv"

# shellcheck source=tools/lib/lesson_common.sh
source "$SCRIPT_DIR/lib/lesson_common.sh"
# shellcheck source=tools/lib/document_paths.sh
source "$SCRIPT_DIR/lib/document_paths.sh"

FLOW="$(lesson_flow_file)"
STATE="$(lesson_state_file)"
APPROVALS="$(lesson_approval_file)"
LEARNING_MODE="$(lesson_learning_mode_file)"
WORKFLOW_LANGUAGE="$(lesson_workflow_language_file)"
PRODUCT_LANGUAGE="$(lesson_product_language_file)"
ROADMAP="$(lesson_abs_path "$(lesson_config_get roadmap_file "learning/ROADMAP.md")")"
HELP_DESK="$(lesson_abs_path "$(lesson_config_get helpdesk_file "learning/HELP_DESK.md")")"
SYNC_GATES="$(lesson_abs_path "$(lesson_config_get sync_gates_file "lesson/SYNC_GATES_14_DAYS.tsv")")"
PROMPTS="$(lesson_abs_path "$(lesson_config_get prompt_file "prompts/PROMPTS_14_DAYS.md")")"

required_files=(
  "index-14-days.md"
  "guides/DOCUMENT_MAP.md"
  "$(lesson_doc_relpath requirements)"
  "$(lesson_doc_relpath specification)"
  "$(lesson_doc_relpath implementation_plan)"
  "$(lesson_doc_relpath task_tracker)"
  "$(lesson_doc_relpath handoff)"
  "$(lesson_doc_relpath developer_memory)"
  "docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv"
  "docs/workflow/GIT_WORKFLOW_POLICY.tsv"
  "docs/workflow/GIT_HOOKS_POLICY.tsv"
  "docs/workflow/GIT_HOOK_CHECKS.tsv"
  "docs/workflow/DASHBOARD_DATA_SCHEMA.tsv"
  "guides/LESSON_14_DAYS.md"
  "playbooks/AGENT_PLAYBOOK_14_DAYS.md"
  "lesson/LESSON_CONFIG_14_DAYS.tsv"
  "lesson/LESSON_FLOW_14_DAYS.tsv"
  "lesson/SYNC_GATES_14_DAYS.tsv"
  "learning/LESSON_STATE_14_DAYS.tsv"
  "learning/LESSON_APPROVALS_14_DAYS.tsv"
  "learning/LESSON_MODE_14_DAYS.tsv"
  "learning/WORKFLOW_DISPLAY_LANGUAGE_14_DAYS.tsv"
  "learning/PRODUCT_DEVELOPMENT_LANGUAGE_14_DAYS.tsv"
  "learning/GIT_WORKFLOW_SETTINGS.tsv"
  "learning/GIT_HOOK_SETTINGS.tsv"
  "learning/LEARNING_TASK_TRACKER_14_DAYS.md"
  "learning/LEARNING_HANDOFF_14_DAYS.md"
  "learning/ROADMAP.md"
  "learning/HELP_DESK.md"
  "free-development/FREE_DEVELOPMENT_MODE.md"
  "advanced/TEAM_DEVELOPMENT_DOCKER.md"
  "advanced/DOCKER_PATHS.md"
  "reviews/SUBAGENT_REVIEW_PROTOCOL.md"
  "package.json"
  "package-lock.json"
  "playwright.config.js"
  "tests/playwright/dashboard.spec.js"
  "prompts/PROMPTS_14_DAYS.md"
  "tools/lib/lesson_runtime.sh"
  "tools/lib/document_paths.sh"
  "tools/lib/dashboard_data.sh"
  "tools/lib/git_workflow_policy.sh"
  "tools/lib/git_hooks_policy.sh"
  "docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv"
  "tools/lesson14"
  "tools/roadmap"
  "tools/helpdesk"
  "tools/free-development"
  "tools/product-improvement"
  "tools/external-integration"
  "tools/team-development"
  "tools/menu"
  "tools/as-built-sync"
  "tools/git-workflow"
  "tools/git-hooks"
  "tools/docs-tour"
  "tools/dashboard"
  "tools/dashboard-data"
  "tools/illustrations"
  "tools/check_lesson14_structure.sh"
  "tools/check_document_organization.sh"
  "tools/check_learner_display.sh"
  "tools/check_lesson14_sync.sh"
  "tools/check_git_sync.sh"
  "tools/check_ci_status.sh"
  "tools/check_agents_skills.sh"
  "tools/check_as_built_docs.sh"
  "tools/check_as_built_sync_contract.sh"
  "tools/check_workflow_pair_sync.sh"
  "tools/check_review_protocol.sh"
  "tools/check_developer_memory_requirements.sh"
  "tools/list_non_english_docs.sh"
  "tools/test_lesson_repository.sh"
  "tools/test_product_gate_tools.sh"
  "tools/product-repository-cleanup"
  "tools/test_product_repository_cleanup.sh"
  "tools/test_menu_prerequisites.sh"
  "tools/test_docs_tour.sh"
  "tools/test_as_built_sync_contract.sh"
  "tools/test_git_workflow_policy.sh"
  "tools/test_git_hooks.sh"
  "tools/test_lesson_start_position.sh"
  "tools/test_production_operations.sh"
  "tools/test_lesson_playwright.sh"
  "tools/test_dashboard_schema.sh"
  "tools/test_dashboard_data.sh"
  "tools/test_dashboard_control_center.sh"
  "tools/dashboard-control-center"
  "tools/test_lesson14.sh"
  "illustrations/README.md"
  "illustrations/lesson14/index.tsv"
  "illustration-review/index.html"
)

executable_files=(
  "tools/lesson14"
  "tools/roadmap"
  "tools/helpdesk"
  "tools/free-development"
  "tools/product-improvement"
  "tools/external-integration"
  "tools/team-development"
  "tools/menu"
  "tools/as-built-sync"
  "tools/git-workflow"
  "tools/git-hooks"
  "tools/docs-tour"
  "tools/dashboard"
  "tools/dashboard-data"
  "tools/illustrations"
  "tools/check_lesson14_structure.sh"
  "tools/check_document_organization.sh"
  "tools/check_learner_display.sh"
  "tools/check_lesson14_sync.sh"
  "tools/check_git_sync.sh"
  "tools/check_ci_status.sh"
  "tools/check_agents_skills.sh"
  "tools/check_as_built_docs.sh"
  "tools/check_as_built_sync_contract.sh"
  "tools/check_workflow_pair_sync.sh"
  "tools/check_review_protocol.sh"
  "tools/check_developer_memory_requirements.sh"
  "tools/list_non_english_docs.sh"
  "tools/test_lesson_repository.sh"
  "tools/test_product_gate_tools.sh"
  "tools/product-repository-cleanup"
  "tools/test_product_repository_cleanup.sh"
  "tools/test_menu_prerequisites.sh"
  "tools/test_docs_tour.sh"
  "tools/test_as_built_sync_contract.sh"
  "tools/test_git_workflow_policy.sh"
  "tools/test_git_hooks.sh"
  "tools/test_lesson_start_position.sh"
  "tools/test_production_operations.sh"
  "tools/test_lesson_playwright.sh"
  "tools/test_dashboard_schema.sh"
  "tools/test_dashboard_data.sh"
  "tools/test_dashboard_control_center.sh"
  "tools/dashboard-control-center"
  "tools/test_lesson14.sh"
)

missing=0

for file in "${required_files[@]}"; do
  if [[ ! -f "$ROOT/$file" ]]; then
    printf 'missing: %s\n' "$file" >&2
    missing=1
  fi
done

for file in "${executable_files[@]}"; do
  if [[ -f "$ROOT/$file" && ! -x "$ROOT/$file" ]]; then
    printf 'not executable: %s\n' "$file" >&2
    missing=1
  fi
done

if [[ $missing -ne 0 ]]; then
  printf '\nLesson14 structure check failed.\n' >&2
  exit 1
fi

if [[ -f "$LEARNING_MODE" ]]; then
  if ! awk -F '\t' '
    $1 !~ /^#/ {
      if ($2 == "A" && $3 != "じっくり説明") bad = 1
      if ($2 == "B" && $3 != "ほどよく説明") bad = 1
      if ($2 == "C" && $3 != "手順だけ") bad = 1
      if ($2 !~ /^[ABC]$/) bad = 1
    }
    END { exit bad }
  ' "$LEARNING_MODE"; then
    printf 'invalid learning mode display label in %s\n' "$LEARNING_MODE" >&2
    missing=1
  fi
fi

for language_file in "$WORKFLOW_LANGUAGE" "$PRODUCT_LANGUAGE"; do
  if [[ -f "$language_file" ]]; then
    if ! awk -F '\t' '$1 !~ /^#/ && (NF != 3 || $2 == "" || $3 == "") { bad = 1 } END { exit bad }' "$language_file"; then
      printf 'invalid language state file: %s\n' "$language_file" >&2
      missing=1
    fi
  fi
done

if ! awk -F '\t' '
  NR == FNR {
    if ($1 !~ /^#/) {
      if (NF != 5) {
        printf "invalid flow column count at %s: %d\n", $1, NF > "/dev/stderr"
        bad = 1
      }
      if ($1 == "" || $2 == "" || $3 == "" || $4 == "" || $5 == "") {
        printf "empty flow field at row %s\n", $1 > "/dev/stderr"
        bad = 1
      }
      if (order_seen[$1]++) {
        printf "duplicate flow order: %s\n", $1 > "/dev/stderr"
        bad = 1
      }
      if (step_seen[$2]++) {
        printf "duplicate flow step: %s\n", $2 > "/dev/stderr"
        bad = 1
      }
      flow_count++
      flow_order[flow_count] = $1
      flow_step[flow_count] = $2
      flow_day[flow_count] = $3
      flow[$2] = $1
      if ($3 ~ /^Step [0-9]+\/14$/) {
        step_label = $3
        sub(/^Step /, "", step_label)
        sub(/\/14$/, "", step_label)
        step_label_seen[step_label] = 1
      }
    }
    next
  }
  $1 !~ /^#/ {
    if (NF != 5) {
      printf "invalid state column count at %s: %d\n", $1, NF > "/dev/stderr"
      bad = 1
    }
    state_count++
    state_order[state_count] = $1
    state_step[state_count] = $2
    state_status[state_count] = $3
    if (state_count > flow_count) {
      printf "extra state row: %s %s\n", $1, $2 > "/dev/stderr"
      bad = 1
    } else if ($1 != flow_order[state_count] || $2 != flow_step[state_count]) {
      printf "lesson14 state order mismatch at row %d: expected %s %s, got %s %s\n", state_count, flow_order[state_count], flow_step[state_count], $1, $2 > "/dev/stderr"
      bad = 1
    }
    if (!($2 in flow)) {
      printf "state step not in flow: %s\n", $2 > "/dev/stderr"
      bad = 1
    }
    if ($3 != "current" && $3 != "locked" && $3 != "completed") {
      printf "invalid lesson14 state: %s %s\n", $2, $3 > "/dev/stderr"
      bad = 1
    }
    if (state_step_seen[$2]++) {
      printf "duplicate state step: %s\n", $2 > "/dev/stderr"
      bad = 1
    }
    state[$2] = 1
    if ($3 == "current") current++
  }
  END {
    if (state_count != flow_count) {
      printf "lesson14 state row count mismatch: expected %d, got %d\n", flow_count, state_count > "/dev/stderr"
      bad = 1
    }
    for (step in flow) {
      if (!(step in state)) {
        printf "flow step missing in state: %s\n", step > "/dev/stderr"
        bad = 1
      }
    }
    for (i = 1; i <= 14; i++) {
      if (!step_label_seen[i]) {
        printf "missing Step %d/14 in lesson14 flow\n", i > "/dev/stderr"
        bad = 1
      }
    }
    phase = "completed"
    for (i = 1; i <= state_count; i++) {
      status = state_status[i]
      if (status == "completed") completed++
      if (phase == "completed") {
        if (status == "current") phase = "current"
        else if (status == "locked") phase = "locked"
      } else if (phase == "current") {
        if (status == "locked") phase = "locked"
        else {
          printf "invalid lesson14 state order at %s: %s after current\n", state_step[i], status > "/dev/stderr"
          bad = 1
        }
      } else if (phase == "locked") {
        if (status != "locked") {
          printf "invalid lesson14 state order at %s: %s after locked\n", state_step[i], status > "/dev/stderr"
          bad = 1
        }
      }
    }
    if (current > 1) {
      printf "multiple current lesson14 steps: %d\n", current > "/dev/stderr"
      bad = 1
    }
    if (current == 0 && completed != state_count) {
      printf "missing current lesson14 step while unfinished steps remain\n" > "/dev/stderr"
      bad = 1
    }
    if (current == 1 && completed == state_count) {
      printf "current lesson14 step exists even though all steps are completed\n" > "/dev/stderr"
      bad = 1
    }
    exit bad
  }
' "$FLOW" "$STATE"; then
  missing=1
fi

if ! "$ROOT/tools/check_lesson14_sync.sh" >/dev/null; then
  "$ROOT/tools/check_lesson14_sync.sh" >&2 || true
  missing=1
fi

if ! awk -F '\t' '
  NR == FNR {
    if ($1 !~ /^#/) flow[$2] = 1
    next
  }
  FNR == 1 {
    if ($0 != "# step_id\taction\tapproved_at\tmemo") {
      printf "invalid approval header\n" > "/dev/stderr"
      bad = 1
    }
    next
  }
  $1 !~ /^#/ {
    if (NF != 4) {
      printf "invalid approval column count at %s %s: %d\n", $1, $2, NF > "/dev/stderr"
      bad = 1
    }
    if ($1 == "" || $2 == "" || $3 == "" || $4 == "") {
      printf "empty approval field at %s %s\n", $1, $2 > "/dev/stderr"
      bad = 1
    }
    if (!($1 in flow)) {
      printf "approval step not in flow: %s\n", $1 > "/dev/stderr"
      bad = 1
    }
    if ($2 != "start" && $2 != "pass") {
      printf "invalid approval action at %s: %s\n", $1, $2 > "/dev/stderr"
      bad = 1
    }
    key = $1 "\t" $2
    if (seen[key]++) {
      printf "duplicate approval receipt: %s %s\n", $1, $2 > "/dev/stderr"
      bad = 1
    }
  }
  END { exit bad }
' "$FLOW" "$APPROVALS"; then
  missing=1
fi

if ! awk -F '\t' '
  FNR == 1 {
    if ($0 != "# selected_at\tmode\tdescription") {
      printf "invalid learning mode header\n" > "/dev/stderr"
      bad = 1
    }
    next
  }
  $1 !~ /^#/ {
    if (NF != 3) {
      printf "invalid learning mode column count: %d\n", NF > "/dev/stderr"
      bad = 1
    }
    if ($1 == "" || $2 == "" || $3 == "") {
      printf "empty learning mode field\n" > "/dev/stderr"
      bad = 1
    }
    if ($2 != "A" && $2 != "B" && $2 != "C") {
      printf "invalid learning mode: %s\n", $2 > "/dev/stderr"
      bad = 1
    }
    count++
  }
  END {
    if (count > 1) {
      printf "multiple learning mode records: %d\n", count > "/dev/stderr"
      bad = 1
    }
    exit bad
  }
' "$LEARNING_MODE"; then
  missing=1
fi

for file in "$ROADMAP" "$HELP_DESK" "$SYNC_GATES" "$PROMPTS"; do
  [[ -f "$file" ]] || missing=1
done

if [[ $missing -ne 0 ]]; then
  printf '\nLesson14 structure check failed.\n' >&2
  exit 1
fi

printf 'Lesson14 structure check passed.\n'
