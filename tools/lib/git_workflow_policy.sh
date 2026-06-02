#!/usr/bin/env bash

if [[ -z "${LESSON_ROOT:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # shellcheck source=lesson_common.sh
  source "$SCRIPT_DIR/lesson_common.sh"
fi

git_workflow_policy_file() {
  printf '%s\n' "${GIT_WORKFLOW_POLICY_FILE:-$LESSON_ROOT/docs/workflow/GIT_WORKFLOW_POLICY.tsv}"
}

git_workflow_settings_file() {
  printf '%s\n' "${GIT_WORKFLOW_SETTINGS_FILE:-$LESSON_ROOT/learning/GIT_WORKFLOW_SETTINGS.tsv}"
}

git_workflow_policy_rows() {
  local policy_file
  policy_file="$(git_workflow_policy_file)"
  awk -F '\t' 'NF >= 5 && $1 !~ /^#/ { print }' "$policy_file"
}

git_workflow_policy_field() {
  local key="$1"
  local field="$2"
  local policy_file
  policy_file="$(git_workflow_policy_file)"
  awk -F '\t' -v key="$key" -v field="$field" '
    NF >= 5 && $1 == key { print $field; found = 1 }
    END { if (!found) exit 1 }
  ' "$policy_file"
}

git_workflow_policy_has_key() {
  git_workflow_policy_field "$1" 1 >/dev/null 2>&1
}

git_workflow_policy_allowed_values() {
  git_workflow_policy_field "$1" 2
}

git_workflow_policy_default_value() {
  git_workflow_policy_field "$1" 3
}

git_workflow_policy_label() {
  git_workflow_policy_field "$1" 4
}

git_workflow_validate_value() {
  local key="$1"
  local value="$2"
  local allowed

  if ! allowed="$(git_workflow_policy_allowed_values "$key")"; then
    printf 'Unknown Git workflow setting: %s\n' "$key" >&2
    return 1
  fi

  case "|$allowed|" in
    *"|$value|"*) return 0 ;;
  esac

  printf 'Invalid value for %s: %s (allowed: %s)\n' "$key" "$value" "$allowed" >&2
  return 1
}

git_workflow_raw_setting_value() {
  local key="$1"
  local settings_file
  settings_file="$(git_workflow_settings_file)"
  [[ -f "$settings_file" ]] || return 1
  awk -F '\t' -v key="$key" 'NF >= 2 && $1 == key { print $2; found = 1 } END { if (!found) exit 1 }' "$settings_file"
}

git_workflow_setting_value() {
  local key="$1"
  local value

  if value="$(git_workflow_raw_setting_value "$key" 2>/dev/null)"; then
    git_workflow_validate_value "$key" "$value" >/dev/null
    printf '%s\n' "$value"
    return 0
  fi

  git_workflow_policy_default_value "$key"
}

git_workflow_write_setting() {
  local key="$1"
  local value="$2"
  local settings_file
  local settings_dir
  local tmp_file

  git_workflow_validate_value "$key" "$value" || return 1
  settings_file="$(git_workflow_settings_file)"
  settings_dir="$(dirname "$settings_file")"
  mkdir -p "$settings_dir"
  tmp_file="$(mktemp)"

  {
    printf '# key\tvalue\n'
    while IFS=$'\t' read -r row_key _allowed default_value _label _description; do
      local selected
      if [[ "$row_key" == "$key" ]]; then
        selected="$value"
      elif selected="$(git_workflow_raw_setting_value "$row_key" 2>/dev/null)"; then
        git_workflow_validate_value "$row_key" "$selected" >/dev/null
      else
        selected="$default_value"
      fi
      printf '%s\t%s\n' "$row_key" "$selected"
    done < <(git_workflow_policy_rows)
  } >"$tmp_file"

  mv "$tmp_file" "$settings_file"
}

git_workflow_bool_enabled() {
  [[ "$(git_workflow_setting_value "$1")" == "true" ]]
}

git_workflow_automation_level() {
  git_workflow_setting_value automation_level
}

git_workflow_automation_allows() {
  local action="$1"
  local level
  level="$(git_workflow_automation_level)"

  case "$level:$action" in
    commit:commit) return 0 ;;
    pr_ci:commit|pr_ci:push|pr_ci:pr|pr_ci:ci) return 0 ;;
    sync:commit|sync:push|sync:pr|sync:ci|sync:sync) return 0 ;;
  esac

  return 1
}

git_workflow_absolute_dir() {
  local path="$1"
  (cd "$path" && pwd -P)
}

git_workflow_git_root() {
  local repo="${1:-$PWD}"
  git -C "$repo" rev-parse --show-toplevel 2>/dev/null
}

git_workflow_repository_context() {
  local repo="${1:-$PWD}"
  local git_root
  local abs_root
  local abs_lesson
  local product_root

  git_root="$(git_workflow_git_root "$repo")" || {
    printf 'not-git\n'
    return 1
  }

  abs_root="$(git_workflow_absolute_dir "$git_root")"
  abs_lesson="$(git_workflow_absolute_dir "$LESSON_ROOT")"
  if [[ "$abs_root" == "$abs_lesson" ]]; then
    printf 'lesson\n'
    return 0
  fi

  if product_root="$(lesson_product_repo_root 2>/dev/null)" && [[ -n "$product_root" && -e "$product_root" ]]; then
    local product_git_root
    local abs_product
    product_git_root="$(git_workflow_git_root "$product_root" 2>/dev/null || true)"
    if [[ -n "$product_git_root" ]]; then
      abs_product="$(git_workflow_absolute_dir "$product_git_root")"
    fi
    if [[ -n "${abs_product:-}" && "$abs_root" == "$abs_product" ]]; then
      printf 'product\n'
      return 0
    fi
  fi

  printf 'custom\n'
}

git_workflow_branch_name() {
  local repo="$1"
  git -C "$repo" symbolic-ref --quiet --short HEAD 2>/dev/null || git -C "$repo" rev-parse --short HEAD
}

git_workflow_upstream_name() {
  local repo="$1"
  local upstream
  if upstream="$(git -C "$repo" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)" && [[ -n "$upstream" && "$upstream" != "@{upstream}" ]]; then
    printf '%s\n' "$upstream"
  fi
}

git_workflow_upstream_counts() {
  local repo="$1"
  local upstream="$2"
  local counts
  if [[ -z "$upstream" ]]; then
    printf '0 0\n'
    return 0
  fi
  if counts="$(git -C "$repo" rev-list --left-right --count "HEAD...$upstream" 2>/dev/null)"; then
    awk '{ print $1, $2 }' <<<"$counts"
  else
    printf 'unknown unknown\n'
    return 1
  fi
}

git_workflow_worktree_state() {
  local repo="$1"
  if [[ -z "$(git -C "$repo" status --short)" ]]; then
    printf 'clean\n'
  else
    printf 'dirty\n'
  fi
}

git_workflow_candidate_branches() {
  local repo="$1"
  local current="$2"
  git -C "$repo" branch --merged 2>/dev/null \
    | sed 's/^[* ]*//' \
    | awk -v current="$current" '
      $0 != "" &&
      $0 !~ /^\(/ &&
      $0 != current &&
      $0 != "main" &&
      $0 != "master" &&
      $0 != "trunk" &&
      $0 != "develop" { print }
    '
}

git_workflow_candidate_worktrees() {
  local repo="$1"
  local root="$2"
  local abs_root
  abs_root="$(git_workflow_absolute_dir "$root")"
  git -C "$repo" worktree list --porcelain 2>/dev/null \
    | awk '/^worktree / { sub(/^worktree /, ""); print }' \
    | while IFS= read -r path; do
        [[ -d "$path" ]] || continue
        local abs_path
        abs_path="$(git_workflow_absolute_dir "$path")"
        [[ "$abs_path" == "$abs_root" ]] || printf '%s\n' "$path"
      done
}

git_workflow_print_settings() {
  while IFS=$'\t' read -r key _allowed _default label description; do
    printf '%s: %s\n' "$key" "$(git_workflow_setting_value "$key")"
    printf '  %s - %s\n' "$label" "$description"
  done < <(git_workflow_policy_rows)
}

git_workflow_print_monitor() {
  local repo="${1:-$PWD}"
  local root
  local context
  local branch
  local state
  local upstream
  local counts
  local ahead
  local behind
  local candidates
  local worktrees

  root="$(git_workflow_git_root "$repo")" || {
    printf 'Git repository: not found (%s)\n' "$repo"
    return 1
  }

  context="$(git_workflow_repository_context "$repo")"
  branch="$(git_workflow_branch_name "$root")"
  state="$(git_workflow_worktree_state "$root")"
  upstream="$(git_workflow_upstream_name "$root")"
  if counts="$(git_workflow_upstream_counts "$root" "$upstream")"; then
    ahead="${counts%% *}"
    behind="${counts##* }"
  else
    ahead="unknown"
    behind="unknown"
  fi
  candidates="$(git_workflow_candidate_branches "$root" "$branch")"
  worktrees="$(git_workflow_candidate_worktrees "$root" "$root")"

  printf 'Repository context: %s\n' "$context"
  printf 'Git root: %s\n' "$root"
  printf 'Branch: %s\n' "$branch"
  printf 'Working tree: %s\n' "$state"
  if [[ -n "$upstream" ]]; then
    printf 'Upstream: %s\n' "$upstream"
    printf 'Ahead: %s\n' "$ahead"
    printf 'Behind: %s\n' "$behind"
  else
    printf 'Upstream: none\n'
  fi

  if [[ -n "$candidates" ]]; then
    printf 'Candidate cleanup branches:\n%s\n' "$candidates"
  else
    printf 'Candidate cleanup branches: none\n'
  fi

  if [[ -n "$worktrees" ]]; then
    printf 'Candidate cleanup worktrees:\n%s\n' "$worktrees"
  else
    printf 'Candidate cleanup worktrees: none\n'
  fi
}

git_workflow_check_repository() {
  local repo="${1:-$PWD}"
  local root
  local upstream
  local counts
  local ahead
  local behind
  local failed=0

  root="$(git_workflow_git_root "$repo")" || {
    printf 'Git repository: not found (%s)\n' "$repo" >&2
    return 1
  }

  git_workflow_print_monitor "$root"

  if [[ "$(git_workflow_worktree_state "$root")" != "clean" ]]; then
    printf 'Git monitor failed: uncommitted changes are present.\n' >&2
    failed=1
  fi

  upstream="$(git_workflow_upstream_name "$root")"
  if [[ -z "$upstream" ]]; then
    printf 'Git monitor failed: upstream is not configured.\n' >&2
    failed=1
  else
    if counts="$(git_workflow_upstream_counts "$root" "$upstream")"; then
      ahead="${counts%% *}"
      behind="${counts##* }"
    else
      printf 'Git monitor failed: upstream cannot be resolved.\n' >&2
      failed=1
      ahead="unknown"
      behind="unknown"
    fi
    if [[ "$ahead" != "0" || "$behind" != "0" ]]; then
      printf 'Git monitor failed: local and upstream differ.\n' >&2
      failed=1
    fi
  fi

  return "$failed"
}

git_workflow_allow_policy() {
  local action="$1"

  case "$action" in
    branch)
      git_workflow_bool_enabled branch_allowed
      ;;
    worktree)
      git_workflow_bool_enabled worktree_allowed
      ;;
    main-direct)
      git_workflow_bool_enabled main_direct_work_allowed
      ;;
    commit|push|pr|ci|sync)
      git_workflow_automation_allows "$action"
      ;;
    *)
      printf 'Unknown Git workflow action: %s\n' "$action" >&2
      return 1
      ;;
  esac
}
