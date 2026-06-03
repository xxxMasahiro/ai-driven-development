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
ARTIFACTS: .githooks/pre-commit, docs/workflow/GIT_HOOKS_POLICY.tsv, docs/workflow/GIT_HOOK_CHECKS.tsv, learning/GIT_HOOK_SETTINGS.tsv, tools/lib/git_hooks_policy.sh, tools/git-hooks, tools/test_git_hooks.sh
TESTS: tools/test_git_hooks.sh

SYNC-ID: learner_context_foundation
STATUS: planned
ARTIFACTS: learning/context/README.md,learning/context/AI_DRIVEN_DEVELOPMENT_FOUNDATION.md,learning/context/SECURITY_FOUNDATION.md,learning/context/LESSON_CONTEXT_MAP.tsv
TESTS: tools/test_lesson_repository.sh
```

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
   - Added `learning/GIT_HOOK_SETTINGS.tsv`.
   - Added shared shell helpers in `tools/lib/git_hooks_policy.sh`.
   - Kept mode names and accepted values centralized so future tools, dashboard output, repo-local skills, and tests can reuse the same source.

3. Add a hook runner command.
   - Added `tools/git-hooks status`.
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

6. Connect to existing ecosystem surfaces.
   - Updated `.githooks/pre-commit` to call `tools/git-hooks run`.
   - Wired the dedicated hook test into `tools/test_lesson_repository.sh`.
   - Added CI coverage for the hook test and for full/no-cache behavior.
   - Added AGENTS routing and standard-check references for the hook command and test.
   - Updated existing wiring checks and status output so runner-based hook dispatch is recognized as active pre-commit wiring for the current hook mode.

7. Add standalone and aggregate tests.
   - Added `tools/test_git_hooks.sh` for modes, invalid mode rejection, invalid persisted settings, malformed check rows, invalid or empty check-row mode tokens, cache hits, cache misses, invalidation, no-cache operation, minimal-mode required checks, failing-check cache refusal, and safe cache clearing.
   - Confirm existing pre-commit checks still run in `full` through `tools/git-hooks run --mode full --no-cache`.
   - Confirm aggregate tests, CI, and pre-commit include the new hook validation after implementation.
   - Confirm existing 7-day, 14-day, Git workflow policy, menu, dashboard, docs-tour, product cleanup, sync-contract, and CI behavior remains available.

8. Plan recovery behavior.
   - If a cache bug is suspected, clear the cache and rerun with `--no-cache`.
   - If hook-runner integration fails, restore the current serial `.githooks/pre-commit` command list while preserving the new tests for diagnosis.
   - If minimal-mode scope conflicts with safety expectations, stop for developer approval.
   - If CI behavior diverges from local hooks, keep CI on full/no-cache verification and fix local runner behavior.

9. Synchronize after implementation.
   - Moved `git_hooks_policy` from `planned` to `implemented`.
   - Replaced `ARTIFACTS: none` and `TESTS: none` with the implemented files and tests.
   - Updated these five synchronized documents and `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv` together.
   - Keep unrelated existing content unchanged.

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
