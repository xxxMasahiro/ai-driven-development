#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
missing=0

# shellcheck source=tools/lib/git_hooks_policy.sh
source "$ROOT/tools/lib/git_hooks_policy.sh"

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
  if ! grep -Eq -- "$pattern" "$ROOT/$file"; then
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
      while IFS="$row_separator" read -r _ _ row_command _; do
        if [[ "$row_command" == "./tools/$command" || "$row_command" == "$ROOT/tools/$command" ]]; then
          return
        fi
      done <<<"$rows"
    fi
  fi
  printf 'missing %s in .githooks/pre-commit\n' "$label" >&2
  missing=1
}

require_file "AGENTS.MD"
require_pattern "AGENTS.MD" '^## 不変ルール$' "immutable rules heading"
require_pattern "AGENTS.MD" '^## 起動手順$' "bootstrap heading"
require_pattern "AGENTS.MD" '^## ルーティングテーブル$' "routing table heading"
require_pattern "AGENTS.MD" 'エージェントは、ユーザーに `index\.md` や `index-14-days\.md` を探させません。' "agent-routed index policy"
require_pattern "AGENTS.MD" '^1\. 学習用リポジトリと成果物リポジトリは、2つのUbuntu/WSL CLI画面で分けて扱う。$' "two-cli immutable rule"
require_pattern "AGENTS.MD" '成果物リポジトリの開発に入る前には、必ず学習者へ別画面でUbuntu/WSL CLIを起動' "product CLI prompt immutable detail"
require_pattern "AGENTS.MD" '^2\. 既存機能とのトレードオフは一切禁止する。$' "no-tradeoff immutable rule"
require_pattern "AGENTS.MD" '^3\. 実装とテストは、リファクタリング性、エコシステム性、再利用性、汎用性を満たす。$' "implementation-quality immutable rule"
require_pattern "AGENTS.MD" 'AGENTS\.MD.*AGENT\.md' "AGENTS versus AGENT distinction"
require_pattern "AGENTS.MD" 'STEP 1-7: 基礎レッスン: index\.md' "STEP 1-7 default entry"
require_pattern "AGENTS.MD" 'STEP 1-14: 実践レッスン: index-14-days\.md' "STEP 1-14 default entry"
require_pattern "AGENTS.MD" 'index-14-days\.md' "14-day entry route"
require_pattern "AGENTS.MD" 'skills/github-login-onboarding/SKILL\.md' "github login skill route"
require_pattern "AGENTS.MD" 'skills/learning-progress-helpdesk/SKILL\.md' "learning progress skill route"
require_pattern "AGENTS.MD" 'skills/lesson14-facilitator/SKILL\.md' "lesson14 skill route"
require_pattern "AGENTS.MD" 'skills/lesson-sync-gate/SKILL\.md' "sync skill route"
require_pattern "AGENTS.MD" 'skills/lesson-repository-development/SKILL\.md' "lesson repository development skill route"
require_pattern "AGENTS.MD" 'skills/task-tracker-docs/SKILL\.md' "task docs skill route"
require_pattern "AGENTS.MD" 'skills/worklog-doc-sync/SKILL\.md' "worklog sync skill route"
require_pattern "AGENTS.MD" 'tools/check_agents_skills\.sh' "agents skills check"

skills=(
  "github-login-onboarding"
  "learning-progress-helpdesk"
  "lesson14-facilitator"
  "lesson-sync-gate"
  "lesson-repository-development"
  "task-tracker-docs"
  "worklog-doc-sync"
)

skill_count="$(find "$ROOT/skills" -mindepth 1 -maxdepth 1 -type d | wc -l)"
if [[ "$skill_count" -ne "${#skills[@]}" ]]; then
  printf 'unexpected skill directory count: expected %d, got %s\n' "${#skills[@]}" "$skill_count" >&2
  missing=1
fi

for skill in "${skills[@]}"; do
  require_file "skills/$skill/SKILL.md"
  require_file "skills/$skill/agents/openai.yaml"
  require_pattern "skills/$skill/SKILL.md" '^---$' "$skill frontmatter delimiter"
  require_pattern "skills/$skill/SKILL.md" "^name: $skill$" "$skill name"
  require_pattern "skills/$skill/SKILL.md" '^description: .{40,}$' "$skill description"
  require_pattern "skills/$skill/SKILL.md" '^description: .*Use when' "$skill trigger phrase"
  require_pattern "skills/$skill/agents/openai.yaml" 'display_name:' "$skill display name"
  require_pattern "skills/$skill/agents/openai.yaml" 'short_description: ".{10,}"' "$skill short description"
  require_pattern "skills/$skill/agents/openai.yaml" 'default_prompt: ".{10,}"' "$skill default prompt"
  first_line="$(sed -n '1p' "$ROOT/skills/$skill/SKILL.md")"
  [[ "$first_line" == "---" ]] || { printf 'frontmatter must start at first line: %s\n' "$skill" >&2; missing=1; }
  if grep -R '\[TODO:\|TODO' "$ROOT/skills/$skill" >/dev/null; then
    printf 'TODO remains in skill: %s\n' "$skill" >&2
    missing=1
  fi
done

require_file "skills/github-login-onboarding/references/github-login.md"
require_file "skills/learning-progress-helpdesk/references/progress-helpdesk.md"
require_file "skills/lesson14-facilitator/references/routes.md"
require_file "skills/lesson-sync-gate/references/sync-gates.md"
require_file "skills/lesson-repository-development/references/repository-development.md"
require_file "skills/task-tracker-docs/references/product-docs.md"
require_file "skills/worklog-doc-sync/references/worklog-sync.md"

require_pattern "skills/github-login-onboarding/SKILL.md" 'github-login-setup-guide\.md' "github login guide route"
require_pattern "skills/learning-progress-helpdesk/SKILL.md" 'tools/helpdesk' "helpdesk command"
require_pattern "skills/lesson14-facilitator/SKILL.md" 'tools/lesson14 status' "lesson14 status command"
require_pattern "skills/lesson14-facilitator/SKILL.md" 'check_agents_skills\.sh' "lesson14 facilitator agents check"
require_pattern "skills/lesson14-facilitator/SKILL.md" 'separate Ubuntu/WSL CLI window' "lesson14 product CLI prompt"
require_pattern "skills/lesson-sync-gate/SKILL.md" 'check_ci_status\.sh --required' "required CI check"
require_pattern "skills/lesson-sync-gate/SKILL.md" 'check_git_sync\.sh --product --required' "required product git check"
require_pattern "skills/lesson-sync-gate/SKILL.md" 'separate Ubuntu/WSL CLI window' "sync gate product CLI prompt"
require_pattern "skills/lesson-repository-development/SKILL.md" 'repository-development-workflow status' "repository development workflow status"
require_pattern "skills/lesson-repository-development/SKILL.md" 'worklog-doc-sync' "repository development worklog route"
require_pattern "skills/lesson-repository-development/SKILL.md" 'lesson-sync-gate' "repository development lesson sync route"
require_pattern "skills/lesson-repository-development/references/repository-development.md" 'main_sync_cleanup' "repository development main cleanup phase"
require_pattern "skills/lesson-repository-development/references/repository-development.md" 'explicit developer approval' "repository development approval boundary"
require_pattern "skills/task-tracker-docs/SKILL.md" 'docs/product/REQUIREMENTS\.md' "requirements route"
require_pattern "skills/task-tracker-docs/SKILL.md" 'docs/workflow/TASK_TRACKER\.md' "tracker route"
require_pattern "skills/task-tracker-docs/SKILL.md" 'separate Ubuntu/WSL CLI window' "task docs product CLI prompt"
require_pattern "skills/worklog-doc-sync/SKILL.md" 'docs/product/IMPLEMENTATION_PLAN\.md' "implementation plan route"
require_pattern "skills/worklog-doc-sync/SKILL.md" 'separate Ubuntu/WSL CLI window' "worklog product CLI prompt"
require_pattern "skills/lesson14-facilitator/references/routes.md" 'separate Ubuntu/WSL CLI window' "lesson14 routes product CLI prompt"
require_pattern "skills/lesson-sync-gate/references/sync-gates.md" 'separate Ubuntu/WSL CLI window' "sync gate reference product CLI prompt"
require_pattern "skills/task-tracker-docs/references/product-docs.md" 'separate Ubuntu/WSL CLI window' "task docs reference product CLI prompt"
require_pattern "skills/worklog-doc-sync/references/worklog-sync.md" 'separate Ubuntu/WSL CLI window' "worklog reference product CLI prompt"

require_pre_commit_check 'check_agents_skills.sh' "pre-commit agents skills check"
require_pre_commit_check 'check_lesson14_structure.sh' "pre-commit lesson14 structure check"
require_pre_commit_check 'check_lesson14_sync.sh' "pre-commit lesson14 sync check"
require_pattern ".github/workflows/ci.yml" 'check_agents_skills\.sh' "ci agents skills check"
require_pattern ".github/workflows/lesson14-ci.yml" 'check_agents_skills\.sh' "lesson14 ci agents skills check"
require_pattern "ai-driven-task-tracker-scenario.md" '成果物リポジトリの開発に入る前には、別画面でUbuntu/WSL CLIを起動' "7-day scenario product CLI prompt"
require_pattern "guides/LESSON_GUIDE.md" '成果物リポジトリの開発に入る前には、別画面でUbuntu/WSL CLIを起動' "7-day guide product CLI prompt"
require_pattern "guides/LESSON_14_DAYS.md" '成果物リポジトリの開発に入る前には、別画面でUbuntu/WSL CLIを起動' "14-day guide product CLI prompt"
require_pattern "learning/ROADMAP.md" '別画面のUbuntu/WSL CLI起動' "roadmap product CLI prompt"
require_pattern "lesson/LESSON_FLOW.tsv" '別CLI起動' "7-day flow product CLI prompt"
require_pattern "lesson/LESSON_FLOW_14_DAYS.tsv" '別CLI起動' "14-day flow product CLI prompt"
require_pattern "lesson/SYNC_GATES_14_DAYS.tsv" 'Step 3/14.*check_repository_boundary\.sh --product-required && tools/check_git_sync\.sh --product --clean-required' "Step 3/14 product boundary gate"
require_pattern "lesson/SYNC_GATES_14_DAYS.tsv" 'Step 5/14.*check_git_sync\.sh --product --required && tools/check_ci_status\.sh --product --required' "Step 5/14 product git ci gate"
require_pattern "lesson/SYNC_GATES_14_DAYS.tsv" 'Step 11/14.*check_git_sync\.sh --product --required && tools/check_ci_status\.sh --product --required' "Step 11/14 product git ci gate"
require_pattern "lesson/SYNC_GATES_14_DAYS.tsv" 'Step 13/14.*check_agents_skills\.sh' "Step 13/14 agents skills gate"
require_pattern "lesson/SYNC_GATES_14_DAYS.tsv" 'Step 14/14.*check_git_sync\.sh --product --required && tools/check_ci_status\.sh --product --required' "Step 14/14 product git ci gate"
require_pattern "index.md" '成果物リポジトリの開発に入る前には、別画面でUbuntu/WSL CLIを起動' "7-day index product CLI prompt"
require_pattern "index-14-days.md" 'check_agents_skills\.sh' "14-day index agents skills check"
require_pattern "index-14-days.md" '成果物リポジトリの開発に入る前に、学習者は別画面でUbuntu/WSL CLIを起動' "14-day index product CLI prompt"
require_pattern "playbooks/AGENT_PLAYBOOK.md" '別画面でUbuntu/WSL CLIを起動するよう必ず促す' "7-day playbook product CLI prompt"
require_pattern "playbooks/AGENT_PLAYBOOK_14_DAYS.md" 'check_agents_skills\.sh' "14-day playbook agents skills check"
require_pattern "playbooks/AGENT_PLAYBOOK_14_DAYS.md" '別画面でUbuntu/WSL CLIを起動するよう必ず促す' "14-day playbook product CLI prompt"
require_pattern "prompts/PROMPTS.md" '成果物リポジトリの開発に入る前には、別画面でUbuntu/WSL CLIを起動するよう必ず促してください。' "7-day prompt product CLI prompt"
require_pattern "prompts/PROMPTS_14_DAYS.md" 'check_agents_skills\.sh' "14-day prompt agents skills check"
require_pattern "prompts/PROMPTS_14_DAYS.md" '成果物リポジトリの開発に入る前には、別画面でUbuntu/WSL CLIを起動するよう必ず促してください。' "14-day prompt product CLI prompt"
require_pattern "tools/check_repository_boundary.sh" 'separate Ubuntu/WSL CLI window' "boundary check product CLI prompt"
require_pattern "tools/check_repository_boundary.sh" '--product-required' "boundary required product option"
require_pattern "tools/check_git_sync.sh" '--product' "git sync product option"
require_pattern "tools/check_git_sync.sh" '--clean-required' "git sync clean required option"
require_pattern "tools/check_ci_status.sh" '--product' "ci status product option"
require_pattern "tools/check_ci_status.sh" '--commit' "ci status commit option"

if [[ $missing -ne 0 ]]; then
  printf '\nAGENTS and skills check failed.\n' >&2
  exit 1
fi

printf 'AGENTS and skills check passed.\n'
