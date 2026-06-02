#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/lib/lesson_common.sh
source "$SCRIPT_DIR/lib/lesson_common.sh"
# shellcheck source=tools/lib/document_paths.sh
source "$SCRIPT_DIR/lib/document_paths.sh"

target_root="$LESSON_ROOT"
tracker="$(lesson_doc_path task_tracker)"
handoff="$(lesson_doc_path handoff)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --product)
      target_root="$(lesson_product_repo_root)"
      tracker="$target_root/TASK_TRACKER.md"
      handoff="$target_root/HANDOFF.md"
      shift
      ;;
    --repo)
      target_root="$(lesson_expand_path "${2:-}")"
      tracker="$target_root/TASK_TRACKER.md"
      handoff="$target_root/HANDOFF.md"
      shift 2
      ;;
    *)
      printf 'unknown option: %s\n' "$1" >&2
      exit 1
      ;;
  esac
done

missing=0

for file in "$tracker" "$handoff"; do
  if [[ ! -f "$file" ]]; then
    printf 'missing workflow pair file: %s\n' "$file" >&2
    missing=1
  fi
done

if [[ $missing -ne 0 ]]; then
  printf '\nWorkflow pair sync check failed.\n' >&2
  exit 1
fi

require_in_both() {
  local pattern="$1"
  local label="$2"
  if ! grep -Eiq "$pattern" "$tracker"; then
    printf 'missing %s in TASK_TRACKER: %s\n' "$label" "$tracker" >&2
    missing=1
  fi
  if ! grep -Eiq "$pattern" "$handoff"; then
    printf 'missing %s in HANDOFF: %s\n' "$label" "$handoff" >&2
    missing=1
  fi
}

require_in_both 'Current|Current State|Current Status|現在' 'current state'
require_in_both 'Next Step|Remaining Work|Next action|次' 'next action or remaining work'
require_in_both 'TASK_TRACKER|HANDOFF|workflow-state pair|workflow pair' 'paired workflow context'

if git -C "$target_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  tracker_rel="${tracker#"$target_root"/}"
  handoff_rel="${handoff#"$target_root"/}"
  changed="$(git -C "$target_root" diff --name-only -- "$tracker_rel" "$handoff_rel"; git -C "$target_root" diff --cached --name-only -- "$tracker_rel" "$handoff_rel")"
  tracker_changed=0
  handoff_changed=0
  if printf '%s\n' "$changed" | grep -Fx "$tracker_rel" >/dev/null; then
    tracker_changed=1
  fi
  if printf '%s\n' "$changed" | grep -Fx "$handoff_rel" >/dev/null; then
    handoff_changed=1
  fi
  if [[ "$tracker_changed" -ne "$handoff_changed" && -z "${WORKFLOW_PAIR_SINGLE_FILE_REASON:-}" ]]; then
    printf 'workflow pair changed only one file; set WORKFLOW_PAIR_SINGLE_FILE_REASON for an explicit exception\n' >&2
    missing=1
  fi
fi

if [[ $missing -ne 0 ]]; then
  printf '\nWorkflow pair sync check failed.\n' >&2
  exit 1
fi

printf 'Workflow pair sync check passed.\n'
