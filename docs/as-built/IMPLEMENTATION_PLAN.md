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
21. Add safe product repository cleanup for the external product repository created by the structured lessons.
22. Add the as-built sync contract, validator, status command, and regression tests for the three design/as-built documents plus `TASK_TRACKER.md` and `HANDOFF.md`.
23. Synchronize as-built lesson documentation in:
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
31. Add `tools/product-repository-cleanup` for safe external product repository cleanup.
32. Add `tools/test_product_repository_cleanup.sh` and wire it into structure checks, as-built checks, developer-memory checks, aggregate tests, CI, and pre-commit.
33. Add Git workflow policy settings, `tools/git-workflow`, and `tools/test_git_workflow_policy.sh` for configurable branch, worktree, automation, monitoring, and cleanup-plan behavior.

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
   - Inherit the most recently configured 7-day or 14-day settings when available.
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
   - Explained `docs/workflow/GIT_HOOKS_POLICY.tsv`, `docs/workflow/GIT_HOOK_CHECKS.tsv`, and `learning/GIT_HOOK_SETTINGS.tsv` as the Git hook policy and current local hook-mode controls.
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

## Implemented Product Repository Cleanup Implementation Plan

This additive implementation is complete and synchronized across `docs/as-built/REQUIREMENTS.md`, `docs/as-built/SPECIFICATION.md`, `docs/as-built/IMPLEMENTATION_PLAN.md`, `docs/workflow/TASK_TRACKER.md`, and `docs/workflow/HANDOFF.md`.
It preserves existing features without tradeoffs and follows the repository quality constraints for refactorability, ecosystem fit, reusability, and generality.

1. Add a dedicated cleanup command.
   - Added `tools/product-repository-cleanup`.
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
   - Reject deletion when the target path is not the configured external product repository path.
   - Reject deletion when the target is not a Git repository, lacks `.git`, is not the Git top level, or cannot be identified safely.
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
   - Added `tools/test_product_repository_cleanup.sh`.
   - Test status and plan behavior.
   - Test missing-confirmation and wrong-confirmation failures.
   - Test nested repository rejection.
   - Test non-Git target rejection.
   - Test local cleanup using temporary repositories only.
   - Test remote paths with fake `gh` behavior, never by deleting a real GitHub repository.
   - `tools/product-repository-cleanup` and `tools/test_product_repository_cleanup.sh` are required runtime artifacts.

7. Wire validation into existing checks.
   - Updated structure checks.
   - Updated as-built checks.
   - Updated developer-memory checks.
   - Added the new test to aggregate tests, CI, and pre-commit.
   - Preserved existing 7-day, 14-day, menu, dashboard, Free Development, Product Improvement, external-integration, product-gate, Playwright, docs-tour, CI, and pre-commit behavior.

8. Synchronize related guidance after implementation.
   - Updated the five planning/workflow documents from planned to implemented state.
   - Updated `AGENTS.MD`, README/menu guidance, and dashboard output only where the cleanup command is part of runtime behavior.
   - Kept unrelated existing content unchanged.

9. Verify local, remote, and CI consistency.
   - Run the new cleanup test.
   - Run the existing lesson-side verification sequence.
   - Run pre-commit.
   - Commit and push only after all local checks pass.
   - Confirm `CI` and `Lesson14 CI` succeed for the pushed commit.
   - Confirm local HEAD, `origin/main`, and the CI target SHA match.

## Implemented As-Built Sync Contract Implementation Plan

This additive implementation strengthens mechanical enforcement across the three design/as-built documents and the two workflow-state documents.
It preserves existing checks and does not trade away any current 7-day, 14-day, menu, dashboard, documentation-map, product-gate, product-repository cleanup, CI, pre-commit, or developer-memory behavior.

1. Add a synchronization contract file.
   - Added `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv`.
   - Record each synchronized improvement with `sync_id`, `status`, `title`, `required_artifacts`, `required_tests`, `required_docs`, and `runtime_evidence`.
   - Keep the format simple enough for shell-based checks and future dashboard reuse.

2. Add matching sync blocks to the five synchronized documents.
   - Added `SYNC-ID`, `STATUS`, `ARTIFACTS`, and `TESTS` blocks to `docs/as-built/REQUIREMENTS.md`.
   - Added the same blocks to `docs/as-built/SPECIFICATION.md`.
   - Added the same blocks to `docs/as-built/IMPLEMENTATION_PLAN.md`.
   - Added the same blocks to `docs/workflow/TASK_TRACKER.md`.
   - Added the same blocks to `docs/workflow/HANDOFF.md`.
   - Preserved existing headings and narrative content; added contract metadata without deleting unrelated content.

3. Add a dedicated contract validator.
   - Added `tools/check_as_built_sync_contract.sh`.
   - Validate that every contract `sync_id` exists in all five documents.
   - Validate that no synchronized document contains a `SYNC-ID` block missing from the contract.
   - Validate that all five documents use the same `STATUS` for each `sync_id`.
   - Validate that document `ARTIFACTS` and `TESTS` blocks exactly match the contract without extra or missing entries.
   - Validate that required artifacts and required tests exist in the repository.
   - Validate that runtime evidence files exist and reference the sync ID, one of its artifacts, or one of its tests.
   - Validate that implemented sync IDs have their required tests actively wired into aggregate tests, CI, and pre-commit.
   - Fail if a `planned` status and an `implemented` status are mixed for the same `sync_id`.

4. Preserve and extend existing checks.
   - Call the validator from `tools/check_as_built_docs.sh`.
   - Keep the current topic-based as-built checks as compatibility checks.
   - Keep `tools/check_workflow_pair_sync.sh` active for `TASK_TRACKER.md` and `HANDOFF.md`.
   - Do not replace existing checks with the new contract; make the contract an additional gate.

5. Add a status helper for learners and agents.
   - Added `tools/as-built-sync status`.
   - Show all sync IDs, current status, five-document coverage, artifact presence, and test-wiring status.
   - Keep output useful for both CLI learners and future dashboard reuse.

6. Add regression tests.
   - Added `tools/test_as_built_sync_contract.sh`.
   - Test a fully synchronized contract.
   - Test failure when one of the five documents lacks a sync block.
   - Test failure when a synchronized document contains an unknown sync ID.
   - Test failure when statuses are mixed across documents.
   - Test failure when a document contains extra artifacts or tests not listed in the contract.
   - Test failure when a required artifact is missing.
   - Test failure when an implemented required test is only mentioned as inert text or is not actively wired into aggregate tests, CI, or pre-commit.

7. Wire verification into existing gates after implementation.
   - Added the new test to `tools/test_lesson_repository.sh`.
   - Added the validator and test to `.githooks/pre-commit`.
   - Added shell syntax and regression steps to `.github/workflows/ci.yml`.
   - Added shell syntax and regression steps to `.github/workflows/lesson14-ci.yml`.
   - Added `AGENTS.MD` routing and standard-check references for the sync-contract status and validator.
   - Updated runtime checks only where they became enforcement.
   - Run targeted checks, aggregate tests, pre-commit, and GitHub Actions before declaring implementation complete.

## As-Built Sync Contract Records

```text
SYNC-ID: documentation_map
STATUS: implemented
ARTIFACTS: guides/DOCUMENT_MAP.md, tools/docs-tour, tools/test_docs_tour.sh
TESTS: tools/test_docs_tour.sh

SYNC-ID: menu_prerequisite_control
STATUS: implemented
ARTIFACTS: tools/menu, tools/test_menu_prerequisites.sh
TESTS: tools/test_menu_prerequisites.sh

SYNC-ID: product_repository_cleanup
STATUS: implemented
ARTIFACTS: tools/product-repository-cleanup, tools/test_product_repository_cleanup.sh
TESTS: tools/test_product_repository_cleanup.sh

SYNC-ID: as_built_sync_contract
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv, tools/check_as_built_sync_contract.sh, tools/as-built-sync, tools/test_as_built_sync_contract.sh
TESTS: tools/check_as_built_sync_contract.sh, tools/test_as_built_sync_contract.sh

SYNC-ID: git_workflow_policy
STATUS: implemented
ARTIFACTS: docs/workflow/GIT_WORKFLOW_POLICY.tsv, learning/GIT_WORKFLOW_SETTINGS.tsv, tools/lib/git_workflow_policy.sh, tools/git-workflow, tools/test_git_workflow_policy.sh
TESTS: tools/test_git_workflow_policy.sh

SYNC-ID: menu_git_workflow_policy
STATUS: implemented
ARTIFACTS: tools/menu, tools/dashboard, tools/git-workflow, tools/test_menu_prerequisites.sh
TESTS: tools/test_menu_prerequisites.sh

SYNC-ID: git_workflow_action_settings
STATUS: implemented
ARTIFACTS: docs/workflow/GIT_WORKFLOW_POLICY.tsv, learning/GIT_WORKFLOW_SETTINGS.tsv, learning/GIT_WORKFLOW_APPROVALS.tsv, tools/lib/git_workflow_policy.sh, tools/git-workflow, tools/menu, tools/dashboard, tools/test_git_workflow_policy.sh, tools/test_menu_prerequisites.sh
TESTS: tools/test_git_workflow_policy.sh, tools/test_menu_prerequisites.sh

SYNC-ID: git_hooks_policy
STATUS: implemented
ARTIFACTS: .githooks/pre-commit, docs/workflow/GIT_HOOKS_POLICY.tsv, docs/workflow/GIT_HOOK_CHECKS.tsv, docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv, learning/GIT_HOOK_SETTINGS.tsv, tools/lib/git_hooks_policy.sh, tools/git-hooks, tools/test_git_hooks.sh
TESTS: tools/test_git_hooks.sh

SYNC-ID: resource_budget_parallel_guard
STATUS: implemented
ARTIFACTS: docs/workflow/RESOURCE_POLICY.tsv, learning/RESOURCE_SETTINGS.tsv, tools/lib/resource_guard.sh, tools/resource-guard, tools/test_resource_guard.sh, tools/git-hooks, tools/test_lesson_playwright.sh, playwright.config.js, .github/workflows/ci.yml, .github/workflows/lesson14-ci.yml
TESTS: tools/test_resource_guard.sh

SYNC-ID: resource_guard_safe_cleanup
STATUS: implemented
ARTIFACTS: docs/workflow/RESOURCE_POLICY.tsv, learning/RESOURCE_SETTINGS.tsv, tools/lib/resource_guard.sh, tools/resource-guard, tools/test_resource_cleanup.sh, tools/test_lesson_repository.sh, docs/workflow/GIT_HOOK_CHECKS.tsv, .github/workflows/ci.yml, .github/workflows/lesson14-ci.yml
TESTS: tools/test_resource_cleanup.sh

SYNC-ID: resource_guard_summary_parallel_ci
STATUS: implemented
ARTIFACTS: docs/workflow/RESOURCE_POLICY.tsv, learning/RESOURCE_SETTINGS.tsv, tools/lib/resource_guard.sh, tools/resource-guard, docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv, tools/lib/git_hooks_policy.sh, tools/git-hooks, tools/test_resource_guard_summary.sh, tools/test_git_hooks_parallel.sh, tools/check_ci_workflow_structure.sh, .github/workflows/ci.yml, .github/workflows/lesson14-ci.yml, tools/test_lesson_repository.sh
TESTS: tools/test_resource_guard_summary.sh, tools/test_git_hooks_parallel.sh, tools/check_ci_workflow_structure.sh

SYNC-ID: learner_context_foundation
STATUS: planned
ARTIFACTS: learning/context/README.md,learning/context/AI_DRIVEN_DEVELOPMENT_FOUNDATION.md,learning/context/SECURITY_FOUNDATION.md,learning/context/LESSON_CONTEXT_MAP.tsv
TESTS: tools/test_lesson_repository.sh

SYNC-ID: learner_context_runtime_integration
STATUS: planned
ARTIFACTS: learning/context/README.md,learning/context/LESSON_CONTEXT_MAP.tsv
TESTS: tools/test_lesson_repository.sh

SYNC-ID: safeflow_security_backfill
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv,tools/lib/security_invariants.sh,tools/check_security_invariants.sh,tools/test_security_invariants.sh,docs/workflow/GIT_HOOK_CHECKS.tsv,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/test_lesson_repository.sh
TESTS: tools/check_security_invariants.sh,tools/test_security_invariants.sh

SYNC-ID: product_security_workflow_gate
STATUS: implemented
ARTIFACTS: docs/workflow/PRODUCT_SECURITY_POLICY.tsv,learning/context/WORKFLOW_CONTEXT_MAP.tsv,tools/lib/product_security.sh,tools/product-security,tools/test_product_security.sh,tools/free-development,tools/product-improvement,tools/external-integration,tools/menu,tools/dashboard,docs/workflow/GIT_HOOK_CHECKS.tsv,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/test_lesson_repository.sh
TESTS: tools/test_product_security.sh,tools/test_product_gate_tools.sh

SYNC-ID: test_ci_safe_time_optimization_plan
STATUS: implemented
ARTIFACTS: docs/workflow/TEST_PLAN_MANIFEST.tsv,tools/lib/test_plan.sh,tools/test-plan,tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/lib/fixture_copy.sh,tools/fixture-copy,tools/test_fixture_copy.sh,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,tools/git-hooks,tools/test_git_hooks_parallel.sh,tools/check_ci_workflow_structure.sh,tools/test_lesson_repository.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_fixture_copy.sh,tools/test_git_hooks_parallel.sh,tools/check_ci_workflow_structure.sh

SYNC-ID: test_ci_final_gate_optimization_plan
STATUS: implemented
ARTIFACTS: docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,docs/workflow/RESOURCE_POLICY.tsv,tools/lib/ci_evidence.sh,tools/lib/as_built_evidence.sh,tools/ci-evidence,tools/ci-final-gate,tools/git-hooks,tools/lib/git_hooks_policy.sh,tools/lib/resource_guard.sh,tools/check_as_built_sync_contract.sh,tools/as-built-sync,tools/docs-tour,tools/check_ci_workflow_structure.sh,tools/test_lesson_playwright.sh,tools/test_lesson_start_position.sh,tools/test_lesson14.sh,tools/test_lesson_repository.sh,tools/test_ci_evidence.sh,tools/test_ci_final_gate.sh,tools/test_resource_cleanup.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/test_ci_evidence.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/test_git_hooks_parallel.sh,tools/test_resource_cleanup.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/test_docs_tour.sh,tools/test_as_built_sync_contract.sh,tools/test_lesson_start_position.sh,tools/test_lesson14.sh

SYNC-ID: test_ci_full_pipeline_acceleration_plan
STATUS: implemented
ARTIFACTS: docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/git-hooks,tools/ci-final-gate,tools/ci-evidence,tools/ci-playwright-setup,tools/lib/ci_evidence.sh,tools/lib/as_built_evidence.sh,tools/lib/git_hooks_policy.sh,tools/lib/resource_guard.sh,tools/check_as_built_sync_contract.sh,tools/check_ci_workflow_structure.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_lesson_playwright.sh,tools/test_lesson_repository.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_as_built_docs.sh,tools/check_as_built_sync_contract.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh,tools/test_ci_pipeline_acceleration.sh

RECORD: dashboard_control_center_mock_exact_alignment_correction
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,free-development/FREE_DEVELOPMENT_MODE.md,templates/TEMPLATES.md,lesson/SYNC_GATES_14_DAYS.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/lib/product_repository_authority.sh,tools/free-development,tools/product-improvement,tools/external-integration,tools/product-scaffold-check,tools/product-launch-check,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
```

## Implemented Resource-Budgeted Parallel Guard Implementation Plan

This plan is synchronized from `docs/memory/DEVELOPER_MEMORY.md`.
The runtime implementation is complete.
It preserves existing Git hooks modes, CI checks, pre-commit behavior, 7-day and 14-day lesson behavior, dashboard behavior, docs routes, and repository-boundary checks.

### Implemented Change Targets

- `docs/workflow/RESOURCE_POLICY.tsv`
- `learning/RESOURCE_SETTINGS.tsv`
- `tools/lib/resource_guard.sh`
- `tools/resource-guard`
- `tools/test_resource_guard.sh`
- `tools/git-hooks`
- `tools/test_lesson_playwright.sh`
- `playwright.config.js`
- `tools/test_lesson_repository.sh`
- `.github/workflows/ci.yml`
- `.github/workflows/lesson14-ci.yml`

### Implemented Order

1. Added policy and settings sources.
   - Keep warning thresholds, allowed modes, profile names, and default behavior in policy/settings files.
   - Keep the available-memory floor in both policy defaults and user settings.
   - Do not encode one-off fixed values directly in command branches.

2. Added a shared resource guard library.
   - Read memory, swap, disk free space, and active heavy-process signals where practical.
   - Calculate the effective swap budget from user-selected storage percentage and GiB upper limit.
   - Keep logic profile-based so Git hooks, Playwright, aggregate checks, and future checks can reuse it.
   - Reject unknown heavy-work profiles instead of silently falling back to a different profile.

3. Added a resource-guard command surface.
   - Commands include `status`, `check --profile`, `recommend-jobs --profile`, and `monitor --profile`.
   - Output must be suitable for learner-facing summaries and agent automation.
   - `check --profile` and `recommend-jobs --profile` fail closed at safe-stop while preserving serial fallback for caution states.
   - `parallel` mode is explicit and fails closed when caution states prevent safe parallelism.

4. Connected Git hooks without changing existing mode semantics.
   - Keep `minimal` lightweight.
   - Keep `full` as the complete local hook verification path.
   - Let heavy local checks consult the resource guard before optional parallel execution.
   - Preserve serial fallback when resource checks fail or enter a caution/block state.
   - Keep CI able to run the full Git hooks regression without inheriting local WSL resource settings.

5. Connected Playwright and aggregate checks conservatively.
   - Treat Playwright as heavy work.
   - Prefer one local worker unless resource checks explicitly allow more.
   - Do not allow uncontrolled overlap between Playwright, full hooks, and aggregate repository tests.
   - Route CI dashboard browser checks through the same Playwright wrapper used locally, and do not hide safe-stop failures.

6. Connected CI separately from local WSL resource policy.
   - Preserve all required CI checks.
   - Consider safe job separation and duplicate-run cancellation.
   - Do not treat CI runner resources as equivalent to local WSL resource settings.

7. Added standalone and aggregate tests.
   - Added `tools/test_resource_guard.sh`.
   - Wired it into `tools/test_lesson_repository.sh`.
   - Added calculation, threshold, active-heavy-process fallback, safe-stop failure code, invalid-setting, serial-mode, parallel-mode, and profile rejection tests.

8. Updated synchronized documentation after implementation.
   - Moved `resource_budget_parallel_guard` from `planned` to `implemented`.
   - Replaced the planned artifact/test list with implemented runtime files and active tests.
   - Kept all five synchronized documents and the sync contract aligned.

### Verification Commands

Run:

```bash
./tools/resource-guard status
./tools/resource-guard check --profile git-hooks-full
./tools/resource-guard recommend-jobs --profile playwright
./tools/test_resource_guard.sh
./tools/test_git_hooks.sh
./tools/git-hooks run --mode minimal
./tools/git-hooks run --mode full --no-cache
.githooks/pre-commit
./tools/test_lesson_repository.sh
./tools/as-built-sync status
./tools/check_as_built_sync_contract.sh
```

### Planned Recovery And Approval Rules

- If settings parsing fails, fix the TSV structure and add regression coverage.
- If thresholds are too strict or too loose, adjust policy data instead of adding hard-coded command branches.
- If Playwright becomes unstable, reduce worker count through resource recommendations and keep serial fallback.
- If CI diverges from local behavior, keep CI full and separate local resource policy from CI workflow structure.
- Developer approval is required before `.wslconfig` writes, swap creation/deletion, privileged cleanup, process killing, changing Git hooks mode semantics, weakening CI, weakening pre-commit, or introducing Docker/cgroups/systemd memory enforcement.

## Planned Learner Context Foundation Plan

This plan prepares the learner-facing context foundation only.
It does not implement runtime lesson rendering yet.
The next implementation plan should connect these files to lesson output, dashboards, prompts, and checks.

1. Add context source documents under `learning/context/`.
   - Add a directory README that explains the role of learner context and its synchronization boundary.
   - Add the main AI-driven development foundation text.
   - Add a staged security foundation.
   - Add a machine-readable context-to-lesson map.

2. Preserve source-language and display-language separation.
   - Keep repository source documents in English.
   - Let future runtime output translate or summarize according to the selected workflow display language.
   - Do not hard-code Japanese-only lesson text into runtime behavior from this documentation step.

3. Keep context separate from runtime implementation.
   - Do not modify lesson state machines in this step.
   - Do not change `tools/lesson`, `tools/lesson14`, dashboard behavior, or browser dashboard behavior in this step.
   - Mark the sync ID as `planned` until runtime integration and targeted checks are implemented.

4. Prepare future implementation connections.
   - Use `LESSON_CONTEXT_MAP.tsv` as the future bridge from context topics to lesson openings, per-topic explanations, final recaps, security coverage, prompt examples, and dashboard candidates.
   - Use the main foundation and security foundation as the source for learner-mode-specific rendering.
   - Add future tests only when runtime integration is implemented.

5. Synchronize document discovery.
   - Update `guides/DOCUMENT_MAP.md` so learners and agents can find `learning/context/`.
   - Synchronize the planned context foundation through the as-built sync contract and the five synchronized documents.

## Planned Learner Context Runtime Integration Plan

This plan connects the existing learner-context foundation to runtime guidance.
It is not implemented yet.
The implementation must keep Free Development Mode as a workflow, not as a lesson.

### Planned Change Targets

- `learning/context/LESSON_CONTEXT_MAP.tsv`
- planned new `learning/context/WORKFLOW_CONTEXT_MAP.tsv`
- planned new `tools/lib/lesson_context.sh`
- planned new `tools/lesson-context`
- `tools/lesson`
- `tools/lesson14`
- `tools/team-development`
- `tools/free-development`
- `tools/product-improvement`
- `tools/external-integration`
- `tools/menu`
- `tools/dashboard`
- `guides/DOCUMENT_MAP.md`
- `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv`
- the three design/as-built documents and the two workflow-state documents

### Planned Implementation Order

1. Refine the learning context map.
   - Keep `LESSON_CONTEXT_MAP.tsv` focused on learning contexts: 7-day lesson, 14-day lesson, and applied lesson.
   - Map opening context, per-step context, recap context, prompt examples, security markers, and dashboard candidates without relying on one hard-coded phrase.

2. Add a workflow context map.
   - Add `WORKFLOW_CONTEXT_MAP.tsv` for Free Development Mode, Product Improvement, External Integration, and lesson repository maintenance.
   - Keep workflow targets separate from lesson targets.
   - Make Free Development Mode a product-development workflow that applies the learned process.

3. Add a shared context library.
   - Add `tools/lib/lesson_context.sh`.
   - Reuse `tools/lib/lesson_common.sh` for learning mode, workflow display language, product development language, and common path handling.
   - Load maps generically so future topics can be added without one-off shell branches.

4. Add a standalone context CLI.
   - Add `tools/lesson-context status`.
   - Add `tools/lesson-context opening lesson-7|lesson-14|applied`.
   - Add `tools/lesson-context step lesson-7|lesson-14 <step_id>`.
   - Add `tools/lesson-context recap lesson-7|lesson-14|applied`.
   - Add `tools/lesson-context workflow free-development|product-improvement|external-integration|lesson-maintenance`.

5. Connect structured and applied learning.
   - Integrate context display into `tools/lesson`, `tools/lesson14`, and `tools/team-development`.
   - Preserve approval gates, ordered progression, learner-selected start positions, and current lesson state files.

6. Connect product-facing workflows.
   - Integrate workflow context into `tools/free-development`, `tools/product-improvement`, and `tools/external-integration`.
   - Show purpose, required documents, safety checks, and copy-paste prompts before product-facing work starts.
   - Preserve product repository boundary checks and Git workflow settings.

7. Connect menu and dashboard views.
   - Keep menu categories distinct: learning, building/extending, and lesson maintenance.
   - Show learning context and workflow context separately in dashboard output.

8. Add validation.
   - Add `tools/test_lesson_context.sh`.
   - Wire the new test into `tools/test_lesson_repository.sh`, `.githooks/pre-commit`, `.github/workflows/ci.yml`, and `.github/workflows/lesson14-ci.yml`.
   - Keep the test runnable standalone and through aggregate checks.

9. Synchronize from planned to implemented only after runtime integration passes.
   - Update the sync-contract row artifacts and tests to the implemented runtime files.
   - Update all five synchronized documents from `planned` to `implemented`.
   - Keep unrelated content unchanged.

### Planned Verification

Run, after implementation:

```bash
./tools/lesson-context status
./tools/lesson-context opening lesson-7
./tools/lesson-context opening lesson-14
./tools/lesson-context opening applied
./tools/lesson-context workflow free-development
./tools/lesson-context workflow product-improvement
./tools/lesson-context workflow external-integration
./tools/test_lesson_context.sh
./tools/test_lesson.sh
./tools/test_lesson14.sh
./tools/test_menu_prerequisites.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/test_lesson_repository.sh
./tools/git-hooks run --mode full --no-cache
```

CI and Lesson14 CI must also pass after push.

### Planned Failure Recovery

- If context map parsing fails, fix `tools/lesson-context` and `tools/lib/lesson_context.sh` before touching lesson commands.
- If lesson progression regresses, temporarily disconnect lesson command integration and keep the standalone context CLI stable.
- If Free Development Mode is displayed as a lesson, move that mapping to workflow context and correct menu/dashboard labels.
- If output is too verbose, adjust learning-mode display policy without rewriting the source context.
- If CI-only failures occur, compare CI logs with local full/no-cache verification and isolate environment-specific behavior.

### Developer Approval Points

- Whether to add columns to `LESSON_CONTEXT_MAP.tsv` or keep additional binding data in separate TSV files.
- How broad `WORKFLOW_CONTEXT_MAP.tsv` should be in its first implementation.
- How much context Free Development Mode should show before product work starts.
- Which workflow targets must always show security guidance.
- How much context should appear in CLI dashboard output before browser dashboard work begins.
- Whether runtime translation remains an agent facilitation instruction or a future translation dictionary is introduced.

## Implemented Git Workflow Policy Implementation Plan

This implementation lets users configure Git-management permissions and Git automation levels before the agent performs Git workflow operations.
It is additive and does not trade away existing 7-day, 14-day, menu, dashboard, Free Development, Product Improvement, external-integration, product-repository cleanup, CI, pre-commit, or as-built sync-contract behavior.

1. Add policy and settings files.
   - Added `docs/workflow/GIT_WORKFLOW_POLICY.tsv` as the policy definition.
   - Added `learning/GIT_WORKFLOW_SETTINGS.tsv` as the current user-selected settings file.
   - Defined supported keys for working-branch permission, worktree permission, main-direct-work permission, and automation level.
   - Keep the file format simple and reusable for CLI tools, dashboard output, and future browser dashboard work.

2. Add a shared Git workflow policy library.
   - Added `tools/lib/git_workflow_policy.sh`.
   - Load policy definitions and selected settings.
   - Validate setting keys and values.
   - Expose helpers for branch permission, worktree permission, main-direct-work permission, automation level, repository context, and Git monitoring.
   - Reuse existing repository-boundary, Git sync, and lesson-common patterns where practical.

3. Add a learner-facing command.
   - Added `tools/git-workflow status`.
   - Added `tools/git-workflow configure`.
   - Added `tools/git-workflow set <key> <value>`.
   - Added `tools/git-workflow allow <branch|worktree|main-direct|commit|push|pr|ci|sync>`.
   - Added `tools/git-workflow check`.
   - Added `tools/git-workflow cleanup-plan`.
   - Keep `cleanup-plan` non-destructive.

4. Define automation levels.
   - `manual`: provide guidance and monitoring only.
   - `commit`: allow automated commit after required checks pass.
   - `pr_ci`: allow automated push, PR creation where applicable, and CI checks.
   - `sync`: allow automated main CI checks plus local/remote synchronization checks.

5. Preserve explicit confirmation for high-impact operations.
   - Keep merge confirmation-gated.
   - Keep branch deletion confirmation-gated.
   - Keep worktree deletion confirmation-gated.
   - Keep remote deletion confirmation-gated.
   - Do not let automation level bypass destructive-operation confirmation.

6. Add Git monitoring.
   - Detect uncommitted changes.
   - Detect unpushed commits.
   - Detect local/remote divergence.
   - List candidate unnecessary working branches.
   - List candidate unnecessary worktrees.
   - Show whether the current repository is the lesson repository or product repository.
   - Separate lesson-repository Git state from product-repository Git state so the workflow cannot mix repositories.

7. Integrate with existing workflows.
   - Added menu and dashboard entry points without removing existing entries.
   - Keep the policy reusable for 7-day, 14-day, applied-learning, Free Development, product-improvement, and external-integration workflows.
   - Keep status paths non-blocking.
   - Enforce the policy only where a start, gate, check, or Git action actually depends on it.

8. Add tests.
   - Added `tools/test_git_workflow_policy.sh`.
   - Test valid setting changes.
   - Test invalid key and invalid value rejection.
   - Test branch and worktree permission decisions.
   - Test automation-level decisions.
   - Test dirty-state and local/remote sync monitoring.
   - Test lesson-repository and product-repository separation.
   - Test cleanup-plan output without deleting branches or worktrees.

9. Wire validation.
   - Added new files to structure checks.
   - Added policy checks to as-built checks.
   - Added `tools/test_git_workflow_policy.sh` to aggregate tests, CI, and pre-commit.
   - Preserve existing checks and avoid replacing current Git sync or CI checks.

10. Synchronize documentation.
   - Updated these five documents from planned to implemented state.
   - Updated `AGENTS.MD`, menu guidance, dashboard guidance, and runtime checks only where the runtime feature became active.
   - Keep unrelated existing content unchanged.

## Implemented Menu-Wide Git Workflow Policy Implementation Plan

This implementation promotes the existing Git workflow policy into a shared menu-level policy.
It is additive and does not trade away existing 7-day, 14-day, applied-learning, Free Development, Product Improvement, External Integration, lesson-maintenance, dashboard, product cleanup, CI, pre-commit, or as-built sync-contract behavior.

1. Preserve the existing Git policy source.
   - Keep `tools/git-workflow status|configure|set|allow|check|cleanup-plan` unchanged as the reusable policy command surface.
   - Reuse `docs/workflow/GIT_WORKFLOW_POLICY.tsv`, `learning/GIT_WORKFLOW_SETTINGS.tsv`, and `tools/lib/git_workflow_policy.sh`.

2. Add menu-level Git policy readiness.
   - Extended `tools/menu readiness` so menu items 1 through 7 show Git policy readiness.
   - Show branch permission, worktree permission, direct-main permission, automation level, and repository-monitor availability.

3. Extend menu checks without weakening existing prerequisites.
   - Added Git policy validation to menu items 1 through 6.
   - Keep current learning-mode, workflow display language, product development language, repository-boundary, and approval checks intact.
   - Keep `automation_level=manual` as a valid non-blocking setting.

4. Add a safe item 7 check/start path.
   - Added `tools/menu check 7`.
   - Added `tools/menu start 7 --confirm`.
   - Treat item 7 as lesson-repository maintenance and use lesson repository Git context.

5. Interpret automation levels consistently by menu item.
   - `manual`: guidance and monitoring only.
   - `commit`: commit-level automation only after required checks pass.
   - `pr_ci`: push, PR, and CI-check automation where applicable.
   - `sync`: main synchronization plus local/remote sync checks where applicable.

6. Preserve explicit confirmation for destructive Git actions.
   - Do not let menu-level policy bypass merge confirmation.
   - Do not let menu-level policy bypass branch deletion, worktree deletion, remote deletion, or product repository cleanup confirmation.

7. Update dashboard visibility.
   - Added a menu-wide Git policy summary to dashboard output.
   - Preserve existing lesson, docs, development, illustration, and menu readiness dashboard sections.

8. Add or update tests.
   - Extended `tools/test_menu_prerequisites.sh` for item 1 through 7 Git policy readiness and checks.
   - Keep `tools/test_git_workflow_policy.sh` focused on the reusable Git policy command itself.
   - Keep `tools/test_lesson_repository.sh`, CI, and pre-commit wiring additive.

9. Synchronize documentation.
   - Updated these five documents from planned to implemented after runtime implementation exists and tests pass.
   - Updated `AGENTS.MD`, menu guidance, and dashboard guidance only where the runtime feature became active.
   - Keep unrelated existing content unchanged.

10. Verify with mechanical checks.
   - Run as-built sync-contract checks.
   - Run menu prerequisite tests.
   - Run Git workflow policy tests.
   - Run aggregate lesson-repository tests.
   - Run pre-commit and GitHub Actions before declaring implementation complete.

## Implemented Git Workflow Action Settings Implementation Plan

This implemented work adds detailed manual/automatic controls for common Git workflow actions.
It must preserve existing Git policy settings, menu checks, dashboard output, cleanup controls, CI checks, pre-commit, and the as-built sync contract.

1. Preserve existing policy compatibility.
   - Keep `branch_allowed`, `worktree_allowed`, `main_direct_work_allowed`, and `automation_level`.
   - Keep `automation_level` available as a compatibility preset.
   - Do not remove or rename existing `tools/git-workflow` commands.

2. Extend the Git workflow policy definition.
   - Add these detailed keys to the policy definition:
     - `commit_automation`
     - `push_automation`
     - `pr_creation`
     - `pr_ci_monitoring`
     - `merge_execution`
     - `developer_auto_merge_allowed`
     - `main_ci_monitoring`
     - `sync_monitoring`
   - Allow only `manual|auto` for non-merge action keys.
   - Allow only `manual|after_approval` for `merge_execution`.
   - Allow only `false|true` for `developer_auto_merge_allowed`.
   - Use these defaults:
     - `commit_automation: auto`
     - `push_automation: manual`
     - `pr_creation: manual`
     - `pr_ci_monitoring: auto`
     - `merge_execution: after_approval`
     - `developer_auto_merge_allowed: false`
     - `main_ci_monitoring: auto`
     - `sync_monitoring: auto`
   - These detailed defaults are active after implementation; `automation_level` remains available as a compatibility preset when detailed action keys are absent.

3. Add shared resolution helpers.
   - Add `git_workflow_action_mode <action>` to `tools/lib/git_workflow_policy.sh`.
   - Supported actions: `commit`, `push`, `pr`, `ci`, `pr_ci`, `merge`, `main_ci`, and `sync`.
   - Keep `ci` as a compatibility alias for CI monitoring so existing `tools/git-workflow allow ci` behavior is not removed.
   - Resolve merge as `manual`, `after_approval`, or `developer_auto`.
   - Resolve `developer_auto` only when `developer_auto_merge_allowed=true` and all merge safety gates pass.
   - Detailed settings take precedence only when the detailed setting key is present.
   - Fall back to `automation_level` when a detailed setting key is absent.

4. Update the learner-facing Git command output.
   - Update `tools/git-workflow status` to show detailed action settings.
   - Update `tools/git-workflow configure` with copyable `set` examples for all detailed settings.
   - Keep `tools/git-workflow set <key> <value>` as the single write path.
   - Add `tools/git-workflow approve <push|pr|merge> "memo"` as the explicit approval write path for high-impact detailed Git actions.

5. Update menu and dashboard visibility.
   - Show detailed action settings in `tools/menu readiness`.
   - Show detailed action settings in `tools/dashboard menu`.
   - Apply the same settings to menu items 1 through 7.

6. Preserve manual confirmation for high-impact actions.
   - For push and PR creation, `auto` means the agent may execute the operation only after explicit approval for that operation is recorded; it never means approval-free execution.
   - For normal merge operation, `merge_execution: after_approval` means the agent may execute merge only after explicit merge approval is recorded.
   - Require matching action, repository, and branch approval receipts from `learning/GIT_WORKFLOW_APPROVALS.tsv` before detailed push, PR creation, or normal merge execution is allowed.
   - Added `developer_auto_merge_allowed: true` as the only implemented path for developer-responsibility approval-free merge.
   - Require gate evidence plus actual repository checks before developer auto-merge: PR CI success, clear target PR and branch, verified merge base, clean working tree, checked local/remote state, and stop-on-failure behavior.
   - Keep branch deletion, worktree deletion, remote deletion, and product repository deletion behind explicit user confirmation regardless of merge settings.
   - Keep PR CI, main CI, and sync monitoring automatic by default.

7. Add tests.
   - Extend `tools/test_git_workflow_policy.sh` for defaults, changes, invalid values, detailed precedence, approval receipts, and helper resolution.
   - Extend `tools/test_menu_prerequisites.sh` for detailed settings in menu readiness.
   - Extend dashboard coverage so `tools/dashboard menu` exposes detailed settings.
   - Keep aggregate lesson-repository, pre-commit, and CI wiring additive.

8. Synchronize implemented documentation.
   - Moved `git_workflow_action_settings` from `planned` to `implemented`.
   - Replaced `ARTIFACTS: none` and `TESTS: none` with the implemented artifacts and tests.
   - Updated these five synchronized documents and the sync contract together.

## Implemented Git Hooks Policy Implementation Plan

This implementation makes `.githooks/pre-commit` faster while preserving the current safety model.
The work is implemented through runtime artifacts, tests, and the `git_hooks_policy` sync record.

1. Preserve the current safety baseline.
   - Kept the existing `.githooks/pre-commit` check list as the functional baseline in `docs/workflow/GIT_HOOK_CHECKS.tsv`.
   - Do not add a normal learner-facing `off` mode.
   - Keep CI and completion verification full or no-cache.
   - Do not remove existing checks, CI steps, sync-contract checks, or documentation routes.

2. Define a reusable policy and settings layer.
   - Added `docs/workflow/GIT_HOOKS_POLICY.tsv`.
   - Added `docs/workflow/GIT_HOOK_CHECKS.tsv`.
   - Added `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv`.
   - Added `learning/GIT_HOOK_SETTINGS.tsv`.
   - Added shared shell helpers in `tools/lib/git_hooks_policy.sh`.
   - Kept mode names and accepted values centralized so future tools, dashboard output, repo-local skills, and tests can reuse the same source.

3. Add a hook runner command.
   - Added `tools/git-hooks status`.
   - Added `tools/git-hooks recommend`.
   - Added `tools/git-hooks recommend --paths <path>...`.
   - Added `tools/git-hooks mode <full|fast|minimal>`.
   - Added `tools/git-hooks cache clear`.
   - Added `tools/git-hooks run`.
   - Added `tools/git-hooks run --no-cache`.
   - Added `tools/git-hooks run --mode <full|fast|minimal>`.
   - Keep output learner-readable and suitable for agents to summarize.

4. Implement conservative caching.
   - Store cache data under an untracked Git-local directory such as `.git/pre-commit-cache/`.
   - Include hook mode, command identity, relevant tool hashes, relevant input hashes, staged content, worktree changes, and Git status data.
   - Disable cache use while untracked files are present.
   - Treat missing, stale, corrupted, or unverifiable cache entries as misses.
   - Never allow a cache hit to replace full/no-cache CI verification.

5. Define mode behavior.
   - `full` runs coverage equivalent to the current required pre-commit checks.
   - `fast` uses the cache to avoid rerunning checks only when prior successful inputs still match.
   - `minimal` runs a small required mechanical set for quick local feedback.
   - Future changes to the minimal-mode check list require developer approval because it defines the lowest acceptable local safety gate.

6. Add local full/no-cache recommendation behavior.
   - Keep the selected local hook mode, such as `minimal`, as the default local pre-commit behavior.
   - Keep remote CI and final verification on full/no-cache coverage.
   - Recommend local `tools/git-hooks run --mode full --no-cache` only when changed paths match the recommendation policy for Git hooks, CI, checks, tests, or as-built synchronization.
   - Keep the recommendation policy in `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv` instead of hard-coding one-off branches in the runner.

7. Connect to existing ecosystem surfaces.
   - Updated `.githooks/pre-commit` to call `tools/git-hooks run`.
   - Wired the dedicated hook test into `tools/test_lesson_repository.sh`.
   - Added CI coverage for the hook test and for full/no-cache behavior.
   - Added AGENTS routing and standard-check references for the hook command and test.
   - Updated existing wiring checks and status output so runner-based hook dispatch is recognized as active pre-commit wiring against full-mode coverage, independent of the current local hook mode.

8. Add standalone and aggregate tests.
   - Added `tools/test_git_hooks.sh` for modes, invalid mode rejection, invalid persisted settings, malformed check rows, invalid or empty check-row mode tokens, cache hits, cache misses, invalidation, no-cache operation, minimal-mode required checks, failing-check cache refusal, and safe cache clearing.
   - Added recommendation tests that confirm ordinary changed files keep the local recommendation at `minimal`, while Git hooks, CI, checks, tests, or as-built synchronization paths recommend local `full --no-cache`.
   - Confirm existing pre-commit checks still run in `full` through `tools/git-hooks run --mode full --no-cache`.
   - Confirm aggregate tests, CI, and pre-commit include the new hook validation after implementation.
   - Confirm existing 7-day, 14-day, Git workflow policy, menu, dashboard, docs-tour, product cleanup, sync-contract, and CI behavior remains available.

9. Plan recovery behavior.
   - If a cache bug is suspected, clear the cache and rerun with `--no-cache`.
   - If hook-runner integration fails, restore the current serial `.githooks/pre-commit` command list while preserving the new tests for diagnosis.
   - If minimal-mode scope conflicts with safety expectations, stop for developer approval.
   - If CI behavior diverges from local hooks, keep CI on full/no-cache verification and fix local runner behavior.

10. Synchronize after implementation.
   - Moved `git_hooks_policy` from `planned` to `implemented`.
   - Replaced `ARTIFACTS: none` and `TESTS: none` with the implemented files and tests.
   - Updated these five synchronized documents and `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv` together.
   - Keep unrelated existing content unchanged.

## Implemented Local Verification Scope Policy Implementation Plan

SYNC-ID: local_verification_scope_policy
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOKS_POLICY.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,learning/GIT_HOOK_SETTINGS.tsv,tools/lib/test_plan.sh,tools/test-plan,tools/lib/git_hooks_policy.sh,tools/git-hooks,tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_git_hooks.sh
TESTS: tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_git_hooks.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

This implementation records an everyday local-verification scope rule over the existing Test Plan Manifest and Git hooks policy.
It adds no runtime branch and does not reduce CI, pre-commit, aggregate, full/no-cache, or sync-contract coverage.

### Implemented Change Targets

- Add an AGENTS invariant that limits test execution to workflow contract, change scope, and user approval.
- Synchronize the rule through the five as-built/workflow documents under `local_verification_scope_policy`.
- Connect the rule to existing `TEST_PLAN_MANIFEST.tsv`, `GIT_HOOK_CHECKS.tsv`, `GIT_HOOK_RECOMMENDATION_PATHS.tsv`, `GIT_HOOKS_POLICY.tsv`, and `GIT_HOOK_SETTINGS.tsv`.
- Keep developer-memory documentation out of scope because it is not the durable source for this rule.

### Implemented Order

1. Add the invariant after existing AGENTS rules without changing prior rule wording or numbering.
2. Add the sync-contract row so the five synchronized documents can be checked mechanically.
3. Add role-specific content:
   - requirements state the user-facing and agent-behavior requirement;
   - specification defines how existing contracts decide verification scope;
   - implementation plan records targets, order, verification, recovery, and approval boundaries;
   - task tracker records implemented status;
   - handoff records restart behavior.
4. Preserve all existing Git hooks, CI, pre-commit, resource guard, and test-plan semantics.

### Verification Plan

The contract-required checks for this documentation synchronization are:

```bash
./tools/check_test_plan_coverage.sh
./tools/test_test_plan.sh
./tools/test_git_hooks.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
```

Heavy or recommended checks outside this set must be presented before execution unless the change scope later expands into runtime hook, CI, schema, shared-tooling, or broad implementation changes.

### Recovery Plan

- If the sync contract fails, align the contract row and all five synchronized document blocks before changing runtime artifacts.
- If the new invariant conflicts with the no-existing-feature-tradeoff rule, keep the no-existing-feature-tradeoff rule authoritative and narrow the new text.
- If future agents treat recommendation paths as automatic approval to run heavy tests, clarify recommendation versus permission in AGENTS and the specification before changing tools.
- If lightweight changes still trigger excessive local work, inspect the path policy and present a policy-change proposal rather than bypassing the existing contract.

### Developer Approval Gates

- Approval is required before reducing full/no-cache scope, changing required CI contexts, changing `full`, `fast`, or `minimal` semantics, making changed-only checks authoritative, weakening pre-commit or sync-contract coverage, or accepting any existing-feature tradeoff.
- Approval is required before changing `TEST_PLAN_MANIFEST.tsv`, `GIT_HOOK_CHECKS.tsv`, or `GIT_HOOK_RECOMMENDATION_PATHS.tsv` behavior to make this rule more or less aggressive.

## Verification Plan

Run:

```bash
./tools/check_lesson_structure.sh
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/check_as_built_docs.sh
./tools/check_as_built_sync_contract.sh
./tools/as-built-sync status
./tools/check_review_protocol.sh
./tools/check_developer_memory_requirements.sh
./tools/menu
./tools/dashboard all
./tools/illustrations list
./tools/test_as_built_sync_contract.sh
./tools/test_git_workflow_policy.sh
./tools/test_git_hooks.sh
./tools/git-hooks run --mode full --no-cache
.githooks/pre-commit
./tools/test_menu_prerequisites.sh
./tools/test_lesson_start_position.sh
./tools/test_lesson.sh
./tools/test_lesson14.sh
./tools/test_product_gate_tools.sh
./tools/test_product_repository_cleanup.sh
./tools/test_lesson_repository.sh
```

Run `./tools/test_production_operations.sh` only when an external product repository is intentionally present.

The verification sequence also includes document-organization, workflow-pair synchronization, strengthened as-built synchronization, external-integration, Playwright, CI/pre-commit, and failure-path tests introduced by this plan.

Implemented local verification for the 7-day parity change passed:

```text
7-day lesson CLI tests passed.
Lesson14 CLI tests passed.
Lesson repository test passed.
```

The same verification covers the expanded language list and confirms `zh` is normalized to `zh-CN`.

## Implemented Resource Guard Safe Cleanup Implementation Plan

This plan was synchronized from `docs/memory/DEVELOPER_MEMORY.md` and implemented as `resource_guard_safe_cleanup`.
It is a follow-up capability to `resource_budget_parallel_guard`, not a replacement for the existing resource monitoring and fail-closed behavior.

### Implemented Change Targets

- `docs/workflow/RESOURCE_POLICY.tsv`
- `learning/RESOURCE_SETTINGS.tsv`
- `tools/lib/resource_guard.sh`
- `tools/resource-guard`
- `tools/test_resource_cleanup.sh`
- `tools/test_lesson_repository.sh`
- `docs/workflow/GIT_HOOK_CHECKS.tsv`
- `.github/workflows/ci.yml`
- `.github/workflows/lesson14-ci.yml`

### Implemented Order

1. Synchronized the safe cleanup plan into the five as-built and workflow documents.
   - Added `resource_guard_safe_cleanup` to `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv`.
   - Kept `resource_budget_parallel_guard` implemented and unchanged as the parent resource-control capability.

2. Extended resource policy and settings.
   - Added cleanup defaults for safe deletion, age filtering, and explicit safe-delete requirements.
   - Added policy-owned cleanup targets for Playwright report output, Playwright test results, and marked Git hooks cache.
   - Kept cleanup targets data-driven instead of embedding target lists in command branches.

3. Added shared cleanup helpers to `tools/lib/resource_guard.sh`.
   - Validate cleanup target paths.
   - Resolve paths under the lesson repository root.
   - Reject path traversal, absolute paths, symlink targets, unsafe `.git` targets, and repo-boundary escape.
   - Require the Git hooks cache marker before deleting `.git/pre-commit-cache`.
   - Apply optional age filtering before deletion.

4. Added `tools/resource-guard cleanup`.
   - Default action is dry-run.
   - `--safe` is required for deletion.
   - `--profile` filters cleanup targets by reusable profile.
   - `--older-than` overrides the configured age filter for one command.

5. Added standalone cleanup tests.
   - Added `tools/test_resource_cleanup.sh`.
   - Tests use temporary fixture repositories and do not depend on the product repository or local Playwright artifacts.
   - Tests cover dry-run, safe deletion, profile filtering, age filtering, symlink rejection, repo-outside rejection, unknown profile rejection, disabled safe cleanup, and Git hooks cache marker enforcement.

6. Connected cleanup regression to existing verification surfaces.
   - Wired cleanup tests into `tools/test_lesson_repository.sh`.
   - Added cleanup regression to `docs/workflow/GIT_HOOK_CHECKS.tsv`.
   - Added shell syntax and regression steps to both GitHub Actions workflows.

### Recovery Plan

- If dry-run deletes anything, stop and disable cleanup execution until planning is fixed.
- If a repo-outside path is accepted, stop and fix path validation before continuing.
- If a symlink escape is possible, disable safe deletion and repair boundary checks.
- If Git hooks cache cleanup fails, keep `tools/git-hooks cache clear` as the existing recovery path and repair marker validation.
- If Playwright reports are needed for debugging, use dry-run or age filtering rather than deleting them immediately.
- If CI diverges from local behavior, keep CI cleanup checks fixture-based and non-destructive outside temporary test directories.

## Implemented Resource Guard Summary And Parallel CI Implementation Plan

This implementation was synchronized from `docs/memory/DEVELOPER_MEMORY.md` as `resource_guard_summary_parallel_ci`.
It is a follow-up to the implemented resource guard, Git hooks policy, and safe cleanup work.
It must not replace existing `status`, `monitor`, `recommend-jobs`, `check`, `cleanup`, Git hooks modes, CI checks, pre-commit behavior, or lesson flows.

### Implemented Change Targets

- `tools/resource-guard`
- `tools/lib/resource_guard.sh`
- `tools/lib/git_hooks_policy.sh`
- `tools/git-hooks`
- `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv`
- `.github/workflows/ci.yml`
- `.github/workflows/lesson14-ci.yml`
- `tools/test_resource_guard_summary.sh`
- `tools/test_git_hooks_parallel.sh`
- `tools/check_ci_workflow_structure.sh`
- Existing aggregate and hook wiring in `tools/test_lesson_repository.sh`, `.githooks/pre-commit`, and CI workflows.

### Implemented Order

1. Synchronized the plan into the five as-built/workflow documents and added the sync contract row.
2. Added resource guard summary helpers that read profiles from `docs/workflow/RESOURCE_POLICY.tsv` and reuse `resource_guard_recommended_jobs`.
3. Added `tools/resource-guard summary` and `tools/resource-guard summary --short`.
4. Added standalone summary regression tests with fixture policy/settings files.
5. Added `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv` for parallel-safe, serial, heavy, and final-gate classification without changing the existing `GIT_HOOK_CHECKS.tsv` contract.
6. Added local Git hooks parallel runner support that uses the `git-hooks-full` recommendation as the maximum worker count for parallel-safe checks.
7. Kept minimal mode conservative and serial.
8. Added isolated per-check logging and deterministic replay in check definition order.
9. Added Git hooks parallel regression tests for worker limits, serial fallback, failure reporting, output order, and unclassified serial fallback.
10. Split GitHub Actions workflows into runner-oriented jobs while preserving all existing checks.
11. Added required CI workflow structure checks to verify required job names, `needs`, and required commands.
12. Ensured main CI aggregate/full-hooks jobs install npm dependencies and Playwright dependencies before running aggregate repository tests or full hooks.
13. Preserved explicit local/CI separation, including CI-safe local-resource bypass behavior with `RESOURCE_GUARD_SKIP_LOCAL_CHECK=1` for CI full hooks.
14. Wired new tests into aggregate, pre-commit, and CI.
15. Updated `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv` from planning-only artifacts and tests to actual runtime artifacts, runtime tests, and runtime evidence.
16. Moved the sync ID from `planned` to `implemented` after runtime artifacts and tests existed locally.

### Verification Plan

Verification commands:

```bash
bash -n tools/resource-guard tools/lib/resource_guard.sh tools/lib/git_hooks_policy.sh tools/git-hooks
./tools/resource-guard summary
./tools/resource-guard summary --short
./tools/test_resource_guard_summary.sh
./tools/test_resource_guard.sh
./tools/test_git_hooks_parallel.sh
./tools/test_git_hooks.sh
./tools/as-built-sync status
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_workflow_pair_sync.sh
./tools/check_ci_workflow_structure.sh
./tools/git-hooks run --mode minimal --no-cache
./tools/git-hooks run --mode full --no-cache
.githooks/pre-commit
./tools/test_lesson_repository.sh
```

Optional verification:

```bash
./tools/test_lesson_playwright.sh
```

Remote CI verification should use GitHub Actions run status or PR checks after the workflow split is pushed.

### Recovery Plan

- If summary output diverges from `status` or `recommend-jobs`, fix summary helper reuse rather than duplicating calculations.
- If local parallel hooks fail due to ordering or shared state, classify the affected check as serial and keep the rest of the parallel-safe group intact.
- If logs interleave, keep per-check logs and replay order as the required baseline.
- If resource guard returns `safe-stop`, stop new parallel work instead of forcing worker execution.
- If CI job splitting drops an existing check, restore the check before pursuing runtime improvement.
- If CI job splitting becomes ambiguous, pause for developer approval rather than weakening verification.

### Developer Approval Gates

- Approval is required before changing the meaning of `full`, `fast`, or `minimal`.
- Approval is required before directly changing the `GIT_HOOK_CHECKS.tsv` column structure.
- Approval is required before making Playwright or aggregate checks more aggressively parallel than resource guard recommends.
- Approval is required before reducing duplicate CI coverage for speed.
- Approval is required before adding a CI-specific settings file if the workflow structure alone is insufficient.

## Implemented Security Guard Backfill Implementation Plan

This implementation is synchronized from `docs/memory/DEVELOPER_MEMORY.md`.
The sync ID is implemented because runtime artifacts, tests, Git hooks wiring, CI wiring, and pre-commit wiring are present.

### Implemented Scope

- Added a Security guard backfill sync scope that is separate from learner-context runtime integration.
- Added repository-level security invariants to the agent rule layer.
- Added `docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv` as a policy table for security surfaces, invariants, evidence, required checks, and status.
- Added `tools/lib/security_invariants.sh`, `tools/check_security_invariants.sh`, and `tools/test_security_invariants.sh`.
- Wired the checker into aggregate tests, Git hooks, CI, and pre-commit.

### Implemented Order

1. Added the policy table with a small schema rather than overbuilding severity or owner routing.
2. Added the reusable security-invariant checker and regression test.
3. Added Git hooks recommendation paths and hook checks after the checker existed.
4. Wired standalone, sync, aggregate, Git hooks, pre-commit, and CI verification.
5. Moved `safeflow_security_backfill` from planned to implemented after runtime artifacts and tests passed locally.

### Verification

```bash
./tools/check_security_invariants.sh
./tools/test_security_invariants.sh
./tools/as-built-sync status
./tools/check_as_built_sync_contract.sh
./tools/check_workflow_pair_sync.sh
./tools/test_lesson_repository.sh
./tools/git-hooks run --mode minimal --no-cache
./tools/git-hooks run --mode full --no-cache
.githooks/pre-commit
```

### Recovery

- If the checker creates false positives, adjust policy categories or allowlists instead of adding one-off bypasses.
- If a proposed invariant conflicts with existing behavior, stop and ask for developer approval.
- If a security check requires network access, separate it from pre-commit and local non-network verification.

## Implemented Product Security Workflow Gate Implementation Plan

This implementation is synchronized from `docs/memory/DEVELOPER_MEMORY.md`.
The sync ID is implemented because product-security runtime commands, policy, tests, and menu/workflow wiring exist.

### Implemented Scope

- Added product-security advice, check, and gate behavior for menu items 4, 5, and 6.
- Keep existing Free Development, Product Improvement, External Integration, repository-boundary, Git sync, CI, and document-sync gates.
- Added product security policy configuration instead of hard-coded stack-specific branches.
- Added workflow-context risk metadata for Free Development, Product Improvement, External Integration, and lesson maintenance.
- Added dashboard and menu safety summaries that explain next safe action, what not to touch, and what requires approval.

### Implemented Order

1. Added `docs/workflow/PRODUCT_SECURITY_POLICY.tsv` and `learning/context/WORKFLOW_CONTEXT_MAP.tsv`.
2. Added `tools/lib/product_security.sh` as the reusable product-security library.
3. Added `tools/product-security status|preflight|advise|check|gate`.
4. Added `tools/test_product_security.sh` using temporary product repositories and fixture policies.
5. Connected the product-security gate to menu items 4, 5, and 6 without replacing existing gates.
6. Strengthened External Integration start/preflight prompts to require explicit OAuth/API and logging confirmation.
7. Added product-repository context handling after the product repository is known.
8. Wired tests into aggregate tests, Git hooks, CI, and pre-commit.
9. Moved `product_security_workflow_gate` from planned to implemented after runtime artifacts and tests passed locally.

### Verification

```bash
./tools/product-security status
./tools/product-security preflight
./tools/product-security check
./tools/test_product_security.sh
./tools/test_product_gate_tools.sh
./tools/as-built-sync status
./tools/check_as_built_sync_contract.sh
./tools/check_workflow_pair_sync.sh
./tools/test_lesson_repository.sh
./tools/git-hooks run --mode minimal --no-cache
./tools/git-hooks run --mode full --no-cache
.githooks/pre-commit
```

### Recovery

- If the gate blocks too much, split high-confidence blocks from warnings instead of weakening all security checks.
- If a stack-specific check is needed, put the detection and command mapping in policy or reusable library code.
- If product repository context is ambiguous, stop and require user confirmation instead of scanning outside the configured repository.

### Developer Approval Gates

- Future approval is required before expanding AGENTS.MD security-invariant wording beyond the implemented additive rule.
- Future approval is required before adding new product-security blocking conditions.
- Future approval is required before making External Integration approvals mandatory beyond the implemented OAuth/API and logging scope.
- Approval is required before enabling network-dependent audits such as `npm audit` in CI.
- Approval is required before adding product repository cleanup strengthening to this implementation instead of a later sync scope.

## Implemented Test And CI Safe Time Optimization Implementation

This plan is synchronized as `test_ci_safe_time_optimization_plan`.
The implemented first phase keeps runtime test selection, CI required behavior, pre-commit behavior, and Git hook mode semantics intact while adding observe-only planning, fail-closed coverage checks, result attestation, CI-safe Git hooks parallelism, and lightweight fixture copying.

### Implemented Change Targets

- `docs/workflow/TEST_PLAN_MANIFEST.tsv` stores machine-readable observe-only test-plan policy.
- `tools/lib/test_plan.sh` and `tools/test-plan` implement changed-path classification, manifest generation, coverage validation, and result attestation.
- `tools/check_test_plan_coverage.sh` and `tools/test_test_plan.sh` provide standalone and aggregate-callable checks.
- `tools/git-hooks` accepts `--jobs <count>` and `GIT_HOOKS_JOBS` while local execution remains capped by resource guard recommendations.
- `.github/workflows/ci.yml` and `.github/workflows/lesson14-ci.yml` keep full/no-cache verification and request CI-safe full-hooks parallelism with `--jobs 4`.
- `tools/lib/fixture_copy.sh`, `tools/fixture-copy`, and `tools/test_fixture_copy.sh` implement and validate lightweight fixture copying.
- `docs/workflow/GIT_HOOK_CHECKS.tsv`, `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv`, `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv`, `tools/test_lesson_repository.sh`, and `tools/check_ci_workflow_structure.sh` wire the new checks into existing local, aggregate, Git hooks, and CI gates.

### Implemented Order And Preserved Future Work

1. Added a Test Plan Manifest in observe-only mode.
   - Generate `run` and `force` decisions without changing actual CI enforcement.
   - Print learner-readable decision and full-escalation reasons.
   - Treat unknown paths and dangerous paths as full/no-cache until classified.

2. Added Coverage Guard.
   - Fail closed when policy rows are malformed, reference unknown Git hook checks, omit required dangerous-change patterns, weaken required dangerous-change full/CI escalation, or emit a force decision without full escalation.
   - Keep CI/pre-commit wiring verification in the CI workflow structure checker.
   - Add tests that prove unsafe changed-only decisions fail before any CI skipping is allowed.

3. Added Result Attestation.
   - Record policy hash, check-catalog hash, repository-state hash, manifest hash, generated run/force decisions, and final observe-only authority.
   - Keep attestation as evidence, not as approval or proof of delivery.

4. Connected observe-only checks to local hooks, aggregate tests, and CI.
   - Local `minimal`, `fast`, and `full` run the coverage guard through the configured hook catalog.
   - CI runs the coverage guard and test-plan regression while still running the existing required full verification.

5. Kept the hook-specific gap-only final gate as future work.
   - Keep `tools/test_lesson_repository.sh` as the standalone exhaustive aggregate command.
   - In full hooks, replace duplicate aggregate reruns only after a mechanical coverage check proves that individual hook rows plus the gap gate cover the standalone aggregate expectations.

6. Kept as-built validation single-pass behavior as future work.
   - Keep strict standalone defaults.
   - Add internal-only options only after tests prove callers already ran `tools/check_as_built_sync_contract.sh` once in the same path.

7. Kept Playwright duplicate-execution removal as future work.
   - Keep Playwright as required local/CI verification where relevant.
   - Ensure CI final aggregation checks Playwright evidence rather than rerunning the browser suite.

8. Added CI-safe hook parallelism.
   - Keep `--mode full --no-cache`.
   - Add an explicit CI worker setting through `--jobs` or `GIT_HOOKS_JOBS`.
   - Do not use local WSL resource settings as CI truth.

9. Reduced fixture-copy cost.
   - Add a shared fixture-copy helper that excludes `.git`, `node_modules`, `playwright-report`, `test-results`, and cache directories.
   - Require any test fixture that depends on untracked files to declare those files explicitly.

10. Kept changed-only selection observe-only.
    - Compare planned changed-only output against full CI results.
    - Do not let changed-only skip CI checks until Coverage Guard and Result Attestation are implemented and have sufficient passing evidence.

### Document Synchronization Policy

- `docs/as-built/REQUIREMENTS.md` describes the guarantees and non-goals.
- `docs/as-built/SPECIFICATION.md` describes manifest, guard, attestation, cache, CI, and quarantine behavior.
- `docs/as-built/IMPLEMENTATION_PLAN.md` describes implementation order, recovery, and approval gates.
- `docs/workflow/TASK_TRACKER.md` records implemented task state and preserved future work.
- `docs/workflow/HANDOFF.md` records restart context, risks, future approval gates, and next steps.
- The sync ID is implemented because runtime artifacts, standalone tests, aggregate wiring, CI wiring, and pre-commit behavior are present and verified for the safe first phase.

### Verification Plan

Implemented verification:

```bash
bash -n tools/test-plan tools/lib/test_plan*.sh tools/lib/fixture_copy.sh tools/fixture-copy tools/check_test_plan_coverage.sh tools/test_test_plan.sh tools/test_fixture_copy.sh
./tools/test_test_plan.sh
./tools/check_test_plan_coverage.sh
./tools/test_fixture_copy.sh
./tools/test_git_hooks_parallel.sh
./tools/check_ci_workflow_structure.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/as-built-sync status
./tools/test_lesson_repository.sh
./tools/git-hooks run --mode minimal --no-cache
./tools/git-hooks run --mode full --no-cache
.githooks/pre-commit
```

### Recovery Plan

- If Test Plan Manifest output is wrong, keep it observe-only and fix policy classification before changing execution behavior.
- If Coverage Guard blocks valid work, fix the manifest or impact map; do not bypass the guard with ad hoc path exceptions.
- If attestation is incomplete, keep full CI authoritative and repair evidence generation.
- If same-run cache creates stale reuse, disable reuse and keep full/no-cache execution until hash inputs are corrected.
- If gap-only final gate misses aggregate coverage, restore the standalone aggregate in full hooks and repair the mechanical coverage check.
- If CI workflow consolidation changes required check names, pause for developer approval and branch-protection migration planning.

### Developer Approval Gates

- Approval is required before making changed-only selection authoritative in CI.
- Approval is required before changing required CI check names or consolidating `ci.yml` and `lesson14-ci.yml` in a way that affects branch protection.
- Approval is required before reducing full/no-cache scope.
- Approval is required before adding flaky quarantine.
- Approval is required before changing the meaning of `full`, `fast`, or `minimal`.
- Approval is required before using persistent verification-result cache in CI.

## Implemented Test And CI Final Gate Optimization Implementation Plan

This plan is synchronized as `test_ci_final_gate_optimization_plan`.
It is implemented as the completed test and CI time optimization work for reducing the current long `aggregate-and-full-hooks` runtime without reducing coverage.

### Planned Change Targets

- `.github/workflows/ci.yml` and `.github/workflows/lesson14-ci.yml` for dependency caching, same-run evidence handoff, and common-versus-Lesson14 final-gate separation.
- `docs/workflow/TEST_PLAN_MANIFEST.tsv` and `docs/workflow/FINAL_GATE_COVERAGE.tsv` for cache-scope, aggregate coverage, and final-gate policy alignment.
- `docs/workflow/GIT_HOOK_CHECKS.tsv`, `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv`, and `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv` for hook catalog and final-gate coverage mapping.
- `tools/git-hooks` and shared Git hook policy code for full-mode gap-only final-gate dispatch.
- `tools/test_lesson_repository.sh` as the standalone exhaustive aggregate command that must remain available.
- `tools/check_ci_workflow_structure.sh` for mechanical enforcement of the optimized CI shape.
- New implementation-specific checks and tests for gap-only coverage, same-run evidence reuse, Playwright evidence reuse, and as-built evidence reuse.

### Planned Implementation Order

1. Add same-run evidence primitives.
   - Define a repo-local or workflow-local evidence directory.
   - Record command ID, commit SHA, workflow name, job name, policy hash, check catalog hash, input hashes, result hash, and timestamp.
   - Reject evidence that is missing, stale, corrupted, mismatched, or from a different command identity.

2. Add as-built and sync evidence reuse.
   - Generate evidence from strict as-built and sync checks.
   - Reuse evidence only inside the same command or CI run when synchronized document hashes, sync-contract hash, checker hashes, and repository-state hash match.
   - Keep strict standalone commands unchanged.

3. Add Playwright evidence reuse.
   - Generate evidence from the `playwright-tests` job.
   - Final aggregation checks evidence instead of rerunning Playwright when config, test files, dependency lockfile, command identity, commit SHA, workflow run, source job identity, and result status match.
   - Rerun or fail closed when evidence cannot be trusted.

4. Add hook-specific gap-only final gate.
   - Keep `tools/test_lesson_repository.sh` as the exhaustive command.
   - Replace the full hook's duplicate aggregate rerun with a final gate that proves individual hook rows plus explicit final-gap checks cover the aggregate expectations.
   - Add a standalone coverage map and test proving the gate fails when any aggregate requirement is uncovered.

5. Reduce common CI duplication between `CI` and `Lesson14 CI`.
   - Keep required workflow names unless developer approval is granted to change them.
   - Move common heavy verification into one common path where possible.
   - Keep Lesson14-specific structure and CLI checks in `Lesson14 CI` through a Lesson14-specific final gate instead of the common aggregate/full-hooks gate.
   - If branch-protection constraints require both workflows to report, reduce duplicate internals without renaming checks.
   - Keep the legacy `Lesson14 CI` `playwright-tests` and `aggregate-and-full-hooks` job names as compatibility gates that do not duplicate browser execution, `tools/test_lesson_repository.sh`, or `tools/git-hooks run --mode full --no-cache`.
   - Extend Git hook recommendation paths so final-gate coverage, final-gate commands, same-run evidence, and as-built evidence implementation changes recommend local `full --no-cache`.

6. Add dependency caching.
   - Use GitHub Actions npm dependency caching.
   - Add Playwright browser dependency caching where safe for hosted runners.
   - Never restore verification-result cache from earlier commits or workflow runs.

7. Extend cleanup and cache management.
   - Include same-run evidence, Playwright reports, test results, temporary fixtures, and repo-local cache directories.
   - Keep global caches, OS caches, Docker, swap, processes, product repositories, and user-home cleanup out of scope without explicit approval.

8. Update mechanical enforcement.
   - Extend CI structure checks to require the optimized final-gate shape.
   - Keep new tests standalone and callable from aggregate tests.
   - Keep `TEST_PLAN_MANIFEST.tsv` cache-scope policy aligned with implemented behavior.

### Document Synchronization Policy

- Requirements describe the guarantees, non-goals, and approval gates.
- Specification describes same-run evidence validity, cache boundaries, and fail-closed behavior.
- Implementation plan describes change order, validation, recovery, and approval points.
- Task tracker records the implemented work and final verification state.
- Handoff records restart instructions and the next implementation boundary.
- The as-built sync contract is `implemented` because the runtime artifacts and tests exist, are wired, and are expected to pass.

### Verification Plan

The implementation must add and pass these checks before the sync ID can become `implemented`:

```bash
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_ci_workflow_structure.sh
./tools/test_test_plan.sh
./tools/test_git_hooks_parallel.sh
./tools/test_resource_cleanup.sh
./tools/test_lesson_start_position.sh
./tools/test_lesson14.sh
./tools/test_lesson_repository.sh
./tools/git-hooks run --mode full --no-cache --jobs 4
.githooks/pre-commit
```

The implementation must also add focused tests for:

- gap-only final-gate coverage,
- same-run evidence reuse and stale-evidence rejection,
- Playwright evidence reuse and changed-input rejection,
- as-built evidence reuse and changed-document rejection,
- CI dependency cache wiring,
- cleanup coverage for same-run evidence and generated reports.

### Recovery Plan

- If gap-only final gate misses coverage, restore the duplicate aggregate rerun in full hooks and fix the coverage map.
- If same-run evidence is stale or ambiguous, disable evidence reuse for that command and rerun the strict check.
- If Playwright evidence cannot be trusted, rerun Playwright rather than passing on incomplete evidence.
- If as-built evidence mismatches input hashes, rerun strict as-built checks.
- If dependency caching causes CI-only failures, remove the cache step or narrow the cache key.
- If CI workflow consolidation affects required check names, stop and request developer approval.

### Developer Approval Gates

- Approval is required before changing required CI workflow or job names.
- Approval is required before reducing full/no-cache scope.
- Approval is required before making changed-only CI selection authoritative.
- Approval is required before reusing verification results across workflow runs or commits.
- Approval is required before introducing flaky quarantine.
- Approval is required before accepting any existing-feature tradeoff; the approval request must state the reason, impact, alternatives, and rollback path.

## Implemented Test And CI Full Pipeline Acceleration Implementation Plan

This plan is synchronized as `test_ci_full_pipeline_acceleration_plan`.
Runtime behavior is implemented through policy files, focused regression checks, CI workflow structure checks, and workflow wiring.
The purpose is to complete the remaining local and remote test/CI speed work after the final-gate evidence-reuse implementation, without weakening any required check or existing workflow.

### Implemented Change Targets

- `.github/workflows/ci.yml` and `.github/workflows/lesson14-ci.yml` for GitHub Actions deprecation handling, Playwright setup optimization, job separation, duplicate-policy regression reduction, and CI-runner-oriented parallelism.
- `docs/workflow/TEST_PLAN_MANIFEST.tsv`, `docs/workflow/GIT_HOOK_CHECKS.tsv`, `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv`, `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv`, `docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv`, and `docs/workflow/FINAL_GATE_COVERAGE.tsv` for machine-readable check ownership, risk, cache scope, parallel grouping, and final-gate coverage policy.
- `tools/git-hooks`, `tools/lib/git_hooks_policy.sh`, `tools/lib/resource_guard.sh`, `tools/ci-final-gate`, `tools/ci-evidence`, `tools/lib/ci_evidence.sh`, and `tools/lib/as_built_evidence.sh` for local execution, evidence validation, same-run reuse, and resource-aware behavior.
- `tools/check_as_built_sync_contract.sh`, `tools/check_ci_workflow_structure.sh`, `tools/check_test_plan_coverage.sh`, `tools/test_ci_evidence.sh`, `tools/test_ci_final_gate.sh`, `tools/test_git_hooks_parallel.sh`, and `tools/test_lesson_repository.sh` for mechanical verification.
- `tools/ci-playwright-setup` and `tools/test_ci_pipeline_acceleration.sh` for cache-aware Playwright setup and focused acceleration regression coverage.
- Future implementation candidates such as `tools/ci-metrics` or additional focused tests may be added only when they are generic, reusable, standalone-testable, aggregate-testable, and synchronized into the contract after creation.

### Implemented Steps

1. GitHub Actions deprecation regressions are mechanically guarded first.
   - Required workflow/job meanings are preserved.
   - CI workflow structure checks reject old major action versions and `continue-on-error: true`.

2. Playwright setup is optimized.
   - `tools/ci-playwright-setup` prefers npm cache reuse and checks whether Chromium is already installed.
   - Playwright execution is preserved and setup falls back to normal install behavior when cache state is missing, stale, or unsupported.

3. Full-hook parallelization is expanded safely.
   - Lesson CLI fixture checks are classified through the existing parallel-group policy after confirming independent fixture state.
   - Keep unclassified or ambiguous checks serial.

4. Same-run evidence reuse remains scoped and fail-closed.
   - Same-run reuse for existing evidence-backed checks remains valid only when relevant hashes, command identities, repository state, and success status match.
   - Keep strict standalone commands available.

5. Duplicated policy-regression work between `CI` and `Lesson14 CI` is reduced.
   - Keep required workflow and job contexts unless developer approval changes them.
   - Main `CI` owns common policy regression work.
   - `Lesson14 CI` keeps compatibility contexts and lesson-specific gates without rerunning browser tests, `tools/test_lesson_repository.sh`, or full Git hooks.

6. `aggregate-and-full-hooks` internals preserve the optimized final-gate structure.
   - Evidence generation, evidence verification, and final-gap gate behavior remain covered by existing final-gate implementation and structure checks.
   - Preserve the externally required final guarantee that aggregate, full hooks, final-gap coverage, and evidence validity all pass.

7. Changed-only CI remains prepared for a future approval gate.
   - Keep changed-only observe-only in this implementation cycle.
   - Do not make changed-only authoritative until Coverage Guard, Result Attestation, full-CI comparison evidence, and developer approval are complete.

### Document Synchronization Policy

- Requirements state the guarantees, safety boundaries, and approval gates.
- Specification states policy-driven behavior, evidence validity, CI structure, and fail-closed behavior.
- Implementation plan states the implementation order, verification, recovery, and approval points.
- Task tracker records this as implemented work with final verification status.
- Handoff records the restart boundary for future test/CI acceleration work.
- The sync contract is `implemented` after runtime artifacts exist, tests are wired, and local plus remote verification pass.

### Verification Plan

The implementation cycle must run the related checks that already exist before and after changes:

```bash
git diff --check
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_ci_workflow_structure.sh
./tools/test_ci_pipeline_acceleration.sh
./tools/test_ci_evidence.sh
./tools/test_ci_final_gate.sh
./tools/test_git_hooks_parallel.sh
./tools/test_lesson_repository.sh
```

The implementation cycle adds focused tests when new behavior is introduced:

- CI workflow deprecation and action-version structure checks.
- Playwright cache-key and fallback tests.
- Parallel-group independence tests for newly parallelized checks.
- Same-run evidence reuse and stale-evidence rejection tests for new evidence types.
- Duplicate-policy regression prevention checks.
- Aggregate/final-hook split tests that prove no required coverage is lost.
- Changed-only observe-only metrics tests if metrics are added.
- `tools/test_ci_pipeline_acceleration.sh` is the focused standalone and aggregate-callable regression check for this cycle.
- `tools/check_as_built_sync_contract.sh` recognizes the documented split between main `CI` common verification and `Lesson14 CI` compatibility contexts without accepting missing main CI coverage.
- `tools/check_as_built_sync_contract.sh` caches wiring lookups only within one checker process to avoid re-scanning the same evidence repeatedly; this is not persistent verification-result caching.

### Recovery Plan

- If a cache causes stale or CI-only failures, narrow the cache key or remove the cache step.
- If parallelization causes nondeterministic output or shared-state collisions, move that check back to serial and update the policy row.
- If evidence reuse is ambiguous, disable reuse for that command and rerun the strict check.
- If job splitting affects required check names, restore compatibility contexts and request developer approval before changing names.
- If changed-only appears to skip required coverage, keep it observe-only and fail the new guard.
- If any existing-feature tradeoff appears necessary, stop and request developer approval with reason, impact, alternatives, and rollback path.

### Developer Approval Gates

- Approval is required before changing required CI workflow or job names.
- Approval is required before reducing full/no-cache scope.
- Approval is required before making changed-only CI authoritative.
- Approval is required before caching verification results across commits, branches, workflow runs, repositories, or users.
- Approval is required before adding flaky quarantine.
- Approval is required before accepting any existing-feature tradeoff; the approval request must state the reason, impact, alternatives, and rollback path.

## CI Timing And Approved Auto-Improvement Implementation Plan

SYNC-ID: ci_timing_auto_improvement_plan
STATUS: implemented
ARTIFACTS: docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/check_ci_status.sh,tools/check_ci_workflow_structure.sh,tools/lib/ci_timing.sh,tools/ci-timing,tools/test_ci_timing.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_evidence.sh,tools/test_ci_final_gate.sh,tools/test_git_hooks_parallel.sh,tools/test_lesson_repository.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_ci_workflow_structure.sh,tools/test_ci_timing.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_evidence.sh,tools/test_ci_final_gate.sh,tools/test_git_hooks_parallel.sh,tools/check_as_built_sync_contract.sh

This implementation adds measurement, precise CI completion checks, and approval-gated improvement proposals before any reduction in final-gate or full/no-cache behavior.
It is runtime-implemented for timing and proposal generation, while generated improvements remain read-only until developer approval.

### Implemented Change Targets

- Added reusable timing report support for final-gate and Git hooks checks through `tools/lib/ci_timing.sh` and `tools/ci-timing`.
- Connected timing report output to CI artifact collection for the main `CI` final common aggregate and full-hooks checks.
- Strengthened `tools/check_ci_status.sh` so workflow name, run id, commit SHA when available, run state, job state, and conclusion are checked without confusing `CI` and `Lesson14 CI`.
- Added read-only CI improvement proposal generation through `tools/ci-timing propose`.
- Kept same-run hash-evidence reuse recommendations gated by command identity, input hashes, policy hashes, repository-state hash, workflow/run identity, and success status.
- Connected the implementation through `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv`, `docs/workflow/GIT_HOOK_CHECKS.tsv`, `docs/workflow/TEST_PLAN_MANIFEST.tsv`, final-gate policy files, CI workflow structure checks, and aggregate tests.
- Kept conditional `full no-cache` reduction as a future developer-approved step.

### Implemented Order

1. Added timing report data structures and focused tests.
   - `tools/lib/ci_timing.sh` records check id, display name, command id, mode, start time, end time, duration seconds, exit status, command hash, input hash, policy hash, repository-state hash, evidence-use state, workflow/job/run identity, and commit SHA.
   - `tools/test_ci_timing.sh` validates success recording, failure recording, marker safety, proposal generation, and read-only behavior.

2. Attached timing report generation to the final common aggregate and full-hooks checks.
   - The `Lesson aggregate test` step runs through `tools/ci-timing run lesson_aggregate`.
   - The `Git hooks full no-cache regression` step runs through `tools/ci-timing run git_hooks_full_no_cache`.
   - The job uploads the timing report as `ci-timing-${{ github.run_id }}-${{ github.run_attempt }}`.

3. Improved CI status targeting.
   - `tools/check_ci_status.sh` can target workflow identity and run id.
   - When run from this lesson repository with `--required` and no explicit workflow, it requires both `CI` and `Lesson14 CI` for the target branch/commit.
   - It checks job status and conclusion for the selected required run.
   - Calls from product or other repositories preserve the narrower single-workflow behavior.

4. Added read-only improvement proposal generation.
   - `tools/ci-timing propose` reports slow checks, same-run evidence candidates, and parallelization candidates.
   - Proposals include reason, affected files, required verification, and developer-approval requirement.
   - The command never edits workflow or policy files.

5. Connected tests and policies.
   - Added `test_ci_timing` to Git hook checks, parallel groups, final-gate coverage, Test Plan Manifest, CI syntax checks, CI policy regression checks, and aggregate repository tests.
   - Updated `tools/check_ci_workflow_structure.sh` and `tools/test_ci_pipeline_acceleration.sh` so workflow timing integration is mechanically checked.

6. Preserved future approval gates.
   - Same-run evidence reuse expansion remains fail-closed and recommendation-only unless a later approved implementation changes strict rerun behavior.
   - Full hook parallel-group refinement remains policy-driven.
   - Conditional `full no-cache` operation remains disabled until developer approval.

### Verification Plan

```bash
git diff --check
./tools/check_ci_workflow_structure.sh
./tools/test_ci_timing.sh
./tools/test_ci_pipeline_acceleration.sh
./tools/test_ci_evidence.sh
./tools/test_ci_final_gate.sh
./tools/test_git_hooks_parallel.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/test_lesson_repository.sh
```

### Recovery Plan

- If timing output destabilizes CI, make timing collection non-authoritative and keep the existing strict checks running.
- If CI status targeting misses a valid required workflow, split workflow selection, run selection, and commit matching into separate validated functions.
- If proposal generation overstates safety, keep it read-only and add stricter candidate classification.
- If same-run evidence reuse is ambiguous, disable reuse for that check and run the strict command.
- If parallel grouping produces nondeterministic output or shared-state collisions, move that check back to serial policy.
- If any existing-feature tradeoff appears necessary, stop and request developer approval with reason, impact, alternatives, and rollback path.

### Developer Approval Gates

- Approval is required before implementing a generated CI improvement proposal.
- Approval is required before reducing or conditionally skipping `full no-cache`.
- Approval is required before changing required workflow or job names.
- Approval is required before caching verification results across commits, branches, workflow runs, repositories, or users.
- Approval is required before accepting any existing-feature tradeoff.

## Implemented CI Aggregate And Full-Hooks Split Implementation Plan

SYNC-ID: ci_aggregate_full_hooks_split
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,tools/check_ci_workflow_structure.sh,tools/test_ci_pipeline_acceleration.sh,tools/check_as_built_sync_contract.sh,tools/ci-timing,tools/test_ci_timing.sh,tools/lib/ci_evidence.sh,tools/test_ci_evidence.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_ci_workflow_structure.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_timing.sh,tools/test_ci_evidence.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

This implementation applies the approved first CI acceleration candidate from the measured timing work: split the main `CI` final common verification job into parallelizable jobs and a strict final gate.
It is intentionally limited to job scheduling and evidence handoff; it does not change cache policy, full/no-cache scope, or authoritative check coverage.

### Implemented Change Targets

- Replace the main `CI` workflow `aggregate-and-full-hooks` job with `lesson-aggregate`, `git-hooks-full-no-cache`, and `final-gate`.
- Keep both split jobs behind the same prerequisite gates that previously fed the combined final job.
- Keep `tools/test_lesson_repository.sh --use-evidence --write-evidence` in `lesson-aggregate`.
- Keep `tools/git-hooks run --mode full --no-cache --jobs 4` in `git-hooks-full-no-cache`.
- Upload same-run Git hook evidence from `git-hooks-full-no-cache` and require it in an always-started `final-gate` that validates split prerequisite results and expected evidence source before evidence verification.
- Preserve timing reports by uploading split timing parts with distinct report filenames and merging them into the existing final timing artifact.
- Keep `CI_TIMING_REPORT` local to `tools/ci-timing` report recording and out of the wrapped command environment.
- Keep same-run evidence artifact filenames safe for GitHub artifact upload while preserving original evidence ids in metadata.
- Update `tools/check_ci_workflow_structure.sh` and `tools/test_ci_pipeline_acceleration.sh` so the split is mechanically checked.
- Keep `Lesson14 CI` compatibility contexts intact; a stable compatibility marker and structure checks may point at the main `CI` split without rerunning common heavy work.

### Implemented Order

1. Synchronized the approved scope into the as-built contract and the five synchronized documents.
2. Updated the main `CI` workflow jobs and evidence/timing artifact handoff.
3. Updated workflow structure checks to require the new job graph, no-cache command, evidence requirement, and timing-part merge.
4. Updated the focused acceleration test to reject unsafe setup regressions and require the split wiring.
5. Complete synchronization, structure, focused CI, aggregate, full/no-cache, and pre-commit verification before commit and push.
6. Complete sub-agent review for requirements/specification consistency and CI implementation safety before final remote verification.

### Verification Plan

```bash
git diff --check
./tools/check_ci_workflow_structure.sh
./tools/test_ci_pipeline_acceleration.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/test_ci_timing.sh
./tools/test_ci_evidence.sh
./tools/test_ci_final_gate.sh
./tools/test_lesson_repository.sh
./tools/git-hooks run --mode full --no-cache --jobs 4
.githooks/pre-commit
./tools/check_ci_status.sh --required
```

### Recovery Plan

- If the split job graph loses coverage, restore the combined final job and keep the timing evidence for a narrower redesign.
- If split prerequisite results or same-run evidence cannot be validated in `final-gate`, fail closed and restore strict rerun behavior before reporting PASS.
- If timing artifact merging fails, keep strict verification and fix artifact names or download patterns before push.
- If required check contexts are affected, restore compatibility contexts and request developer approval before changing names.
- If any existing-feature tradeoff appears necessary, stop and request developer approval with reason, impact, alternatives, and rollback path.

### Developer Approval Gates

- Approval is required before changing required workflow or job names beyond the approved main `CI` split.
- Approval is required before reducing or conditionally skipping `full no-cache`.
- Approval is required before adding persistent verification-result caching.
- Approval is required before splitting Git hooks into a group matrix.
- Approval is required before making changed-only CI authoritative.
- Approval is required before accepting any existing-feature tradeoff.

## Implemented Dashboard Control Center Data Layer Implementation Plan

SYNC-ID: dashboard_control_center_data_layer
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,tools/check_ci_workflow_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

This implementation adds the read-only JSON data layer behind an AI-driven development control center.
The first runtime phase creates the data layer before any React or browser UI work.
The current synchronized state includes the schema source, shared dashboard-data helpers, `tools/dashboard-data`, focused tests, aggregate wiring, Git hooks wiring, CI syntax and policy wiring, and no browser UI dependency or UI action execution.

### Implemented Change Targets

- Keep `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv` as the implemented source for JSON fields, source groups, allowed state vocabulary, and safety requirements.
- Keep `tools/test_dashboard_schema.sh` as the standalone and aggregate-callable schema drift guard.
- Add `tools/lib/dashboard_data.sh` for reusable JSON escaping, status vocabulary validation, source tracking, partial failure collection, and command-preview construction.
- Add `tools/dashboard-data` as the read-only JSON producer.
- Add `tools/test_dashboard_data.sh` as a standalone-callable and aggregate-callable focused regression test.
- Connect the focused test through `tools/test_lesson_repository.sh`, Git hooks, pre-commit, CI, and the sync contract after the runtime artifacts exist.
- Keep `tools/dashboard` human-readable and backward-compatible unless the developer approves a separate JSON mode.
- Keep future React/Vite mechanics hidden behind the dashboard control-center surface so ordinary users do not have to understand Vite commands, dev-server URLs, package scripts, or frontend internals.
- Design the future UI/UX so non-engineer users perform one action only: open the dashboard/control center through the provided entry point, with setup, Vite startup, URL discovery, JSON data loading, and check orchestration handled by maintained tooling.
- Design the future control panel for two audiences: plain-language lesson content/progress/management for non-engineers, and precise workflow content/progress/management, gate, evidence, and next-action detail for intermediate and senior engineers doing practical work.
- Treat lessons and workflows as two first-class repository surfaces: future UI work must group, label, and prioritize them separately while keeping both surfaces easy to scan, understand, and operate.

### Implemented Phase Summary

1. Synchronized the plan first.
   - Recorded the sync ID in the as-built sync contract and the five synchronized documents.
   - Kept runtime artifacts out of the contract until they were created.
   - Validated the schema through `tools/test_dashboard_schema.sh`.

2. Stabilize the JSON contract.
   - Confirm the required top-level fields, nested sections, concise guidance items, completed-lesson representation, state vocabulary, and source attribution.
   - Keep `policy ready`, `settings ready`, `gate passed`, `approval required`, `optional`, `cached`, and `unknown` as separate concepts.

3. Implement reusable helpers.
   - Put reusable JSON and dashboard-data helpers under `tools/lib/`.
   - Reuse existing lesson, menu prerequisite, Git workflow, product-security, resource, CI evidence, and as-built sources instead of copying logic into the UI.

4. Implement the read-only CLI.
   - Add `tools/dashboard-data` to emit JSON only.
   - Keep optional or slow checks as `partial_failures` with required follow-up commands rather than failing the entire snapshot.
   - Do not execute dangerous operations; only preview command intent, target, risk, and approval requirement.

5. Add focused tests.
   - Validate JSON syntax, schema version, source files, concise guidance items, completed-lesson representation, allowed state vocabulary, partial failures, policy/gate separation, command-preview safety, and secret-like data redaction.
   - Use fixtures where possible so tests do not depend on a specific product stack, current wording, network availability, or live GitHub state.

6. Wire the checks after runtime implementation.
   - Added the focused dashboard-data test to aggregate validation, Git hooks, pre-commit, CI, and the as-built sync contract only after the test and runtime files existed.
   - Preserve current full/no-cache, CI, lesson, product-security, resource, Git workflow, docs-tour, and as-built checks.

7. Defer React/Vite.
   - Introduce React/Vite only after the JSON contract and tests are stable.
   - Keep the initial browser dashboard read-only and driven by JSON, not by parsing CLI prose.
   - Present any future React/Vite UI through the dashboard control center; keep Vite startup and build mechanics out of the ordinary learner-facing workflow.
   - Preserve the one-action user path: open the control center, without asking ordinary users to run npm scripts, choose ports, paste URLs, or invoke data/check commands manually.
   - Preserve practical workflow depth: future UI work must not flatten gates, evidence, blockers, approvals, or next operational actions into vague learner-only status labels.
   - Preserve the lesson/workflow split in navigation and status hierarchy so the control panel does not confuse learning progress with operational workflow progress.

### Document Synchronization Policy

- Requirements describe what the data layer must and must not do.
- Specification defines the JSON contract, state vocabulary, source boundaries, and safety rules.
- Implementation plan records phase order, future files, tests, recovery, and approval gates.
- `docs/workflow/TASK_TRACKER.md` records current implemented state and next implementation tasks.
- `docs/workflow/HANDOFF.md` records restart context, approval-sensitive decisions, and recovery rules.
- The five synchronized documents must share the same `SYNC-ID`, `STATUS`, `ARTIFACTS`, and `TESTS` values, while keeping prose role-specific.

### Verification Plan

Current runtime verification:

```bash
git diff --check
./tools/test_dashboard_data.sh
./tools/test_dashboard_schema.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_ci_workflow_structure.sh
./tools/check_workflow_pair_sync.sh
./tools/test_lesson_repository.sh
```

Full completion verification:

```bash
./tools/test_dashboard_data.sh
./tools/test_dashboard_schema.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_ci_workflow_structure.sh
./tools/test_lesson_repository.sh
./tools/git-hooks run --mode full --no-cache
.githooks/pre-commit
```

### Recovery Plan

- If document synchronization fails, fix the five `SYNC-ID` blocks and contract row before changing runtime files.
- If JSON generation fails, keep `tools/dashboard-data` read-only and return valid JSON with `partial_failures` where safe.
- If a source command is slow, flaky, or network-dependent, make it optional or evidence-backed instead of blocking the dashboard snapshot.
- If secret-like data, raw logs, absolute paths, or external payloads leak into JSON, fail the focused test and redact at the owner data layer.
- If the browser UI starts duplicating source-of-truth logic, move the logic back to shared CLI/helper code.
- If any existing-feature tradeoff appears necessary, stop, do not accept the tradeoff, and redesign around alternatives that preserve existing behavior.

### Developer Approval Gates

- Approval is required before choosing `tools/dashboard --format json` instead of a separate `tools/dashboard-data` command.
- Runtime dashboard data-layer implementation was developer-approved for this cycle; further scope expansion still requires approval.
- Approval is required before adding React/Vite dependencies or changing package scripts.
- Approval is required before adding command execution buttons or any operation beyond read-only command previews.
- Approval is required before making live network, CI, or GitHub status authoritative for dashboard rendering.
- Approval is required before changing existing `tools/dashboard` output semantics.
- Approval is required before selecting among redesign alternatives when an apparent existing-feature tradeoff is encountered; accepting the tradeoff is not allowed.

## Implemented Dashboard Control Center React UI Implementation Plan

SYNC-ID: dashboard_control_center_react_ui_plan
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/dashboard-data,package.json,package-lock.json,vite.config.mjs,dashboard-control-center/index.html,dashboard-control-center/src/main.jsx,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/styles.css,tools/dashboard,tools/dashboard-control-center,tools/test_dashboard_control_center.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_lesson_playwright.sh,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,tools/check_ci_workflow_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_lesson_playwright.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_ci_workflow_structure.sh

This implementation turns the implemented read-only dashboard JSON layer into a browser control center after developer approval for React/Vite dependencies, package scripts, runtime files, maintained entry tooling, and browser test wiring.
It remains additive and does not replace `tools/dashboard`, parse `tools/dashboard` prose, run UI actions, make frontend state authoritative, or weaken existing lessons, checks, CI, pre-commit, docs, or sync behavior.

### Implemented Change Targets

- Added a React/Vite browser UI after developer approval for dependency and package-script changes.
- Keep `tools/dashboard-data` as the data contract and keep `tools/dashboard` as the human-readable CLI compatibility surface.
- Added reusable frontend adapters for dashboard JSON so components consume schema fields and state vocabulary rather than current prose wording.
- Added control-center sections for summary, lessons, workflows, maintenance, security, and action previews.
- Kept the initial UI read-only and preview-only for commands.
- Added `tools/dashboard control-center` and `tools/dashboard-control-center` as the maintained dashboard entry tooling.
- Added standalone-callable and aggregate-callable browser/layout checks through `tools/test_dashboard_control_center.sh`.

### Implemented Order

1. Kept the UI sync separate from the implemented data-layer sync.
   - Preserve `dashboard_control_center_data_layer` as implemented.
   - Mark `dashboard_control_center_react_ui_plan` as implemented only after runtime files and tests exist.

2. Confirmed approval gates before runtime work.
   - Added React/Vite dependencies, package scripts, browser runtime files, generated build output rules, and browser test wiring under the developer-approved implementation request.
   - Stopped and corrected review findings where data/schema or sync boundaries were incomplete.

3. Introduced the frontend contract layer.
   - Built adapters around dashboard JSON fields, source attribution, allowed status values, guidance items, blockers, and command previews.
   - Keep adapter logic generic over the schema instead of special-casing the current product stack or current display text.
   - Extended and tested the dashboard data schema/producer for lesson points, warnings, and next learning actions before treating them as UI fields.

4. Implemented read-only UI sections.
   - Summary: mode, concise guidance, blockers, next safe action.
   - Lessons: 7-day, 14-day, applied lesson progress, points, warnings, and next learning action.
   - Workflows: product/workflow state, Git sync, CI, gates, evidence, approvals, blockers, and next operational action.
   - Maintenance and security: as-built sync, workflow pair sync, developer-memory, repo-local skills, policy/gate separation, and preview-only command guidance.

5. Hid Vite mechanics behind maintained tooling.
   - Ordinary users get a single dashboard/control-center entry action.
   - Maintained tooling handles server startup, URL selection, JSON generation, and check orchestration without requiring ordinary users to invoke npm scripts or parse Vite details.

6. Added runtime checks after artifacts exist.
   - Added focused UI rendering/layout checks that run standalone.
   - Wired them into aggregate tests, Git hooks, pre-commit, CI, final-gate coverage, and sync contract after the files exist.

### Document Synchronization Policy

- Requirements describe purpose, problems, scope, non-scope, existing-feature impact, document updates, tests, and risks.
- Specification describes the UI sections, data handling, UX constraints, and implemented verification boundaries.
- Implementation plan describes change targets, order, verification, recovery, and approval gates.
- `docs/workflow/TASK_TRACKER.md` records implemented state and remaining approval-only boundaries.
- `docs/workflow/HANDOFF.md` records restart context and safety-sensitive decisions.

### Verification Method For This Sync

```bash
git diff --check
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_control_center.sh
./tools/test_lesson_playwright.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_ci_workflow_structure.sh
./tools/test_lesson_repository.sh
./tools/git-hooks run --mode full --no-cache --jobs 4
.githooks/pre-commit
```

After commit and push, required remote `CI` and `Lesson14 CI` must pass, and local/remote sync must match.

### Recovery Plan

- If sync checks fail, correct the five document blocks and contract row before changing runtime scope.
- If dashboard schema/data/UI tests fail, fix the data-layer contract, UI adapter, or this plan so the UI remains contract-driven.
- If future frontend work duplicates owner-layer checks, move the logic back to shared CLI/helper code.
- If future UI hides workflow gates, evidence, blockers, approvals, or next actions, redesign the component model before implementation.
- If Vite mechanics leak into ordinary user workflow, keep the UI behind maintained tooling and update the entry plan.
- If any existing-feature tradeoff appears necessary, stop and redesign; accepting the tradeoff is not allowed.

### Developer Approval Gates

- Approval has been used for the initial React/Vite dependencies, package scripts, maintained entry tooling, browser runtime files, and browser test wiring.
- Approval is required before adding action execution from the UI.
- Approval is required before making live network, CI, or GitHub status authoritative for rendering.
- Approval is required before changing existing `tools/dashboard` semantics or replacing `tools/dashboard-data`.
- Approval is required before accepting any design alternative that would weaken existing lessons, workflows, checks, CI, pre-commit, docs, or sync behavior.

## Implemented Dashboard Control Center Information Architecture Implementation Plan

SYNC-ID: dashboard_control_center_information_architecture
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,vite.config.mjs,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

This implemented follow-up organizes the dashboard wall-bouncing conclusions into a scoped UI improvement.
It preserves the implemented dashboard JSON data layer, the initial read-only React/Vite UI, existing lessons, CI, checks, document routes, Git hooks, pre-commit, and owner-layer safety logic.

### Implemented Change Targets

- `dashboard-control-center/mocks/archive/mock-categorized-dashboard.png`
  - Keep the generated mock as a visual design reference for category navigation, Overview-first information hierarchy, and Safety Actions isolation.
- `dashboard-control-center/src/App.jsx`
  - Replace the one-page vertical section stack with category navigation and Overview-first rendering.
  - Keep lessons, development workflow, maintenance sync, security, and command previews as separate render surfaces.
  - Keep command previews visible only in Safety Actions and only as preview-only/non-executable data.
- `dashboard-control-center/src/i18n.js`
  - Add reusable fixed-label localization for `en` and `ja` with English fallback.
  - Keep data-derived text out of browser translation.
  - Add locale-aware generated-time and relative-age formatting.
- `dashboard-control-center/src/styles.css`
  - Rework layout to match the mock direction with a sidebar, status strip, overview grid, category health cards, compact cards, and responsive constraints.
- `tests/playwright/dashboard-control-center.spec.js`
  - Update browser tests to verify categorized navigation, Overview-first behavior, Safety Actions command isolation, fixed-label localization, no command-execution buttons, redaction, and mobile layout.
- `tools/test_dashboard_control_center.sh`
  - Keep the check as the standalone and aggregate entry point for the React/Vite control-center regression.

### Implemented Order

1. Organize the proposal.
   - Purpose: make the dashboard understandable and scannable without weakening read-only safety.
   - Problems: one-page overload, command previews too visible on first screen, English-only fixed labels, and weak snapshot freshness cues.
   - Scope: categories, `en`/`ja` fixed UI labels, snapshot generated time and age, and Safety Actions isolation.
   - Non-scope: automatic updates, command execution, live authoritative CI/Git, and broad localization.

2. Preserve owner-layer and data boundaries.
   - Leave `tools/dashboard-data` and the dashboard JSON schema as the data boundary.
   - Do not parse `tools/dashboard` prose.
   - Do not move Git, CI, Security guard, approval, or gate truth into React.

3. Implement category UI.
   - Add Overview, Lessons, Development Workflow, Maintenance Sync, and Safety Actions navigation.
   - Render Overview by default.
   - Move command previews out of Overview and into Safety Actions.

4. Implement fixed-label localization.
   - Detect the browser language through `navigator.languages`.
   - Use `ja` labels for Japanese device language and English otherwise.
   - Preserve technical/data text as source data.

5. Implement snapshot freshness display.
   - Show `generated_at` formatted with browser locale APIs.
   - Show relative snapshot age as display context, not as an authoritative stale gate.

6. Update tests and synchronization.
   - Update Playwright tests to assert behavior and boundaries rather than a single wording stack.
   - Sync the new implementation through the as-built contract, requirements, specification, implementation plan, task tracker, and handoff.

### Document Synchronization Policy

- Requirements record the implementation proposal: purpose, problems, target scope, non-scope, existing-feature impact, required document updates, tests, and risks.
- Specification records the implemented category, localization, safety, data-boundary, visual, and verification behavior.
- Implementation plan records changed files, order, document sync, verification, recovery, and approval-gate boundaries.
- `docs/workflow/TASK_TRACKER.md` records completed work and intentionally deferred future phases.
- `docs/workflow/HANDOFF.md` records restart context and safety-sensitive constraints for the next agent.

### Verification Method

The `TESTS` field for this sync ID lists directly wired standalone checks required by the as-built sync contract.
`tools/test_lesson_repository.sh`, full/no-cache Git hooks, `.githooks/pre-commit`, and `tools/ci-final-gate` remain final verification and runtime evidence, not `required_tests` entries, because the sync-contract checker requires each `required_tests` command to be directly wired in the repository test surfaces.

```bash
git diff --check
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_control_center.sh
./tools/test_lesson_playwright.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_ci_workflow_structure.sh
./tools/test_lesson_repository.sh
./tools/git-hooks run --mode full --no-cache --jobs 4
.githooks/pre-commit
./tools/ci-final-gate
```

### Failure Recovery

- If UI tests fail, inspect whether the failure is layout/navigation behavior, localization behavior, data-boundary behavior, or Playwright selector ambiguity; fix the implementation or test intent without weakening safety assertions.
- If as-built sync fails, update the contract and all five synchronized documents to the same sync ID, status, artifacts, and tests.
- If existing dashboard, lesson, CI, Git hooks, pre-commit, schema, or data tests fail, treat it as a regression and restore existing behavior before proceeding.
- If a fix appears to require browser command execution, live authoritative CI/Git status, broad localization, or existing-feature tradeoff, stop and request developer approval.

### Developer Approval Boundaries

- Automatic updates, polling, WebSocket/live updates, browser-triggered checks, command execution, live authoritative CI/Git status, broader multi-language coverage, data-schema localization fields, and any change to existing `tools/dashboard` semantics remain separate future phases.
- Existing-feature tradeoffs are not allowed and cannot be approved as a normal implementation choice.

## Implemented Dashboard Control Center Visual Polish Implementation Plan

SYNC-ID: dashboard_control_center_visual_polish
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

This implementation refines the categorized dashboard to look closer to the generated mock while preserving the existing information architecture, read-only safety, data contract, tests, CI, pre-commit, and document routes.

### Implemented Change Targets

- `dashboard-control-center/src/App.jsx`
  - Add display structure needed for mock-like health cards, category shortcut cards, and sidebar metadata.
  - Keep navigation, Safety Actions, and command-preview behavior unchanged.
- `dashboard-control-center/src/i18n.js`
  - Add fixed UI labels for visual-polish elements such as Explore Pages and last-updated context.
- `dashboard-control-center/src/styles.css`
  - Tune the sidebar, status strip, overview grid, health cards, Explore Pages cards, spacing, borders, subtle depth, and responsive layout.
- `tests/playwright/dashboard-control-center.spec.js`
  - Add structure-oriented visual assertions for segmented status, desktop 2x2 health cards, Explore Pages cards, mobile stability, and safety isolation.
- Synchronized documents
  - Add a separate sync ID so visual polish remains distinct from data, React UI, and information architecture layers.

### Implementation Order

1. Preserve current safety boundaries.
   - Do not add command execution, polling, live CI/Git authority, schema changes, or new dependencies.
   - Keep command previews only under Safety Actions.

2. Adjust markup for reusable visual components.
   - Add sidebar generated-time context.
   - Add compact health-card body and status-ring structure.
   - Add Explore Pages shortcut cards using the existing category model.

3. Apply CSS polish.
   - Convert the top status area into a segmented strip.
   - Use a 2x2 health-card grid on desktop.
   - Tune card density, borders, shadows, typography scale, and responsive breakpoints.
   - Preserve 8px card radii and stable dimensions.

4. Update tests.
   - Keep existing read-only and localization tests.
   - Add layout structure assertions without pixel-perfect image matching.
   - Keep `tools/test_dashboard_control_center.sh` as the standalone and aggregate entry point.

5. Verify and review.
   - Run targeted UI tests first, then sync checks and aggregate checks.
   - Use sub-agent review for requirements/spec/plan alignment, UI/visual fit, safety boundaries, and test sufficiency.

### Document Synchronization Policy

- Requirements capture purpose, problems, target scope, non-scope, existing impact, tests, and risks.
- Specification captures visual behavior, layout constraints, safety constraints, and verification behavior.
- Implementation plan captures file targets, order, verification, recovery, and approval gates.
- `TASK_TRACKER.md` captures completed work and deferred future phases.
- `HANDOFF.md` captures restart context and the boundary between mock-aligned polish and future live/action work.

### Verification Method

```bash
git diff --check
./tools/test_dashboard_control_center.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_ci_workflow_structure.sh
./tools/test_lesson_repository.sh
./tools/git-hooks run --mode full --no-cache --jobs 4
.githooks/pre-commit
./tools/ci-final-gate
```

### Failure Recovery

- If visual tests fail, distinguish layout regression from brittle selectors; fix structure or tests without weakening safety checks.
- If mobile overflow appears, reduce fixed widths and preserve responsive constraints.
- If Japanese labels overflow, adjust layout or wrapping rather than hard-coding language-specific branches.
- If visual polish hides safety details or creates command-like affordances, restore the previous read-only category behavior and redesign.
- If sync checks fail, fix the contract and all five synchronized documents before further runtime changes.

### Developer Approval Boundaries

- Automatic refresh, broad localization, live CI/Git authority, UI-triggered checks, command execution, new dependencies, and any existing-feature tradeoff remain outside this phase.

## Implemented Dashboard Control Center Mock Parity Implementation Plan

SYNC-ID: dashboard_control_center_mock_parity
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/fixtures/dashboard-control-center-invalid.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

This plan is synchronized as an implemented follow-up to the implemented visual-polish layer.
It implements mock parity through structured dashboard data and reusable UI components, not through fixed mock values.

### Implemented Change Targets

- `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv` for category metrics, structured primary action, and failure/follow-up separation.
- `tools/lib/dashboard_data.sh` and `tools/dashboard-data` for producer-owned metric calculation and safe JSON output.
- `dashboard-control-center/src/dashboardData.js` for validation of the new fields.
- `dashboard-control-center/src/App.jsx`, `dashboard-control-center/src/i18n.js`, and `dashboard-control-center/src/styles.css` for mock-aligned compact cards, progress rings, issue summaries with detail-page navigation, and Explore Pages metrics.
- `tests/fixtures/dashboard-control-center.json`, `tests/fixtures/dashboard-control-center-live-update.json`, `tests/fixtures/dashboard-control-center-invalid.json`, and Playwright tests for data-driven visual structure, alternate metrics, and invalid refresh behavior.
- `tools/test_dashboard_schema.sh`, `tools/test_dashboard_data.sh`, `tools/test_dashboard_control_center.sh`, and aggregate wiring for standalone and full validation.

### Implemented Order

1. Extend the schema and producer with metric and primary-action fields.
2. Update frontend validation so unsupported or malformed data fails closed.
3. Refactor the Overview UI into compact primary-action, issue-preview, metric-ring, and Explore Pages components.
4. Update localization labels only for fixed UI chrome.
5. Add tests proving that percentages and counts come from fixture or producer data rather than fixed mock values.
6. Replace any global no-buttons assertion with no command-execution controls, because read-only navigation and summaries are permitted controls.
7. Run sync, structure, targeted UI, data, and aggregate checks.

### Document Synchronization Policy

- Requirements describe why mock parity is needed and what is out of scope.
- Specification describes the schema-owned data and UI behavior.
- Implementation plan describes files, order, validation, recovery, and approval gates.
- Task tracker records planned, in-progress, and implemented status.
- Handoff records restart context and known boundaries.

### Verification Method

The `TESTS` field for this sync ID lists directly wired standalone checks required by the as-built sync contract.
`tools/test_lesson_repository.sh`, full/no-cache Git hooks, `.githooks/pre-commit`, and `tools/ci-final-gate` remain final verification and runtime evidence, not `required_tests` entries, because the sync-contract checker requires each `required_tests` command to be directly wired in the repository test surfaces.

```bash
git diff --check
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_control_center.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_ci_workflow_structure.sh
./tools/test_lesson_repository.sh
```

### Failure Recovery

- If schema validation fails, correct the producer/schema boundary before changing UI.
- If visual tests become pixel-brittle, replace them with structure and data-flow assertions without weakening safety checks.
- If percentages appear fixed, move calculation into the producer or fixture and assert alternate fixture values.
- If optional checks are misrepresented as partial failures, separate them into manual follow-ups before rerunning.
- If Overview detail navigation conflicts with safety tests, keep read-only detail access and tighten tests around executable actions instead.
- If existing 7-day, 14-day, CI, hook, or document checks regress, stop and restore compatibility before continuing.

### Developer Approval Boundaries

- Approval is required before accepting any existing-feature tradeoff.
- Approval is required before broadening localization beyond the current `en`/`ja` fixed-label boundary.
- Approval is required before adding new dependencies.
- Approval is required before making the mock image a pixel-perfect correctness gate.
- Approval is required before changing command-preview safety or browser execution boundaries.

## Implemented Dashboard Control Center Live Snapshot Sync Implementation Plan

SYNC-ID: dashboard_control_center_live_snapshot_sync
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/dashboard-control-center,vite.config.mjs,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/fixtures/dashboard-control-center-invalid.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

This plan is synchronized as an implemented separate read-only refresh layer.
It follows mock parity because live refresh should move validated schema-owned data, not UI-invented values.

### Implemented Change Targets

- `tools/dashboard-control-center` for atomic snapshot writing and refresh while the Vite server is open.
- `tools/dashboard-data` and `tools/lib/dashboard_data.sh` for mandatory producer-owned `snapshot_id` and `content_hash`.
- `dashboard-control-center/src/dashboardData.js` for validated snapshot fetches and signature handling.
- `dashboard-control-center/src/App.jsx` and `dashboard-control-center/src/styles.css` for in-place refresh, stale status, and last-known-good UI.
- Playwright fixtures and tests for live update, failed refresh, no reload, and no browser command execution.
- Existing standalone and aggregate test entry points for reusable verification.

### Implemented Order

1. Add mandatory producer-owned `snapshot_id` and `content_hash` to the dashboard JSON contract.
2. Implement atomic snapshot writing in the control-center shell entry point.
3. Add a configurable refresh loop to `tools/dashboard-control-center open`.
4. Update the React app to poll the dashboard JSON endpoint with GET and keep last-known-good data on refresh failure.
5. Add deterministic Playwright tests for changed data and failed refresh.
6. Add static safety checks for browser execution boundaries.
7. Run targeted, sync, structure, aggregate, hook, pre-commit, and CI/final-gate checks as needed.

### Document Synchronization Policy

- Keep live refresh separate from command execution and real CI/Git authority.
- Keep the schema and producer as the data owner.
- Record any future UI-triggered command work as a separate sync ID and approval-gated phase.

### Verification Method

```bash
git diff --check
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_control_center.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_ci_workflow_structure.sh
./tools/test_lesson_repository.sh
./tools/git-hooks run --mode full --no-cache
.githooks/pre-commit
./tools/ci-final-gate
```

### Failure Recovery

- If atomic writing fails, keep the previous snapshot writer and stop before enabling live refresh.
- If polling produces flaky tests, move the test to deterministic fixture sequencing rather than increasing sleeps.
- If invalid JSON blanks the UI, restore last-known-good behavior before continuing.
- If the browser gains any command execution, non-GET dashboard-data fetch, or `tools/*` fetch path, remove it and rerun safety checks.
- If existing checks regress, restore the previous read-only snapshot behavior and request approval if a tradeoff appears unavoidable.

### Developer Approval Boundaries

- Approval is required before browser-triggered checks, POST/PUT/PATCH/DELETE requests, WebSocket/server push, GitHub API calls, Git/CI authority, or command execution.
- Approval is required before new dependencies.
- Approval is required before changing existing CI, pre-commit, Git hooks, 7-day, or 14-day behavior.
- Approval is required before accepting any stale-data behavior that hides validation failure.

## Implemented Dashboard Control Center Mock-Aligned Overview Implementation Plan

SYNC-ID: dashboard_control_center_mock_aligned_overview
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

This plan is synchronized as a visual and interaction follow-up to mock parity and live snapshot sync.
It preserves the existing data producer, schema validation, read-only browser boundary, and live refresh behavior.

### Implemented Change Targets

- `dashboard-control-center/src/App.jsx` for Overview hierarchy, accessible title handling, mock-aligned Next Safe Action structure, global mock-aligned icon placement, stable Partial Failures none state, manual follow-up summary placement, bottom notice, and non-expanding summary navigation.
- `dashboard-control-center/src/i18n.js` for fixed UI labels, none-state text, manual follow-up summary text, and repository-control-panel notice text.
- `dashboard-control-center/src/styles.css` for mock-aligned spacing, four health-ring category colors, left icons, health-card height alignment, stable summary cards, responsive layout, and accessible visually hidden title support.
- `tests/fixtures/dashboard-control-center.json` and `tests/fixtures/dashboard-control-center-live-update.json` for non-empty and empty Partial Failures coverage without fixed mock values.
- `tests/playwright/dashboard-control-center.spec.js` and `tools/test_dashboard_control_center.sh` for standalone browser verification.

### Implemented Order

1. Synchronized this sync ID into the sync contract and five synchronized documents.
2. Ran sync and structure checks before runtime changes.
3. Removed the visible main header and snapshot explanation while preserving an accessible page title.
4. Refactored `PrimaryActionCard` into the mock-aligned safe-action structure with the heading/helper outside the green primary action row and white metadata rows below it.
5. Replaced Overview issue-preview expansion with stable summary cards.
6. Rendered Partial Failures as an always-present summary with a none state when empty.
7. Moved manual follow-ups into a third-row summary card with concise count, representative context, and detail navigation.
8. Removed the visible Category Health heading and preserved the accessible category-health region.
9. Aligned the four health-card heights inside the grid.
10. Added decorative left icons to navigation, status, repeated cards, summaries, detail rows, and command previews without adding command affordances.
11. Applied distinct category colors to the four health rings.
12. Added the repository-control-panel read-only notice at the Overview bottom.
13. Updated Playwright assertions for structure, global icons, four health-ring colors, no-overflow, localization, live refresh, and safety boundaries.
14. Ran targeted checks, sync checks, aggregate checks, full hooks, pre-commit, final gate, and sub-agent review as final verification.

### Document Synchronization Policy

- Requirements describe why the mock-aligned Overview is needed and what remains out of scope.
- Specification describes the Overview structure, stable summaries, icon behavior, and safety model.
- Implementation plan describes files, order, validation, recovery, and approval boundaries.
- Task tracker records planned, in-progress, and implemented status.
- Handoff records restart context, detail-link expectations, safety boundaries, and verification commands.

### Verification Method

```bash
git diff --check
npm run dashboard:build
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_control_center.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_ci_workflow_structure.sh
./tools/test_lesson_repository.sh
./tools/git-hooks run --mode full --no-cache --jobs 4
.githooks/pre-commit
./tools/ci-final-gate
```

### Failure Recovery

- If accessible heading coverage fails, restore a screen-reader-only `h1` rather than restoring visible header chrome.
- If mobile overflow appears, reduce fixed widths and preserve responsive constraints.
- If Partial Failures or manual follow-ups are confused, restore the data distinction before styling changes.
- If the Overview appears to execute commands or expose command previews outside Safety Actions, remove that affordance and rerun safety checks.
- If sync checks fail, fix the contract and all five synchronized documents before further runtime work.

### Developer Approval Boundaries

- Approval is required before any existing-feature tradeoff.
- Approval is required before changing command-preview isolation, browser command execution boundaries, live CI/Git authority, dependencies, CI/pre-commit semantics, or 7-day/14-day lesson behavior.

## Implemented Dashboard Control Center Detail-Page Mock Parity Implementation Plan

SYNC-ID: dashboard_control_center_detail_mock_parity
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/archive/mock-detail-lessons.png,dashboard-control-center/mocks/archive/mock-detail-workflow.png,dashboard-control-center/mocks/archive/mock-detail-maintenance.png,dashboard-control-center/mocks/archive/mock-detail-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

This implementation is synchronized as a visual and information-architecture follow-up to the approved Overview mock alignment.
It preserves the existing data producer, schema validation, read-only browser boundary, live refresh behavior, and category routes.
The approved detail mock images are treated as the UI/UX source of truth for hierarchy, density, color direction, and icon direction; automated tests validate structural parity and safety boundaries rather than pixel-perfect screenshots.

### Implemented Change Targets

- `dashboard-control-center/mocks/archive/mock-detail-lessons.png`, `mock-detail-workflow.png`, `mock-detail-maintenance.png`, and `mock-detail-safety.png` remain checked-in visual source references.
- `dashboard-control-center/src/App.jsx` adds shared detail page headers, decision summaries, workflow icon centralization, lesson inspection panels, workflow checklist rows, maintenance confirmation tables, safety failure tables, display-only command preview cards, and source-boundary panels.
- `dashboard-control-center/src/i18n.js` adds fixed decision-summary labels, page judgments, must-review labels, display-only labels, known source/intent display labels, and locale-resolution support that does not mix UI locale with lesson/workflow language settings.
- `dashboard-control-center/src/styles.css` adds category-colored detail summaries, mock-aligned panels/rows/tables, centered risk/status pills, responsive constraints, severity rails, command/reference chips, and read-only banners.
- `tests/playwright/dashboard-control-center.spec.js` verifies the implemented detail structure and safety boundaries through `tools/test_dashboard_control_center.sh`.
- The follow-up tightening keeps the same sync ID and artifacts while refining the category header icon presentation, first-row decision-summary content model, active sidebar category icon, workflow category icon glyph, maintenance/safety card icon containers, failure severity icons, and command-preview section grouping.
- Additional translated UI strings are added only through `dashboard-control-center/src/i18n.js`; React runtime code does not add Japanese-only literals and does not use lesson/workflow language settings as the dashboard UI locale.

### Implementation Order Completed

1. Synchronize this sync ID into the sync contract and five synchronized documents.
2. Run sync, test-plan, and CI-structure checks before runtime changes.
3. Added reusable helpers for detail page headers, decision summaries, item display metadata, source labels, command labels, and structured lesson attention labels without changing the dashboard data schema.
4. Added one centralized workflow category icon component using a branching `Network` icon and reused it across Overview, navigation, Explore Pages, and detail pages.
5. Tuned shared pill CSS so short localized labels are visually centered.
6. Refactored Lessons detail into the approved decision-summary and inspection-panel layout.
7. Refactored Development Workflow detail into must-review and ready checklist rows with human-readable titles and secondary technical keys.
8. Refactored Maintenance Sync detail into status cards, manual confirmation table, and source-boundary panel.
9. Refactored Safety Actions detail into safety status cards, Partial Failures table, and display-only Command Preview cards.
10. Updated Playwright assertions for detail summaries, icon consistency, readable labels, safety boundaries, centered short pills, and desktop/mobile no-overflow.
11. Targeted checks and final verification are run after synchronization before completion reporting.
12. Tighten mock parity for the approved detail-page references by adding decision-summary bullets, count badges, safe links, page-specific icon chrome, distinct safety severity glyphs, and compact read-only command preview grouping without changing the data schema or browser read-only boundary.

### Document Synchronization Policy

- Requirements describe the user-facing decision problems and out-of-scope boundaries.
- Specification describes shared detail-page structure, page-specific behavior, icon/color rules, and safety model.
- Implementation plan describes files, order, validation, recovery, and approval boundaries.
- Task tracker records planned, in-progress, and implemented status.
- Handoff records restart context, mock-image references, read-only boundaries, and verification commands.

### Verification Method

```bash
git diff --check
npm run dashboard:build
./tools/test_dashboard_control_center.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_ci_workflow_structure.sh
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_lesson_repository.sh
./tools/git-hooks run --mode full --no-cache --jobs 4
.githooks/pre-commit
./tools/ci-final-gate
```

### Failure Recovery

- If sync checks fail, fix the contract and all five synchronized documents before further runtime work.
- If decision summaries duplicate or contradict data, derive them from shared helpers and existing snapshot fields before styling changes.
- If workflow icon replacement creates ambiguity or import issues, keep one centralized workflow category icon component and use the closest lucide branching workflow icon to the approved mock rather than mixing multiple workflow icons.
- If mobile overflow appears, reduce fixed widths and preserve responsive constraints rather than adding language-specific branches.
- If technical traceability is lost, restore technical keys as secondary metadata, not primary headings.
- If command previews look executable or expose controls outside Safety Actions, remove the affordance and rerun safety checks.

### Developer Approval Boundaries

- Approval is required before any existing-feature tradeoff.
- Approval is required before changing dashboard data schema ownership, command-preview isolation, browser command execution boundaries, live CI/Git authority, dependencies, CI/pre-commit semantics, or 7-day/14-day lesson behavior.
- Approval is required before replacing the copied detail mock images or treating them as pixel-perfect test oracles.

## Acceptance Criteria

- Existing 7-day and 14-day flows still pass structure checks.
- Free Development Mode and Team Development/Docker are additive.
- Implementation preserves refactorability, ecosystem fit, reusability, and generality.
- No existing feature is traded away.
- Lesson-side tests pass without recreating `task-tracker-repository`.
- Product repository boundary, Git sync, and CI checks remain available for explicit real product operations testing.
- All as-built documents describe the same implemented state.
- Lesson repository test prints `Lesson repository test passed.`
- Every implemented developer-memory audit item is synchronized into the five planning/workflow documents and backed by a mechanical check.
- Planned developer-memory audit items are synchronized into the five planning/workflow documents without being described as runtime-implemented work.

## Planned Lesson Display Label Policy Implementation Plan

SYNC-ID: lesson_display_label_policy
STATUS: implemented
ARTIFACTS: docs/workflow/LESSON_DISPLAY_LABELS.tsv,tools/lib/lesson_display_labels.sh,tools/lib/lesson_common.sh,tools/lib/lesson_runtime.sh,tools/menu,tools/dashboard,tools/learn,tools/helpdesk,tools/lesson14,tools/roadmap,tools/docs-tour,README.md,AGENTS.MD,index.md,index-14-days.md,ai-driven-task-tracker-scenario.md,guides/LESSON_14_DAYS.md,learning/ROADMAP.md,lesson/LESSON_FLOW_14_DAYS.tsv,prompts/PROMPTS.md,prompts/PROMPTS_14_DAYS.md,playbooks/AGENT_PLAYBOOK.md,playbooks/AGENT_PLAYBOOK_14_DAYS.md,tools/check_learner_display.sh,tools/test_menu_prerequisites.sh,tools/check_lesson14_sync.sh,tools/check_agents_skills.sh
TESTS: tools/check_learner_display.sh,tools/test_menu_prerequisites.sh,tools/check_lesson14_sync.sh,tools/check_agents_skills.sh,tools/test_lesson14.sh

This plan is synchronized as `lesson_display_label_policy`.
It is runtime-implemented.
The implementation begins with display-policy separation rather than broad text replacement.

### Implemented Change Targets

- Added `docs/workflow/LESSON_DISPLAY_LABELS.tsv` as the reusable lesson display-label policy source.
- Added `tools/lib/lesson_display_labels.sh` so menu, dashboard, roadmap, lesson14 reset/runtime, learning-record, and helpdesk output resolve labels consistently.
- Updated `tools/menu` and `tools/dashboard` because they are the most visible learner entry points.
- Updated `tools/roadmap`, `tools/lesson14`, `tools/learn`, and `tools/helpdesk` normal output so internal aliases remain command compatibility, not learner-facing labels.
- Updated learner-facing README, AGENTS routing text, index files, guides, prompts, playbooks, roadmap text, and task-tracker scenario text so they no longer reproduce old duration labels.
- Extended `tools/check_learner_display.sh` to detect learner-facing old labels and broader Day variants while allowing approved internal and historical contexts.
- Updated `tools/test_menu_prerequisites.sh` so learner-facing label checks and internal compatibility checks are separate.

### Implemented Order

1. Defined the display-label policy and allowlist boundary.
   - Added final course labels to `docs/workflow/LESSON_DISPLAY_LABELS.tsv`.
   - Kept `Step N/14` as the current sync-gate key.

2. Introduced shared label resolution.
   - Avoided duplicating labels directly in menu, dashboard, roadmap, lesson14 reset/runtime, learn, and helpdesk commands.
   - Kept the helper reusable for future browser dashboard work.

3. Updated entry-point output.
   - Changed menu and dashboard learner-facing course names.
   - Preserved existing commands and compatibility paths.

4. Updated learner-facing docs and prompt surfaces.
   - Updated README, AGENTS.MD, index files, guides, prompts, playbooks, roadmap text, and scenario text only where they are active learner-facing guidance.
   - Kept filenames and command names unchanged.

5. Strengthened checks and tests.
   - Added active-surface checks for old learner-facing labels.
   - Covered the known gap where `tools/check_learner_display.sh` only detected narrower `Day N` style regressions.
   - Kept internal compatibility checks for `tools/lesson14`, `index-14-days.md`, `Step N/14`, and `dayN.*`.

6. Verified and iterated.
   - Run the targeted checks first, then aggregate lesson validation.
   - If a future check fails because it treats internal aliases as learner-facing labels, fix the policy boundary instead of weakening the check.

### Verification Plan

```bash
git diff --check
./tools/check_learner_display.sh
./tools/test_menu_prerequisites.sh
./tools/check_lesson14_sync.sh
./tools/test_lesson14.sh
./tools/check_agents_skills.sh
./tools/check_developer_memory_requirements.sh
./tools/as-built-sync status
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/test_lesson_repository.sh
```

### Recovery Plan

- If Lesson14 sync gates fail, restore `Step N/14` as the machine key and move learner-facing changes behind display-label resolution.
- If learner-display checks over-match historical records, add a policy-governed historical allowlist instead of editing past logs.
- If internal compatibility checks fail, restore command names, filenames, TSV keys, and test expectations before retrying learner-facing display changes.
- If AGENTS, skills, or developer-memory checks still require old course labels, split those checks into learner-facing label assertions and internal compatibility assertions.
- If any existing-feature tradeoff appears necessary, stop and request developer approval with reason, impact, alternatives, and rollback path.

### Developer Approval Gates

- Approval is required before changing the final course display labels recorded in `docs/workflow/LESSON_DISPLAY_LABELS.tsv`.
- Approval is required before changing the `Step N/14` sync-gate key contract.
- Approval is required before bulk-editing historical learning logs.
- Approval is required before changing `tools/lesson14`, `index-14-days.md`, `_14_DAYS` filenames, or `dayN.*` step IDs.
- Approval is required before weakening learner-display checks or existing sync-gate checks.
- Approval is required before accepting any existing-feature tradeoff.

## Implemented External Product Repository Authority Implementation Plan

SYNC-ID: external_product_repository_authority
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/test_product_repository_authority.sh,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/check_ci_workflow_structure.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

This implemented plan records the external product repository authority work after document synchronization and runtime implementation.
The implementation remains additive, manifest-driven, evidence-driven, and read-only for dashboard consumers.

### Implemented Change Targets

- Added lesson-side product structure and evidence schema policy documents.
- Added a shared product document path resolver that reads canonical docs paths and existing root-level legacy paths without changing existing gate semantics.
- Added reusable product repository authority helpers under `tools/lib/`.
- Added a read-only product authority command that can inspect a configured product repository or a supplied product root.
- Added a standalone product authority regression test using temporary product repositories and no real network.
- Extended `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv` before dashboard UI reliance, adding product authority, manifest summary, evidence summary, product-operation blockers, and explicit not-run/stale state handling.
- Extended `tools/dashboard-data` as a read-only snapshot producer that reads existing manifests and evidence only.
- Updated dashboard data fixtures and tests to verify missing product repository, present product repository, manifest coverage, evidence freshness, and product-operation blockers.
- Kept the browser control center read-only and avoided browser-triggered command execution.

### Implemented Order

1. Synchronize the planned contract through the five as-built/workflow documents.
2. Add product repository structure and evidence schema policy documents.
3. Extend dashboard schema with product authority fields and state vocabulary before UI reliance.
4. Implement the shared product document path resolver and shared parsing/status helpers for product manifests and existing evidence.
5. Implement a read-only CLI command for product authority status.
6. Add fixture-based tests that create temporary product repositories with manifest and evidence combinations.
7. Connect the product authority read model into dashboard-data without removing current fields or executing product checks.
8. Update dashboard schema and dashboard data tests.
9. Add the new product authority test to the test plan, Git hooks check list, final-gate coverage where required by existing policy, and aggregate regression paths.
10. Run contract-required checks and targeted tests.
11. Move the sync ID from planned to implemented and update task tracker and handoff.

### Verification Method

```bash
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/test_product_repository_authority.sh
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/check_test_plan_coverage.sh
```

Broader aggregate, full/no-cache, pre-commit, remote CI, and final gate checks remain governed by the workflow contract and current user approval.

### Failure Recovery

- If sync checks fail, fix the contract row and all five synchronized blocks before runtime implementation continues.
- If product path checks become ambiguous, fail closed and report sanitized context rather than guessing.
- If a root duplicate product document exists, report the conflict as product authority `blocked` instead of choosing one silently.
- If evidence freshness conflicts with source state, mark the evidence stale or unknown instead of treating it as healthy.
- If dashboard schema changes break existing consumers, preserve existing fields and add the new product authority fields additively.
- If product repository evidence is absent, report `not_run` or `not_collected` rather than creating evidence inside `tools/dashboard-data`.
- If any existing-feature tradeoff appears necessary, stop and request developer approval.

### Developer Approval Boundaries

- Approval is required before adding browser-side command execution.
- Approval is required before destructive product repository operations, automatic push, merge, delete, or remote mutation.
- Approval is required before changing the priority of `AGENTS.MD` invariants.
- Approval is required before removing support for root-level legacy product documents or changing existing product gate semantics.
- Approval is required before changing 7-day, 14-day, CI, pre-commit, or existing product cleanup semantics.

## Implemented STEP 1-14 Product Launch Quality Gate Implementation Plan

SYNC-ID: step_1_14_product_launch_quality_gate
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,lesson/SYNC_GATES_14_DAYS.tsv,lesson/LESSON_FLOW_14_DAYS.tsv,prompts/PROMPTS_14_DAYS.md,skills/lesson-sync-gate/SKILL.md,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/product-launch-check,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

This implementation was priority 1.
It fixes the trust boundary first: STEP 1-14 completion must mean the product works through the documented user launch path.

Implemented order:

1. Define the product launch-path gate in lesson-side sync-gate policy.
   - Treat the product README launch path as the launch authority.
   - Keep direct `index.html` opening as the planned STEP 1-14 task-tracker contract.
   - Keep HTTP-server-only launch as an approval-requiring alternative.

2. Add launch-path verification to the product gate flow.
   - Check the Add Task workflow through the documented launch path.
   - Verify task list rendering, counters, status transitions, and Clear Done behavior.
   - Keep the check standalone-runnable and callable from the lesson aggregate.
   - Record `tools/product-launch-check` and `tools/test_product_launch_check.sh` in the sync contract artifacts and tests after the runtime artifact exists.

3. Update STEP 1-14 prompts and skill guidance.
   - Tell agents to verify the user-facing launch path before declaring completion.
   - Keep existing lesson approval and ordered progression semantics unchanged.

4. Connect the final STEP 1-14 completion path to launch verification.
   - Ensure final completion cannot pass with unit-only, HTTP-only, or document-only evidence.
   - Keep missing product repository conditions reported safely without recreating the repository.

5. Update product-side generated guidance through the existing lesson workflow.
   - Product README, product requirements, product specification, implementation plan, task tracker, and handoff must describe the same launch path when generated or repaired.
   - Do not bulk-edit unrelated existing product repositories from lesson-side synchronization.

Verification plan:

```bash
./tools/check_lesson14_sync.sh
./tools/test_lesson14.sh
./tools/test_product_launch_check.sh
./tools/test_product_gate_tools.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
```

Failure recovery:

- If direct launch verification fails, fix the product launch implementation or generated guidance before allowing final completion.
- If the documented launch path and test path differ, treat the mismatch as a gate failure.
- If a product repository is missing, report the missing product context without mutating the lesson repository or recreating product files.
- If implementation appears to require changing the official launch path, stop for developer approval.

Developer approval boundaries:

- Approval is required before changing the official STEP 1-14 task-tracker launch path from direct `index.html` opening to HTTP server launch.
- Approval is required before adding a bundler, dependency, external service, browser command execution, or destructive product operation.
- Approval is required before changing existing STEP 1-7 or STEP 1-14 ordered progression semantics.

## Implemented Product Authority Evidence Status Propagation Implementation Plan

SYNC-ID: product_authority_evidence_status_propagation
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/test_product_repository_authority.sh,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/test_dashboard_data.sh,tools/test_dashboard_schema.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

This implementation was priority 2.
It corrects the product evidence read model before other workflows rely on product authority state.

Implemented order:

1. Add product authority regression fixtures for multiple evidence rows.
   - Cover matching context, `all` context, context mismatch, malformed rows, and deterministic JSON output.
   - Prefer temporary fixtures generated inside `tools/test_product_repository_authority.sh`; if persistent fixture files are added, add them to the sync contract artifacts before marking implemented.

2. Fix evidence JSON aggregation.
   - Preserve every applicable evidence item as valid JSON.
   - Fail closed to safe product-authority state when evidence rows are malformed.

3. Add required-evidence status propagation.
   - Promote required `failed` and `blocked` evidence to product-operation blockers.
   - Promote required `stale`, `not_run`, and `unknown` evidence to stale, not-run, unknown, or manual-required state.
   - Keep optional evidence visible without turning it into a required blocker.

4. Keep dashboard-data read-only.
   - Dashboard-data consumes product authority state only.
   - No evidence writing, GitHub polling, Git fetch, CI execution, or repository mutation belongs in this sync ID.

5. Update schema/data tests.
   - Validate status vocabulary, blocker shape, evidence freshness, and dashboard-safe JSON output.

Verification plan:

```bash
./tools/test_product_repository_authority.sh
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
```

Failure recovery:

- If product authority JSON becomes invalid, stop dashboard-data work and fix authority output first.
- If evidence state conflicts with structure state, preserve the worse product-operation state.
- If a status cannot be classified safely, emit `unknown` or `manual_required` rather than `ready`.

Developer approval boundaries:

- Approval is required before adding evidence writers, automatic Git/CI refresh, network calls, or product repository mutation.
- Approval is required before weakening canonical product document enforcement.

## Implemented Free Development Product Repository Scaffold Implementation Plan

SYNC-ID: free_development_product_repo_scaffold
STATUS: implemented
ARTIFACTS: free-development/FREE_DEVELOPMENT_MODE.md,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,tools/free-development,tools/product-improvement,tools/external-integration,tools/product-scaffold-check,tools/test_product_scaffold_check.sh,tools/test_product_gate_tools.sh,tools/test_product_repository_authority.sh,tools/check_workflow_pair_sync.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_product_scaffold_check.sh,tools/test_product_gate_tools.sh,tools/test_product_repository_authority.sh,tools/check_workflow_pair_sync.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

This implementation was priority 3.
It makes Free Development repositories structurally inspectable before the dashboard presents them as selected contexts.

Implemented order:

1. Extend the product repository structure policy.
   - Keep `docs/product/`, `docs/workflow/`, `docs/memory/`, `ops/`, `src/`, and `tests/` as reusable scaffold areas.
   - Keep root-level `AGENT.md`, `README.md`, entry files, and standard control directories discoverable.

2. Add manifest-backed source authority.
   - Declare entrypoint, runtime source, test source, CI, security, dashboard surfaces, and integration evidence through `ops/` manifests.
   - Avoid product-stack-specific or product-name-specific branches.
   - If new manifest files are added rather than extending existing policy files, add them to the sync contract artifacts before marking implemented.

3. Align Free Development, Product Improvement, and External Integration gates.
   - Use the shared product authority resolver.
   - Keep canonical product documents as the only accepted scaffold for product design and workflow documents.

4. Add scaffold validation tests.
   - Cover missing required scaffold entries, optional stack additions, root duplicate blockers, and ambiguous entrypoint/source declarations.
   - Keep tests standalone-runnable and aggregate-runnable.
   - Record `tools/product-scaffold-check` and `tools/test_product_scaffold_check.sh` in the sync contract artifacts and tests after the runtime artifact exists.

5. Update free-development guidance.
   - Describe the external product repo shape in learner-facing workflow guidance without copying the lesson repository wholesale.

Verification plan:

```bash
./tools/test_product_gate_tools.sh
./tools/test_product_scaffold_check.sh
./tools/test_product_repository_authority.sh
./tools/check_workflow_pair_sync.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
```

Failure recovery:

- If root duplicate product documents exist, report a product-operation blocker instead of choosing silently.
- If source authority is ambiguous, fail scaffold validation with a required manifest correction.
- If a repository is stack-specific, add policy or manifest rows rather than hard-coded tool branches.

Developer approval boundaries:

- Approval is required before weakening canonical document enforcement or making CI mandatory for every Free Development repository.
- Approval is required before adding destructive repository cleanup, automatic push, merge, or remote mutation to scaffold workflows.

## Implemented Dashboard Control Center Selected Context Sync Implementation Plan

SYNC-ID: dashboard_control_center_selected_context_sync
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

This implementation was priority 4.
It starts from the data contract because the browser UI must not infer workflow state, repository identity, evidence status, blockers, or progress numbers.
It depends on the earlier launch-quality, evidence-status, and scaffold sync IDs for the product facts that it displays.

Implemented order:

1. Extend the dashboard schema with `selected_context` and `available_contexts`.
   - Keep the change additive.
   - Preserve existing fields and existing consumers.
   - Define status vocabulary before UI reliance.

2. Add a selected-context resolver to the dashboard-data producer layer.
   - Use existing lesson config, lesson state, workflow context map, Git workflow settings, product structure policy, product evidence schema, menu prerequisites, and product authority inputs.
   - Avoid fixed repository names and fixed workflow context branches in UI code.
   - Treat Git, CI, Security, and product status readers as read-only evidence/settings readers; do not execute checks or refresh evidence from the resolver.

3. Remove the dashboard-data `product-improvement` fixed context and single-product-repository assumption.
   - Pass the resolved context into product authority, Git/CI/Security evidence display, and command preview generation.
   - Preserve `task-tracker-repository` as the STEP 1-14 standard repository where that context selects it.

4. Consume product authority evidence propagation from `product_authority_evidence_status_propagation`.
   - Do not duplicate product authority status aggregation in dashboard-data or React.
   - Treat unresolved evidence propagation as a blocker for final UI reliance.

5. Consume canonical scaffold and resolver behavior from `free_development_product_repo_scaffold`.
   - Prefer producer-owned product authority fields.
   - Keep root-level product document compatibility through shared resolvers.

6. Make dashboard-data evidence-driven while preserving read-only behavior.
   - Read existing evidence, settings, and manifests.
   - Do not create evidence, call GitHub, fetch remotes, run CI, run product checks, or mutate repositories.
   - Classify unavailable live evidence as not-run, stale, manual-required, or unknown with a safe next command preview.

7. Update the React control center to consume selected-context data.
   - Add a top-level context selector.
   - Render selected-context summary, four context-aware status cards, Git management overview, Security overview, and current-state detail headers.
   - Keep UI state limited to display selection and navigation.

8. Align the selected-context UI foundation with `mock-context-*` references.
   - Reuse common components for selected context header, current status cards, next safe action, blocker rows, manual follow-ups, and evidence details.
   - Preserve category icon identity, distinct health colors, card height alignment, centered short labels, no-overflow responsive constraints, and read-only notices.
   - The full mock-source-of-truth UI rebuild is implemented separately under `dashboard_control_center_context_mock_source_of_truth`.

9. Update tests and fixtures.
   - Cover selected contexts, evidence status aggregation, free-development context, canonical docs fallback/conflict behavior, Partial Failures none state, blockers, manual follow-ups, and no browser command execution.
   - Keep new checks standalone-callable and aggregate-callable through existing test entry points.

Verification plan:

```bash
./tools/test_product_repository_authority.sh
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_control_center.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_ci_workflow_structure.sh
```

For later mock-source runtime UI changes, `npm run dashboard:build` remains the targeted Vite build check, but it is not a sync-contract `TESTS` entry because the contract records standalone repository check files.
Broader aggregate, full/no-cache Git hooks, pre-commit, final-gate, main CI, and remote CI remain governed by AGENTS.MD verification-scope rules and the active workflow contract.

Failure recovery:

- If schema validation fails, stop UI work and correct the schema, producer, and fixtures first.
- If product authority aggregation fails, fix authority status and blockers before dashboard-data or UI changes continue.
- If dashboard-data cannot resolve a context safely, emit a valid snapshot with blocked or manual-required state instead of guessing.
- If UI rendering fails, add or correct producer-owned data rather than introducing React-side state inference.
- If sync checks fail, repair the five synchronized documents and sync contract before runtime implementation continues.
- If any existing-feature tradeoff appears necessary, stop and request developer approval.

Developer approval boundaries:

- Approval is required before browser command execution, POST fetches, GitHub/API calls, live authoritative CI/Git fetching, push, merge, remote deletion, destructive Git operations, OAuth, tokens, or webhook handling.
- Approval is required before removing root-level legacy product document compatibility.
- Approval is required before changing STEP 1-7 behavior, STEP 1-14 behavior, existing CI, pre-commit, Git hooks semantics, document routes, or dashboard read-only ownership.
- Approval is required before adding a persistent selected-context storage file outside existing settings and policy sources.
- Approval is required before including evidence writing or auto-merge execution in this sync ID.

## Implemented Dashboard Control Center Context Mock Source Of Truth Implementation Plan

SYNC-ID: dashboard_control_center_context_mock_source_of_truth
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

This implementation re-centers the dashboard UI around the five approved `mock-context-*` images after selected-context data synchronization.
The implementation must keep the dashboard producer authoritative, the browser read-only, and the UI reusable across STEP 1-7, STEP 1-14, applied lessons, Free Development, Product Improvement, External Integration, and lesson-repository improvement contexts.

Change targets:

- `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv`, `tools/lib/dashboard_data.sh`, and `tools/dashboard-data` for producer-owned fields needed by the mock-aligned UI.
- `dashboard-control-center/src/App.jsx`, `dashboard-control-center/src/dashboardData.js`, `dashboard-control-center/src/i18n.js`, and `dashboard-control-center/src/styles.css` for the React shell, sidebar, overview, detail pages, localization, and responsive layout.
- `tests/fixtures/dashboard-control-center.json`, `tests/fixtures/dashboard-control-center-live-update.json`, and `tests/playwright/dashboard-control-center.spec.js` for mock-structure and safety regression coverage.

Implementation order:

1. Confirm the five `mock-context-*` images as source references for layout, icon direction, page density, sidebar detail, and non-engineer comprehension.
2. Extend the dashboard schema only for fields the UI cannot safely derive, including current-step labels, current-step totals, Git operation rows, maintenance evidence rows, Security approval summaries, dangerous-operation summaries, and command-preview grouping.
3. Extend `tools/dashboard-data` and shared helpers to emit those fields from existing settings, manifests, evidence, and status sources without executing Git, CI, GitHub, product-security, product-authority, or shell commands.
4. Refactor the React shell into reusable surfaces: sidebar, page header, context menu tiles, selected-context strip, status cards, decision summaries, evidence tables, command-preview tiles, and read-only banners.
5. Rebuild Overview to match the mock order: visible header, seven menu tiles, context strip, four status cards, Git management settings, Security confirmation, four Explore Pages cards, and bottom notice.
6. Rebuild Lessons, Development Workflow, Maintenance Sync, and Safety Confirmation as page-specific surfaces using shared components but preserving each mock's information hierarchy.
7. Move all fixed labels through `i18n.js` and keep data-originated identifiers sanitized through existing display helpers.
8. Update fixtures so tests verify changing data, empty and non-empty Partial Failures, selected contexts, no command execution, and mobile no-overflow without depending on one screenshot value or one language phrase.
9. Run the contract-required targeted checks before marking this sync ID implemented.

Verification plan:

```bash
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_control_center.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_ci_workflow_structure.sh
```

When runtime UI changes are implemented, `npm run dashboard:build` is the targeted Vite build check.
Broader aggregate, full/no-cache hooks, pre-commit, final gate, main CI, and remote CI remain governed by AGENTS.MD local-verification scope and the active workflow contract.

Failure recovery:

- If schema checks fail, correct schema, producer, and fixture data before continuing React work.
- If producer data cannot support a mock field safely, add a structured blocked, unknown, manual-required, not-run, or stale state rather than hard-coding mock text.
- If React layout contradicts producer state, fix the data contract or shared display helper instead of adding UI-only status inference.
- If mock alignment creates command-like affordances, remove the affordance and keep links, code chips, and preview cards visually non-executable.
- If mobile or localized text overflows, fix responsive constraints rather than language-specific branches.
- If sync checks fail, repair the sync contract and all five synchronized documents before runtime implementation continues.
- If any existing-feature tradeoff appears necessary, stop and request developer approval.

Developer approval boundaries:

- Approval is required before browser command execution, POST fetches, Git/GitHub/CI/API calls, live authoritative CI/Git polling, automatic push, merge, cleanup, deletion, OAuth, token, webhook, evidence writing, or destructive operations.
- Approval is required before removing root-level legacy product document compatibility.
- Approval is required before changing STEP 1-7, STEP 1-14, existing CI, pre-commit, Git hooks semantics, document routes, or dashboard read-only ownership.
- Approval is required before making screenshot equality the required automated oracle.
- Approval is required before accepting any existing-feature tradeoff.

## Implemented Dashboard Control Center Exact Mock Alignment Correction Implementation Plan

SYNC-ID: dashboard_control_center_mock_exact_alignment_correction
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,free-development/FREE_DEVELOPMENT_MODE.md,templates/TEMPLATES.md,lesson/SYNC_GATES_14_DAYS.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/lib/product_repository_authority.sh,tools/free-development,tools/product-improvement,tools/external-integration,tools/product-scaffold-check,tools/product-launch-check,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

This implemented correction is a separate implementation unit because developer visual review found that the earlier implemented mock-source dashboard relied too much on generic structures and did not match the current mock family.
It is not a replacement for selected-context sync, product authority, scaffold, or launch-quality work; it makes those contracts visible through an exact mock-aligned control-panel UI.

Change targets:

- `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv`, `tools/lib/dashboard_data.sh`, and `tools/dashboard-data` for selected-context map, context-specific metrics, workflow evidence rows, maintenance evidence rows, Safety summaries, and command-preview groups.
- `tools/lib/product_repository_authority.sh` for blocker-preserving status propagation when required evidence is failed, blocked, stale, not-run, or unknown.
- `tools/free-development`, `tools/product-improvement`, `tools/external-integration`, `tools/product-scaffold-check`, and `tools/product-launch-check` for shared external product repository structure, manifest-backed authority, and launch-quality gates.
- `free-development/FREE_DEVELOPMENT_MODE.md`, `templates/TEMPLATES.md`, `docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv`, `docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv`, and `lesson/SYNC_GATES_14_DAYS.tsv` for external repository and STEP 1-14 launch-quality contracts.
- `dashboard-control-center/src/App.jsx`, `dashboard-control-center/src/dashboardData.js`, `dashboard-control-center/src/i18n.js`, and `dashboard-control-center/src/styles.css` for the exact mock-aligned browser implementation.
- Dashboard fixtures and Playwright spec for post-visual-approval structural and safety regression coverage.

Implementation order completed:

1. Kept this sync ID planned until the runtime correction was implemented and targeted checks passed.
2. Corrected the selected-context data model so menu choices have complete producer-owned context data or safe incomplete state.
   - Implement either an expanded `available_contexts[]` contract or a `contexts_by_menu` style producer map before the UI treats menu switching as live context switching.
   - Keep thin menu-id/status summaries only for non-authoritative preview display.
3. Separated STEP 1-14, Free Development, Product Improvement, External Integration, and lesson-repository improvement repository resolution through policy-backed context data.
   - Treat `docs/memory/` as part of the standard external repository scaffold shape while keeping individual memory files optional until used.
4. Made Git, CI, Security, product authority, scaffold, launch, and workflow-pair status display evidence-backed or explicitly manual-required without making `tools/dashboard-data` execute checks.
5. Added selected-context Git, CI, and Security axis propagation from product authority evidence and product-operation blockers, so external product repository evidence changes are reflected in the dashboard state.
6. Hardened product authority aggregation so multiple evidence rows and required failed, blocked, stale, not-run, or unknown evidence propagate to blockers deterministically.
7. Required `passed` evidence to be both current and authoritative before satisfying a required manifest source, and deduplicated repeated required evidence sources before emitting synthetic not-run blockers.
8. Replaced fixed lesson live, maintenance card, and safety card description text with producer-owned lesson setting state, snapshot identity, evidence-row, approval-row, dangerous-operation, and Partial Failure detail rendering.
9. Recomputed dashboard metrics around selected-context progress and current blockers rather than mixing optional, unknown, cached, or future checks into progress percentages.
10. Refactored React into page-specific mock surfaces for Overview, Lessons, Workflow, Maintenance, and Safety.
11. Limited shared React abstractions to shell, sidebar, icon badge, status pill, display sanitization, localization, and read-only notice behavior.
12. Rebuilt the Overview to match the current mock order and content amount.
13. Rebuilt Lessons around selected lesson progress, current step, next learning action, and live lesson state.
14. Rebuilt Workflow around Git sync, CI, PR/Merge, product evidence, next step, and recent evidence rows from producer data.
15. Rebuilt Maintenance around as-built sync, workflow pair, Developer Memory, repo-local skills, Git workflow settings, Security policy, evidence rows, and source grounding as secondary details.
16. Rebuilt Safety around Security gate, approvals, dangerous operations, always-visible Partial Failures, command previews, and policy state.
17. Aligned color tokens, contrast, icon shapes, icon centering, background fill or transparency, status badges, card heights, and responsive no-overflow with the five mocks.
18. Adjusted targeted tests and fixtures, then promoted this sync ID to implemented after required checks passed.

Document synchronization:

- Requirements state why the corrective implementation is needed and what must not change.
- Specification defines the producer-owned data boundary, page-specific UI contract, external repository behavior, and read-only safety boundary.
- This implementation plan defines execution order, verification, recovery, and approval boundaries.
- Task tracker records current planned work state and implementation checklist.
- Handoff records restart context, source mocks, prohibited shortcuts, and deferred verification.

Verification completed:

- Targeted runtime checks cover dashboard schema/data, browser control center, product authority, scaffold, launch quality, product gate, STEP 1-14 sync, STEP 1-14 aggregate, and as-built synchronization.
- The sync contract and all five synchronized `TESTS` blocks carry the runtime checks required by the actual implementation.
- `tools/test_dashboard_control_center.sh` includes the targeted Vite build and Playwright browser control-center checks.
- Full/no-cache hooks, final gate, main CI, and remote CI remain governed by AGENTS.MD local-verification scope and active workflow contract.

Failure recovery:

- If a mock field lacks producer-owned data, extend schema and producer output or show a safe incomplete state; do not hard-code screenshot text.
- If UI remains visually misaligned, correct the page-specific structure instead of layering more generic CSS.
- If product authority aggregation fails, fix authority status and blockers before dashboard-data or React changes continue.
- If scaffold or launch validation conflicts with existing STEP behavior, stop and isolate the conflict before implementation continues.
- If sync checks fail, repair all five synchronized documents and the sync contract before runtime implementation starts.
- If any existing-feature tradeoff appears necessary, stop and request developer approval.

Developer approval boundaries:

- Approval is required before browser command execution, POST fetches, Git/GitHub/CI/API calls, live authoritative Git or CI polling, push, merge, cleanup, remote deletion, OAuth, token handling, webhook handling, evidence writing, or destructive operations.
- Approval is required before changing STEP 1-7 behavior, STEP 1-14 behavior, direct `index.html` launch requirements, existing CI, pre-commit, Git hooks semantics, document routes, dashboard read-only ownership, or canonical product document enforcement.
- Approval is required before creating runtime pages for repository information, documents, settings, help, or changelog.
- Approval is required before making screenshot equality an automated test oracle.

## Implemented Dashboard Lessons Page Exact Mock Alignment Implementation Plan

SYNC-ID: dashboard_control_center_lessons_page_exact_mock_alignment
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

Implementation order completed:

1. Inspect `dashboard-control-center/mocks/mock-context-lessons.png` and the current Lessons page side by side with Playwright screenshots.
2. Create a discrepancy checklist for layout, color, contrast, icon identity, icon background fill or transparency, text amount, progress display, card height, and responsive behavior.
3. Update `App.jsx`, `i18n.js`, and `styles.css` to match the mock-backed Lessons page structure without adding fixed screenshot-only values.
4. Add or adjust shared components or tokens only when they improve mock-family reuse and do not disturb the already implemented pages.
5. Keep schema and producer output unchanged unless the mock requires a fact that is not available from producer-owned data; in that case, stop and plan the missing data contract.
6. Used Playwright desktop and narrow/mobile screenshots for visual inspection before reporting design completion for developer visual approval.
7. After developer visual approval and explicit Git/CI closure request, run `tools/test_dashboard_control_center.sh` and the synchronized structure checks listed in this block.
8. Promoted this sync ID from `planned` to `implemented` after implementation and targeted verification were in scope.

Document synchronization:

- Requirements record the user-facing goal and non-scope.
- Specification records the read-only producer-owned UI contract.
- This implementation plan records execution order, verification, recovery, and approval boundaries.
- Task tracker records current work state.
- Handoff records restart context and the exact source mock.

Failure recovery:

- If visual mismatch remains, revise page structure, tokens, icons, and content hierarchy instead of layering ad hoc CSS.
- If responsive behavior breaks, adjust layout constraints before changing content.
- If a producer-data gap appears, stop and plan schema and producer changes before rendering invented state.
- If sync checks fail, repair the five synchronized documents and sync contract before runtime implementation proceeds.

Developer approval boundaries:

- Visual implementation should stop for developer visual approval before broad checks and CI unless the workflow owner explicitly requests Git/CI closure.
- Approval is required before changing other page designs, STEP 1-7, STEP 1-14, Git hooks, CI, pre-commit, read-only dashboard ownership, or canonical product document enforcement.

## Implemented Dashboard Control Center Visual Refinement Follow-up Implementation Plan

SYNC-ID: dashboard_control_center_visual_refinement_followup
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/memory/DEVELOPER_MEMORY.md,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

Implementation order completed:

1. Refined the Lessons page and Overview lesson-progress card typography, progress-ring/bar weight, fraction hierarchy, and three-card responsive layout.
2. Added restrained one-time count-up animation for lesson progress numbers and removed gradient, fade, shine, and icon scaling effects.
3. Aligned Development Workflow responsive behavior, bottom notice styling, and Git sync icon language with the mock family.
4. Aligned Maintenance Sync icon fills, status/evidence columns, copy controls, ellipsis fields, source-boundary tooltips, and non-engineer-readable labels.
5. Aligned Safety Confirmation top icons, localized Security detail labels, failure wording, Partial Failures panel, command-preview cards, copy controls, and Security policy checklist.
6. Stacked Safety command preview and Security policy panels vertically to preserve readable width.
7. Unified the left sidebar structure and active styling across all implemented pages.
8. Reset and repopulated Developer Memory with only the active dashboard and maintenance follow-ups requested by the developer.
9. Updated Playwright expectations for the implemented three-lesson-card Lessons page.
10. Kept dashboard data read-only and did not add browser command execution, live Git/CI polling, or evidence writing.

Verification plan:

```bash
./tools/test_dashboard_control_center.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_ci_workflow_structure.sh
```

Runtime visual checks should continue to use Playwright screenshots and DOM overflow checks before broad CI.
The current closure request explicitly moves from visual-only tuning into minimal local verification, commit, CI, merge, and local/remote synchronization.

Failure recovery:

- If dashboard browser tests fail, fix the UI contract or test expectation that no longer matches the implemented mock-backed behavior.
- If sync checks fail, repair the sync contract and all five synchronized documents before committing.
- If responsive overflow returns, adjust layout constraints before changing content.
- If localized fixed labels expose raw English controlled strings, add i18n mappings rather than rewriting producer-owned data.
- If Git/CI closure fails, preserve the committed branch state and record the exact failing check before retrying.

## Implemented Menu Product Display Profile Confirmation Implementation Plan

SYNC-ID: menu_product_display_profile_confirmation
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/MENU_PRODUCT_PROFILE_POLICY.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/lesson_common.sh,tools/lib/product_repository_authority.sh,tools/product-profile,tools/menu,tools/lesson,tools/lesson14,tools/free-development,tools/product-improvement,tools/external-integration,tools/team-development,tools/product-scaffold-check,tools/test_menu_prerequisites.sh,tools/test_lesson.sh,tools/test_lesson14.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_menu_prerequisites.sh,tools/test_lesson.sh,tools/test_lesson14.sh,tools/test_dashboard_data.sh,tools/check_lesson_structure.sh,tools/check_agents_skills.sh

Implementation order completed:

1. Added a menu product-profile policy TSV so recommendations and scope are data-backed rather than hard-coded branches.
2. Added `tools/product-profile` with explicit `--confirm`, product repository boundary checking, safe JSON writing, and learner-confirmed display-name output.
3. Added shared profile helpers to `tools/lib/lesson_common.sh` for readiness, required checks, menu scope, and localized display-name lookup.
4. Wired profile prerequisites into `tools/menu`, direct workflow start/gate commands, and both `setup.index` lesson gates.
5. Added `product_profile_valid` validation and `ops/PRODUCT_PROFILE.json` to the external product repository structure policy.
6. Switched product authority summary from requirements/specification inference to canonical `ops/PRODUCT_PROFILE.json`.
7. Updated the dashboard schema, data tests, UI locale fallback, and targeted fixtures.
8. Kept product profile handling producer-backed and regenerated the local dashboard snapshot from `tools/dashboard-data`.

Verification completed:

```bash
./tools/test_dashboard_schema.sh
./tools/test_product_repository_authority.sh
./tools/test_product_scaffold_check.sh
./tools/test_menu_prerequisites.sh
./tools/test_lesson.sh
./tools/test_lesson14.sh
./tools/test_dashboard_data.sh
./tools/check_lesson_structure.sh
./tools/check_agents_skills.sh
npm run dashboard:build
git diff --check
```

Known follow-up:

- `tools/test_dashboard_control_center.sh` was attempted and still has existing responsive/layout expectation failures in the browser UI suite. The failure is tracked in handoff and was not promoted as passed verification for this sync ID.

## Implemented Product Repository Canonical Docs Only Implementation Plan

SYNC-ID: product_repository_canonical_docs_only
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_REPOSITORY_FORBIDDEN_ROOT_PATHS.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,prompts/PROMPTS.md,prompts/PROMPTS_14_DAYS.md,lesson/LESSON_FLOW.tsv,lesson/LESSON_FLOW_14_DAYS.tsv,lesson/SYNC_GATES_14_DAYS.tsv,playbooks/AGENT_PLAYBOOK.md,playbooks/AGENT_PLAYBOOK_14_DAYS.md,templates/TEMPLATES.md,skills/task-tracker-docs/SKILL.md,skills/task-tracker-docs/references/product-docs.md,skills/worklog-doc-sync/SKILL.md,skills/worklog-doc-sync/references/worklog-sync.md,skills/lesson-sync-gate/SKILL.md,skills/lesson-sync-gate/references/sync-gates.md,skills/learning-progress-helpdesk/references/progress-helpdesk.md,tools/lib/product_repository_authority.sh,tools/product-scaffold-check,tools/product-improvement,tools/external-integration,tools/dashboard-data,tools/dashboard,tools/check_workflow_pair_sync.sh,tools/check_agents_skills.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_security.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_security.sh,tools/check_agents_skills.sh,tools/test_dashboard_data.sh,tools/test_lesson14.sh,tools/check_lesson_structure.sh,tools/check_lesson14_sync.sh

Implementation order completed:

1. Split forbidden root Markdown paths into `docs/workflow/PRODUCT_REPOSITORY_FORBIDDEN_ROOT_PATHS.tsv` so the policy is reusable and not hard-coded per command.
2. Updated product authority to validate the forbidden-root policy and block root duplicates before canonical readiness can be reported.
3. Updated scaffold validation to evaluate optional rows for root duplicates while still requiring only context-required structure items.
4. Removed root fallback from product improvement, external integration, dashboard data, CLI dashboard, and product workflow-pair checks.
5. Canonicalized prompt, playbook, lesson-flow, sync-gate, and repo-local skill wording so agents are not guided to create or edit root product documents.
6. Updated tests to assert root-only and canonical-plus-root-duplicate product documents block the workflow, including optional memory duplicates.
7. Kept external repository remediation outside this lesson repository record; this implementation records only the reusable policy, tools, prompts, and tests.

Verification completed:

```bash
./tools/test_product_repository_authority.sh
./tools/test_product_scaffold_check.sh
./tools/test_product_security.sh
./tools/check_agents_skills.sh
./tools/test_dashboard_data.sh
./tools/test_lesson14.sh
./tools/check_lesson_structure.sh
./tools/check_lesson14_sync.sh
```

Failure recovery:

- If a product repository has root duplicate Markdown files, move or merge the content into the canonical docs path first, then remove the root duplicate and regenerate its repository index.
- If root and canonical content differ, stop before deletion and preserve both versions for human review.
- If dashboard product document readiness reports missing, inspect canonical `docs/product` and `docs/workflow` paths rather than adding root fallback.
- If skills or prompts regress to bare product document names, update the relevant guidance and `tools/check_agents_skills.sh` together.

## Implemented Dashboard Control Center Documents Guided Catalog Implementation Plan

SYNC-ID: dashboard_control_center_documents_guided_catalog
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/dashboard_data.sh,tools/lib/document_paths.sh,tools/lib/product_repository_authority.sh,tools/dashboard-data,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

Implementation order completed:

1. Define the documents catalog data contract before changing the browser page.
   - Use existing dashboard schema, producer, fixture, and validator paths.
   - Keep the shape generic, for example document id, group id, role id, path, audience, order, status, status source, related dashboard surface, and display-only related command metadata.
   - Do not add a React-only fixed document list.
2. Extend `tools/dashboard-data` and shared dashboard data helpers to emit the documents catalog from existing settings, document routes, docs-tour knowledge, and dashboard state.
   - Treat the producer as read-only.
   - Do not execute Git, CI, product authority, security checks, evidence writers, or document generators.
3. Update `DASHBOARD_DATA_SCHEMA.tsv` and `dashboardData.js` so malformed document catalog data is caught before UI reliance while missing legacy catalog data renders as a safe incomplete state.
4. Rebuild `DocumentsPage` as a guided reading surface.
   - Suggested groups: first documents to read, what is being built, current progress, decision background, and help when stuck.
   - Route Git/CI, security, evidence, file structure, and update history to their dedicated pages.
   - Keep file paths and technical ids as secondary copyable or tooltip-backed details.
5. Update localized fixed labels in `i18n.js` and reuse existing dashboard card, tooltip, copy, sidebar, and responsive CSS patterns.
6. Add or adjust tests only at the level required by changed surfaces.
   - If a new documents-specific test is needed, make it standalone and aggregate-callable.
   - Avoid assertions that depend on one exact Japanese sentence, one product stack, or one fixture-only case.
7. Promoted this sync ID to `implemented` after implementation and required verification passed.
8. Addressed sub-agent review findings for safe relative path validation, documents hash coverage, duplicate ids, legacy snapshot fallback, manifest product-type ordering, docs-tour references, and fixed-phrase test assertions.

Document synchronization:

- Requirements record the user-facing capability, non-scope, and no-tradeoff constraints.
- Specification records the data contract, UI contract, safety boundary, and compatibility behavior.
- This implementation plan records execution order, verification, recovery, and approval boundaries.
- Task tracker records current implemented work state and checklist.
- Handoff records restart context, prohibited shortcuts, and validation expectations.

Verification completed:

```bash
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_control_center.sh
./tools/test_product_repository_authority.sh
./tools/test_product_scaffold_check.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
```

Runtime React changes also use `npm run dashboard:build` as the targeted Vite build check.
Run broader aggregate, pre-commit, PR CI, or main CI only when the active workflow contract requires it.

Failure recovery:

- If schema or producer tests fail, fix the data contract and producer output before continuing UI work.
- If the UI cannot display a document group from producer-owned data, show a safe incomplete state or extend the schema; do not hard-code the missing fact in React.
- If evidence or command details reappear as primary Documents page content, move them back to Maintenance Sync, Safety Confirmation, Development Workflow, or update history.
- If localized text overflows, fix responsive layout or label structure rather than adding language-specific branches.
- If sync checks fail, repair the five synchronized documents and sync contract before runtime implementation continues.
- If any existing-feature tradeoff appears necessary, stop and request developer approval.

Developer approval boundaries:

- Approval is required before browser command execution, POST fetches, live Git/GitHub/CI/API polling, evidence writing, document editing from the dashboard, merge, push, cleanup, remote deletion, OAuth, token handling, or destructive operations.
- Approval is required before removing or weakening docs-tour, `tools/dashboard docs`, Maintenance Sync evidence, Safety Confirmation, Repository Information, STEP 1-7, STEP 1-14, existing CI, Git hooks, pre-commit, or existing document routes.
- Approval is required before accepting schema-incompatible behavior or any existing-feature tradeoff.

## Implemented Agent Escalated Verification Policy Implementation Plan

SYNC-ID: agent_escalated_verification_policy
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv
TESTS: tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_agents_skills.sh

Implementation completed:

1. Added AGENTS.MD invariant rule 22 for first-attempt escalated execution of known sandbox-incompatible, non-destructive verification.
2. Scoped the rule to Playwright/Chromium real-screen inspection, screenshot capture, browser launch, local port observation, and equivalent observation-only checks.
3. Preserved the existing approval boundary for credentials, OAuth, external writes, dependency changes, repository mutation, push, merge, cleanup, delete, destructive operations, CI failure overrides, and gate weakening.
4. Registered the policy in `AS_BUILT_SYNC_CONTRACT.tsv` so future synchronization checks treat the policy as an implemented contract.
5. Synchronized requirements, specification, implementation plan, task tracker, and handoff so the rule is not only an AGENTS.MD one-off.

Verification plan:

```bash
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_agents_skills.sh
```

Future usage:

- When visual design work requires Playwright evidence, launch the browser with the required execution scope immediately and capture the relevant viewport screenshots before making design conclusions.
- If the escalated command itself fails, report the environment blocker and do not claim the page was visually verified.
- Continue to ask before dangerous or credential-bearing operations; this policy only removes redundant confirmation for non-destructive observation commands that are already required by the active task.

## Implemented Dashboard Control Center Settings Safe Change Implementation Plan

SYNC-ID: dashboard_control_center_settings_safe_change_plan
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/lib/dashboard_data.sh,tools/lib/git_workflow_policy.sh,tools/dashboard-data,tools/dashboard-settings,tools/dashboard-control-center,vite.config.mjs,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh
TESTS: tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_git_workflow_policy.sh,tools/test_lesson.sh,tools/test_lesson14.sh,tools/test_menu_prerequisites.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh

Implementation result:

1. Synchronized the implemented contract through the as-built sync contract and the five synchronized documents.
   - Promoted the sync ID to `implemented` after schema, producer, Settings writer, Vite middleware, UI, fixtures, and targeted validation were implemented.
   - Preserved read-only behavior for non-Settings pages and command previews.
2. Define the settings catalog schema.
   - Add generic settings fields to `DASHBOARD_DATA_SCHEMA.tsv`, including status, groups, items, current value, current label, safe source file, allowed values, editability, risk level, confirmation requirement, disabled reason, related page, and update action id.
   - Avoid schema fields tied to a single product stack, language phrase, fixture value, or exact UI sentence.
3. Extend the dashboard data producer.
   - Add reusable catalog builders in `tools/lib/dashboard_data.sh`.
   - Emit `settings` from existing lesson settings, selected context, Git workflow policy/settings, and security approval state.
   - Include settings source files and catalog content in source tracking and content hash generation.
   - Emit `summary.workflow_language`, `summary.display_locale`, and `summary.ui_locale` from the selected workflow display language and include those locale fields in content hash generation.
   - Do not execute Git, GitHub, CI, product-security, product-authority, evidence writers, or settings writers from `tools/dashboard-data`.
4. Implement the Settings write path in this sync ID.
   - Added `tools/dashboard-settings catalog|plan|apply --confirm` as the only writer for editable Settings rows.
   - Reused lesson setting normalization and Git workflow policy validation, rejected arbitrary paths and shell strings, validated output, and wrote through same-directory temporary files plus atomic rename.
   - Regenerated the dashboard snapshot after successful apply and restricted snapshot output to the dashboard runtime directory outside isolated test mode.
   - Kept product or work target naming writes out of scope; they must route through product-profile policy, repository-boundary checks where product-scoped, and a separate approved write contract.
5. Add validation before UI reliance.
   - Extend `dashboard-control-center/src/dashboardData.js` and Vite snapshot validation if needed so malformed settings catalog data fails before rendering.
   - Validate locale summaries when present, including `summary.workflow_language`, `summary.display_locale`, `summary.ui_locale`, and the match between `summary.workflow_language` and the Settings `workflow_language` row.
   - Update fixtures only from producer-owned data, not from manual UI-only objects.
6. Rebuild Settings UI and mutation boundary.
   - Replace narrow card grids with row-based `Settings` groups that render producer-owned settings items.
   - Keep the top section compact so the first settings rows are visible on mobile.
   - Add related-page display to each settings row.
   - Add a large review popup with dialog semantics, focus entry, Tab/Shift+Tab focus trap, close behavior, current value, proposed value, impact, source file, required confirmation, validation state, update preview, plan result, explicit apply confirmation, and apply result.
   - Add Vite `/dashboard-settings/plan` and `/dashboard-settings/apply` endpoints that accept same-origin narrow JSON and call `tools/dashboard-settings` through `execFile` without shell execution.
   - After a successful apply, immediately refetch the regenerated snapshot from React state management so workflow display language changes update Dashboard fixed UI labels without a page reload.
7. Add focused tests and aggregate wiring.
   - Add focused schema, dashboard-data, settings-tool, and browser tests for the Settings catalog and popup, including malformed catalog rejection and legacy or missing catalog safe incomplete behavior.
   - Wire `tools/test_dashboard_settings.sh` into `tools/test_dashboard_control_center.sh` so the new check can run standalone or through the aggregate dashboard test.
   - Add a real Vite middleware integration check for Settings plan/apply, JSON and same-origin guards, CLI JSON response validation, settings-file update behavior, regenerated snapshot content hash, summary locale fields, and the Settings `workflow_language` row.
   - Add Playwright coverage for Settings desktop, mobile no-overflow, row rendering, related-page display, dialog focus behavior, approval-only wording, plan/apply payloads, invalid catalog rejection, and workflow display language apply without page reload.
8. Promote this sync ID to `implemented` only after catalog, update tool, UI, required local checks, sub-agent review, and synchronization checks pass.

Document synchronization policy:

- Requirements record the learner-facing capability, exclusions, and no-tradeoff constraints.
- Specification records the settings catalog contract, UI contract, update boundary, and safety compatibility rules.
- This implementation plan records order, verification, recovery, and approval boundaries.
- Task tracker records current planned state and checklist.
- Handoff records restart context, blocked shortcuts, and future validation expectations.

Verification method:

```bash
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_settings.sh
./tools/test_dashboard_control_center.sh
./tools/test_git_workflow_policy.sh
./tools/test_lesson.sh
./tools/test_lesson14.sh
./tools/test_menu_prerequisites.sh
./tools/test_lesson_repository.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_workflow_pair_sync.sh
```

The settings update tool is implemented in this sync ID; run its standalone test and the aggregate dashboard control-center test.
Because Git workflow settings are writable through Settings, include `./tools/test_git_workflow_policy.sh`.
Because this sync ID touches 7-day and 14-day lesson setting behavior, include `./tools/test_lesson.sh`, `./tools/test_lesson14.sh`, and `./tools/test_menu_prerequisites.sh`.
When React runtime changes are made, run `npm run dashboard:build`, then Playwright visual inspection before developer visual approval and heavier Git/CI closure.

Failure recovery:

- If schema or producer validation fails, fix the schema and producer before changing React rendering.
- If the UI cannot render a needed setting from producer data, extend the settings catalog or show a safe incomplete state; do not invent the value in React.
- If a later update tool writes invalid data, restore from the temporary or backup path, add a regression test, and do not weaken validation.
- If 7-day or 14-day lesson flows regress, revert the settings update surface before changing lesson behavior.
- If pre-commit, aggregate, or CI checks fail, fix the underlying contract or implementation; do not skip or weaken hooks, gates, or required checks.
- If the same failure repeats three times or an existing-feature tradeoff appears necessary, stop and request developer direction.

Developer approval boundaries:

- Approval is required before adding any browser mutation route beyond `/dashboard-settings/plan` and `/dashboard-settings/apply`, browser-triggered tools beyond `tools/dashboard-settings`, evidence writing, live Git/GitHub/CI polling, product-security execution, product-authority execution, dependency changes, non-whitelisted file writes, external repository writes, push, merge, cleanup, deletion, destructive operations, approval-state mutation, or any relaxation of the implemented Settings allowlist.
- Approval is required before changing pre-commit or CI required coverage.
- Approval is required before accepting behavior that would trade off STEP 1-7, STEP 1-14, existing checks, existing document routes, repo-local skills, or security gates.

## Implemented Dashboard Control Center Full Locale UI Support Implementation Plan

SYNC-ID: dashboard_control_center_full_locale_ui_support
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/lib/lesson_common.sh,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/dashboard-settings,tools/dashboard-control-center,tools/test_dashboard_i18n.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh,tools/test_lesson_repository.sh,vite.config.mjs,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js
TESTS: tools/test_dashboard_i18n.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh

Implemented change targets:

- `dashboard-control-center/src/i18n.js`: central locale policy, aliases, direction metadata, full standard dictionaries, resolver, and dictionary completeness exports.
- `dashboard-control-center/src/dashboardData.js`: summary locale and Settings row validation for the full standard locale set.
- `dashboard-control-center/src/App.jsx`: active-locale state after Settings apply success, root `lang` and `dir`, Settings notice, and RTL-safe rendering boundaries.
- `dashboard-control-center/src/styles.css`: CSS logical properties and LTR isolation for technical values where needed.
- `tools/lib/dashboard_data.sh` and `tools/dashboard-data`: canonical UI locale and optional direction fields from the workflow display language, content hash participation, and schema-aligned summary emission.
- `tools/dashboard-settings`: canonical locale metadata in successful apply responses for locale-affecting settings.
- `vite.config.mjs`: validation of apply responses and snapshots without widening the same-origin JSON POST boundary.
- `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv`, fixtures, Playwright tests, and dashboard shell tests: full locale contract and regression coverage.

Implementation result:

1. Keep the current Settings safe-change implementation intact and preserve all same-origin, JSON-only, `execFile`, allowlist, atomic write, and snapshot boundary behavior.
2. Extract or formalize the Dashboard locale policy so producer, Settings writer, React, validators, and tests consume the same standard language set and alias mapping.
3. Expand `summary.ui_locale` schema and validators from `ja|en` to the full standard set. Add or validate direction metadata for `ar`.
4. Add complete fixed-label dictionaries for all standard Dashboard UI locales in the localization layer. Do not add component-level language branches to compensate for missing labels.
5. Update `tools/dashboard-data` so selected workflow display language, canonical display locale, resolved UI locale, direction, and content hash are all produced from the shared policy.
6. Update `tools/dashboard-settings apply` so successful locale-affecting writes return canonical locale metadata. React must update active locale only after this success response.
7. Update React state flow so Settings apply updates fixed UI labels immediately without page reload, then refetches the regenerated snapshot as authoritative data.
8. Add the localized Settings notice that setting changes may take a moment and that the Dashboard updates automatically after successful application.
9. Add RTL support for Arabic at the root and reusable technical-value boundaries, then verify no page uses language-specific layout branches.
10. Added `tools/test_dashboard_i18n.sh` for locale policy and dictionary completeness, then wired it into aggregate dashboard checks and test-plan policy.
11. Update fixtures from producer-owned data and broaden Playwright coverage to representative locales: Japanese, English, one CJK locale such as `zh-CN`, one longer Latin locale such as `de` or `pt-BR`, and Arabic RTL.
12. Run the implementation verification set and obtain sub-agent review before final completion.

Document synchronization policy:

- Requirements describe user-facing language behavior, no-tradeoff constraints, and non-scope.
- Specification defines locale metadata, data fields, Settings apply response, React selection order, RTL/LTR boundaries, and validation behavior.
- This implementation plan records edit order, tests, failure recovery, and approval boundaries.
- Task tracker records the implemented checklist and verification state.
- Handoff records restart context, current implemented behavior, verification state, and continuation boundaries.

Verification method:

```bash
./tools/test_dashboard_i18n.sh
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_settings.sh
./tools/test_dashboard_control_center.sh
npm run dashboard:build
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_workflow_pair_sync.sh
```

Run `./tools/test_lesson.sh`, `./tools/test_lesson14.sh`, and `./tools/test_menu_prerequisites.sh` if implementation changes lesson language normalization, menu prerequisite behavior, or setting-file handling.
Run `./tools/test_lesson_repository.sh` only when the test-plan policy, changed files, or developer-approved final gate requires it.
Use escalated browser execution from the first attempt for Playwright visual inspection when required by the active implementation task.

Failure recovery:

- If dictionary completeness fails, fix the shared localization dictionary or policy before touching component rendering.
- If `summary.workflow_language`, `summary.display_locale`, `summary.ui_locale`, or direction disagree, fix producer and validators before changing React fallback behavior.
- If Settings apply succeeds but the immediate locale update and refetched snapshot disagree, keep the snapshot authoritative and add a regression test for the mismatch.
- If Arabic RTL causes technical values to become unreadable, add reusable LTR isolation or logical CSS utilities rather than language-specific page branches.
- If regular CI time grows too much, reduce routine browser locale coverage to representative locales and keep all-language checks static; do not remove dictionary completeness coverage.
- If the same failure repeats three times, a specification conflict appears, or an existing-feature tradeoff seems necessary, stop and request developer direction.

Developer approval boundaries:

- Approval is required before using runtime machine translation, external translation APIs, dependency changes, new browser mutation routes, any Settings writer beyond `tools/dashboard-settings`, any mutation outside allowlisted Settings rows, or any relaxation of schema, same-origin, JSON-only, `execFile`, atomic write, or snapshot-output boundaries.
- Approval is required before changing required CI, pre-commit, final-gate, or aggregate-test coverage in a way that reduces protection.
- Approval is required before accepting unsupported custom languages as Dashboard fixed UI locales or changing the standard language list beyond the AGENTS.MD invariant.
- Approval is required before accepting any tradeoff against STEP 1-7, STEP 1-14, existing docs routes, existing checks, repo-local skills, or security gates.

## Implemented Dashboard Control Center Settings Apply Feedback Implementation Plan

SYNC-ID: dashboard_control_center_settings_apply_feedback
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_i18n.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_control_center.sh
TESTS: tools/test_dashboard_i18n.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh

Implemented change targets:

- `dashboard-control-center/src/App.jsx`: independent Settings apply feedback state, request ids, delayed non-modal status surface, generic Settings row reconciliation, strict `workflow_language` locale reconciliation, snapshot-authoritative mismatch handling, row action labels, and confirmation dialog close-on-success behavior.
- `dashboard-control-center/src/i18n.js`: localized apply-feedback labels, warnings, step labels, and dismiss labels across every standard Dashboard UI locale.
- `dashboard-control-center/src/styles.css`: status-surface layout, indeterminate progress animation with reduced-motion support, wrapping-safe right-end action labels, mobile handling, and separated eyebrow/status label font rules.
- `tests/playwright/dashboard-control-center.spec.js`: behavior coverage for fast path, delayed path, stale snapshot mismatch, no reload, chip removal, action labels, eyebrow size, RTL, and no-overflow.
- Existing `tools/test_dashboard_i18n.sh`, `tools/test_dashboard_settings.sh`, and `tools/test_dashboard_control_center.sh`: remain the reusable standalone and aggregate-capable verification entry points.

Implementation result:

1. Synchronized this contract through the sync contract and the five synchronized documents before runtime changes.
2. Added independent apply-feedback state in `App.jsx` without changing writer endpoints, settings files, producer authority, schema, or mutation scope.
3. Kept writer apply progress in the existing confirmation dialog, then closes that dialog after writer success and runs delayed snapshot reconciliation outside the focus trap.
4. Added named UI-policy timing constants for delayed feedback, auto-close, and timeout.
5. Implemented generic Settings row reconciliation and stricter `workflow_language` summary plus row reconciliation.
6. Kept apply-response locale metadata as immediate UI feedback after server success only; refetched snapshot data clears optimistic locale hints and remains authoritative on mismatch.
7. Removed row changeability chips and moved editable/review labels to the right-end action area and row accessible name.
8. Split modal eyebrow styling from status labels and made only the eyebrow text slightly larger.
9. Added all new fixed labels to every standard Dashboard UI locale and validated dictionary completeness.
10. Extended Playwright coverage through the aggregate dashboard test without adding a new standalone checker.
11. Ran the planned verification set before promoting this sync ID to implemented.

Document synchronization policy:

- Requirements state the user-visible feedback behavior, no-tradeoff constraints, non-scope, and approval boundaries.
- Specification defines the feedback state machine, reconciliation rules, accessibility behavior, row label behavior, and verification contract.
- This implementation plan records edit order, verification commands, recovery behavior, and approval boundaries.
- Task tracker records current implementation state, final verification state, and close-out checklist.
- Handoff records restart context, implemented entry points, known risks, and stop conditions.

Verification method:

```bash
./tools/test_dashboard_i18n.sh
./tools/test_dashboard_settings.sh
./tools/test_dashboard_control_center.sh
./tools/check_ci_workflow_structure.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_workflow_pair_sync.sh
```

`npm run dashboard:build` was run after React, CSS, and i18n runtime changes.
Run broader lesson or repository aggregate checks only when the implementation touches shared lesson settings, producer behavior, CI or hook wiring, schema files, or the final-gate scope requires them.

Failure recovery:

- If apply fails before the writer returns success, keep the existing confirmation dialog error path and do not show saved or reconciliation progress.
- If snapshot refetch fails after writer success, show that the setting was saved but Dashboard reflection confirmation failed or is still pending.
- If a stale snapshot is fetched, continue waiting or time out safely; do not mark reflection complete from stale data.
- If the snapshot conflicts with apply metadata, snapshot data wins and the feedback surface shows a mismatch warning.
- If row-label layout fails for long translated text, fix responsive layout and wrapping rules rather than adding language-specific branches.
- If the same verification failure repeats three times, or a writer, endpoint, schema, CI, pre-commit, or existing-feature tradeoff appears necessary, stop and request developer direction.

Developer approval boundaries:

- Approval is required before adding mutation endpoints, adding writers beyond `tools/dashboard-settings`, expanding Settings mutation scope, changing snapshot schema, adding dependencies, weakening CI or pre-commit coverage, or changing existing editable Settings behavior.
- Approval is required before reducing currently implemented Settings editability, including any proposal to make existing safe Git workflow settings display-only.
- Approval is required before replacing snapshot authority with apply-response authority or keeping an optimistic locale after snapshot disagreement.

## Implemented Dashboard Control Center Settings Consistency Gate Implementation Plan

SYNC-ID: dashboard_control_center_settings_consistency_gate
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,tools/lib/git_workflow_policy.sh,tools/git-workflow,tools/dashboard-settings,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_git_workflow_policy.sh,tools/test_dashboard_i18n.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh
TESTS: tools/test_git_workflow_policy.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_i18n.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh

Implemented change targets:

- `tools/lib/git_workflow_policy.sh`: reusable full-state candidate validator and reason-code vocabulary for Git workflow settings.
- `tools/git-workflow`: route command-line setting updates through the same validator.
- `tools/dashboard-settings`: validate Settings `plan` and `apply` against the candidate full state before writing; keep allowlist, confirmation, atomic write, and snapshot regeneration behavior.
- `tools/lib/dashboard_data.sh` and `tools/dashboard-data`: emit consistency status, effective mode, reason, next action, and context-dependent `not_applicable` data from owner-layer sources.
- `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv` and browser validators: describe and enforce the generic consistency status fields.
- `dashboard-control-center/src/App.jsx`, `dashboardData.js`, `i18n.js`, and `styles.css`: render producer-owned consistency state, blocked candidate feedback, aligned columns, translated labels, and no-overflow layout without policy branching in React.
- Fixtures and tests: cover validator, writer, schema, data, i18n, and browser behavior through existing standalone and aggregate-capable commands.

Implementation order:

1. Keep this sync ID in the five synchronized documents and sync contract before runtime edits.
2. Add the reusable candidate full-state validator in `tools/lib/git_workflow_policy.sh`.
   - Return structured severities and reason codes rather than free-form strings only.
   - Cover no-write-path, branch-dependent automation, worktree-without-branch, approval-gated automation, non-ready merge-precedence display, and compatibility warnings.
   - Preserve current `automation_level` compatibility and do not change merge precedence without approval.
3. Connect `tools/git-workflow set` to the shared validator so CLI and Dashboard writes cannot diverge.
4. Connect `tools/dashboard-settings plan|apply` to the validator.
   - Validate the post-change candidate state.
   - Reject unsafe or impossible candidate states before file writes, including branch-dependent automation with `branch_allowed=false`.
   - Return structured policy rejection JSON with `applied:false` for candidate validation failures so browser feedback remains machine-readable without changing Vite error forwarding.
   - Permit writes that repair an inconsistent current file.
5. Extend dashboard data production.
   - Add generic consistency fields to settings rows and summary surfaces.
   - Add `not_applicable` to the shared schema, producer, and browser vocabulary or introduce a generic applicability field before emitting context-dependent not-applicable rows.
   - Emit context-specific `not_applicable` or blocked states for product repository, lesson repository improvement, external integration, and learner approval source gaps.
   - Keep locale and product-development language behavior separated through the existing locale policy.
6. Update browser validation and UI.
   - Validate new fields before rendering.
   - Render status, reason, and next action from producer data.
   - Keep Settings row columns aligned across desktop, narrow desktop, mobile, and RTL.
   - Preserve no-reload language switching and delayed apply-feedback reconciliation.
7. Update focused tests and aggregate wiring.
   - Extend existing tests instead of adding a new standalone checker unless a new reusable command is introduced.
   - Keep assertions based on reason codes, roles, status keys, and schema fields rather than one exact phrase.
8. Keep this sync ID at `implemented` only after runtime implementation, targeted checks, required aggregate checks, and sub-agent review pass with no unresolved major findings.

Implementation result:

- `tools/lib/git_workflow_policy.sh` now owns the candidate full-state consistency gate, including no-write-path, worktree-without-branch, branch-dependent automation, merge manual/auto-merge display warning, and recovery-write handling for persisted inconsistent settings.
- `tools/git-workflow allow` now rejects runtime action permission while the persisted Git workflow state has blocking consistency rows, so writer validation and runtime authorization share the same owner-layer safety boundary.
- `tools/dashboard-settings plan|apply` returns structured blocked policy JSON with `applied:false` and no snapshot regeneration for ordinary policy rejections while preserving non-zero failures for malformed or boundary-violating requests.
- `tools/dashboard-data` and `tools/lib/dashboard_data.sh` emit producer-owned row-level consistency metadata, effective modes, context-dependent `not_applicable` states, and learner-approval source separation.
- The browser validator and Settings UI accept the shared consistency schema, render blocked/manual-required/not-applicable states without becoming the policy source, preserve no-reload locale switching, and keep Settings rows aligned across representative locales.
- Existing Settings writer allowlists, same-origin POST handling, atomic writes, snapshot regeneration, STEP 1-7, STEP 1-14, CI wiring, Git hooks, pre-commit wiring, and document routes remain additive constraints.

Document synchronization policy:

- Requirements record the user-visible safety goal, no-tradeoff constraints, required outcomes, and non-scope.
- Specification records consistency severity, validator ownership, Git workflow rules, data contract, UI contract, and verification contract.
- This implementation plan records edit targets, order, validation, failure recovery, and approval boundaries.
- Task tracker records implemented work state and verification progress.
- Handoff records restart context, stop conditions, and the decisions that remain approval-bound.

Verification method:

```bash
./tools/test_git_workflow_policy.sh
./tools/test_dashboard_settings.sh
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_i18n.sh
./tools/test_dashboard_control_center.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_workflow_pair_sync.sh
```

Run `npm run dashboard:build` after React, Vite, or CSS runtime changes.
Run `./tools/check_lesson_structure.sh` and `./tools/check_lesson14_structure.sh` as related structure checks when promoting the sync state, while keeping the sync-contract required test list aligned with active CI wiring.
Run `tools/test_lesson_repository.sh` only when changed-file policy, final-gate scope, or developer approval requires the heavier aggregate check.

Final verification evidence:

- `tools/test_lesson_repository.sh` passed after runtime and documentation updates, covering STEP 1-7, STEP 1-14, Dashboard, Git/CI, product gate, and security guard paths.
- `tools/test_dashboard_control_center.sh` passed after the final blocked apply-feedback correction with 15 Playwright tests.
- `npm run dashboard:build` passed after React, i18n, Vite, and CSS changes.
- Multiple read-only xhigh sub-agent reviews found no unresolved major findings after the owner-layer runtime allow gate, UI/data/schema/i18n corrections, and sync-contract TESTS correction.

Failure recovery:

- If the shared validator disagrees between CLI and Settings, stop and fix the owner-layer validator before adjusting React.
- If a persisted settings file is already invalid, add a recovery fixture and ensure the proposed valid candidate can be applied.
- If Dashboard data and Settings writer disagree on severity or reason codes, treat producer/writer consistency as the bug; do not patch the browser to hide the mismatch.
- If a status label or reason overflows, fix reusable layout constraints or translations rather than adding language-specific branches.
- If three repeated failures occur, a specification conflict appears, or an existing-feature tradeoff seems necessary, stop and request developer direction.

Developer approval boundaries:

- Approval is required before changing `automation_level` from compatibility preset or summary into a hard maximum.
- Approval is required before defining detached-worktree behavior when `worktree_allowed=true` and `branch_allowed=false`.
- Approval is required before changing the runtime precedence between `merge_execution=manual` and `developer_auto_merge_allowed=true`; without approval, implementation may only change Dashboard display to a qualified non-ready state.
- Approval is required before changing approval receipt security semantics such as HEAD-SHA binding, expiry, or source authority.
- Approval is required before reducing existing Settings editability, weakening CI/pre-commit coverage, adding dependencies, adding mutation endpoints, adding writers, broadening mutation scope, or accepting any tradeoff against STEP 1-7, STEP 1-14, existing checks, document routes, repo-local skills, or security gates.

## Implemented Product Workflow Git Usage Modes Implementation Plan

SYNC-ID: product_workflow_git_usage_modes
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/MENU_PRODUCT_PROFILE_POLICY.tsv,docs/workflow/PRODUCT_WORKFLOW_GIT_USAGE_POLICY.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,learning/PRODUCT_WORKFLOW_GIT_USAGE_SETTINGS.tsv,learning/context/WORKFLOW_CONTEXT_MAP.tsv,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/lib/product_workflow_git_usage.sh,tools/free-development,tools/product-improvement,tools/external-integration,tools/check_repository_boundary.sh,tools/product-scaffold-check,tools/lib/product_security.sh,tools/product-security,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/dashboard-data,tools/dashboard-settings,tools/lib/dashboard_data.sh,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,vite.config.mjs,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tools/test_product_git_usage_modes.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_product_git_usage_modes.sh,tools/test_product_gate_tools.sh,tools/test_product_scaffold_check.sh,tools/test_product_security.sh,tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_i18n.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh,tools/check_lesson_structure.sh

Implemented change targets:

- `docs/workflow/PRODUCT_WORKFLOW_GIT_USAGE_POLICY.tsv` and `learning/PRODUCT_WORKFLOW_GIT_USAGE_SETTINGS.tsv` define Git usage applicability separately from existing Git workflow action settings.
- `tools/lib/product_workflow_git_usage.sh` resolves `none`, `local`, `remote_sync`, and `ci` to product workspace, Git worktree, remote sync, CI, and dashboard applicability requirements.
- `tools/free-development`, `tools/product-improvement`, and `tools/external-integration` gates call the shared helper instead of hard-coding Git sync and CI checks.
- Repository-boundary, product-scaffold, product-security, product authority, and product-gate evidence handling distinguish product workspace checks from Git worktree checks.
- Dashboard data, schema, browser validation, Settings writer, Settings UI labels, command previews, fixtures, and tests render producer-owned Git/CI applicability.
- `tools/test_product_git_usage_modes.sh` is a standalone and aggregate-capable test for the product workflow Git usage mode matrix.

Implementation result:

1. Added the owner-layer policy, settings file, and helper first, with default mode `ci` preserving the existing strict behavior when no explicit setting exists.
2. Added persisted and candidate product workflow mode validation before Settings writes. Invalid modes fail before any file update.
3. Replaced repeated Git/CI gate calls in the three product-scoped menu tools with shared helper gates.
4. Split product workspace and Git worktree assumptions in boundary, scaffold, security, and authority code without making `none` bypass documents, scaffold, security, approvals, or local checks.
5. Kept `.git`-less authoritative evidence storage out of scope. Non-Git and non-CI evidence is represented as `not_applicable` until a future approved evidence-storage design exists.
6. Extended `DASHBOARD_DATA_SCHEMA.tsv`, producer output, browser validation, Settings catalog, Settings writer, localization, and fixtures together so React remains a renderer.
7. Updated command previews and manual follow-ups so required Git/CI commands appear only when the mode requires them.
8. Added the mode-matrix test and connected it to aggregate repository checks, CI workflow structure, Git hook metadata, final-gate coverage, and test-plan policy.
9. Promoted the sync ID from `planned` to `implemented` after targeted checks passed and before final aggregate closure.

Document synchronization policy:

- Requirements record user-facing mode behavior, no-tradeoff guarantees, and non-scope.
- Specification records mode semantics, owner-layer data, gate behavior, Settings/UI behavior, evidence boundaries, and verification contract.
- This implementation plan records implemented targets, validation, recovery, and approval boundaries.
- Task tracker records final implementation state and verification checklist.
- Handoff records restart context, active constraints, verification state, and stop conditions.

Verification method:

```bash
./tools/test_product_git_usage_modes.sh
./tools/test_product_gate_tools.sh
./tools/test_product_scaffold_check.sh
./tools/test_product_security.sh
./tools/test_product_repository_authority.sh
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_settings.sh
./tools/test_dashboard_i18n.sh
./tools/test_dashboard_control_center.sh
./tools/check_ci_workflow_structure.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_workflow_pair_sync.sh
./tools/check_lesson_structure.sh
./tools/check_lesson14_structure.sh
./tools/test_lesson_repository.sh
```

The standalone product workflow Git usage mode test is implemented and wired into the aggregate repository test. The full aggregate repository test is the final closure check for this sync ID.

Failure recovery:

- If `ci` mode behavior changes, stop and restore current strict behavior before continuing.
- If `none` appears to pass by bypassing documents, scaffold, security, approval, or local checks, treat that as a safety regression.
- If Dashboard data and gate behavior disagree, fix the shared owner-layer helper before changing React.
- If `.git`-less evidence storage cannot be made authoritative without a new security decision, stop and request developer approval.
- If the same failure repeats three times, a specification conflict appears, or an existing-feature tradeoff seems necessary, stop and request developer direction.

Developer approval boundaries:

- Approval is required for the `.git`-less evidence index path, freshness model, and `product_head` replacement.
- Approval is required before changing STEP 1-7, STEP 1-14, existing strict Git/CI completion gates, CI/pre-commit coverage, repo-local skill behavior, or product-security guarantees.
- Approval is required before adding dependencies, external services, browser mutation routes, writers beyond `tools/dashboard-settings`, evidence writers, Git/GitHub/CI execution from the dashboard, product repository mutation, push, merge, cleanup, deletion, OAuth, credentials, or destructive operations.
- Approval is required before accepting unsupported product workflow modes beyond `none`, `local`, `remote_sync`, and `ci`.

## Implemented Lesson Repository Development Workflow Skill Implementation Plan

SYNC-ID: lesson_repository_development_workflow_skill
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/REPOSITORY_DEVELOPMENT_WORKFLOW.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,learning/REPOSITORY_DEVELOPMENT_APPROVALS.tsv,skills/lesson-repository-development/SKILL.md,skills/lesson-repository-development/references/repository-development.md,skills/lesson-repository-development/agents/openai.yaml,tools/lib/repository_development_workflow.sh,tools/repository-development-workflow,tools/check_repository_development_workflow.sh,tools/test_repository_development_workflow.sh,tools/check_agents_skills.sh,tools/test_lesson_repository.sh,tools/check_ci_workflow_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_repository_development_workflow.sh,tools/test_repository_development_workflow.sh

This implemented plan records the runtime workflow support for lesson-repository development. The implementation is additive: AGENTS.MD remains the highest-priority rule source, the policy TSV is the owner layer for phase data, and release proof stays separate from fast implementation loops.

Implemented order:

1. Added `docs/workflow/REPOSITORY_DEVELOPMENT_WORKFLOW.tsv` with stable phase ids for `context_triage`, `proposal`, `implementation_plan`, `fast_loop`, `mid_tests`, `release_gate`, and `main_sync_cleanup`, including recommended checks, required checks, approvals, Git/CI expectations, cleanup behavior, and stop conditions.
2. Added `learning/REPOSITORY_DEVELOPMENT_APPROVALS.tsv` so approval-bound workflow phases have explicit default state.
3. Added `skills/lesson-repository-development/SKILL.md`, `skills/lesson-repository-development/references/repository-development.md`, and `skills/lesson-repository-development/agents/openai.yaml`, with concise skill routing and detailed reference guidance.
4. Added `tools/lib/repository_development_workflow.sh` and `tools/repository-development-workflow` with `status`, `plan`, `check`, `gate`, `guidance`, and `list` commands backed by the TSV owner layer.
5. Added `tools/check_repository_development_workflow.sh` and `tools/test_repository_development_workflow.sh` covering malformed policy rows, missing wiring, missing PR/main CI and local/remote sync requirements, weakened AGENTS invariants, fast-loop versus release-gate separation, and cleanup-plan safety.
6. Wired the new check and test into `tools/check_agents_skills.sh`, `docs/workflow/GIT_HOOK_CHECKS.tsv`, `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv`, `docs/workflow/TEST_PLAN_MANIFEST.tsv`, `docs/workflow/FINAL_GATE_COVERAGE.tsv`, `tools/test_lesson_repository.sh`, `tools/check_ci_workflow_structure.sh`, `.github/workflows/ci.yml`, and `.github/workflows/lesson14-ci.yml`.
7. Added the minimal AGENTS.MD route needed for repository-local skill discovery while preserving the no-tradeoff invariant and existing repo-local skill routing.
8. Promoted the sync ID from `planned` to `implemented` after the runtime implementation and focused checks were in place.

Document synchronization policy:

- Requirements record the capability, safety constraints, ownership boundaries, and non-scope.
- Specification records the policy TSV contract, CLI behavior, validation semantics, phase behavior, verification contract, and approval boundaries.
- This implementation plan records file order, wiring order, verification sequence, failure recovery, and promotion conditions.
- Task tracker records current work state and pending closure tasks.
- Handoff records restart context, next safe action, dirty-worktree cautions, and stop conditions.

Verification sequence:

```bash
bash -n tools/lib/repository_development_workflow.sh tools/repository-development-workflow tools/check_repository_development_workflow.sh tools/test_repository_development_workflow.sh
./tools/check_repository_development_workflow.sh
./tools/test_repository_development_workflow.sh
./tools/check_agents_skills.sh
./tools/check_test_plan_coverage.sh
./tools/test_test_plan.sh
./tools/test_git_hooks.sh
./tools/test_git_hooks_parallel.sh
./tools/check_ci_workflow_structure.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_workflow_pair_sync.sh
./tools/check_lesson_structure.sh
./tools/check_lesson14_structure.sh
./tools/test_lesson_repository.sh
```

PR CI, merge, main CI, local/remote sync, and cleanup are closure-phase actions. They must not be forced during fast implementation loops unless the developer explicitly requests that phase.

Failure recovery:

- If policy TSV parsing disagrees between CLI, checks, hooks, aggregate, and CI, fix the shared owner layer before adjusting callers.
- If the workflow recommends fewer required release checks than the existing gates, treat it as a blocker rather than a time optimization.
- If cleanup guidance can delete state without explicit approval, remove the executable path and keep only an approval-bound cleanup plan.
- If the new skill conflicts with `worklog-doc-sync`, `lesson-sync-gate`, AGENTS.MD, existing document routes, STEP 1-7, STEP 1-14, CI, or security gates, stop and request developer approval.
- If the same failure repeats three times, or if a specification conflict or existing-feature tradeoff appears necessary, stop and report the blocker.

Developer approval boundaries:

- Approval is required before editing AGENTS.MD, pre-commit, CI, final-gate coverage, branch/worktree deletion, remote deletion, product-repository deletion, push, merge, main CI waiting, local/remote sync, or any destructive operation.
- Approval is required before weakening existing gates, removing required checks, changing STEP 1-7 or STEP 1-14 behavior, changing repo-local skill ownership, or accepting an existing-feature tradeoff.
