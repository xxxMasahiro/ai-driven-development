#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
export LESSON_CONFIG="$ROOT/lesson/LESSON_CONFIG_14_DAYS.tsv"

# shellcheck source=tools/lib/lesson_common.sh
source "$SCRIPT_DIR/lib/lesson_common.sh"

FLOW="$(lesson_flow_file)"
STATE="$(lesson_state_file)"
ROADMAP="$(lesson_abs_path "$(lesson_config_get roadmap_file "learning/ROADMAP.md")")"
HELP_DESK="$(lesson_abs_path "$(lesson_config_get helpdesk_file "learning/HELP_DESK.md")")"
SYNC_GATES="$(lesson_abs_path "$(lesson_config_get sync_gates_file "lesson/SYNC_GATES_14_DAYS.tsv")")"
PROMPTS="$(lesson_abs_path "$(lesson_config_get prompt_file "prompts/PROMPTS_14_DAYS.md")")"
APPROVALS="$(lesson_approval_file)"
LEARNING_MODE="$(lesson_learning_mode_file)"
WORKFLOW_LANGUAGE="$(lesson_workflow_language_file)"
PRODUCT_LANGUAGE="$(lesson_product_language_file)"
INDEX="$ROOT/index-14-days.md"
GUIDE="$ROOT/guides/LESSON_14_DAYS.md"
PLAYBOOK="$ROOT/playbooks/AGENT_PLAYBOOK_14_DAYS.md"
TRACKER="$(lesson_tracker_file)"
HANDOFF="$(lesson_handoff_file)"

missing=0

require_pattern() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if ! grep -Eq "$pattern" "$file"; then
    printf 'missing %s in %s\n' "$label" "$file" >&2
    missing=1
  fi
}

for file in "$FLOW" "$STATE" "$ROADMAP" "$HELP_DESK" "$SYNC_GATES" "$PROMPTS" "$APPROVALS" "$LEARNING_MODE" "$WORKFLOW_LANGUAGE" "$PRODUCT_LANGUAGE" "$INDEX" "$GUIDE" "$PLAYBOOK" "$TRACKER" "$HANDOFF"; do
  if [[ ! -f "$file" ]]; then
    printf 'missing: %s\n' "$file" >&2
    missing=1
  fi
done

if [[ $missing -ne 0 ]]; then
  printf '\nLesson14 sync check failed.\n' >&2
  exit 1
fi

require_pattern "$FLOW" '^001[[:space:]]+setup\.index[[:space:]]+Setup[[:space:]]+index-14-days\.md' "14-day setup index entry"
require_pattern "$PROMPTS" 'index-14-days\.md' "14-day prompt entry"
require_pattern "$INDEX" 'LEARNING_TASK_TRACKER_14_DAYS\.md' "14-day tracker reference"
require_pattern "$INDEX" 'LEARNING_HANDOFF_14_DAYS\.md' "14-day handoff reference"
require_pattern "$INDEX" 'tools/lesson14 承認' "14-day approval command"
require_pattern "$INDEX" 'tools/lesson14 学習モード' "14-day learning mode command"
require_pattern "$INDEX" 'tools/lesson14 表示言語' "14-day workflow display language command"
require_pattern "$INDEX" 'tools/lesson14 開発言語' "14-day product development language command"
require_pattern "$PROMPTS" 'tools/lesson14 承認' "14-day approval prompt"
require_pattern "$PROMPTS" '承認 start' "14-day start approval prompt"
require_pattern "$PROMPTS" 'tools/lesson14 学習モード' "14-day learning mode prompt"
require_pattern "$PROMPTS" 'tools/lesson14 表示言語' "14-day workflow display language prompt"
require_pattern "$PROMPTS" 'tools/lesson14 開発言語' "14-day product development language prompt"
require_pattern "$GUIDE" 'tools/lesson14 承認' "14-day approval guide"
require_pattern "$GUIDE" '承認 start' "14-day start approval guide"
require_pattern "$GUIDE" 'tools/lesson14 学習モード' "14-day learning mode guide"
require_pattern "$PLAYBOOK" 'LEARNING_TASK_TRACKER_14_DAYS\.md' "14-day tracker playbook reference"
require_pattern "$PLAYBOOK" 'LEARNING_HANDOFF_14_DAYS\.md' "14-day handoff playbook reference"
if grep -Eq 'LEARNING_TASK_TRACKER\.md|LEARNING_HANDOFF\.md' "$SYNC_GATES"; then
  printf 'sync gates must use 14-day learning files only\n' >&2
  missing=1
fi

for step_number in $(seq 1 14); do
  step_label="Step $step_number/14"
  if ! awk -F '\t' -v step_label="$step_label" '$1 !~ /^#/ && $3 == step_label { found=1 } END { exit found ? 0 : 1 }' "$FLOW"; then
    printf 'missing %s in flow\n' "$step_label" >&2
    missing=1
  fi
  if ! awk -F '\t' -v step_label="$step_label" '$1 !~ /^#/ && $1 == step_label { found=1 } END { exit found ? 0 : 1 }' "$SYNC_GATES"; then
    printf 'missing %s in sync gates\n' "$step_label" >&2
    missing=1
  fi
  require_pattern "$ROADMAP" "Step $step_number/14([^0-9]|$)" "$step_label"
  require_pattern "$PROMPTS" "^## Step $step_number/14$" "$step_label prompt"
  require_pattern "$TRACKER" "Step $step_number/14([^0-9]|$)" "$step_label tracker row"
done

combined="$(mktemp)"
trap 'rm -f "$combined"' EXIT
cat "$FLOW" "$ROADMAP" "$PROMPTS" "$SYNC_GATES" "$INDEX" "$GUIDE" "$PLAYBOOK" > "$combined"

for topic in \
  'GitHub' \
  'CI' \
  'Playwright' \
  'サブエージェント' \
  'スキル' \
  'MCP' \
  'ロードマップ' \
  'ヘルプデスク' \
  'TASK_TRACKER' \
  'HANDOFF' \
  'REQUIREMENTS' \
  'SPECIFICATION' \
  'IMPLEMENTATION_PLAN'
do
  require_pattern "$combined" "$topic" "$topic"
done

if ! awk -F '\t' '
  $1 !~ /^#/ {
    if (NF != 6) {
      printf "invalid sync gate column count at %s: %d\n", $1, NF > "/dev/stderr"
      bad = 1
    }
    for (i = 1; i <= NF; i++) {
      if ($i == "") {
        printf "empty sync gate field at %s column %d\n", $1, i > "/dev/stderr"
        bad = 1
      }
    }
    if ($5 ~ /CI/ && $5 !~ /必要なら/ && $5 != "-" && $6 !~ /check_ci_status\.sh --product --required/) {
      printf "mandatory CI gate must use required CI check at %s\n", $1 > "/dev/stderr"
      bad = 1
    }
    if ($3 != "-" && $5 ~ /CI/ && $5 !~ /必要なら/ && $5 != "-" && $6 !~ /check_ci_status\.sh --product --required/) {
      printf "product CI gate must target product repository at %s\n", $1 > "/dev/stderr"
      bad = 1
    }
    if ($1 == "Step 14/14" && $6 !~ /check_git_sync\.sh --product --required/) {
      printf "Step 14/14 must use required git sync check\n" > "/dev/stderr"
      bad = 1
    }
    if ($1 == "Step 14/14" && $6 !~ /product-launch-check[[:space:]]+check/ ) {
      printf "Step 14/14 must use product launch check\n" > "/dev/stderr"
      bad = 1
    }
    if ($1 == "Step 14/14" && $6 !~ /--launch[[:space:]]+direct-index/ ) {
      printf "Step 14/14 product launch check must verify direct index launch\n" > "/dev/stderr"
      bad = 1
    }
    if ($4 ~ /push|remote|PR|merge|pull|同期/ && $6 !~ /check_git_sync\.sh --product --required/) {
      printf "remote sync gate must use required git sync check at %s\n", $1 > "/dev/stderr"
      bad = 1
    }
    if ($4 ~ /commit/ && $6 !~ /check_git_sync\.sh --product (--clean-required|--required)/) {
      printf "product commit gate must check product git state at %s\n", $1 > "/dev/stderr"
      bad = 1
    }
    if ($1 == "Step 3/14" && $6 !~ /check_repository_boundary\.sh --product-required/) {
      printf "Step 3/14 must require the product repository boundary\n" > "/dev/stderr"
      bad = 1
    }
  }
  END { exit bad }
' "$SYNC_GATES"; then
  missing=1
fi

if [[ $missing -ne 0 ]]; then
  printf '\nLesson14 sync check failed.\n' >&2
  exit 1
fi

printf 'Lesson14 sync check passed.\n'
