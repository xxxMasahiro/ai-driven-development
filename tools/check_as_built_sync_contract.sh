#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/lib/lesson_common.sh
source "$SCRIPT_DIR/lib/lesson_common.sh"
# shellcheck source=tools/lib/document_paths.sh
source "$SCRIPT_DIR/lib/document_paths.sh"

ROOT="${AS_BUILT_SYNC_ROOT:-$LESSON_ROOT}"
CONTRACT_FILE="${AS_BUILT_SYNC_CONTRACT_FILE:-$ROOT/docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv}"
missing=0

required_doc_relpaths=(
  "docs/as-built/REQUIREMENTS.md"
  "docs/as-built/SPECIFICATION.md"
  "docs/as-built/IMPLEMENTATION_PLAN.md"
  "docs/workflow/TASK_TRACKER.md"
  "docs/workflow/HANDOFF.md"
)

wiring_relpaths=(
  "tools/test_lesson_repository.sh"
  ".githooks/pre-commit"
  ".github/workflows/ci.yml"
  ".github/workflows/lesson14-ci.yml"
)

contract_sync_ids=()

report_missing() {
  printf '%s\n' "$1" >&2
  missing=1
}

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

list_has_item() {
  local list="$1"
  local expected="$2"
  local item
  IFS=',' read -r -a items <<<"$list"
  for item in "${items[@]}"; do
    item="$(trim "$item")"
    if [[ "$item" == "$expected" ]]; then
      return 0
    fi
  done
  return 1
}

require_list_contains() {
  local list="$1"
  local expected="$2"
  local context="$3"
  if ! list_has_item "$list" "$expected"; then
    report_missing "missing $expected in $context"
  fi
}

require_list_no_extras() {
  local list="$1"
  local allowed="$2"
  local context="$3"
  local item
  IFS=',' read -r -a items <<<"$list"
  for item in "${items[@]}"; do
    item="$(trim "$item")"
    [[ -n "$item" ]] || continue
    if ! list_has_item "$allowed" "$item"; then
      report_missing "unexpected $item in $context"
    fi
  done
}

require_list_matches() {
  local actual="$1"
  local expected="$2"
  local context="$3"
  local item
  IFS=',' read -r -a expected_items <<<"$expected"
  for item in "${expected_items[@]}"; do
    item="$(trim "$item")"
    require_list_contains "$actual" "$item" "$context"
  done
  require_list_no_extras "$actual" "$expected" "$context"
}

block_field() {
  local file="$1"
  local sync_id="$2"
  local field="$3"
  awk -v sync_id="$sync_id" -v field="$field" '
    $0 == "SYNC-ID: " sync_id {
      in_block = 1
      next
    }
    in_block && /^SYNC-ID: / {
      exit
    }
    in_block && index($0, field ": ") == 1 {
      print substr($0, length(field) + 3)
      found = 1
      exit
    }
  ' "$file"
}

require_file_exists() {
  local relpath="$1"
  local label="$2"
  if [[ -z "$relpath" || "$relpath" == "none" ]]; then
    return
  fi
  if [[ ! -f "$ROOT/$relpath" ]]; then
    report_missing "missing $label: $relpath"
  fi
}

require_file_executable() {
  local relpath="$1"
  if [[ -z "$relpath" || "$relpath" == "none" ]]; then
    return
  fi
  if [[ -f "$ROOT/$relpath" && ! -x "$ROOT/$relpath" ]]; then
    report_missing "not executable: $relpath"
  fi
}

require_list_files() {
  local list="$1"
  local label="$2"
  local item
  IFS=',' read -r -a items <<<"$list"
  for item in "${items[@]}"; do
    item="$(trim "$item")"
    require_file_exists "$item" "$label"
    if [[ "$label" == "required test" ]]; then
      require_file_executable "$item"
    fi
  done
}

active_command_reference() {
  local file="$1"
  local test_relpath="$2"
  local line command

  while IFS= read -r line; do
    line="$(trim "$line")"
    [[ -n "$line" ]] || continue
    [[ "$line" != \#* ]] || continue

    if [[ "$line" == run:* ]]; then
      line="$(trim "${line#run:}")"
    fi

    while [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*=[^[:space:]]+[[:space:]]+ ]]; do
      line="${line#* }"
      line="$(trim "$line")"
    done

    command="${line%%[[:space:]]*}"
    command="${command%\"}"
    command="${command#\"}"

    if [[ "$command" == "./$test_relpath" || "$command" == "\$ROOT/$test_relpath" || "$command" == "$ROOT/$test_relpath" ]]; then
      return 0
    fi
  done <"$file"

  return 1
}

git_hooks_runner_reference() {
  local test_relpath="$1"
  local pre_commit="$ROOT/.githooks/pre-commit"
  local checks_file="$ROOT/docs/workflow/GIT_HOOK_CHECKS.tsv"
  local policy_file="$ROOT/docs/workflow/GIT_HOOKS_POLICY.tsv"
  local settings_file="$ROOT/learning/GIT_HOOK_SETTINGS.tsv"
  local allowed_modes
  local hook_mode

  [[ -f "$pre_commit" && -f "$checks_file" && -f "$policy_file" ]] || return 1
  active_command_reference "$pre_commit" "tools/git-hooks" || return 1
  allowed_modes="$(awk -F '\t' '$1 == "hook_mode" { print $2; found = 1 } END { if (!found) exit 1 }' "$policy_file")" || return 1
  if [[ -f "$settings_file" ]]; then
    hook_mode="$(awk -F '\t' '$1 == "hook_mode" { print $2; found = 1 } END { if (!found) exit 1 }' "$settings_file" 2>/dev/null || true)"
  fi
  if [[ -z "${hook_mode:-}" ]]; then
    hook_mode="$(awk -F '\t' '$1 == "hook_mode" { print $3; found = 1 } END { if (!found) exit 1 }' "$policy_file")" || return 1
  fi
  case "|$allowed_modes|" in
    *"|$hook_mode|"*) ;;
    *) return 1 ;;
  esac

  awk -F '\t' -v rel="./$test_relpath" -v abs="$ROOT/$test_relpath" -v hook_mode="$hook_mode" -v allowed_modes="$allowed_modes" '
    function trim(value) {
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)
      return value
    }
    /^[[:space:]]*$/ { next }
    $1 ~ /^#/ { next }
    NF != 4 {
      invalid = 1
      next
    }
    {
      check_id = trim($1)
      modes_field = trim($2)
      command = trim($3)
      if (check_id == "" || modes_field == "" || command == "") {
        invalid = 1
        next
      }
      selected = 0
      row_invalid = 0
      mode_count = split(modes_field, modes, "|")
      for (i = 1; i <= mode_count; i++) {
        if (modes[i] == "" || index("|" allowed_modes "|", "|" modes[i] "|") == 0) {
          invalid = 1
          row_invalid = 1
        }
        if (modes[i] == hook_mode) {
          selected = 1
        }
      }
      if (!row_invalid && selected && (command == rel || command == abs)) {
        found = 1
      }
    }
    END { exit invalid ? 1 : (found ? 0 : 1) }
  ' "$checks_file"
}

require_test_wiring() {
  local test_relpath="$1"
  local wiring_relpath
  if [[ -z "$test_relpath" || "$test_relpath" == "none" ]]; then
    return
  fi
  for wiring_relpath in "${wiring_relpaths[@]}"; do
    if [[ ! -f "$ROOT/$wiring_relpath" ]]; then
      report_missing "missing wiring file: $wiring_relpath"
      continue
    fi
    if active_command_reference "$ROOT/$wiring_relpath" "$test_relpath"; then
      continue
    fi
    if [[ "$wiring_relpath" == ".githooks/pre-commit" ]] && git_hooks_runner_reference "$test_relpath"; then
      continue
    fi
    if ! active_command_reference "$ROOT/$wiring_relpath" "$test_relpath"; then
      report_missing "missing active test wiring for $test_relpath in $wiring_relpath"
    fi
  done
}

require_tests_wired() {
  local tests="$1"
  local test_relpath
  IFS=',' read -r -a test_items <<<"$tests"
  for test_relpath in "${test_items[@]}"; do
    test_relpath="$(trim "$test_relpath")"
    require_test_wiring "$test_relpath"
  done
}

require_runtime_evidence_reference() {
  local evidence_relpath="$1"
  local sync_id="$2"
  local artifacts="$3"
  local tests="$4"
  local item

  if [[ -z "$evidence_relpath" || "$evidence_relpath" == "none" || ! -f "$ROOT/$evidence_relpath" ]]; then
    return
  fi

  if grep -F "$sync_id" "$ROOT/$evidence_relpath" >/dev/null; then
    return
  fi

  IFS=',' read -r -a artifact_items <<<"$artifacts"
  for item in "${artifact_items[@]}"; do
    item="$(trim "$item")"
    [[ -n "$item" && "$item" != "none" ]] || continue
    if grep -F "$item" "$ROOT/$evidence_relpath" >/dev/null; then
      return
    fi
  done

  IFS=',' read -r -a test_items <<<"$tests"
  for item in "${test_items[@]}"; do
    item="$(trim "$item")"
    [[ -n "$item" && "$item" != "none" ]] || continue
    if grep -F "$item" "$ROOT/$evidence_relpath" >/dev/null; then
      return
    fi
    if [[ "$evidence_relpath" == ".githooks/pre-commit" ]] && git_hooks_runner_reference "$item"; then
      return
    fi
  done

  report_missing "runtime evidence does not reference $sync_id artifacts or tests: $evidence_relpath"
}

validate_no_unknown_doc_blocks() {
  local doc_relpath="$1"
  local doc_path="$ROOT/$doc_relpath"
  local doc_sync_id known_sync_id known

  [[ -f "$doc_path" ]] || return

  while IFS= read -r doc_sync_id; do
    known=0
    for known_sync_id in "${contract_sync_ids[@]}"; do
      if [[ "$doc_sync_id" == "$known_sync_id" ]]; then
        known=1
        break
      fi
    done
    if [[ "$known" -eq 0 ]]; then
      report_missing "unknown SYNC-ID block in $doc_relpath: $doc_sync_id"
    fi
  done < <(awk '/^SYNC-ID: / { print substr($0, 10) }' "$doc_path")
}

validate_doc_block() {
  local doc_relpath="$1"
  local sync_id="$2"
  local status="$3"
  local artifacts="$4"
  local tests="$5"
  local doc_path="$ROOT/$doc_relpath"
  local count doc_status doc_artifacts doc_tests

  if [[ ! -f "$doc_path" ]]; then
    report_missing "missing synchronized document: $doc_relpath"
    return
  fi

  count="$(grep -Ec "^SYNC-ID: ${sync_id}$" "$doc_path" || true)"
  if [[ "$count" -ne 1 ]]; then
    report_missing "expected one SYNC-ID block for $sync_id in $doc_relpath, found $count"
    return
  fi

  doc_status="$(block_field "$doc_path" "$sync_id" "STATUS")"
  if [[ "$doc_status" != "$status" ]]; then
    report_missing "status mismatch for $sync_id in $doc_relpath: expected $status, got ${doc_status:-missing}"
  fi

  doc_artifacts="$(block_field "$doc_path" "$sync_id" "ARTIFACTS")"
  doc_tests="$(block_field "$doc_path" "$sync_id" "TESTS")"

  require_list_matches "$doc_artifacts" "$artifacts" "$doc_relpath ARTIFACTS for $sync_id"
  require_list_matches "$doc_tests" "$tests" "$doc_relpath TESTS for $sync_id"
}

validate_contract_row() {
  local sync_id="$1"
  local status="$2"
  local title="$3"
  local artifacts="$4"
  local tests="$5"
  local docs="$6"
  local runtime_evidence="$7"
  local doc_relpath test_relpath evidence_relpath

  if [[ -z "$sync_id" || -z "$status" || -z "$title" || -z "$artifacts" || -z "$tests" || -z "$docs" || -z "$runtime_evidence" ]]; then
    report_missing "invalid empty field in contract row for ${sync_id:-unknown}"
    return
  fi

  if [[ "$status" != "planned" && "$status" != "implemented" ]]; then
    report_missing "invalid status for $sync_id: $status"
  fi

  require_list_matches "$docs" "$(IFS=,; printf '%s' "${required_doc_relpaths[*]}")" "$sync_id required_docs"

  for doc_relpath in "${required_doc_relpaths[@]}"; do
    validate_doc_block "$doc_relpath" "$sync_id" "$status" "$artifacts" "$tests"
  done

  require_list_files "$artifacts" "required artifact"
  require_list_files "$tests" "required test"

  IFS=',' read -r -a evidence_items <<<"$runtime_evidence"
  for evidence_relpath in "${evidence_items[@]}"; do
    evidence_relpath="$(trim "$evidence_relpath")"
    require_file_exists "$evidence_relpath" "runtime evidence"
    require_runtime_evidence_reference "$evidence_relpath" "$sync_id" "$artifacts" "$tests"
  done

  if [[ "$status" == "implemented" ]]; then
    require_tests_wired "$tests"
  fi
}

if [[ ! -f "$CONTRACT_FILE" ]]; then
  report_missing "missing as-built sync contract: $CONTRACT_FILE"
else
  while IFS=$'\t' read -r sync_id status title artifacts tests docs runtime_evidence extra; do
    if [[ -z "${sync_id:-}" || "$sync_id" == \#* ]]; then
      continue
    fi
    if [[ -n "${extra:-}" ]]; then
      report_missing "invalid extra column in contract row for $sync_id"
      continue
    fi
    contract_sync_ids+=("$sync_id")
    validate_contract_row "$sync_id" "$status" "$title" "$artifacts" "$tests" "$docs" "$runtime_evidence"
  done <"$CONTRACT_FILE"

  for doc_relpath in "${required_doc_relpaths[@]}"; do
    validate_no_unknown_doc_blocks "$doc_relpath"
  done
fi

if [[ $missing -ne 0 ]]; then
  printf '\nAs-built sync contract check failed.\n' >&2
  exit 1
fi

printf 'As-built sync contract check passed.\n'
