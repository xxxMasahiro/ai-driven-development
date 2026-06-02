#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/lib/lesson_common.sh
source "$SCRIPT_DIR/lib/lesson_common.sh"
# shellcheck source=tools/lib/document_paths.sh
source "$SCRIPT_DIR/lib/document_paths.sh"

missing=0

require_doc() {
  local key="$1"
  local path
  path="$(lesson_doc_path "$key")"
  if [[ ! -f "$path" ]]; then
    printf 'missing role document: %s\n' "${path#"$LESSON_ROOT"/}" >&2
    missing=1
  fi
}

for key in $(lesson_all_role_doc_keys); do
  require_doc "$key"
done

root_forbidden=(
  "REQUIREMENTS.md"
  "SPECIFICATION.md"
  "IMPLEMENTATION_PLAN.md"
  "TASK_TRACKER.md"
  "HANDOFF.md"
  "DEVELOPER_MEMORY.md"
)

for file in "${root_forbidden[@]}"; do
  if [[ -e "$LESSON_ROOT/$file" ]]; then
    printf 'misplaced root role document: %s\n' "$file" >&2
    missing=1
  fi
done

if [[ -f "$LESSON_ROOT/AGENTS.MD" ]]; then
  :
else
  printf 'missing root agent entry: AGENTS.MD\n' >&2
  missing=1
fi

if [[ $missing -ne 0 ]]; then
  printf '\nDocument organization check failed.\n' >&2
  exit 1
fi

printf 'Document organization check passed.\n'
