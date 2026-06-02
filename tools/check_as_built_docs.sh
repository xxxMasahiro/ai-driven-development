#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/lib/lesson_common.sh
source "$SCRIPT_DIR/lib/lesson_common.sh"
# shellcheck source=tools/lib/document_paths.sh
source "$SCRIPT_DIR/lib/document_paths.sh"

ROOT="$LESSON_ROOT"
missing=0

required_docs=(
  "$(lesson_doc_path requirements)"
  "$(lesson_doc_path specification)"
  "$(lesson_doc_path implementation_plan)"
  "$(lesson_doc_path task_tracker)"
  "$(lesson_doc_path handoff)"
)

require_file() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    printf 'missing: %s\n' "$file" >&2
    missing=1
  fi
}

require_pattern() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if ! grep -Eq "$pattern" "$file"; then
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
    cat "$doc" >> "$combined"
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
    'menu prerequisite|Menu Prerequisite|menu items 1 through 6' \
    'product-improvement|Product Improvement|product improvement' \
    '応用レッスン' \
    'DOCUMENT_MAP|Documentation Map' \
    'docs-tour|Documentation tour' \
    'dashboard docs|Documentation Map Dashboard' \
    'production operations test|test_production_operations'
  do
    if ! grep -Eiq "$topic" "$combined"; then
      printf 'missing as-built topic across docs: %s\n' "$topic" >&2
      missing=1
    fi
  done

  require_pattern "$(lesson_doc_path requirements)" 'Non-Goals' "requirements non-goals"
  require_pattern "$(lesson_doc_path requirements)" 'docs/workflow/TASK_TRACKER\.md' "requirements migrated task tracker path"
  require_pattern "$(lesson_doc_path requirements)" 'docs/as-built/REQUIREMENTS\.md' "requirements migrated requirements path"
  require_pattern "$(lesson_doc_path specification)" 'As-Built Components' "specification as-built components"
  require_pattern "$(lesson_doc_path implementation_plan)" 'Verification Plan' "implementation verification plan"
  require_pattern "$(lesson_doc_path implementation_plan)" 'docs/memory/DEVELOPER_MEMORY\.md' "implementation plan migrated developer memory path"
  require_pattern "$(lesson_doc_path implementation_plan)" 'docs/workflow/TASK_TRACKER\.md' "implementation plan migrated task tracker path"
  require_pattern "$(lesson_doc_path task_tracker)" 'Current Status' "task tracker current status"
  require_pattern "$(lesson_doc_path task_tracker)" 'docs/as-built/REQUIREMENTS\.md' "task tracker migrated requirements path"
  require_pattern "$(lesson_doc_path task_tracker)" 'docs/memory/DEVELOPER_MEMORY\.md' "task tracker migrated developer memory path"
  require_pattern "$(lesson_doc_path task_tracker)" 'docs/workflow/HANDOFF\.md' "task tracker migrated handoff path"
  require_pattern "$(lesson_doc_path handoff)" 'Next Step' "handoff next step"
  require_pattern "$(lesson_doc_path handoff)" 'docs/workflow/TASK_TRACKER\.md' "handoff migrated task tracker path"
  require_pattern "$ROOT/reviews/SUBAGENT_REVIEW_PROTOCOL.md" 'docs/as-built/REQUIREMENTS\.md' "review protocol migrated requirements path"
  require_pattern "$ROOT/reviews/SUBAGENT_REVIEW_PROTOCOL.md" 'docs/workflow/TASK_TRACKER\.md' "review protocol migrated workflow path"

  for topic in \
    'shared document-path support|shared document-path layer' \
    'role-specific Markdown|Role-Based Document Organization|role-based Markdown' \
    'Day.*Step|Step.*Day' \
    'internal step ID|Internal step ID' \
    'workflow display language|Workflow display language' \
    'product development language|Product development language' \
    'zh-CN.*pt-BR|pt-BR.*zh-CN' \
    'learning-mode display|Learning Mode Display|learning-mode label' \
    'approval gate|Approval And Passage|start/pass approval' \
    'command-block|copy-paste command|command block' \
    'TASK_TRACKER.*HANDOFF|HANDOFF.*TASK_TRACKER' \
    'as-built synchronization|As-Built Synchronization' \
    'dashboard|Dashboard' \
    'illustration|Illustration' \
    'external-integration|External Integration|external integration' \
    'Playwright' \
    'pre-commit|CI' \
    'failure-path|failure path' \
    'menu prerequisite|Menu Prerequisite|menu items 1 through 6' \
    'product-improvement|Product Improvement|product improvement' \
    '応用レッスン' \
    'DOCUMENT_MAP|Documentation Map' \
    'docs-tour|Documentation tour' \
    'dashboard docs|Documentation Map Dashboard' \
    'test_docs_tour|Documentation tour tests'
  do
    for doc in "${required_docs[@]}"; do
      if ! grep -Eiq "$topic" "$doc"; then
        printf 'missing synchronized remediation topic in %s: %s\n' "$doc" "$topic" >&2
        missing=1
      fi
    done
  done
fi

if [[ $missing -ne 0 ]]; then
  printf '\nAs-built docs check failed.\n' >&2
  exit 1
fi

printf 'As-built docs check passed.\n'
