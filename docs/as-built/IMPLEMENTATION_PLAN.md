# IMPLEMENTATION_PLAN.md

## Implemented Plan

1. Record developer feedback in `docs/memory/DEVELOPER_MEMORY.md`.
2. Add documentation and protocol updates for 14-day lesson facilitation.
3. Add mechanical approval enforcement for `tools/lesson14`.
4. Add learning-mode recording and switching for 7-day and 14-day lessons.
5. Add learner-selected start position support for 7-day and 14-day flows.
6. Add a reset path for 14-day runtime state.
7. Add `tools/check_developer_memory_requirements.sh`.
8. Add `tools/test_lesson_start_position.sh`.
9. Add `tools/test_production_operations.sh` for explicit real product operations testing.
10. Keep `task-tracker-repository` deleted unless a product operations test is explicitly requested.
11. Add Free Development Mode.
12. Add Team Development and Docker advanced module.
13. Add `advanced/DOCKER_PATHS.md` for Docker-installed and no-Docker learning paths.
14. Add dialogue and sub-agent orchestration as core lesson content.
15. Harden CI status checks with GitHub API retry and REST fallback.
16. Add `tools/check_as_built_docs.sh`.
17. Add `reviews/SUBAGENT_REVIEW_PROTOCOL.md` and `tools/check_review_protocol.sh`.
18. Add `tools/list_non_english_docs.sh` for translation audit support.
19. Add `tools/test_lesson_repository.sh` as the lesson-side aggregate test.
20. Add learner-facing menu, dashboard, and illustration review entry points.
21. Synchronize as-built lesson documentation in:
    - `docs/as-built/REQUIREMENTS.md`
    - `docs/as-built/SPECIFICATION.md`
    - `docs/as-built/IMPLEMENTATION_PLAN.md`
    - `docs/workflow/TASK_TRACKER.md`
    - `docs/workflow/HANDOFF.md`
22. Add workflow display language and product development language settings for 7-day and 14-day lessons.
23. Expand supported standard language choices to `ja`, `en`, `ko`, `zh-CN`, `zh-TW`, `es`, `pt-BR`, `fr`, `de`, `id`, `vi`, `th`, `hi`, and `ar`, while preserving `zh` as a `zh-CN` alias and keeping `custom` values available.
24. Add `tools/test_lesson.sh` for 7-day setup gating and setting regression coverage.
25. Preserve existing behavior while keeping additions refactorable, reusable, ecosystem-friendly, and general.
26. Implement menu prerequisite control for menu items 1 through 6.
27. Rename learner-facing menu item 3 to `3. 応用レッスン`.
28. Add `tools/product-improvement status|start|gate`.
29. Add dashboard readiness output for menu items 1 through 6.
30. Add `tools/test_menu_prerequisites.sh` and wire it into aggregate tests, CI, and pre-commit.

## Implemented Remediation Plan

This plan implements the developer-memory audit.
It is additive and must not trade away existing 7-day lessons, 14-step lessons, free-development flow, advanced modules, existing checks, or repository-boundary behavior.

1. Add shared document-path support.
   - Add a reusable document path layer for design/as-built documents, workflow-state documents, and memory/decision documents.
   - Update tools to consume the shared path layer instead of hard-coding root-level paths.

2. Safely migrate role-specific Markdown documents.
   - Keep `AGENTS.MD` at the repository root.
   - Move design/as-built documents into a design/as-built directory.
   - Move workflow-state documents into a workflow/progress directory.
   - Move developer memory and related memory documents into a memory/decision directory.
   - Update references in README, AGENTS, guides, prompts, skills, dashboard, checks, CI, and tests.
   - Remove final root-level role-specific copies only after references and checks are updated.

3. Replace learner-facing `Day` labels with `Step` labels.
   - Update learner-facing guides, roadmap, prompts, runtime output, dashboard text, and reusable guidance.
   - Keep internal IDs and state-file values stable where technically necessary.
   - Add checks that prevent old learner-facing `Day N` labels from returning.

4. Hide internal IDs in learner-facing output.
   - Add or reuse display-label mapping for internal step IDs.
   - Show internal IDs only in copy-paste command blocks, debug output, raw state files, or developer diagnostics.
   - Validate dashboard/status output against this rule.

5. Implement language settings.
   - Add workflow display language state for 7-day and 14-day lessons.
   - Add product development language state for 7-day and 14-day lessons.
   - Add CLI commands and status output for both settings in `tools/lesson` and `tools/lesson14`.
   - Add a shared supported-language list and language normalizer in `tools/lib/lesson_common.sh`.
   - Show both settings in dashboard output where relevant.
   - Add tests for selection, switching, and required prompts before product development.

6. Enforce learning-mode display names.
   - Preserve A/B/C internal IDs.
   - Display `じっくり説明`, `ほどよく説明`, and `手順だけ` in learner-facing output.
   - Update guides, prompts, dashboard, and tests.

7. Strengthen approval gates.
   - Require start approval before start.
   - Require pass approval before pass.
   - Validate approval/action ordering and pairing.
   - Add negative tests for missing or mismatched approvals.

8. Improve passage prompts and command-block explanations.
   - Ensure pass/start prompts invite questions.
   - Add short explanations before copy-paste command blocks.
   - Add checks for reusable guidance text.

9. Enforce paired `docs/workflow/TASK_TRACKER.md` and `docs/workflow/HANDOFF.md` synchronization.
   - Add a workflow-pair synchronization checker.
   - Validate compatible current state, next action, and restart context.
   - Detect one-sided workflow-state updates without an explicit reason.
   - Surface pair status in dashboard output.

10. Strengthen as-built synchronization.
    - Update checks so the five as-built documents agree on current status, completed work, remaining work, test evidence, and known gaps.
    - Keep topic checks only as a supporting signal, not the primary pass condition.

11. Expand the CLI dashboard.
    - Lesson view shows current step, progress, 7-day and 14-day learning-mode labels, workflow display language, product development language where relevant, helpdesk/question records, developer-memory open items, next approval, sync-gate status, and illustration availability.
    - Development view shows product repository, current objective, workflow document status, paired tracker/handoff synchronization, developer-memory items, Git status, real CI status when available, and next recommended action.
    - Keep dashboard data reusable for a future browser dashboard.

12. Complete illustration request and review support.
    - Expand illustration metadata with learning mode, display language, source explanation, summary, key terms, and generation timestamp.
    - Add a command path to mark requested illustrations as available after generated PNG assets are provided.
    - Avoid non-ASCII topic path collisions.
    - Update the review page to read records and display ordered review material with explanatory text.

13. Add an external-integration CLI path.
    - Add `status`, `start`, and `gate` actions.
    - Support both post-Free-Development progression and direct use with an existing product repository.
    - Check product scope documents (`REQUIREMENTS.md`, `SPECIFICATION.md`, and `IMPLEMENTATION_PLAN.md`), product boundary, paired workflow documents, Git sync, and CI where applicable.

14. Introduce lesson-repository Playwright checks.
    - Add Playwright setup for dashboard and illustration-review pages.
    - Keep CLI checks and documentation checks active.
    - Require browser checks after `npm install` in CI, pre-commit, and aggregate tests.

15. Wire strengthened checks into CI and pre-commit.
    - Add new checks to the aggregate lesson repository test.
    - Add critical checks, product-gate tests, Playwright checks, and aggregate tests to pre-commit.
    - Add aggregate validation to CI without removing existing CI jobs.

16. Expand Free Development and Team Development gate tests.
    - Add missing-product-repository tests.
    - Add dirty-Git-state tests.
    - Add CI-failure tests.
    - Add Docker installed/not-installed path tests.
    - Add status/start output tests.

## Implemented Menu Prerequisite Implementation

This additive implementation is synchronized across `docs/as-built/REQUIREMENTS.md`, `docs/as-built/SPECIFICATION.md`, `docs/as-built/IMPLEMENTATION_PLAN.md`, `docs/workflow/TASK_TRACKER.md`, and `docs/workflow/HANDOFF.md`.
It preserves existing features without tradeoffs and follows the repository quality constraints for refactorability, ecosystem fit, reusability, and generality.

1. Rename the learner-facing menu item.
   - Change `3. 発展・応用レッスン` to `3. 応用レッスン`.
   - Keep the existing Team Development and Docker entry available through the renamed applied-learning item.
   - Add a check that prevents the old learner-facing label from returning.

2. Define one prerequisite model for menu items 1 through 6.
   - Require learning mode.
   - Require workflow display language.
   - Require product development language.
   - Require repository context and boundary confirmation where the item touches a product repository.
   - Require learner approval before start.

3. Reuse existing structured-lesson settings.
   - Keep 7-day settings stored in the current 7-day state files.
   - Keep 14-day settings stored in the current 14-day state files.
   - Preserve the expanded standard language list, `zh` compatibility alias, and `custom` flexibility.

4. Add a shared settings and prerequisite layer.
   - Add shared reusable helper functions in `tools/lib/lesson_common.sh`.
   - Provide a shared settings view for applied-learning, Free Development Mode, product improvement, and external integration.
   - Inherit the latest configured 7-day or 14-day settings when available.
   - Fail start/gate/check commands with learner-friendly guidance when required settings are missing.

5. Preserve discoverability.
   - Keep `status` commands non-blocking so learners can inspect menu items before configuring everything.
   - Enforce prerequisites in start, gate, or explicit menu-check commands.

6. Add or formalize product improvement control.
   - Add `tools/product-improvement status|start|gate`, or an equivalent reusable product-improvement gate.
   - Treat product improvement as the bridge between Free Development Mode and external integration.
   - Require product development language for product-facing edits.

7. Expand dashboard readiness.
   - Show readiness for menu items 1 through 6.
   - Include learning mode, workflow display language, product development language, repository context, approval status, and next recommended action.
   - Preserve existing lesson, development, developer-memory, and illustration dashboard information.

8. Synchronize documentation and checks.
   - Update the five planning/workflow documents.
   - Update developer memory, README/menu guidance, AGENTS routing, and related checks.
   - Keep unrelated existing content unchanged.

9. Verify with tests.
   - Run existing lesson and repository checks.
   - Add targeted tests for the renamed menu label and missing-prerequisite failure paths.
   - Confirm existing 7-day and 14-day flows still pass.
   - Confirm Free Development Mode, Team Development, external integration, dashboard, and product gates remain available.

## Implemented Documentation Map Implementation Plan

This additive implementation is complete and synchronized across `docs/as-built/REQUIREMENTS.md`, `docs/as-built/SPECIFICATION.md`, `docs/as-built/IMPLEMENTATION_PLAN.md`, `docs/workflow/TASK_TRACKER.md`, and `docs/workflow/HANDOFF.md`.
It preserves existing features without tradeoffs and follows the repository quality constraints for refactorability, ecosystem fit, reusability, and generality.

1. Add a learner-facing documentation map guide.
   - Created `guides/DOCUMENT_MAP.md`.
   - Explained rules/routing, design/as-built, workflow state, memory/decisions, and skills as separate categories.
   - Used non-engineer-friendly explanations while keeping repository source text in English.

2. Explain the agent rule and routing layer.
   - Explained `AGENTS.MD` as the lesson-side rulebook for agents.
   - Covered invariant rules, document root, routing table, and repo-local skills.
   - Explicitly distinguished `AGENTS.MD` from product-side `AGENT.md`.

3. Explain design, workflow, and memory documents.
   - Explained `docs/as-built/REQUIREMENTS.md`, `docs/as-built/SPECIFICATION.md`, and `docs/as-built/IMPLEMENTATION_PLAN.md`.
   - Explained `docs/workflow/TASK_TRACKER.md` and `docs/workflow/HANDOFF.md` as a synchronized pair.
   - Explained `docs/memory/DEVELOPER_MEMORY.md`.
   - Explained product-side `FAILURE_MEMORY.md` and failure-recovery records without implying a lesson-side `docs/memory/FAILURE_MEMORY.md` exists.

4. Add a CLI tour command.
   - Added `tools/docs-tour`.
   - Support `status`, `rules`, `design`, `workflow`, `memory`, `skills`, and `all`.
   - Adapt explanation depth to learning modes A/B/C.

5. Add a dashboard docs view.
   - Added `./tools/dashboard docs`.
   - Included the docs view in `./tools/dashboard all`.
   - Show categories, key files, current workflow relevance, workflow-pair sync, as-built sync, and next recommended document action.

6. Add copy-paste prompt examples.
   - Added document-understanding prompts to the prompt files.
   - Included prompts for explaining `TASK_TRACKER`/`HANDOFF` and the as-built trio in learner-friendly language.

7. Add early lesson guidance.
   - Added non-disruptive guidance to 7-day and 14-day lesson materials so learners encounter the document map before document-heavy work.
   - Preserve ordered lesson progression and approval gates.

8. Add mechanical validation.
   - Added `tools/test_docs_tour.sh`.
   - Updated structure checks, as-built checks, developer-memory checks, dashboard tests, aggregate tests, CI, and pre-commit as needed.
   - Ensure checks fail if `guides/DOCUMENT_MAP.md`, `tools/docs-tour`, `dashboard docs`, prompt examples, or the synchronized planning/workflow entries are missing.
   - `guides/DOCUMENT_MAP.md`, `tools/docs-tour`, `tools/test_docs_tour.sh`, and `./tools/dashboard docs` are now expected to exist in runtime.
   - Validation is wired through `tools/test_docs_tour.sh`, structure checks, as-built checks, developer-memory checks, dashboard or Playwright tests, aggregate tests, CI, and pre-commit.
   - The validation suite must preserve existing 7-day, 14-day, menu, dashboard, Free Development, Product Improvement, external-integration, product-gate, Playwright, CI, and pre-commit behavior.

9. Verify with existing and new tests.
   - Run the existing lesson-side verification sequence.
   - Run the new docs-tour test.
   - Confirm existing 7-day, 14-day, menu, dashboard, free-development, product-improvement, external-integration, product-gate, Playwright, CI, and pre-commit behavior remains available.

## Planned Product Repository Cleanup Implementation Plan

This is the next additive implementation plan.
It must be completed only after the plan is synchronized across `docs/as-built/REQUIREMENTS.md`, `docs/as-built/SPECIFICATION.md`, `docs/as-built/IMPLEMENTATION_PLAN.md`, `docs/workflow/TASK_TRACKER.md`, and `docs/workflow/HANDOFF.md`.
It must preserve existing features without tradeoffs and must follow the repository quality constraints for refactorability, ecosystem fit, reusability, and generality.

1. Add a dedicated cleanup command.
   - Add `tools/product-repository-cleanup`.
   - Support `status`, `plan`, `local`, and `remote` subcommands.
   - Keep the command focused on the external product repository configured by the lesson settings.

2. Implement non-destructive status and plan views.
   - `status` prints the configured product repository path, local existence, Git status, repository-name match, nested-repository safety, remote URL, and remote existence when safely checkable.
   - `plan` prints the local and remote cleanup procedure without deleting anything.
   - Both commands remain safe to run without confirmation.

3. Implement local cleanup safety gates.
   - Require a command shape such as `tools/product-repository-cleanup local --confirm task-tracker-repository`.
   - Reject deletion when confirmation is missing or does not match the configured product repository name.
   - Reject deletion when the target path is inside the lesson repository.
   - Reject deletion when the target path does not equal the configured external product repository path.
   - Reject deletion when the target is not a Git repository or cannot be identified safely.
   - Print a clear operation log before and after local deletion.

4. Implement remote cleanup safety gates.
   - Require a command shape such as `tools/product-repository-cleanup remote --confirm xxxMasahiro/task-tracker-repository`.
   - Require GitHub authentication and a successful remote repository lookup before any deletion attempt.
   - Show the owner/repository name and remote URL immediately before deletion.
   - Reject deletion when the confirmation text does not exactly match the full owner/repository name.
   - Print a clear operation log before and after remote deletion.

5. Keep destructive operations separated.
   - Do not add an `all` command.
   - Do not chain local and remote deletion automatically.
   - Do not infer deletion targets from loose user text.

6. Add mechanical validation.
   - Add `tools/test_product_repository_cleanup.sh`.
   - Test status and plan behavior.
   - Test missing-confirmation and wrong-confirmation failures.
   - Test nested repository rejection.
   - Test non-Git target rejection.
   - Test local cleanup using temporary repositories only.
   - Test remote paths with non-destructive or mocked failure behavior, never by deleting a real GitHub repository.
   - At this planning-synchronization stage, `tools/product-repository-cleanup` and `tools/test_product_repository_cleanup.sh` are planned artifacts and are not yet expected to exist in runtime.

7. Wire validation into existing checks.
   - Update structure checks.
   - Update as-built checks.
   - Update developer-memory checks when implementation is complete.
   - Add the new test to aggregate tests, CI, and pre-commit.
   - Preserve existing 7-day, 14-day, menu, dashboard, Free Development, Product Improvement, external-integration, product-gate, Playwright, docs-tour, CI, and pre-commit behavior.

8. Synchronize related guidance after implementation.
   - Update the five planning/workflow documents from planned to implemented state.
   - Update `AGENTS.MD`, README/menu/dashboard guidance, and developer memory only where the cleanup command becomes part of runtime behavior.
   - Keep unrelated existing content unchanged.

9. Verify local, remote, and CI consistency.
   - Run the new cleanup test.
   - Run the existing lesson-side verification sequence.
   - Run pre-commit.
   - Commit and push only after all local checks pass.
   - Confirm `CI` and `Lesson14 CI` succeed for the pushed commit.
   - Confirm local HEAD, `origin/main`, and the CI target SHA match.

## Verification Plan

Run:

```bash
./tools/check_lesson_structure.sh
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/check_as_built_docs.sh
./tools/check_review_protocol.sh
./tools/check_developer_memory_requirements.sh
./tools/menu
./tools/dashboard all
./tools/illustrations list
./tools/test_menu_prerequisites.sh
./tools/test_lesson_start_position.sh
./tools/test_lesson.sh
./tools/test_lesson14.sh
./tools/test_product_gate_tools.sh
./tools/test_lesson_repository.sh
```

Run `./tools/test_production_operations.sh` only when an external product repository is intentionally present.

The verification sequence also includes document-organization, workflow-pair synchronization, strengthened as-built synchronization, external-integration, Playwright, CI/pre-commit, and failure-path tests introduced by this plan.

Latest local verification for the 7-day parity change passed:

```text
7-day lesson CLI tests passed.
Lesson14 CLI tests passed.
Lesson repository test passed.
```

The same verification covers the expanded language list and confirms `zh` is normalized to `zh-CN`.

## Acceptance Criteria

- Existing 7-day and 14-day flows still pass structure checks.
- Free Development Mode and Team Development/Docker are additive.
- Implementation preserves refactorability, ecosystem fit, reusability, and generality.
- No existing feature is traded away.
- Lesson-side tests pass without recreating `task-tracker-repository`.
- Product repository boundary, Git sync, and CI checks remain available for explicit real product operations testing.
- All as-built documents describe the same implemented state.
- Lesson repository test prints `Lesson repository test passed.`
- Every developer-memory audit item is implemented, synchronized into the five planning/workflow documents, and backed by a mechanical check.
