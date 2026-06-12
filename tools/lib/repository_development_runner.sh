#!/usr/bin/env bash

REPOSITORY_DEVELOPMENT_RUNNER_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! declare -F repository_development_workflow_file >/dev/null 2>&1; then
  # shellcheck source=repository_development_workflow.sh
  source "$REPOSITORY_DEVELOPMENT_RUNNER_LIB_DIR/repository_development_workflow.sh"
fi

repository_development_runner_policy_file() {
  printf '%s\n' "${REPOSITORY_DEVELOPMENT_RUNNER_POLICY_FILE:-$LESSON_ROOT/docs/workflow/REPOSITORY_DEVELOPMENT_RUNNER_POLICY.tsv}"
}

repository_development_runner_records_dir() {
  printf '%s\n' "${REPOSITORY_DEVELOPMENT_RUNNER_RECORDS_DIR:-$LESSON_ROOT/.repository-development-runs}"
}

repository_development_runner_records_file() {
  printf '%s\n' "$(repository_development_runner_records_dir)/records.tsv"
}

repository_development_runner_policy_rows() {
  local policy_file
  policy_file="$(repository_development_runner_policy_file)"
  awk -F '\t' '
    /^[[:space:]]*$/ { next }
    $1 ~ /^#/ { next }
    {
      if (NF != 10) {
        printf "invalid repository development runner policy row %d: expected 10 tab-separated fields.\n", NR > "/dev/stderr"
        invalid = 1
        next
      }
      print
    }
    END { exit invalid ? 1 : 0 }
  ' "$policy_file"
}

repository_development_runner_field_for_phase() {
  local phase_id="$1"
  local field_number="$2"
  repository_development_runner_policy_rows | awk -F '\t' -v phase_id="$phase_id" -v field_number="$field_number" '
    $1 == phase_id { print $field_number; found = 1; exit }
    END { exit found ? 0 : 1 }
  '
}

repository_development_runner_validate_bool() {
  local field_name="$1"
  local value="$2"
  local phase_id="$3"
  case "$value" in
    true|false) return 0 ;;
    *)
      printf 'invalid runner %s for phase %s: %s\n' "$field_name" "$phase_id" "$value" >&2
      return 1
      ;;
  esac
}

repository_development_runner_validate_policy() {
  local policy_file
  local missing=0
  local row phase_id order execution_mode executable_check_sets record_required reuse_allowed approval_required release_policy destructive_execution stop_policy
  local expected_order expected_phase expected_approval
  local -a rows=()
  declare -A seen=()

  policy_file="$(repository_development_runner_policy_file)"
  if [[ ! -f "$policy_file" ]]; then
    printf 'missing repository development runner policy: %s\n' "$policy_file" >&2
    return 1
  fi

  mapfile -t rows < <(repository_development_runner_policy_rows) || return 1

  for row in "${rows[@]}"; do
    IFS=$'\t' read -r phase_id order execution_mode executable_check_sets record_required reuse_allowed approval_required release_policy destructive_execution stop_policy <<<"$row"
    if [[ -z "$phase_id" || -z "$order" || -z "$execution_mode" || -z "$executable_check_sets" || -z "$record_required" || -z "$reuse_allowed" || -z "$approval_required" || -z "$release_policy" || -z "$destructive_execution" || -z "$stop_policy" ]]; then
      printf 'empty repository development runner policy field for phase: %s\n' "${phase_id:-unknown}" >&2
      missing=1
      continue
    fi
    if ! repository_development_phase_exists "$phase_id"; then
      printf 'unknown repository development runner phase: %s\n' "$phase_id" >&2
      missing=1
      continue
    fi
    if [[ -n "${seen[$phase_id]+set}" ]]; then
      printf 'duplicate repository development runner phase: %s\n' "$phase_id" >&2
      missing=1
    fi
    seen[$phase_id]=1
    expected_order="$(repository_development_expected_order_for "$phase_id")"
    if [[ "$order" != "$expected_order" ]]; then
      printf 'invalid runner order for phase %s: expected %s, got %s\n' "$phase_id" "$expected_order" "$order" >&2
      missing=1
    fi
    case "$execution_mode" in plan_only|local_checks) ;; *) printf 'invalid runner execution_mode for phase %s: %s\n' "$phase_id" "$execution_mode" >&2; missing=1 ;; esac
    case "$executable_check_sets" in none|recommended|required|recommended\|required) ;; *) printf 'invalid runner executable_check_sets for phase %s: %s\n' "$phase_id" "$executable_check_sets" >&2; missing=1 ;; esac
    repository_development_runner_validate_bool record_required "$record_required" "$phase_id" || missing=1
    repository_development_runner_validate_bool reuse_allowed "$reuse_allowed" "$phase_id" || missing=1
    repository_development_runner_validate_bool approval_required "$approval_required" "$phase_id" || missing=1
    repository_development_runner_validate_bool destructive_execution "$destructive_execution" "$phase_id" || missing=1
    case "$release_policy" in no_release_proof|strict_release_proof|strict_main_sync_proof) ;; *) printf 'invalid runner release_policy for phase %s: %s\n' "$phase_id" "$release_policy" >&2; missing=1 ;; esac
    if [[ "$destructive_execution" != "false" ]]; then
      printf 'runner destructive execution must remain false for phase %s.\n' "$phase_id" >&2
      missing=1
    fi
    expected_approval="$(repository_development_expected_approval_required_for "$phase_id")" || {
      printf 'unknown runner approval phase: %s\n' "$phase_id" >&2
      missing=1
      continue
    }
    if [[ "$approval_required" != "$expected_approval" ]]; then
      printf 'invalid runner approval_required for %s: expected %s, got %s\n' "$phase_id" "$expected_approval" "$approval_required" >&2
      missing=1
    fi
    if [[ "$execution_mode" == "plan_only" && "$executable_check_sets" != "none" ]]; then
      printf 'plan-only runner phase must not declare executable check sets: %s\n' "$phase_id" >&2
      missing=1
    fi
    if [[ "$execution_mode" == "local_checks" && "$record_required" != "true" ]]; then
      printf 'local-check runner phase must require records: %s\n' "$phase_id" >&2
      missing=1
    fi
    repository_development_reject_destructive_text "$phase_id runner policy" "$row" || missing=1
  done

  while IFS=$'\t' read -r _order expected_phase; do
    if [[ -z "${seen[$expected_phase]+set}" ]]; then
      printf 'missing repository development runner phase: %s\n' "$expected_phase" >&2
      missing=1
    fi
  done < <(repository_development_expected_phases)

  [[ "$missing" -eq 0 ]]
}

repository_development_runner_check_set_allowed() {
  local phase_id="$1"
  local check_set="$2"
  local allowed
  allowed="$(repository_development_runner_field_for_phase "$phase_id" 4)"
  [[ "$allowed" != "none" ]] || return 1
  repository_development_list_contains_token "$allowed" "$check_set"
}

repository_development_runner_check_ids_for_phase() {
  local phase_id="$1"
  local check_set="$2"
  local field_number
  case "$check_set" in
    recommended) field_number=6 ;;
    required) field_number=7 ;;
    *)
      printf 'unknown runner check set: %s\n' "$check_set" >&2
      return 1
      ;;
  esac
  repository_development_field_for_phase "$phase_id" "$field_number"
}

repository_development_runner_check_command() {
  local check_id="$1"
  local checks_file
  checks_file="$(repository_development_checks_file)"
  awk -F '\t' -v check_id="$check_id" '
    /^[[:space:]]*$/ { next }
    $1 ~ /^#/ { next }
    $1 == check_id { print $3; found = 1; exit }
    END { exit found ? 0 : 1 }
  ' "$checks_file"
}

repository_development_runner_validate_command() {
  local check_id="$1"
  local command="$2"
  if [[ -z "$command" || "$command" == "none" ]]; then
    printf 'runner check has no executable command: %s\n' "$check_id" >&2
    return 1
  fi
  if [[ "$command" != ./"tools/"* ]]; then
    printf 'runner command must start with ./tools/ for check %s: %s\n' "$check_id" "$command" >&2
    return 1
  fi
  if grep -Eq '[;&|<>`$(){}]' <<<"$command"; then
    printf 'runner command contains shell metacharacters for check %s: %s\n' "$check_id" "$command" >&2
    return 1
  fi
  repository_development_reject_destructive_text "runner command $check_id" "$command"
}

repository_development_runner_current_head() {
  git -C "$LESSON_ROOT" rev-parse --verify HEAD 2>/dev/null || printf 'unknown'
}

repository_development_runner_hash_stream() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum | awk '{ print $1 }'
  else
    cksum | awk '{ print $1 "-" $2 }'
  fi
}

repository_development_runner_policy_fingerprint() {
  local file
  {
    for file in \
      "$(repository_development_workflow_file)" \
      "$(repository_development_runner_policy_file)" \
      "$(repository_development_approvals_file)" \
      "$(repository_development_checks_file)"; do
      printf 'FILE\t%s\n' "$file"
      if [[ -f "$file" ]]; then
        if command -v sha256sum >/dev/null 2>&1; then
          sha256sum "$file"
        else
          cksum "$file"
        fi
      else
        printf 'MISSING\t%s\n' "$file"
      fi
    done
  } | repository_development_runner_hash_stream
}

repository_development_runner_input_fingerprint() {
  {
    repository_development_runner_current_head
    git -C "$LESSON_ROOT" status --porcelain=v1 --untracked-files=normal 2>/dev/null || true
  } | repository_development_runner_hash_stream
}

repository_development_runner_sanitize_field() {
  tr '\t\r\n' '   ' | awk '{ gsub(/[[:space:]][[:space:]]+/, " "); sub(/^ /, ""); sub(/ $/, ""); print substr($0, 1, 500) }'
}

repository_development_runner_worktree_summary() {
  local summary
  summary="$(git -C "$LESSON_ROOT" status --short --untracked-files=normal 2>/dev/null | repository_development_runner_sanitize_field)"
  if [[ -n "$summary" ]]; then
    printf '%s' "$summary"
  else
    printf 'clean'
  fi
}

repository_development_runner_ensure_records_file() {
  local records_dir records_file
  records_dir="$(repository_development_runner_records_dir)"
  records_file="$(repository_development_runner_records_file)"
  mkdir -p "$records_dir"
  if [[ ! -f "$records_file" ]]; then
    printf 'started_at\tfinished_at\tphase_id\tcheck_id\tcommand\texit_status\tresult\thead\tpolicy_fingerprint\tinput_fingerprint\tworktree_summary\n' >"$records_file"
  fi
}

repository_development_runner_append_record() {
  local started_at="$1"
  local finished_at="$2"
  local phase_id="$3"
  local check_id="$4"
  local command="$5"
  local exit_status="$6"
  local result="$7"
  local head policy_fingerprint input_fingerprint worktree_summary
  head="$(repository_development_runner_current_head | repository_development_runner_sanitize_field)"
  policy_fingerprint="$(repository_development_runner_policy_fingerprint | repository_development_runner_sanitize_field)"
  input_fingerprint="$(repository_development_runner_input_fingerprint | repository_development_runner_sanitize_field)"
  worktree_summary="$(repository_development_runner_worktree_summary | repository_development_runner_sanitize_field)"
  command="$(printf '%s' "$command" | repository_development_runner_sanitize_field)"
  repository_development_runner_ensure_records_file
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$started_at" "$finished_at" "$phase_id" "$check_id" "$command" "$exit_status" "$result" "$head" "$policy_fingerprint" "$input_fingerprint" "$worktree_summary" \
    >>"$(repository_development_runner_records_file)"
}

repository_development_runner_reusable_pass_exists() {
  local phase_id="$1"
  local check_id="$2"
  local records_file head policy_fingerprint input_fingerprint
  records_file="$(repository_development_runner_records_file)"
  [[ -f "$records_file" ]] || return 1
  head="$(repository_development_runner_current_head)"
  policy_fingerprint="$(repository_development_runner_policy_fingerprint)"
  input_fingerprint="$(repository_development_runner_input_fingerprint)"
  awk -F '\t' -v phase_id="$phase_id" -v check_id="$check_id" -v head="$head" -v policy="$policy_fingerprint" -v input="$input_fingerprint" '
    $3 == phase_id && $4 == check_id && $6 == "0" && $7 == "pass" && $8 == head && $9 == policy && $10 == input { found = 1 }
    END { exit found ? 0 : 1 }
  ' "$records_file"
}

repository_development_runner_print_plan() {
  local phase_id="$1"
  local check_set="$2"
  local execution_mode approval_required reuse_allowed release_policy check_ids check_id command
  repository_development_validate_policy
  repository_development_runner_validate_policy
  repository_development_print_phase "$phase_id"
  execution_mode="$(repository_development_runner_field_for_phase "$phase_id" 3)"
  approval_required="$(repository_development_runner_field_for_phase "$phase_id" 7)"
  reuse_allowed="$(repository_development_runner_field_for_phase "$phase_id" 6)"
  release_policy="$(repository_development_runner_field_for_phase "$phase_id" 8)"
  printf 'Runner mode: %s\n' "$execution_mode"
  printf 'Runner check set: %s\n' "$check_set"
  printf 'Runner approval required: %s\n' "$approval_required"
  printf 'Runner reuse allowed: %s\n' "$reuse_allowed"
  printf 'Runner release policy: %s\n' "$release_policy"
  printf 'Runner records file: %s\n' "$(repository_development_runner_records_file)"
  if [[ "$execution_mode" != "local_checks" ]]; then
    printf 'Runner execution: plan-only for this phase; use owner commands and approval gates for proof.\n'
    return 0
  fi
  if ! repository_development_runner_check_set_allowed "$phase_id" "$check_set"; then
    printf 'Runner execution: check set is not executable for this phase.\n'
    return 0
  fi
  check_ids="$(repository_development_runner_check_ids_for_phase "$phase_id" "$check_set")"
  printf 'Runner commands:\n'
  IFS='|' read -r -a check_tokens <<<"$check_ids"
  for check_id in "${check_tokens[@]}"; do
    check_id="$(repository_development_trim "$check_id")"
    [[ -n "$check_id" && "$check_id" != "none" ]] || continue
    command="$(repository_development_runner_check_command "$check_id")" || {
      printf '  - %s: missing command\n' "$check_id"
      continue
    }
    printf '  - %s: %s\n' "$check_id" "$command"
  done
}

repository_development_runner_execute() {
  local phase_id="$1"
  local check_set="$2"
  local approved="$3"
  local use_reuse="$4"
  local execution_mode approval_required reuse_allowed check_ids check_id command started_at finished_at exit_status result
  local -a command_parts=()
  repository_development_validate_policy
  repository_development_runner_validate_policy
  execution_mode="$(repository_development_runner_field_for_phase "$phase_id" 3)"
  approval_required="$(repository_development_runner_field_for_phase "$phase_id" 7)"
  reuse_allowed="$(repository_development_runner_field_for_phase "$phase_id" 6)"
  if [[ "$execution_mode" != "local_checks" ]]; then
    printf 'runner execution is plan-only for phase: %s\n' "$phase_id" >&2
    return 1
  fi
  if ! repository_development_runner_check_set_allowed "$phase_id" "$check_set"; then
    printf 'runner check set is not executable for phase %s: %s\n' "$phase_id" "$check_set" >&2
    return 1
  fi
  if [[ "$approval_required" == "true" && "$approved" != "true" ]]; then
    printf 'runner execution for phase %s requires --approved.\n' "$phase_id" >&2
    return 1
  fi
  check_ids="$(repository_development_runner_check_ids_for_phase "$phase_id" "$check_set")"
  IFS='|' read -r -a check_tokens <<<"$check_ids"
  for check_id in "${check_tokens[@]}"; do
    check_id="$(repository_development_trim "$check_id")"
    [[ -n "$check_id" && "$check_id" != "none" ]] || continue
    command="$(repository_development_runner_check_command "$check_id")"
    repository_development_runner_validate_command "$check_id" "$command"
    if [[ "$reuse_allowed" == "true" && "$use_reuse" == "true" ]] && repository_development_runner_reusable_pass_exists "$phase_id" "$check_id"; then
      printf 'reuse: %s\n' "$check_id"
      continue
    fi
    printf 'run: %s\n' "$check_id"
    read -r -a command_parts <<<"$command"
    started_at="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
    set +e
    (cd "$LESSON_ROOT" && "${command_parts[@]}")
    exit_status=$?
    set -e
    finished_at="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
    if [[ "$exit_status" -eq 0 ]]; then
      result="pass"
    else
      result="fail"
    fi
    repository_development_runner_append_record "$started_at" "$finished_at" "$phase_id" "$check_id" "$command" "$exit_status" "$result"
    if [[ "$exit_status" -ne 0 ]]; then
      return "$exit_status"
    fi
  done
  printf 'Runner execution passed for phase %s (%s).\n' "$phase_id" "$check_set"
}

repository_development_runner_record_manual() {
  local phase_id="$1"
  local check_id="$2"
  local result="$3"
  local exit_status="$4"
  local command now
  repository_development_validate_policy
  repository_development_runner_validate_policy
  repository_development_phase_exists "$phase_id" || {
    printf 'unknown repository development phase: %s\n' "$phase_id" >&2
    return 1
  }
  repository_development_check_id_exists "$check_id" || {
    printf 'unknown runner check id: %s\n' "$check_id" >&2
    return 1
  }
  case "$result" in pass|fail|skipped) ;; *) printf 'runner result must be pass, fail, or skipped: %s\n' "$result" >&2; return 1 ;; esac
  [[ "$exit_status" =~ ^[0-9]+$ ]] || {
    printf 'runner exit status must be numeric: %s\n' "$exit_status" >&2
    return 1
  }
  command="$(repository_development_runner_check_command "$check_id")"
  repository_development_runner_validate_command "$check_id" "$command"
  now="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  repository_development_runner_append_record "$now" "$now" "$phase_id" "$check_id" "$command" "$exit_status" "$result"
  printf 'Runner record written: %s %s %s\n' "$phase_id" "$check_id" "$result"
}

repository_development_runner_print_records() {
  local records_file
  records_file="$(repository_development_runner_records_file)"
  printf 'Runner records file: %s\n' "$records_file"
  if [[ ! -f "$records_file" ]]; then
    printf 'Runner records: none\n'
    return 0
  fi
  printf 'Recent runner records:\n'
  tail -n 10 "$records_file"
}

repository_development_runner_phase_complete() {
  local phase_id="$1"
  local check_ids check_id
  check_ids="$(repository_development_runner_check_ids_for_phase "$phase_id" required)"
  IFS='|' read -r -a check_tokens <<<"$check_ids"
  for check_id in "${check_tokens[@]}"; do
    check_id="$(repository_development_trim "$check_id")"
    [[ -n "$check_id" && "$check_id" != "none" ]] || continue
    repository_development_runner_reusable_pass_exists "$phase_id" "$check_id" || return 1
  done
}

repository_development_runner_next_phase() {
  local phase_id="$1"
  repository_development_expected_phases | awk -F '\t' -v phase_id="$phase_id" '
    $2 == phase_id { target = $1 + 1 }
    target && $1 == target { print $2; found = 1; exit }
    END { exit found ? 0 : 1 }
  '
}

repository_development_runner_print_next() {
  local phase_id="$1"
  local execution_mode next_phase
  repository_development_validate_policy
  repository_development_runner_validate_policy
  repository_development_print_phase "$phase_id"
  execution_mode="$(repository_development_runner_field_for_phase "$phase_id" 3)"
  if [[ "$execution_mode" != "local_checks" ]]; then
    printf 'Next decision: stop at phase boundary; this phase is plan-only for the runner.\n'
    return 0
  fi
  if repository_development_runner_phase_complete "$phase_id"; then
    next_phase="$(repository_development_runner_next_phase "$phase_id" || true)"
    if [[ -n "$next_phase" ]]; then
      printf 'Next decision: required runner records are reusable; next phase is %s.\n' "$next_phase"
    else
      printf 'Next decision: required runner records are reusable; no later phase is defined.\n'
    fi
  else
    printf 'Next decision: remain in %s; required reusable runner records are incomplete.\n' "$phase_id"
  fi
}

repository_development_runner_detect_phase() {
  local changed_paths
  changed_paths="$(git -C "$LESSON_ROOT" status --short --untracked-files=normal 2>/dev/null | awk '{ print $2 }')"
  if [[ -z "$changed_paths" ]]; then
    printf 'Detected phase: context_triage\n'
    printf 'Reason: working tree is clean; start with context confirmation before new work.\n'
  elif grep -Eq '^(\.github/|\.githooks/|docs/workflow/(GIT_HOOK|FINAL_GATE|TEST_PLAN)|tools/(git-hooks|ci-final-gate|ci-evidence|test-plan)|tools/lib/(git_hooks|ci_|test_plan))' <<<"$changed_paths"; then
    printf 'Detected phase: mid_tests\n'
    printf 'Reason: changed paths affect hooks, CI, final-gate, or test-plan wiring.\n'
  elif grep -Eq '^(tools/repository-development-workflow|tools/lib/repository_development_|tools/check_repository_development_workflow\.sh|tools/test_repository_development_workflow\.sh|docs/workflow/REPOSITORY_DEVELOPMENT_)' <<<"$changed_paths"; then
    printf 'Detected phase: fast_loop\n'
    printf 'Reason: changed paths affect repository-development workflow runtime or policy.\n'
  elif grep -Eq '^(docs/as-built/|docs/workflow/(AS_BUILT_SYNC_CONTRACT|TASK_TRACKER|HANDOFF)\.)' <<<"$changed_paths"; then
    printf 'Detected phase: implementation_plan\n'
    printf 'Reason: changed paths are synchronized planning documents.\n'
  else
    printf 'Detected phase: fast_loop\n'
    printf 'Reason: working tree has scoped changes; run focused local checks before stricter gates.\n'
  fi
}
