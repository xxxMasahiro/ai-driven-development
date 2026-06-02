#!/usr/bin/env bash

lesson_runtime_name="${LESSON_RUNTIME_NAME:-lesson}"
lesson_runtime_flow="${LESSON_RUNTIME_FLOW:-$(lesson_flow_file)}"
lesson_runtime_state="${LESSON_RUNTIME_STATE:-$(lesson_state_file)}"
lesson_runtime_tracker="${LESSON_RUNTIME_TRACKER:-$(lesson_tracker_file)}"
lesson_runtime_handoff="${LESSON_RUNTIME_HANDOFF:-$(lesson_handoff_file)}"
lesson_runtime_approval="${LESSON_RUNTIME_APPROVAL:-}"
lesson_runtime_approval_required="${LESSON_RUNTIME_REQUIRE_APPROVAL:-0}"
lesson_runtime_check="${LESSON_RUNTIME_CHECK:-lesson_structure_check}"
lesson_runtime_before_pass="${LESSON_RUNTIME_BEFORE_PASS:-}"

lesson_runtime_usage() {
  cat <<USAGE
Usage:
  tools/$lesson_runtime_name 現在地
  tools/$lesson_runtime_name 一覧
  tools/$lesson_runtime_name 開始 <step_id>
  tools/$lesson_runtime_name 開始位置 <step_id> --confirm
  tools/$lesson_runtime_name 承認 <start|pass> <step_id> "承認メモ"
  tools/$lesson_runtime_name 通過 <step_id> "メモ"
  tools/$lesson_runtime_name 復習 <step_id>

Aliases:
  status, list, start, start-at, approve, pass, complete, revisit

Rules:
  - Only the current step can be started or passed.
  - A learner-selected start position requires the explicit --confirm flag.
  - When approval is required, start/pass needs a matching approval receipt first.
  - Future locked steps cannot be started or passed.
  - Completed steps can be revisited freely.
USAGE
}

lesson_runtime_require_files() {
  local file
  for file in "$lesson_runtime_flow" "$lesson_runtime_state" "$lesson_runtime_tracker" "$lesson_runtime_handoff"; do
    [[ -f "$file" ]] || { printf 'missing: %s\n' "$file" >&2; exit 1; }
  done
  if [[ "$lesson_runtime_approval_required" == "1" ]]; then
    [[ -n "$lesson_runtime_approval" ]] || { printf 'approval file is not configured.\n' >&2; exit 1; }
    [[ -f "$lesson_runtime_approval" ]] || { printf 'missing: %s\n' "$lesson_runtime_approval" >&2; exit 1; }
  fi
}

lesson_runtime_validate() {
  if declare -F "$lesson_runtime_check" >/dev/null 2>&1; then
    "$lesson_runtime_check" >/dev/null
  else
    "$lesson_runtime_check" >/dev/null
  fi
}

lesson_runtime_flow_field() {
  local step_id="$1"
  local field="$2"
  awk -F '\t' -v step="$step_id" -v field="$field" '
    $1 !~ /^#/ && $2 == step { print $field; found=1; exit }
    END { if (!found) exit 1 }
  ' "$lesson_runtime_flow"
}

lesson_runtime_state_field() {
  local step_id="$1"
  local field="$2"
  awk -F '\t' -v step="$step_id" -v field="$field" '
    $1 !~ /^#/ && $2 == step { print $field; found=1; exit }
    END { if (!found) exit 1 }
  ' "$lesson_runtime_state"
}

lesson_runtime_current_step() {
  awk -F '\t' '$1 !~ /^#/ && $3 == "current" { print $2; exit }' "$lesson_runtime_state"
}

lesson_runtime_next_step_after() {
  local step_id="$1"
  awk -F '\t' -v step="$step_id" '
    $1 !~ /^#/ {
      if (previous) { print $2; exit }
      if ($2 == step) previous = 1
    }
  ' "$lesson_runtime_flow"
}

lesson_runtime_step_exists() {
  local step_id="$1"
  awk -F '\t' -v step="$step_id" '$1 !~ /^#/ && $2 == step { found=1 } END { exit found ? 0 : 1 }' "$lesson_runtime_flow"
}

lesson_runtime_step_label() {
  local step_id="$1"
  local day title
  day="$(lesson_runtime_flow_field "$step_id" 3)"
  title="$(lesson_runtime_flow_field "$step_id" 4)"
  printf '%s / %s / %s' "$step_id" "$day" "$title"
}

lesson_runtime_require_step() {
  local step_id="$1"
  [[ -n "$step_id" ]] || { printf 'step_id is required.\n' >&2; lesson_runtime_usage; exit 1; }
  lesson_runtime_step_exists "$step_id" || { printf 'unknown step_id: %s\n' "$step_id" >&2; exit 1; }
}

lesson_runtime_normalize_approval_action() {
  local action="$1"
  case "$action" in
    start|開始)
      printf 'start'
      ;;
    pass|通過|完了|complete)
      printf 'pass'
      ;;
    *)
      printf 'approval action must be start or pass.\n' >&2
      exit 1
      ;;
  esac
}

lesson_runtime_has_approval() {
  local action="$1"
  local step_id="$2"
  [[ -n "$lesson_runtime_approval" && -f "$lesson_runtime_approval" ]] || return 1
  awk -F '\t' -v step="$step_id" -v action="$action" '
    $1 !~ /^#/ && $1 == step && $2 == action { found=1; exit }
    END { exit found ? 0 : 1 }
  ' "$lesson_runtime_approval"
}

lesson_runtime_enforce_approval() {
  local action="$1"
  local step_id="$2"
  [[ "$lesson_runtime_approval_required" == "1" ]] || return 0
  if lesson_runtime_has_approval "$action" "$step_id"; then
    return 0
  fi
  printf 'Approval required before this action.\n' >&2
  printf 'Run: ./tools/%s 承認 %s %s "ユーザーが次へ進むことを承認した"\n' "$lesson_runtime_name" "$action" "$step_id" >&2
  exit 1
}

lesson_runtime_approve_step() {
  local raw_action="$1"
  local step_id="$2"
  local stamp="$3"
  shift 3 || true
  local memo="${*:-}"
  [[ -n "$raw_action" ]] || { printf 'approval action is required.\n' >&2; lesson_runtime_usage; exit 1; }
  local action
  action="$(lesson_runtime_normalize_approval_action "$raw_action")"
  lesson_runtime_require_step "$step_id"
  [[ -n "$memo" ]] || { printf 'approval memo is required.\n' >&2; exit 1; }
  local state current
  state="$(lesson_runtime_state_field "$step_id" 3)"
  current="$(lesson_runtime_current_step)"
  if [[ "$state" != "current" ]]; then
    printf 'Blocked: approval can only be recorded for the current step.\n' >&2
    [[ -n "$current" ]] && printf 'Next required step: %s\n' "$(lesson_runtime_step_label "$current")" >&2
    exit 1
  fi
  if lesson_runtime_has_approval "$action" "$step_id"; then
    printf 'Approval already recorded for %s %s.\n' "$action" "$(lesson_runtime_step_label "$step_id")"
    return 0
  fi
  memo="${memo//$'\t'/ }"
  printf '%s\t%s\t%s\t%s\n' "$step_id" "$action" "$stamp" "$memo" >> "$lesson_runtime_approval"
  printf 'Approval recorded for %s %s.\n' "$action" "$(lesson_runtime_step_label "$step_id")"
}

lesson_runtime_append_tracker() {
  local kind="$1"
  local step_id="$2"
  local memo="$3"
  local stamp="$4"
  {
    printf '\n## %s\n\n' "$lesson_runtime_name 制御ログ: $stamp"
    printf '```text\n'
    printf '種別: %s\n' "$kind"
    printf '項目: %s\n' "$(lesson_runtime_step_label "$step_id")"
    printf '通過条件: %s\n' "$(lesson_runtime_flow_field "$step_id" 5)"
    printf '内容: %s\n' "$memo"
    printf '```\n'
  } >> "$lesson_runtime_tracker"
}

lesson_runtime_append_handoff() {
  local kind="$1"
  local step_id="$2"
  local memo="$3"
  local stamp="$4"
  local current
  current="$(lesson_runtime_current_step)"
  {
    printf '\n## %s\n\n' "$lesson_runtime_name 制御ハンドオフ: $stamp"
    printf '```text\n'
    printf '種別: %s\n' "$kind"
    printf '直近の項目: %s\n' "$(lesson_runtime_step_label "$step_id")"
    printf '通過条件: %s\n' "$(lesson_runtime_flow_field "$step_id" 5)"
    printf '内容: %s\n' "$memo"
    if [[ -n "$current" ]]; then
      printf '次に進める項目: %s\n' "$(lesson_runtime_step_label "$current")"
      printf '次回の最初の一問: %s を始めてよいですか？\n' "$(lesson_runtime_flow_field "$current" 4)"
    else
      printf '次に進める項目: すべて完了\n'
      printf '次回の最初の一問: 14日版レッスン全体をふりかえりますか？\n'
    fi
    printf '```\n'
  } >> "$lesson_runtime_handoff"
}

lesson_runtime_status() {
  local current completed total
  current="$(lesson_runtime_current_step)"
  completed="$(awk -F '\t' '$1 !~ /^#/ && $3 == "completed" { count++ } END { print count + 0 }' "$lesson_runtime_state")"
  total="$(awk -F '\t' '$1 !~ /^#/ { count++ } END { print count + 0 }' "$lesson_runtime_state")"
  printf '%s progress: %s/%s completed\n' "$lesson_runtime_name" "$completed" "$total"
  if [[ -n "$current" ]]; then
    printf 'Current step: %s\n' "$(lesson_runtime_step_label "$current")"
  else
    printf 'Current step: all steps completed\n'
  fi
  printf '\nUse:\n'
  printf '  ./tools/%s 開始 <step_id>\n' "$lesson_runtime_name"
  if [[ "$lesson_runtime_approval_required" == "1" ]]; then
    printf '  ./tools/%s 承認 <start|pass> <step_id> "承認メモ"\n' "$lesson_runtime_name"
  fi
  printf '  ./tools/%s 通過 <step_id> "メモ"\n' "$lesson_runtime_name"
  printf '  ./tools/%s 復習 <completed_step_id>\n' "$lesson_runtime_name"
}

lesson_runtime_list_steps() {
  awk -F '\t' '
    NR == FNR {
      if ($1 !~ /^#/) status[$2] = $3
      next
    }
    $1 !~ /^#/ {
      printf "%s\t%s\t%s\t%s\n", $2, status[$2], $3, $4
    }
  ' "$lesson_runtime_state" "$lesson_runtime_flow"
}

lesson_runtime_rewrite_state_for_start() {
  local step_id="$1"
  local stamp="$2"
  local tmp
  tmp="$(mktemp "$lesson_runtime_state.tmp.XXXXXX")"
  awk -F '\t' -v OFS='\t' -v step="$step_id" -v stamp="$stamp" '
    /^#/ { print; next }
    $2 == step && $3 == "current" && $4 == "" { $4 = stamp }
    { print }
  ' "$lesson_runtime_state" > "$tmp"
  mv "$tmp" "$lesson_runtime_state"
}

lesson_runtime_rewrite_state_for_pass() {
  local step_id="$1"
  local next_step="$2"
  local stamp="$3"
  local tmp
  tmp="$(mktemp "$lesson_runtime_state.tmp.XXXXXX")"
  awk -F '\t' -v OFS='\t' -v step="$step_id" -v next_step="$next_step" -v stamp="$stamp" '
    /^#/ { print; next }
    $2 == step {
      $3 = "completed"
      if ($4 == "") $4 = stamp
      $5 = stamp
      print
      next
    }
    next_step != "" && $2 == next_step && $3 == "locked" {
      $3 = "current"
      $4 = stamp
      print
      next
    }
    { print }
  ' "$lesson_runtime_state" > "$tmp"
  mv "$tmp" "$lesson_runtime_state"
}

lesson_runtime_rewrite_state_for_start_at() {
  local step_id="$1"
  local stamp="$2"
  local tmp
  tmp="$(mktemp "$lesson_runtime_state.tmp.XXXXXX")"
  awk -F '\t' -v OFS='\t' -v step="$step_id" -v stamp="$stamp" '
    /^#/ { print; next }
    $2 == step {
      phase = "after"
      $3 = "current"
      $4 = stamp
      $5 = ""
      print
      next
    }
    phase != "after" {
      $3 = "completed"
      if ($4 == "") $4 = stamp
      if ($5 == "") $5 = stamp
      print
      next
    }
    {
      $3 = "locked"
      $4 = ""
      $5 = ""
      print
    }
  ' "$lesson_runtime_state" > "$tmp"
  mv "$tmp" "$lesson_runtime_state"
}

lesson_runtime_clear_approvals() {
  [[ "$lesson_runtime_approval_required" == "1" ]] || return 0
  [[ -n "$lesson_runtime_approval" ]] || return 0
  printf '# step_id\taction\tapproved_at\tmemo\n' > "$lesson_runtime_approval"
}

lesson_runtime_start_step() {
  local step_id="$1"
  local stamp="$2"
  lesson_runtime_require_step "$step_id"
  local state current
  state="$(lesson_runtime_state_field "$step_id" 3)"
  current="$(lesson_runtime_current_step)"
  case "$state" in
    current)
      lesson_runtime_enforce_approval "start" "$step_id"
      lesson_runtime_rewrite_state_for_start "$step_id" "$stamp"
      lesson_runtime_append_tracker "開始" "$step_id" "順番どおり現在の項目を開始した。" "$stamp"
      lesson_runtime_append_handoff "開始" "$step_id" "この項目から進行中。" "$stamp"
      printf 'Started current step: %s\n' "$(lesson_runtime_step_label "$step_id")"
      ;;
    completed)
      printf 'Revisit allowed: %s\n' "$(lesson_runtime_step_label "$step_id")"
      ;;
    locked)
      printf 'Blocked: this step is locked and cannot be skipped.\n' >&2
      [[ -n "$current" ]] && printf 'Next required step: %s\n' "$(lesson_runtime_step_label "$current")" >&2
      exit 1
      ;;
    *)
      printf 'invalid state for %s: %s\n' "$step_id" "$state" >&2
      exit 1
      ;;
  esac
}

lesson_runtime_start_at_step() {
  local step_id="$1"
  local stamp="$2"
  local confirm="${3:-}"
  lesson_runtime_require_step "$step_id"
  if [[ "$confirm" != "--confirm" ]]; then
    printf 'Start position changes require explicit confirmation.\n' >&2
    printf 'Run: ./tools/%s 開始位置 %s --confirm\n' "$lesson_runtime_name" "$step_id" >&2
    exit 1
  fi
  lesson_runtime_rewrite_state_for_start_at "$step_id" "$stamp"
  lesson_runtime_clear_approvals
  lesson_runtime_append_tracker "開始位置" "$step_id" "学習者がこの項目から開始することを選択した。" "$stamp"
  lesson_runtime_append_handoff "開始位置" "$step_id" "学習者指定により、この項目を現在地に設定した。" "$stamp"
  printf 'Start position set to: %s\n' "$(lesson_runtime_step_label "$step_id")"
}

lesson_runtime_pass_step() {
  local step_id="$1"
  local stamp="$2"
  shift 2 || true
  lesson_runtime_require_step "$step_id"
  local memo="${*:-}"
  if [[ -z "$memo" ]]; then
    printf 'pass memo is required. Required output: %s\n' "$(lesson_runtime_flow_field "$step_id" 5)" >&2
    exit 1
  fi
  local state current next
  state="$(lesson_runtime_state_field "$step_id" 3)"
  current="$(lesson_runtime_current_step)"
  next="$(lesson_runtime_next_step_after "$step_id")"
  case "$state" in
    current)
      lesson_runtime_enforce_approval "pass" "$step_id"
      if [[ -n "$lesson_runtime_before_pass" ]]; then
        "$lesson_runtime_before_pass" "$step_id" "$memo"
      fi
      lesson_runtime_rewrite_state_for_pass "$step_id" "$next" "$stamp"
      lesson_runtime_append_tracker "通過" "$step_id" "$memo" "$stamp"
      lesson_runtime_append_handoff "通過" "$step_id" "$memo" "$stamp"
      printf 'Passed step: %s\n' "$(lesson_runtime_step_label "$step_id")"
      current="$(lesson_runtime_current_step)"
      if [[ -n "$current" ]]; then
        printf 'Next required step: %s\n' "$(lesson_runtime_step_label "$current")"
      else
        printf 'All lesson steps completed.\n'
      fi
      ;;
    completed)
      printf 'Already completed. Revisit is allowed: %s\n' "$(lesson_runtime_step_label "$step_id")"
      ;;
    locked)
      printf 'Blocked: this step is locked and cannot be passed before earlier steps.\n' >&2
      [[ -n "$current" ]] && printf 'Next required step: %s\n' "$(lesson_runtime_step_label "$current")" >&2
      exit 1
      ;;
    *)
      printf 'invalid state for %s: %s\n' "$step_id" "$state" >&2
      exit 1
      ;;
  esac
}

lesson_runtime_revisit_step() {
  local step_id="$1"
  local stamp="$2"
  lesson_runtime_require_step "$step_id"
  local state current
  state="$(lesson_runtime_state_field "$step_id" 3)"
  current="$(lesson_runtime_current_step)"
  if [[ "$state" == "completed" ]]; then
    lesson_runtime_append_tracker "復習" "$step_id" "完了済み項目を再確認した。" "$stamp"
    lesson_runtime_append_handoff "復習" "$step_id" "完了済み項目を再確認。現在の進行位置は変更しない。" "$stamp"
    printf 'Revisit allowed: %s\n' "$(lesson_runtime_step_label "$step_id")"
    [[ -n "$current" ]] && printf 'Current required step remains: %s\n' "$(lesson_runtime_step_label "$current")"
  else
    printf 'Blocked: only completed steps can be revisited freely.\n' >&2
    [[ -n "$current" ]] && printf 'Next required step: %s\n' "$(lesson_runtime_step_label "$current")" >&2
    exit 1
  fi
}

lesson_runtime_main() {
  local command="${1:-}"
  [[ $# -gt 0 ]] && shift || true
  local stamp
  stamp="$(date '+%Y-%m-%d %H:%M:%S')"
  lesson_runtime_require_files
  lesson_runtime_validate
  case "$command" in
    現在地|status)
      lesson_runtime_status
      ;;
    一覧|list)
      lesson_runtime_list_steps
      ;;
    開始|start)
      lesson_runtime_start_step "${1:-}" "$stamp"
      ;;
    開始位置|start-at)
      lesson_runtime_start_at_step "${1:-}" "$stamp" "${2:-}"
      ;;
    承認|approve)
      local raw_action="${1:-}"
      local step="${2:-}"
      [[ $# -ge 2 ]] && shift 2 || true
      lesson_runtime_approve_step "$raw_action" "$step" "$stamp" "$@"
      ;;
    通過|完了|pass|complete)
      local step="${1:-}"
      [[ $# -gt 0 ]] && shift || true
      lesson_runtime_pass_step "$step" "$stamp" "$@"
      ;;
    復習|revisit)
      lesson_runtime_revisit_step "${1:-}" "$stamp"
      ;;
    ""|-h|--help|help)
      lesson_runtime_usage
      ;;
    *)
      printf 'unknown command: %s\n' "$command" >&2
      lesson_runtime_usage
      exit 1
      ;;
  esac
}
