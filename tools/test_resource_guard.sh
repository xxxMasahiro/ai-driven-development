#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

POLICY_FILE="$TMP_DIR/resource-policy.tsv"
SETTINGS_FILE="$TMP_DIR/resource-settings.tsv"
MEMINFO_FILE="$TMP_DIR/meminfo"

cat >"$POLICY_FILE" <<'EOF'
# row_type	key	value	label	description
default	memory_budget_percent	40	Memory budget percent	Test default.
default	swap_storage_percent	20	Swap storage percent	Test default.
default	swap_gib_limit	16	Swap GiB limit	Test default.
default	max_parallel_jobs	auto	Maximum parallel jobs	Test default.
default	resource_mode	automatic	Resource mode	Test default.
default	available_memory_floor_percent	25	Available memory floor percent	Test default.
default	cleanup_safe_delete_enabled	true	Cleanup safe delete enabled	Test default.
default	cleanup_older_than_hours	0	Cleanup older-than hours	Test default.
default	cleanup_require_explicit_safe	true	Cleanup requires explicit safe flag	Test default.
threshold	record_10	10	Record only	Test threshold.
threshold	record_20	20	Record only	Test threshold.
threshold	record_30	30	Record only	Test threshold.
threshold	record_40	40	Record only	Test threshold.
threshold	notice_50	50	Notice	Test threshold.
threshold	warning_60	60	Warning	Test threshold.
threshold	strong_warning_70	70	Strong warning	Test threshold.
threshold	stop_new_parallel_80	80	Stop new parallel work	Test threshold.
threshold	serial_fallback_90	90	Serial fallback or safe stop	Test threshold.
profile	git-hooks-full	2048	Git hooks full verification	Test profile.
profile	playwright	4096	Playwright browser checks	Test profile.
profile	aggregate	4096	Aggregate lesson checks	Test profile.
profile	default	2048	Default heavy work	Test profile.
EOF

cat >"$SETTINGS_FILE" <<'EOF'
# key	value	description
memory_budget_percent	40	Test memory budget.
swap_storage_percent	40	Test swap storage percentage.
swap_gib_limit	64	Test swap GiB cap.
max_parallel_jobs	auto	Test automatic job selection.
resource_mode	automatic	Test automatic mode.
available_memory_floor_percent	25	Test available memory floor.
EOF

cat >"$MEMINFO_FILE" <<'EOF'
MemTotal:       16777216 kB
MemAvailable:   8388608 kB
SwapTotal:       4194304 kB
SwapFree:        3145728 kB
EOF

run_guard() {
  RESOURCE_GUARD_POLICY_FILE="$POLICY_FILE" \
  RESOURCE_GUARD_SETTINGS_FILE="$SETTINGS_FILE" \
  RESOURCE_GUARD_MEMINFO_FILE="$MEMINFO_FILE" \
  RESOURCE_GUARD_DISK_FREE_MIB="102400" \
  RESOURCE_GUARD_CPU_COUNT="8" \
  RESOURCE_GUARD_ACTIVE_HEAVY_COUNT="${TEST_ACTIVE_HEAVY_COUNT:-0}" \
  "$ROOT/tools/resource-guard" "$@"
}

status_output="$(run_guard status --profile git-hooks-full)"
[[ "$status_output" == *"Memory budget MiB: 6553"* ]]
[[ "$status_output" == *"Effective swap budget MiB: 40960"* ]]
[[ "$status_output" == *"Active heavy process count: 0"* ]]
[[ "$status_output" == *"Repository swap-budget usage percent: 2"* ]]
[[ "$status_output" == *"Usage stage: record-only"* ]]
[[ "$status_output" == *"Decision: parallel-allowed"* ]]

jobs="$(run_guard recommend-jobs --profile git-hooks-full --value-only)"
[[ "$jobs" == "3" ]]

heavy_output="$(TEST_ACTIVE_HEAVY_COUNT=2 run_guard check --profile git-hooks-full)"
[[ "$heavy_output" == *"Active heavy process count: 2"* ]]
[[ "$heavy_output" == *"Decision: serial-fallback"* ]]
[[ "$(TEST_ACTIVE_HEAVY_COUNT=2 run_guard recommend-jobs --profile git-hooks-full --value-only)" == "1" ]]

monitor_output="$(run_guard monitor --profile git-hooks-full)"
[[ "$monitor_output" == *"Usage stage: record-only"* ]]

if run_guard status --profile unknown >/dev/null 2>&1; then
  printf 'unknown resource profile passed unexpectedly\n' >&2
  exit 1
fi
if run_guard monitor --profile unknown >/dev/null 2>&1; then
  printf 'unknown resource profile monitor passed unexpectedly\n' >&2
  exit 1
fi

cat >"$MEMINFO_FILE" <<'EOF'
MemTotal:       16777216 kB
MemAvailable:   8388608 kB
SwapTotal:      41943040 kB
SwapFree:        2097152 kB
EOF

set +e
high_output="$(run_guard check --profile git-hooks-full 2>&1)"
high_status="$?"
set -e
if [[ "$high_status" -eq 0 ]]; then
  printf 'safe-stop resource check passed unexpectedly\n' >&2
  exit 1
fi
[[ "$high_status" == "2" ]]
[[ "$high_output" == *"Usage stage: serial-fallback-or-safe-stop"* ]]
[[ "$high_output" == *"Decision: safe-stop"* ]]
set +e
high_jobs_output="$(run_guard recommend-jobs --profile git-hooks-full --value-only 2>&1)"
high_jobs_status="$?"
set -e
[[ "$high_jobs_status" == "2" ]]
[[ "$high_jobs_output" == *"Resource guard safe-stop prevents job recommendation"* ]]

cat >"$MEMINFO_FILE" <<'EOF'
MemTotal:       16777216 kB
MemAvailable:    524288 kB
SwapTotal:       4194304 kB
SwapFree:        3145728 kB
EOF

low_memory_output="$(run_guard check --profile git-hooks-full)"
[[ "$low_memory_output" == *"Decision: serial-fallback"* ]]

cat >"$SETTINGS_FILE" <<'EOF'
# key	value	description
memory_budget_percent	40	Test memory budget.
swap_storage_percent	40	Test swap storage percentage.
swap_gib_limit	64	Test swap GiB cap.
max_parallel_jobs	2	Test fixed job cap.
resource_mode	automatic	Test automatic mode.
available_memory_floor_percent	25	Test available memory floor.
EOF
cat >"$MEMINFO_FILE" <<'EOF'
MemTotal:       16777216 kB
MemAvailable:   8388608 kB
SwapTotal:       4194304 kB
SwapFree:        3145728 kB
EOF
[[ "$(run_guard recommend-jobs --profile git-hooks-full --value-only)" == "2" ]]

cat >"$SETTINGS_FILE" <<'EOF'
# key	value	description
memory_budget_percent	0	Invalid memory budget.
swap_storage_percent	40	Test swap storage percentage.
swap_gib_limit	64	Test swap GiB cap.
max_parallel_jobs	auto	Test automatic job selection.
resource_mode	automatic	Test automatic mode.
available_memory_floor_percent	25	Test available memory floor.
EOF
if run_guard status >/dev/null 2>&1; then
  printf 'invalid resource settings passed unexpectedly\n' >&2
  exit 1
fi

cat >"$SETTINGS_FILE" <<'EOF'
# key	value	description
memory_budget_percent	40	Test memory budget.
swap_storage_percent	40	Test swap storage percentage.
swap_gib_limit	64	Test swap GiB cap.
max_parallel_jobs	auto	Test automatic job selection.
resource_mode	serial	Test serial mode.
available_memory_floor_percent	25	Test available memory floor.
EOF
serial_output="$(run_guard check --profile playwright)"
[[ "$serial_output" == *"Decision: serial"* ]]
[[ "$(run_guard recommend-jobs --profile playwright --value-only)" == "1" ]]

cat >"$MEMINFO_FILE" <<'EOF'
MemTotal:       16777216 kB
MemAvailable:   8388608 kB
SwapTotal:      41943040 kB
SwapFree:        2097152 kB
EOF
set +e
serial_safe_stop_output="$(run_guard check --profile playwright 2>&1)"
serial_safe_stop_status="$?"
set -e
[[ "$serial_safe_stop_status" == "2" ]]
[[ "$serial_safe_stop_output" == *"Decision: safe-stop"* ]]

cat >"$SETTINGS_FILE" <<'EOF'
# key	value	description
memory_budget_percent	40	Test memory budget.
swap_storage_percent	40	Test swap storage percentage.
swap_gib_limit	64	Test swap GiB cap.
max_parallel_jobs	auto	Test automatic job selection.
resource_mode	parallel	Test explicit parallel mode.
available_memory_floor_percent	25	Test available memory floor.
EOF
cat >"$MEMINFO_FILE" <<'EOF'
MemTotal:       16777216 kB
MemAvailable:   8388608 kB
SwapTotal:       4194304 kB
SwapFree:        3145728 kB
EOF
parallel_output="$(run_guard check --profile git-hooks-full)"
[[ "$parallel_output" == *"Decision: parallel-allowed"* ]]
[[ "$(run_guard recommend-jobs --profile git-hooks-full --value-only)" == "3" ]]
set +e
parallel_heavy_output="$(TEST_ACTIVE_HEAVY_COUNT=2 run_guard check --profile git-hooks-full 2>&1)"
parallel_heavy_status="$?"
set -e
[[ "$parallel_heavy_status" == "2" ]]
[[ "$parallel_heavy_output" == *"Decision: safe-stop"* ]]
set +e
parallel_jobs_output="$(TEST_ACTIVE_HEAVY_COUNT=2 run_guard recommend-jobs --profile git-hooks-full --value-only 2>&1)"
parallel_jobs_status="$?"
set -e
[[ "$parallel_jobs_status" == "2" ]]
[[ "$parallel_jobs_output" == *"Resource guard safe-stop prevents job recommendation"* ]]

awk 'BEGIN { FS=OFS="\t" } $1 == "default" && $2 == "available_memory_floor_percent" { $3 = "101" } { print }' "$POLICY_FILE" >"$TMP_DIR/invalid-policy.tsv"
if RESOURCE_GUARD_POLICY_FILE="$TMP_DIR/invalid-policy.tsv" \
  RESOURCE_GUARD_SETTINGS_FILE="$SETTINGS_FILE" \
  RESOURCE_GUARD_MEMINFO_FILE="$MEMINFO_FILE" \
  RESOURCE_GUARD_DISK_FREE_MIB="102400" \
  RESOURCE_GUARD_CPU_COUNT="8" \
  RESOURCE_GUARD_ACTIVE_HEAVY_COUNT="0" \
  "$ROOT/tools/resource-guard" status >/dev/null 2>&1; then
  printf 'invalid available_memory_floor_percent policy passed unexpectedly\n' >&2
  exit 1
fi

printf 'Resource guard tests passed.\n'
