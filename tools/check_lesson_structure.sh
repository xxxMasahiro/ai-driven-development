#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/lib/lesson_common.sh
source "$SCRIPT_DIR/lib/lesson_common.sh"
# shellcheck source=tools/lib/document_paths.sh
source "$SCRIPT_DIR/lib/document_paths.sh"

ROOT="$LESSON_ROOT"
FLOW="$(lesson_flow_file)"
STATE="$(lesson_state_file)"
PRODUCT_REPO_NAME="$(lesson_product_repo_name)"

required_files=(
  ".gitignore"
  ".githooks/pre-commit"
  ".github/workflows/ci.yml"
  "AGENTS.MD"
  "LICENSE"
  "README.md"
  "$(lesson_doc_relpath requirements)"
  "$(lesson_doc_relpath specification)"
  "$(lesson_doc_relpath implementation_plan)"
  "$(lesson_doc_relpath task_tracker)"
  "$(lesson_doc_relpath handoff)"
  "$(lesson_doc_relpath developer_memory)"
  "docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv"
  "docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv"
  "docs/workflow/PRODUCT_SECURITY_POLICY.tsv"
  "docs/workflow/GIT_WORKFLOW_POLICY.tsv"
  "docs/workflow/MENU_PRODUCT_PROFILE_POLICY.tsv"
  "docs/workflow/GIT_HOOKS_POLICY.tsv"
  "docs/workflow/GIT_HOOK_CHECKS.tsv"
  "docs/workflow/TEST_PLAN_MANIFEST.tsv"
  "docs/workflow/DASHBOARD_DATA_SCHEMA.tsv"
  "index.md"
  "ai-driven-task-tracker-scenario.md"
  "github-login-setup-guide.md"
  "guides/DOCUMENT_MAP.md"
  "guides/LESSON_GUIDE.md"
  "prompts/PROMPTS.md"
  "templates/TEMPLATES.md"
  "free-development/FREE_DEVELOPMENT_MODE.md"
  "advanced/TEAM_DEVELOPMENT_DOCKER.md"
  "advanced/DOCKER_PATHS.md"
  "reviews/SUBAGENT_REVIEW_PROTOCOL.md"
  "package.json"
  "package-lock.json"
  "playwright.config.js"
  "tests/playwright/dashboard.spec.js"
  "playbooks/AGENT_PLAYBOOK.md"
  "lesson/LESSON_CONFIG.tsv"
  "lesson/LESSON_FLOW.tsv"
  "learning/LESSON_STATE.tsv"
  "learning/LESSON_MODE.tsv"
  "learning/WORKFLOW_DISPLAY_LANGUAGE.tsv"
  "learning/PRODUCT_DEVELOPMENT_LANGUAGE.tsv"
  "learning/GIT_WORKFLOW_SETTINGS.tsv"
  "learning/GIT_HOOK_SETTINGS.tsv"
  "learning/context/WORKFLOW_CONTEXT_MAP.tsv"
  "learning/LEARNING_TASK_TRACKER.md"
  "learning/LEARNING_HANDOFF.md"
  "tools/check_lesson_structure.sh"
  "tools/check_document_organization.sh"
  "tools/check_learner_display.sh"
  "tools/check_repository_boundary.sh"
  "tools/check_agents_skills.sh"
  "tools/check_as_built_docs.sh"
  "tools/check_as_built_sync_contract.sh"
  "tools/check_test_plan_coverage.sh"
  "tools/check_security_invariants.sh"
  "tools/fixture-copy"
  "tools/check_workflow_pair_sync.sh"
  "tools/check_review_protocol.sh"
  "tools/check_developer_memory_requirements.sh"
  "tools/list_non_english_docs.sh"
  "tools/test_lesson.sh"
  "tools/test_lesson_repository.sh"
  "tools/test_product_gate_tools.sh"
  "tools/product-launch-check"
  "tools/test_product_launch_check.sh"
  "tools/product-scaffold-check"
  "tools/test_product_scaffold_check.sh"
  "tools/product-repository-authority"
  "tools/product-profile"
  "tools/product-repository-cleanup"
  "tools/test_product_repository_cleanup.sh"
  "tools/test_product_repository_authority.sh"
  "tools/test_product_security.sh"
  "tools/test_menu_prerequisites.sh"
  "tools/test_docs_tour.sh"
  "tools/test_as_built_sync_contract.sh"
  "tools/test_test_plan.sh"
  "tools/test_fixture_copy.sh"
  "tools/test_security_invariants.sh"
  "tools/test_git_workflow_policy.sh"
  "tools/test_git_hooks.sh"
  "docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv"
  "tools/test_lesson_start_position.sh"
  "tools/free-development"
  "tools/product-improvement"
  "tools/product-security"
  "tools/external-integration"
  "tools/team-development"
  "tools/menu"
  "tools/as-built-sync"
  "tools/test-plan"
  "tools/git-workflow"
  "tools/git-hooks"
  "tools/docs-tour"
  "tools/dashboard"
  "tools/dashboard-data"
  "tools/illustrations"
  "tools/test_lesson_playwright.sh"
  "tools/lib/lesson_common.sh"
  "tools/lib/dashboard_data.sh"
  "tools/lib/git_workflow_policy.sh"
  "tools/lib/git_hooks_policy.sh"
  "tools/lib/test_plan.sh"
  "tools/lib/fixture_copy.sh"
  "tools/lib/security_invariants.sh"
  "tools/lib/product_security.sh"
  "tools/lib/product_repository_authority.sh"
  "tools/lesson"
  "tools/learn"
  "illustrations/README.md"
  "illustrations/lesson14/index.tsv"
  "illustration-review/index.html"
)

misplaced_files=(
  "INDEX.md"
  "LESSON_GUIDE.md"
  "PROMPTS.md"
  "TEMPLATES.md"
  "AGENT_PLAYBOOK.md"
  "LESSON_FLOW.tsv"
  "LESSON_STATE.tsv"
  "LEARNING_TASK_TRACKER.md"
  "LEARNING_HANDOFF.md"
)

missing=0

for file in "${required_files[@]}"; do
  if [[ ! -f "$ROOT/$file" ]]; then
    printf 'missing: %s\n' "$file" >&2
    missing=1
  fi
done

for file in "${misplaced_files[@]}"; do
  if [[ -f "$ROOT/$file" ]]; then
    printf 'misplaced root file: %s\n' "$file" >&2
    missing=1
  fi
done

for script in "tools/check_lesson_structure.sh" "tools/check_document_organization.sh" "tools/check_learner_display.sh" "tools/check_repository_boundary.sh" "tools/check_agents_skills.sh" "tools/check_as_built_docs.sh" "tools/check_as_built_sync_contract.sh" "tools/check_test_plan_coverage.sh" "tools/check_security_invariants.sh" "tools/fixture-copy" "tools/check_workflow_pair_sync.sh" "tools/check_review_protocol.sh" "tools/check_developer_memory_requirements.sh" "tools/list_non_english_docs.sh" "tools/test_lesson.sh" "tools/test_lesson_repository.sh" "tools/test_product_gate_tools.sh" "tools/product-launch-check" "tools/test_product_launch_check.sh" "tools/product-scaffold-check" "tools/test_product_scaffold_check.sh" "tools/product-repository-authority" "tools/product-profile" "tools/product-repository-cleanup" "tools/test_product_repository_cleanup.sh" "tools/test_product_repository_authority.sh" "tools/test_product_security.sh" "tools/test_menu_prerequisites.sh" "tools/test_docs_tour.sh" "tools/test_as_built_sync_contract.sh" "tools/test_test_plan.sh" "tools/test_fixture_copy.sh" "tools/test_security_invariants.sh" "tools/test_git_workflow_policy.sh" "tools/test_git_hooks.sh" "tools/test_lesson_start_position.sh" "tools/test_lesson_playwright.sh" "tools/test_dashboard_schema.sh" "tools/test_dashboard_data.sh" "tools/test_dashboard_control_center.sh" "tools/free-development" "tools/product-improvement" "tools/product-security" "tools/external-integration" "tools/team-development" "tools/menu" "tools/as-built-sync" "tools/test-plan" "tools/git-workflow" "tools/git-hooks" "tools/docs-tour" "tools/dashboard" "tools/dashboard-data" "tools/dashboard-control-center" "tools/illustrations" "tools/lesson" "tools/learn"; do
  if [[ ! -x "$ROOT/$script" ]]; then
    printf 'not executable: %s\n' "$script" >&2
    missing=1
  fi
done

if [[ -d "$ROOT/$PRODUCT_REPO_NAME" ]]; then
  printf 'nested product repository is not allowed: %s/\n' "$PRODUCT_REPO_NAME" >&2
  missing=1
fi

if [[ -f "$ROOT/$PRODUCT_REPO_NAME" ]]; then
  printf 'unexpected file at product repository path: %s\n' "$PRODUCT_REPO_NAME" >&2
  missing=1
fi

if [[ -f "$FLOW" && -f "$STATE" ]]; then
  if ! awk -F '\t' '
    NR == FNR {
      if ($1 !~ /^#/) {
        flow_count++
        flow_order[flow_count] = $1
        flow_step[flow_count] = $2
        flow[$2] = $1
      }
      next
    }
    $1 !~ /^#/ {
      state_count++
      state_order[state_count] = $1
      state_step[state_count] = $2
      state_status[state_count] = $3

      if (state_count > flow_count) {
        printf "extra state row: %s %s\n", $1, $2 > "/dev/stderr"
        bad = 1
      } else {
        if ($1 != flow_order[state_count] || $2 != flow_step[state_count]) {
          printf "lesson state order mismatch at row %d: expected %s %s, got %s %s\n", state_count, flow_order[state_count], flow_step[state_count], $1, $2 > "/dev/stderr"
          bad = 1
        }
      }
      if (!($2 in flow)) {
        printf "state step not in flow: %s\n", $2 > "/dev/stderr"
        bad = 1
      }
      if ($3 != "current" && $3 != "locked" && $3 != "completed") {
        printf "invalid lesson state: %s %s\n", $2, $3 > "/dev/stderr"
        bad = 1
      }
      state[$2] = 1
      if ($3 == "current") current++
    }
    END {
      if (state_count != flow_count) {
        printf "lesson state row count mismatch: expected %d, got %d\n", flow_count, state_count > "/dev/stderr"
        bad = 1
      }
      for (step in flow) {
        if (!(step in state)) {
          printf "flow step missing in state: %s\n", step > "/dev/stderr"
          bad = 1
        }
      }
      phase = "completed"
      for (i = 1; i <= state_count; i++) {
        status = state_status[i]
        if (status == "completed") completed++
        if (status == "locked") locked++

        if (phase == "completed") {
          if (status == "current") {
            phase = "current"
          } else if (status == "locked") {
            phase = "locked"
          } else if (status != "completed") {
            bad = 1
          }
        } else if (phase == "current") {
          if (status == "locked") {
            phase = "locked"
          } else {
            printf "invalid lesson state order at %s: %s after current\n", state_step[i], status > "/dev/stderr"
            bad = 1
          }
        } else if (phase == "locked") {
          if (status != "locked") {
            printf "invalid lesson state order at %s: %s after locked\n", state_step[i], status > "/dev/stderr"
            bad = 1
          }
        }
      }
      if (current > 1) {
        printf "multiple current lesson steps: %d\n", current > "/dev/stderr"
        bad = 1
      }
      if (current == 0 && completed != state_count) {
        printf "missing current lesson step while unfinished steps remain\n" > "/dev/stderr"
        bad = 1
      }
      if (current == 1 && completed == state_count) {
        printf "current lesson step exists even though all steps are completed\n" > "/dev/stderr"
        bad = 1
      }
      exit bad
    }
  ' "$FLOW" "$STATE"; then
    missing=1
  fi
fi

validate_learning_mode_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    if ! awk -F '\t' '
      NR == 1 && $0 != "# selected_at\tmode\tdescription" {
        printf "invalid learning mode header in %s\n", FILENAME > "/dev/stderr"
        bad = 1
      }
      NR > 1 {
        count++
        if (NF != 3) {
          printf "invalid learning mode column count in %s: %d\n", FILENAME, NF > "/dev/stderr"
          bad = 1
        }
        if ($1 == "" || $2 == "" || $3 == "") {
          printf "empty learning mode field in %s\n", FILENAME > "/dev/stderr"
          bad = 1
        }
        if ($2 !~ /^[ABC]$/) {
          printf "invalid learning mode in %s: %s\n", FILENAME, $2 > "/dev/stderr"
          bad = 1
        }
      }
      END {
        if (count > 1) {
          printf "multiple learning mode records in %s: %d\n", FILENAME, count > "/dev/stderr"
          bad = 1
        }
        exit bad
      }
    ' "$file"; then
      missing=1
    fi
  fi
}

validate_language_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    if ! awk -F '\t' '
      NR == 1 && $0 != "# selected_at\tcode\tlabel" {
        printf "invalid language header in %s\n", FILENAME > "/dev/stderr"
        bad = 1
      }
      NR > 1 {
        count++
        if (NF != 3) {
          printf "invalid language column count in %s: %d\n", FILENAME, NF > "/dev/stderr"
          bad = 1
        }
        if ($1 == "" || $2 == "" || $3 == "") {
          printf "empty language field in %s\n", FILENAME > "/dev/stderr"
          bad = 1
        }
      }
      END {
        if (count > 1) {
          printf "multiple language records in %s: %d\n", FILENAME, count > "/dev/stderr"
          bad = 1
        }
        exit bad
      }
    ' "$file"; then
      missing=1
    fi
  fi
}

validate_learning_mode_file "$ROOT/learning/LESSON_MODE.tsv"
validate_language_file "$ROOT/learning/WORKFLOW_DISPLAY_LANGUAGE.tsv"
validate_language_file "$ROOT/learning/PRODUCT_DEVELOPMENT_LANGUAGE.tsv"

if [[ $missing -ne 0 ]]; then
  printf '\nLesson structure check failed.\n' >&2
  exit 1
fi

printf 'Lesson structure check passed.\n'
