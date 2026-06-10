# Sync Gate Reference

The sync-gate source of truth is `lesson/SYNC_GATES_14_DAYS.tsv`.
Before product-repository gates, confirm the learner was prompted to open a separate Ubuntu/WSL CLI window for `$HOME/projects/task-tracker-repository/`.

## Core Checks

```bash
./tools/check_lesson_structure.sh
./tools/check_repository_boundary.sh
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/test_lesson14.sh
```

## Git And CI

Use required mode when the gate says Git or CI is mandatory:

```bash
./tools/check_git_sync.sh --required
./tools/check_ci_status.sh --required
./tools/check_git_sync.sh --product --clean-required
./tools/check_git_sync.sh --product --required
./tools/check_ci_status.sh --product --required
```

Use optional mode only for exploratory status checks.
Use `--product` when the gate is checking the task-tracker product repository rather than the lesson repository.
Use `--clean-required` when a local commit is required but upstream sync is not required yet.

## Document Sync

Initial creation flow:

```text
docs/product/REQUIREMENTS.md
docs/product/SPECIFICATION.md
docs/product/IMPLEMENTATION_PLAN.md
then docs/workflow/TASK_TRACKER.md and docs/workflow/HANDOFF.md
```

Change flow:

```text
docs/workflow/TASK_TRACKER.md and docs/workflow/HANDOFF.md first
implementation next
then docs/product/REQUIREMENTS.md, docs/product/SPECIFICATION.md, docs/product/IMPLEMENTATION_PLAN.md
```
