#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

POLICY_FILE="$TMP_DIR/git-hooks-policy.tsv"
SETTINGS_FILE="$TMP_DIR/git-hooks-settings.tsv"
CHECKS_FILE="$TMP_DIR/git-hooks-checks.tsv"
GROUPS_FILE="$TMP_DIR/git-hooks-parallel-groups.tsv"
RECOMMENDATION_FILE="$TMP_DIR/git-hooks-recommendations.tsv"
RESOURCE_POLICY_FILE="$TMP_DIR/resource-policy.tsv"
RESOURCE_SETTINGS_FILE="$TMP_DIR/resource-settings.tsv"
MEMINFO_FILE="$TMP_DIR/meminfo"
CACHE_DIR="$TMP_DIR/cache"
TEST_REPO="$TMP_DIR/repo"

mkdir -p "$TEST_REPO"
git -C "$TEST_REPO" init -q
git -C "$TEST_REPO" config user.name "Git Hooks Parallel Test"
git -C "$TEST_REPO" config user.email "git-hooks-parallel@example.com"
printf 'test repo\n' >"$TEST_REPO/README.md"
git -C "$TEST_REPO" add README.md
git -C "$TEST_REPO" commit -q -m "Initial test repo"

cat >"$POLICY_FILE" <<'EOF'
# key	allowed_values	default_value	label	description
hook_mode	full|fast|minimal	full	Git hooks mode	Test policy.
EOF

cat >"$RECOMMENDATION_FILE" <<'EOF'
# pattern	recommendation	reason
tools/test_*.sh	full-no-cache	Regression-test changes need full verification.
EOF

cat >"$RESOURCE_POLICY_FILE" <<'EOF'
# row_type	key	value	label	description
default	memory_budget_percent	70	Memory budget percent	Test default.
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
profile	default	2048	Default heavy work	Test profile.
EOF

cat >"$RESOURCE_SETTINGS_FILE" <<'EOF'
# key	value	description
memory_budget_percent	70	Test memory budget.
swap_storage_percent	20	Test swap storage percentage.
swap_gib_limit	16	Test swap GiB cap.
max_parallel_jobs	auto	Test automatic job selection.
resource_mode	automatic	Test automatic mode.
available_memory_floor_percent	25	Test available memory floor.
cleanup_safe_delete_enabled	true	Test cleanup toggle.
cleanup_older_than_hours	0	Test cleanup age.
cleanup_require_explicit_safe	true	Test cleanup safety.
EOF

cat >"$MEMINFO_FILE" <<'EOF'
MemTotal:       16777216 kB
MemAvailable:   8388608 kB
SwapTotal:       4194304 kB
SwapFree:        4194304 kB
EOF

write_sleep_script() {
  local path="$1"
  local label="$2"
  local sleep_seconds="$3"
  local exit_code="${4:-0}"
  cat >"$path" <<EOF
#!/usr/bin/env bash
set -euo pipefail
ACTIVE_FILE="$TMP_DIR/active-count"
MAX_FILE="$TMP_DIR/max-active-count"
LOCK_DIR="$TMP_DIR/active-lock"
acquire_lock() {
  while ! mkdir "\$LOCK_DIR" 2>/dev/null; do
    sleep 0.01
  done
}
release_lock() {
  rmdir "\$LOCK_DIR"
}
acquire_lock
active=0
if [[ -f "\$ACTIVE_FILE" ]]; then
  active="\$(cat "\$ACTIVE_FILE")"
fi
active=\$((active + 1))
printf '%s\n' "\$active" >"\$ACTIVE_FILE"
max_active=0
if [[ -f "\$MAX_FILE" ]]; then
  max_active="\$(cat "\$MAX_FILE")"
fi
if (( active > max_active )); then
  printf '%s\n' "\$active" >"\$MAX_FILE"
fi
release_lock
sleep "$sleep_seconds"
printf '%s\n' "$label"
acquire_lock
active="\$(cat "\$ACTIVE_FILE")"
active=\$((active - 1))
printf '%s\n' "\$active" >"\$ACTIVE_FILE"
release_lock
exit "$exit_code"
EOF
  chmod +x "$path"
}

reset_active_counter() {
  rm -rf "$TMP_DIR/active-lock"
  printf '0\n' >"$TMP_DIR/active-count"
  printf '0\n' >"$TMP_DIR/max-active-count"
}

max_active_count() {
  sed -n '1p' "$TMP_DIR/max-active-count"
}

run_git_hooks() {
  LESSON_ROOT="$TEST_REPO" \
  GIT_HOOKS_POLICY_FILE="$POLICY_FILE" \
  GIT_HOOKS_SETTINGS_FILE="$SETTINGS_FILE" \
  GIT_HOOKS_CHECKS_FILE="$CHECKS_FILE" \
  GIT_HOOKS_PARALLEL_GROUPS_FILE="$GROUPS_FILE" \
  GIT_HOOKS_RECOMMENDATION_PATHS_FILE="$RECOMMENDATION_FILE" \
  GIT_HOOKS_CACHE_DIR="$CACHE_DIR" \
  RESOURCE_GUARD_POLICY_FILE="$RESOURCE_POLICY_FILE" \
  RESOURCE_GUARD_SETTINGS_FILE="$RESOURCE_SETTINGS_FILE" \
  RESOURCE_GUARD_MEMINFO_FILE="$MEMINFO_FILE" \
  RESOURCE_GUARD_DISK_FREE_MIB="102400" \
  RESOURCE_GUARD_CPU_COUNT="8" \
  RESOURCE_GUARD_ACTIVE_HEAVY_COUNT="${TEST_ACTIVE_HEAVY_COUNT:-0}" \
  RESOURCE_GUARD_SKIP_LOCAL_CHECK=0 \
  "$ROOT/tools/git-hooks" "$@"
}

write_sleep_script "$TMP_DIR/slow_a.sh" "A finished" 2
write_sleep_script "$TMP_DIR/fast_b.sh" "B finished" 0
write_sleep_script "$TMP_DIR/slow_c.sh" "C finished" 2

cat >"$CHECKS_FILE" <<EOF
# check_id	modes	command	description
slow_a	full	$TMP_DIR/slow_a.sh	Slow first check.
fast_b	full	$TMP_DIR/fast_b.sh	Fast second check.
slow_c	full	$TMP_DIR/slow_c.sh	Slow third check.
EOF

cat >"$GROUPS_FILE" <<'EOF'
# check_id	parallel_group	execution_kind	description
slow_a	test	parallel	Parallel test check.
fast_b	test	parallel	Parallel test check.
slow_c	test	parallel	Parallel test check.
EOF

reset_active_counter
parallel_output="$(run_git_hooks run --mode full --no-cache)"
[[ "$parallel_output" == *"Git hooks checks passed: full mode (3 checks)."* ]]
[[ "$parallel_output" == *"A finished"* ]]
[[ "$parallel_output" == *"B finished"* ]]
[[ "$parallel_output" == *"C finished"* ]]
if (( $(max_active_count) < 2 )); then
  printf 'parallel Git hooks run did not overlap checks\n' >&2
  exit 1
fi
a_line="$(printf '%s\n' "$parallel_output" | awk '/A finished/ { print NR; exit }')"
b_line="$(printf '%s\n' "$parallel_output" | awk '/B finished/ { print NR; exit }')"
if (( a_line >= b_line )); then
  printf 'parallel logs were not replayed in check order\n' >&2
  exit 1
fi

reset_active_counter
serial_output="$(TEST_ACTIVE_HEAVY_COUNT=1 run_git_hooks run --mode full --no-cache)"
[[ "$serial_output" == *"Decision: serial-fallback"* ]]
[[ "$serial_output" == *"Git hooks checks passed: full mode (3 checks)."* ]]
if (( $(max_active_count) != 1 )); then
  printf 'serial fallback Git hooks run overlapped checks unexpectedly\n' >&2
  exit 1
fi

cat >"$GROUPS_FILE" <<'EOF'
# check_id	parallel_group	execution_kind	description
EOF
reset_active_counter
unclassified_output="$(run_git_hooks run --mode full --no-cache)"
[[ "$unclassified_output" == *"Git hooks checks passed: full mode (3 checks)."* ]]
if (( $(max_active_count) != 1 )); then
  printf 'unclassified serial Git hooks check ran as parallel work\n' >&2
  exit 1
fi

write_sleep_script "$TMP_DIR/fail_b.sh" "B failed" 0 1
cat >"$CHECKS_FILE" <<EOF
# check_id	modes	command	description
slow_a	full	$TMP_DIR/slow_a.sh	Slow first check.
fail_b	full	$TMP_DIR/fail_b.sh	Failing second check.
EOF
cat >"$GROUPS_FILE" <<'EOF'
# check_id	parallel_group	execution_kind	description
slow_a	test	parallel	Parallel test check.
fail_b	test	parallel	Parallel test check.
EOF
if run_git_hooks run --mode full --no-cache >/dev/null 2>&1; then
  printf 'failing parallel Git hook check passed unexpectedly\n' >&2
  exit 1
fi

cat >"$GROUPS_FILE" <<'EOF'
# check_id	parallel_group	execution_kind	description
slow_a	test	bogus	Invalid execution kind.
EOF
if run_git_hooks run --mode full --no-cache >/dev/null 2>&1; then
  printf 'invalid parallel group row passed unexpectedly\n' >&2
  exit 1
fi

printf 'Git hooks parallel tests passed.\n'
