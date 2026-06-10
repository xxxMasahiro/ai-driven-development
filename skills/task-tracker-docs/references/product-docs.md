# Product Document Reference

The product repository is separate from this lesson repository.
Before product-repository development, prompt the learner to open a separate Ubuntu/WSL CLI window for `$HOME/projects/task-tracker-repository/`.

Standard product files:

```text
AGENT.md
docs/product/REQUIREMENTS.md
docs/product/SPECIFICATION.md
docs/product/IMPLEMENTATION_PLAN.md
docs/workflow/TASK_TRACKER.md
docs/workflow/HANDOFF.md
docs/memory/SESSION_MEMORY.md
docs/memory/FAILURE_MEMORY.md
docs/memory/DEVELOPER_MEMORY.md
index.html
style.css
app.js
README.md
```

## Roles

```text
docs/product/REQUIREMENTS.md: what to build
docs/product/SPECIFICATION.md: how it behaves
docs/product/IMPLEMENTATION_PLAN.md: order of work
docs/workflow/TASK_TRACKER.md: work progress
docs/workflow/HANDOFF.md: next-session handoff
docs/memory/SESSION_MEMORY.md: session-specific facts
docs/memory/FAILURE_MEMORY.md: failures and recovery
docs/memory/DEVELOPER_MEMORY.md: stable developer preferences
```

## Sync Order

Initial setup:

```text
requirements -> specification -> implementation plan -> task tracker -> handoff
```

Feature change:

```text
task tracker -> handoff -> implementation -> requirements/specification/plan sync
```
