#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

POLICY_FILE="$TMP_DIR/resource-policy.tsv"
SETTINGS_FILE="$TMP_DIR/resource-settings.tsv"
MEMINFO_FILE="$TMP_DIR/meminfo"
REPO_ROOT="$TMP_DIR/repo"

write_policy() {
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
cleanup_target	playwright-report	playwright-report	playwright	Test Playwright report.
cleanup_target	playwright-results	test-results	playwright	Test Playwright results.
cleanup_target	git-hooks-cache	.git/pre-commit-cache	git-hooks-full	Test Git hooks cache.
cleanup_target	resource-temp	tmp/resource-guard	all	Test repo-local temporary directory.
EOF
}

write_settings() {
  cat >"$SETTINGS_FILE" <<'EOF'
# key	value	description
memory_budget_percent	40	Test memory budget.
swap_storage_percent	20	Test swap storage percentage.
swap_gib_limit	16	Test swap GiB cap.
max_parallel_jobs	auto	Test automatic job selection.
resource_mode	automatic	Test automatic mode.
available_memory_floor_percent	25	Test available memory floor.
cleanup_safe_delete_enabled	true	Test explicit safe cleanup.
cleanup_older_than_hours	0	Test cleanup age.
cleanup_require_explicit_safe	true	Test explicit safe cleanup flag.
EOF
}

write_meminfo() {
  cat >"$MEMINFO_FILE" <<'EOF'
MemTotal:       16777216 kB
MemAvailable:   8388608 kB
SwapTotal:       4194304 kB
SwapFree:        3145728 kB
EOF
}

reset_repo() {
  rm -rf "$REPO_ROOT"
  mkdir -p "$REPO_ROOT/playwright-report" "$REPO_ROOT/test-results" "$REPO_ROOT/.git/pre-commit-cache" "$REPO_ROOT/tmp/resource-guard"
  printf 'report\n' >"$REPO_ROOT/playwright-report/index.html"
  printf 'result\n' >"$REPO_ROOT/test-results/result.txt"
  printf 'git-hooks-cache-v1\n' >"$REPO_ROOT/.git/pre-commit-cache/.git-hooks-cache"
  printf 'cache\n' >"$REPO_ROOT/.git/pre-commit-cache/check.cache"
  printf 'temp\n' >"$REPO_ROOT/tmp/resource-guard/tmp.txt"
}

run_guard() {
  RESOURCE_GUARD_POLICY_FILE="$POLICY_FILE" \
  RESOURCE_GUARD_SETTINGS_FILE="$SETTINGS_FILE" \
  RESOURCE_GUARD_MEMINFO_FILE="$MEMINFO_FILE" \
  RESOURCE_GUARD_ROOT="$REPO_ROOT" \
  RESOURCE_GUARD_DISK_FREE_MIB="102400" \
  RESOURCE_GUARD_CPU_COUNT="8" \
  RESOURCE_GUARD_ACTIVE_HEAVY_COUNT="0" \
  "$ROOT/tools/resource-guard" "$@"
}

run_guard_function_without_explicit_safe() {
  RESOURCE_GUARD_POLICY_FILE="$POLICY_FILE" \
  RESOURCE_GUARD_SETTINGS_FILE="$SETTINGS_FILE" \
  RESOURCE_GUARD_MEMINFO_FILE="$MEMINFO_FILE" \
  RESOURCE_GUARD_ROOT="$REPO_ROOT" \
  RESOURCE_GUARD_DISK_FREE_MIB="102400" \
  RESOURCE_GUARD_CPU_COUNT="8" \
  RESOURCE_GUARD_ACTIVE_HEAVY_COUNT="0" \
  bash -c 'source "$1/tools/lib/resource_guard.sh"; resource_guard_cleanup_plan safe all ""' _ "$ROOT"
}

write_policy
write_settings
write_meminfo
reset_repo

dry_run_output="$(run_guard cleanup --dry-run)"
[[ "$dry_run_output" == *"Action: dry-run"* ]]
[[ "$dry_run_output" == *"cleanup-would-delete	playwright-report	playwright-report"* ]]
[[ "$dry_run_output" == *"cleanup-would-delete	git-hooks-cache	.git/pre-commit-cache"* ]]
[[ -d "$REPO_ROOT/playwright-report" ]]
[[ -d "$REPO_ROOT/test-results" ]]
[[ -d "$REPO_ROOT/.git/pre-commit-cache" ]]

profile_output="$(run_guard cleanup --profile playwright --dry-run)"
[[ "$profile_output" == *"cleanup-would-delete	playwright-report	playwright-report"* ]]
[[ "$profile_output" != *"git-hooks-cache"* ]]

if run_guard_function_without_explicit_safe >/dev/null 2>&1; then
  printf 'safe cleanup without an explicit safe flag passed unexpectedly\n' >&2
  exit 1
fi

safe_output="$(run_guard cleanup --safe --profile playwright)"
[[ "$safe_output" == *"Action: safe"* ]]
[[ "$safe_output" == *"cleanup-deleted	playwright-report	playwright-report"* ]]
[[ ! -e "$REPO_ROOT/playwright-report" ]]
[[ ! -e "$REPO_ROOT/test-results" ]]
[[ -d "$REPO_ROOT/.git/pre-commit-cache" ]]
[[ -d "$REPO_ROOT/tmp/resource-guard" ]]

reset_repo
recent_output="$(run_guard cleanup --safe --older-than 24h --profile playwright)"
[[ "$recent_output" == *"cleanup-kept-recent	playwright-report	playwright-report"* ]]
[[ -d "$REPO_ROOT/playwright-report" ]]

reset_repo
hook_output="$(run_guard cleanup --safe --profile git-hooks-full)"
[[ "$hook_output" == *"cleanup-deleted	git-hooks-cache	.git/pre-commit-cache"* ]]
[[ ! -e "$REPO_ROOT/.git/pre-commit-cache" ]]
[[ -d "$REPO_ROOT/playwright-report" ]]

reset_repo
rm -f "$REPO_ROOT/.git/pre-commit-cache/.git-hooks-cache"
if run_guard cleanup --safe --profile git-hooks-full >/dev/null 2>&1; then
  printf 'unmarked git hooks cache cleanup passed unexpectedly\n' >&2
  exit 1
fi

reset_repo
rm -rf "$REPO_ROOT/test-results"
mkdir -p "$TMP_DIR/outside"
ln -s "$TMP_DIR/outside" "$REPO_ROOT/test-results"
if run_guard cleanup --safe --profile playwright >/dev/null 2>&1; then
  printf 'symlink cleanup passed unexpectedly\n' >&2
  exit 1
fi
[[ -d "$TMP_DIR/outside" ]]

reset_repo
rm -rf "$REPO_ROOT/test-results"
ln -s playwright-report "$REPO_ROOT/test-results"
if run_guard cleanup --safe --profile playwright >/dev/null 2>&1; then
  printf 'repo-local symlink cleanup passed unexpectedly\n' >&2
  exit 1
fi
[[ -d "$REPO_ROOT/playwright-report" ]]

reset_repo
mkdir -p "$REPO_ROOT/real-parent"
rm -rf "$REPO_ROOT/tmp/link-parent"
ln -s "$REPO_ROOT/real-parent" "$REPO_ROOT/tmp/link-parent"
printf 'cleanup_target\tcomponent-symlink\ttmp/link-parent/test-results\taggregate\tTest symlink path component.\n' >>"$POLICY_FILE"
if run_guard cleanup --safe --profile aggregate >/dev/null 2>&1; then
  printf 'symlink path component cleanup passed unexpectedly\n' >&2
  exit 1
fi
[[ -d "$REPO_ROOT/real-parent" ]]

reset_repo
mkdir -p "$REPO_ROOT/git-cache-destination"
rm -rf "$REPO_ROOT/.git/pre-commit-cache"
ln -s "$REPO_ROOT/git-cache-destination" "$REPO_ROOT/.git/pre-commit-cache"
if run_guard cleanup --safe --profile git-hooks-full >/dev/null 2>&1; then
  printf 'git hooks cache symlink cleanup passed unexpectedly\n' >&2
  exit 1
fi
[[ -d "$REPO_ROOT/git-cache-destination" ]]

write_policy
awk 'BEGIN { FS=OFS="\t" } $1 == "cleanup_target" && $2 == "playwright-report" { $3 = "../outside" } { print }' "$POLICY_FILE" >"$TMP_DIR/unsafe-policy.tsv"
if RESOURCE_GUARD_POLICY_FILE="$TMP_DIR/unsafe-policy.tsv" \
  RESOURCE_GUARD_SETTINGS_FILE="$SETTINGS_FILE" \
  RESOURCE_GUARD_MEMINFO_FILE="$MEMINFO_FILE" \
  RESOURCE_GUARD_ROOT="$REPO_ROOT" \
  RESOURCE_GUARD_DISK_FREE_MIB="102400" \
  RESOURCE_GUARD_CPU_COUNT="8" \
  RESOURCE_GUARD_ACTIVE_HEAVY_COUNT="0" \
  "$ROOT/tools/resource-guard" cleanup --dry-run >/dev/null 2>&1; then
  printf 'repo-outside cleanup target passed unexpectedly\n' >&2
  exit 1
fi

write_policy
awk 'BEGIN { FS=OFS="\t" } $1 == "cleanup_safe_delete_enabled" { $2 = "false" } { print }' "$SETTINGS_FILE" >"$TMP_DIR/no-safe-settings.tsv"
if RESOURCE_GUARD_POLICY_FILE="$POLICY_FILE" \
  RESOURCE_GUARD_SETTINGS_FILE="$TMP_DIR/no-safe-settings.tsv" \
  RESOURCE_GUARD_MEMINFO_FILE="$MEMINFO_FILE" \
  RESOURCE_GUARD_ROOT="$REPO_ROOT" \
  RESOURCE_GUARD_DISK_FREE_MIB="102400" \
  RESOURCE_GUARD_CPU_COUNT="8" \
  RESOURCE_GUARD_ACTIVE_HEAVY_COUNT="0" \
  "$ROOT/tools/resource-guard" cleanup --safe >/dev/null 2>&1; then
  printf 'disabled safe cleanup passed unexpectedly\n' >&2
  exit 1
fi

if run_guard cleanup --profile unknown --dry-run >/dev/null 2>&1; then
  printf 'unknown cleanup profile passed unexpectedly\n' >&2
  exit 1
fi

printf 'Resource cleanup tests passed.\n'
