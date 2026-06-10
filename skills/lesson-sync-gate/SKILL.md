---
name: lesson-sync-gate
description: Validate and enforce synchronization gates for this AI-driven development lesson. Use when passing a 14-day lesson sync gate; checking consistency among lesson state, roadmap, prompts, product documents, docs/workflow/TASK_TRACKER.md, docs/workflow/HANDOFF.md, Git state, and GitHub Actions; or repairing failed lesson/CI/Git/document sync checks.
---

# Lesson Sync Gate

## Required Sequence

1. Read `AGENTS.MD`.
2. Read `lesson/SYNC_GATES_14_DAYS.tsv`.
3. Run:

```bash
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
```

4. If the current day requires Git or CI, run the command listed in column 6 of `lesson/SYNC_GATES_14_DAYS.tsv`.
5. Before a product-repository gate, confirm the learner was prompted to open a separate Ubuntu/WSL CLI window for `$HOME/projects/task-tracker-repository/`.
6. Fix only the failing scope.
7. Re-run checks until they pass.
8. Pass the current step with `tools/lesson14 通過 <step_id> "メモ"` only after requirements are satisfied.

## Gate Rules

- Mandatory CI gates must use `tools/check_ci_status.sh --required`.
- Product CI gates must use `tools/check_ci_status.sh --product --required`.
- Remote sync gates must use `tools/check_git_sync.sh --product --required`.
- Product commit gates must use `tools/check_git_sync.sh --product --clean-required`.
- Step 14/14 must require Git sync, CI status, and product launch-path verification.
- 14-day learning records must use `_14_DAYS` files.
- 14-day entry must be `index-14-days.md`.
- Product-repository gates must preserve the separate Ubuntu/WSL CLI window prompt.

## References

Read `references/sync-gates.md` when diagnosing a failed gate.

## Failure Handling

When a check fails, report:

```text
failed command
reason
file or command to fix
next safe action
```

Do not bypass checks by editing state files directly unless the task is explicitly to repair corrupted lesson state.
