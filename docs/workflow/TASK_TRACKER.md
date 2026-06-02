# TASK_TRACKER.md

## Current Status

The lesson repository includes mechanical enforcement, flexible lesson entry, Free Development Mode, Team Development and Docker advanced module, dialogue-centered learning, as-built synchronization checks, sub-agent review protocol, menu/dashboard/illustration entry points, 7-day and 14-day lesson language controls, and lesson-side aggregate testing.

The latest implemented change adds menu prerequisite control for menu items 1 through 6.
It also preserves the 7-day and 14-day learning-mode, workflow display language, product development language, and expanded language-list controls.
The shared standard language list remains `ja`, `en`, `ko`, `zh-CN`, `zh-TW`, `es`, `pt-BR`, `fr`, `de`, `id`, `vi`, `th`, `hi`, and `ar`, while `zh` remains a `zh-CN` alias and `custom` remains available.
The implementation remains additive and keeps the existing 7-day lesson, 14-day lesson, free-development flow, advanced modules, existing checks, and repository-boundary behavior intact.

## Completed

- Recorded developer feedback in `docs/memory/DEVELOPER_MEMORY.md`.
- Added 14-day approval receipts and enforcement.
- Added learning mode A/B/C selection and switching for 7-day and 14-day lessons.
- Added workflow display language and product development language controls for 7-day and 14-day lessons.
- Added shared standard language choices for 7-day and 14-day language settings.
- Added setup.index gates so both structured lessons require learning mode, workflow display language, and product development language before passing the entry step.
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
- Added `tools/test_lesson.sh` for 7-day setup gating and settings regression coverage.
- Added a non-English Markdown listing tool for translation follow-up.
- Added learner-facing menu, dashboard, and illustration review entry points.
- Renamed menu item 3 to `3. 応用レッスン`.
- Added shared menu prerequisite helpers for learning mode, workflow display language, product development language, start approval, and menu readiness.
- Added `tools/menu check <1|2|3|4|5|6>` and `tools/menu start <1|2|3|4|5|6> --confirm`.
- Added `tools/product-improvement status|start|gate`.
- Added dashboard readiness output for menu items 1 through 6.
- Added menu prerequisite tests and wired them into aggregate tests, CI, and pre-commit.
- Documented implementation quality constraints: refactorability, ecosystem fit, reusability, and generality.
- Preserved the no-tradeoff rule for existing features.
- Added as-built lesson-side documents:
  - `docs/as-built/REQUIREMENTS.md`
  - `docs/as-built/SPECIFICATION.md`
  - `docs/as-built/IMPLEMENTATION_PLAN.md`
  - `docs/workflow/TASK_TRACKER.md`
  - `docs/workflow/HANDOFF.md`

## Implemented Remediation Summary

The following developer-memory remediation items are implemented and mechanically verified:

1. Add shared document-path support for design/as-built, workflow-state, and memory/decision documents.
2. Safely migrate role-specific Markdown documents into directories while keeping `AGENTS.MD` at root.
3. Replace learner-facing `Day N` labels with `Step N` labels where practical.
4. Hide internal step IDs from ordinary learner-facing output.
5. Implement separate workflow display language and product development language settings for both structured lessons.
6. Enforce learner-facing learning-mode display names while preserving A/B/C internal IDs.
7. Strengthen start/pass approval gates and approval/action pairing checks.
8. Improve passage prompts and copy-paste command-block explanations.
9. Enforce `docs/workflow/TASK_TRACKER.md` and `docs/workflow/HANDOFF.md` as a synchronized workflow-state pair.
10. Strengthen as-built synchronization beyond shallow topic checks.
11. Expand CLI dashboard lesson and development views to match developer-memory requirements, including separate 7-day and 14-day language settings.
12. Complete illustration request metadata, generated-asset registration, and review-page display.
13. Add an external-integration CLI path with `status`, `start`, and `gate`.
14. Require Playwright checks for lesson-repository dashboard and illustration-review quality after dependencies are installed.
15. Wire strengthened checks, product-gate tests, Playwright checks, and aggregate tests into CI and pre-commit without removing existing checks.
16. Add Free Development and Team Development gate failure-path tests.

## Current Synchronized State

- The implemented menu prerequisite control is synchronized into the three design/as-built documents:
  - `docs/as-built/REQUIREMENTS.md`
  - `docs/as-built/SPECIFICATION.md`
  - `docs/as-built/IMPLEMENTATION_PLAN.md`
- The same implemented state is synchronized into the two workflow-state documents:
  - `docs/workflow/TASK_TRACKER.md`
  - `docs/workflow/HANDOFF.md`
- The synchronization passes only when the implemented content is present in all five documents.
- Preserve refactorability, ecosystem fit, reusable design, generality, and the no-existing-feature-tradeoff rule while maintaining the implemented remediation.

## Implemented Documentation Map Synchronization

The lesson now explains the repository's rule, routing, skill, design, workflow, and memory documents in a way that non-engineer learners can understand.
Runtime implementation has started and the docs map artifacts are present.

- Added `guides/DOCUMENT_MAP.md`.
- Explain `AGENTS.MD` invariant rules, document root, routing table, and repo-local skills as the agent-facing rule and navigation layer.
- Distinguish lesson-side `AGENTS.MD` from product-side `AGENT.md`.
- Explain `docs/as-built/` as the requirements, specification, and implementation-plan area.
- Explain `docs/workflow/` as the task-tracker and handoff area.
- Explain `docs/memory/` as memory and decision records, including `docs/memory/DEVELOPER_MEMORY.md`.
- Explain product-side `FAILURE_MEMORY.md` or failure-recovery records without claiming a lesson-side failure-memory file exists.
- Added `tools/docs-tour` with `status`, `rules`, `design`, `workflow`, `memory`, `skills`, and `all` views.
- Made `tools/docs-tour` adapt to learning modes A/B/C.
- Added `./tools/dashboard docs` and included that view in `./tools/dashboard all`.
- Added copy-paste prompt examples for asking an agent to explain `TASK_TRACKER`/`HANDOFF` and the as-built trio in learner-friendly language.
- Added early 7-day and 14-day guidance so learners understand why the documents exist before they use them deeply.
- Added `tools/test_docs_tour.sh` and wired it into structure/as-built/developer-memory checks, aggregate tests, CI, and pre-commit.
- Preserve existing lesson progression, approvals, checks, menu behavior, dashboard behavior, skills, memory workflow, and repository-boundary behavior.
- `guides/DOCUMENT_MAP.md`, `tools/docs-tour`, `tools/test_docs_tour.sh`, and `./tools/dashboard docs` are runtime artifacts.
- Validation is wired through `tools/test_docs_tour.sh`, structure checks, as-built checks, developer-memory checks, dashboard or Playwright tests, aggregate tests, CI, and pre-commit.
- The validation suite must preserve existing 7-day, 14-day, menu, dashboard, Free Development, Product Improvement, external-integration, product-gate, Playwright, CI, and pre-commit behavior.

## Planned Product Repository Cleanup Synchronization

The next planned lesson improvement provides a safe, explicit cleanup path for the external product repository created by the 7-day or 14-day lessons.
This is a plan only; runtime implementation has not started.

- Add `tools/product-repository-cleanup`.
- Support `status`, `plan`, `local`, and `remote` subcommands.
- Keep `status` and `plan` non-destructive.
- Require explicit confirmation for local cleanup with the configured product repository name, such as `task-tracker-repository`.
- Require explicit confirmation for remote cleanup with the full GitHub owner/repository name, such as `xxxMasahiro/task-tracker-repository`.
- Keep local deletion and remote deletion separate; do not add `all` or automatic chained deletion.
- Reject local deletion unless the target is the configured external product repository path, normally `$HOME/projects/task-tracker-repository`.
- Reject local deletion when the target is inside the lesson repository, does not match the configured product repository name, is not a Git repository, or cannot be identified safely.
- Require GitHub authentication and a successful remote repository lookup before any remote deletion attempt.
- Show the remote URL and owner/repository name before any remote deletion.
- Print a clear operation log for status, plan, local cleanup, and remote cleanup paths.
- Add `tools/test_product_repository_cleanup.sh`.
- Test status, plan, missing confirmation, wrong confirmation, nested repository rejection, non-Git target rejection, temporary local cleanup behavior, and non-destructive remote failure paths.
- Do not delete a real GitHub repository in lesson-repository tests.
- Wire the cleanup test into structure checks, as-built checks, developer-memory checks, aggregate tests, CI, and pre-commit when implemented.
- Preserve existing lesson progression, approvals, checks, menu behavior, dashboard behavior, Free Development, Product Improvement, external-integration, product-gate, Playwright, docs-tour, CI, and pre-commit behavior.
- At this planning-synchronization stage, `tools/product-repository-cleanup` and `tools/test_product_repository_cleanup.sh` are planned artifacts and are not yet expected to exist in runtime.
- Implementation completion will require validation wiring through `tools/test_product_repository_cleanup.sh`, structure checks, as-built checks, developer-memory checks, aggregate tests, CI, and pre-commit.

## Implemented Menu Prerequisite Control

Shared menu prerequisite control is implemented without replacing existing lesson or product workflows.

- Rename the learner-facing menu item to `3. 応用レッスン`.
- Keep the Team Development and Docker path available through the renamed applied-learning item.
- Require learning mode, workflow display language, product development language, repository context/boundary confirmation where relevant, and learner approval before starting menu items 1 through 6.
- Reuse existing 7-day and 14-day settings where available.
- For applied-learning, Free Development Mode, product improvement, and external integration, inherit the latest configured structured-lesson settings when possible; otherwise require missing settings before start or gate passage.
- Keep product development language mandatory for product-side work.
- Implement the prerequisite logic through shared reusable helpers rather than duplicated menu branches.
- Keep `status` commands non-blocking for discovery; enforce prerequisites through start, gate, or explicit menu-check commands.
- Add a mechanically checkable product-improvement entry point for menu item 5.
- Expand dashboard readiness output for menu items 1 through 6.
- Add tests for the renamed menu label, absence of the old learner-facing label, missing-prerequisite failure paths, unchanged existing 7-day/14-day behavior, and preservation of existing Free Development, Team Development, external-integration, dashboard, and product-gate checks.

## Verification Status

Required lesson-side verification target:

```text
7-day lesson CLI tests passed.
Lesson14 CLI tests passed.
Lesson repository test passed.
```

Latest local verification reached this target after synchronizing the 7-day parity implementation and the expanded language-list implementation.
The latest verification target now also includes `Menu prerequisite tests passed.`
Real product operations testing remains available through `tools/test_production_operations.sh` when an external product repository is intentionally recreated.

## Remaining Work

- Commit and push only after all local checks pass.
- Translate remaining learner-facing Markdown files to English using the audit output from `tools/list_non_english_docs.sh`.
