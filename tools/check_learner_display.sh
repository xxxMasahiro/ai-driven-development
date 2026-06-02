#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
missing=0

learner_files=(
  "ai-driven-task-tracker-scenario.md"
  "guides/LESSON_GUIDE.md"
  "guides/LESSON_14_DAYS.md"
  "learning/ROADMAP.md"
  "prompts/PROMPTS.md"
  "prompts/PROMPTS_14_DAYS.md"
  "lesson/LESSON_FLOW.tsv"
  "lesson/LESSON_FLOW_14_DAYS.tsv"
  "lesson/SYNC_GATES_14_DAYS.tsv"
  "skills/lesson14-facilitator/SKILL.md"
  "skills/lesson-sync-gate/SKILL.md"
)

for file in "${learner_files[@]}"; do
  if [[ -f "$ROOT/$file" ]] && grep -En '\bDay [0-9]+' "$ROOT/$file" >/tmp/learner-display-day.out; then
    printf 'learner-facing Day label remains in %s:\n' "$file" >&2
    cat /tmp/learner-display-day.out >&2
    missing=1
  fi
done

if "$ROOT/tools/lesson14" status 2>/tmp/lesson14-status.err | grep -E 'Current step: day[0-9]+\.' >/tmp/lesson14-status-id.out; then
  printf 'lesson14 status exposes internal step id as current step:\n' >&2
  cat /tmp/lesson14-status-id.out >&2
  missing=1
fi

if "$ROOT/tools/lesson14" status 2>/tmp/lesson14-status.err | grep -E 'Copy-paste command step id|command_step_id=' >/tmp/lesson14-status-command-id.out; then
  printf 'lesson14 status exposes internal id outside command text:\n' >&2
  cat /tmp/lesson14-status-command-id.out >&2
  missing=1
fi

if "$ROOT/tools/lesson" status 2>/tmp/lesson-status.err | grep -E 'Copy-paste command step id|command_step_id=' >/tmp/lesson-status-command-id.out; then
  printf 'lesson status exposes internal id outside command text:\n' >&2
  cat /tmp/lesson-status-command-id.out >&2
  missing=1
fi

if "$ROOT/tools/dashboard" lesson 2>/tmp/dashboard-lesson.err | grep -E 'Current step: day[0-9]+\.' >/tmp/dashboard-lesson-id.out; then
  printf 'dashboard exposes internal step id as current step:\n' >&2
  cat /tmp/dashboard-lesson-id.out >&2
  missing=1
fi

if [[ $missing -ne 0 ]]; then
  printf '\nLearner display check failed.\n' >&2
  exit 1
fi

printf 'Learner display check passed.\n'
