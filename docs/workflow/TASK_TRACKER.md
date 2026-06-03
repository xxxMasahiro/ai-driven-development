# TASK_TRACKER.md

## Current Status

The lesson repository includes mechanical enforcement, flexible lesson entry, Free Development Mode, Team Development and Docker advanced module, dialogue-centered learning, as-built synchronization checks, sub-agent review protocol, menu/dashboard/illustration entry points, 7-day and 14-day lesson language controls, and lesson-side aggregate testing.

The previous implemented change promotes the Git workflow policy into a shared menu-level policy for menu items 1 through 7, including branch permission, `git worktree` permission, direct-main permission, automation level, Git monitoring, and non-destructive cleanup planning.
The previous implemented change added user-configurable Git workflow policy settings and the as-built sync contract that mechanically enforces synchronization across the three design/as-built documents and the two workflow-state documents.
The current implemented Git workflow action settings split Git workflow behavior into detailed settings for commit, push, PR creation, PR CI monitoring, merge execution, developer-responsibility auto-merge, main CI monitoring, and local/remote sync monitoring.
The current implemented Git hooks policy provides faster safe serial pre-commit operation through `full`, `fast`, and `minimal` modes plus conservative Git-local caching.
The current planned learner context foundation prepares source documents under `learning/context/` for the next lesson-content implementation cycle; runtime lesson output has not been changed by that foundation step.
Safe product repository cleanup remains implemented for the external product repository created by the 7-day or 14-day lessons.
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
- Added `tools/product-repository-cleanup status|plan|local|remote`.
- Added `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv`.
- Added `tools/check_as_built_sync_contract.sh`.
- Added `tools/as-built-sync status`.
- Added `tools/test_as_built_sync_contract.sh`.
- Added `docs/workflow/GIT_WORKFLOW_POLICY.tsv`.
- Added `learning/GIT_WORKFLOW_SETTINGS.tsv`.
- Added `tools/lib/git_workflow_policy.sh`.
- Added `tools/git-workflow status|configure|set|allow|check|cleanup-plan`.
- Added `tools/test_git_workflow_policy.sh`.
- Added `docs/workflow/GIT_HOOKS_POLICY.tsv`.
- Added `docs/workflow/GIT_HOOK_CHECKS.tsv`.
- Added `learning/GIT_HOOK_SETTINGS.tsv`.
- Added `tools/lib/git_hooks_policy.sh`.
- Added `tools/git-hooks status|mode|cache|run`.
- Added `tools/test_git_hooks.sh`.
- Added planned learner context source documents under `learning/context/`.
- Added `learning/context/AI_DRIVEN_DEVELOPMENT_FOUNDATION.md`.
- Added `learning/context/SECURITY_FOUNDATION.md`.
- Added `learning/context/LESSON_CONTEXT_MAP.tsv`.
- Added AGENTS routing and standard-check references for the sync-contract status and validator.
- Added dashboard readiness output for menu items 1 through 6.
- Added menu prerequisite tests and wired them into aggregate tests, CI, and pre-commit.
- Added product repository cleanup tests and wired them into structure checks, as-built checks, developer-memory checks, aggregate tests, CI, and pre-commit.
- Added as-built sync-contract enforcement and wired it into structure checks, as-built checks, aggregate tests, CI, and pre-commit.
- Added Git workflow policy tests and wired them into structure checks, as-built checks, aggregate tests, CI, and pre-commit.
- Added Git hooks policy tests and wired them into structure checks, aggregate tests, CI, and pre-commit.
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

- The implemented as-built sync-contract behavior is synchronized into the three design/as-built documents:
  - `docs/as-built/REQUIREMENTS.md`
  - `docs/as-built/SPECIFICATION.md`
  - `docs/as-built/IMPLEMENTATION_PLAN.md`
- The same implemented state is synchronized into the two workflow-state documents:
  - `docs/workflow/TASK_TRACKER.md`
  - `docs/workflow/HANDOFF.md`
- The implemented product repository cleanup behavior remains synchronized in the same five documents.
- The implemented menu prerequisite control remains synchronized in the same five documents.
- The implemented Git workflow policy behavior is synchronized in the same five documents.
- The implemented Git hooks policy behavior is synchronized in the same five documents.
- The planned learner context foundation is synchronized in the same five documents as documentation foundation work for the next implementation plan.
- The synchronization passes only when the implemented content is present in all five documents.
- Preserve refactorability, ecosystem fit, reusable design, generality, and the no-existing-feature-tradeoff rule while maintaining the implemented remediation.

## Implemented Documentation Map Synchronization

The lesson now explains the repository's rule, routing, skill, design, workflow, and memory documents in a way that non-engineer learners can understand.
Runtime implementation is complete and the docs map artifacts are present.

- Added `guides/DOCUMENT_MAP.md`.
- Explain `AGENTS.MD` invariant rules, document root, routing table, and repo-local skills as the agent-facing rule and navigation layer.
- Distinguish lesson-side `AGENTS.MD` from product-side `AGENT.md`.
- Explain `docs/as-built/` as the requirements, specification, and implementation-plan area.
- Explain `docs/workflow/` as the task-tracker and handoff area.
- Explain `docs/workflow/GIT_HOOKS_POLICY.tsv`, `docs/workflow/GIT_HOOK_CHECKS.tsv`, and `learning/GIT_HOOK_SETTINGS.tsv` as Git hook policy and current local hook-mode controls.
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

## Implemented Product Repository Cleanup Synchronization

The lesson now provides a safe, explicit cleanup path for the external product repository created by the 7-day or 14-day lessons.
Runtime implementation is complete.

- Added `tools/product-repository-cleanup`.
- Support `status`, `plan`, `local`, and `remote` subcommands.
- Keep `status` and `plan` non-destructive.
- Require explicit confirmation for local cleanup with the configured product repository name, such as `task-tracker-repository`.
- Require explicit confirmation for remote cleanup with the full GitHub owner/repository name, such as `xxxMasahiro/task-tracker-repository`.
- Keep local deletion and remote deletion separate; do not add `all` or automatic chained deletion.
- Reject local deletion unless the target is the configured external product repository path, normally `$HOME/projects/task-tracker-repository`.
- Reject local deletion when the target is inside the lesson repository, does not match the configured product repository name, is not a Git repository, lacks `.git`, is not the Git top level, or cannot be identified safely.
- Require GitHub authentication and a successful remote repository lookup before any remote deletion attempt.
- Show the remote URL and owner/repository name before any remote deletion.
- Print a clear operation log for status, plan, local cleanup, and remote cleanup paths.
- Added `tools/test_product_repository_cleanup.sh`.
- Test status, plan, missing confirmation, wrong confirmation, nested repository rejection, non-Git target rejection, temporary local cleanup behavior, and fake-`gh` remote deletion behavior.
- Do not delete a real GitHub repository in lesson-repository tests.
- Wired the cleanup test into structure checks, as-built checks, developer-memory checks, aggregate tests, CI, and pre-commit.
- Exposed runtime discovery through README, AGENTS routing, menu item 5, and the dashboard development view.
- Preserve existing lesson progression, approvals, checks, menu behavior, dashboard behavior, Free Development, Product Improvement, external-integration, product-gate, Playwright, docs-tour, CI, and pre-commit behavior.

## Implemented As-Built Sync Contract Synchronization

The lesson now strengthens mechanical enforcement across the three design/as-built documents and the two workflow-state documents.
Runtime implementation is complete.

- Added `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv` as the contract source for synchronized improvement IDs.
- Record each synchronized improvement with `sync_id`, `status`, `title`, `required_artifacts`, `required_tests`, `required_docs`, and `runtime_evidence`.
- Added matching `SYNC-ID`, `STATUS`, `ARTIFACTS`, and `TESTS` blocks to all five synchronized documents:
  - `docs/as-built/REQUIREMENTS.md`,
  - `docs/as-built/SPECIFICATION.md`,
  - `docs/as-built/IMPLEMENTATION_PLAN.md`,
  - `docs/workflow/TASK_TRACKER.md`,
  - `docs/workflow/HANDOFF.md`.
- Added `tools/check_as_built_sync_contract.sh`.
- Fail when a contract sync ID is missing from any of the five documents.
- Fail when any of the five documents contains a `SYNC-ID` block that is absent from the contract.
- Fail when the same sync ID is marked `planned` in one document and `implemented` in another.
- Fail when document `ARTIFACTS` or `TESTS` blocks contain extra or missing entries compared with the contract.
- Fail when required artifacts or required tests are missing from the repository.
- Fail when runtime evidence files are missing or do not reference the sync ID, one of its artifacts, or one of its tests.
- Fail when an implemented sync ID's required tests are not actively wired into `tools/test_lesson_repository.sh`, `.githooks/pre-commit`, `.github/workflows/ci.yml`, and `.github/workflows/lesson14-ci.yml`.
- Keep `tools/check_as_built_docs.sh` and its topic-based checks active.
- Call `tools/check_as_built_sync_contract.sh` from `tools/check_as_built_docs.sh`.
- Keep `tools/check_workflow_pair_sync.sh` active for the `TASK_TRACKER.md` and `HANDOFF.md` pair.
- Added `tools/as-built-sync status` to show sync IDs, document coverage, artifact presence, and test wiring.
- Added `tools/test_as_built_sync_contract.sh`.
- Test complete synchronization, missing document block, unknown sync ID, mixed status, extra artifacts/tests, missing artifact, inert wiring, and missing active test-wiring failure paths.
- Added `AGENTS.MD` routing and standard-check references for sync-contract status and validation.
- Wired the validator and regression test into `tools/check_as_built_docs.sh`, `tools/test_lesson_repository.sh`, `.githooks/pre-commit`, `.github/workflows/ci.yml`, and `.github/workflows/lesson14-ci.yml`.
- Preserve existing lesson progression, approvals, checks, menu behavior, dashboard behavior, docs-tour, Free Development, Product Improvement, external-integration, product-gate, product-repository cleanup, Playwright, CI, and pre-commit behavior.

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

## Planned Learner Context Foundation Synchronization

The lesson now has a planned learner-context foundation for the next implementation cycle.
This is documentation foundation work only; lesson runtime output is not yet changed.

- Added `learning/context/README.md`.
- Added `learning/context/AI_DRIVEN_DEVELOPMENT_FOUNDATION.md`.
- Added `learning/context/SECURITY_FOUNDATION.md`.
- Added `learning/context/LESSON_CONTEXT_MAP.tsv`.
- Updated `guides/DOCUMENT_MAP.md` so the context directory is discoverable.
- Added `learner_context_foundation` to `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv` with `STATUS: planned`.
- Added matching planned sync blocks to the three as-built documents and the two workflow-state documents.
- Preserved existing 7-day, 14-day, menu, dashboard, Git workflow, Git hooks, docs-tour, product-repository cleanup, sync-contract, CI, and pre-commit behavior.
- Next implementation work should connect the context map to lesson openings, per-topic explanations, final recaps, prompt display, security guidance, and dashboard review surfaces.

## Implemented Git Workflow Policy Synchronization

The Git workflow policy lets users choose how much Git management and Git automation the workflow agent may perform.
This is implemented runtime behavior.
It is additive and does not trade away existing lesson progression, approvals, menu behavior, dashboard behavior, Free Development, Product Improvement, external-integration, product-repository cleanup, CI, pre-commit, or as-built sync-contract behavior.

- Added `docs/workflow/GIT_WORKFLOW_POLICY.tsv` for supported Git workflow policy definitions.
- Added `learning/GIT_WORKFLOW_SETTINGS.tsv` for the current user-selected Git workflow settings.
- Added `tools/lib/git_workflow_policy.sh` for shared setting loading, validation, permission checks, automation-level helpers, repository-context detection, and Git monitoring.
- Added `tools/git-workflow status|configure|set|allow|check|cleanup-plan` as the learner/agent command surface.
- Support working-branch permission, `git worktree` permission, and main-direct-work permission.
- Support automation levels:
  - `manual`: guidance only.
  - `commit`: commit may be automated after checks pass.
  - `pr_ci`: push, PR creation where applicable, and CI checks may be automated.
  - `sync`: main CI plus local/remote synchronization checks may be automated.
- Keep merge, branch deletion, worktree deletion, remote deletion, and other destructive operations behind explicit confirmation regardless of automation level.
- Monitor uncommitted changes, unpushed commits, local/remote divergence, unnecessary working branches, unnecessary worktrees, and whether the current repository is the lesson, product, or a custom repository.
- Separate lesson-repository Git state from product-repository Git state so the workflow cannot mix repositories.
- Keep cleanup planning non-destructive.
- Reuse existing repository-boundary, Git sync, menu prerequisite, dashboard, and aggregate-test patterns.
- Added `tools/test_git_workflow_policy.sh` for settings validation, permission decisions, automation-level decisions, dirty-state detection, local/remote sync monitoring, repository separation, and non-destructive cleanup planning.
- Wired validation into structure checks, as-built checks, aggregate tests, CI, and pre-commit.

## Implemented Menu-Wide Git Workflow Policy Synchronization

The implemented improvement promotes Git workflow policy from an independent support setting to a shared menu-level policy.
This is runtime behavior.
It is additive and does not trade away existing lesson progression, approvals, menu behavior, dashboard behavior, Free Development, Product Improvement, External Integration, product-repository cleanup, CI, pre-commit, or as-built sync-contract behavior.

- Keep `tools/git-workflow status|configure|set|allow|check|cleanup-plan` as the existing policy source.
- Make menu categories reference the same Git policy:
  - learning paths: 7-day, 14-day, and applied lesson,
  - building/extending paths: Free Development Mode, Product Improvement, and External Integration,
  - maintenance path: lesson repository improvement.
- Show Git policy readiness in `tools/menu readiness` for menu items 1 through 7.
- Added Git policy validation to `tools/menu check <1|2|3|4|5|6>` without weakening existing menu prerequisites.
- Added `tools/menu check 7` and `tools/menu start 7 --confirm` as a safe lesson-maintenance path.
- Keep `automation_level=manual` valid and non-blocking.
- Interpret automation levels consistently as guidance-only, commit, PR/CI, and sync scopes.
- Keep destructive Git operations behind explicit confirmation regardless of automation level.
- Show menu-wide Git policy status in dashboard output.
- Added tests for valid policy readiness, invalid policy values, item 1 through 7 checks, missing policy files, and no-tradeoff behavior.

## Implemented Git Workflow Action Settings Synchronization

The implemented improvement splits Git workflow automation into action-by-action manual or automatic settings.
It remains additive and must not trade away existing Git policy, menu, dashboard, cleanup, CI, pre-commit, or as-built sync-contract behavior.

- Keep existing settings:
  - `branch_allowed`
  - `worktree_allowed`
  - `main_direct_work_allowed`
  - `automation_level`
- Treat `automation_level` as a compatibility preset.
- Detailed settings take precedence only when the detailed setting key is present.
- Fall back to `automation_level` when a detailed setting key is absent so current implemented behavior is preserved.
- Add detailed settings:
  - `commit_automation: manual|auto`
  - `push_automation: manual|auto`
  - `pr_creation: manual|auto`
  - `pr_ci_monitoring: manual|auto`
  - `merge_execution: manual|after_approval`
  - `developer_auto_merge_allowed: false|true`
  - `main_ci_monitoring: manual|auto`
  - `sync_monitoring: manual|auto`
- Implemented defaults:
  - `commit_automation: auto`
  - `push_automation: manual`
  - `pr_creation: manual`
  - `pr_ci_monitoring: auto`
  - `merge_execution: after_approval`
  - `developer_auto_merge_allowed: false`
  - `main_ci_monitoring: auto`
  - `sync_monitoring: auto`
- These detailed defaults are active after implementation; `automation_level` remains available as a compatibility preset when detailed action keys are absent.
- Add shared action-mode resolution in `tools/lib/git_workflow_policy.sh` for `commit`, `push`, `pr`, `ci`, `pr_ci`, `merge`, `main_ci`, and `sync`.
- Keep `ci` as a compatibility alias for CI monitoring so existing `tools/git-workflow allow ci` behavior is preserved.
- Keep `tools/git-workflow status|configure|set` as the setting surface.
- Show detailed settings in `tools/menu readiness` and `tools/dashboard menu`.
- Apply the settings to menu items 1 through 7.
- For push and PR creation, `auto` means the agent may execute the operation only after explicit approval for that operation is recorded; it never means approval-free execution.
- `merge_execution: after_approval` means the agent may execute merge only after explicit merge approval is recorded.
- `learning/GIT_WORKFLOW_APPROVALS.tsv` stores matching action, repository, and branch approval receipts for detailed push, PR creation, and normal merge execution.
- `developer_auto_merge_allowed: true` is the only implemented path for developer-responsibility approval-free merge and requires PR CI success, clear target PR and branch, verified merge base, clean working tree, checked local/remote state, and stop-on-failure behavior.
- Developer-responsibility auto-merge requires gate evidence plus actual repository checks; the setting alone does not permit approval-free merge.
- Keep branch deletion, worktree deletion, remote deletion, and product repository deletion behind explicit user confirmation regardless of merge settings.
- Add tests for defaults, valid changes, invalid values, detailed-setting precedence, menu display, dashboard display, and preservation of existing workflows.

## Implemented Git Hooks Policy Synchronization

The implemented improvement provides the runtime path for faster pre-commit execution.
It is synchronized as `git_hooks_policy` with `STATUS: implemented`.

- Keep the current pre-commit behavior as the safety baseline.
- Keep hooks serial and avoid a normal learner-facing `off` mode.
- Add implemented modes:
  - `full`: current-equivalent required pre-commit coverage.
  - `fast`: conservative cache-assisted execution that skips only checks with unchanged successful inputs.
  - `minimal`: quick local mechanical feedback that is not enough for final completion by itself.
- Store cache data outside version control under a Git-local cache path such as `.git/pre-commit-cache/`.
- Fail closed on missing, stale, corrupted, or unverifiable cache entries.
- Fail closed on malformed `docs/workflow/GIT_HOOK_CHECKS.tsv` rows, including invalid or empty mode tokens.
- Store the hook check list in `docs/workflow/GIT_HOOK_CHECKS.tsv`.
- Provide a reusable command surface for hook status, mode selection, cache clearing, normal run, no-cache run, and explicit mode run.
- Connect the implementation to existing settings files, `tools/lib` helpers, aggregate tests, CI, pre-commit, and repo-local skills.
- Preserve existing wiring enforcement by teaching the existing checks and status output to recognize runner-based pre-commit dispatch.
- Keep CI and completion verification on full or no-cache execution.
- Add `tools/test_git_hooks.sh` for standalone policy/cache validation, invalid persisted settings, malformed check rows, invalid or empty mode tokens, invalidation, no-cache behavior, minimal-mode coverage, failing-check cache refusal, and safe cache clearing.
- Verify full/no-cache coverage, aggregate wiring, CI wiring, and preservation of existing checks through `tools/git-hooks run --mode full --no-cache`, `.githooks/pre-commit`, `tools/test_lesson_repository.sh`, and the CI workflow definitions.
- Require developer approval before changing the minimal-mode required check list or using cache to skip Playwright-related checks beyond the implemented fail-closed behavior.

## Implemented Menu Prerequisite Control

Shared menu prerequisite control is implemented without replacing existing lesson or product workflows.

- Rename the learner-facing menu item to `3. 応用レッスン`.
- Keep the Team Development and Docker path available through the renamed applied-learning item.
- Require learning mode, workflow display language, product development language, repository context/boundary confirmation where relevant, and learner approval before starting menu items 1 through 6.
- Reuse existing 7-day and 14-day settings where available.
- For applied-learning, Free Development Mode, product improvement, and external integration, inherit the most recently configured structured-lesson settings when possible; otherwise require missing settings before start or gate passage.
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

Implemented local verification reached this target after synchronizing the 7-day parity implementation and the expanded language-list implementation.
The implemented verification target also includes `Menu prerequisite tests passed.`
The implemented verification target also includes `Product repository cleanup tests passed.`
The implemented verification target also includes `As-built sync contract tests passed.`
The implemented verification target also includes `Git workflow policy tests passed.`
The implemented verification target also includes `Git hooks policy tests passed.`
The implemented verification sequence includes `./tools/check_as_built_sync_contract.sh`, `./tools/as-built-sync status`, `./tools/test_as_built_sync_contract.sh`, `./tools/test_git_workflow_policy.sh`, `./tools/test_git_hooks.sh`, `./tools/git-hooks run --mode full --no-cache`, and `.githooks/pre-commit`.
Real product operations testing remains available through `tools/test_production_operations.sh` when an external product repository is intentionally recreated.

## Remaining Work

- Commit and push only after all local checks pass.
- Translate remaining learner-facing Markdown files to English using the audit output from `tools/list_non_english_docs.sh`.
