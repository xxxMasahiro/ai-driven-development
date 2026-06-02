#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_PREFIX

export GIT_WORKFLOW_SETTINGS_FILE="$TMP_DIR/settings.tsv"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  if [[ "$haystack" != *"$needle"* ]]; then
    printf 'Expected output to contain: %s\n' "$needle" >&2
    printf 'Actual output:\n%s\n' "$haystack" >&2
    exit 1
  fi
}

assert_fails() {
  if "$@" >/tmp/git-workflow-policy-test.out 2>/tmp/git-workflow-policy-test.err; then
    printf 'Expected command to fail: %s\n' "$*" >&2
    exit 1
  fi
}

status_output="$("$ROOT/tools/git-workflow" status --repo "$ROOT")"
assert_contains "$status_output" "Git workflow policy status"
assert_contains "$status_output" "branch_allowed: true"
assert_contains "$status_output" "worktree_allowed: false"
assert_contains "$status_output" "automation_level: manual"
assert_contains "$status_output" "Repository context: lesson"

"$ROOT/tools/git-workflow" set automation_level pr_ci >/dev/null
assert_contains "$("$ROOT/tools/git-workflow" status --repo "$ROOT")" "automation_level: pr_ci"
"$ROOT/tools/git-workflow" allow commit >/dev/null
"$ROOT/tools/git-workflow" allow ci >/dev/null
assert_fails "$ROOT/tools/git-workflow" allow sync

"$ROOT/tools/git-workflow" set worktree_allowed true >/dev/null
"$ROOT/tools/git-workflow" allow worktree >/dev/null
assert_fails "$ROOT/tools/git-workflow" set worktree_allowed maybe
assert_fails "$ROOT/tools/git-workflow" set unknown_setting true

ORIGIN="$TMP_DIR/origin.git"
REPO="$TMP_DIR/repo"
git init --bare "$ORIGIN" >/dev/null
git init "$REPO" >/dev/null
git -C "$REPO" config user.name "Git Workflow Test"
git -C "$REPO" config user.email "git-workflow-test@example.com"
printf 'initial\n' >"$REPO/file.txt"
git -C "$REPO" add file.txt
git -C "$REPO" commit -m "Initial commit" >/dev/null
git -C "$REPO" branch -M main
git -C "$REPO" remote add origin "$ORIGIN"
git -C "$REPO" push -u origin main >/dev/null

check_output="$("$ROOT/tools/git-workflow" check --repo "$REPO")"
assert_contains "$check_output" "Repository context: custom"
assert_contains "$check_output" "Working tree: clean"
assert_contains "$check_output" "Ahead: 0"
assert_contains "$check_output" "Behind: 0"

printf 'untracked\n' >"$REPO/untracked.txt"
assert_fails "$ROOT/tools/git-workflow" check --repo "$REPO"
rm "$REPO/untracked.txt"

printf 'dirty\n' >>"$REPO/file.txt"
assert_fails "$ROOT/tools/git-workflow" check --repo "$REPO"
git -C "$REPO" restore file.txt

PROJECTS="$TMP_DIR/projects"
PRODUCT_WT="$PROJECTS/product-linked"
CONFIG="$TMP_DIR/lesson-config.tsv"
mkdir -p "$PROJECTS"
git -C "$REPO" worktree add "$PRODUCT_WT" -b product-linked >/dev/null
{
  printf '# key\tvalue\n'
  printf 'product_repo_name\tproduct-linked\n'
  printf 'project_root\t%s\n' "$PROJECTS"
} >"$CONFIG"
product_output="$(LESSON_CONFIG="$CONFIG" "$ROOT/tools/git-workflow" status --repo "$PRODUCT_WT")"
assert_contains "$product_output" "Repository context: product"

git -C "$REPO" branch old-merged-branch
cleanup_output="$("$ROOT/tools/git-workflow" cleanup-plan --repo "$REPO")"
assert_contains "$cleanup_output" "Git cleanup plan"
assert_contains "$cleanup_output" "old-merged-branch"
assert_contains "$cleanup_output" "No deletion is performed by this command."

git -C "$REPO" checkout --detach HEAD >/dev/null
detached_cleanup_output="$("$ROOT/tools/git-workflow" cleanup-plan --repo "$REPO")"
if [[ "$detached_cleanup_output" == *"(HEAD"* ]]; then
  printf 'Detached HEAD pseudo-branch appeared in cleanup output:\n%s\n' "$detached_cleanup_output" >&2
  exit 1
fi
git -C "$REPO" switch main >/dev/null

git -C "$REPO" switch -c stale-upstream >/dev/null
git -C "$REPO" push -u origin stale-upstream >/dev/null
git -C "$REPO" switch main >/dev/null
git -C "$REPO" push origin --delete stale-upstream >/dev/null
git -C "$REPO" switch stale-upstream >/dev/null
assert_fails "$ROOT/tools/git-workflow" check --repo "$REPO"
git -C "$REPO" switch main >/dev/null
git -C "$REPO" branch -D stale-upstream >/dev/null

printf 'ahead\n' >>"$REPO/file.txt"
git -C "$REPO" add file.txt
git -C "$REPO" commit -m "Ahead commit" >/dev/null
assert_fails "$ROOT/tools/git-workflow" check --repo "$REPO"

printf 'Git workflow policy tests passed.\n'
