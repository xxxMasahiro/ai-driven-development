#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export CI_EVIDENCE_USE="${CI_EVIDENCE_USE:-1}"
export CI_EVIDENCE_WRITE="${CI_EVIDENCE_WRITE:-1}"
export CI_EVIDENCE_RUN_ID="${CI_EVIDENCE_RUN_ID:-test-docs-tour-$$}"
export CI_EVIDENCE_SOURCE_JOB="${CI_EVIDENCE_SOURCE_JOB:-test_docs_tour}"
export DOCS_TOUR_SKIP_SYNC_STATUS=1

require_file() {
  local file="$1"
  if [[ ! -f "$ROOT/$file" ]]; then
    printf 'missing: %s\n' "$file" >&2
    exit 1
  fi
}

require_executable() {
  local file="$1"
  require_file "$file"
  if [[ ! -x "$ROOT/$file" ]]; then
    printf 'not executable: %s\n' "$file" >&2
    exit 1
  fi
}

require_output() {
  local label="$1"
  local output="$2"
  local pattern="$3"
  if ! grep -Eq "$pattern" <<<"$output"; then
    printf 'missing %s: %s\n' "$label" "$pattern" >&2
    exit 1
  fi
}

require_pattern() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if ! grep -Eq "$pattern" "$ROOT/$file"; then
    printf 'missing %s in %s\n' "$label" "$file" >&2
    exit 1
  fi
}

require_file "guides/DOCUMENT_MAP.md"
require_executable "tools/docs-tour"

status_output="$("$ROOT/tools/docs-tour" status)"
require_output "docs-tour status heading" "$status_output" "Documentation Map Status"
require_output "guide status" "$status_output" "guides/DOCUMENT_MAP.md"
require_output "workflow pair status" "$status_output" "TASK_TRACKER/HANDOFF pair"
require_output "as-built status" "$status_output" "As-built document set"
require_output "status role overview" "$status_output" "Quick role overview"
require_output "status AGENTS distinction" "$status_output" "AGENTS.MD: lesson-side agent rulebook"
require_output "status product agent distinction" "$status_output" "product-side AGENT.md"
require_output "status product failure memory" "$status_output" "product-side docs/memory/FAILURE_MEMORY.md"
require_output "status Git hook policy" "$status_output" "Git hook policy"
require_output "status Git hook checks" "$status_output" "GIT_HOOK_CHECKS.tsv"
require_output "status Git hook recommendation paths" "$status_output" "GIT_HOOK_RECOMMENDATION_PATHS.tsv"

all_output="$("$ROOT/tools/docs-tour" all)"
require_output "rules section" "$all_output" "Rules And Routing"
require_output "design section" "$all_output" "Design And As-Built Documents"
require_output "workflow section" "$all_output" "Workflow State Documents"
require_output "memory section" "$all_output" "Memory And Decisions"
require_output "skills section" "$all_output" "Repo-Local Skills"
require_output "AGENTS distinction" "$all_output" "AGENTS.MD.*AGENT.md|AGENT.md"
require_output "developer memory" "$all_output" "DEVELOPER_MEMORY.md"
require_output "failure memory" "$all_output" "FAILURE_MEMORY.md"
require_output "Git hook policy tour" "$all_output" "GIT_HOOKS_POLICY.tsv"
require_output "Git hook recommendation paths tour" "$all_output" "GIT_HOOK_RECOMMENDATION_PATHS.tsv"
require_output "Git hook settings tour" "$all_output" "GIT_HOOK_SETTINGS.tsv"

dashboard_output="$("$ROOT/tools/dashboard" docs)"
require_output "dashboard docs heading" "$dashboard_output" "Documentation Map Dashboard"
require_output "dashboard docs tour status" "$dashboard_output" "Documentation Map Status"
require_output "dashboard document purposes" "$dashboard_output" "Document purposes"
require_output "dashboard AGENTS distinction" "$dashboard_output" "AGENTS.MD: lesson-side agent rulebook"
require_output "dashboard product agent distinction" "$dashboard_output" "product-side AGENT.md"
require_output "dashboard failure memory" "$dashboard_output" "product-side docs/memory/FAILURE_MEMORY.md"
require_output "dashboard Git hook policy category" "$dashboard_output" "Git hook policy"
require_output "dashboard Git hooks policy file" "$dashboard_output" "GIT_HOOKS_POLICY.tsv"
require_output "dashboard Git hook checks file" "$dashboard_output" "GIT_HOOK_CHECKS.tsv"
require_output "dashboard Git hook recommendation paths file" "$dashboard_output" "GIT_HOOK_RECOMMENDATION_PATHS.tsv"
require_output "dashboard Git hook settings" "$dashboard_output" "GIT_HOOK_SETTINGS.tsv"

dashboard_all_output="$("$ROOT/tools/dashboard" all)"
require_output "dashboard all docs view" "$dashboard_all_output" "Documentation Map Dashboard"

require_pattern "guides/DOCUMENT_MAP.md" "AGENTS.MD" "guide AGENTS explanation"
require_pattern "guides/DOCUMENT_MAP.md" "docs/as-built/REQUIREMENTS.md" "guide requirements explanation"
require_pattern "guides/DOCUMENT_MAP.md" "docs/workflow/TASK_TRACKER.md" "guide task tracker explanation"
require_pattern "guides/DOCUMENT_MAP.md" "docs/workflow/HANDOFF.md" "guide handoff explanation"
require_pattern "guides/DOCUMENT_MAP.md" "docs/workflow/GIT_HOOKS_POLICY.tsv" "guide Git hooks policy explanation"
require_pattern "guides/DOCUMENT_MAP.md" "docs/workflow/GIT_HOOK_CHECKS.tsv" "guide Git hook checks explanation"
require_pattern "guides/DOCUMENT_MAP.md" "docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv" "guide Git hook recommendation explanation"
require_pattern "guides/DOCUMENT_MAP.md" "learning/GIT_HOOK_SETTINGS.tsv" "guide Git hook settings explanation"
require_pattern "guides/DOCUMENT_MAP.md" "docs/memory/DEVELOPER_MEMORY.md" "guide developer memory explanation"
require_pattern "guides/DOCUMENT_MAP.md" "FAILURE_MEMORY.md" "guide failure memory explanation"
require_pattern "guides/DOCUMENT_MAP.md" "skills/.*/SKILL.md|skills/\\*/SKILL.md" "guide skills explanation"
require_pattern "guides/DOCUMENT_MAP.md" "Read docs/workflow/TASK_TRACKER.md and docs/workflow/HANDOFF.md" "workflow prompt example"
require_pattern "guides/DOCUMENT_MAP.md" "Read docs/as-built/REQUIREMENTS.md, docs/as-built/SPECIFICATION.md, and docs/as-built/IMPLEMENTATION_PLAN.md" "as-built prompt example"
require_pattern "prompts/PROMPTS.md" "文書マップ|DOCUMENT_MAP" "7-day document-map prompt"
require_pattern "prompts/PROMPTS.md" "AGENT.mdは成果物リポジトリ側" "7-day AGENT distinction prompt"
require_pattern "prompts/PROMPTS.md" "成果物リポジトリ側のdocs/memory/FAILURE_MEMORY.md" "7-day product failure memory prompt"
require_pattern "prompts/PROMPTS_14_DAYS.md" "文書マップ|DOCUMENT_MAP" "14-day document-map prompt"
require_pattern "prompts/PROMPTS_14_DAYS.md" "AGENT.mdは成果物リポジトリ側" "14-day AGENT distinction prompt"
require_pattern "prompts/PROMPTS_14_DAYS.md" "成果物リポジトリ側のdocs/memory/FAILURE_MEMORY.md" "14-day product failure memory prompt"
require_pattern "index.md" "DOCUMENT_MAP|文書マップ" "7-day early document-map guidance"
require_pattern "index-14-days.md" "DOCUMENT_MAP|文書マップ" "14-day early document-map guidance"
if grep -Eq 'Planned Documentation Map|documentation-map improvement is planned and not yet implemented|guides/DOCUMENT_MAP.md.*planned artifacts|tools/docs-tour.*planned artifacts|not yet part of the runtime dispatcher' "$ROOT/docs/as-built/SPECIFICATION.md" "$ROOT/docs/as-built/REQUIREMENTS.md" "$ROOT/docs/as-built/IMPLEMENTATION_PLAN.md" "$ROOT/docs/workflow/TASK_TRACKER.md" "$ROOT/docs/workflow/HANDOFF.md"; then
  printf 'documentation map implementation is still described as unimplemented in a synchronized document\n' >&2
  exit 1
fi

printf 'Documentation tour tests passed.\n'
