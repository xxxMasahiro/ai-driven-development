#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
missing=0

required_docs=(
  "REQUIREMENTS.md"
  "SPECIFICATION.md"
  "IMPLEMENTATION_PLAN.md"
  "TASK_TRACKER.md"
  "HANDOFF.md"
)

require_file() {
  local file="$1"
  if [[ ! -f "$ROOT/$file" ]]; then
    printf 'missing: %s\n' "$file" >&2
    missing=1
  fi
}

require_pattern() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if ! grep -Eq "$pattern" "$ROOT/$file"; then
    printf 'missing %s in %s\n' "$label" "$file" >&2
    missing=1
  fi
}

for file in "${required_docs[@]}"; do
  require_file "$file"
done

if [[ $missing -eq 0 ]]; then
  combined="$(mktemp)"
  trap 'rm -f "$combined"' EXIT
  for doc in "${required_docs[@]}"; do
    cat "$ROOT/$doc" >> "$combined"
    printf '\n' >> "$combined"
  done

  for topic in \
    'approval|承認' \
    'learning mode|学習モード' \
    'start position|開始位置' \
    'Free Development Mode|自由開発' \
    'Team Development|チーム開発' \
    'Docker Learning Paths|DOCKER_PATHS' \
    'Docker' \
    'dialogue|壁打ち|対話' \
    'sub-agent|サブエージェント' \
    'Developer Memory|DEVELOPER_MEMORY' \
    'as-built docs check|check_as_built_docs' \
    'review protocol|SUBAGENT_REVIEW_PROTOCOL|check_review_protocol' \
    'refactorability|reusable|generality|ecosystem' \
    'tradeoff|trade-off' \
    'lesson repository test|test_lesson_repository' \
    'product-gate|product gate|test_product_gate_tools' \
    'production operations test|test_production_operations'
  do
    if ! grep -Eiq "$topic" "$combined"; then
      printf 'missing as-built topic across docs: %s\n' "$topic" >&2
      missing=1
    fi
  done

  require_pattern "REQUIREMENTS.md" 'Non-Goals' "requirements non-goals"
  require_pattern "SPECIFICATION.md" 'As-Built Components' "specification as-built components"
  require_pattern "IMPLEMENTATION_PLAN.md" 'Verification Plan' "implementation verification plan"
  require_pattern "TASK_TRACKER.md" 'Current Status' "task tracker current status"
  require_pattern "HANDOFF.md" 'Next Step' "handoff next step"
fi

if [[ $missing -ne 0 ]]; then
  printf '\nAs-built docs check failed.\n' >&2
  exit 1
fi

printf 'As-built docs check passed.\n'
