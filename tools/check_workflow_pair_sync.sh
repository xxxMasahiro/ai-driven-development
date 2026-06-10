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
product_mode=0
product_root_duplicates=()

resolve_product_workflow_pair() {
  local repo="$1"
  local canonical_tracker="$repo/docs/workflow/TASK_TRACKER.md"
  local legacy_tracker="$repo/TASK_TRACKER.md"
  local canonical_handoff="$repo/docs/workflow/HANDOFF.md"
  local legacy_handoff="$repo/HANDOFF.md"

  product_root_duplicates=()
  tracker="$canonical_tracker"
  handoff="$canonical_handoff"
  [[ ! -e "$legacy_tracker" ]] || product_root_duplicates+=("TASK_TRACKER.md")
  [[ ! -e "$legacy_handoff" ]] || product_root_duplicates+=("HANDOFF.md")
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --product)
      target_root="$(lesson_product_repo_root)"
      product_mode=1
      resolve_product_workflow_pair "$target_root"
      shift
      ;;
    --repo)
      target_root="$(lesson_expand_path "${2:-}")"
      product_mode=1
      resolve_product_workflow_pair "$target_root"
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
    if [[ "$product_mode" -eq 1 ]]; then
      printf 'missing workflow pair file: docs/workflow/%s\n' "$(basename "$file")" >&2
    else
      printf 'missing workflow pair file: %s\n' "$file" >&2
    fi
    missing=1
  fi
done

if [[ "$product_mode" -eq 1 && "${#product_root_duplicates[@]}" -gt 0 ]]; then
  for file in "${product_root_duplicates[@]}"; do
    printf 'root-level duplicate workflow file is not allowed: %s; keep docs/workflow/%s only\n' "$file" "$file" >&2
  done
  missing=1
fi

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
