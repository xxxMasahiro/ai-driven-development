#!/usr/bin/env bash

lesson_document_paths_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "${LESSON_ROOT:-}" ]]; then
  # shellcheck source=tools/lib/lesson_common.sh
  source "$lesson_document_paths_dir/lesson_common.sh"
fi

lesson_docs_root() {
  printf '%s/docs' "$LESSON_ROOT"
}

lesson_doc_path() {
  local key="$1"
  case "$key" in
    requirements)
      printf '%s/as-built/REQUIREMENTS.md' "$(lesson_docs_root)"
      ;;
    specification)
      printf '%s/as-built/SPECIFICATION.md' "$(lesson_docs_root)"
      ;;
    implementation_plan)
      printf '%s/as-built/IMPLEMENTATION_PLAN.md' "$(lesson_docs_root)"
      ;;
    task_tracker)
      printf '%s/workflow/TASK_TRACKER.md' "$(lesson_docs_root)"
      ;;
    handoff)
      printf '%s/workflow/HANDOFF.md' "$(lesson_docs_root)"
      ;;
    developer_memory)
      printf '%s/memory/DEVELOPER_MEMORY.md' "$(lesson_docs_root)"
      ;;
    *)
      printf 'unknown lesson document key: %s\n' "$key" >&2
      return 1
      ;;
  esac
}

lesson_doc_relpath() {
  local key="$1"
  local path
  path="$(lesson_doc_path "$key")"
  printf '%s' "${path#"$LESSON_ROOT"/}"
}

lesson_design_doc_keys() {
  printf '%s\n' requirements specification implementation_plan
}

lesson_workflow_doc_keys() {
  printf '%s\n' task_tracker handoff
}

lesson_memory_doc_keys() {
  printf '%s\n' developer_memory
}

lesson_all_role_doc_keys() {
  lesson_design_doc_keys
  lesson_workflow_doc_keys
  lesson_memory_doc_keys
}
