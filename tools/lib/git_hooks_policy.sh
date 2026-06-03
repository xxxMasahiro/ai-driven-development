#!/usr/bin/env bash

if [[ -z "${LESSON_ROOT:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # shellcheck source=lesson_common.sh
  source "$SCRIPT_DIR/lesson_common.sh"
fi

git_hooks_policy_file() {
  printf '%s\n' "${GIT_HOOKS_POLICY_FILE:-$LESSON_ROOT/docs/workflow/GIT_HOOKS_POLICY.tsv}"
}

git_hooks_checks_file() {
  printf '%s\n' "${GIT_HOOKS_CHECKS_FILE:-$LESSON_ROOT/docs/workflow/GIT_HOOK_CHECKS.tsv}"
}

git_hooks_recommendation_paths_file() {
  printf '%s\n' "${GIT_HOOKS_RECOMMENDATION_PATHS_FILE:-$LESSON_ROOT/docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv}"
}

git_hooks_settings_file() {
  printf '%s\n' "${GIT_HOOKS_SETTINGS_FILE:-$LESSON_ROOT/learning/GIT_HOOK_SETTINGS.tsv}"
}

git_hooks_policy_field() {
  local key="$1"
  local field="$2"
  local policy_file
  policy_file="$(git_hooks_policy_file)"
  awk -F '\t' -v key="$key" -v field="$field" '
    NF >= 5 && $1 == key { print $field; found = 1 }
    END { if (!found) exit 1 }
  ' "$policy_file"
}

git_hooks_allowed_modes() {
  git_hooks_policy_field hook_mode 2
}

git_hooks_default_mode() {
  git_hooks_policy_field hook_mode 3
}

git_hooks_validate_mode() {
  local mode="$1"
  local allowed
  allowed="$(git_hooks_allowed_modes)" || {
    printf 'Git hooks policy is missing hook_mode.\n' >&2
    return 1
  }
  case "|$allowed|" in
    *"|$mode|"*) return 0 ;;
  esac
  printf 'Invalid Git hooks mode: %s (allowed: %s)\n' "$mode" "$allowed" >&2
  return 1
}

git_hooks_validate_modes_field() {
  local modes="$1"
  local token
  local invalid=0

  IFS='|' read -r -a tokens <<<"$modes"
  for token in "${tokens[@]}"; do
    if [[ -z "$token" ]]; then
      printf 'Invalid empty Git hooks mode token in check row modes: %s\n' "$modes" >&2
      invalid=1
      continue
    fi
    if ! git_hooks_validate_mode "$token" >/dev/null; then
      invalid=1
    fi
  done

  [[ "$invalid" -eq 0 ]]
}

git_hooks_raw_mode() {
  local settings_file
  settings_file="$(git_hooks_settings_file)"
  [[ -f "$settings_file" ]] || return 1
  awk -F '\t' '$1 == "hook_mode" { print $2; found = 1 } END { if (!found) exit 1 }' "$settings_file"
}

git_hooks_mode() {
  local mode
  if mode="$(git_hooks_raw_mode 2>/dev/null)"; then
    git_hooks_validate_mode "$mode" || return 1
    printf '%s\n' "$mode"
    return 0
  fi
  git_hooks_default_mode
}

git_hooks_write_mode() {
  local mode="$1"
  local settings_file
  local settings_dir
  git_hooks_validate_mode "$mode" || return 1
  settings_file="$(git_hooks_settings_file)"
  settings_dir="$(dirname "$settings_file")"
  mkdir -p "$settings_dir"
  {
    printf '# key\tvalue\n'
    printf 'hook_mode\t%s\n' "$mode"
  } >"$settings_file"
}

git_hooks_git_root() {
  git -C "$LESSON_ROOT" rev-parse --show-toplevel 2>/dev/null || printf '%s\n' "$LESSON_ROOT"
}

git_hooks_cache_dir() {
  if [[ -n "${GIT_HOOKS_CACHE_DIR:-}" ]]; then
    printf '%s\n' "$GIT_HOOKS_CACHE_DIR"
    return 0
  fi

  local root
  local git_path
  root="$(git_hooks_git_root)"
  git_path="$(git -C "$root" rev-parse --git-path pre-commit-cache 2>/dev/null || true)"
  if [[ -z "$git_path" ]]; then
    printf '%s\n' "$root/.git/pre-commit-cache"
  elif [[ "$git_path" == /* ]]; then
    printf '%s\n' "$git_path"
  else
    printf '%s\n' "$root/$git_path"
  fi
}

git_hooks_cache_marker_text() {
  printf 'git-hooks-cache-v1\n'
}

git_hooks_cache_marker_file() {
  printf '%s/.git-hooks-cache\n' "$(git_hooks_cache_dir)"
}

git_hooks_cache_marker_valid() {
  local marker
  marker="$(git_hooks_cache_marker_file)"
  [[ -f "$marker" ]] && [[ "$(sed -n '1p' "$marker")" == "$(git_hooks_cache_marker_text)" ]]
}

git_hooks_cache_dir_empty() {
  local cache_dir="$1"
  [[ -z "$(find "$cache_dir" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]
}

git_hooks_prepare_cache_dir() {
  local cache_dir
  local marker
  cache_dir="$(git_hooks_cache_dir)"
  marker="$(git_hooks_cache_marker_file)"

  if [[ -z "$cache_dir" || "$cache_dir" == "/" ]]; then
    printf 'Unsafe Git hooks cache directory: %s\n' "$cache_dir" >&2
    return 1
  fi
  if [[ -L "$cache_dir" ]]; then
    printf 'Refusing symlinked Git hooks cache directory: %s\n' "$cache_dir" >&2
    return 1
  fi
  if [[ -e "$cache_dir" && ! -d "$cache_dir" ]]; then
    printf 'Git hooks cache path is not a directory: %s\n' "$cache_dir" >&2
    return 1
  fi

  if [[ -d "$cache_dir" ]]; then
    if git_hooks_cache_marker_valid; then
      return 0
    fi
    if [[ -e "$marker" ]]; then
      printf 'Invalid Git hooks cache marker: %s\n' "$marker" >&2
      return 1
    fi
    if ! git_hooks_cache_dir_empty "$cache_dir"; then
      printf 'Refusing unmarked non-empty Git hooks cache directory: %s\n' "$cache_dir" >&2
      return 1
    fi
  fi

  mkdir -p "$cache_dir"
  git_hooks_cache_marker_text >"$marker"
}

git_hooks_hash_stream() {
  sha256sum | awk '{ print $1 }'
}

git_hooks_file_hash() {
  local file="$1"
  if [[ -f "$file" ]]; then
    sha256sum "$file" | awk '{ print $1 }'
  else
    printf 'missing\n'
  fi
}

git_hooks_command_file_hash() {
  local command="$1"
  local first
  first="${command%% *}"
  if [[ "$first" == ./* ]]; then
    first="$LESSON_ROOT/${first#./}"
  fi
  git_hooks_file_hash "$first"
}

git_hooks_has_untracked_files() {
  local root="$1"
  git -C "$root" status --porcelain --untracked-files=all 2>/dev/null | awk '/^\?\?/ { found = 1 } END { exit found ? 0 : 1 }'
}

git_hooks_cache_key() {
  local root="$1"
  local mode="$2"
  local check_id="$3"
  local command="$4"
  local checks_file
  checks_file="$(git_hooks_checks_file)"
  {
    printf 'mode=%s\n' "$mode"
    printf 'check_id=%s\n' "$check_id"
    printf 'command=%s\n' "$command"
    printf 'command_hash=%s\n' "$(git_hooks_command_file_hash "$command")"
    printf 'checks_hash=%s\n' "$(git_hooks_file_hash "$checks_file")"
    printf 'policy_hash=%s\n' "$(git_hooks_file_hash "$(git_hooks_policy_file)")"
    printf 'settings_hash=%s\n' "$(git_hooks_file_hash "$(git_hooks_settings_file)")"
    git -C "$root" ls-files -s 2>/dev/null || true
    git -C "$root" diff --binary 2>/dev/null || true
    git -C "$root" diff --cached --binary 2>/dev/null || true
    git -C "$root" status --porcelain --untracked-files=all 2>/dev/null || true
  } | git_hooks_hash_stream
}

git_hooks_mode_contains() {
  local modes="$1"
  local mode="$2"
  case "|$modes|" in
    *"|$mode|"*) return 0 ;;
  esac
  return 1
}

git_hooks_rows_for_mode() {
  local mode="$1"
  local checks_file
  local row_separator
  local allowed_modes
  checks_file="$(git_hooks_checks_file)"
  allowed_modes="$(git_hooks_allowed_modes)" || {
    printf 'Git hooks policy is missing allowed modes.\n' >&2
    return 1
  }
  row_separator=$'\034'
  awk -F '\t' -v mode="$mode" -v allowed_modes="$allowed_modes" -v row_separator="$row_separator" '
    /^[[:space:]]*$/ { next }
    $1 ~ /^#/ { next }
    NF != 4 {
      printf "Malformed Git hook check row %d: expected exactly 4 tab-separated fields.\n", NR > "/dev/stderr"
      invalid = 1
      next
    }
    {
      check_id = $1
      modes_field = $2
      command = $3
      description = $4
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", check_id)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", modes_field)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", command)
    }
    check_id == "" || modes_field == "" || command == "" {
      printf "Malformed Git hook check row %d: check_id, modes, and command are required.\n", NR > "/dev/stderr"
      invalid = 1
      next
    }
    {
      selected = 0
      row_invalid = 0
      mode_count = split(modes_field, modes, "|")
      for (i = 1; i <= mode_count; i++) {
        if (modes[i] == "" || index("|" allowed_modes "|", "|" modes[i] "|") == 0) {
          printf "Malformed Git hook check row %d: invalid mode token %s.\n", NR, modes[i] > "/dev/stderr"
          invalid = 1
          row_invalid = 1
        }
        if (modes[i] == mode) {
          selected = 1
        }
      }
      if (row_invalid) {
        next
      }
      if (selected) {
        printf "%s%s%s%s%s%s%s\n", check_id, row_separator, modes_field, row_separator, command, row_separator, description
      }
    }
    END { exit invalid ? 1 : 0 }
  ' "$checks_file"
}

git_hooks_count_for_mode() {
  git_hooks_rows_for_mode "$1" | awk 'END { print NR + 0 }'
}

git_hooks_print_status() {
  local root
  local mode
  local full_count
  local fast_count
  local minimal_count
  root="$(git_hooks_git_root)"
  mode="$(git_hooks_mode)" || return 1
  full_count="$(git_hooks_count_for_mode full)" || return 1
  fast_count="$(git_hooks_count_for_mode fast)" || return 1
  minimal_count="$(git_hooks_count_for_mode minimal)" || return 1
  printf 'Git hooks policy\n'
  printf 'Mode: %s\n' "$mode"
  printf 'Policy file: %s\n' "$(git_hooks_policy_file)"
  printf 'Checks file: %s\n' "$(git_hooks_checks_file)"
  printf 'Recommendation paths file: %s\n' "$(git_hooks_recommendation_paths_file)"
  printf 'Settings file: %s\n' "$(git_hooks_settings_file)"
  printf 'Cache directory: %s\n' "$(git_hooks_cache_dir)"
  printf 'Full checks: %s\n' "$full_count"
  printf 'Fast checks: %s\n' "$fast_count"
  printf 'Minimal checks: %s\n' "$minimal_count"
  if git_hooks_has_untracked_files "$root"; then
    printf 'Cache status: disabled while untracked files are present\n'
  else
    printf 'Cache status: available for fast mode\n'
  fi
  git_hooks_print_recommendation
}

git_hooks_cache_file_for() {
  local check_id="$1"
  local safe_id
  safe_id="$(printf '%s' "$check_id" | tr -c 'A-Za-z0-9_.-' '_')"
  printf '%s/%s.cache\n' "$(git_hooks_cache_dir)" "$safe_id"
}

git_hooks_run_one() {
  local root="$1"
  local mode="$2"
  local no_cache="$3"
  local cache_allowed="$4"
  local check_id="$5"
  local command="$6"
  local cache_key=""
  local cache_file=""

  if [[ "$mode" == "fast" && "$no_cache" == "false" && "$cache_allowed" == "true" ]]; then
    git_hooks_prepare_cache_dir || return 1
    cache_key="$(git_hooks_cache_key "$root" "$mode" "$check_id" "$command")"
    cache_file="$(git_hooks_cache_file_for "$check_id")"
    if [[ -f "$cache_file" ]] && [[ "$(sed -n '1p' "$cache_file")" == "$cache_key" ]]; then
      printf 'hook cache hit: %s\n' "$check_id"
      return 0
    fi
  fi

  printf 'hook run: %s\n' "$check_id"
  if (cd "$root" && bash -c "$command"); then
    if [[ "$mode" == "fast" && "$no_cache" == "false" && "$cache_allowed" == "true" ]]; then
      {
        printf '%s\n' "$cache_key"
        date '+%Y-%m-%d %H:%M:%S'
      } >"$cache_file"
    fi
    return 0
  fi

  printf 'hook failed: %s\n' "$check_id" >&2
  return 1
}

git_hooks_run_checks() {
  local mode="$1"
  local no_cache="${2:-false}"
  local root
  local cache_allowed="true"
  local count=0
  local failed=0
  local rows
  local row_separator
  row_separator=$'\034'

  git_hooks_validate_mode "$mode" || return 1
  root="$(git_hooks_git_root)"

  if git_hooks_has_untracked_files "$root"; then
    cache_allowed="false"
    if [[ "$mode" == "fast" && "$no_cache" == "false" ]]; then
      printf 'Git hooks cache disabled because untracked files are present.\n'
    fi
  fi

  rows="$(git_hooks_rows_for_mode "$mode")" || return 1
  while IFS="$row_separator" read -r check_id modes command _description; do
    [[ -n "$check_id" ]] || continue
    if ! git_hooks_mode_contains "$modes" "$mode"; then
      continue
    fi
    if [[ -z "$command" ]]; then
      printf 'Git hook check has no command: %s\n' "$check_id" >&2
      return 1
    fi
    count=$((count + 1))
    if ! git_hooks_run_one "$root" "$mode" "$no_cache" "$cache_allowed" "$check_id" "$command"; then
      failed=1
      break
    fi
  done <<<"$rows"

  if [[ "$count" -eq 0 ]]; then
    printf 'No Git hook checks are configured for mode: %s\n' "$mode" >&2
    return 1
  fi

  if [[ "$failed" -ne 0 ]]; then
    return 1
  fi

  printf 'Git hooks checks passed: %s mode (%s checks).\n' "$mode" "$count"
}

git_hooks_clear_cache() {
  local cache_dir
  cache_dir="$(git_hooks_cache_dir)"
  git_hooks_prepare_cache_dir || return 1
  find "$cache_dir" -maxdepth 1 -type f -name '*.cache' -delete
  printf 'Git hooks cache cleared: %s\n' "$cache_dir"
}

git_hooks_changed_paths() {
  local root
  root="$(git_hooks_git_root)"
  {
    git -C "$root" diff --name-only --diff-filter=ACDMRTUXB 2>/dev/null || true
    git -C "$root" diff --cached --name-only --diff-filter=ACDMRTUXB 2>/dev/null || true
    git -C "$root" ls-files --others --exclude-standard 2>/dev/null || true
  } | sed '/^[[:space:]]*$/d' | sort -u
}

git_hooks_normalize_path() {
  local path="$1"
  local root
  root="$(git_hooks_git_root)"
  path="${path#./}"
  if [[ "$path" == "$root/"* ]]; then
    path="${path#"$root/"}"
  fi
  printf '%s\n' "$path"
}

git_hooks_path_matches_pattern() {
  local pattern="$1"
  local path="$2"
  path="$(git_hooks_normalize_path "$path")"
  if [[ "$pattern" == */ ]]; then
    [[ "$path" == "$pattern"* ]]
    return
  fi
  case "$path" in
    $pattern) return 0 ;;
  esac
  return 1
}

git_hooks_recommendation_rows_for_paths() {
  local recommendation_file
  local path
  local pattern
  local recommendation
  local reason
  local invalid=0

  recommendation_file="$(git_hooks_recommendation_paths_file)"
  [[ -f "$recommendation_file" ]] || {
    printf 'Git hooks recommendation paths file is missing: %s\n' "$recommendation_file" >&2
    return 1
  }

  while IFS=$'\t' read -r pattern recommendation reason extra; do
    [[ -n "${pattern:-}" ]] || continue
    [[ "$pattern" != \#* ]] || continue
    if [[ -n "${extra:-}" || -z "${recommendation:-}" || -z "${reason:-}" ]]; then
      printf 'Malformed Git hooks recommendation row for pattern: %s\n' "$pattern" >&2
      invalid=1
      continue
    fi
    case "$recommendation" in
      full-no-cache) ;;
      *)
        printf 'Invalid Git hooks recommendation for pattern %s: %s\n' "$pattern" "$recommendation" >&2
        invalid=1
        continue
        ;;
    esac
    for path in "$@"; do
      [[ -n "$path" ]] || continue
      if git_hooks_path_matches_pattern "$pattern" "$path"; then
        printf '%s\t%s\t%s\t%s\n' "$recommendation" "$path" "$pattern" "$reason"
      fi
    done
  done <"$recommendation_file"

  [[ "$invalid" -eq 0 ]]
}

git_hooks_print_recommendation() {
  local paths=("$@")
  local matches
  local path
  if [[ "${#paths[@]}" -eq 0 ]]; then
    mapfile -t paths < <(git_hooks_changed_paths)
  fi

  printf 'Local verification recommendation\n'
  if [[ "${#paths[@]}" -eq 0 ]]; then
    printf 'Recommended command: ./tools/git-hooks run --mode minimal\n'
    printf 'Reason: no local changes were detected.\n'
    printf 'Remote CI: full/no-cache remains the final verification.\n'
    return 0
  fi

  matches="$(git_hooks_recommendation_rows_for_paths "${paths[@]}")" || return 1
  if [[ -z "$matches" ]]; then
    printf 'Recommended command: ./tools/git-hooks run --mode minimal\n'
    printf 'Reason: changed files do not match the full/no-cache recommendation policy.\n'
    printf 'Remote CI: full/no-cache remains the final verification.\n'
    return 0
  fi

  printf 'Recommended command: ./tools/git-hooks run --mode full --no-cache\n'
  printf 'Reason: changed files affect Git hooks, CI, checks, tests, or as-built synchronization.\n'
  printf 'Matched files:\n'
  while IFS=$'\t' read -r _recommendation path pattern reason; do
    [[ -n "${path:-}" ]] || continue
    printf '%s\n' "- $path (policy: $pattern; $reason)"
  done <<<"$matches"
  printf 'Remote CI: full/no-cache remains the final verification.\n'
}
