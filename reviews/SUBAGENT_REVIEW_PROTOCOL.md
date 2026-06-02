# Sub-Agent Review Protocol

Use this protocol when the lesson repository needs multi-perspective verification.

## Purpose

The goal is to verify that implementation, tests, and as-built documents describe the same state.
Sub-agents are used as role-based reviewers, not as automatic background workers.
The orchestrating agent must combine findings and decide what to adopt, defer, or reject.

## Required Review Roles

1. Documentation consistency reviewer
   - Checks `docs/as-built/REQUIREMENTS.md`, `docs/as-built/SPECIFICATION.md`, `docs/as-built/IMPLEMENTATION_PLAN.md`, `docs/workflow/TASK_TRACKER.md`, and `docs/workflow/HANDOFF.md`.
   - Confirms that the same capabilities and constraints appear across all five files.

2. Implementation and test reviewer
   - Checks tools, gates, and test scripts.
   - Confirms that required behavior is mechanically enforced where appropriate.

3. Learning experience reviewer
   - Checks lesson guides, prompts, AGENTS, and advanced modules.
   - Confirms that dialogue, sub-agent orchestration, Free Development Mode, and Docker/team development are learnable.

## Review Output Format

Each reviewer returns:

```text
Findings:
- <severity> <file>: <issue>

Suggested fixes:
- <concrete fix>

Pass/fail:
- PASS or FAIL
```

## Local Checks

Run these before and after applying review fixes:

```bash
./tools/check_as_built_docs.sh
./tools/check_developer_memory_requirements.sh
./tools/test_lesson_repository.sh
```
