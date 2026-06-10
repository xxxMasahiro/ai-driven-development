#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=tools/lib/fixture_copy.sh
source "$ROOT/tools/lib/fixture_copy.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

fixture_copy_repo "$ROOT" "$work/lesson"
cd "$work/lesson"
git init -b main >/dev/null
git config user.name "Menu Test"
git config user.email "menu-test@example.com"
git add .
git commit -m "Initial lesson fixture" >/dev/null

project_root="$work/projects"
product_name="menu-product"
product_repo="$project_root/$product_name"
mkdir -p "$project_root"

cat > lesson/LESSON_CONFIG.tsv <<CONFIG
# key	value
lesson_repo_name	ai-driven-development-lesson
product_repo_name	$product_name
project_root	$project_root
flow_file	lesson/LESSON_FLOW.tsv
state_file	learning/LESSON_STATE.tsv
learning_tracker_file	learning/LEARNING_TASK_TRACKER.md
learning_handoff_file	learning/LEARNING_HANDOFF.md
learning_mode_file	learning/LESSON_MODE.tsv
workflow_language_file	learning/WORKFLOW_DISPLAY_LANGUAGE.tsv
product_language_file	learning/PRODUCT_DEVELOPMENT_LANGUAGE.tsv
CONFIG

cat > lesson/LESSON_CONFIG_14_DAYS.tsv <<CONFIG
# key	value
lesson_repo_name	ai-driven-development-lesson
product_repo_name	$product_name
project_root	$project_root
flow_file	lesson/LESSON_FLOW_14_DAYS.tsv
state_file	learning/LESSON_STATE_14_DAYS.tsv
learning_tracker_file	learning/LEARNING_TASK_TRACKER_14_DAYS.md
learning_handoff_file	learning/LEARNING_HANDOFF_14_DAYS.md
approval_file	learning/LESSON_APPROVALS_14_DAYS.tsv
learning_mode_file	learning/LESSON_MODE_14_DAYS.tsv
workflow_language_file	learning/WORKFLOW_DISPLAY_LANGUAGE_14_DAYS.tsv
product_language_file	learning/PRODUCT_DEVELOPMENT_LANGUAGE_14_DAYS.tsv
roadmap_file	learning/ROADMAP.md
helpdesk_file	learning/HELP_DESK.md
sync_gates_file	lesson/SYNC_GATES_14_DAYS.tsv
prompt_file	prompts/PROMPTS_14_DAYS.md
CONFIG

printf '# selected_at\tmode\tdescription\n' > learning/LESSON_MODE.tsv
printf '# selected_at\tcode\tlabel\n' > learning/WORKFLOW_DISPLAY_LANGUAGE.tsv
printf '# selected_at\tcode\tlabel\n' > learning/PRODUCT_DEVELOPMENT_LANGUAGE.tsv
printf '# selected_at\tmode\tdescription\n' > learning/LESSON_MODE_14_DAYS.tsv
printf '# selected_at\tcode\tlabel\n' > learning/WORKFLOW_DISPLAY_LANGUAGE_14_DAYS.tsv
printf '# selected_at\tcode\tlabel\n' > learning/PRODUCT_DEVELOPMENT_LANGUAGE_14_DAYS.tsv

menu_output="$(./tools/menu)"
grep '1\. STEP 1-7: 基礎レッスン' <<<"$menu_output" >/dev/null
grep '2\. STEP 1-14: 実践レッスン' <<<"$menu_output" >/dev/null
grep '7日間レッスン\|14日間レッスン' <<<"$menu_output" >/dev/null && exit 1 || true
grep '3\. 応用レッスン' <<<"$menu_output" >/dev/null
grep '3\. 発展・応用レッスン' <<<"$menu_output" >/dev/null && exit 1 || true
grep './tools/product-improvement status' <<<"$menu_output" >/dev/null
grep './tools/git-workflow status' <<<"$menu_output" >/dev/null

for item in 1 2 3 4 5 6; do
  ./tools/menu start "$item" --confirm >/tmp/menu-missing-prerequisite-"$item".out 2>&1 && exit 1 || true
  grep 'missing menu prerequisite' /tmp/menu-missing-prerequisite-"$item".out >/dev/null
done

./tools/product-profile set --menu 7 --accept-recommended --confirm >/dev/null
./tools/menu check 7 | grep 'Menu prerequisite check passed' >/dev/null
./tools/menu start 4 >/tmp/menu-approval-required.out 2>&1 && exit 1 || true
grep 'learner approval is required before starting' /tmp/menu-approval-required.out >/dev/null
./tools/menu start 7 >/tmp/menu-approval-required-7.out 2>&1 && exit 1 || true
grep 'learner approval is required before starting' /tmp/menu-approval-required-7.out >/dev/null
./tools/menu start 7 --confirm | grep 'Start entry: docs/memory/DEVELOPER_MEMORY.md and ./tools/dashboard all' >/dev/null

mv docs/workflow/GIT_WORKFLOW_POLICY.tsv docs/workflow/GIT_WORKFLOW_POLICY.tsv.bak
./tools/menu check 7 >/tmp/menu-git-policy-missing.out 2>&1 && exit 1 || true
grep 'missing Git workflow policy file' /tmp/menu-git-policy-missing.out >/dev/null
mv docs/workflow/GIT_WORKFLOW_POLICY.tsv.bak docs/workflow/GIT_WORKFLOW_POLICY.tsv

cp learning/GIT_WORKFLOW_SETTINGS.tsv learning/GIT_WORKFLOW_SETTINGS.tsv.bak
{
  printf '# key\tvalue\n'
  printf 'branch_allowed\ttrue\n'
  printf 'worktree_allowed\tfalse\n'
  printf 'main_direct_work_allowed\tfalse\n'
  printf 'automation_level\tinvalid\n'
} > learning/GIT_WORKFLOW_SETTINGS.tsv
./tools/menu check 7 >/tmp/menu-git-policy-invalid.out 2>&1 && exit 1 || true
grep 'Invalid value for automation_level' /tmp/menu-git-policy-invalid.out >/dev/null
mv learning/GIT_WORKFLOW_SETTINGS.tsv.bak learning/GIT_WORKFLOW_SETTINGS.tsv

setting_value() {
  local key="$1"
  awk -F '\t' -v key="$key" '
    $1 == key {
      print $2
      found = 1
    }
    END {
      if (!found) {
        exit 1
      }
    }
  ' learning/GIT_WORKFLOW_SETTINGS.tsv
}

expected_commit_automation="$(setting_value commit_automation)"
expected_push_automation="$(setting_value push_automation)"
expected_pr_creation="$(setting_value pr_creation)"
expected_pr_ci_monitoring="$(setting_value pr_ci_monitoring)"
expected_merge_execution="$(setting_value merge_execution)"
expected_developer_auto_merge_allowed="$(setting_value developer_auto_merge_allowed)"
expected_main_ci_monitoring="$(setting_value main_ci_monitoring)"
expected_sync_monitoring="$(setting_value sync_monitoring)"

./tools/lesson 学習モード A >/dev/null
./tools/lesson 表示言語 ja >/dev/null
./tools/lesson 開発言語 ja >/dev/null
./tools/lesson14 学習モード B >/dev/null
./tools/lesson14 表示言語 en >/dev/null
./tools/lesson14 開発言語 en >/dev/null

git -c init.defaultBranch=main init "$product_repo" >/dev/null
git -C "$product_repo" config user.name "Menu Test"
git -C "$product_repo" config user.email "menu-test@example.com"
./tools/product-profile set --menu 2 --accept-recommended --confirm >/dev/null

for item in 1 2 3 4; do
  ./tools/menu check "$item" | grep 'Menu prerequisite check passed' >/dev/null
done

for item in 5 6; do
  ./tools/menu check "$item" | grep 'Menu prerequisite check passed' >/dev/null
done

./tools/menu readiness | grep 'Menu prerequisite readiness: 自由開発' >/dev/null
./tools/menu readiness | grep 'Product name: ready - タスク管理表' >/dev/null
./tools/menu readiness | grep 'Product repository boundary: ready' >/dev/null
./tools/menu readiness | grep 'Git workflow policy: ready' >/dev/null
./tools/menu readiness | grep 'Git branch permission: true' >/dev/null
./tools/menu readiness | grep 'Git worktree permission: false' >/dev/null
./tools/menu readiness | grep 'Git direct-main permission: false' >/dev/null
./tools/menu readiness | grep "Git commit automation: $expected_commit_automation" >/dev/null
./tools/menu readiness | grep "Git push automation: $expected_push_automation" >/dev/null
./tools/menu readiness | grep "Git PR creation: $expected_pr_creation" >/dev/null
./tools/menu readiness | grep "Git PR CI monitoring: $expected_pr_ci_monitoring" >/dev/null
./tools/menu readiness | grep "Git merge execution: $expected_merge_execution" >/dev/null
./tools/menu readiness | grep "Git developer auto-merge allowed: $expected_developer_auto_merge_allowed" >/dev/null
./tools/menu readiness | grep "Git main CI monitoring: $expected_main_ci_monitoring" >/dev/null
./tools/menu readiness | grep "Git sync monitoring: $expected_sync_monitoring" >/dev/null
./tools/menu readiness | grep '\[1\] STEP 1-7: 基礎レッスン' >/dev/null
./tools/menu readiness | grep '\[2\] STEP 1-14: 実践レッスン' >/dev/null
./tools/menu readiness | grep '\[7\] 教材そのものを改善' >/dev/null
dashboard_menu_output="$(./tools/dashboard menu)"
grep 'STEP 1-7: 基礎レッスン' <<<"$dashboard_menu_output" >/dev/null
grep 'STEP 1-14: 実践レッスン' <<<"$dashboard_menu_output" >/dev/null
grep '7日間レッスン\|14日間レッスン' <<<"$dashboard_menu_output" >/dev/null && exit 1 || true
grep "Git commit automation: $expected_commit_automation" <<<"$dashboard_menu_output" >/dev/null
grep "Git push automation: $expected_push_automation" <<<"$dashboard_menu_output" >/dev/null
grep "Git PR creation: $expected_pr_creation" <<<"$dashboard_menu_output" >/dev/null
grep "Git PR CI monitoring: $expected_pr_ci_monitoring" <<<"$dashboard_menu_output" >/dev/null
grep "Git merge execution: $expected_merge_execution" <<<"$dashboard_menu_output" >/dev/null
grep "Git developer auto-merge allowed: $expected_developer_auto_merge_allowed" <<<"$dashboard_menu_output" >/dev/null
grep "Git main CI monitoring: $expected_main_ci_monitoring" <<<"$dashboard_menu_output" >/dev/null
grep "Git sync monitoring: $expected_sync_monitoring" <<<"$dashboard_menu_output" >/dev/null

printf 'Menu prerequisite tests passed.\n'
