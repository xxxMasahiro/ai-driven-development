#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=tools/lib/lesson_display_labels.sh
source "$ROOT/tools/lib/lesson_display_labels.sh"
missing=0
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

learner_files=(
  "README.md"
  "AGENTS.MD"
  "index.md"
  "index-14-days.md"
  "ai-driven-task-tracker-scenario.md"
  "guides/LESSON_GUIDE.md"
  "guides/LESSON_14_DAYS.md"
  "learning/ROADMAP.md"
  "learning/HELP_DESK.md"
  "prompts/PROMPTS.md"
  "prompts/PROMPTS_14_DAYS.md"
  "lesson/LESSON_FLOW.tsv"
  "lesson/LESSON_FLOW_14_DAYS.tsv"
  "lesson/SYNC_GATES_14_DAYS.tsv"
  "skills/lesson14-facilitator/SKILL.md"
  "skills/lesson-sync-gate/SKILL.md"
  "playbooks/AGENT_PLAYBOOK.md"
  "playbooks/AGENT_PLAYBOOK_14_DAYS.md"
  "tools/menu"
  "tools/dashboard"
  "tools/learn"
  "tools/helpdesk"
  "tools/lesson14"
  "tools/docs-tour"
)

for course in lesson_7 lesson_14; do
  if ! lesson_display_label "$course" >/dev/null; then
    printf 'missing display label for %s\n' "$course" >&2
    missing=1
  fi
done

forbidden_patterns=(
  '7日間'
  '14日間'
  '7日間レッスン'
  '14日間レッスン'
  '7日版:'
  '14日版:'
  '7日版'
  '14日版'
  '7日版レッスン'
  '14日版レッスン'
  '7日版の入口'
  '14日版の入口'
  '7日版の目的'
  '14日版の目的'
  '7日ロードマップ'
  '14日ロードマップ'
  '\bDay [0-9]+'
  'Day別'
  '各Day'
  'DayまたはStep'
  '\|[[:space:]]*Day[[:space:]]*\|'
  '7-day lesson status'
  '14-day lesson status'
  '7-day and 14-day'
  '^14-day:'
  '^7-day:'
  'SafeFlow'
  'safeflow'
  'akane-safeflow'
  'akane_safeflow'
)

for file in "${learner_files[@]}"; do
  [[ -f "$ROOT/$file" ]] || continue
  for pattern in "${forbidden_patterns[@]}"; do
    if grep -En "$pattern" "$ROOT/$file" >"$tmp_dir/learner-display.out"; then
      printf 'learner-facing old lesson label remains in %s:\n' "$file" >&2
      cat "$tmp_dir/learner-display.out" >&2
      missing=1
    fi
  done
done

menu_output="$("$ROOT/tools/menu")"
if ! grep -F "$(lesson_display_label lesson_7)" <<<"$menu_output" >/dev/null; then
  printf 'menu does not show STEP 1-7 learner label.\n' >&2
  missing=1
fi
if ! grep -F "$(lesson_display_label lesson_14)" <<<"$menu_output" >/dev/null; then
  printf 'menu does not show STEP 1-14 learner label.\n' >&2
  missing=1
fi
if grep -E '7日間レッスン|14日間レッスン' <<<"$menu_output" >"$tmp_dir/menu-old-labels.out"; then
  printf 'menu still shows old course labels:\n' >&2
  cat "$tmp_dir/menu-old-labels.out" >&2
  missing=1
fi

dashboard_output="$("$ROOT/tools/dashboard" lesson)"
if ! grep -F "$(lesson_display_label lesson_7)" <<<"$dashboard_output" >/dev/null; then
  printf 'dashboard lesson view does not show STEP 1-7 learner label.\n' >&2
  missing=1
fi
if ! grep -F "$(lesson_display_label lesson_14)" <<<"$dashboard_output" >/dev/null; then
  printf 'dashboard lesson view does not show STEP 1-14 learner label.\n' >&2
  missing=1
fi
if grep -E '7-day lesson status|14-day lesson status|^14-day:|^7-day:' <<<"$dashboard_output" >"$tmp_dir/dashboard-old-labels.out"; then
  printf 'dashboard still shows old course labels:\n' >&2
  cat "$tmp_dir/dashboard-old-labels.out" >&2
  missing=1
fi

if "$ROOT/tools/lesson14" status 2>"$tmp_dir/lesson14-status.err" | grep -E 'Current step: day[0-9]+\.' >"$tmp_dir/lesson14-status-id.out"; then
  printf 'lesson14 status exposes internal step id as current step:\n' >&2
  cat "$tmp_dir/lesson14-status-id.out" >&2
  missing=1
fi

if "$ROOT/tools/lesson14" status 2>"$tmp_dir/lesson14-status.err" | grep -E 'Copy-paste command step id|command_step_id=' >"$tmp_dir/lesson14-status-command-id.out"; then
  printf 'lesson14 status exposes internal id outside command text:\n' >&2
  cat "$tmp_dir/lesson14-status-command-id.out" >&2
  missing=1
fi

learn_output="$("$ROOT/tools/learn" 現在地)"
if grep -E '現在のレッスン項目: day[0-9]+\.|^[[:space:]]*day[0-9]+\.' <<<"$learn_output" >"$tmp_dir/learn-internal-id.out"; then
  printf 'learn output exposes internal step id as learner label:\n' >&2
  cat "$tmp_dir/learn-internal-id.out" >&2
  missing=1
fi

helpdesk_output="$("$ROOT/tools/helpdesk" 一覧)"
if grep -E '現在のレッスン項目: day[0-9]+\.' <<<"$helpdesk_output" >"$tmp_dir/helpdesk-internal-id.out"; then
  printf 'helpdesk output exposes internal step id as learner label:\n' >&2
  cat "$tmp_dir/helpdesk-internal-id.out" >&2
  missing=1
fi

if "$ROOT/tools/lesson" status 2>"$tmp_dir/lesson-status.err" | grep -E 'Copy-paste command step id|command_step_id=' >"$tmp_dir/lesson-status-command-id.out"; then
  printf 'lesson status exposes internal id outside command text:\n' >&2
  cat "$tmp_dir/lesson-status-command-id.out" >&2
  missing=1
fi

if "$ROOT/tools/dashboard" lesson 2>"$tmp_dir/dashboard-lesson.err" | grep -E 'Current step: day[0-9]+\.' >"$tmp_dir/dashboard-lesson-id.out"; then
  printf 'dashboard exposes internal step id as current step:\n' >&2
  cat "$tmp_dir/dashboard-lesson-id.out" >&2
  missing=1
fi

if [[ $missing -ne 0 ]]; then
  printf '\nLearner display check failed.\n' >&2
  exit 1
fi

printf 'Learner display check passed.\n'
