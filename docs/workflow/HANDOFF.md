# HANDOFF.md

## Current State

The lesson repository is in an implemented as-built sync-contract state with implemented Git workflow policy settings and implemented menu-wide Git workflow policy controls.
The current validation scope is lesson-side only; it must not recreate or depend on `task-tracker-repository`.
Existing 7-day lessons, 14-step lessons, free-development flow, advanced modules, checks, and repository-boundary behavior must not be weakened or replaced.
The implementation adds `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv`, `tools/check_as_built_sync_contract.sh`, `tools/as-built-sync`, `tools/test_as_built_sync_contract.sh`, `docs/workflow/GIT_WORKFLOW_POLICY.tsv`, `learning/GIT_WORKFLOW_SETTINGS.tsv`, `tools/lib/git_workflow_policy.sh`, `tools/git-workflow`, and `tools/test_git_workflow_policy.sh`; it also extends `tools/menu`, `tools/dashboard`, and `tools/test_menu_prerequisites.sh` for menu-wide Git policy controls while preserving product repository cleanup, shared menu prerequisite control for menu items 1 through 6, refactorability, ecosystem fit, reusable design, generality, and the no-existing-feature-tradeoff rule.
The implemented Git workflow policy now applies at menu level for items 1 through 7 and preserves all existing Git sync, CI, menu, dashboard, cleanup, lesson, and as-built synchronization behavior.
The current implemented Git workflow action settings separate Git workflow actions into detailed controls for commit, push, PR creation, PR CI monitoring, merge execution, developer-responsibility auto-merge, main CI monitoring, and local/remote sync monitoring while preserving existing broad Git settings and menu-wide Git policy behavior.
The current implemented Git hooks policy provides faster safe serial pre-commit behavior with `full`, `fast`, and `minimal` modes, conservative Git-local caching, and a path-based recommendation for when local full/no-cache should be run before push.
The current implemented resource-budgeted parallel guard captures the developer-approved implementation proposal for safe optional parallel execution based on user-configured memory and swap budgets; runtime policy, settings, CLI, Git hooks integration, Playwright worker recommendation, CI wiring, and tests are present.
The current planned learner context foundation adds source documents under `learning/context/` for the next lesson-content implementation cycle; it does not yet change runtime lesson output.
The current planned learner context runtime integration separates learning context from workflow context; Free Development Mode must remain a workflow and must not be implemented as a lesson.

## Key Implemented Capabilities

- 14-day approval enforcement.
- Learning mode A/B/C selection and switching for 7-day and 14-day lessons.
- Workflow display language and product development language selection for 7-day and 14-day lessons.
- Standard language choices: `ja`, `en`, `ko`, `zh-CN`, `zh-TW`, `es`, `pt-BR`, `fr`, `de`, `id`, `vi`, `th`, `hi`, and `ar`.
- Backward compatibility: `zh` remains accepted and is recorded as `zh-CN`; non-empty unsupported values remain available as `custom`.
- Entry-step gates requiring learning mode, workflow display language, and product development language before passing `setup.index` in both structured lesson versions.
- Learner-selected start positions.
- Free Development Mode.
- Team Development and Docker advanced module.
- Dialogue and wall-bouncing as core AI-driven development learning.
- Role-based sub-agent use and orchestration.
- MCP purpose-before-workflow guidance for Step 13/14.
- Developer-memory requirement checks.
- Learner-facing menu, dashboard, and illustration review entry points.
- Menu item 3 is `3. 応用レッスン`.
- Menu items 1 through 7 have shared Git workflow policy visibility; menu items 1 through 6 also have shared prerequisite checks for learning mode, workflow display language, product development language, repository boundary where relevant, and learner approval before start.
- `status` commands remain non-blocking; `start`, `gate`, and `check` enforce prerequisites.
- `tools/product-improvement status|start|gate` provides the mechanical entry for product improvement.
- `tools/product-repository-cleanup status|plan|local|remote` provides the mechanical entry for safe product repository cleanup.
- `tools/check_as_built_sync_contract.sh` provides the mechanical five-document synchronization contract check.
- `tools/as-built-sync status` provides the learner/agent-facing sync-contract status view.
- `tools/test_as_built_sync_contract.sh` covers sync-contract success and failure paths.
- `tools/git-workflow status|configure|set|allow|check|cleanup-plan` provides the Git workflow policy command surface.
- `tools/test_git_workflow_policy.sh` covers Git workflow policy success and failure paths.
- `tools/git-hooks status|recommend|mode|cache|run` provides the Git hooks policy command surface.
- `tools/test_git_hooks.sh` covers standalone Git hooks policy/cache/recommendation success and failure paths.
- `tools/git-hooks run --mode full --no-cache` and `.githooks/pre-commit` cover full/no-cache and real pre-commit dispatch verification.
- Dashboard readiness output shows menu items 1 through 7 and menu-wide Git workflow policy status.
- As-built document checks.
- Sub-agent review protocol.
- Lesson repository aggregate test.
- Real product operations test for explicit product-repository runs.
- Quality constraints: refactorability, ecosystem fit, reusability, generality, and no existing-feature tradeoffs.

## Implemented Remediation Plan

The 2026-06-02 developer-memory audit has been implemented additively.
The synchronized implemented state covers these items:

1. Shared document-path support.
2. Safe role-based Markdown document migration.
3. Learner-facing `Day N` to `Step N` wording.
4. Internal step ID hiding in ordinary learner-facing output.
5. Separate workflow display language and product development language settings for both structured lessons.
6. Learning-mode display labels for A/B/C.
7. Stronger start/pass approval gate pairing.
8. Question-inviting passage prompts and command-block explanations.
9. Paired `docs/workflow/TASK_TRACKER.md` and `docs/workflow/HANDOFF.md` synchronization checks.
10. Stronger as-built synchronization checks.
11. Expanded CLI dashboard views, including separate 7-day and 14-day language settings.
12. Completed illustration metadata, asset registration, and review page.
13. External-integration CLI path with `status`, `start`, and `gate`.
14. Required lesson-repository Playwright checks after dependencies are installed.
15. CI and pre-commit integration for strengthened checks, product-gate tests, Playwright checks, and aggregate tests.
16. Free Development and Team Development failure-path tests.

## Important Files

```text
docs/as-built/REQUIREMENTS.md
docs/as-built/SPECIFICATION.md
docs/as-built/IMPLEMENTATION_PLAN.md
docs/workflow/TASK_TRACKER.md
docs/workflow/HANDOFF.md
docs/memory/DEVELOPER_MEMORY.md
free-development/FREE_DEVELOPMENT_MODE.md
advanced/TEAM_DEVELOPMENT_DOCKER.md
advanced/DOCKER_PATHS.md
reviews/SUBAGENT_REVIEW_PROTOCOL.md
docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv
tools/check_as_built_docs.sh
tools/check_as_built_sync_contract.sh
tools/check_developer_memory_requirements.sh
tools/check_review_protocol.sh
tools/menu
tools/dashboard
tools/illustrations
tools/test_lesson.sh
tools/test_lesson_repository.sh
tools/test_product_gate_tools.sh
tools/test_product_repository_cleanup.sh
tools/test_as_built_sync_contract.sh
tools/git-workflow
tools/test_git_workflow_policy.sh
tools/git-hooks
tools/test_git_hooks.sh
tools/test_production_operations.sh
learning/context/README.md
learning/context/AI_DRIVEN_DEVELOPMENT_FOUNDATION.md
learning/context/SECURITY_FOUNDATION.md
learning/context/LESSON_CONTEXT_MAP.tsv
```

## Next Step

The resource-budgeted parallel guard is implemented.
The resource guard safe cleanup follow-up is implemented.
The resource guard summary and local/CI parallelization improvement is planned as `resource_guard_summary_parallel_ci`.
The next implementation cycle should choose explicitly between `resource_guard_summary_parallel_ci` and the remaining learner context runtime integration work.
Do not perform `.wslconfig` writes, swap creation/deletion, privileged cleanup, arbitrary process killing, CI weakening, pre-commit weakening, or Git hooks mode semantic changes without developer approval.
If resource guard behavior is changed later, preserve policy/settings-driven implementation, user-configurable available-memory floor, active-heavy-process fallback, explicit parallel-mode safe-stop, unknown-profile rejection, safe-stop failure for checks and job recommendations, standalone and aggregate tests, CI/pre-commit wiring, Playwright wrapper wiring, and existing Git hooks mode semantics.
If cleanup behavior is changed later, preserve dry-run by default, explicit `--safe` deletion, repo-local path validation, symlink escape rejection, marked Git hooks cache validation, fixture-based tests, CI/pre-commit wiring, and the prohibition on OS cache, swap, Docker, process, product repository, and global cache cleanup without developer approval.
If `resource_guard_summary_parallel_ci` is implemented next, preserve existing `status`, `monitor`, `recommend-jobs`, `check`, `cleanup`, Git hooks mode semantics, pre-commit behavior, and CI check coverage.
Use resource guard recommendations for local Git hooks worker limits, but optimize GitHub Actions through CI-runner-oriented job splitting rather than applying local WSL memory settings to CI.
Treat unclassified Git hook checks as serial until they are explicitly classified as parallel-safe.
Keep per-check logs separated and replayed in deterministic definition order.
The implementation must add required CI workflow structure verification for job names, `needs`, and required command coverage.
The final CI `aggregate-and-full-hooks` job must install npm dependencies and Playwright dependencies before running aggregate repository tests or full hooks.
CI full-hooks execution must keep the CI-safe local-resource bypass behavior such as `RESOURCE_GUARD_SKIP_LOCAL_CHECK=1` or an equivalent documented mechanism, while local Playwright and Git hooks may use resource guard recommendations.
Before moving `resource_guard_summary_parallel_ci` to `implemented`, update the sync contract from planning-only artifacts and tests to actual runtime artifacts, runtime tests, and runtime evidence.
Developer approval is required before changing `GIT_HOOK_CHECKS.tsv` columns, changing the meaning of `full`, `fast`, or `minimal`, making Playwright or aggregate checks more aggressive than resource guard recommends, reducing CI coverage for speed, or adding a CI-specific settings file.

Implemented Git workflow policy scope:

- Added `docs/workflow/GIT_WORKFLOW_POLICY.tsv` for supported Git workflow policy definitions.
- Added `learning/GIT_WORKFLOW_SETTINGS.tsv` for current user-selected Git workflow settings.
- Added `tools/lib/git_workflow_policy.sh` for shared setting loading, validation, permission checks, automation-level helpers, repository-context detection, and Git monitoring.
- Added `tools/git-workflow status|configure|set|allow|check|cleanup-plan`.
- Let users allow or disallow normal working branches.
- Let users allow or disallow `git worktree`.
- Let users explicitly control whether direct work on `main` is allowed.
- Define automation levels:
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
- Preserve existing 7-day, 14-day, menu, dashboard, Free Development, Product Improvement, external-integration, product-repository cleanup, product-gate, Playwright, docs-tour, CI, pre-commit, and as-built sync-contract behavior.
- The as-built sync contract records below include `git_workflow_policy` as implemented work.

The synchronized as-built sync-contract implementation is now represented across the three design/as-built documents and two workflow-state documents.

Implemented as-built sync-contract scope:

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

As-built sync contract records:

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
STATUS: planned
ARTIFACTS: docs/memory/DEVELOPER_MEMORY.md, docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv
TESTS: tools/check_as_built_sync_contract.sh

SYNC-ID: learner_context_foundation
STATUS: planned
ARTIFACTS: learning/context/README.md,learning/context/AI_DRIVEN_DEVELOPMENT_FOUNDATION.md,learning/context/SECURITY_FOUNDATION.md,learning/context/LESSON_CONTEXT_MAP.tsv
TESTS: tools/test_lesson_repository.sh

SYNC-ID: learner_context_runtime_integration
STATUS: planned
ARTIFACTS: learning/context/README.md,learning/context/LESSON_CONTEXT_MAP.tsv
TESTS: tools/test_lesson_repository.sh
```

Planned learner context foundation scope:

- Added `learning/context/README.md` for context-document organization and synchronization boundaries.
- Added `learning/context/AI_DRIVEN_DEVELOPMENT_FOUNDATION.md` for the main learner-facing conceptual source text.
- Added `learning/context/SECURITY_FOUNDATION.md` for staged security learning.
- Added `learning/context/LESSON_CONTEXT_MAP.tsv` so future implementation can map context topics to lesson phases.
- Updated `guides/DOCUMENT_MAP.md` so learners and agents can find the context source documents.
- Synchronized the planned state through `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv` and the five synchronized documents.
- Runtime integration remains the next step and must not be assumed complete.

Planned learner context runtime integration scope:

- Sync ID: `learner_context_runtime_integration`.
- Status: `planned`.
- Keep 7-day lesson, 14-day lesson, and applied modules as learning contexts.
- Keep Free Development Mode, Product Improvement, External Integration, and lesson repository maintenance as workflow contexts.
- Planned future files include `learning/context/WORKFLOW_CONTEXT_MAP.tsv`, `tools/lib/lesson_context.sh`, `tools/lesson-context`, and `tools/test_lesson_context.sh`.
- Planned future integration points include `tools/lesson`, `tools/lesson14`, `tools/team-development`, `tools/free-development`, `tools/product-improvement`, `tools/external-integration`, `tools/menu`, and `tools/dashboard`.
- Future implementation must preserve existing approval gates, ordered progression, learner-selected start positions, menu prerequisites, Git workflow settings, Git hooks settings, dashboard views, CI, pre-commit, and repository-boundary behavior.
- Future implementation must add standalone and aggregate test coverage before moving the sync ID to `implemented`.

The previously synchronized menu-wide implementation is `menu_git_workflow_policy`.
It promotes the existing Git workflow policy into a shared menu-level policy without weakening any existing lesson, menu, dashboard, cleanup, CI, pre-commit, or as-built synchronization behavior.

Implemented menu-wide Git workflow policy scope:

- Keep `tools/git-workflow status|configure|set|allow|check|cleanup-plan` as the existing policy source.
- Make `tools/menu readiness` show Git policy readiness for menu items 1 through 7.
- Added Git policy validation to `tools/menu check <1|2|3|4|5|6>` without weakening existing learning-mode, language, product-language, repository-boundary, or approval checks.
- Added `tools/menu check 7` and `tools/menu start 7 --confirm` for lesson-repository maintenance.
- Keep `automation_level=manual` valid and non-blocking.
- Interpret automation levels consistently across learning, building/extending, and maintenance menu categories.
  - `manual`: guidance and monitoring only.
  - `commit`: commit-level automation only after required checks pass.
  - `pr_ci`: push, PR, and CI-check automation where applicable.
  - `sync`: main synchronization plus local/remote sync checks where applicable.
- Keep merge, branch deletion, worktree deletion, remote deletion, and product repository cleanup behind explicit confirmation regardless of automation level.
- Show menu-wide Git policy status in dashboard output.
- Added runtime tests in `tools/test_menu_prerequisites.sh` and updated these five synchronized documents from planned to implemented.

Implemented Git workflow action settings scope:

- Keep `branch_allowed`, `worktree_allowed`, `main_direct_work_allowed`, and `automation_level`.
- Treat `automation_level` as a compatibility preset.
- Detailed settings take precedence only when the detailed setting key is present.
- Fall back to `automation_level` when a detailed setting key is absent so current implemented behavior is preserved.
- Add detailed settings for:
  - `commit_automation: manual|auto`
  - `push_automation: manual|auto`
  - `pr_creation: manual|auto`
  - `pr_ci_monitoring: manual|auto`
  - `merge_execution: manual|after_approval`
  - `developer_auto_merge_allowed: false|true`
  - `main_ci_monitoring: manual|auto`
  - `sync_monitoring: manual|auto`
- Use safety-oriented defaults:
  - `commit_automation: auto`
  - `push_automation: manual`
  - `pr_creation: manual`
  - `pr_ci_monitoring: auto`
  - `merge_execution: after_approval`
  - `developer_auto_merge_allowed: false`
  - `main_ci_monitoring: auto`
  - `sync_monitoring: auto`
- These detailed defaults are active after implementation; `automation_level` remains available as a compatibility preset when detailed action keys are absent.
- Add a shared `git_workflow_action_mode <action>` resolver for `commit`, `push`, `pr`, `ci`, `pr_ci`, `merge`, `main_ci`, and `sync`.
- Keep `ci` as a compatibility alias for CI monitoring so existing `tools/git-workflow allow ci` behavior is preserved.
- Keep `tools/git-workflow status|configure|set` as the user-facing setting surface.
- Show detailed action settings in `tools/menu readiness` and `tools/dashboard menu`.
- Apply the same detailed settings to menu items 1 through 7.
- For push and PR creation, `auto` means the agent may execute the operation only after explicit approval for that operation is recorded; it never means approval-free execution.
- `merge_execution: after_approval` means the agent may execute merge only after explicit merge approval is recorded.
- `learning/GIT_WORKFLOW_APPROVALS.tsv` stores matching action, repository, and branch approval receipts for detailed push, PR creation, and normal merge execution.
- `developer_auto_merge_allowed: true` is the only implemented path for developer-responsibility approval-free merge and requires PR CI success, clear target PR and branch, verified merge base, clean working tree, checked local/remote state, and stop-on-failure behavior.
- Developer-responsibility auto-merge requires gate evidence plus actual repository checks; the setting alone does not permit approval-free merge.
- Keep branch deletion, worktree deletion, remote deletion, and product repository deletion behind explicit user confirmation regardless of merge settings.
- Moved `git_workflow_action_settings` from `planned` to `implemented` across the sync contract and all five synchronized documents.

Implemented Git hooks policy handoff:

- Sync ID: `git_hooks_policy`.
- Current status: `implemented`.
- Current scope: faster safe serial pre-commit execution.
- Safety baseline: preserve the current `.githooks/pre-commit` behavior and existing CI/check coverage.
- Implemented modes:
  - `full`: current-equivalent required pre-commit coverage.
  - `fast`: cache-assisted execution only when prior successful inputs still match.
  - `minimal`: quick local mechanical checks, not final completion coverage.
- Local `minimal` remains valid for ordinary quick feedback; local `full --no-cache` is recommended when changed paths match Git hooks, CI, check, test, or as-built synchronization policy.
- Normal learner-facing `off` mode is out of scope.
- Cache location is Git-local and untracked, such as `.git/pre-commit-cache/`.
- Cache must fail closed: missing, stale, corrupted, or unverifiable entries force a run.
- Hook check configuration must fail closed when rows are malformed or contain invalid or empty mode tokens.
- The command surface includes hook status, local verification recommendation, mode selection, cache clearing, normal run, no-cache run, and explicit mode run.
- Implemented targets include `.githooks/pre-commit`, `tools/git-hooks`, `tools/lib/git_hooks_policy.sh`, `docs/workflow/GIT_HOOKS_POLICY.tsv`, `docs/workflow/GIT_HOOK_CHECKS.tsv`, `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv`, `learning/GIT_HOOK_SETTINGS.tsv`, and `tools/test_git_hooks.sh`.
- Existing wiring checks and status output now recognize runner-based pre-commit dispatch while preserving direct-command detection.
- Required next action after this sync: run the as-built sync checks, related tests, aggregate test, `tools/git-hooks run --mode full --no-cache`, and pre-commit. If they pass, the change is ready for developer review or commit.
- Developer approval is required before changing the minimal-mode required check list or skipping Playwright-related checks through cache beyond the implemented fail-closed behavior.
- Recovery path: clear the cache and rerun no-cache on suspected cache issues; restore the current serial pre-commit command list if runner integration fails.

The synchronized product repository cleanup implementation remains represented across the same documents.

Implemented product repository cleanup scope:

- Added `tools/product-repository-cleanup` so learners and agents can safely remove the external product repository created by the 7-day or 14-day lessons.
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

The synchronized menu prerequisite implementation remains represented across the same documents.

Implemented scope:

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

Current implemented docs-map scope:

- Added `guides/DOCUMENT_MAP.md` so learners can understand the repository's document system before document-heavy work.
- Explain `AGENTS.MD` invariant rules, document root, routing table, and repo-local skills in non-engineer-friendly terms.
- Distinguish lesson-side `AGENTS.MD` from product-side `AGENT.md`.
- Explain `docs/as-built/`, `docs/workflow/`, and `docs/memory/` by role.
- Explain `docs/workflow/GIT_HOOKS_POLICY.tsv`, `docs/workflow/GIT_HOOK_CHECKS.tsv`, and `learning/GIT_HOOK_SETTINGS.tsv` as Git hook policy and current local hook-mode controls.
- Explain `docs/memory/DEVELOPER_MEMORY.md` and product-side `FAILURE_MEMORY.md` or failure-recovery records without claiming a lesson-side failure-memory file exists.
- Added `tools/docs-tour status|rules|design|workflow|memory|skills|all` with learning-mode-aware A/B/C explanation depth.
- Added `./tools/dashboard docs` and included it in `./tools/dashboard all`.
- Added copy-paste prompt examples for asking an agent to explain `TASK_TRACKER`/`HANDOFF` and the as-built trio in learner-friendly language.
- Added early 7-day and 14-day guidance about why the documents exist.
- Added `tools/test_docs_tour.sh` and wired it into the relevant structure, as-built, developer-memory, aggregate, CI, and pre-commit checks.
- Preserve existing lesson progression, approvals, checks, menu behavior, dashboard behavior, skills, memory workflow, and repository-boundary behavior.
- `guides/DOCUMENT_MAP.md`, `tools/docs-tour`, `tools/test_docs_tour.sh`, and `./tools/dashboard docs` are runtime artifacts.
- Validation is wired through `tools/test_docs_tour.sh`, structure checks, as-built checks, developer-memory checks, dashboard or Playwright tests, aggregate tests, CI, and pre-commit.
- The validation suite must preserve existing 7-day, 14-day, menu, dashboard, Free Development, Product Improvement, external-integration, product-gate, Playwright, CI, and pre-commit behavior.

Implemented local verification passed the lesson-side verification sequence:

```bash
./tools/check_lesson_structure.sh
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/check_as_built_docs.sh
./tools/check_as_built_sync_contract.sh
./tools/check_review_protocol.sh
./tools/check_developer_memory_requirements.sh
./tools/menu
./tools/dashboard all
./tools/as-built-sync status
./tools/illustrations list
./tools/test_as_built_sync_contract.sh
./tools/test_git_workflow_policy.sh
./tools/test_git_hooks.sh
./tools/git-hooks run --mode full --no-cache
./tools/test_menu_prerequisites.sh
./tools/test_lesson_start_position.sh
./tools/test_lesson.sh
./tools/test_lesson14.sh
./tools/test_product_gate_tools.sh
./tools/test_product_repository_cleanup.sh
./tools/test_lesson_repository.sh
.githooks/pre-commit
```

The expected terminal evidence is:

```text
7-day lesson CLI tests passed.
Lesson14 CLI tests passed.
Lesson repository test passed.
Git hooks policy tests passed.
Git hooks checks passed: full mode
```

Run `tools/test_production_operations.sh` only when a product repository is intentionally present.
