#!/usr/bin/env bash

if [[ -z "${LESSON_ROOT:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # shellcheck source=lesson_common.sh
  source "$SCRIPT_DIR/lesson_common.sh"
fi

resource_guard_policy_file() {
  printf '%s\n' "${RESOURCE_GUARD_POLICY_FILE:-$LESSON_ROOT/docs/workflow/RESOURCE_POLICY.tsv}"
}

resource_guard_settings_file() {
  printf '%s\n' "${RESOURCE_GUARD_SETTINGS_FILE:-$LESSON_ROOT/learning/RESOURCE_SETTINGS.tsv}"
}

resource_guard_root() {
  printf '%s\n' "${RESOURCE_GUARD_ROOT:-$LESSON_ROOT}"
}

resource_guard_meminfo_file() {
  printf '%s\n' "${RESOURCE_GUARD_MEMINFO_FILE:-/proc/meminfo}"
}

resource_guard_is_non_negative_integer() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

resource_guard_is_positive_integer() {
  [[ "$1" =~ ^[1-9][0-9]*$ ]]
}

resource_guard_is_boolean() {
  [[ "$1" == "true" || "$1" == "false" ]]
}

resource_guard_policy_value() {
  local row_type="$1"
  local key="$2"
  local policy_file
  policy_file="$(resource_guard_policy_file)"
  awk -F '\t' -v row_type="$row_type" -v key="$key" '
    $1 !~ /^#/ && $1 == row_type && $2 == key {
      print $3
      found = 1
      exit
    }
    END { if (!found) exit 1 }
  ' "$policy_file"
}

resource_guard_default_value() {
  resource_guard_policy_value default "$1"
}

resource_guard_setting_value() {
  local key="$1"
  local settings_file
  settings_file="$(resource_guard_settings_file)"
  if [[ -f "$settings_file" ]]; then
    awk -F '\t' -v key="$key" '
      $1 !~ /^#/ && $1 == key {
        print $2
        found = 1
        exit
      }
      END { exit found ? 0 : 1 }
    ' "$settings_file" && return 0
  fi
  resource_guard_default_value "$key"
}

resource_guard_profile_job_mib() {
  local profile="$1"
  resource_guard_policy_value profile "$profile" 2>/dev/null || {
    printf 'Unknown resource profile: %s\n' "$profile" >&2
    return 1
  }
}

resource_guard_require_profile() {
  resource_guard_profile_job_mib "$1" >/dev/null
}

resource_guard_threshold_value() {
  resource_guard_policy_value threshold "$1"
}

resource_guard_meminfo_kib() {
  local key="$1"
  local meminfo_file
  meminfo_file="$(resource_guard_meminfo_file)"
  awk -v key="$key" '$1 == key ":" { print $2; found = 1; exit } END { if (!found) print 0 }' "$meminfo_file" 2>/dev/null || printf '0\n'
}

resource_guard_mem_total_mib() {
  printf '%s\n' "$(( $(resource_guard_meminfo_kib MemTotal) / 1024 ))"
}

resource_guard_mem_available_mib() {
  printf '%s\n' "$(( $(resource_guard_meminfo_kib MemAvailable) / 1024 ))"
}

resource_guard_swap_total_mib() {
  printf '%s\n' "$(( $(resource_guard_meminfo_kib SwapTotal) / 1024 ))"
}

resource_guard_swap_free_mib() {
  printf '%s\n' "$(( $(resource_guard_meminfo_kib SwapFree) / 1024 ))"
}

resource_guard_swap_used_mib() {
  local total free
  total="$(resource_guard_swap_total_mib)"
  free="$(resource_guard_swap_free_mib)"
  if (( total > free )); then
    printf '%s\n' "$(( total - free ))"
  else
    printf '0\n'
  fi
}

resource_guard_disk_free_mib() {
  if [[ -n "${RESOURCE_GUARD_DISK_FREE_MIB:-}" ]]; then
    printf '%s\n' "$RESOURCE_GUARD_DISK_FREE_MIB"
    return
  fi
  df -Pm "$(resource_guard_root)" 2>/dev/null | awk 'NR == 2 { print $4; found = 1 } END { if (!found) print 0 }'
}

resource_guard_cpu_count() {
  if [[ -n "${RESOURCE_GUARD_CPU_COUNT:-}" ]]; then
    printf '%s\n' "$RESOURCE_GUARD_CPU_COUNT"
    return
  fi
  getconf _NPROCESSORS_ONLN 2>/dev/null || printf '1\n'
}

resource_guard_active_heavy_process_count() {
  if [[ -n "${RESOURCE_GUARD_ACTIVE_HEAVY_COUNT:-}" ]]; then
    printf '%s\n' "$RESOURCE_GUARD_ACTIVE_HEAVY_COUNT"
    return
  fi
  ps -eo comm= 2>/dev/null | awk '
    /^(node|npm|npx|playwright|chromium|chrome|google-chrome)$/ { count++ }
    END { print count + 0 }
  '
}

resource_guard_memory_budget_mib() {
  local total percent
  total="$(resource_guard_mem_total_mib)"
  percent="$(resource_guard_setting_value memory_budget_percent)"
  printf '%s\n' "$(( total * percent / 100 ))"
}

resource_guard_effective_swap_budget_mib() {
  local free_mib percent limit_gib by_percent by_limit
  free_mib="$(resource_guard_disk_free_mib)"
  percent="$(resource_guard_setting_value swap_storage_percent)"
  limit_gib="$(resource_guard_setting_value swap_gib_limit)"
  by_percent="$(( free_mib * percent / 100 ))"
  by_limit="$(( limit_gib * 1024 ))"
  if (( by_percent < by_limit )); then
    printf '%s\n' "$by_percent"
  else
    printf '%s\n' "$by_limit"
  fi
}

resource_guard_swap_budget_usage_percent() {
  local budget used
  budget="$(resource_guard_effective_swap_budget_mib)"
  used="$(resource_guard_swap_used_mib)"
  if (( budget <= 0 )); then
    if (( used > 0 )); then
      printf '100\n'
    else
      printf '0\n'
    fi
    return
  fi
  printf '%s\n' "$(( used * 100 / budget ))"
}

resource_guard_usage_stage() {
  local percent="$1"
  local p50 p60 p70 p80 p90
  p50="$(resource_guard_threshold_value notice_50)"
  p60="$(resource_guard_threshold_value warning_60)"
  p70="$(resource_guard_threshold_value strong_warning_70)"
  p80="$(resource_guard_threshold_value stop_new_parallel_80)"
  p90="$(resource_guard_threshold_value serial_fallback_90)"
  if (( percent >= p90 )); then
    printf 'serial-fallback-or-safe-stop'
  elif (( percent >= p80 )); then
    printf 'stop-new-parallel-work'
  elif (( percent >= p70 )); then
    printf 'strong-warning'
  elif (( percent >= p60 )); then
    printf 'warning'
  elif (( percent >= p50 )); then
    printf 'notice'
  else
    printf 'record-only'
  fi
}

resource_guard_validate_policy() {
  local policy_file
  local invalid=0
  local previous_threshold=-1
  policy_file="$(resource_guard_policy_file)"
  [[ -f "$policy_file" ]] || {
    printf 'Resource policy file is missing: %s\n' "$policy_file" >&2
    return 1
  }
  while IFS=$'\t' read -r row_type key value label description extra; do
    [[ -n "${row_type:-}" ]] || continue
    [[ "$row_type" != \#* ]] || continue
    if [[ -n "${extra:-}" || -z "${key:-}" || -z "${value:-}" || -z "${label:-}" || -z "${description:-}" ]]; then
      printf 'Malformed resource policy row for key: %s\n' "${key:-unknown}" >&2
      invalid=1
      continue
    fi
    case "$row_type" in
      default)
        case "$key" in
          swap_gib_limit)
            resource_guard_is_non_negative_integer "$value" || {
              printf 'Invalid numeric resource policy default %s: %s\n' "$key" "$value" >&2
              invalid=1
            }
            ;;
          cleanup_older_than_hours)
            resource_guard_is_non_negative_integer "$value" || {
              printf 'Invalid cleanup_older_than_hours default: %s\n' "$value" >&2
              invalid=1
            }
            ;;
          memory_budget_percent|swap_storage_percent|available_memory_floor_percent)
            if ! resource_guard_is_non_negative_integer "$value" || (( value > 100 )); then
              printf 'Invalid percent resource policy default %s: %s\n' "$key" "$value" >&2
              invalid=1
            fi
            ;;
          max_parallel_jobs)
            [[ "$value" == "auto" ]] || resource_guard_is_positive_integer "$value" || {
              printf 'Invalid max_parallel_jobs default: %s\n' "$value" >&2
              invalid=1
            }
            ;;
          resource_mode)
            case "$value" in automatic|serial|parallel) ;; *) printf 'Invalid resource_mode default: %s\n' "$value" >&2; invalid=1 ;; esac
            ;;
          cleanup_safe_delete_enabled|cleanup_require_explicit_safe)
            resource_guard_is_boolean "$value" || {
              printf 'Invalid cleanup boolean default %s: %s\n' "$key" "$value" >&2
              invalid=1
            }
            ;;
          *)
            printf 'Unknown resource policy default: %s\n' "$key" >&2
            invalid=1
            ;;
        esac
        ;;
      threshold)
        if ! resource_guard_is_non_negative_integer "$value" || (( value > 100 )); then
          printf 'Invalid resource threshold %s: %s\n' "$key" "$value" >&2
          invalid=1
        elif (( value < previous_threshold )); then
          printf 'Resource thresholds must be nondecreasing: %s\n' "$key" >&2
          invalid=1
        else
          previous_threshold="$value"
        fi
        ;;
      profile)
        resource_guard_is_positive_integer "$value" || {
          printf 'Invalid resource profile MiB value %s: %s\n' "$key" "$value" >&2
          invalid=1
        }
        ;;
      cleanup_target)
        if [[ "$value" == /* || "$value" == "." || "$value" == *".."* || "$value" == *"//"* ]]; then
          printf 'Invalid cleanup target path %s: %s\n' "$key" "$value" >&2
          invalid=1
        fi
        if [[ "$value" == ".git" || "$value" == ".git/"* && "$value" != ".git/pre-commit-cache" ]]; then
          printf 'Invalid cleanup target under .git for %s: %s\n' "$key" "$value" >&2
          invalid=1
        fi
        ;;
      *)
        printf 'Unknown resource policy row type: %s\n' "$row_type" >&2
        invalid=1
        ;;
    esac
  done <"$policy_file"

  for required in memory_budget_percent swap_storage_percent swap_gib_limit max_parallel_jobs resource_mode available_memory_floor_percent cleanup_safe_delete_enabled cleanup_older_than_hours cleanup_require_explicit_safe; do
    resource_guard_default_value "$required" >/dev/null 2>&1 || {
      printf 'Missing resource policy default: %s\n' "$required" >&2
      invalid=1
    }
  done
  for required in record_10 record_20 record_30 record_40 notice_50 warning_60 strong_warning_70 stop_new_parallel_80 serial_fallback_90; do
    resource_guard_threshold_value "$required" >/dev/null 2>&1 || {
      printf 'Missing resource threshold: %s\n' "$required" >&2
      invalid=1
    }
  done
  resource_guard_policy_value profile default >/dev/null 2>&1 || {
    printf 'Missing default resource profile.\n' >&2
    invalid=1
  }
  [[ "$invalid" -eq 0 ]]
}

resource_guard_validate_settings() {
  local settings_file
  local invalid=0
  local seen_memory=0
  local seen_swap_percent=0
  local seen_swap_limit=0
  local seen_max_jobs=0
  local seen_mode=0
  local seen_floor=0
  settings_file="$(resource_guard_settings_file)"
  [[ -f "$settings_file" ]] || {
    printf 'Resource settings file is missing: %s\n' "$settings_file" >&2
    return 1
  }
  while IFS=$'\t' read -r key value description extra; do
    [[ -n "${key:-}" ]] || continue
    [[ "$key" != \#* ]] || continue
    if [[ -n "${extra:-}" || -z "${value:-}" || -z "${description:-}" ]]; then
      printf 'Malformed resource settings row for key: %s\n' "${key:-unknown}" >&2
      invalid=1
      continue
    fi
    case "$key" in
      memory_budget_percent)
        seen_memory=1
        if ! resource_guard_is_positive_integer "$value" || (( value > 100 )); then
          printf 'memory_budget_percent must be 1..100: %s\n' "$value" >&2
          invalid=1
        fi
        ;;
      swap_storage_percent)
        seen_swap_percent=1
        if ! resource_guard_is_non_negative_integer "$value" || (( value > 100 )); then
          printf 'swap_storage_percent must be 0..100: %s\n' "$value" >&2
          invalid=1
        fi
        ;;
      swap_gib_limit)
        seen_swap_limit=1
        if ! resource_guard_is_non_negative_integer "$value"; then
          printf 'swap_gib_limit must be a non-negative integer: %s\n' "$value" >&2
          invalid=1
        fi
        ;;
      max_parallel_jobs)
        seen_max_jobs=1
        if [[ "$value" != "auto" ]] && ! resource_guard_is_positive_integer "$value"; then
          printf 'max_parallel_jobs must be auto or a positive integer: %s\n' "$value" >&2
          invalid=1
        fi
        ;;
      resource_mode)
        seen_mode=1
        case "$value" in automatic|serial|parallel) ;; *) printf 'resource_mode must be automatic, serial, or parallel: %s\n' "$value" >&2; invalid=1 ;; esac
        ;;
      available_memory_floor_percent)
        seen_floor=1
        if ! resource_guard_is_non_negative_integer "$value" || (( value > 100 )); then
          printf 'available_memory_floor_percent must be 0..100: %s\n' "$value" >&2
          invalid=1
        fi
        ;;
      cleanup_safe_delete_enabled|cleanup_require_explicit_safe)
        if ! resource_guard_is_boolean "$value"; then
          printf '%s must be true or false: %s\n' "$key" "$value" >&2
          invalid=1
        fi
        ;;
      cleanup_older_than_hours)
        if ! resource_guard_is_non_negative_integer "$value"; then
          printf 'cleanup_older_than_hours must be a non-negative integer: %s\n' "$value" >&2
          invalid=1
        fi
        ;;
      *)
        printf 'Unknown resource setting: %s\n' "$key" >&2
        invalid=1
        ;;
    esac
  done <"$settings_file"

  for pair in \
    "seen_memory memory_budget_percent" \
    "seen_swap_percent swap_storage_percent" \
    "seen_swap_limit swap_gib_limit" \
    "seen_max_jobs max_parallel_jobs" \
    "seen_mode resource_mode" \
    "seen_floor available_memory_floor_percent"; do
    local var_name setting_name
    var_name="${pair%% *}"
    setting_name="${pair#* }"
    if [[ "${!var_name}" -eq 0 ]]; then
      printf 'Missing resource setting: %s\n' "$setting_name" >&2
      invalid=1
    fi
  done
  [[ "$invalid" -eq 0 ]]
}

resource_guard_decision() {
  local profile="${1:-default}"
  local mode usage_percent stage mem_available memory_budget floor_percent floor_mib active_heavy_count
  resource_guard_require_profile "$profile" || return 1
  mode="$(resource_guard_setting_value resource_mode)"
  usage_percent="$(resource_guard_swap_budget_usage_percent)"
  stage="$(resource_guard_usage_stage "$usage_percent")"
  mem_available="$(resource_guard_mem_available_mib)"
  memory_budget="$(resource_guard_memory_budget_mib)"
  floor_percent="$(resource_guard_setting_value available_memory_floor_percent)"
  floor_mib="$(( memory_budget * floor_percent / 100 ))"
  active_heavy_count="$(resource_guard_active_heavy_process_count)"

  if [[ "$stage" == "serial-fallback-or-safe-stop" ]]; then
    printf 'safe-stop'
  elif [[ "$mode" == "serial" ]]; then
    printf 'serial'
  elif [[ "$stage" == "stop-new-parallel-work" ]]; then
    if [[ "$mode" == "parallel" ]]; then
      printf 'safe-stop'
    else
      printf 'serial-fallback'
    fi
  elif (( mem_available > 0 && mem_available < floor_mib )); then
    if [[ "$mode" == "parallel" ]]; then
      printf 'safe-stop'
    else
      printf 'serial-fallback'
    fi
  elif (( active_heavy_count > 0 )); then
    if [[ "$mode" == "parallel" ]]; then
      printf 'safe-stop'
    else
      printf 'serial-fallback'
    fi
  else
    printf 'parallel-allowed'
  fi
}

resource_guard_recommended_jobs() {
  local profile="${1:-default}"
  local decision max_jobs cpu_count memory_budget job_mib jobs
  resource_guard_require_profile "$profile" || return 1
  decision="$(resource_guard_decision "$profile")"
  if [[ "$decision" == "safe-stop" ]]; then
    printf 'Resource guard safe-stop prevents job recommendation for %s.\n' "$profile" >&2
    return 2
  fi
  if [[ "$decision" != "parallel-allowed" ]]; then
    printf '1\n'
    return
  fi
  max_jobs="$(resource_guard_setting_value max_parallel_jobs)"
  cpu_count="$(resource_guard_cpu_count)"
  memory_budget="$(resource_guard_memory_budget_mib)"
  job_mib="$(resource_guard_profile_job_mib "$profile")"
  jobs="$(( memory_budget / job_mib ))"
  (( jobs < 1 )) && jobs=1
  if resource_guard_is_positive_integer "$cpu_count" && (( jobs > cpu_count )); then
    jobs="$cpu_count"
  fi
  if [[ "$max_jobs" != "auto" ]] && (( jobs > max_jobs )); then
    jobs="$max_jobs"
  fi
  printf '%s\n' "$jobs"
}

resource_guard_status_report() {
  local profile="${1:-default}"
  local usage_percent decision recommended_jobs
  resource_guard_require_profile "$profile" || return 1
  usage_percent="$(resource_guard_swap_budget_usage_percent)"
  decision="$(resource_guard_decision "$profile")"
  if [[ "$decision" == "safe-stop" ]]; then
    recommended_jobs="not-available-safe-stop"
  else
    recommended_jobs="$(resource_guard_recommended_jobs "$profile")"
  fi
  printf 'Resource guard status\n'
  printf 'Policy file: %s\n' "$(resource_guard_policy_file)"
  printf 'Settings file: %s\n' "$(resource_guard_settings_file)"
  printf 'Profile: %s\n' "$profile"
  printf 'Resource mode: %s\n' "$(resource_guard_setting_value resource_mode)"
  printf 'Memory budget percent: %s\n' "$(resource_guard_setting_value memory_budget_percent)"
  printf 'Memory total MiB: %s\n' "$(resource_guard_mem_total_mib)"
  printf 'Memory available MiB: %s\n' "$(resource_guard_mem_available_mib)"
  printf 'Memory budget MiB: %s\n' "$(resource_guard_memory_budget_mib)"
  printf 'Swap storage percent: %s\n' "$(resource_guard_setting_value swap_storage_percent)"
  printf 'Swap GiB limit: %s\n' "$(resource_guard_setting_value swap_gib_limit)"
  printf 'Disk free MiB: %s\n' "$(resource_guard_disk_free_mib)"
  printf 'Effective swap budget MiB: %s\n' "$(resource_guard_effective_swap_budget_mib)"
  printf 'System swap total MiB: %s\n' "$(resource_guard_swap_total_mib)"
  printf 'System swap used MiB: %s\n' "$(resource_guard_swap_used_mib)"
  printf 'Active heavy process count: %s\n' "$(resource_guard_active_heavy_process_count)"
  printf 'Repository swap-budget usage percent: %s\n' "$usage_percent"
  printf 'Usage stage: %s\n' "$(resource_guard_usage_stage "$usage_percent")"
  printf 'Decision: %s\n' "$decision"
  printf 'Recommended jobs: %s\n' "$recommended_jobs"
}

resource_guard_check_profile() {
  local profile="${1:-default}"
  local decision
  resource_guard_validate_policy || return 1
  resource_guard_validate_settings || return 1
  resource_guard_require_profile "$profile" || return 1
  resource_guard_status_report "$profile"
  decision="$(resource_guard_decision "$profile")"
  case "$decision" in
    safe-stop)
      printf 'Resource guard: serial fallback or safe stop is required before new heavy parallel work.\n'
      return 2
      ;;
    serial-fallback)
      printf 'Resource guard: serial fallback is recommended for this profile.\n'
      ;;
    serial)
      printf 'Resource guard: serial mode is selected.\n'
      ;;
    parallel-allowed)
      printf 'Resource guard: limited parallel execution is allowed for this profile.\n'
      ;;
  esac
}

resource_guard_cleanup_parse_hours() {
  local value="$1"
  if [[ "$value" =~ ^([0-9]+)h?$ ]]; then
    printf '%s\n' "${BASH_REMATCH[1]}"
  else
    printf 'Invalid cleanup older-than value: %s\n' "$value" >&2
    return 1
  fi
}

resource_guard_cleanup_profile_known() {
  local profile="$1"
  [[ "$profile" == "all" ]] || resource_guard_require_profile "$profile"
}

resource_guard_cleanup_profile_matches() {
  local profiles="$1"
  local requested="$2"
  local profile
  [[ "$requested" == "all" ]] && return 0
  IFS=',' read -r -a profile_items <<<"$profiles"
  for profile in "${profile_items[@]}"; do
    profile="${profile//[[:space:]]/}"
    if [[ "$profile" == "$requested" ]]; then
      return 0
    fi
  done
  return 1
}

resource_guard_cleanup_relative_path_valid() {
  local relpath="$1"
  case "$relpath" in
    ""|/*|.|..|../*|*/../*|*/..|*//*)
      printf 'Unsafe cleanup target path: %s\n' "$relpath" >&2
      return 1
      ;;
  esac
  if [[ "$relpath" == ".git" || ( "$relpath" == ".git/"* && "$relpath" != ".git/pre-commit-cache" ) ]]; then
    printf 'Unsafe cleanup target under .git: %s\n' "$relpath" >&2
    return 1
  fi
}

resource_guard_cleanup_reject_symlink_components() {
  local relpath="$1"
  local root current part
  local -a path_parts
  root="$(resource_guard_root)"
  current="$root"
  IFS='/' read -r -a path_parts <<<"$relpath"
  for part in "${path_parts[@]}"; do
    current="$current/$part"
    if [[ -L "$current" ]]; then
      printf 'Cleanup target contains symlink: %s\n' "$relpath" >&2
      return 1
    fi
    [[ -e "$current" ]] || break
  done
}

resource_guard_cleanup_resolved_path() {
  local relpath="$1"
  local root root_real target target_real
  resource_guard_cleanup_relative_path_valid "$relpath" || return 1
  resource_guard_cleanup_reject_symlink_components "$relpath" || return 1
  root="$(resource_guard_root)"
  root_real="$(realpath -m "$root")"
  target="$root/$relpath"
  target_real="$(realpath -m "$target")"
  case "$target_real" in
    "$root_real"/*) ;;
    *)
      printf 'Cleanup target escapes repository: %s\n' "$relpath" >&2
      return 1
      ;;
  esac
  printf '%s\n' "$target"
}

resource_guard_cleanup_target_old_enough() {
  local target_path="$1"
  local older_than_hours="$2"
  local older_than_minutes found
  if (( older_than_hours <= 0 )); then
    return 0
  fi
  older_than_minutes="$(( older_than_hours * 60 ))"
  found="$(find "$target_path" -maxdepth 0 -mmin +"$older_than_minutes" -print -quit 2>/dev/null || true)"
  [[ -n "$found" ]]
}

resource_guard_cleanup_target_size() {
  local target_path="$1"
  du -sh "$target_path" 2>/dev/null | awk 'NR == 1 { print $1; found = 1 } END { if (!found) print "unknown" }'
}

resource_guard_cleanup_preflight_safe() {
  local policy_file="$1"
  local profile="$2"
  local row_type key relpath profiles description extra target_path
  local invalid=0

  while IFS=$'\t' read -r row_type key relpath profiles description extra; do
    [[ -n "${row_type:-}" ]] || continue
    [[ "$row_type" != \#* ]] || continue
    [[ "$row_type" == "cleanup_target" ]] || continue

    if [[ -n "${extra:-}" || -z "${key:-}" || -z "${relpath:-}" || -z "${profiles:-}" || -z "${description:-}" ]]; then
      printf 'cleanup-error\t%s\tmalformed-cleanup-target\n' "${key:-unknown}"
      invalid=1
      continue
    fi

    resource_guard_cleanup_profile_matches "$profiles" "$profile" || continue

    if ! target_path="$(resource_guard_cleanup_resolved_path "$relpath")"; then
      printf 'cleanup-error\t%s\t%s\tunsafe-path\n' "$key" "$relpath"
      invalid=1
      continue
    fi

    if [[ -L "$target_path" ]]; then
      printf 'cleanup-error\t%s\t%s\tsymlink-rejected\n' "$key" "$relpath"
      invalid=1
      continue
    fi

    if [[ -e "$target_path" && "$relpath" == ".git/pre-commit-cache" ]]; then
      if [[ ! -f "$target_path/.git-hooks-cache" || "$(sed -n '1p' "$target_path/.git-hooks-cache")" != "git-hooks-cache-v1" ]]; then
        printf 'cleanup-error\t%s\t%s\tmissing-or-invalid-cache-marker\n' "$key" "$relpath"
        invalid=1
      fi
    fi
  done <"$policy_file"

  [[ "$invalid" -eq 0 ]]
}

resource_guard_cleanup_plan() {
  local action="$1"
  local profile="$2"
  local older_than_hours="$3"
  local explicit_safe="${4:-false}"
  local policy_file key relpath profiles description extra
  local matched=0
  local invalid=0
  local target_path target_size

  case "$action" in
    dry-run|safe) ;;
    *) printf 'Unknown cleanup action: %s\n' "$action" >&2; return 1 ;;
  esac

  resource_guard_validate_policy || return 1
  resource_guard_validate_settings || return 1
  resource_guard_cleanup_profile_known "$profile" || return 1
  if [[ -z "$older_than_hours" ]]; then
    older_than_hours="$(resource_guard_setting_value cleanup_older_than_hours)"
  fi
  resource_guard_is_non_negative_integer "$older_than_hours" || {
    printf 'cleanup older-than hours must be a non-negative integer: %s\n' "$older_than_hours" >&2
    return 1
  }

  if [[ "$action" == "safe" ]]; then
    if [[ "$(resource_guard_setting_value cleanup_safe_delete_enabled)" != "true" ]]; then
      printf 'Resource cleanup safe deletion is disabled by settings.\n' >&2
      return 1
    fi
    if [[ "$(resource_guard_setting_value cleanup_require_explicit_safe)" == "true" && "$explicit_safe" != "true" ]]; then
      printf 'Resource cleanup safe deletion requires an explicit safe flag.\n' >&2
      return 1
    fi
  fi

  policy_file="$(resource_guard_policy_file)"
  printf 'Resource guard cleanup\n'
  printf 'Action: %s\n' "$action"
  printf 'Profile: %s\n' "$profile"
  printf 'Older-than hours: %s\n' "$older_than_hours"

  if [[ "$action" == "safe" ]]; then
    resource_guard_cleanup_preflight_safe "$policy_file" "$profile" || return 1
  fi

  while IFS=$'\t' read -r row_type key relpath profiles description extra; do
    [[ -n "${row_type:-}" ]] || continue
    [[ "$row_type" != \#* ]] || continue
    [[ "$row_type" == "cleanup_target" ]] || continue

    if [[ -n "${extra:-}" || -z "${key:-}" || -z "${relpath:-}" || -z "${profiles:-}" || -z "${description:-}" ]]; then
      printf 'cleanup-error\t%s\tmalformed-cleanup-target\n' "${key:-unknown}"
      invalid=1
      continue
    fi

    resource_guard_cleanup_profile_matches "$profiles" "$profile" || continue
    matched=1

    if ! target_path="$(resource_guard_cleanup_resolved_path "$relpath")"; then
      printf 'cleanup-error\t%s\t%s\tunsafe-path\n' "$key" "$relpath"
      invalid=1
      continue
    fi

    if [[ -L "$target_path" ]]; then
      printf 'cleanup-error\t%s\t%s\tsymlink-rejected\n' "$key" "$relpath"
      invalid=1
      continue
    fi

    if [[ ! -e "$target_path" ]]; then
      printf 'cleanup-missing\t%s\t%s\t%s\n' "$key" "$relpath" "$description"
      continue
    fi

    if [[ "$relpath" == ".git/pre-commit-cache" ]]; then
      if [[ ! -f "$target_path/.git-hooks-cache" || "$(sed -n '1p' "$target_path/.git-hooks-cache")" != "git-hooks-cache-v1" ]]; then
        printf 'cleanup-error\t%s\t%s\tmissing-or-invalid-cache-marker\n' "$key" "$relpath"
        invalid=1
        continue
      fi
    fi

    if ! resource_guard_cleanup_target_old_enough "$target_path" "$older_than_hours"; then
      printf 'cleanup-kept-recent\t%s\t%s\t%s\n' "$key" "$relpath" "$description"
      continue
    fi

    target_size="$(resource_guard_cleanup_target_size "$target_path")"
    if [[ "$action" == "dry-run" ]]; then
      printf 'cleanup-would-delete\t%s\t%s\t%s\t%s\n' "$key" "$relpath" "$target_size" "$description"
    else
      if rm -rf -- "$target_path"; then
        printf 'cleanup-deleted\t%s\t%s\t%s\t%s\n' "$key" "$relpath" "$target_size" "$description"
      else
        printf 'cleanup-error\t%s\t%s\tdelete-failed\n' "$key" "$relpath"
        invalid=1
      fi
    fi
  done <"$policy_file"

  if [[ "$matched" -eq 0 ]]; then
    printf 'cleanup-no-targets\t%s\n' "$profile"
  fi

  [[ "$invalid" -eq 0 ]]
}
