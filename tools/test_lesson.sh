#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=tools/lib/fixture_copy.sh
source "$ROOT/tools/lib/fixture_copy.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
export HOME="$work/home"
mkdir -p "$HOME/projects"

fixture_copy_repo "$ROOT" "$work/lesson"
cd "$work/lesson"

reset_state_from_flow() {
  local flow="$1"
  local state="$2"
  local first_step="$3"
  local tmp_state
  tmp_state="$(mktemp)"
  awk -F '\t' -v OFS='\t' -v first="$first_step" '
    BEGIN { print "# order", "step_id", "status", "started_at", "completed_at" }
    $1 !~ /^#/ {
      if ($2 == first) print $1, $2, "current", "", ""
      else print $1, $2, "locked", "", ""
    }
  ' "$flow" > "$tmp_state"
  mv "$tmp_state" "$state"
}

reset_state_from_flow lesson/LESSON_FLOW.tsv learning/LESSON_STATE.tsv setup.index
printf '# selected_at\tmode\tdescription\n' > learning/LESSON_MODE.tsv
printf '# selected_at\tcode\tlabel\n' > learning/WORKFLOW_DISPLAY_LANGUAGE.tsv
printf '# selected_at\tcode\tlabel\n' > learning/PRODUCT_DEVELOPMENT_LANGUAGE.tsv

./tools/lesson 通過 setup.index "設定から体験開発へ進む順番を確認した" >/tmp/lesson-mode-required.out 2>&1 && exit 1 || true
grep 'Learning mode is required before passing setup.index' /tmp/lesson-mode-required.out >/dev/null
grep './tools/lesson 学習モード <A|B|C>' /tmp/lesson-mode-required.out >/dev/null

./tools/lesson 学習モード A | grep 'Learning mode recorded: A'
./tools/lesson 通過 setup.index "設定から体験開発へ進む順番を確認した" >/tmp/lesson-language-required.out 2>&1 && exit 1 || true
grep 'Workflow display language is required before passing setup.index' /tmp/lesson-language-required.out >/dev/null
grep 'Product development language is required before passing setup.index' /tmp/lesson-language-required.out >/dev/null

./tools/lesson 表示言語 ja | grep 'Workflow display language recorded: ja'
./tools/lesson 開発言語 ja | grep 'Product development language recorded: ja'
product_repo="$HOME/projects/task-tracker-repository"
git -c init.defaultBranch=main init "$product_repo" >/dev/null
git -C "$product_repo" config user.name "Lesson Test"
git -C "$product_repo" config user.email "lesson-test@example.com"
./tools/product-profile set --menu 1 --accept-recommended --confirm >/dev/null
./tools/lesson 通過 setup.index "設定から体験開発へ進む順番を確認した" | grep 'Passed step'
./tools/lesson 現在地 | grep './tools/lesson 開始 setup.github-login'

./tools/lesson 学習モード C | grep 'Learning mode recorded: C'
./tools/lesson 学習モード | grep 'Current learning mode: C'
./tools/lesson 表示言語 zh-TW | grep 'Workflow display language recorded: zh-TW'
./tools/lesson 開発言語 pt-BR | grep 'Product development language recorded: pt-BR'
./tools/lesson 表示言語 | grep 'Current workflow display language: zh-TW'
./tools/lesson 開発言語 | grep 'Current product development language: pt-BR'

./tools/check_lesson_structure.sh >/dev/null

printf '7-day lesson CLI tests passed.\n'
