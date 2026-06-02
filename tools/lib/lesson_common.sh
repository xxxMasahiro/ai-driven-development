#!/usr/bin/env bash

lesson_common_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LESSON_ROOT="${LESSON_ROOT:-$(cd "$lesson_common_dir/../.." && pwd)}"
LESSON_CONFIG="${LESSON_CONFIG:-$LESSON_ROOT/lesson/LESSON_CONFIG.tsv}"

lesson_config_get() {
  local key="$1"
  local default_value="${2:-}"

  if [[ ! -f "$LESSON_CONFIG" ]]; then
    printf '%s' "$default_value"
    return
  fi

  awk -F '\t' -v key="$key" -v default_value="$default_value" '
    $1 !~ /^#/ && $1 == key {
      print $2
      found = 1
      exit
    }
    END {
      if (!found) print default_value
    }
  ' "$LESSON_CONFIG"
}

lesson_expand_path() {
  local path="$1"
  case "$path" in
    '$HOME')
      printf '%s' "$HOME"
      ;;
    '$HOME'/*)
      printf '%s/%s' "$HOME" "${path#\$HOME/}"
      ;;
    "~")
      printf '%s' "$HOME"
      ;;
    "~"/*)
      printf '%s/%s' "$HOME" "${path#~/}"
      ;;
    *)
      printf '%s' "$path"
      ;;
  esac
}

lesson_abs_path() {
  local path="$1"
  path="$(lesson_expand_path "$path")"
  case "$path" in
    /*) printf '%s' "$path" ;;
    *) printf '%s/%s' "$LESSON_ROOT" "$path" ;;
  esac
}

lesson_project_root() {
  local configured
  configured="$(lesson_config_get project_root "")"
  if [[ -n "$configured" ]]; then
    lesson_expand_path "$configured"
  else
    dirname "$LESSON_ROOT"
  fi
}

lesson_product_repo_name() {
  lesson_config_get product_repo_name "task-tracker-repository"
}

lesson_product_repo_root() {
  printf '%s/%s' "$(lesson_project_root)" "$(lesson_product_repo_name)"
}

lesson_flow_file() {
  lesson_abs_path "$(lesson_config_get flow_file "lesson/LESSON_FLOW.tsv")"
}

lesson_state_file() {
  lesson_abs_path "$(lesson_config_get state_file "learning/LESSON_STATE.tsv")"
}

lesson_tracker_file() {
  lesson_abs_path "$(lesson_config_get learning_tracker_file "learning/LEARNING_TASK_TRACKER.md")"
}

lesson_handoff_file() {
  lesson_abs_path "$(lesson_config_get learning_handoff_file "learning/LEARNING_HANDOFF.md")"
}

lesson_approval_file() {
  lesson_abs_path "$(lesson_config_get approval_file "learning/LESSON_APPROVALS.tsv")"
}

lesson_learning_mode_file() {
  lesson_abs_path "$(lesson_config_get learning_mode_file "learning/LESSON_MODE.tsv")"
}

lesson_workflow_language_file() {
  lesson_abs_path "$(lesson_config_get workflow_language_file "learning/WORKFLOW_DISPLAY_LANGUAGE.tsv")"
}

lesson_product_language_file() {
  lesson_abs_path "$(lesson_config_get product_language_file "learning/PRODUCT_DEVELOPMENT_LANGUAGE.tsv")"
}

lesson_structure_check() {
  "$LESSON_ROOT/tools/check_lesson_structure.sh" >/dev/null
}
