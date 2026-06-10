# Worklog Sync Reference

Product documentation has two roles:

Before product-repository development or product-document edits, prompt the learner to open a separate Ubuntu/WSL CLI window for `$HOME/projects/task-tracker-repository/`.

```text
docs/product/REQUIREMENTS.md / docs/product/SPECIFICATION.md / docs/product/IMPLEMENTATION_PLAN.md: current design
docs/workflow/TASK_TRACKER.md / docs/workflow/HANDOFF.md: work history and restart context
```

Initial creation records design first, then work history.

Feature changes and removals record work history first, then update current design after implementation is complete.

## Consistency Checks

```text
docs/workflow/TASK_TRACKER.md completed work matches implementation
docs/workflow/HANDOFF.md next action matches current state
docs/product/REQUIREMENTS.md describes current desired behavior
docs/product/SPECIFICATION.md describes current actual behavior
docs/product/IMPLEMENTATION_PLAN.md matches completed and remaining work
```
