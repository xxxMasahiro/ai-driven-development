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

lesson_normalize_learning_mode() {
  local mode="$1"
  case "$mode" in
    A|a)
      printf 'A\tじっくり説明'
      ;;
    B|b)
      printf 'B\tほどよく説明'
      ;;
    C|c)
      printf 'C\t手順だけ'
      ;;
    *)
      printf 'learning mode must be A, B, or C.\n' >&2
      exit 1
      ;;
  esac
}

lesson_current_learning_mode_file() {
  local file="$1"
  awk -F '\t' '$1 !~ /^#/ && $2 ~ /^[ABC]$/ { print $2; found=1; exit } END { exit found ? 0 : 1 }' "$file"
}

lesson_set_learning_mode_file() {
  local file="$1"
  local raw_mode="${2:-}"
  [[ -n "$raw_mode" ]] || { printf 'learning mode is required: A, B, or C.\n' >&2; exit 1; }
  local normalized mode description stamp
  normalized="$(lesson_normalize_learning_mode "$raw_mode")"
  mode="${normalized%%$'\t'*}"
  description="${normalized#*$'\t'}"
  stamp="$(date '+%Y-%m-%d %H:%M:%S')"
  printf '# selected_at\tmode\tdescription\n%s\t%s\t%s\n' "$stamp" "$mode" "$description" > "$file"
  printf 'Learning mode recorded: %s (%s)\n' "$mode" "$description"
}

lesson_show_learning_mode_file() {
  local file="$1"
  local current
  current="$(awk -F '\t' '$1 !~ /^#/ && $2 ~ /^[ABC]$/ { print $2 " (" $3 ")"; found=1; exit } END { exit found ? 0 : 1 }' "$file" || true)"
  if [[ -n "$current" ]]; then
    printf 'Current learning mode: %s\n' "$current"
  else
    printf 'Current learning mode: not selected\n'
  fi
}

lesson_normalize_language() {
  local raw="$1"
  case "$raw" in
    ja|JA|jp|JP|日本語|Japanese|japanese)
      printf 'ja\t日本語'
      ;;
    en|EN|英語|English|english)
      printf 'en\tEnglish'
      ;;
    ko|KO|韓国語|Korean|korean)
      printf 'ko\t한국어'
      ;;
    zh|ZH|中国語|Chinese|chinese)
      printf 'zh\t中文'
      ;;
    *)
      if [[ -n "$raw" ]]; then
        printf 'custom\t%s' "$raw"
      else
        printf 'language is required. Examples: ja, en, ko, zh.\n' >&2
        exit 1
      fi
      ;;
  esac
}

lesson_language_file_has_value() {
  local file="$1"
  [[ -f "$file" ]] || return 1
  awk -F '\t' '$1 !~ /^#/ && $2 != "" && $3 != "" { found=1; exit } END { exit found ? 0 : 1 }' "$file"
}

lesson_set_language_file() {
  local file="$1"
  local label="$2"
  local raw_language="${3:-}"
  local normalized code display stamp
  normalized="$(lesson_normalize_language "$raw_language")"
  code="${normalized%%$'\t'*}"
  display="${normalized#*$'\t'}"
  stamp="$(date '+%Y-%m-%d %H:%M:%S')"
  printf '# selected_at\tcode\tlabel\n%s\t%s\t%s\n' "$stamp" "$code" "$display" > "$file"
  printf '%s recorded: %s (%s)\n' "$label" "$code" "$display"
}

lesson_show_language_file() {
  local file="$1"
  local label="$2"
  local current
  current="$(awk -F '\t' '$1 !~ /^#/ && $2 != "" { print $2 " (" $3 ")"; found=1; exit } END { exit found ? 0 : 1 }' "$file" || true)"
  if [[ -n "$current" ]]; then
    printf 'Current %s: %s\n' "$label" "$current"
  else
    printf 'Current %s: not selected\n' "$label"
  fi
}

lesson_structure_check() {
  "$LESSON_ROOT/tools/check_lesson_structure.sh" >/dev/null
}
