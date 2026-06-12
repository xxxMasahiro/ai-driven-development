#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=tools/lib/repository_development_workflow.sh
source "$ROOT/tools/lib/repository_development_workflow.sh"

missing=0

report_missing() {
  printf '%s\n' "$1" >&2
  missing=1
}

require_file() {
  local relpath="$1"
  if [[ ! -f "$ROOT/$relpath" ]]; then
    report_missing "missing file: $relpath"
  fi
}

require_executable() {
  local relpath="$1"
  require_file "$relpath"
  if [[ -f "$ROOT/$relpath" && ! -x "$ROOT/$relpath" ]]; then
    report_missing "not executable: $relpath"
  fi
}

require_pattern() {
  local relpath="$1"
  local pattern="$2"
  local label="$3"
  if ! grep -Eq -- "$pattern" "$ROOT/$relpath"; then
    report_missing "missing $label in $relpath"
  fi
}

require_policy_row() {
  local relpath="$1"
  local pattern="$2"
  local label="$3"
  if ! awk -F '\t' -v pattern="$pattern" '
    $1 !~ /^#/ && $0 ~ pattern { found = 1 }
    END { exit found ? 0 : 1 }
  ' "$ROOT/$relpath"; then
    report_missing "missing $label in $relpath"
  fi
}

repository_development_validate_policy || missing=1

require_file "docs/workflow/REPOSITORY_DEVELOPMENT_WORKFLOW.tsv"
require_file "learning/REPOSITORY_DEVELOPMENT_APPROVALS.tsv"
require_file "skills/repository-development-workflow/SKILL.md"
require_file "skills/repository-development-workflow/references/repository-development.md"
require_file "skills/repository-development-workflow/agents/openai.yaml"
require_file "tools/lib/repository_development_workflow.sh"
require_executable "tools/repository-development-workflow"
require_executable "tools/check_repository_development_workflow.sh"
require_executable "tools/test_repository_development_workflow.sh"

require_pattern "AGENTS.MD" '既存機能.*トレードオフ.*禁止' "no-tradeoff invariant"
require_pattern "AGENTS.MD" 'STEP 1-7.*STEP 1-14.*既存CI.*既存チェック.*既存ドキュメント導線' "existing feature invariant scope"
require_pattern "AGENTS.MD" 'リファクタリング性.*エコシステム性.*再利用性.*汎用性' "quality invariant"
require_pattern "AGENTS.MD" '固定値.*場当たり的.*共通ライブラリ.*repo-local skills' "ecosystem integration invariant"
require_pattern "AGENTS.MD" '新しい検査.*単体.*集約テスト' "standalone and aggregate check invariant"
require_pattern "AGENTS.MD" 'skills/repository-development-workflow/SKILL\.md' "repository development workflow skill route"

require_pattern "skills/repository-development-workflow/SKILL.md" '^description: .*Use when' "skill trigger phrase"
require_pattern "skills/repository-development-workflow/SKILL.md" 'AGENTS\.MD' "AGENTS reference"
require_pattern "skills/repository-development-workflow/SKILL.md" 'worklog-doc-sync' "worklog route"
require_pattern "skills/repository-development-workflow/SKILL.md" 'lesson-sync-gate' "lesson sync route"
require_pattern "skills/repository-development-workflow/SKILL.md" 'repository-development-workflow' "workflow CLI reference"
require_pattern "skills/repository-development-workflow/references/repository-development.md" 'context_triage' "phase reference"
require_pattern "skills/repository-development-workflow/references/repository-development.md" 'release_gate' "release phase reference"
require_pattern "skills/repository-development-workflow/references/repository-development.md" 'explicit developer approval' "approval reference"

require_pattern "tools/repository-development-workflow" 'repository_development_validate_policy' "owner-layer validation"
require_pattern "tools/test_repository_development_workflow.sh" 'REPOSITORY_DEVELOPMENT_WORKFLOW_FILE' "policy override regression"

require_policy_row "docs/workflow/GIT_HOOK_CHECKS.tsv" '^check_repository_development_workflow\t' "hook check row"
require_policy_row "docs/workflow/GIT_HOOK_CHECKS.tsv" '^test_repository_development_workflow\t' "hook test row"
require_policy_row "docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv" '^check_repository_development_workflow\t' "parallel group check row"
require_policy_row "docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv" '^test_repository_development_workflow\t' "parallel group test row"
require_policy_row "docs/workflow/TEST_PLAN_MANIFEST.tsv" '^docs/workflow/REPOSITORY_DEVELOPMENT_WORKFLOW.tsv\t' "test-plan workflow policy row"
require_policy_row "docs/workflow/TEST_PLAN_MANIFEST.tsv" '^tools/lib/repository_development_workflow.sh\t' "test-plan helper row"
require_policy_row "docs/workflow/TEST_PLAN_MANIFEST.tsv" '^tools/repository-development-workflow\t' "test-plan CLI row"
require_policy_row "docs/workflow/TEST_PLAN_MANIFEST.tsv" '^tools/check_repository_development_workflow.sh\t' "test-plan check row"
require_policy_row "docs/workflow/TEST_PLAN_MANIFEST.tsv" '^tools/test_repository_development_workflow.sh\t' "test-plan test row"
require_policy_row "docs/workflow/TEST_PLAN_MANIFEST.tsv" '^skills/repository-development-workflow/\t' "test-plan skill row"
require_policy_row "docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv" '^repository_development_workflow_status\t[.]/tools/repository-development-workflow status >/dev/null\t' "final-gate status gap command"
require_policy_row "docs/workflow/FINAL_GATE_COVERAGE.tsv" '^[.]/tools/check_repository_development_workflow.sh\t' "final-gate check coverage"
require_policy_row "docs/workflow/FINAL_GATE_COVERAGE.tsv" '^[.]/tools/test_repository_development_workflow.sh\t' "final-gate test coverage"
require_policy_row "docs/workflow/FINAL_GATE_COVERAGE.tsv" '^[.]/tools/repository-development-workflow status\tgap\trepository_development_workflow_status\t' "final-gate status coverage"

require_pattern "tools/test_lesson_repository.sh" '\./tools/check_repository_development_workflow\.sh' "aggregate check wiring"
require_pattern "tools/test_lesson_repository.sh" '\./tools/test_repository_development_workflow\.sh' "aggregate test wiring"
require_pattern ".github/workflows/ci.yml" 'bash -n tools/lib/repository_development_workflow\.sh' "main CI syntax helper"
require_pattern ".github/workflows/ci.yml" '\./tools/test_repository_development_workflow\.sh' "main CI regression"
require_pattern ".github/workflows/lesson14-ci.yml" 'bash -n tools/lib/repository_development_workflow\.sh' "lesson14 CI syntax helper"
require_pattern ".github/workflows/lesson14-ci.yml" '\./tools/test_repository_development_workflow\.sh' "lesson14 CI regression"
require_pattern "tools/check_ci_workflow_structure.sh" 'tools/test_repository_development_workflow\.sh' "CI structure guard"

if ./tools/repository-development-workflow guidance --phase main_sync_cleanup | grep -Eq '(^|[[:space:]])rm[[:space:]]+-rf|git[[:space:]]+branch[[:space:]]+-D|git[[:space:]]+worktree[[:space:]]+remove|git[[:space:]]+push[[:space:]]+--delete|gh[[:space:]]+pr[[:space:]]+merge'; then
  report_missing "workflow guidance contains direct destructive cleanup or merge command"
fi

if [[ "$missing" -ne 0 ]]; then
  printf '\nRepository development workflow check failed.\n' >&2
  exit 1
fi

printf 'Repository development workflow check passed.\n'
