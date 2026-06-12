#!/usr/bin/env bash

if [[ -z "${LESSON_ROOT:-}" ]]; then
  REPOSITORY_DEVELOPMENT_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # shellcheck source=lesson_common.sh
  source "$REPOSITORY_DEVELOPMENT_LIB_DIR/lesson_common.sh"
fi

repository_development_workflow_file() {
  printf '%s\n' "${REPOSITORY_DEVELOPMENT_WORKFLOW_FILE:-$LESSON_ROOT/docs/workflow/REPOSITORY_DEVELOPMENT_WORKFLOW.tsv}"
}

repository_development_approvals_file() {
  printf '%s\n' "${REPOSITORY_DEVELOPMENT_APPROVALS_FILE:-$LESSON_ROOT/learning/REPOSITORY_DEVELOPMENT_APPROVALS.tsv}"
}

repository_development_checks_file() {
  printf '%s\n' "${GIT_HOOKS_CHECKS_FILE:-$LESSON_ROOT/docs/workflow/GIT_HOOK_CHECKS.tsv}"
}

repository_development_trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

repository_development_expected_phases() {
  cat <<'PHASES'
1	context_triage
2	proposal
3	implementation_plan
4	fast_loop
5	mid_tests
6	release_gate
7	main_sync_cleanup
PHASES
}

repository_development_expected_order_for() {
  local phase_id="$1"
  repository_development_expected_phases | awk -F '\t' -v phase_id="$phase_id" '$2 == phase_id { print $1; found = 1 } END { exit found ? 0 : 1 }'
}

repository_development_phase_exists() {
  repository_development_expected_order_for "$1" >/dev/null 2>&1
}

repository_development_expected_approval_required_for() {
  local phase_id="$1"
  case "$phase_id" in
    context_triage|proposal|mid_tests)
      printf 'false\n'
      ;;
    implementation_plan|fast_loop|release_gate|main_sync_cleanup)
      printf 'true\n'
      ;;
    *)
      return 1
      ;;
  esac
}

repository_development_list_contains_token() {
  local list="$1"
  local expected="$2"
  local token
  IFS='|' read -r -a tokens <<<"$list"
  for token in "${tokens[@]}"; do
    token="$(repository_development_trim "$token")"
    if [[ "$token" == "$expected" ]]; then
      return 0
    fi
  done
  return 1
}

repository_development_policy_rows() {
  local policy_file
  policy_file="$(repository_development_workflow_file)"
  awk -F '\t' '
    /^[[:space:]]*$/ { next }
    $1 ~ /^#/ { next }
    {
      if (NF != 11) {
        printf "invalid repository development workflow row %d: expected 11 tab-separated fields.\n", NR > "/dev/stderr"
        invalid = 1
        next
      }
      print
    }
    END { exit invalid ? 1 : 0 }
  ' "$policy_file"
}

repository_development_collect_policy_rows() {
  local -n out_ref="$1"
  local tmp_file
  tmp_file="$(mktemp)"
  if ! repository_development_policy_rows >"$tmp_file"; then
    rm -f "$tmp_file"
    return 1
  fi
  mapfile -t out_ref <"$tmp_file"
  rm -f "$tmp_file"
}

repository_development_check_id_exists() {
  local check_id="$1"
  local checks_file
  [[ "$check_id" == "none" ]] && return 0
  checks_file="$(repository_development_checks_file)"
  awk -F '\t' -v check_id="$check_id" '
    /^[[:space:]]*$/ { next }
    $1 ~ /^#/ { next }
    $1 == check_id { found = 1; exit }
    END { exit found ? 0 : 1 }
  ' "$checks_file"
}

repository_development_validate_check_list() {
  local field_name="$1"
  local value="$2"
  local phase_id="$3"
  local missing=0
  local token

  if [[ "$value" == "none" ]]; then
    return 0
  fi

  IFS='|' read -r -a tokens <<<"$value"
  for token in "${tokens[@]}"; do
    token="$(repository_development_trim "$token")"
    if [[ -z "$token" ]]; then
      printf 'empty %s token for phase: %s\n' "$field_name" "$phase_id" >&2
      missing=1
    elif ! repository_development_check_id_exists "$token"; then
      printf 'unknown %s check id for phase %s: %s\n' "$field_name" "$phase_id" "$token" >&2
      missing=1
    fi
  done

  [[ "$missing" -eq 0 ]]
}

repository_development_reject_destructive_text() {
  local context="$1"
  local value="$2"
  if grep -Eq '(^|[[:space:]])rm[[:space:]]+-rf([[:space:]]|$)|git[[:space:]]+branch[[:space:]]+-D|git[[:space:]]+worktree[[:space:]]+remove|git[[:space:]]+push[[:space:]]+--delete|gh[[:space:]]+pr[[:space:]]+merge' <<<"$value"; then
    printf 'destructive executable guidance is not allowed in %s: %s\n' "$context" "$value" >&2
    return 1
  fi
}

repository_development_field_for_phase() {
  local phase_id="$1"
  local field_number="$2"
  repository_development_policy_rows | awk -F '\t' -v phase_id="$phase_id" -v field_number="$field_number" '
    $1 == phase_id { print $field_number; found = 1; exit }
    END { exit found ? 0 : 1 }
  '
}

repository_development_validate_approvals() {
  local approvals_file
  local missing=0
  local phase_id approval_scope required default_state description extra
  local expected_required expected_phase expected_default
  declare -A seen=()
  approvals_file="$(repository_development_approvals_file)"

  if [[ ! -f "$approvals_file" ]]; then
    printf 'missing repository development approvals file: %s\n' "$approvals_file" >&2
    return 1
  fi

  while IFS=$'\t' read -r phase_id approval_scope required default_state description extra; do
    [[ -n "${phase_id:-}" ]] || continue
    [[ "$phase_id" != \#* ]] || continue
    if [[ -n "${extra:-}" || -z "${approval_scope:-}" || -z "${required:-}" || -z "${default_state:-}" || -z "${description:-}" ]]; then
      printf 'invalid repository development approval row for phase: %s\n' "${phase_id:-unknown}" >&2
      missing=1
      continue
    fi
    if ! repository_development_phase_exists "$phase_id"; then
      printf 'unknown approval phase: %s\n' "$phase_id" >&2
      missing=1
      continue
    fi
    if [[ -n "${seen[$phase_id]+set}" ]]; then
      printf 'duplicate repository development approval phase: %s\n' "$phase_id" >&2
      missing=1
    fi
    seen[$phase_id]=1
    case "$required" in true|false) ;; *) printf 'invalid approval required value for %s: %s\n' "$phase_id" "$required" >&2; missing=1 ;; esac
    case "$default_state" in not_required|not_granted) ;; *) printf 'invalid approval default state for %s: %s\n' "$phase_id" "$default_state" >&2; missing=1 ;; esac
    expected_required="$(repository_development_expected_approval_required_for "$phase_id")" || {
      printf 'unknown expected approval phase: %s\n' "$phase_id" >&2
      missing=1
      continue
    }
    if [[ "$required" != "$expected_required" ]]; then
      printf 'invalid approval required value for %s: expected %s, got %s\n' "$phase_id" "$expected_required" "$required" >&2
      missing=1
    fi
    if [[ "$expected_required" == "true" ]]; then
      expected_default="not_granted"
    else
      expected_default="not_required"
    fi
    if [[ "$default_state" != "$expected_default" ]]; then
      printf 'invalid approval default state for %s: expected %s, got %s\n' "$phase_id" "$expected_default" "$default_state" >&2
      missing=1
    fi
  done <"$approvals_file"

  while IFS=$'\t' read -r _order expected_phase; do
    if [[ -z "${seen[$expected_phase]+set}" ]]; then
      printf 'missing repository development approval phase: %s\n' "$expected_phase" >&2
      missing=1
    fi
  done < <(repository_development_expected_phases)

  [[ "$missing" -eq 0 ]]
}

repository_development_validate_policy() {
  local policy_file checks_file
  local missing=0
  local row phase_id order purpose required_inputs allowed_writes recommended_checks required_checks git_ci_expectations approval_requirements cleanup_behavior stop_conditions
  local expected_order expected_phase
  local -a policy_rows=()
  declare -A seen=()

  policy_file="$(repository_development_workflow_file)"
  checks_file="$(repository_development_checks_file)"

  if [[ ! -f "$policy_file" ]]; then
    printf 'missing repository development workflow policy: %s\n' "$policy_file" >&2
    return 1
  fi
  if [[ ! -f "$checks_file" ]]; then
    printf 'missing Git hook checks file: %s\n' "$checks_file" >&2
    return 1
  fi

  repository_development_collect_policy_rows policy_rows || return 1

  for row in "${policy_rows[@]}"; do
    IFS=$'\t' read -r phase_id order purpose required_inputs allowed_writes recommended_checks required_checks git_ci_expectations approval_requirements cleanup_behavior stop_conditions <<<"$row"
    if [[ -z "$phase_id" || -z "$order" || -z "$purpose" || -z "$required_inputs" || -z "$allowed_writes" || -z "$recommended_checks" || -z "$required_checks" || -z "$git_ci_expectations" || -z "$approval_requirements" || -z "$cleanup_behavior" || -z "$stop_conditions" ]]; then
      printf 'empty repository development workflow field for phase: %s\n' "${phase_id:-unknown}" >&2
      missing=1
      continue
    fi
    if ! repository_development_phase_exists "$phase_id"; then
      printf 'unknown repository development phase: %s\n' "$phase_id" >&2
      missing=1
      continue
    fi
    if [[ -n "${seen[$phase_id]+set}" ]]; then
      printf 'duplicate repository development phase: %s\n' "$phase_id" >&2
      missing=1
    fi
    seen[$phase_id]=1
    expected_order="$(repository_development_expected_order_for "$phase_id")"
    if [[ "$order" != "$expected_order" ]]; then
      printf 'invalid order for phase %s: expected %s, got %s\n' "$phase_id" "$expected_order" "$order" >&2
      missing=1
    fi
    repository_development_validate_check_list "recommended_checks" "$recommended_checks" "$phase_id" || missing=1
    repository_development_validate_check_list "required_checks" "$required_checks" "$phase_id" || missing=1
    repository_development_reject_destructive_text "$phase_id fields" "$row" || missing=1
  done

  while IFS=$'\t' read -r _order expected_phase; do
    if [[ -z "${seen[$expected_phase]+set}" ]]; then
      printf 'missing repository development phase: %s\n' "$expected_phase" >&2
      missing=1
    fi
  done < <(repository_development_expected_phases)

  if ! repository_development_list_contains_token "$(repository_development_field_for_phase release_gate 7 2>/dev/null || true)" "test_lesson_repository"; then
    printf 'release_gate must require aggregate repository verification.\n' >&2
    missing=1
  fi
  if ! repository_development_list_contains_token "$(repository_development_field_for_phase release_gate 8 2>/dev/null || true)" "pr_ci_required"; then
    printf 'release_gate must require PR CI evidence.\n' >&2
    missing=1
  fi
  if ! repository_development_list_contains_token "$(repository_development_field_for_phase release_gate 8 2>/dev/null || true)" "full_hooks_required"; then
    printf 'release_gate must require full hooks evidence.\n' >&2
    missing=1
  fi
  if ! repository_development_list_contains_token "$(repository_development_field_for_phase release_gate 8 2>/dev/null || true)" "pre_commit_required"; then
    printf 'release_gate must require pre-commit evidence.\n' >&2
    missing=1
  fi
  if ! repository_development_list_contains_token "$(repository_development_field_for_phase main_sync_cleanup 8 2>/dev/null || true)" "main_ci_required"; then
    printf 'main_sync_cleanup must require main CI evidence.\n' >&2
    missing=1
  fi
  if ! repository_development_list_contains_token "$(repository_development_field_for_phase main_sync_cleanup 8 2>/dev/null || true)" "local_remote_sync_required"; then
    printf 'main_sync_cleanup must require local/remote sync.\n' >&2
    missing=1
  fi
  if ! repository_development_list_contains_token "$(repository_development_field_for_phase main_sync_cleanup 9 2>/dev/null || true)" "explicit_approval_required_for_merge_sync_cleanup"; then
    printf 'main_sync_cleanup must require explicit approval for merge, sync, and cleanup.\n' >&2
    missing=1
  fi
  if ! repository_development_list_contains_token "$(repository_development_field_for_phase main_sync_cleanup 10 2>/dev/null || true)" "approval_bound_plan_only_until_confirmed"; then
    printf 'main_sync_cleanup cleanup behavior must remain approval-bound plan-only until confirmed.\n' >&2
    missing=1
  fi

  repository_development_validate_approvals || missing=1
  [[ "$missing" -eq 0 ]]
}

repository_development_phase_row() {
  local phase_id="$1"
  repository_development_policy_rows | awk -F '\t' -v phase_id="$phase_id" '$1 == phase_id { print; found = 1; exit } END { exit found ? 0 : 1 }'
}

repository_development_print_phase() {
  local phase_id="$1"
  local row order purpose required_inputs allowed_writes recommended_checks required_checks git_ci_expectations approval_requirements cleanup_behavior stop_conditions
  row="$(repository_development_phase_row "$phase_id")" || {
    printf 'Unknown repository development phase: %s\n' "$phase_id" >&2
    return 1
  }
  IFS=$'\t' read -r _phase order purpose required_inputs allowed_writes recommended_checks required_checks git_ci_expectations approval_requirements cleanup_behavior stop_conditions <<<"$row"
  printf 'Phase: %s\n' "$phase_id"
  printf 'Order: %s\n' "$order"
  printf 'Purpose: %s\n' "$purpose"
  printf 'Required inputs: %s\n' "$required_inputs"
  printf 'Allowed writes: %s\n' "$allowed_writes"
  printf 'Recommended checks: %s\n' "$recommended_checks"
  printf 'Required checks: %s\n' "$required_checks"
  printf 'Git/CI expectations: %s\n' "$git_ci_expectations"
  printf 'Approval requirements: %s\n' "$approval_requirements"
  printf 'Cleanup behavior: %s\n' "$cleanup_behavior"
  printf 'Stop conditions: %s\n' "$stop_conditions"
}

repository_development_print_list() {
  repository_development_policy_rows | awk -F '\t' '
    BEGIN { printf "phase_id\torder\tpurpose\n" }
    { printf "%s\t%s\t%s\n", $1, $2, $3 }
  '
}

repository_development_print_guidance() {
  local phase_id="$1"
  repository_development_print_phase "$phase_id" || return 1
  printf 'Guidance: use recommended checks during implementation; use required checks before leaving this phase.\n'
  case "$phase_id" in
    fast_loop)
      printf 'Fast loop: do not treat focused checks as release proof.\n'
      ;;
    release_gate)
      printf 'Release gate: run aggregate/full proof and PR CI before merge.\n'
      ;;
    main_sync_cleanup)
      printf 'Main sync cleanup: merge, main CI, local/remote sync, and cleanup execution require explicit developer approval.\n'
      ;;
  esac
}
