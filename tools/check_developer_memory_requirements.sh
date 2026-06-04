#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/lib/lesson_common.sh
source "$SCRIPT_DIR/lib/lesson_common.sh"
# shellcheck source=tools/lib/document_paths.sh
source "$SCRIPT_DIR/lib/document_paths.sh"
# shellcheck source=tools/lib/git_hooks_policy.sh
source "$SCRIPT_DIR/lib/git_hooks_policy.sh"

ROOT="$LESSON_ROOT"
DEVELOPER_MEMORY_DOC="$(lesson_doc_relpath developer_memory)"
missing=0

require_pattern() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if ! grep -Eq "$pattern" "$ROOT/$file"; then
    printf 'missing %s in %s\n' "$label" "$file" >&2
    missing=1
  fi
}

require_pre_commit_check() {
  local command="$1"
  local label="$2"
  local hook_mode
  local row_command
  local rows
  local row_separator
  if awk -v command="$command" '
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*$/ { next }
    index($0, command) { found = 1 }
    END { exit found ? 0 : 1 }
  ' "$ROOT/.githooks/pre-commit"; then
    return
  fi
  if awk '
      /^[[:space:]]*#/ { next }
      /^[[:space:]]*$/ { next }
      index($0, "tools/git-hooks") { found = 1 }
      END { exit found ? 0 : 1 }
    ' "$ROOT/.githooks/pre-commit" \
    && [[ -f "$ROOT/docs/workflow/GIT_HOOK_CHECKS.tsv" ]]; then
    hook_mode="full"
    if git_hooks_validate_mode "$hook_mode" >/dev/null 2>&1; then
      row_separator=$'\034'
      rows="$(git_hooks_rows_for_mode "$hook_mode")" || rows=""
      while IFS="$row_separator" read -r check_id _ row_command _; do
        if [[ "$row_command" == "./tools/$command" || "$row_command" == "./tools/$command "* || "$row_command" == "$ROOT/tools/$command" || "$row_command" == "$ROOT/tools/$command "* ]]; then
          return
        fi
        if [[ "$command" == "test_lesson_repository.sh" && "$check_id" == "test_lesson_repository" && ( "$row_command" == "./tools/ci-final-gate" || "$row_command" == "$ROOT/tools/ci-final-gate" ) ]]; then
          return
        fi
      done <<<"$rows"
    fi
  fi
  printf 'missing %s in .githooks/pre-commit\n' "$label" >&2
  missing=1
}

require_file() {
  local file="$1"
  if [[ ! -f "$ROOT/$file" ]]; then
    printf 'missing: %s\n' "$file" >&2
    missing=1
  fi
}

require_file "$DEVELOPER_MEMORY_DOC"
require_file "learning/LESSON_MODE.tsv"
require_file "learning/WORKFLOW_DISPLAY_LANGUAGE.tsv"
require_file "learning/PRODUCT_DEVELOPMENT_LANGUAGE.tsv"
require_file "learning/LESSON_APPROVALS_14_DAYS.tsv"
require_file "learning/LESSON_MODE_14_DAYS.tsv"

require_pattern "$DEVELOPER_MEMORY_DOC" 'Approval checkpoints now have tooling enforcement' "approval enforcement record"
require_pattern "tools/lesson14" 'LESSON_RUNTIME_REQUIRE_APPROVAL=1' "lesson14 approval enforcement flag"
require_pattern "tools/lib/lesson_runtime.sh" 'Approval required before this action' "approval gate"
require_pattern "tools/test_lesson14.sh" 'lesson14-approval-required' "approval regression test"

require_pattern "$DEVELOPER_MEMORY_DOC" 'tools/lesson 学習モード <A\|B\|C>' "7-day learning mode record"
require_pattern "$DEVELOPER_MEMORY_DOC" 'tools/lesson14 学習モード <A\|B\|C>' "14-day learning mode record"
require_pattern "$DEVELOPER_MEMORY_DOC" 'at any time during (the|either) lesson' "learning mode switchability record"
require_pattern "tools/lesson" 'Learning mode is required before passing setup\.index' "7-day learning mode gate"
require_pattern "tools/test_lesson.sh" 'Learning mode recorded: C' "7-day learning mode switch regression test"
require_pattern "tools/test_lesson.sh" 'lesson-mode-required' "7-day learning mode regression test"
require_pattern "tools/lesson" 'Workflow display language is required before passing setup\.index' "7-day workflow language gate"
require_pattern "tools/lesson" 'Product development language is required before passing setup\.index' "7-day product development language gate"
require_pattern "tools/test_lesson.sh" 'lesson-language-required' "7-day language gate regression test"
require_pattern "tools/test_lesson.sh" 'zh-TW' "7-day expanded workflow language regression test"
require_pattern "tools/test_lesson.sh" 'pt-BR' "7-day expanded product language regression test"
require_pattern "tools/lesson14" 'Learning mode is required before passing setup\.index' "learning mode gate"
require_pattern "tools/test_lesson14.sh" 'Learning mode recorded: C' "learning mode switch regression test"
require_pattern "tools/test_lesson14.sh" 'lesson14-mode-required' "learning mode regression test"
require_pattern "tools/lesson14" 'Workflow display language is required before passing setup\.index' "workflow language gate"
require_pattern "tools/lesson14" 'Product development language is required before passing setup\.index' "product development language gate"
require_pattern "tools/test_lesson14.sh" 'lesson14-language-required' "language gate regression test"
require_pattern "tools/test_lesson14.sh" 'zh-CN' "14-day zh alias regression test"
require_pattern "tools/test_lesson14.sh" 'Product development language recorded: es' "14-day expanded product language regression test"
require_pattern "tools/lib/lesson_common.sh" 'lesson_supported_language_codes' "shared language code list"
require_pattern "tools/lib/lesson_common.sh" 'pt-BR' "shared language pt-BR support"
require_pattern "tools/lib/lesson_common.sh" 'zh-TW' "shared language zh-TW support"
require_pattern "AGENTS.MD" 'ja\|en\|ko\|zh-CN\|zh-TW\|es\|pt-BR\|fr\|de\|id\|vi\|th\|hi\|ar' "AGENTS supported language invariant"
require_pattern "$DEVELOPER_MEMORY_DOC" 'Standard language choices should include' "developer memory expanded language choices"

require_pattern "README.md" 'STEP 1-7: 基礎レッスン' "STEP 1-7 entry"
require_pattern "README.md" 'STEP 1-14: 実践レッスン' "STEP 1-14 entry"
require_pattern "AGENTS.MD" 'STEP 1-7: 基礎レッスン.*STEP 1-14: 実践レッスン' "course selection rule"
require_pattern "AGENTS.MD" '学習モード' "learning mode startup rule"
require_pattern "AGENTS.MD" '既存機能とのトレードオフは一切禁止' "no existing-feature tradeoff rule"
require_pattern "AGENTS.MD" 'リファクタリング性、エコシステム性、再利用性、汎用性' "implementation quality rule"
require_pattern "$DEVELOPER_MEMORY_DOC" 'refactorable, ecosystem-friendly, reusable, and general' "implementation quality memory"
require_pattern "$DEVELOPER_MEMORY_DOC" 'Existing functionality must not be traded away' "no-tradeoff memory"
require_pattern "$DEVELOPER_MEMORY_DOC" 'Final tests pass only when every improvement or problem recorded in this developer memory' "developer-memory full-clear test rule"

require_pattern "guides/LESSON_14_DAYS.md" 'Step 12/14からStep 13/14' "Step 12/14-13 guide section"
require_pattern "guides/LESSON_14_DAYS.md" '対話と壁打ち' "dialogue practice section"
require_pattern "prompts/PROMPTS_14_DAYS.md" '壁打ち開始プロンプト' "dialogue prompt"
require_pattern "AGENTS.MD" '壁打ち' "agent dialogue rule"
require_pattern "prompts/PROMPTS_14_DAYS.md" 'サブエージェント|sub-agent' "sub-agent prompt guidance"
require_pattern "prompts/PROMPTS_14_DAYS.md" 'MCP' "MCP prompt guidance"
require_pattern "skills/lesson14-facilitator/SKILL.md" 'Step 12/14 and Step 13/14' "Step 12/14-13 skill rule"
require_pattern "$DEVELOPER_MEMORY_DOC" 'Explain MCP Purpose Before MCP Workflows' "MCP purpose-before-workflow memory"
require_pattern "prompts/PROMPTS_14_DAYS.md" '入力、出力、便利になること、最小範囲' "MCP input/output prompt guidance"
require_pattern "skills/lesson14-facilitator/SKILL.md" 'Before any MCP-related work' "MCP purpose-before-workflow skill rule"
require_pattern "guides/LESSON_14_DAYS.md" 'MCPに入る前' "MCP learner-facing guide rule"

require_pattern "guides/LESSON_14_DAYS.md" '改善サイクル|improvement cycle' "post-completion improvement cycle"
require_pattern "prompts/PROMPTS_14_DAYS.md" 'Googleカレンダー|Google Calendar' "external integration follow-up"
require_file "tools/menu"
require_pattern "tools/menu" '【学ぶ】' "menu learning group"
require_pattern "tools/menu" '【作る・発展させる】' "menu build and extend group"
require_pattern "tools/menu" '3\. 応用レッスン' "renamed applied lesson menu item"
require_pattern "tools/menu" '自由開発で作る → 成果物を改善する → 外部連携で発展させる' "menu progression"
require_pattern "tools/menu" 'tools/menu check <1\|2\|3\|4\|5\|6\|7>' "menu prerequisite check command"
require_pattern "tools/menu" 'lesson_menu_require_start_approval' "menu start approval enforcement"
if grep -Eq '3\. 発展・応用レッスン' "$ROOT/tools/menu"; then
  printf 'old menu label remains in tools/menu\n' >&2
  missing=1
fi
require_pattern "README.md" './tools/menu' "README menu command"
require_pattern "AGENTS.MD" 'メニュー' "AGENTS menu routing"

require_file "tools/dashboard"
require_pattern "tools/dashboard" 'Lesson Dashboard' "dashboard lesson view"
require_pattern "tools/dashboard" 'Development Dashboard' "dashboard development view"
require_pattern "tools/dashboard" 'Documentation Map Dashboard' "dashboard docs view"
require_file "guides/DOCUMENT_MAP.md"
require_file "tools/docs-tour"
require_file "tools/test_docs_tour.sh"
require_pattern "guides/DOCUMENT_MAP.md" 'AGENTS.MD' "document map AGENTS explanation"
require_pattern "guides/DOCUMENT_MAP.md" 'docs/as-built/REQUIREMENTS.md' "document map as-built explanation"
require_pattern "guides/DOCUMENT_MAP.md" 'docs/workflow/TASK_TRACKER.md' "document map task tracker explanation"
require_pattern "guides/DOCUMENT_MAP.md" 'docs/workflow/HANDOFF.md' "document map handoff explanation"
require_pattern "guides/DOCUMENT_MAP.md" 'docs/memory/DEVELOPER_MEMORY.md' "document map developer memory explanation"
require_pattern "guides/DOCUMENT_MAP.md" 'skills/\*/SKILL.md|skills/.*/SKILL.md' "document map skills explanation"
require_pattern "tools/docs-tour" 'status\|rules\|design\|workflow\|memory\|skills\|all' "docs-tour supported views"
require_pattern "tools/test_docs_tour.sh" 'Documentation tour tests passed' "docs-tour test"
require_pre_commit_check 'test_docs_tour.sh' "pre-commit docs-tour test"
require_file "tools/illustrations"
require_file "illustrations/README.md"
require_file "illustrations/lesson14/index.tsv"
require_file "illustration-review/index.html"
require_pattern "tools/illustrations" 'imagegen' "illustration imagegen workflow"
require_pattern "illustration-review/index.html" 'Lesson Illustration Review' "illustration review page"

require_pattern "tools/lesson14" '初期化|reset' "fresh-run reset command"
require_pattern "tools/test_lesson14.sh" '初期化 --confirm' "reset regression test"
require_pattern "tools/test_production_operations.sh" 'Production operations test passed' "production operations test"
require_file "tools/test_lesson_repository.sh"
require_file "package-lock.json"
require_pattern "tools/test_lesson_repository.sh" 'Lesson repository test passed' "lesson repository aggregate test"
require_file "tools/test_product_gate_tools.sh"
require_pattern "tools/test_product_gate_tools.sh" 'Product gate tool tests passed' "product gate tool tests"
require_pattern "tools/test_product_gate_tools.sh" 'missing external-integration scope document' "external integration scope failure test"
require_file "tools/product-repository-cleanup"
require_file "tools/test_product_repository_cleanup.sh"
require_pattern "tools/product-repository-cleanup" 'local --confirm <product-repository-name>' "product cleanup local confirmation command"
require_pattern "tools/product-repository-cleanup" 'remote --confirm <owner/repository>' "product cleanup remote confirmation command"
require_pattern "tools/product-repository-cleanup" 'refusing to delete a target inside the lesson repository' "product cleanup lesson boundary guard"
require_pattern "tools/test_product_repository_cleanup.sh" 'Product repository cleanup tests passed' "product cleanup regression test"
require_file "tools/test_menu_prerequisites.sh"
require_pattern "tools/test_menu_prerequisites.sh" 'Menu prerequisite tests passed' "menu prerequisite tests"
require_pattern "tools/test_menu_prerequisites.sh" '3\\. 応用レッスン' "menu label regression test"
require_pre_commit_check 'test_lesson_repository.sh' "pre-commit aggregate test"
require_pre_commit_check 'test_product_gate_tools.sh' "pre-commit product gate test"
require_pre_commit_check 'test_product_repository_cleanup.sh' "pre-commit product cleanup test"
require_pre_commit_check 'test_menu_prerequisites.sh' "pre-commit menu prerequisite test"
require_pre_commit_check 'test_lesson_playwright.sh' "pre-commit Playwright test"
require_file "docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv"
require_pattern "tools/git-hooks" 'recommend' "Git hooks recommendation command"
require_pattern "tools/test_git_hooks.sh" 'Recommended command: ./tools/git-hooks run --mode full --no-cache' "Git hooks recommendation regression test"
require_file "tools/check_as_built_docs.sh"
require_pattern "tools/check_as_built_docs.sh" 'As-built docs check passed' "as-built docs check"
require_file "tools/check_review_protocol.sh"
require_pattern "tools/check_review_protocol.sh" 'Review protocol check passed' "review protocol check"
require_file "reviews/SUBAGENT_REVIEW_PROTOCOL.md"
require_pattern "reviews/SUBAGENT_REVIEW_PROTOCOL.md" 'Documentation consistency reviewer' "sub-agent review protocol"
require_file "tools/list_non_english_docs.sh"
require_pattern "tools/lesson" '開始位置' "7-day learner-selected start command"
require_pattern "tools/lib/lesson_runtime.sh" '開始位置' "14-day learner-selected start command"
require_pattern "tools/test_lesson_start_position.sh" 'Lesson start position tests passed' "start position regression test"
require_file "free-development/FREE_DEVELOPMENT_MODE.md"
require_pattern "free-development/FREE_DEVELOPMENT_MODE.md" 'Required Workflow' "free development workflow"
require_pattern "free-development/FREE_DEVELOPMENT_MODE.md" 'Programming languages' "free development language choice"
require_pattern "free-development/FREE_DEVELOPMENT_MODE.md" 'Payment systems' "free development payment choice"
require_pattern "free-development/FREE_DEVELOPMENT_MODE.md" 'Databases' "free development database choice"
require_pattern "tools/free-development" 'Free Development Mode gate passed' "free development gate"
require_pattern "tools/free-development" 'lesson_menu_require_settings' "free development prerequisite gate"
require_file "tools/product-improvement"
require_pattern "tools/product-improvement" 'Product Improvement gate passed' "product improvement gate"
require_pattern "tools/product-improvement" 'lesson_menu_require_settings' "product improvement prerequisite gate"
require_pattern "tools/external-integration" 'missing external-integration scope document' "external integration scope docs gate"
require_pattern "tools/external-integration" 'lesson_menu_require_settings' "external integration prerequisite gate"
require_file "advanced/TEAM_DEVELOPMENT_DOCKER.md"
require_file "advanced/DOCKER_PATHS.md"
require_pattern "advanced/TEAM_DEVELOPMENT_DOCKER.md" 'Team Development and Docker' "team Docker guide"
require_pattern "advanced/TEAM_DEVELOPMENT_DOCKER.md" 'AI-Driven Team Workflow' "AI-driven team workflow"
require_pattern "advanced/TEAM_DEVELOPMENT_DOCKER.md" 'Docker Learning Path' "Docker learning path"
require_pattern "advanced/TEAM_DEVELOPMENT_DOCKER.md" 'Sub-Agent Roles' "team sub-agent roles"
require_pattern "advanced/DOCKER_PATHS.md" 'Docker Not Installed' "Docker no-install path"
require_pattern "advanced/DOCKER_PATHS.md" 'Docker Installed' "Docker installed path"
require_pattern "tools/team-development" 'Team Development and Docker gate passed' "team Docker gate"
require_pattern "tools/team-development" 'lesson_menu_require_settings' "team development prerequisite gate"

if [[ $missing -ne 0 ]]; then
  printf '\nDeveloper memory requirements check failed.\n' >&2
  exit 1
fi

printf 'Developer memory requirements check passed.\n'
