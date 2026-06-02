#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/lib/lesson_common.sh
source "$SCRIPT_DIR/lib/lesson_common.sh"
# shellcheck source=tools/lib/document_paths.sh
source "$SCRIPT_DIR/lib/document_paths.sh"

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

require_file() {
  local file="$1"
  if [[ ! -f "$ROOT/$file" ]]; then
    printf 'missing: %s\n' "$file" >&2
    missing=1
  fi
}

require_file "$DEVELOPER_MEMORY_DOC"
require_file "learning/LESSON_APPROVALS_14_DAYS.tsv"
require_file "learning/LESSON_MODE_14_DAYS.tsv"

require_pattern "$DEVELOPER_MEMORY_DOC" 'Approval checkpoints now have tooling enforcement' "approval enforcement record"
require_pattern "tools/lesson14" 'LESSON_RUNTIME_REQUIRE_APPROVAL=1' "lesson14 approval enforcement flag"
require_pattern "tools/lib/lesson_runtime.sh" 'Approval required before this action' "approval gate"
require_pattern "tools/test_lesson14.sh" 'lesson14-approval-required' "approval regression test"

require_pattern "$DEVELOPER_MEMORY_DOC" 'tools/lesson14 学習モード <A\|B\|C>' "learning mode record"
require_pattern "$DEVELOPER_MEMORY_DOC" 'at any time during the lesson' "learning mode switchability record"
require_pattern "tools/lesson14" 'Learning mode is required before passing setup\.index' "learning mode gate"
require_pattern "tools/test_lesson14.sh" 'Learning mode recorded: C' "learning mode switch regression test"
require_pattern "tools/test_lesson14.sh" 'lesson14-mode-required' "learning mode regression test"
require_pattern "tools/lesson14" 'Workflow display language is required before passing setup\.index' "workflow language gate"
require_pattern "tools/lesson14" 'Product development language is required before passing setup\.index' "product development language gate"
require_pattern "tools/test_lesson14.sh" 'lesson14-language-required' "language gate regression test"

require_pattern "README.md" '7-day|7日版' "7-day entry"
require_pattern "README.md" '14-day|14日版' "14-day entry"
require_pattern "AGENTS.MD" '7日版か14日版' "version selection rule"
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
require_pattern "tools/menu" '自由開発で作る → 成果物を改善する → 外部連携で発展させる' "menu progression"
require_pattern "README.md" './tools/menu' "README menu command"
require_pattern "AGENTS.MD" 'メニュー' "AGENTS menu routing"

require_file "tools/dashboard"
require_pattern "tools/dashboard" 'Lesson Dashboard' "dashboard lesson view"
require_pattern "tools/dashboard" 'Development Dashboard' "dashboard development view"
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
require_pattern ".githooks/pre-commit" 'test_lesson_repository\.sh' "pre-commit aggregate test"
require_pattern ".githooks/pre-commit" 'test_product_gate_tools\.sh' "pre-commit product gate test"
require_pattern ".githooks/pre-commit" 'test_lesson_playwright\.sh' "pre-commit Playwright test"
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
require_pattern "tools/external-integration" 'missing external-integration scope document' "external integration scope docs gate"
require_file "advanced/TEAM_DEVELOPMENT_DOCKER.md"
require_file "advanced/DOCKER_PATHS.md"
require_pattern "advanced/TEAM_DEVELOPMENT_DOCKER.md" 'Team Development and Docker' "team Docker guide"
require_pattern "advanced/TEAM_DEVELOPMENT_DOCKER.md" 'AI-Driven Team Workflow' "AI-driven team workflow"
require_pattern "advanced/TEAM_DEVELOPMENT_DOCKER.md" 'Docker Learning Path' "Docker learning path"
require_pattern "advanced/TEAM_DEVELOPMENT_DOCKER.md" 'Sub-Agent Roles' "team sub-agent roles"
require_pattern "advanced/DOCKER_PATHS.md" 'Docker Not Installed' "Docker no-install path"
require_pattern "advanced/DOCKER_PATHS.md" 'Docker Installed' "Docker installed path"
require_pattern "tools/team-development" 'Team Development and Docker gate passed' "team Docker gate"

if [[ $missing -ne 0 ]]; then
  printf '\nDeveloper memory requirements check failed.\n' >&2
  exit 1
fi

printf 'Developer memory requirements check passed.\n'
