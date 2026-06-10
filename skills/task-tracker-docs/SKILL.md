---
name: task-tracker-docs
description: Create, review, and synchronize the task-tracker product repository documents used by the lesson. Use when working on docs/product/REQUIREMENTS.md, docs/product/SPECIFICATION.md, docs/product/IMPLEMENTATION_PLAN.md, docs/workflow/TASK_TRACKER.md, docs/workflow/HANDOFF.md, AGENT.md, docs/memory/SESSION_MEMORY.md, docs/memory/FAILURE_MEMORY.md, docs/memory/DEVELOPER_MEMORY.md, or README.md for the task-tracker product, especially when converting learner answers into approved document drafts.
---

# Task Tracker Docs

## Workflow

1. Before product-repository development, prompt the learner to open a separate Ubuntu/WSL CLI window for `$HOME/projects/task-tracker-repository/`.
2. Confirm repository boundary:

```bash
pwd
git rev-parse --show-toplevel
```

3. If unsure, run the lesson-side boundary check from the lesson repository:

```bash
./tools/check_repository_boundary.sh
```

4. Read `templates/TEMPLATES.md`.
5. For initial creation, draft `docs/product/REQUIREMENTS.md`, `docs/product/SPECIFICATION.md`, and `docs/product/IMPLEMENTATION_PLAN.md` first.
6. Record initial creation in `docs/workflow/TASK_TRACKER.md` and `docs/workflow/HANDOFF.md`.
7. For later changes, update `docs/workflow/TASK_TRACKER.md` and `docs/workflow/HANDOFF.md` first, implement, then sync the three design documents.
8. Present update proposals before editing protected product documents.

## Edit Policy

- `AGENT.md` and `docs/memory/DEVELOPER_MEMORY.md` may be agent-maintained according to lesson rules.
- Other product memory/history/design files require developer approval before writing.
- Keep learner-facing explanations short and non-engineer friendly.
- Keep generated product docs consistent with current implementation state.

## References

Read `references/product-docs.md` for the product-document roles and sync order.
