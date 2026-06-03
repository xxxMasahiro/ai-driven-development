#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

POLICY_FILE="$TMP_DIR/policy.tsv"
SETTINGS_FILE="$TMP_DIR/settings.tsv"
CHECKS_FILE="$TMP_DIR/checks.tsv"
RECOMMENDATION_FILE="$TMP_DIR/recommendation-paths.tsv"
CACHE_DIR="$TMP_DIR/cache"
TEST_REPO="$TMP_DIR/repo"

mkdir -p "$TEST_REPO"
git -C "$TEST_REPO" init -q
git -C "$TEST_REPO" config user.name "Git Hooks Test"
git -C "$TEST_REPO" config user.email "git-hooks-test@example.com"
printf 'test repo\n' >"$TEST_REPO/README.md"
git -C "$TEST_REPO" add README.md
git -C "$TEST_REPO" commit -q -m "Initial test repo"

cat >"$POLICY_FILE" <<'EOF'
# key	allowed_values	default_value	label	description
hook_mode	full|fast|minimal	fast	Git hooks mode	Test policy.
EOF

cat >"$RECOMMENDATION_FILE" <<'EOF'
# pattern	recommendation	reason
.github/workflows/	full-no-cache	CI workflow changes need full verification.
docs/workflow/GIT_HOOK_CHECKS.tsv	full-no-cache	Check-list changes need full verification.
tools/test_*.sh	full-no-cache	Regression-test changes need full verification.
EOF

write_check_script() {
  local path="$1"
  local counter="$2"
  local exit_code="${3:-0}"
  cat >"$path" <<EOF
#!/usr/bin/env bash
set -euo pipefail
count=0
if [[ -f "$counter" ]]; then
  count="\$(cat "$counter")"
fi
count=\$((count + 1))
printf '%s\n' "\$count" >"$counter"
exit "$exit_code"
EOF
  chmod +x "$path"
}

run_git_hooks() {
  LESSON_ROOT="$TEST_REPO" \
  GIT_HOOKS_POLICY_FILE="$POLICY_FILE" \
  GIT_HOOKS_SETTINGS_FILE="$SETTINGS_FILE" \
  GIT_HOOKS_CHECKS_FILE="$CHECKS_FILE" \
  GIT_HOOKS_RECOMMENDATION_PATHS_FILE="$RECOMMENDATION_FILE" \
  GIT_HOOKS_CACHE_DIR="$CACHE_DIR" \
  "$ROOT/tools/git-hooks" "$@"
}

run_git_hooks_with_cache() {
  local cache_dir="$1"
  shift
  LESSON_ROOT="$TEST_REPO" \
  GIT_HOOKS_POLICY_FILE="$POLICY_FILE" \
  GIT_HOOKS_SETTINGS_FILE="$SETTINGS_FILE" \
  GIT_HOOKS_CHECKS_FILE="$CHECKS_FILE" \
  GIT_HOOKS_RECOMMENDATION_PATHS_FILE="$RECOMMENDATION_FILE" \
  GIT_HOOKS_CACHE_DIR="$cache_dir" \
  "$ROOT/tools/git-hooks" "$@"
}

write_check_script "$TMP_DIR/cache_check.sh" "$TMP_DIR/cache_count"
write_check_script "$TMP_DIR/full_check.sh" "$TMP_DIR/full_count"
write_check_script "$TMP_DIR/minimal_check.sh" "$TMP_DIR/minimal_count"
write_check_script "$TMP_DIR/fail_check.sh" "$TMP_DIR/fail_count" 1

cat >"$CHECKS_FILE" <<EOF
# check_id	modes	command	description
cache_check	full|fast	$TMP_DIR/cache_check.sh	Cache test.
minimal_check	minimal|fast	$TMP_DIR/minimal_check.sh	Minimal test.
EOF

run_git_hooks status >/dev/null
recommend_output="$(run_git_hooks recommend --paths README.md)"
[[ "$recommend_output" == *"Recommended command: ./tools/git-hooks run --mode minimal"* ]]
recommend_output="$(run_git_hooks recommend --paths docs/workflow/GIT_HOOK_CHECKS.tsv)"
[[ "$recommend_output" == *"Recommended command: ./tools/git-hooks run --mode full --no-cache"* ]]
[[ "$recommend_output" == *"docs/workflow/GIT_HOOK_CHECKS.tsv"* ]]
recommend_output="$(run_git_hooks recommend --paths ./.github/workflows/ci.yml)"
[[ "$recommend_output" == *"Recommended command: ./tools/git-hooks run --mode full --no-cache"* ]]
recommend_output="$(run_git_hooks recommend --paths "$TEST_REPO/tools/test_git_hooks.sh")"
[[ "$recommend_output" == *"Recommended command: ./tools/git-hooks run --mode full --no-cache"* ]]
recommend_output="$(run_git_hooks recommend --paths tools/test_git_hooks.sh)"
[[ "$recommend_output" == *"Recommended command: ./tools/git-hooks run --mode full --no-cache"* ]]
mkdir -p "$TEST_REPO/.github/workflows"
printf 'name: changed\n' >"$TEST_REPO/.github/workflows/ci.yml"
recommend_output="$(run_git_hooks recommend)"
[[ "$recommend_output" == *"Recommended command: ./tools/git-hooks run --mode full --no-cache"* ]]
rm -rf "$TEST_REPO/.github"
cat >"$RECOMMENDATION_FILE" <<'EOF'
# pattern	recommendation	reason
tools/test_*.sh	bogus	Invalid recommendation must fail closed.
EOF
if run_git_hooks recommend --paths tools/test_git_hooks.sh >/dev/null 2>&1; then
  printf 'invalid recommendation row passed unexpectedly\n' >&2
  exit 1
fi
cat >"$RECOMMENDATION_FILE" <<'EOF'
# pattern	recommendation	reason
.github/workflows/	full-no-cache	CI workflow changes need full verification.
docs/workflow/GIT_HOOK_CHECKS.tsv	full-no-cache	Check-list changes need full verification.
tools/test_*.sh	full-no-cache	Regression-test changes need full verification.
EOF
run_git_hooks mode fast >/dev/null
[[ "$(awk -F '\t' '$1 == "hook_mode" { print $2 }' "$SETTINGS_FILE")" == "fast" ]]

if run_git_hooks mode off >/dev/null 2>&1; then
  printf 'invalid hook mode was accepted\n' >&2
  exit 1
fi

{
  printf '# key\tvalue\n'
  printf 'hook_mode\toff\n'
} >"$SETTINGS_FILE"
if run_git_hooks mode >/dev/null 2>&1; then
  printf 'invalid persisted hook mode was reported as current\n' >&2
  exit 1
fi
if run_git_hooks status >/dev/null 2>&1; then
  printf 'invalid persisted hook mode was accepted by status\n' >&2
  exit 1
fi
run_git_hooks mode fast >/dev/null

run_git_hooks run --mode fast >/dev/null
run_git_hooks run --mode fast >/dev/null
[[ "$(cat "$TMP_DIR/cache_count")" == "1" ]]
[[ "$(cat "$TMP_DIR/minimal_count")" == "1" ]]

printf '# changed command identity\n' >>"$TMP_DIR/cache_check.sh"
run_git_hooks run --mode fast >/dev/null
[[ "$(cat "$TMP_DIR/cache_count")" == "2" ]]

run_git_hooks run --mode fast --no-cache >/dev/null
[[ "$(cat "$TMP_DIR/cache_count")" == "3" ]]

rm -f "$TMP_DIR/full_count" "$TMP_DIR/minimal_count"
cat >"$CHECKS_FILE" <<EOF
# check_id	modes	command	description
full_check	full|fast	$TMP_DIR/full_check.sh	Full test.
minimal_check	minimal	$TMP_DIR/minimal_check.sh	Minimal test.
EOF
run_git_hooks run --mode minimal --no-cache >/dev/null
[[ ! -f "$TMP_DIR/full_count" ]]
[[ "$(cat "$TMP_DIR/minimal_count")" == "1" ]]

cat >"$CHECKS_FILE" <<EOF
# check_id	modes	command	description
malformed_check	full|fast		Missing command must fail closed.
EOF
if run_git_hooks run --mode fast --no-cache >/dev/null 2>&1; then
  printf 'malformed hook check row passed unexpectedly\n' >&2
  exit 1
fi
cat >"$CHECKS_FILE" <<EOF
# check_id	modes	command	description
whitespace_check	full|fast	   	Whitespace command must fail closed.
EOF
if run_git_hooks run --mode fast --no-cache >/dev/null 2>&1; then
  printf 'whitespace-only hook command passed unexpectedly\n' >&2
  exit 1
fi
cat >"$CHECKS_FILE" <<EOF
# check_id	modes	command	description
extra_field_check	full|fast	$TMP_DIR/cache_check.sh	Description	Unexpected field.
EOF
if run_git_hooks run --mode fast --no-cache >/dev/null 2>&1; then
  printf 'extra-field hook check row passed unexpectedly\n' >&2
  exit 1
fi
cat >"$CHECKS_FILE" <<EOF
# check_id	modes	command	description
invalid_mode_check	full|fas	$TMP_DIR/cache_check.sh	Invalid mode token must fail closed.
EOF
if run_git_hooks run --mode fast --no-cache >/dev/null 2>&1; then
  printf 'invalid-mode hook check row passed unexpectedly\n' >&2
  exit 1
fi
cat >"$CHECKS_FILE" <<EOF
# check_id	modes	command	description
leading_invalid_mode_check	bogus|fast	$TMP_DIR/cache_check.sh	Leading invalid mode token must fail closed.
EOF
if run_git_hooks run --mode fast --no-cache >/dev/null 2>&1; then
  printf 'leading-invalid-mode hook check row passed unexpectedly\n' >&2
  exit 1
fi
cat >"$CHECKS_FILE" <<EOF
# check_id	modes	command	description
trailing_invalid_mode_check	fast|bogus	$TMP_DIR/cache_check.sh	Trailing invalid mode token must fail closed.
EOF
if run_git_hooks run --mode fast --no-cache >/dev/null 2>&1; then
  printf 'trailing-invalid-mode hook check row passed unexpectedly\n' >&2
  exit 1
fi
cat >"$CHECKS_FILE" <<EOF
# check_id	modes	command	description
empty_mode_token_check	full||fast	$TMP_DIR/cache_check.sh	Empty mode token must fail closed.
EOF
if run_git_hooks run --mode fast --no-cache >/dev/null 2>&1; then
  printf 'empty-mode-token hook check row passed unexpectedly\n' >&2
  exit 1
fi

rm -rf "$CACHE_DIR"
cat >"$CHECKS_FILE" <<EOF
# check_id	modes	command	description
fail_check	full|fast	$TMP_DIR/fail_check.sh	Failure test.
EOF
if run_git_hooks run --mode fast >/dev/null 2>&1; then
  printf 'failing hook check passed unexpectedly\n' >&2
  exit 1
fi
if [[ -f "$CACHE_DIR/fail_check.cache" ]]; then
  printf 'failing hook check was cached\n' >&2
  exit 1
fi

unsafe_cache="$TMP_DIR/not-a-cache"
mkdir -p "$unsafe_cache"
printf 'keep\n' >"$unsafe_cache/keep.txt"
if run_git_hooks_with_cache "$unsafe_cache" cache clear >/dev/null 2>&1; then
  printf 'unmarked non-empty cache directory was cleared\n' >&2
  exit 1
fi
[[ -f "$unsafe_cache/keep.txt" ]]

run_git_hooks cache clear >/dev/null
[[ -d "$CACHE_DIR" ]]
[[ -f "$CACHE_DIR/.git-hooks-cache" ]]

printf 'Git hooks policy tests passed.\n'
