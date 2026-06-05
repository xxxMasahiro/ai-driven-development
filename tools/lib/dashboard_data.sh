#!/usr/bin/env bash

if [[ -z "${LESSON_ROOT:-}" ]]; then
  DASHBOARD_DATA_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # shellcheck source=lesson_common.sh
  source "$DASHBOARD_DATA_LIB_DIR/lesson_common.sh"
fi

if ! declare -F git_workflow_policy_file >/dev/null 2>&1; then
  # shellcheck source=git_workflow_policy.sh
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/git_workflow_policy.sh"
fi

if ! declare -F product_security_policy_file >/dev/null 2>&1; then
  # shellcheck source=product_security.sh
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/product_security.sh"
fi

dashboard_data_schema_version() {
  printf '0.1.0'
}

dashboard_data_generated_at() {
  if [[ -n "${DASHBOARD_DATA_GENERATED_AT:-}" ]]; then
    printf '%s' "$DASHBOARD_DATA_GENERATED_AT"
  else
    date -u '+%Y-%m-%dT%H:%M:%SZ'
  fi
}

dashboard_data_strip_unsafe_control_chars() {
  local value="$1"
  local code char
  for code in 1 2 3 4 5 6 7 8 11 12 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31; do
    printf -v char "\\$(printf '%03o' "$code")"
    value="${value//$char/}"
  done
  printf '%s' "$value"
}

dashboard_data_safe_text() {
  local value="$1"
  value="$(dashboard_data_strip_unsafe_control_chars "$value")"
  value="${value//$'\r'/ }"
  value="${value//$'\n'/ }"
  value="${value//$'\t'/ }"

  if grep -Eiq '(SECRET|TOKEN|API_KEY|PASSWORD|PRIVATE_KEY)[[:space:]]*[:=][[:space:]]*[^[:space:]#]{8,}|gh[pousr]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY' <<<"$value"; then
    printf '[redacted secret-like data]'
    return
  fi

  printf '%s' "$value" | sed -E 's#(^|[[:space:]])/[^[:space:]]+#\1[absolute-path]#g'
}

dashboard_json_escape() {
  local value escaped
  value="$(dashboard_data_safe_text "$1")"
  value="$(dashboard_data_strip_unsafe_control_chars "$value")"
  escaped="${value//\\/\\\\}"
  escaped="${escaped//\"/\\\"}"
  escaped="${escaped//$'\r'/\\r}"
  escaped="${escaped//$'\n'/\\n}"
  escaped="${escaped//$'\t'/\\t}"
  printf '%s' "$escaped"
}

dashboard_json_string() {
  printf '"%s"' "$(dashboard_json_escape "$1")"
}

dashboard_json_bool() {
  case "$1" in
    true|false) printf '%s' "$1" ;;
    *) printf 'invalid JSON boolean: %s\n' "$1" >&2; return 1 ;;
  esac
}

dashboard_json_string_array() {
  local first=1
  local item
  printf '['
  for item in "$@"; do
    if [[ "$first" -eq 0 ]]; then
      printf ','
    fi
    first=0
    dashboard_json_string "$item"
  done
  printf ']'
}

dashboard_json_raw_array() {
  local first=1
  local item
  printf '['
  for item in "$@"; do
    if [[ "$first" -eq 0 ]]; then
      printf ','
    fi
    first=0
    printf '%s' "$item"
  done
  printf ']'
}

dashboard_data_allowed_state() {
  case "$1" in
    missing|ready|passed|failed|blocked|unknown|approval_required|optional|cached) return 0 ;;
  esac
  return 1
}

dashboard_data_validate_state() {
  dashboard_data_allowed_state "$1" || {
    printf 'invalid dashboard data state: %s\n' "$1" >&2
    return 1
  }
}

dashboard_data_validate_partial_status() {
  case "$1" in
    optional|failed|unknown) return 0 ;;
  esac
  printf 'invalid dashboard partial failure status: %s\n' "$1" >&2
  return 1
}

dashboard_data_validate_risk_level() {
  case "$1" in
    low|medium|high|critical) return 0 ;;
  esac
  printf 'invalid dashboard command risk level: %s\n' "$1" >&2
  return 1
}

dashboard_data_validate_execution_mode() {
  case "$1" in
    preview_only|manual_after_approval) return 0 ;;
  esac
  printf 'invalid dashboard command execution mode: %s\n' "$1" >&2
  return 1
}

dashboard_data_validate_guidance_surface() {
  case "$1" in
    lesson|workflow) return 0 ;;
  esac
  printf 'invalid dashboard guidance surface: %s\n' "$1" >&2
  return 1
}

dashboard_data_validate_guidance_audience() {
  case "$1" in
    non_engineer|engineer|all) return 0 ;;
  esac
  printf 'invalid dashboard guidance audience: %s\n' "$1" >&2
  return 1
}

dashboard_data_validate_guidance_priority() {
  case "$1" in
    info|attention|action) return 0 ;;
  esac
  printf 'invalid dashboard guidance priority: %s\n' "$1" >&2
  return 1
}

dashboard_json_partial_failure() {
  local source="$1"
  local status="$2"
  local reason="$3"
  local required_command="$4"
  dashboard_data_validate_partial_status "$status"
  printf '{"source":'
  dashboard_json_string "$source"
  printf ',"status":'
  dashboard_json_string "$status"
  printf ',"reason":'
  dashboard_json_string "$reason"
  printf ',"required_command":'
  dashboard_json_string "$required_command"
  printf '}'
}

dashboard_json_blocking_item() {
  local source="$1"
  local status="$2"
  local reason="$3"
  local required_command="$4"
  dashboard_data_validate_state "$status"
  printf '{"source":'
  dashboard_json_string "$source"
  printf ',"status":'
  dashboard_json_string "$status"
  printf ',"reason":'
  dashboard_json_string "$reason"
  printf ',"required_command":'
  dashboard_json_string "$required_command"
  printf '}'
}

dashboard_json_guidance_item() {
  local surface="$1"
  local audience="$2"
  local priority="$3"
  local message="$4"
  local related_command="$5"

  dashboard_data_validate_guidance_surface "$surface"
  dashboard_data_validate_guidance_audience "$audience"
  dashboard_data_validate_guidance_priority "$priority"

  printf '{"surface":'
  dashboard_json_string "$surface"
  printf ',"audience":'
  dashboard_json_string "$audience"
  printf ',"priority":'
  dashboard_json_string "$priority"
  printf ',"message":'
  dashboard_json_string "$message"
  printf ',"related_command":'
  dashboard_json_string "$related_command"
  printf '}'
}

dashboard_data_add_partial_failure() {
  local -n target_array="$1"
  shift
  target_array+=("$(dashboard_json_partial_failure "$@")")
}

dashboard_data_add_blocking_item() {
  local -n target_array="$1"
  shift
  target_array+=("$(dashboard_json_blocking_item "$@")")
}

dashboard_json_command_preview() {
  local intent="$1"
  local target="$2"
  local risk_level="$3"
  local requires_approval="$4"
  local approval_gate_id="$5"
  local command_text="$6"
  local execution_mode="$7"
  local non_executable="$8"
  shift 8

  dashboard_data_validate_risk_level "$risk_level"
  dashboard_json_bool "$requires_approval" >/dev/null
  dashboard_data_validate_execution_mode "$execution_mode"
  dashboard_json_bool "$non_executable" >/dev/null

  printf '{"intent":'
  dashboard_json_string "$intent"
  printf ',"target":'
  dashboard_json_string "$target"
  printf ',"risk_level":'
  dashboard_json_string "$risk_level"
  printf ',"requires_approval":'
  dashboard_json_bool "$requires_approval"
  printf ',"approval_gate_id":'
  dashboard_json_string "$approval_gate_id"
  printf ',"argv":'
  dashboard_json_string_array "$@"
  printf ',"command_text":'
  dashboard_json_string "$command_text"
  printf ',"execution_mode":'
  dashboard_json_string "$execution_mode"
  printf ',"non_executable":'
  dashboard_json_bool "$non_executable"
  printf '}'
}

dashboard_data_relative_path() {
  local path="$1"
  case "$path" in
    "$LESSON_ROOT"/*)
      printf '%s' "${path#$LESSON_ROOT/}"
      ;;
    /*)
      printf '[external-path]'
      ;;
    *)
      printf '%s' "$path"
      ;;
  esac
}

dashboard_data_file_state() {
  local relpath="$1"
  if [[ -f "$LESSON_ROOT/$relpath" ]]; then
    printf 'ready'
  else
    printf 'missing'
  fi
}

dashboard_data_current_lesson_step() {
  local state_file="$1"
  [[ -f "$state_file" ]] || return 1
  awk -F '\t' '$1 !~ /^#/ && $3 == "current" { print $2; found = 1; exit } END { exit found ? 0 : 1 }' "$state_file"
}

dashboard_data_lesson_all_completed() {
  local state_file="$1"
  [[ -f "$state_file" ]] || return 1
  awk -F '\t' '
    $1 !~ /^#/ {
      total++
      if ($3 == "completed") completed++
    }
    END {
      exit (total > 0 && completed == total) ? 0 : 1
    }
  ' "$state_file"
}

dashboard_data_lesson_state_file_from_config() {
  local config_file="$1"
  lesson_abs_path_from_config_file "$config_file" "$(lesson_config_get_from_file "$config_file" state_file "learning/LESSON_STATE.tsv")"
}

dashboard_data_lesson_setting_state() {
  local config_file="$1"
  local setting="$2"
  local file
  file="$(lesson_setting_file_from_config "$config_file" "$setting")"
  if lesson_setting_file_has_value "$setting" "$file"; then
    printf 'ready'
  else
    printf 'missing'
  fi
}

dashboard_data_latest_menu_setting_state() {
  local setting="$1"
  if lesson_menu_latest_setting_file "$setting" >/dev/null 2>&1; then
    printf 'ready'
  else
    printf 'missing'
  fi
}

dashboard_data_git_policy_status() {
  local policy_file
  local rows
  policy_file="$(git_workflow_policy_file)"
  [[ -f "$policy_file" ]] || { printf 'missing'; return; }
  if ! rows="$(git_workflow_policy_rows 2>/dev/null)"; then
    printf 'failed'
  elif [[ -n "$rows" ]]; then
    printf 'ready'
  else
    printf 'failed'
  fi
}

dashboard_data_git_settings_status() {
  local settings_file
  local policy_file
  local rows
  local key
  settings_file="$(git_workflow_settings_file)"
  [[ -f "$settings_file" ]] || { printf 'missing'; return; }
  policy_file="$(git_workflow_policy_file)"
  [[ -f "$policy_file" ]] || { printf 'missing'; return; }
  if ! rows="$(git_workflow_policy_rows 2>/dev/null)"; then
    printf 'failed'
    return
  fi
  [[ -n "$rows" ]] || { printf 'failed'; return; }
  while IFS=$'\t' read -r key _allowed _default _label _description; do
    if ! git_workflow_setting_value "$key" >/dev/null 2>&1; then
      printf 'failed'
      return
    fi
  done <<<"$rows"
  printf 'ready'
}

dashboard_data_product_security_policy_status() {
  [[ -f "$(product_security_policy_file)" ]] || { printf 'missing'; return; }
  [[ -f "$(product_security_context_map_file)" ]] || { printf 'missing'; return; }
  if product_security_validate_policy >/dev/null 2>&1; then
    printf 'ready'
  else
    printf 'failed'
  fi
}
