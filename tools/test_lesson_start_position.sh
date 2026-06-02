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
./tools/lesson 開始 day2.screen-structure >/tmp/lesson-start-locked.out 2>&1 && exit 1 || true
grep 'locked' /tmp/lesson-start-locked.out >/dev/null
./tools/lesson 開始位置 day2.screen-structure >/tmp/lesson-start-at-no-confirm.out 2>&1 && exit 1 || true
grep 'explicit confirmation' /tmp/lesson-start-at-no-confirm.out >/dev/null
./tools/lesson 開始位置 day2.screen-structure --confirm | grep 'Start position set to'
./tools/lesson status | grep 'day2.screen-structure'
./tools/check_lesson_structure.sh >/dev/null

reset_state_from_flow lesson/LESSON_FLOW_14_DAYS.tsv learning/LESSON_STATE_14_DAYS.tsv setup.index
printf '# step_id\taction\tapproved_at\tmemo\n' > learning/LESSON_APPROVALS_14_DAYS.tsv
printf '# selected_at\tmode\tdescription\n' > learning/LESSON_MODE_14_DAYS.tsv
./tools/lesson14 開始 day2.git-basics >/tmp/lesson14-start-locked.out 2>&1 && exit 1 || true
grep 'locked' /tmp/lesson14-start-locked.out >/dev/null
./tools/lesson14 開始位置 day2.git-basics >/tmp/lesson14-start-at-no-confirm.out 2>&1 && exit 1 || true
grep 'explicit confirmation' /tmp/lesson14-start-at-no-confirm.out >/dev/null
./tools/lesson14 開始位置 day2.git-basics --confirm | grep 'Start position set to'
./tools/lesson14 status | grep 'day2.git-basics'
./tools/check_lesson14_structure.sh >/dev/null

printf 'Lesson start position tests passed.\n'
