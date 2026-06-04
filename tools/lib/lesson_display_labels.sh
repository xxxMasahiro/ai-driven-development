#!/usr/bin/env bash

LESSON_DISPLAY_LABELS_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LESSON_DISPLAY_LABELS_ROOT="${LESSON_ROOT:-$(cd "$LESSON_DISPLAY_LABELS_LIB_DIR/../.." && pwd)}"
LESSON_DISPLAY_LABELS_FILE="${LESSON_DISPLAY_LABELS_FILE:-$LESSON_DISPLAY_LABELS_ROOT/docs/workflow/LESSON_DISPLAY_LABELS.tsv}"

lesson_display_labels_column_number() {
  case "$1" in
    learner_label) printf '2' ;;
    short_label) printf '3' ;;
    internal_alias) printf '4' ;;
    status_command) printf '5' ;;
    start_command) printf '6' ;;
    config_file) printf '7' ;;
    description) printf '8' ;;
    *)
      printf 'unknown lesson display label field: %s\n' "$1" >&2
      exit 1
      ;;
  esac
}

lesson_display_labels_normalize_course() {
  case "$1" in
    lesson_7|lesson-7|7|step-1-7|STEP1-7|STEP\ 1-7)
      printf 'lesson_7'
      ;;
    lesson_14|lesson-14|14|step-1-14|STEP1-14|STEP\ 1-14)
      printf 'lesson_14'
      ;;
    *)
      printf 'unknown lesson display label course: %s\n' "$1" >&2
      exit 1
      ;;
  esac
}

lesson_display_label_value() {
  local course raw_field field column default_value
  course="$(lesson_display_labels_normalize_course "$1")"
  raw_field="$2"
  default_value="${3:-}"
  column="$(lesson_display_labels_column_number "$raw_field")"

  if [[ ! -f "$LESSON_DISPLAY_LABELS_FILE" ]]; then
    if [[ -n "$default_value" ]]; then
      printf '%s' "$default_value"
      return
    fi
    printf 'missing lesson display labels file: %s\n' "$LESSON_DISPLAY_LABELS_FILE" >&2
    exit 1
  fi

  field="$(awk -F '\t' -v course="$course" -v column="$column" '
    $1 !~ /^#/ && $1 == course {
      print $column
      found = 1
      exit
    }
    END {
      exit found ? 0 : 1
    }
  ' "$LESSON_DISPLAY_LABELS_FILE" || true)"

  if [[ -n "$field" ]]; then
    printf '%s' "$field"
    return
  fi
  if [[ -n "$default_value" ]]; then
    printf '%s' "$default_value"
    return
  fi

  printf 'missing lesson display label value: %s %s\n' "$course" "$raw_field" >&2
  exit 1
}

lesson_display_label() {
  lesson_display_label_value "$1" learner_label
}

lesson_display_short_label() {
  lesson_display_label_value "$1" short_label
}

lesson_display_description() {
  lesson_display_label_value "$1" description
}

lesson_display_status_command() {
  lesson_display_label_value "$1" status_command
}

lesson_display_internal_alias() {
  lesson_display_label_value "$1" internal_alias
}
