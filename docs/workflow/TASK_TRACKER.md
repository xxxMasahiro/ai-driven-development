# TASK_TRACKER.md

## Current Status

The lesson repository includes mechanical enforcement, flexible lesson entry, Free Development Mode, Team Development and Docker advanced module, dialogue-centered learning, initial as-built synchronization checks, sub-agent review protocol, menu/dashboard/illustration entry points, and lesson-side aggregate testing.

The 2026-06-02 unfinished developer-memory audit found that several recorded requirements are not fully implemented or mechanically enforced yet.
The current task is to keep the existing functionality intact while synchronizing and then implementing the remediation plan recorded in `docs/as-built/REQUIREMENTS.md`, `docs/as-built/SPECIFICATION.md`, and `docs/as-built/IMPLEMENTATION_PLAN.md`.

## Completed

- Recorded developer feedback in `docs/memory/DEVELOPER_MEMORY.md`.
- Added 14-day approval receipts and enforcement.
- Added learning mode A/B/C selection and switching.
- Added learner-selected start position commands for 7-day and 14-day lessons.
- Added 14-day runtime reset command.
- Added `tools/check_developer_memory_requirements.sh`.
- Added `tools/test_lesson_start_position.sh`.
- Added `tools/test_production_operations.sh` for explicit real product operations testing.
- Kept `task-tracker-repository` deleted for the current lesson-side validation scope.
- Added Free Development Mode.
- Added Team Development and Docker advanced module.
- Added Docker learning paths for installed and not-installed environments.
- Added agent dialogue and wall-bouncing as core lesson content.
- Added sub-agent orchestration guidance.
- Added MCP purpose-before-workflow guidance for Step 13/14.
- Hardened GitHub Actions CI status checking.
- Added as-built document consistency checks.
- Added sub-agent review protocol checks.
- Added lesson-repository aggregate test.
- Added product-gate tool tests that use a temporary product repository and fake CI response.
- Added a non-English Markdown listing tool for translation follow-up.
- Added learner-facing menu, dashboard, and illustration review entry points.
- Documented implementation quality constraints: refactorability, ecosystem fit, reusability, and generality.
- Preserved the no-tradeoff rule for existing features.
- Added as-built lesson-side documents:
  - `docs/as-built/REQUIREMENTS.md`
  - `docs/as-built/SPECIFICATION.md`
  - `docs/as-built/IMPLEMENTATION_PLAN.md`
  - `docs/workflow/TASK_TRACKER.md`
  - `docs/workflow/HANDOFF.md`

## Open Remediation Backlog

The following items are open until implemented and mechanically verified:

1. Add shared document-path support for design/as-built, workflow-state, and memory/decision documents.
2. Safely migrate role-specific Markdown documents into directories while keeping `AGENTS.MD` at root.
3. Replace learner-facing `Day N` labels with `Step N` labels where practical.
4. Hide internal step IDs from ordinary learner-facing output.
5. Implement separate workflow display language and product development language settings.
6. Enforce learner-facing learning-mode display names while preserving A/B/C internal IDs.
7. Strengthen start/pass approval gates and approval/action pairing checks.
8. Improve passage prompts and copy-paste command-block explanations.
9. Enforce `docs/workflow/TASK_TRACKER.md` and `docs/workflow/HANDOFF.md` as a synchronized workflow-state pair.
10. Strengthen as-built synchronization beyond shallow topic checks.
11. Expand CLI dashboard lesson and development views to match developer-memory requirements.
12. Complete illustration request metadata, generated-asset registration, and review-page display.
13. Add an external-integration CLI path with `status`, `start`, and `gate`.
14. Require Playwright checks for lesson-repository dashboard and illustration-review quality after dependencies are installed.
15. Wire strengthened checks, product-gate tests, Playwright checks, and aggregate tests into CI and pre-commit without removing existing checks.
16. Add Free Development and Team Development gate failure-path tests.

## Current Synchronization Task

- Synchronize the remediation plan into the three design/as-built documents:
  - `docs/as-built/REQUIREMENTS.md`
  - `docs/as-built/SPECIFICATION.md`
  - `docs/as-built/IMPLEMENTATION_PLAN.md`
- Synchronize the same plan into the two workflow-state documents:
  - `docs/workflow/TASK_TRACKER.md`
  - `docs/workflow/HANDOFF.md`
- Verify with xhigh sub-agent review and mechanical checks.
- Treat the synchronization as passing only when the plan content is present in all five documents.
- Preserve refactorability, ecosystem fit, reusable design, generality, and the no-existing-feature-tradeoff rule while implementing the backlog.

## Verification Status

Required lesson-side verification target:

```text
Lesson repository test passed.
```

Real product operations testing remains available through `tools/test_production_operations.sh` when an external product repository is intentionally recreated.

## Remaining Work

- Run final lesson-repository tests after synchronization edits.
- Use xhigh sub-agent review to inspect consistency across the five planning/workflow documents.
- Implement the open remediation backlog without existing-feature tradeoffs.
- Translate remaining learner-facing Markdown files to English using the audit output from `tools/list_non_english_docs.sh`.
