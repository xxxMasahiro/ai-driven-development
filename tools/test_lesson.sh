#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

cp -a "$ROOT" "$work/lesson"
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
./tools/lesson 通過 setup.index "設定から体験開発へ進む順番を確認した" | grep 'Passed step'
./tools/lesson 現在地 | grep './tools/lesson 開始 setup.github-login'

./tools/lesson 学習モード C | grep 'Learning mode recorded: C'
./tools/lesson 学習モード | grep 'Current learning mode: C'
./tools/lesson 表示言語 | grep 'Current workflow display language: ja'
./tools/lesson 開発言語 | grep 'Current product development language: ja'

./tools/check_lesson_structure.sh >/dev/null

printf '7-day lesson CLI tests passed.\n'
