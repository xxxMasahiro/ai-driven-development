# HANDOFF.md

## Current State

The lesson repository is in an implemented as-built sync-contract state with implemented Git workflow policy settings and implemented menu-wide Git workflow policy controls.
The current validation scope is lesson-side only; it must not recreate or depend on `task-tracker-repository`.
Existing 7-day lessons, 14-step lessons, free-development flow, advanced modules, checks, and repository-boundary behavior must not be weakened or replaced.
The implementation adds `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv`, `tools/check_as_built_sync_contract.sh`, `tools/as-built-sync`, `tools/test_as_built_sync_contract.sh`, `docs/workflow/GIT_WORKFLOW_POLICY.tsv`, `learning/GIT_WORKFLOW_SETTINGS.tsv`, `tools/lib/git_workflow_policy.sh`, `tools/git-workflow`, and `tools/test_git_workflow_policy.sh`; it also extends `tools/menu`, `tools/dashboard`, and `tools/test_menu_prerequisites.sh` for menu-wide Git policy controls while preserving product repository cleanup, shared menu prerequisite control for menu items 1 through 6, refactorability, ecosystem fit, reusable design, generality, and the no-existing-feature-tradeoff rule.
The implemented Git workflow policy now applies at menu level for items 1 through 7 and preserves all existing Git sync, CI, menu, dashboard, cleanup, lesson, and as-built synchronization behavior.
The current implemented Git workflow action settings separate Git workflow actions into detailed controls for commit, push, PR creation, PR CI monitoring, merge execution, developer-responsibility auto-merge, main CI monitoring, and local/remote sync monitoring while preserving existing broad Git settings and menu-wide Git policy behavior.
The current implemented Git hooks policy provides faster safe serial pre-commit behavior with `full`, `fast`, and `minimal` modes, conservative Git-local caching, and a path-based recommendation for when local full/no-cache should be run before push.
The current implemented local verification scope policy requires everyday test execution to follow workflow contracts, changed scope, and user approval; heavy recommended checks must be presented before execution unless an immediate safety condition requires stopping.
The current implemented resource-budgeted parallel guard captures the developer-approved implementation proposal for safe optional parallel execution based on user-configured memory and swap budgets; runtime policy, settings, CLI, Git hooks integration, Playwright worker recommendation, CI wiring, and tests are present.
The current planned learner context foundation adds source documents under `learning/context/` for the next lesson-content implementation cycle; it does not yet change runtime lesson output.
The current planned learner context runtime integration separates learning context from workflow context; Free Development Mode must remain a workflow and must not be implemented as a lesson.
The current implemented Security guard backfill adds repository-level security invariants, `docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv`, `tools/check_security_invariants.sh`, and `tools/test_security_invariants.sh`.
The current implemented product security workflow gate adds `docs/workflow/PRODUCT_SECURITY_POLICY.tsv`, `learning/context/WORKFLOW_CONTEXT_MAP.tsv`, `tools/product-security`, `tools/test_product_security.sh`, and gate wiring for menu items 4, 5, and 6.
The current implemented test and CI safe time optimization first phase is documented as `test_ci_safe_time_optimization_plan`; it provides observe-only planning, fail-closed coverage validation, result attestation, CI-safe Git hooks parallelism, and lightweight fixture copying while preserving full/no-cache verification.
The current implemented CI timing and approved auto-improvement cycle is documented as `ci_timing_auto_improvement_plan`; it records measured final common aggregate/full-hooks timing, provides precise CI status targeting, and generates proposal-only CI improvement candidates while keeping future full/no-cache policy refinement developer-approved.
The current implemented CI aggregate and full-hooks split is documented as `ci_aggregate_full_hooks_split`; it runs main `CI` lesson aggregate and full/no-cache Git hook verification as separate jobs with a strict final gate while preserving cache policy and full/no-cache semantics.
The current implemented dashboard control center data layer is documented as `dashboard_control_center_data_layer`; it provides a read-only JSON source behind an AI-driven development control center while preserving the existing CLI dashboard.
The current implemented dashboard control center React UI is documented as `dashboard_control_center_react_ui_plan`; it provides a read-only browser control-center scope with maintained entry tooling, standalone/aggregate browser checks, and no UI action execution.
The current implemented dashboard control center information architecture is documented as `dashboard_control_center_information_architecture`; it provides category navigation, Overview-first presentation, the original `en`/`ja` fixed-label localization layer, snapshot freshness display, and Safety Actions command-preview isolation while preserving read-only behavior. Full standard Dashboard UI locale support is implemented separately as `dashboard_control_center_full_locale_ui_support`.
The current implemented dashboard control center visual polish is documented as `dashboard_control_center_visual_polish`; that layer brings the categorized read-only UI closer to `dashboard-control-center/mocks/archive/mock-categorized-dashboard.png` without itself adding automatic refresh, live CI/Git authority, or UI command execution.
The current implemented dashboard control center mock parity is documented as `dashboard_control_center_mock_parity`; it brings the Overview structure closer to `mock-categorized-dashboard.png` with producer-owned metrics, compact issue preview expansion, central percentage rings, and Explore Pages metrics without fixed mock values.
The latest implemented dashboard control center live snapshot sync is documented as `dashboard_control_center_live_snapshot_sync`; it adds atomic schema-validated snapshot publication plus read-only browser polling and last-known-good behavior without browser command execution or live CI/Git authority.
The current implemented dashboard control center mock-aligned Overview is documented as `dashboard_control_center_mock_aligned_overview`; it keeps the Overview closer to the mock, makes empty Partial Failures explicit, separates manual follow-ups, avoids layout-changing Overview expansion, and preserves the read-only browser boundary.
The current implemented dashboard control center detail-page mock parity follow-up is documented as `dashboard_control_center_detail_mock_parity`; it uses the four approved detail mock images as UI/UX source references to make category pages explain what they check, what judgment they support, and what must be reviewed next while preserving the read-only browser boundary.
The current dashboard control center exact mock alignment correction is implemented as `dashboard_control_center_mock_exact_alignment_correction`; it records the corrective implementation pass that aligns the dashboard runtime with the approved mock family while preserving producer-owned state and read-only browser behavior.
The current implemented dashboard control center Settings safe change is documented as `dashboard_control_center_settings_safe_change_plan`; it now includes guarded Settings edits, Settings-driven Dashboard fixed UI locale resolution, and immediate post-apply snapshot refresh without a page reload.

## Key Implemented Capabilities

- 14-day approval enforcement.
- Learning mode A/B/C selection and switching for 7-day and 14-day lessons.
- Workflow display language and product development language selection for 7-day and 14-day lessons.
- Dashboard Control Center fixed UI labels follow the Settings workflow display language for every standard language, with immediate no-reload refresh after apply.
- Standard language choices: `ja`, `en`, `ko`, `zh-CN`, `zh-TW`, `es`, `pt-BR`, `fr`, `de`, `id`, `vi`, `th`, `hi`, and `ar`.
- Dashboard fixed-label dictionaries now exist for the full standard language set. Unsupported custom language values remain workflow data unless a later locale policy promotes them.
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
- `tools/check_security_invariants.sh` provides mechanical Security guard invariant validation.
- `tools/product-security status|preflight|advise|check|gate` provides the mechanical product-security command surface for menu items 4, 5, and 6.
- `tools/check_as_built_sync_contract.sh` provides the mechanical five-document synchronization contract check.
- `tools/as-built-sync status` provides the learner/agent-facing sync-contract status view.
- `tools/test_as_built_sync_contract.sh` covers sync-contract success and failure paths.
- `tools/git-workflow status|configure|set|allow|check|cleanup-plan` provides the Git workflow policy command surface.
- `tools/test_git_workflow_policy.sh` covers Git workflow policy success and failure paths.
- `tools/git-hooks status|recommend|mode|cache|run` provides the Git hooks policy command surface.
- `tools/test_git_hooks.sh` covers standalone Git hooks policy/cache/recommendation success and failure paths.
- `tools/git-hooks run --mode full --no-cache` and `.githooks/pre-commit` cover full/no-cache and real pre-commit dispatch verification.
- `local_verification_scope_policy` records that agents must not treat full/no-cache recommendations as automatic permission to run heavy verification without presenting the need.
- Dashboard readiness output shows menu items 1 through 7 and menu-wide Git workflow policy status.
- As-built document checks.
- Sub-agent review protocol.
- Lesson repository aggregate test.
- Real product operations test for explicit product-repository runs.
- Quality constraints: refactorability, ecosystem fit, reusability, generality, and no existing-feature tradeoffs.

## Implemented Local Verification Scope Policy Handoff

Implemented local verification scope policy sync:

- Sync ID: `local_verification_scope_policy`.
- Current status: `implemented`.
- Current scope: durable AGENTS invariant plus five-document synchronization for everyday test-execution scope.
- This rule is lower priority than the no-existing-feature-tradeoff invariant.
- Use `TEST_PLAN_MANIFEST.tsv` to identify required checks for changed paths.
- Use `GIT_HOOK_CHECKS.tsv` to map check IDs to commands.
- Use `GIT_HOOK_RECOMMENDATION_PATHS.tsv` as recommendation policy, not as approval to run heavy verification automatically.
- Use `learning/GIT_HOOK_SETTINGS.tsv` for the current local hook mode; `.githooks/pre-commit` delegates to `tools/git-hooks run`.
- For lightweight UI, wording, CSS, and layout changes, present only contract-relevant target verification unless the change touches schema, shared tools, command boundaries, CI, hooks, or sync contracts.
- For document synchronization, contract, schema, shared-tooling, Git hooks, CI, test-infrastructure, or broad implementation changes, follow the broader contract-required verification path.
- Do not record this rule in developer memory because that file is not the durable source for this preference.
- Required contract checks for this sync ID are `tools/check_test_plan_coverage.sh`, `tools/test_test_plan.sh`, `tools/test_git_hooks.sh`, `tools/check_as_built_sync_contract.sh`, and `tools/check_as_built_docs.sh`.

SYNC-ID: local_verification_scope_policy
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOKS_POLICY.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,learning/GIT_HOOK_SETTINGS.tsv,tools/lib/test_plan.sh,tools/test-plan,tools/lib/git_hooks_policy.sh,tools/git-hooks,tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_git_hooks.sh
TESTS: tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_git_hooks.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

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
tools/check_security_invariants.sh
tools/check_developer_memory_requirements.sh
tools/check_review_protocol.sh
tools/menu
tools/dashboard
tools/illustrations
tools/test_lesson.sh
tools/test_lesson_repository.sh
tools/test_product_gate_tools.sh
tools/test_product_repository_cleanup.sh
tools/test_product_security.sh
tools/test_as_built_sync_contract.sh
tools/test_security_invariants.sh
tools/git-workflow
tools/test_git_workflow_policy.sh
tools/git-hooks
tools/test_git_hooks.sh
tools/test_production_operations.sh
learning/context/README.md
learning/context/AI_DRIVEN_DEVELOPMENT_FOUNDATION.md
learning/context/SECURITY_FOUNDATION.md
learning/context/LESSON_CONTEXT_MAP.tsv
learning/context/WORKFLOW_CONTEXT_MAP.tsv
```

## Next Step

The resource-budgeted parallel guard is implemented.
The resource guard safe cleanup follow-up is implemented.
The resource guard summary and local/CI parallelization improvement is implemented as `resource_guard_summary_parallel_ci`.
The Security guard backfill is implemented as `safeflow_security_backfill`.
The product security workflow gate is implemented as `product_security_workflow_gate`.
The test and CI safe time optimization first phase is implemented as `test_ci_safe_time_optimization_plan`.
The latest implemented test/CI cycle is `test_ci_final_gate_optimization_plan`; local verification and remote synchronization passed for that cycle.
The latest implemented full-pipeline test/CI acceleration cycle is `test_ci_full_pipeline_acceleration_plan`.
The latest implemented CI timing and approved auto-improvement cycle is `ci_timing_auto_improvement_plan`.
The latest implemented CI split cycle is `ci_aggregate_full_hooks_split`; it is limited to main `CI` job scheduling and same-run evidence handoff.
The latest implemented dashboard/control-center cycle is `dashboard_control_center_context_mock_source_of_truth`, following `dashboard_control_center_selected_context_sync`, `dashboard_control_center_mock_aligned_overview`, and `dashboard_control_center_live_snapshot_sync`; together they provide producer-owned selected context data, data-backed mock direction, mock-source UI/UX alignment, seamless read-only snapshot refresh, stable summaries, and no UI action execution.
If future test/CI acceleration work is resumed, inspect Git state, confirm the sync contract is clean, preserve required workflow contexts, and implement only developer-approved candidates generated from `ci_timing_auto_improvement_plan` evidence.
If future dashboard control-center work is resumed, inspect Git state, confirm the sync contract is clean, keep existing `tools/dashboard` semantics, preserve `tools/dashboard-data` as read-only, and request developer approval before broad localization, live authoritative CI/Git/network status, browser-triggered checks, or any command execution.
Do not perform `.wslconfig` writes, swap creation/deletion, privileged cleanup, arbitrary process killing, CI weakening, pre-commit weakening, or Git hooks mode semantic changes without developer approval.
If resource guard behavior is changed later, preserve policy/settings-driven implementation, user-configurable available-memory floor, active-heavy-process fallback, explicit parallel-mode safe-stop, unknown-profile rejection, safe-stop failure for checks and job recommendations, standalone and aggregate tests, CI/pre-commit wiring, Playwright wrapper wiring, and existing Git hooks mode semantics.
If cleanup behavior is changed later, preserve dry-run by default, explicit `--safe` deletion, repo-local path validation, symlink escape rejection, marked Git hooks cache validation, fixture-based tests, CI/pre-commit wiring, and the prohibition on OS cache, swap, Docker, process, product repository, and global cache cleanup without developer approval.
If `resource_guard_summary_parallel_ci` is changed later, preserve existing `status`, `monitor`, `recommend-jobs`, `check`, `cleanup`, Git hooks mode semantics, pre-commit behavior, and CI check coverage.
Use resource guard recommendations for local Git hooks worker limits, but optimize GitHub Actions through CI-runner-oriented job splitting rather than applying local WSL memory settings to CI.
Treat unclassified Git hook checks as serial until they are explicitly classified as parallel-safe.
Keep per-check logs separated and replayed in deterministic definition order.
The implementation must add required CI workflow structure verification for job names, `needs`, and required command coverage.
The main CI split jobs that run aggregate repository tests or full hooks must install npm dependencies and Playwright dependencies before those checks run.
CI full-hooks execution must keep the CI-safe local-resource bypass behavior such as `RESOURCE_GUARD_SKIP_LOCAL_CHECK=1` or an equivalent documented mechanism, while local Playwright and Git hooks may use resource guard recommendations.
The `resource_guard_summary_parallel_ci` sync contract is implemented with actual runtime artifacts, runtime tests, and runtime evidence.
Developer approval is required before changing `GIT_HOOK_CHECKS.tsv` columns, changing the meaning of `full`, `fast`, or `minimal`, making Playwright or aggregate checks more aggressive than resource guard recommends, reducing CI coverage for speed, or adding a CI-specific settings file.
For future Security guard/product-security refinement, developer approval is required before expanding `AGENTS.MD` invariant wording, expanding blocking conditions that stop learner or workflow progress, adding network-dependent audits, changing external-integration approval prompts, or adding destructive cleanup behavior.
The `safeflow_security_backfill` and `product_security_workflow_gate` sync contracts are implemented with actual runtime artifacts, runtime tests, and runtime evidence.
For future `test_ci_safe_time_optimization_plan` refinement, keep changed-only selection observe-only until Coverage Guard and Result Attestation have enough full-CI evidence and developer approval. Do not reduce full/no-cache coverage, required CI checks, Playwright coverage, as-built sync enforcement, security checks, product-security checks, pre-commit behavior, or Git hooks mode semantics without developer approval.
For future `ci_timing_auto_improvement_plan` refinement, generated CI improvement candidates must remain read-only proposals until the developer approves implementation. Do not remove duplicate checks, reduce full/no-cache scope, or change workflow/job names without explicit developer approval.

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

Implemented Security guard backfill scope:

- Sync ID: `safeflow_security_backfill`.
- Status: `implemented`.
- Runtime artifacts include `AGENTS.MD`, `docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv`, `tools/lib/security_invariants.sh`, `tools/check_security_invariants.sh`, and `tools/test_security_invariants.sh`.
- The implementation adds mechanical security invariants without replacing existing learner context, 7-day lessons, 14-day lessons, CI, pre-commit, Git hooks, resource guard, as-built sync, or document-route behavior.
- The implementation does not mutate OS, WSL, Docker, cgroups, swap, or processes.

Implemented product security workflow gate scope:

- Sync ID: `product_security_workflow_gate`.
- Status: `implemented`.
- Runtime artifacts include `docs/workflow/PRODUCT_SECURITY_POLICY.tsv`, `learning/context/WORKFLOW_CONTEXT_MAP.tsv`, `tools/lib/product_security.sh`, `tools/product-security`, and `tools/test_product_security.sh`.
- The implementation supports menu items 4, 5, and 6 as workflow contexts, not lessons.
- The implementation adds a stack-agnostic product-security command surface that can advise, check, and gate work without scanning outside the configured product repository.
- The implementation distinguishes advisory warnings from high-confidence blocking conditions and avoids exposing secret values in output or test fixtures.
- The implementation preserves explicit approval for external API/OAuth/webhook/secrets work and does not weaken existing product-repository boundaries, Git workflow policy, or cleanup behavior.

Implemented test and CI safe time optimization first-phase scope:

- Sync ID: `test_ci_safe_time_optimization_plan`.
- Status: `implemented`.
- Purpose: reduce local and remote verification time by first adding the controls needed to remove duplicate work safely, then applying proven reductions without reducing safety or correctness.
- The first implementation adds Test Plan Manifest, learner-readable decision reasons, Coverage Guard, Result Attestation, CI-safe full-hooks parallelism, and lightweight fixture copying before any changed-only CI skipping or same-run evidence reuse is allowed.
- Keep `tools/test_lesson_repository.sh` as a standalone exhaustive command.
- Repeated as-built validation, duplicate Playwright execution, and duplicate final CI verification remain future optimization targets.
- A future full-hooks path may use a gap-only final gate only after a mechanical coverage check proves that individual hook rows plus the gap gate cover the standalone aggregate requirements.
- CI keeps full/no-cache verification authoritative while observe-only planning gathers evidence.
- CI may cache npm and Playwright dependencies, but not verification results.
- Developer approval is required before changed-only becomes authoritative in CI, required CI check names change, full/no-cache scope is reduced, flaky quarantine is introduced, or `full`, `fast`, and `minimal` semantics change.

Planned test and CI final gate optimization handoff:

- Sync ID: `test_ci_final_gate_optimization_plan`.
- Status: `implemented`; local verification passed, and remote `CI` / `Lesson14 CI` remain the external completion gates for the pushed commit.
- The implementation completes the test/CI optimization work by addressing the current `aggregate-and-full-hooks` bottleneck.
- The previous CI bottleneck was the final full/no-cache gate, especially duplicate `test_lesson_repository.sh`, duplicate Playwright execution, repeated as-built/sync checks, and duplicated common final verification between `CI` and `Lesson14 CI`.
- Same-run evidence is implemented before duplicate execution is removed.
- Keep `tools/test_lesson_repository.sh` available as the standalone exhaustive command.
- The full hook duplicate aggregate rerun is replaced only with a mechanically verified gap-only final gate.
- Playwright evidence is reused only when commit SHA, workflow run, source job identity, Playwright config hash, test file hashes, lockfile hash, command identity, repository-state hash, and success status match.
- `docs/workflow/FINAL_GATE_COVERAGE.tsv` maps aggregate requirements to hook evidence or explicit final-gap commands; missing coverage must fail closed.
- `Lesson14 CI` uses a Lesson14-specific final gate instead of duplicating the common aggregate/full-hooks final gate from `CI`.
- `Lesson14 CI` preserves the legacy `playwright-tests` and `aggregate-and-full-hooks` job contexts as lightweight compatibility gates; they must not rerun browser tests, `tools/test_lesson_repository.sh`, or `tools/git-hooks run --mode full --no-cache`.
- `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv` recommends local `full --no-cache` verification for final-gate coverage, final-gate command, CI evidence, and as-built evidence implementation changes.
- As-built/sync evidence is reused only when synchronized document hashes, sync-contract hash, checker hashes, command identity, repository-state hash, and success status match.
- npm and Playwright dependency caching are added, but verification results are not persistently cached across commits or workflow runs.
- Cleanup coverage includes same-run evidence, Playwright reports, test results, temporary fixtures, and repo-local caches.
- Preserve existing required workflow names unless developer approval is granted to change them.
- Stop for developer approval before accepting any existing-feature tradeoff, changing required CI names, reducing full/no-cache scope, making changed-only CI authoritative, introducing flaky quarantine, or reusing verification results across workflow runs.
- Required first implementation step: add focused tests for gap-only coverage and same-run evidence rejection before changing CI execution flow.

Implemented test and CI full pipeline acceleration handoff:

- Sync ID: `test_ci_full_pipeline_acceleration_plan`.
- Status: `implemented`.
- Purpose: complete the remaining local and remote test/CI acceleration work without reducing required coverage, safety, or compatibility.
- GitHub Actions deprecation regression guards are implemented in CI workflow structure checks.
- Playwright setup uses `tools/ci-playwright-setup` for cache-aware dependency and Chromium setup with normal fallback installs.
- Safe full-hook parallel expansion is policy-driven through `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv`.
- Duplicated policy-regression work between `CI` and `Lesson14 CI` is reduced while preserving required compatibility contexts.
- `tools/test_ci_pipeline_acceleration.sh` verifies the acceleration contract as a standalone and aggregate-callable check.
- `tools/check_as_built_sync_contract.sh` recognizes the Lesson14 compatibility split only when main `CI` keeps active coverage for the relevant test.
- `tools/check_as_built_sync_contract.sh` uses process-local wiring lookup caching only; do not convert that into persistent verification-result cache without developer approval.
- Keep changed-only CI observe-only until Coverage Guard, Result Attestation, full-CI comparison evidence, and developer approval allow any authoritative behavior.
- Preserve existing Step 1-7, Step 1-14, applied lesson, menu, dashboard, Git workflow, Git hooks, Security guard checks, product-security, docs-tour, as-built sync, pre-commit, local full/no-cache, and remote CI behavior.
- Do not add future tool names to the sync contract until those files exist and are testable.
- Stop for developer approval before changing required CI workflow or job names, reducing full/no-cache scope, caching verification results across runs, introducing flaky quarantine, making changed-only CI authoritative, or accepting any existing-feature tradeoff.
- Recovery: if cache, parallelization, evidence reuse, or job splitting weakens determinism or coverage, revert that specific optimization path and keep the strict existing check.

CI timing and approved auto-improvement handoff:

- Sync ID: `ci_timing_auto_improvement_plan`.
- Status: `implemented`.
- Purpose: make further final common aggregate/full-hooks shortening evidence-driven by recording per-check timing, generating read-only improvement proposals, and requiring developer approval before implementing generated candidates.
- Runtime behavior now includes `tools/ci-timing`, `tools/lib/ci_timing.sh`, `tools/test_ci_timing.sh`, strict `check_ci_status.sh` workflow/job matching, and main `CI` timing artifacts for final common aggregate/full-hooks checks.
- The main `CI` workflow records timing for `Lesson aggregate test` and `Git hooks full no-cache regression`, then uploads `ci-timing-${{ github.run_id }}-${{ github.run_attempt }}`.
- `tools/ci-timing propose` is read-only and reports slow checks, same-run evidence candidates, and parallelization candidates with developer-approval requirements.
- `tools/check_ci_status.sh --required` requires both `CI` and `Lesson14 CI` when run from this lesson repository without an explicit workflow; product or custom repositories keep the narrower single-workflow behavior.
- Same-run hash evidence reuse may be implemented only when command identity, input hashes, policy hashes, repository-state hash, workflow/run identity, and success status match.
- Full hook parallel-group refinement should happen only after timing evidence identifies remaining bottlenecks and the grouping stays policy-driven.
- Conditional `full no-cache` scope reduction remains a later developer-approved operation.
- Preserve existing Step 1-7, Step 1-14, applied lesson, menu, dashboard, Git workflow, Git hooks, Security guard checks, product-security checks, docs-tour, as-built sync, pre-commit, local full/no-cache, and remote CI behavior.
- Do not implement generated CI improvement candidates without developer approval.
- Recovery: if timing, proposal generation, evidence reuse, or status targeting weakens determinism or coverage, restore strict existing checks and keep the candidate proposal-only.

SYNC-ID: ci_timing_auto_improvement_plan
STATUS: implemented
ARTIFACTS: docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/check_ci_status.sh,tools/check_ci_workflow_structure.sh,tools/lib/ci_timing.sh,tools/ci-timing,tools/test_ci_timing.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_evidence.sh,tools/test_ci_final_gate.sh,tools/test_git_hooks_parallel.sh,tools/test_lesson_repository.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_ci_workflow_structure.sh,tools/test_ci_timing.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_evidence.sh,tools/test_ci_final_gate.sh,tools/test_git_hooks_parallel.sh,tools/check_as_built_sync_contract.sh

CI aggregate and full-hooks split handoff:

- Sync ID: `ci_aggregate_full_hooks_split`.
- Status: `implemented`; local verification, sub-agent review, commit, push, required remote `CI` and `Lesson14 CI`, and local/remote sync passed.
- Purpose: shorten the main `CI` wall time by running lesson aggregate verification and full/no-cache Git hook verification as separate jobs, then requiring a strict final gate.
- Scope: main `CI` final common verification only. `Lesson14 CI` compatibility contexts remain unchanged.
- The implementation intentionally does not add persistent verification-result cache, conditional full/no-cache skipping, changed-only authoritative CI, Git hook group matrix splitting, or flaky quarantine.
- `lesson-aggregate` runs `tools/test_lesson_repository.sh --use-evidence --write-evidence` after the same prerequisite gates and same-run Playwright evidence download.
- `git-hooks-full-no-cache` runs `tools/git-hooks run --mode full --no-cache --jobs 4` after the same prerequisite gates and uploads same-run Git hook evidence.
- `final-gate` depends on both split jobs, starts with `if: ${{ always() }}`, validates split prerequisite results, requires the same-run Git hook evidence artifact from `git-hooks-full-no-cache`, runs `tools/ci-final-gate`, merges non-colliding timing-part report files, and uploads the final timing report artifact.
- `tools/ci-timing` keeps `CI_TIMING_REPORT` scoped to the wrapper report path and unsets it for wrapped commands so nested timing checks do not overwrite parent job reports.
- `tools/lib/ci_evidence.sh` keeps same-run evidence filenames safe for GitHub artifact upload while preserving original evidence ids in metadata.
- `Lesson14 CI` uses `CI_COMMON_COVERAGE_SOURCE: ci-split-common-coverage` as the stable compatibility marker for common split coverage.
- `tools/check_ci_workflow_structure.sh` and `tools/test_ci_pipeline_acceleration.sh` are the focused guards for the split and must remain standalone-callable and aggregate-callable.
- Preserve existing Step 1-7, Step 1-14, applied lesson, menu, dashboard, Git workflow, Git hooks, Security guard, product-security, docs-tour, as-built sync, pre-commit, local full/no-cache, and remote CI behavior.
- Recovery: if evidence handoff, timing merge, required contexts, or coverage fails, restore strict combined behavior or fail closed before reporting PASS.
- Developer approval is required before changing required workflow contexts beyond this approved split, reducing full/no-cache coverage, adding persistent cache semantics, making changed-only CI authoritative, splitting full hooks into a group matrix, or accepting any existing-feature tradeoff.

SYNC-ID: ci_aggregate_full_hooks_split
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,tools/check_ci_workflow_structure.sh,tools/test_ci_pipeline_acceleration.sh,tools/check_as_built_sync_contract.sh,tools/ci-timing,tools/test_ci_timing.sh,tools/lib/ci_evidence.sh,tools/test_ci_evidence.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_ci_workflow_structure.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_timing.sh,tools/test_ci_evidence.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

Dashboard control center data layer handoff:

- Sync ID: `dashboard_control_center_data_layer`.
- Status: `implemented`.
- Purpose: provide a stable, read-only JSON data layer for a future AI-driven development control center before adding React/Vite or any browser UI.
- Current artifacts: `tools/lib/dashboard_data.sh`, `tools/dashboard-data`, and `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv` provide the runtime JSON producer, reusable helpers, and implemented field contract.
- Current schema guard: `tools/test_dashboard_schema.sh` checks status separation, required schema paths, concise guidance fields, partial-failure fields, command-preview fields, and non-executable preview boundaries.
- Current data guard: `tools/test_dashboard_data.sh` checks JSON syntax, schema version, source files, concise guidance items, completed-lesson representation, allowed status vocabulary, partial failures, policy/gate separation, command-preview safety, and secret-like data redaction.
- Existing `tools/dashboard` remains the human-readable CLI dashboard and must not be parsed by a browser as the data contract.
- Future React/Vite mechanics must stay behind the dashboard control-center surface; ordinary users should not need to see Vite commands, dev-server URLs, package scripts, or frontend internals.
- Future non-engineer UX should require one ordinary user action only: open the dashboard/control center through the provided entry point while maintained tooling handles setup, Vite startup, URL selection, JSON loading, and checks.
- Future UI work should preserve a dual-audience control panel: lesson content/progress/management must be clear for non-engineers, and workflow content/progress/management, gates, evidence, blockers, approvals, and next operational actions must remain precise enough for intermediate and senior engineers.
- Future UI work must preserve the repository's two first-class surfaces, lessons and workflows, as distinct but coordinated control-panel areas that are easy to scan, understand, and operate.
- Keep the JSON producer read-only and source-of-truth preserving: use existing CLI, TSV, Markdown, policy files, and shared helpers instead of duplicating Security guard, Git workflow, Resource guard, CI, or lesson logic in React.
- Separate policy readiness, settings readiness, gate passage, approvals, optional evidence, cached evidence, and unknown state.
- The first UI phase must be read-first, explain-first, and approve-before-action; do not execute push, PR creation, merge, cleanup, deletion, external integration, OAuth/API, or other dangerous operations.
- Focused tests are standalone-callable and aggregate-callable and must not depend on a specific product stack, current prose wording, network availability, or live GitHub state.
- Recovery: if dashboard-data work later weakens existing dashboard, lesson, Security guard, Git workflow, CI, pre-commit, or as-built behavior, restore strict existing behavior and keep the dashboard-data work behind the implemented contract.
- Developer approval is required before choosing `tools/dashboard --format json`, adding React/Vite dependencies, exposing any Vite-specific user workflow, adding command execution buttons, making live network status authoritative, or changing existing dashboard semantics. If an existing-feature tradeoff appears necessary, stop and redesign; accepting the tradeoff is not allowed.

SYNC-ID: dashboard_control_center_data_layer
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,tools/check_ci_workflow_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

Dashboard control center React UI plan handoff:

- Sync ID: `dashboard_control_center_react_ui_plan`.
- Status: `implemented`.
- Purpose: provide a read-only React/Vite browser control center that consumes the implemented dashboard JSON data layer without changing existing CLI dashboard behavior.
- Current boundary: this implementation adds approved dependencies, package scripts, browser runtime files, maintained entry tooling, and browser test wiring; it does not add UI action execution or make frontend-only state authoritative.
- User path: ordinary users should have one dashboard/control-center entry action; maintained tooling handles Vite startup, URL selection, JSON loading, and check orchestration.
- UI model: keep lessons and workflows distinct. Lessons show plain-language content, progress, structured points, warnings, and next learning action from dashboard JSON. Workflows show practical gate, evidence, blocker, approval, Git/CI sync, and next operational action detail for engineers.
- Data source: consume `tools/dashboard-data` output and `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv`; do not parse `tools/dashboard` prose.
- Contract gap handling: lesson points, warnings, and next learning actions are now structured dashboard JSON fields; do not synthesize future fields from CLI prose.
- Safety: keep command previews read-only, treat untrusted text as data, avoid secrets/raw logs/external payloads, and do not make frontend-only state authoritative for safety decisions.
- Required future approval: action execution, live authoritative network status, and any `tools/dashboard` semantic change require developer approval.
- Recovery: if future UI work weakens existing lessons, workflows, Security guard, Resource guard, Git workflow, CI, pre-commit, as-built sync, docs, or dashboard data boundaries, restore existing behavior and redesign. Existing-feature tradeoffs are not allowed.

SYNC-ID: dashboard_control_center_react_ui_plan
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/dashboard-data,package.json,package-lock.json,vite.config.mjs,dashboard-control-center/index.html,dashboard-control-center/src/main.jsx,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/styles.css,tools/dashboard,tools/dashboard-control-center,tools/test_dashboard_control_center.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_lesson_playwright.sh,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,tools/check_ci_workflow_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_lesson_playwright.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_ci_workflow_structure.sh

Dashboard control center information architecture handoff:

- Sync ID: `dashboard_control_center_information_architecture`.
- Status: `implemented`.
- Purpose: make the browser dashboard easier to scan by splitting the read-only control center into Overview, Lessons, Development Workflow, Maintenance Sync, and Safety Actions.
- Design reference: `dashboard-control-center/mocks/archive/mock-categorized-dashboard.png` is a mock reference for information architecture, not a pixel-perfect runtime requirement.
- Current UI: Overview is the default; it shows snapshot mode, generated time, relative age, read-only state, blocker count, next safe action, guidance, partial failures, warnings, and category-health cards.
- Category boundary: Lessons, Development Workflow, Maintenance Sync, and Safety Actions are separate views so lesson state, workflow state, maintenance sync, and safety/action-preview content are not mixed.
- Localization boundary: fixed UI labels support `en` and `ja` from the device language with English fallback; commands, file paths, gate IDs, source names, and dashboard JSON prose are not browser-translated.
- Freshness boundary: generated time and relative age are display context only; they do not make stale/live status authoritative.
- Safety boundary: command previews remain preview-only and non-executable; no command-execution buttons were added.
- Tests: `tools/test_dashboard_control_center.sh` now covers category navigation, Overview-first behavior, Safety Actions isolation, absence of command-execution controls, secret-like redaction, mobile layout, and `en`/`ja` fixed-label localization.
- Deferred phases: UI-triggered command execution, live authoritative CI/Git status, data-schema localization fields, and broad language coverage require separate specification, synchronization, approval, and tests. Read-only live snapshot refresh is implemented later as `dashboard_control_center_live_snapshot_sync`.
- Recovery: if future dashboard work hides safety details, translates operational data text, weakens `tools/dashboard-data`, or changes existing CLI/lesson/check behavior, restore the implemented read-only category boundary and redesign. Existing-feature tradeoffs are not allowed.

SYNC-ID: dashboard_control_center_information_architecture
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,vite.config.mjs,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

Dashboard control center visual polish handoff:

- Sync ID: `dashboard_control_center_visual_polish`.
- Status: `implemented`.
- Purpose: make the categorized read-only dashboard visually closer to `dashboard-control-center/mocks/archive/mock-categorized-dashboard.png` while preserving the implemented data and safety boundaries.
- Design reference: the mock guides layout density, hierarchy, segmented status, sidebar context, compact health cards, and category shortcuts; it remains a visual reference, not a pixel-perfect runtime contract.
- Current UI: Overview keeps the snapshot context prominent, uses a segmented operational status strip, lays category-health cards out as a compact desktop grid, provides Explore Pages shortcuts, and shows read-only/last-updated context in the sidebar.
- Localization boundary: fixed UI labels remain `en`/`ja` with English fallback; commands, file paths, source names, status text from dashboard JSON, and other operational data remain data text.
- Safety boundary: visual shortcuts are navigation links only. They must not become command-execution controls without a separate specification, synchronization, approval, and tests.
- Tests: `tools/test_dashboard_control_center.sh` covers the visual structure through Playwright without relying on pixel-perfect screenshot matching.
- Follow-up boundary: automatic read-only snapshot refresh is implemented later as `dashboard_control_center_live_snapshot_sync`; UI-triggered checks, live authoritative CI/Git integration, command execution, new dependencies, and broad localization remain separate future phases.
- Recovery: if future dashboard visual work weakens the CLI dashboard, `tools/dashboard-data`, category isolation, Safety Actions preview-only behavior, mobile layout, existing lessons, checks, CI, or pre-commit, restore the implemented boundary and redesign. Existing-feature tradeoffs are not allowed.

SYNC-ID: dashboard_control_center_visual_polish
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

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

## Implemented Dashboard Control Center Mock Parity Handoff

Sync ID: `dashboard_control_center_mock_parity`.
Current status: `implemented`.

Current restart context:

- The existing React/Vite control center is implemented and read-only.
- `dashboard-control-center/mocks/archive/mock-categorized-dashboard.png` is the current visual reference.
- The real UI now has data-backed parity for compact Next Safe Action, Partial Failures preview, central percentage rings, and Explore Pages metrics.
- Do not regress by hard-coding mock values such as fixed percentages, fixed item counts, or fixture-specific text into the browser.
- Metrics must stay producer/schema-owned before display.
- Keep optional/unverified live checks separate from true failures by using manual follow-ups rather than `partial_failures`.
- Use normal and alternate valid fixtures so hard-coded percentages or counts fail in tests.
- Keep full issue details reachable through category pages as read-only navigation, not command-execution actions.
- Keep command previews isolated under Safety Actions and non-executable.

Implemented verification entry points:

1. `tools/test_dashboard_schema.sh`.
2. `tools/test_dashboard_data.sh`.
3. `tools/test_dashboard_control_center.sh`.
4. `tools/test_lesson_repository.sh`.

Sync-contract note: keep `tools/test_lesson_repository.sh`, full/no-cache Git hooks, `.githooks/pre-commit`, and `tools/ci-final-gate` as final verification/runtime evidence rather than `TESTS` field entries for this sync ID, because the as-built contract requires `TESTS` entries to be directly wired standalone checks.

Recovery path:

- If metrics cannot be derived safely, stop before UI implementation and request approval rather than inventing values.
- If optional statuses look like true Partial Failures, split the display and data fields.
- If mock parity conflicts with read-only safety, preserve safety and report the conflict.

SYNC-ID: dashboard_control_center_mock_parity
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/fixtures/dashboard-control-center-invalid.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Implemented Dashboard Control Center Live Snapshot Sync Handoff

Sync ID: `dashboard_control_center_live_snapshot_sync`.
Current status: `implemented`.

Current restart context:

- The user approved and this implementation adds a staged path toward seamless live dashboard updates.
- The browser updates while open next to the dashboard CLI, but it remains read-only.
- `tools/dashboard-data` remains the JSON producer; `tools/dashboard` prose must not become a browser data source.
- `tools/dashboard-control-center open` is the right shell boundary for periodic snapshot publication.
- `tools/dashboard-data` must publish producer-owned `snapshot_id` and `content_hash`; browser change detection should use those fields.
- React should keep the last known good snapshot on failed or invalid refresh.
- Browser polling must be GET-only and must not call Git, GitHub, CI, shell, or `tools/*` command endpoints.

Implemented verification entry points:

1. `tools/test_dashboard_schema.sh`.
2. `tools/test_dashboard_data.sh`.
3. `tools/test_dashboard_control_center.sh`.
4. `tools/test_lesson_repository.sh`.

Sync-contract note: keep `tools/test_lesson_repository.sh`, full/no-cache Git hooks, `.githooks/pre-commit`, and `tools/ci-final-gate` as final verification/runtime evidence rather than `TESTS` field entries for this sync ID, because the as-built contract requires `TESTS` entries to be directly wired standalone checks.

Recovery path:

- If atomic snapshot publishing fails, keep the previous one-shot snapshot behavior and stop before enabling refresh.
- If polling blanks the UI on bad data, restore last-known-good behavior before continuing.
- If any browser execution path appears necessary, stop and request approval as a separate future sync ID.

SYNC-ID: dashboard_control_center_live_snapshot_sync
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/dashboard-control-center,vite.config.mjs,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/fixtures/dashboard-control-center-invalid.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Implemented Dashboard Control Center Mock-Aligned Overview Handoff

Sync ID: `dashboard_control_center_mock_aligned_overview`.
Current status: `implemented`.

Current restart context:

- The browser control center is already read-only and has live snapshot sync.
- `dashboard-control-center/mocks/archive/mock-categorized-dashboard.png` remains the visual reference.
- The implemented Overview removes visible non-mock header and snapshot explanation chrome while preserving an accessible page title.
- Next Safe Action keeps the label/helper outside the green primary action row, with target, expected result, and risk as white icon-led metadata rows.
- Partial Failures is always visible as a control-panel category; an empty list shows a concise none state.
- Manual follow-ups do not appear as true failures and are summarized in a separate row with detail navigation.
- The visible Category Health heading is removed; the accessible category-health region remains.
- The four health cards are height-aligned in the grid.
- The four health rings use distinct category colors for lessons, workflow, maintenance, and safety.
- Overview details do not rely on expansion that changes layout height; detailed lists belong on existing category pages.
- Icons added to navigation, status, repeated rows/cards, summaries, and details are decorative or accessible labels only; they must not become buttons or execution affordances.
- The bottom notice is concise repository-control-panel UI chrome.

Implemented verification entry points:

1. `tools/test_dashboard_control_center.sh`.
2. `tools/check_as_built_sync_contract.sh`.
3. `tools/check_as_built_docs.sh`.
4. `tools/check_test_plan_coverage.sh`.
5. `tools/check_ci_workflow_structure.sh`.
6. `tools/test_lesson_repository.sh`.

Sync-contract note: keep full/no-cache Git hooks, `.githooks/pre-commit`, `tools/test_lesson_repository.sh`, and `tools/ci-final-gate` as final verification/runtime evidence rather than broadening this sync ID's `TESTS` field beyond directly wired standalone checks.

Recovery path:

- If removing the visible header breaks accessibility, restore a screen-reader-only title, not the large visible header.
- If manual follow-up navigation is unclear, keep the Overview summary but improve link labels before adding new disclosure behavior.
- If any command execution, non-GET fetch, or command preview leakage appears outside Safety Actions, remove it before continuing.
- If mobile overflow appears, fix responsive constraints rather than adding language-specific branches.

SYNC-ID: dashboard_control_center_mock_aligned_overview
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Implemented Dashboard Control Center Detail-Page Mock Parity Handoff

Sync ID: `dashboard_control_center_detail_mock_parity`.
Current status: `implemented`.

Current restart context:

- The copied visual references are `dashboard-control-center/mocks/archive/mock-detail-lessons.png`, `mock-detail-workflow.png`, `mock-detail-maintenance.png`, and `mock-detail-safety.png`.
- The detail-page mock images are the UI/UX source references for layout, information priority, colors, density, and icon direction; tests validate structure and safety, not pixel-perfect screenshot equality.
- Each detail page starts with a mock-aligned page header and decision summary: what the page checks, current judgment, must-review items, and the next safe check.
- Workflow category icons use one centralized branching `Network` icon component across Overview, navigation, Explore Pages, workflow detail header, and workflow category summary rows.
- Lessons detail surfaces missing settings, warnings, and next learning action in inspection panels before completed details; the primary warning label is derived from structured lesson status fields.
- Development Workflow detail prioritizes approval-required and unknown items in checklist rows, uses human-readable titles, and moves technical keys to secondary metadata.
- Maintenance Sync detail groups snapshot trust, manual follow-ups, warnings, and source boundaries as status cards, a confirmation table, and a source-boundary panel.
- Safety Actions detail separates status cards, Partial Failures table, and display-only Command Previews without adding execution affordances.
- Short localized risk/status labels such as `低` are visually centered.
- English remains the repository-standard data language; fixed UI labels and known control-center source/intent labels display through the resolved UI locale.
- The control-panel UI locale resolver is separate from user-selected lesson display language and workflow/product language settings.
- The browser remains read-only; no route may execute shell, Git, GitHub, CI, or `tools/*` commands.
- Current follow-up tightening keeps the same sync ID and improves mock parity for page-specific header icons, first-row decision-summary bullets/count badges/safe links, active sidebar category context, workflow icon glyph consistency, maintenance/safety card icon containers, failure severity glyphs, and compact display-only command preview grouping.
- Do not add Japanese-only runtime literals when continuing this work; add fixed UI labels through `dashboard-control-center/src/i18n.js` and keep source evidence as sanitized data.
- Do not extend `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv` unless future live-data integration needs new producer-owned fields; this follow-up intentionally uses the existing snapshot shape.

Planned verification entry points:

1. `tools/test_dashboard_control_center.sh`.
2. `tools/check_as_built_sync_contract.sh`.
3. `tools/check_as_built_docs.sh`.
4. `tools/check_test_plan_coverage.sh`.
5. `tools/check_ci_workflow_structure.sh`.
6. `tools/test_dashboard_schema.sh`.
7. `tools/test_dashboard_data.sh`.
8. `tools/test_lesson_repository.sh`.

Sync-contract note: keep full/no-cache Git hooks, `.githooks/pre-commit`, `tools/test_lesson_repository.sh`, and `tools/ci-final-gate` as final verification/runtime evidence rather than broadening this sync ID's `TESTS` field beyond directly wired standalone checks.

Recovery path:

- If detail summaries contradict snapshot data, derive them from existing helper functions and translator labels before adding styling.
- If workflow icon replacement imports fail, use one centralized lucide branching-workflow icon that matches the approved mock direction.
- If mobile overflow appears, adjust responsive constraints instead of adding language-specific branches.
- If command previews look executable, strengthen display-only labels and remove any action-like affordance before continuing.
- If any existing-feature tradeoff appears necessary, stop and request developer approval.

SYNC-ID: dashboard_control_center_detail_mock_parity
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/archive/mock-detail-lessons.png,dashboard-control-center/mocks/archive/mock-detail-workflow.png,dashboard-control-center/mocks/archive/mock-detail-maintenance.png,dashboard-control-center/mocks/archive/mock-detail-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Implemented Lesson Display Label Policy Handoff

Implemented lesson display-label policy sync:

- Sync ID: `lesson_display_label_policy`.
- Current status: `implemented`.
- Current scope: separate learner-facing STEP course labels from internal compatibility names and historical records.
- Do not treat this as a global replacement task.
- Preserve `Step N/14` as the current Lesson14 sync-gate key unless a future approved implementation mechanically separates sync keys from display labels.
- Preserve `tools/lesson14`, `index-14-days.md`, `_14_DAYS` files, `dayN.*` step IDs, and existing historical learning records.
- Implemented learner-facing targets include menu, dashboard, lesson14 reset/runtime output, learn/helpdesk record labels, README, AGENTS routing text, index files, guides, prompts, playbooks, roadmap output, scenario text, and learner-display checks.
- Shared display labels live in `docs/workflow/LESSON_DISPLAY_LABELS.tsv`; shared shell resolution lives in `tools/lib/lesson_display_labels.sh`, with `tools/lib/lesson_common.sh` providing the reusable flow-step display label for record-writing commands.
- Current test caveat: if new learner-facing surfaces are added later, they must be added to `tools/check_learner_display.sh` or another active-surface test rather than relying on global replacement.
- Required verification after implementation: `git diff --check`, `./tools/check_learner_display.sh`, `./tools/test_menu_prerequisites.sh`, `./tools/check_lesson14_sync.sh`, `./tools/test_lesson14.sh`, `./tools/check_agents_skills.sh`, `./tools/check_developer_memory_requirements.sh`, `./tools/as-built-sync status`, `./tools/check_as_built_sync_contract.sh`, `./tools/check_as_built_docs.sh`, and `./tools/test_lesson_repository.sh`.
- Recovery path: if sync gates fail, restore the `Step N/14` machine-key contract first; if display checks over-match history, add a policy-governed allowlist rather than rewriting logs.

SYNC-ID: lesson_display_label_policy
STATUS: implemented
ARTIFACTS: docs/workflow/LESSON_DISPLAY_LABELS.tsv,tools/lib/lesson_display_labels.sh,tools/lib/lesson_common.sh,tools/lib/lesson_runtime.sh,tools/menu,tools/dashboard,tools/learn,tools/helpdesk,tools/lesson14,tools/roadmap,tools/docs-tour,README.md,AGENTS.MD,index.md,index-14-days.md,ai-driven-task-tracker-scenario.md,guides/LESSON_14_DAYS.md,learning/ROADMAP.md,lesson/LESSON_FLOW_14_DAYS.tsv,prompts/PROMPTS.md,prompts/PROMPTS_14_DAYS.md,playbooks/AGENT_PLAYBOOK.md,playbooks/AGENT_PLAYBOOK_14_DAYS.md,tools/check_learner_display.sh,tools/test_menu_prerequisites.sh,tools/check_lesson14_sync.sh,tools/check_agents_skills.sh
TESTS: tools/check_learner_display.sh,tools/test_menu_prerequisites.sh,tools/check_lesson14_sync.sh,tools/check_agents_skills.sh,tools/test_lesson14.sh

## Implemented External Product Repository Authority Handoff

Sync ID: `external_product_repository_authority`.
Current status: `implemented`.

Restart context:

- The current issue is not only a dashboard display issue. The repository needs a product authority read model so external product repositories can be operated with the same quality expectations as lesson-created `task-tracker-repository` without copying the lesson repository wholesale.
- Product repository roots should stay readable: product design documents belong under `docs/product/`, product workflow documents under `docs/workflow/`, product memory under `docs/memory/`, and product operation declarations under `ops/`.
- Root-level duplicate product documents are now blocked by `product_repository_canonical_docs_only`; keep product docs under `docs/product`, `docs/workflow`, and `docs/memory`.
- Product-side `AGENT.md` remains the product repository agent entry; lesson-side `AGENTS.MD` remains the lesson repository invariant source.
- Dashboard must read product structure, manifests, and evidence rather than inferring state from fixed product-stack files.
- `docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv` now records required mode, workflow contexts, product types, validation rule, dashboard visibility, canonical path, and legacy paths.
- `docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv` now records manifest column contracts, evidence index columns, source-id namespace, freshness/status enums, and read-only command preview shape.
- `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv` now includes product authority, manifest summary, evidence summary, product-operation blockers, and not-run/stale state handling before the UI relies on this data.
- `tools/dashboard-data` remains a read-only snapshot producer. It reads existing product manifests and existing evidence only; it must not create evidence, fetch remotes, call `gh`, query GitHub Actions, run product checks, or mutate repositories.
- Product gate evidence should live under the product repository `.git/product-gate-evidence/` area by default and bind observations to product HEAD, freshness, authority, required-in-context state, blockers, and read-only next-command previews.
- Missing product repositories should block product operations only and must not block lesson-only progress.
- Product-operation blockers belong in product authority data and must not be mixed into lesson-only summary blockers.
- Browser dashboard pages remain read-only and must not execute shell, Git, GitHub, CI, or `tools/*` commands.

Implemented verification scope:

```bash
./tools/test_product_repository_authority.sh
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/check_test_plan_coverage.sh
./tools/test_git_hooks.sh
./tools/test_git_hooks_parallel.sh
./tools/test_ci_final_gate.sh
./tools/check_ci_workflow_structure.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
```

Implemented targets:

1. `tools/lib/product_repository_authority.sh`.
2. `tools/product-repository-authority`.
3. `tools/test_product_repository_authority.sh`.
4. Additive dashboard data schema and producer fields.
5. Dashboard data regression updates.
6. Test-plan, Git hooks, and aggregate/final-gate wiring required by existing policy before marking implemented.

SYNC-ID: external_product_repository_authority
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/test_product_repository_authority.sh,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/check_ci_workflow_structure.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

## Implemented STEP 1-14 Product Launch Quality Gate Handoff

Sync ID: `step_1_14_product_launch_quality_gate`.
Current status: `implemented`.
Priority: 1.

Restart context:

- The immediate trust issue is that a STEP 1-14 product can pass existing developer-style checks while failing the launch path documented for the learner.
- The standard task-tracker product should continue to support direct `index.html` opening unless an approved specification changes the launch path.
- The failing Add Task symptom with a `?title=...` URL indicates the browser did not run the expected JavaScript submit handler.
- HTTP-server-only E2E is not enough when README promises direct file opening.
- The final STEP 1-14 completion gate must verify the README launch path, not just unit tests, CI, docs, or HTTP-only Playwright.

Implemented state:

1. The launch-path gate is part of STEP 1-14 sync-gate policy.
2. Direct launch-path product workflow verification covers Add Task, counters, status changes, and Clear Done.
3. The verification is exposed through `tools/product-launch-check` and `tools/test_product_launch_check.sh`, with both runtime artifacts recorded in the sync contract artifacts and tests.
4. Prompts and lesson-sync-gate skill guidance treat README launch verification as completion evidence.
5. Generated product guidance through the existing lesson workflow keeps product README and product docs aligned with the verified launch path.
6. Targeted checks are required before preserving this sync ID as implemented.

Required checks:

```bash
./tools/check_lesson14_sync.sh
./tools/test_lesson14.sh
./tools/test_product_launch_check.sh
./tools/test_product_gate_tools.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
```

Stop and request developer approval before:

- changing the official launch path from direct `index.html` opening to HTTP-server-only launch;
- adding a bundler, dependency, external service, browser command execution, or destructive product operation;
- changing existing STEP 1-7 or STEP 1-14 ordered progression semantics.

Recovery path:

- If direct launch verification fails, fix product launch implementation or generated guidance before allowing completion.
- If product repository context is missing, report the missing context without recreating or mutating repositories.

SYNC-ID: step_1_14_product_launch_quality_gate
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,lesson/SYNC_GATES_14_DAYS.tsv,lesson/LESSON_FLOW_14_DAYS.tsv,prompts/PROMPTS_14_DAYS.md,skills/lesson-sync-gate/SKILL.md,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/product-launch-check,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

## Implemented Product Authority Evidence Status Propagation Handoff

Sync ID: `product_authority_evidence_status_propagation`.
Current status: `implemented`.
Priority: 2.

Restart context:

- Product authority is implemented as a read-only model with focused evidence aggregation coverage.
- Multiple applicable evidence rows must stay valid JSON.
- Required `failed`, `blocked`, `unknown`, `stale`, and `not_run` evidence must be represented as product-operation blocker or manual-required state.
- Dashboard and selected-context work must not duplicate this aggregation in UI code.

Implemented state:

1. Product authority regression cases cover multiple rows, malformed rows, required failures, stale/not-run rows, optional rows, and context mismatch.
2. Evidence fixtures remain temporary inside the test unless persistent fixture files are added to the sync contract artifacts.
3. `tools/lib/product_repository_authority.sh` preserves aggregation and status propagation.
4. Dashboard schema/data expectations consume authority output without duplicating authority aggregation.
5. Targeted authority and dashboard data checks are required before preserving this sync ID as implemented.

Required checks:

```bash
./tools/test_product_repository_authority.sh
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
```

Stop and request developer approval before adding evidence writers, automatic Git/CI refresh, network calls, or product repository mutation.

Recovery path:

- If authority JSON becomes invalid, fix product authority before touching dashboard-data or React.
- If evidence state cannot be classified safely, emit `unknown` or `manual_required` rather than `ready`.

SYNC-ID: product_authority_evidence_status_propagation
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/test_product_repository_authority.sh,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/test_dashboard_data.sh,tools/test_dashboard_schema.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

## Implemented Free Development Product Repository Scaffold Handoff

Sync ID: `free_development_product_repo_scaffold`.
Current status: `implemented`.
Priority: 3.

Restart context:

- Free Development repositories need a clear source authority so the lesson and dashboard can distinguish runtime entrypoints, source files, tests, CI, security evidence, and dashboard-visible surfaces.
- The scaffold should not copy the whole lesson repository.
- Canonical product documents belong under `docs/product/`, `docs/workflow/`, and `docs/memory/`; root duplicate Markdown documents are blocked.

Implemented state:

1. Product repository structure policy defines Free Development scaffold expectations.
2. Manifest declarations identify entrypoint, runtime source, test source, CI, security, dashboard surfaces, and integrations.
3. New manifest files must be added to the sync contract artifacts when created.
4. Free Development, Product Improvement, and External Integration gate readers use shared product authority resolvers.
5. Scaffold validation covers missing required paths, optional stack additions, ambiguous source authority, and root duplicate blockers.
6. Scaffold validation is exposed through `tools/product-scaffold-check` and `tools/test_product_scaffold_check.sh`, with both runtime artifacts recorded in the sync contract artifacts and tests.
7. Free-development guidance and targeted checks are required before preserving this sync ID as implemented.

Required checks:

```bash
./tools/test_product_scaffold_check.sh
./tools/test_product_gate_tools.sh
./tools/test_product_repository_authority.sh
./tools/check_workflow_pair_sync.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
```

Stop and request developer approval before weakening canonical product document enforcement, making CI mandatory for every Free Development repository, or adding destructive repository automation.

Recovery path:

- If root duplicate documents exist, report a product-operation blocker.
- If source authority is ambiguous, fail scaffold validation and require manifest correction.

SYNC-ID: free_development_product_repo_scaffold
STATUS: implemented
ARTIFACTS: free-development/FREE_DEVELOPMENT_MODE.md,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,tools/free-development,tools/product-improvement,tools/external-integration,tools/product-scaffold-check,tools/test_product_scaffold_check.sh,tools/test_product_gate_tools.sh,tools/test_product_repository_authority.sh,tools/check_workflow_pair_sync.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_product_scaffold_check.sh,tools/test_product_gate_tools.sh,tools/test_product_repository_authority.sh,tools/check_workflow_pair_sync.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

## Implemented Dashboard Control Center Selected Context Sync Handoff

Sync ID: `dashboard_control_center_selected_context_sync`.
Current status: `implemented`.
Priority: 4.

Restart context:

- The implemented selected-context sync starts from the dashboard data contract, not from React-only selector UI.
- This dashboard sync consumes the launch-quality, evidence-status, and scaffold contracts rather than absorbing those responsibilities.
- `selected_context` and `available_contexts` are the intended shared contract between dashboard-data and the browser.
- The selected context must tie together the user-selected menu, workflow context, target repository, product type, current lesson step, Git state, CI state, Security state, evidence, blockers, manual follow-ups, command previews, and next safe action.
- `task-tracker-repository` remains the STEP 1-14 standard product repository. Free Development, Product Improvement, and External Integration must resolve repositories through context and policy data instead of fixed names.
- `tools/dashboard-data` must remain read-only. It may read existing settings, manifests, and evidence; it must not create evidence, run checks, fetch remotes, call GitHub, run CI, mutate repositories, or make browser state authoritative.
- Product authority evidence aggregation must be fixed before UI work depends on it. Multiple evidence rows must stay valid JSON, and `failed`, `blocked`, `stale`, and `not_run` must be represented in status and blockers.
- Root-level product document fallback is superseded by `product_repository_canonical_docs_only`; keep dashboard and gate resolution around canonical `docs/product/*`, `docs/workflow/*`, and `docs/memory/*` paths.
- Git management settings and Security checks are cross-cutting selected-context state, not primary menu items.
- Partial Failures are true failed, blocked, or unknown current-context problems. Optional, cached, not-run, or manual-required items belong in manual follow-ups or evidence sections unless they block the current selected context.
- The five `dashboard-control-center/mocks/mock-context-*.png` files are UI/UX references for hierarchy, icon direction, density, color identity, and intuitive comprehension. They are not pixel-perfect test oracles.
- The dashboard UI locale remains separate from lesson display language and product development language settings.

Implemented state:

1. `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv` includes selected-context fields.
2. `tools/dashboard-data` / `tools/lib/dashboard_data.sh` implement producer-side context resolution.
3. Git, CI, Security, and product status readers stay read-only; they may read existing evidence/settings/manifests but must not execute checks or refresh evidence.
4. Evidence propagation comes from `product_authority_evidence_status_propagation`; the dashboard does not reimplement authority aggregation.
5. Scaffold and canonical resolver behavior comes from `free_development_product_repo_scaffold`; root fallback is superseded by `product_repository_canonical_docs_only`.
6. Fixtures and targeted tests cover selected-context behavior.
7. React components and styling consume producer-owned selected-context data.
8. Full mock-source-of-truth page parity is implemented separately by `dashboard_control_center_context_mock_source_of_truth`.
9. Contract-required verification is required before preserving this sync ID as implemented.

Required checks for the implemented selected-context sync:

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

For later mock-source UI changes, `npm run dashboard:build` remains the targeted Vite build check outside this sync ID's direct `TESTS` metadata.

Stop and request developer approval before:

- browser command execution, POST fetches, Git/GitHub/CI/API calls, live authoritative CI/Git polling, automatic push, merge, cleanup, deletion, OAuth, token, webhook, or destructive operations;
- removing root-level legacy product document compatibility;
- changing STEP 1-7, STEP 1-14, existing CI, pre-commit, Git hooks, document routes, or dashboard read-only ownership;
- adding a persistent selected-context storage file outside existing settings and policy sources;
- accepting any existing-feature tradeoff.

Recovery path:

- If schema checks fail, correct schema, producer, and fixtures before UI work.
- If authority checks fail, fix product authority aggregation before dashboard-data or React changes.
- If context resolution cannot choose safely, emit blocked or manual-required state rather than guessing.
- If UI output contradicts producer data, change producer-owned data or shared helper logic rather than React-side inference.
- If sync checks fail, repair all five synchronized documents and the sync contract before runtime implementation continues.

SYNC-ID: dashboard_control_center_selected_context_sync
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Implemented Dashboard Control Center Context Mock Source Of Truth Handoff

Sync ID: `dashboard_control_center_context_mock_source_of_truth`.
Current status: `implemented`.

Restart context:

- Treat `dashboard-control-center/mocks/mock-context-overview.png`, `mock-context-lessons.png`, `mock-context-workflow.png`, `mock-context-maintenance.png`, and `mock-context-safety.png` as the UI/UX source of truth for this implemented dashboard pass.
- Preserve the selected-context, product authority, and live snapshot data work that already exists; do not solve UI mismatch by hard-coding screenshot values in React.
- Start follow-up review from `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv`, `tools/dashboard-data`, `dashboard-control-center/src/App.jsx`, `dashboard-control-center/src/dashboardData.js`, `dashboard-control-center/src/i18n.js`, `dashboard-control-center/src/styles.css`, the dashboard fixtures, and the Playwright spec.
- Keep `tools/dashboard-data` as the only dashboard state authority. The browser remains a read-only renderer.

Implemented reminders:

- The left sidebar, Overview, Lessons, Workflow, Maintenance, and Safety pages are built around the five context mocks.
- Producer-owned fields were added before UI reliance where a mock field could not be derived safely.
- Keep fixed labels in `i18n.js`; do not confuse the control-panel UI locale with lesson workflow display language or product development language.
- Keep Partial Failures separate from optional/manual follow-up states.
- Keep command previews display-only and non-executable.
- Verify responsive layout, centered icon/pill alignment, and mobile no-overflow through targeted dashboard tests.

Required implemented verification:

```bash
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_control_center.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_test_plan_coverage.sh
./tools/check_ci_workflow_structure.sh
```

Use `npm run dashboard:build` as the targeted Vite build check for this runtime UI code change.

Developer approval is required before browser command execution, POST fetches, Git/GitHub/CI/API calls, live authoritative CI/Git polling, automatic push, merge, cleanup, deletion, OAuth, token, webhook, evidence writing, removing root-level legacy product document compatibility, screenshot-equality test oracles, or any existing-feature tradeoff.

SYNC-ID: dashboard_control_center_context_mock_source_of_truth
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Implemented Dashboard Control Center Exact Mock Alignment Correction Handoff

Sync ID: `dashboard_control_center_mock_exact_alignment_correction`.
Current status: `implemented`.

Restart context:

- Developer visual review rejected the earlier dashboard as insufficiently aligned with the approved mock family for design, color, contrast, icon treatment, and content amount.
- This sync ID implemented the corrective runtime pass after `dashboard_control_center_context_mock_source_of_truth`; future visual changes should build on this implemented surface rather than treating the earlier mock-source status as sufficient.
- Continue from the five active mocks under `dashboard-control-center/mocks/`:
  - `mock-context-overview.png`
  - `mock-context-lessons.png`
  - `mock-context-workflow.png`
  - `mock-context-maintenance.png`
  - `mock-context-safety.png`
- The correction must remove the appearance of mock alignment by generic CSS layering. Rebuild page-specific surfaces where the mock uses page-specific hierarchy.
- The browser remains read-only. It must not run Git, GitHub, CI, shell, product-security, product-authority, push, merge, cleanup, or evidence-writing operations.

Important implementation constraints:

- Preserve STEP 1-7, STEP 1-14, existing CI, existing checks, Git hooks, pre-commit, document routes, live snapshot sync, canonical product document enforcement, and localization boundaries.
- Keep control-panel fixed labels in `i18n.js`; do not confuse UI locale with lesson display language or product development language.
- Do not hard-code mock values, one product repository name, one language phrase, one stack, or one fixture result.
- Do not create repository information, documents, settings, help, or changelog runtime pages until mock-backed requirements exist.
- If producer data is missing for a mock field, add schema-backed producer data or show a safe incomplete state. Do not invent state in React.

Implemented focus:

1. Producer-owned context-map data for all displayed menu contexts.
   - Do not rely on a thin `available_contexts[]` menu/status list for live switching; expand it or add an equivalent producer-owned map before the UI treats a menu choice as live context.
2. Policy-backed repository resolver for STEP 1-14, Free Development, Product Improvement, External Integration, and lesson-repository improvement.
3. Evidence and blocker propagation for Git, CI, Security, product authority, scaffold, launch, and workflow-pair status.
   - Selected-context Git, CI, and Security now derive from matching `product.git.*`, `product.ci.*`, and `product.security.*` authority evidence or blockers for the active product workflow context.
   - Required evidence only satisfies readiness when it is both current and authoritative; advisory or cached required evidence remains non-healthy.
4. Page-specific mock surfaces for Overview, Lessons, Workflow, Maintenance, and Safety.
   - Lesson live rows, Maintenance status cards, and Safety status cards use producer-owned setting states, snapshot identity, evidence rows, security rows, and current-context Partial Failure detail instead of fixed success prose.
5. External product repository scaffold and launch-quality wiring where dashboard facts depend on them.
   - Treat `docs/memory/` as part of the standard external repository scaffold shape; individual memory files may remain optional until the workflow uses them.

Verification handoff:

- The implemented `TESTS` field now records targeted runtime checks for dashboard schema/data/control-center, product authority, scaffold, launch, product gate, STEP 1-14 sync, STEP 1-14 aggregate, and as-built synchronization.
- Future runtime changes should run targeted tests according to changed files, AGENTS.MD local-verification scope, and the active workflow contract.
- Heavy full/no-cache hooks, final gate, main CI, and remote CI remain separate workflow-contract decisions.

Stop and ask for approval before:

- Any browser command execution, POST fetch, Git/GitHub/CI/API call, live authoritative polling, push, merge, cleanup, remote deletion, OAuth, token handling, webhook handling, evidence writing, destructive operation, screenshot-equality oracle, canonical product document enforcement weakening, or existing-feature tradeoff.
- Any change to STEP 1-14's official direct `index.html` launch path.

Recovery path:

- If sync checks fail, fix the five synchronized documents and sync contract before runtime work.
- If UI output disagrees with producer data, correct schema or producer data instead of adding UI-only status inference.
- If mock alignment still fails visual review, revise page structure and color/icon tokens rather than layering additional one-off CSS.

SYNC-ID: dashboard_control_center_mock_exact_alignment_correction
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,free-development/FREE_DEVELOPMENT_MODE.md,templates/TEMPLATES.md,lesson/SYNC_GATES_14_DAYS.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/lib/product_repository_authority.sh,tools/free-development,tools/product-improvement,tools/external-integration,tools/product-scaffold-check,tools/product-launch-check,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

## Implemented Dashboard Lessons Page Exact Mock Alignment Handoff

SYNC-ID: dashboard_control_center_lessons_page_exact_mock_alignment
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

Restart context:

- The Lessons page mock-alignment pass is implemented.
- Source mock: `dashboard-control-center/mocks/mock-context-lessons.png`.
- Future Lessons work should start from the implemented three-card, responsive, read-only page and compare against the source mock for regressions.
- Keep the dashboard read-only and producer-owned. Do not invent lesson progress, blocker, approval, repository, Git, CI, Security, or language facts in React.
- For future visual implementation, perform visual alignment first and run tests after developer visual approval unless the workflow owner explicitly requests Git/CI closure.
- Use the existing dashboard dev command when visual inspection is needed: `DASHBOARD_CONTROL_CENTER_DATA_FILE=.dashboard-control-center/dashboard-data.json npm run dashboard:dev -- --host 127.0.0.1`.
- Do not create repository information, documents, settings, help, or changelog runtime pages in this planned pass.

## Implemented Dashboard Control Center Visual Refinement Follow-up Handoff

SYNC-ID: dashboard_control_center_visual_refinement_followup
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/memory/DEVELOPER_MEMORY.md,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

Restart context:

- The active dashboard visual refinement now spans Lessons, Development Workflow, Maintenance Sync, Safety Confirmation, and the shared sidebar.
- The left sidebar is unified across implemented pages and should remain consistent with the dashboard overview menu.
- Lessons and dashboard lesson-progress cards use white backgrounds, solid-color progress, one-time count-up animation only, and no gradient/fade/shine/icon scaling effects.
- Maintenance source and reference fields use one-line ellipsis, copy buttons outside the field, and tooltip bubbles with a pointer for full values.
- Safety command previews use the same copy/tooltip behavior and are stacked above Security policy for readability.
- Known fixed labels should remain localized through `i18n.js`; file paths, command text, evidence ids, and repository facts remain producer data.
- Developer Memory was intentionally reset and repopulated with active dashboard/maintenance follow-ups.
- Minimal verification and Git/CI closure are the remaining active steps for this request.

Stop and ask before adding browser command execution, POST actions, live Git/GitHub/CI polling, product-security execution, product-authority execution, evidence writing, push/merge automation inside the dashboard, destructive operations, runtime placeholder pages, or screenshot-equality test oracles.

## Implemented Menu Product Display Profile Confirmation Handoff

SYNC-ID: menu_product_display_profile_confirmation
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/MENU_PRODUCT_PROFILE_POLICY.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/lesson_common.sh,tools/lib/product_repository_authority.sh,tools/product-profile,tools/menu,tools/lesson,tools/lesson14,tools/free-development,tools/product-improvement,tools/external-integration,tools/team-development,tools/product-scaffold-check,tools/test_menu_prerequisites.sh,tools/test_lesson.sh,tools/test_lesson14.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_menu_prerequisites.sh,tools/test_lesson.sh,tools/test_lesson14.sh,tools/test_dashboard_data.sh,tools/check_lesson_structure.sh,tools/check_agents_skills.sh

Restart context:

- All seven progress-menu choices now require a learner-confirmed product name or work-target name.
- Menu items 1 through 6 use the external product repository profile at `ops/PRODUCT_PROFILE.json`.
- Menu item 7 uses a lesson-repository learning profile and does not require the external product repository.
- Product profile handling is producer-backed, and the dashboard snapshot is generated from `tools/dashboard-data`.

Verification notes:

- Passed targeted profile, menu, lesson, product authority, scaffold, schema, dashboard data, structure, AGENTS, build, and whitespace checks listed in this block.
- `tools/test_dashboard_control_center.sh` was attempted but failed in existing browser UI layout expectations:
  - Overview card top alignment expected one row but observed wrapping into two rows.
  - Unsafe-text responsive test timed out waiting for the Lessons navigation link.
- Treat those browser layout failures as a separate dashboard responsive/test-expectation follow-up, not as passed evidence for the profile-data contract.

Safety notes:

- The dashboard remains read-only and only displays the profile from the snapshot.
- Do not infer product names from requirements/specification prose or repository paths.
- Do not edit the external product repository without boundary confirmation and explicit approval.

## Implemented Product Repository Canonical Docs Only Handoff

SYNC-ID: product_repository_canonical_docs_only
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_REPOSITORY_FORBIDDEN_ROOT_PATHS.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,prompts/PROMPTS.md,prompts/PROMPTS_14_DAYS.md,lesson/LESSON_FLOW.tsv,lesson/LESSON_FLOW_14_DAYS.tsv,lesson/SYNC_GATES_14_DAYS.tsv,playbooks/AGENT_PLAYBOOK.md,playbooks/AGENT_PLAYBOOK_14_DAYS.md,templates/TEMPLATES.md,skills/task-tracker-docs/SKILL.md,skills/task-tracker-docs/references/product-docs.md,skills/worklog-doc-sync/SKILL.md,skills/worklog-doc-sync/references/worklog-sync.md,skills/lesson-sync-gate/SKILL.md,skills/lesson-sync-gate/references/sync-gates.md,skills/learning-progress-helpdesk/references/progress-helpdesk.md,tools/lib/product_repository_authority.sh,tools/product-scaffold-check,tools/product-improvement,tools/external-integration,tools/dashboard-data,tools/dashboard,tools/check_workflow_pair_sync.sh,tools/check_agents_skills.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_security.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_security.sh,tools/check_agents_skills.sh,tools/test_dashboard_data.sh,tools/test_lesson14.sh,tools/check_lesson_structure.sh,tools/check_lesson14_sync.sh

Restart context:

- Product repository docs now use canonical paths only: `docs/product/*`, `docs/workflow/*`, and `docs/memory/*`.
- `docs/workflow/PRODUCT_REPOSITORY_FORBIDDEN_ROOT_PATHS.tsv` is the reusable policy for root Markdown paths that must not exist in product repositories.
- Product authority and scaffold checks block root duplicates before reporting readiness.
- `tools/check_workflow_pair_sync.sh --product` no longer falls back to root `TASK_TRACKER.md` or `HANDOFF.md`.
- Prompts, lesson flows, sync gates, playbooks, and repo-local skills now point to canonical product paths.
- This lesson repository records only reusable prevention policy, tools, prompts, and tests. External product repository cleanup state is not a lesson-repository source of truth.

Verification notes:

- Local targeted verification passed for product authority, scaffold, product security, AGENTS/skills, dashboard data, lesson14, lesson structure, and lesson14 sync.
- Main CI is not part of the requested closure for this handoff. Complete PR CI, merge, and local/remote sync; do not wait for main CI unless a later request changes the workflow.

Recovery notes:

- If a product repository still has root duplicates, compare root and canonical contents before deleting. Never delete a differing root file without preserving the content for review.
- If a product repository lacks canonical docs, create or move content into the canonical path rather than restoring root fallback.
- If root duplicate blockers appear in dashboard data, fix the external repository structure; do not hide the blocker in React.

## Implemented Dashboard Control Center Documents Guided Catalog Handoff

SYNC-ID: dashboard_control_center_documents_guided_catalog
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/dashboard_data.sh,tools/lib/document_paths.sh,tools/lib/product_repository_authority.sh,tools/dashboard-data,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

Restart context:

- The Documents page direction is implemented.
- `tools/dashboard-data` now emits a producer-owned `documents` catalog, with React rendering purpose-based document groups.
- Do not regress `DocumentsPage` back to a UI-local fixed document array.
- Do not use the Documents page as the primary place for Git/CI status, evidence rows, command previews, source-command detail, Security gates, or repository file-tree exploration.
- Route those concepts to Development Workflow, Maintenance Sync, Safety Confirmation, Repository Information, docs-tour, or update history as appropriate.

Implementation reminders:

- Start follow-up changes from `DASHBOARD_DATA_SCHEMA.tsv`, `tools/lib/dashboard_data.sh`, `tools/dashboard-data`, and `dashboard-control-center/src/dashboardData.js` before changing visible UI.
- Keep document catalog fields generic and reusable: stable document id, group id, role id, path, audience, order, status, status source, related dashboard surface, and display-only related command metadata are the current contract.
- Keep fixed display labels in `i18n.js`; keep file paths, ids, command text, and evidence ids as sanitized producer data.
- Use existing dashboard card, copy, tooltip, sidebar, and responsive layout conventions.
- If malformed data appears, fail validation; if legacy document catalog data is missing, show a safe incomplete state; do not invent state in React.
- Product type handling now follows `PRODUCT_MANIFEST.tsv` order and product authority can evaluate multiple `|`-separated product types; do not restore fixed `STEP 1-14 = web` assumptions.

Verification expectations:

```bash
./tools/test_dashboard_schema.sh
./tools/test_dashboard_data.sh
./tools/test_dashboard_control_center.sh
./tools/test_product_repository_authority.sh
./tools/test_product_scaffold_check.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
```

Run `npm run dashboard:build` when runtime React changes are made.
Run heavier aggregate, pre-commit, PR CI, or main CI only when the active workflow contract requires it.

Stop and ask before:

- Browser command execution, POST fetches, live Git/GitHub/CI/API polling, evidence writing, document editing from the dashboard, external repository mutation, push, merge, cleanup, remote deletion, OAuth, token handling, destructive operations, or accepting any existing-feature tradeoff.
- Removing or weakening docs-tour, `tools/dashboard docs`, Maintenance Sync, Safety Confirmation, Repository Information, STEP 1-7, STEP 1-14, existing checks, CI, Git hooks, pre-commit, localization boundaries, or read-only dashboard ownership.

## Implemented Agent Escalated Verification Policy Handoff

SYNC-ID: agent_escalated_verification_policy
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv
TESTS: tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_agents_skills.sh

Restart context:

- AGENTS.MD now has invariant rule 22: known sandbox-incompatible, non-destructive verification must be run with the required execution scope from the first attempt.
- Covered examples are Playwright/Chromium real-screen inspection, screenshot capture, browser launch, local port observation, and equivalent observation-only checks needed by the active task.
- The rule exists to prevent false or delayed visual verification when the page must be inspected before design conclusions or developer visual review.

Safety notes:

- This policy does not authorize credentials, OAuth, external writes, dependency changes, repository mutation, evidence writes, push, merge, cleanup, delete, destructive operations, CI failure overrides, gate weakening, or any existing-feature tradeoff.
- Dashboard pages remain read-only. Escalated Playwright is a verification method outside the dashboard, not a dashboard runtime capability.
- If Playwright cannot capture the page even with the required execution scope, report that blocker and do not claim visual verification.

Verification expectation:

```bash
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_agents_skills.sh
```

## Implemented Dashboard Control Center Settings Safe Change Handoff

SYNC-ID: dashboard_control_center_settings_safe_change_plan
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/lib/dashboard_data.sh,tools/lib/git_workflow_policy.sh,tools/dashboard-data,tools/dashboard-settings,tools/dashboard-control-center,vite.config.mjs,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh
TESTS: tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_git_workflow_policy.sh,tools/test_lesson.sh,tools/test_lesson14.sh,tools/test_menu_prerequisites.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh

Restart context:

- Runtime implementation for the Settings update surface is present and this sync ID is implemented.
- The implemented direction is a non-engineer-readable Settings page that shows current selected menu, target repository, current setting values, status, source, changeability, and related page from producer-owned dashboard data.
- Settings rows open a large review popup that explains current value, proposed value, impact, source file, required confirmation, validation state, allowed values, safe update preview, plan result, and apply result; the popup moves focus inside on open, traps Tab navigation, supports Escape close, and returns focus to the initiating row.
- The workflow display language row controls lesson guidance, workflow display text, and Dashboard fixed UI labels for all standard Dashboard UI locales.
- `tools/dashboard-data` emits `summary.workflow_language`, `summary.display_locale`, and `summary.ui_locale`; validators check the locale summary and Settings row match when the fields are present.
- After a successful browser apply response with `snapshot_regenerated: true`, React refetches the regenerated snapshot immediately and updates fixed UI labels without losing a reload marker.
- Browser runtime remains read-only outside the implemented Settings mutation boundary. Settings writes go only through same-origin `application/json` POSTs to `/dashboard-settings/plan` and `/dashboard-settings/apply`, which call `tools/dashboard-settings`.
- The settings catalog is emitted by `tools/dashboard-data` from existing lesson settings, Git workflow policy/settings, selected context, product authority, and security status sources. React must not parse TSV files or maintain a fixed settings source of truth.
- `tools/dashboard-settings` owns writes with allowlisted setting ids, value validation, explicit `--confirm`, same-directory temporary-file writes, atomic rename, dashboard snapshot regeneration, and snapshot output restricted to `.dashboard-control-center/` outside isolated test mode.
- Product/work target naming, approval-state mutation, security gates, evidence, Git/CI execution, external product repository mutation, push, merge, cleanup, deletion, OAuth, and credentials remain outside editable Settings rows.

Implementation reminders:

- Continue from the implemented runtime files: `DASHBOARD_DATA_SCHEMA.tsv`, `tools/lib/dashboard_data.sh`, `tools/lib/git_workflow_policy.sh`, `tools/dashboard-data`, `tools/dashboard-settings`, `tools/dashboard-control-center`, `vite.config.mjs`, `dashboard-control-center/src/dashboardData.js`, `dashboard-control-center/src/App.jsx`, `dashboard-control-center/src/i18n.js`, and `dashboard-control-center/src/styles.css`.
- Keep fields generic and reusable: group id, setting id, scope, current value, current label, status, safe source file, allowed values, editability, reviewability, risk level, confirmation requirement, disabled reason, related page, update action id, and review metadata.
- Reuse existing lesson setting normalization and Git workflow policy validation; do not duplicate TSV parsing or add UI-only branches.
- Keep product or work target naming display-only in this sync ID; any future naming writer must use product-profile policy, product repository boundary checks when product-scoped, and a separate approved write contract.
- Keep fixed display labels in `i18n.js`; keep file paths, ids, setting values, and repository facts as sanitized producer data.
- Keep fixed-label dictionaries, layout support, and Playwright coverage aligned when changing Dashboard UI localization; do not change locale fallback logic alone.
- Use row layouts and dialog patterns that remain readable on desktop, narrow desktop, tablet, and phone widths.
- If malformed settings catalog data appears, fail validation; if catalog data is missing, show a safe incomplete state; do not invent readiness or source files in React.

Verification expectations after implementation:

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

`npm run dashboard:build` is required after React/Vite changes.
Use escalated execution from the first attempt for Playwright/Chromium verification, per AGENTS.MD.
Sub-agent review must find no unresolved major issues before the completion report.
Final implementation verification included multiple sub-agent reviews; no unresolved major issues remained after the Settings language-flow, safety, UI, and test fixes.

Stop and ask before:

- Browser command execution beyond `tools/dashboard-settings`, POST/PUT/PATCH/DELETE fetches beyond `/dashboard-settings/plan` and `/dashboard-settings/apply`, live Git/GitHub/CI/API polling, evidence writing, settings mutation outside allowlisted Settings rows, external repository mutation, push, merge, cleanup, remote deletion, OAuth, token handling, destructive operations, dependency changes, or approval-state mutation.
- Removing or weakening the existing read-only dashboard guards outside Settings, no command execution checks, mutation fetch checks, display-only command preview contract, STEP 1-7, STEP 1-14, existing checks, CI, Git hooks, pre-commit, repo-local skills, localization boundaries, or document routes.
- Accepting any existing-feature tradeoff to make Settings writes easier.

Recovery notes:

- If schema or producer tests fail, fix the producer contract before changing UI.
- If the Settings update tool writes invalid data, restore from the temporary or backup path and add a regression before retrying.
- If 7-day or 14-day behavior regresses, revert the Settings update surface rather than changing lesson behavior to fit the new UI.
- If a responsive or popup issue appears, fix layout constraints and dialog behavior instead of adding language-specific branches.

## Implemented Dashboard Control Center Full Locale UI Support Handoff

SYNC-ID: dashboard_control_center_full_locale_ui_support
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/lib/lesson_common.sh,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/dashboard-settings,tools/dashboard-control-center,tools/test_dashboard_i18n.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh,tools/test_lesson_repository.sh,vite.config.mjs,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js
TESTS: tools/test_dashboard_i18n.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh

Current State:

- This sync ID is implemented. The existing Settings safe-change implementation is extended so Dashboard fixed-label dictionaries cover the full standard language set.
- The Settings-selected workflow display language drives the Dashboard fixed UI language for `ja`, `en`, `ko`, `zh-CN`, `zh-TW`, `es`, `pt-BR`, `fr`, `de`, `id`, `vi`, `th`, `hi`, and `ar`.
- Product development language remains separate from Dashboard UI language and must not become the Dashboard locale resolver.
- The existing safe Settings writer and Vite endpoints remain the only mutation boundary: same-origin `application/json` POSTs to `/dashboard-settings/plan` and `/dashboard-settings/apply`, calling `tools/dashboard-settings` through `execFile`.
- The interaction is a server-confirmed instant UI update: after apply succeeds, React updates active locale from validated response metadata, then immediately refetches the regenerated snapshot as authoritative data.
- A short Settings-page notice explains that setting changes can take a moment and that the Dashboard updates automatically after successful application.
- Arabic uses RTL chrome plus LTR isolation for technical values such as file paths, command strings, ids, hashes, and branch names.

Document sync verification state:

- The implemented sync is recorded across requirements, specification, implementation plan, task tracker, handoff, and `AS_BUILT_SYNC_CONTRACT.tsv`.
- Final sync checks passed: `tools/check_as_built_sync_contract.sh`, `tools/check_as_built_docs.sh`, `tools/check_test_plan_coverage.sh`, and `tools/check_workflow_pair_sync.sh`.
- Related Dashboard checks passed: `tools/test_dashboard_i18n.sh`, `tools/test_dashboard_schema.sh`, `tools/test_dashboard_data.sh`, `tools/test_dashboard_settings.sh`, and `tools/test_dashboard_control_center.sh`.
- `tools/test_dashboard_i18n.sh` now fails broad English fallback for supported non-English locales and validates locale policy, aliases, direction metadata, and dictionary completeness.
- `tools/test_dashboard_data.sh` now verifies legacy raw `zh` workflow-language files emit canonical `zh-CN` in Dashboard summary and the Settings row.
- `npm run dashboard:build`, `tools/check_ci_workflow_structure.sh`, `tools/test_git_hooks.sh`, `tools/test_git_hooks_parallel.sh`, `tools/test_ci_final_gate.sh`, and `tools/test_lesson_repository.sh` passed after the final fixes.
- `git diff --check` passed.
- Multiple read-only sub-agent reviews completed. One dictionary-completeness finding was fixed by removing broad English base fallback for supported locales, adding an English-match threshold test, and canonicalizing legacy `zh`; follow-up review confirmed no unresolved major findings.

Implementation notes:

- Start from `dashboard-control-center/src/i18n.js`; make it the single source for Dashboard locale policy, aliases, direction metadata, fixed-label dictionaries, and testable completeness helpers.
- Keep the policy aligned with `tools/lib/lesson_common.sh` and AGENTS.MD standard languages; do not create unconnected language lists.
- Update `DASHBOARD_DATA_SCHEMA.tsv`, `tools/lib/dashboard_data.sh`, `tools/dashboard-data`, `dashboardData.js`, fixtures, and tests together when expanding `summary.ui_locale`.
- Update `tools/dashboard-settings` only inside the existing allowlisted writer boundary and return canonical locale metadata after successful locale-affecting apply.
- Update `App.jsx` to apply locale state after server success and refetch the snapshot without reloading the page.
- Update `styles.css` with reusable RTL and technical-value isolation support rather than page-specific language branches.
- `tools/test_dashboard_i18n.sh` is wired into `TEST_PLAN_MANIFEST.tsv`, `GIT_HOOK_CHECKS.tsv`, aggregate dashboard tests, and the as-built sync contract.
- Keep regular checks fast by combining static all-language dictionary validation with representative Playwright coverage; reserve full all-language browser smoke for release readiness or explicit final-gate scope.

Verification expectations:

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

Run `./tools/test_lesson.sh`, `./tools/test_lesson14.sh`, and `./tools/test_menu_prerequisites.sh` if language normalization, setting-file handling, or menu prerequisite behavior changes.
Run `./tools/test_lesson_repository.sh` only when required by changed-file policy, final-gate scope, or developer approval.
Use escalated browser execution from the first attempt for Playwright visual inspection when the implementation reaches browser verification.

Stop and ask before:

- Runtime automatic translation, external translation APIs, dependency changes, new browser mutation routes, mutation outside allowlisted Settings rows, any Settings writer beyond `tools/dashboard-settings`, external repository writes, evidence writes, Git/GitHub/CI execution, approval-state mutation, OAuth, credentials, cleanup, deletion, push, merge, destructive operations, or weakening schema and same-origin guards.
- Reducing pre-commit, CI, aggregate, final-gate, or dictionary-completeness coverage.
- Changing the AGENTS.MD standard language list or promoting unsupported custom values into Dashboard UI locales.
- Accepting any tradeoff against STEP 1-7, STEP 1-14, existing checks, existing document routes, repo-local skills, localization boundaries, or security gates.

Next Step:

- Ready for completion report. Future release-readiness work may add human translation QA or explicit all-language browser smoke without changing routine CI.

## Implemented Dashboard Control Center Settings Apply Feedback Handoff

SYNC-ID: dashboard_control_center_settings_apply_feedback
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_i18n.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_control_center.sh
TESTS: tools/test_dashboard_i18n.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh

Restart context:

- Runtime implementation is complete for this sync ID.
- The implemented Settings writer, Vite same-origin JSON plan/apply endpoints, dictionary policy, snapshot refetch, and no-reload locale update remain the baseline.
- Settings save success and Dashboard snapshot reflection confirmation are separated in the browser UI.
- The feedback surface is independent from the selected row and confirmation dialog state so it can continue after the dialog closes.
- Normal progress uses a delayed non-modal accessible status surface, not a nested modal over the existing Settings dialog focus trap.
- The refetched snapshot remains authoritative. Apply-response locale metadata may provide immediate feedback after server success, but it does not override a conflicting snapshot as final state.
- Row-level `確認のみ` and `ここで変更可能` chips were removed; the right-end row action and accessible row label carry the changeability meaning instead.
- The Settings confirmation eyebrow text is slightly larger through a targeted style rule.

Implemented entry points:

- Continue from `dashboard-control-center/src/App.jsx`, `dashboard-control-center/src/i18n.js`, `dashboard-control-center/src/styles.css`, and `tests/playwright/dashboard-control-center.spec.js` if follow-up work is needed.
- Do not change `tools/dashboard-settings`, Vite mutation endpoints, dashboard-data schema, producer behavior, CI, hooks, or Settings editability unless implementation proves the existing contract cannot satisfy the UX safely and the developer approves.
- Named state and timing policy constants are used rather than scattered magic numbers or setting-specific branches.
- Ordinary settings reconcile through the Settings row `id/current_value`; `workflow_language` reconciles through summary locale fields, direction, and the Settings row.
- Use stable roles, state keys, and metadata in tests. Do not rely only on exact Japanese or English text.

Verification expectations after implementation:

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

Run `npm run dashboard:build` after React or CSS runtime changes.
Run broader lesson, repository, hook, or final-gate checks only when changed files or workflow policy require them.
Use escalated execution from the first attempt for Playwright/Chromium verification when real browser inspection is required.

Implementation verification completed:

- `npm run dashboard:build` passed after runtime changes.
- `tools/test_dashboard_i18n.sh` passed after adding apply feedback locale keys.
- `tools/test_dashboard_settings.sh` passed after runtime changes.
- `tools/test_dashboard_control_center.sh` passed with 13 Playwright tests, including fast path, delayed feedback, stale snapshot authority, chip removal, action labels, eyebrow sizing, RTL, and no-overflow.
- `tools/test_lesson_repository.sh` passed after runtime and documentation updates, covering 7-day, 14-day, dashboard, Git/CI, product gate, and security guard paths.
- Final structure, sync, test-plan, workflow-pair, and sub-agent close-out verification passed with no unresolved major findings.

Stop and ask before:

- Adding browser mutation endpoints, adding writers beyond `tools/dashboard-settings`, changing the Settings allowlist, changing snapshot schema, adding dependencies, weakening CI/pre-commit coverage, or reducing existing Settings editability.
- Treating existing safe Git workflow settings as display-only inside this sync ID; that may be an existing-feature tradeoff and requires a separate approved contract.
- Accepting apply-response metadata as final when the refetched snapshot disagrees.

Recovery notes:

- If writer apply fails, stay in the existing dialog error path and do not show saved progress.
- If snapshot refetch fails or times out after writer success, show saved-but-not-confirmed feedback and keep polling or manual refresh paths available.
- If a valid snapshot is stale or mismatched, do not mark reflection complete.
- If long translated row-action labels overflow, fix responsive layout or wrapping instead of adding language-specific branches.

## Implemented Dashboard Control Center Settings Consistency Gate Handoff

SYNC-ID: dashboard_control_center_settings_consistency_gate
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,tools/lib/git_workflow_policy.sh,tools/git-workflow,tools/dashboard-settings,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_git_workflow_policy.sh,tools/test_dashboard_i18n.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh
TESTS: tools/test_git_workflow_policy.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_i18n.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh

Restart context:

- This sync ID now has runtime implementation in the owner layer, Settings writer, Dashboard data producer, browser validator, Settings UI, fixtures, and related tests.
- The fixed issue was that Settings could expose combinations that were individually valid but collectively inconsistent, such as disallowing normal branches and disallowing direct work on `main`.
- The fix is a reusable owner-layer consistency gate, not React-only validation or one-off text warnings.
- `tools/lib/git_workflow_policy.sh` owns candidate full-state validation. `tools/git-workflow` and `tools/dashboard-settings` call the same validation path.
- `tools/git-workflow allow` rejects runtime action permission while the persisted Git workflow settings have blocking consistency rows, so existing inconsistent files cannot authorize an unsafe or misleading action.
- `tools/dashboard-data` emits effective status, reason, and next action for Dashboard rows so the browser renders producer-owned policy.
- `not_applicable` is now in the schema, producer, and browser status vocabulary before producer output uses it.
- Blocked or rejected Settings policy results return structured JSON with `applied:false` and reason metadata; ordinary policy feedback does not rely on non-zero Vite middleware failures.
- The current Settings writer, Vite same-origin JSON endpoints, full-locale UI behavior, no-reload apply feedback, and centered progress window remain baseline behavior.

Implementation notes:

- Hard reject candidate states that leave no approved write path, especially `branch_allowed=false` with `main_direct_work_allowed=false`.
- Do not count `worktree_allowed=true` as an independent write path unless a later approved policy defines detached or external worktree semantics.
- Treat branch-dependent automation with `branch_allowed=false` as blocked unless an approved policy explicitly models existing external PR monitoring.
- Preserve `automation_level` compatibility and existing detailed-action behavior until the developer approves a stricter maximum model.
- Do not silently change runtime precedence for `merge_execution=manual` versus `developer_auto_merge_allowed=true`; preserve current precedence unless approved, but Dashboard display must be qualified non-ready rather than unqualified ready automation.
- Treat `pr_creation=auto`, `pr_ci_monitoring=auto`, and `merge_execution=after_approval` with `branch_allowed=false` as write-time errors in this sync ID. If a file is already persisted that way, display it as blocked and allow recovery changes.
- Let users recover from invalid persisted settings by accepting candidate writes that produce a valid full state.
- Keep product repository, lesson repository improvement, external integration, and learner approval statuses context-aware so they do not show misleading ready states.

Verification expectations:

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

Run `npm run dashboard:build` after React, Vite, or CSS changes.
Run `./tools/check_lesson_structure.sh` and `./tools/check_lesson14_structure.sh` as related structure checks when promoting the implemented state.
Run `tools/test_lesson_repository.sh` only when changed-file policy, final-gate scope, or developer approval requires it.
Use multiple read-only xhigh sub-agent reviews before and after runtime implementation changes when promoting this sync ID.

Current document-sync verification state:

- Implemented sync content is recorded across requirements, specification, implementation plan, task tracker, handoff, and `AS_BUILT_SYNC_CONTRACT.tsv`.
- Document and structure checks passed: `tools/check_as_built_sync_contract.sh`, `tools/check_as_built_docs.sh`, `tools/check_test_plan_coverage.sh`, `tools/check_workflow_pair_sync.sh`, `tools/check_lesson_structure.sh`, `tools/check_lesson14_structure.sh`, and `tools/check_ci_workflow_structure.sh`.
- Related non-browser checks passed: `tools/test_git_workflow_policy.sh`, `tools/test_dashboard_settings.sh`, `tools/test_dashboard_schema.sh`, `tools/test_dashboard_data.sh`, and `tools/test_dashboard_i18n.sh`.
- `npm run dashboard:build` passed after React, Vite, i18n, and CSS changes.
- `tools/test_dashboard_control_center.sh` passed after runtime fixes for stale workflow-language labels, representative locale row overflow, and blocked apply-feedback display.
- `tools/test_lesson_repository.sh` passed after runtime and documentation updates.
- Multiple read-only xhigh sub-agent reviews passed after clarifying branch-dependent automation, merge-precedence display, `not_applicable` vocabulary handling, structured `applied:false` policy responses, runtime `allow` gating, schema/i18n/UI corrections, and sync-contract TESTS correction. No unresolved major findings remain.

Stop and ask before:

- Reducing existing Settings editability, changing `automation_level` semantics, defining detached-worktree behavior, changing runtime merge precedence, allowing branch-dependent automation without branches, changing approval receipt security semantics, adding dependencies, adding writers, adding mutation endpoints, weakening CI/pre-commit, external repository mutation, Git/GitHub/CI execution, evidence writing, approval-state mutation, push, merge, cleanup, deletion, OAuth, credentials, or accepting any existing-feature tradeoff.

Recovery notes:

- If validation blocks all paths from an inconsistent current file, add a recovery path and fixture instead of weakening validation.
- If CLI and Dashboard validation disagree, fix the shared owner-layer validator first.
- If Dashboard row status and writer rejection disagree, fix producer/writer reason-code mapping before changing React.
- If layout breaks for long translated status or action labels, fix reusable row constraints and translations rather than adding language-specific UI branches.

## Implemented Product Workflow Git Usage Modes Handoff

SYNC-ID: product_workflow_git_usage_modes
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/MENU_PRODUCT_PROFILE_POLICY.tsv,docs/workflow/PRODUCT_WORKFLOW_GIT_USAGE_POLICY.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,learning/PRODUCT_WORKFLOW_GIT_USAGE_SETTINGS.tsv,learning/context/WORKFLOW_CONTEXT_MAP.tsv,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/lib/product_workflow_git_usage.sh,tools/free-development,tools/product-improvement,tools/external-integration,tools/check_repository_boundary.sh,tools/product-scaffold-check,tools/lib/product_security.sh,tools/product-security,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/dashboard-data,tools/dashboard-settings,tools/lib/dashboard_data.sh,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,vite.config.mjs,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tools/test_product_git_usage_modes.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_product_git_usage_modes.sh,tools/test_product_gate_tools.sh,tools/test_product_scaffold_check.sh,tools/test_product_security.sh,tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_i18n.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh,tools/check_lesson_structure.sh

Restart context:

- This sync ID is implemented. Runtime product workflow Git usage modes have been added under this sync ID.
- The problem was that Free Development, Product Improvement, and External Integration were modeled as always requiring product Git remote sync and CI, which was too strict for small local LPs, prototypes, or one-off static pages.
- The implemented direction adds product workflow Git usage modes while keeping `ci` as the default existing-compatible behavior.
- The implemented modes are `none`, `local`, `remote_sync`, and `ci`.
- `none` means Git, remote sync, and CI are not applicable. It does not waive product workspace, canonical documents, scaffold, product-security, secret scanning, external-integration approval, or local checks.
- Existing Git workflow action settings remain the policy for how Git may be used when a mode requires Git. They are not the setting for whether Git is used.
- Dashboard must receive mode and applicability from producer-owned data. React must not infer this from menu labels or hard-coded strings.
- `.git`-less authoritative evidence storage was not introduced. Non-Git and non-CI evidence is represented as `not_applicable`; any future replacement evidence store, freshness model, or product-head binding still requires developer approval.

Implementation notes:

- The owner-layer policy and helper were implemented before UI changes.
- Preserve strict current behavior when no explicit mode is selected.
- `tools/free-development`, `tools/product-improvement`, and `tools/external-integration` call the shared helper rather than hard-coding Git sync and CI.
- `check_repository_boundary.sh`, `product-scaffold-check`, `product_security.sh`, and `product_repository_authority.sh` were updated together because they contained Git worktree assumptions that could block non-Git product work.
- Do not make product-security pass by skipping checks. Every mode still needs boundary protection, secret scanning, safe output metadata, and integration-specific approval when applicable.
- Do not claim authoritative product Git or CI evidence when the mode marks Git or CI not applicable.
- If `.git`-less authoritative evidence is needed later, define its storage path, freshness semantics, and product-head replacement only after developer approval.
- Dashboard schema, producer output, browser validation, Settings catalog, Settings writer, UI labels, command previews, fixtures, and tests were updated as one contract.

Verification commands for this implemented sync:

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

Current verification state:

- `bash -n` passed for the changed shell tools and test scripts during implementation.
- `tools/test_product_git_usage_modes.sh` passed.
- `tools/test_product_gate_tools.sh` passed.
- `tools/test_product_scaffold_check.sh` passed.
- `tools/test_product_security.sh` passed.
- `tools/test_product_repository_authority.sh` passed.
- `tools/test_dashboard_schema.sh` passed.
- `tools/test_dashboard_data.sh` passed.
- `tools/test_dashboard_settings.sh` passed.
- `tools/test_dashboard_i18n.sh` passed.
- `tools/test_dashboard_control_center.sh` passed.
- `tools/test_lesson_repository.sh` passed as the aggregate repository test for this sync ID.
- Final sync and structure checks passed after the implemented documentation state was recorded.
- `git diff --check` passed after implementation and document updates.
- Sub-agent verification completed with no unresolved major findings after review fixes.

Stop and ask before:

- Designing or accepting `.git`-less authoritative evidence storage, freshness, or product-head replacement.
- Changing default strict Git/CI behavior, STEP 1-7, STEP 1-14, existing CI, existing checks, document routes, repo-local skills, product-security guarantees, or product authority guarantees.
- Adding dependencies, external services, runtime translation, browser mutation routes, writers beyond `tools/dashboard-settings`, evidence writers, dashboard Git/GitHub/CI execution, product repository mutation, push, merge, cleanup, deletion, OAuth, credentials, destructive operations, or any existing-feature tradeoff.

Recovery notes:

- If `ci` mode stops matching current behavior, fix that before continuing with lighter modes.
- If Dashboard and gate behavior disagree, repair the owner-layer helper or producer before changing React.
- If non-Git mode bypasses security or documentation requirements, treat it as a blocker, not an acceptable lightweight path.
- If repeated failures or specification conflict appear, stop after the third repeated failure and request developer direction.

Next Step:

- This implementation step is closed. Continue future product workflow Git usage mode changes through a new synced task or explicit developer direction.

## Implemented Repository Development Workflow Workflow Skill Handoff

SYNC-ID: repository_development_workflow_skill
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/REPOSITORY_DEVELOPMENT_WORKFLOW.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,learning/REPOSITORY_DEVELOPMENT_APPROVALS.tsv,skills/repository-development-workflow/SKILL.md,skills/repository-development-workflow/references/repository-development.md,skills/repository-development-workflow/agents/openai.yaml,tools/lib/repository_development_workflow.sh,tools/repository-development-workflow,tools/check_repository_development_workflow.sh,tools/test_repository_development_workflow.sh,tools/check_agents_skills.sh,tools/test_lesson_repository.sh,tools/check_ci_workflow_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_repository_development_workflow.sh,tools/test_repository_development_workflow.sh

Restart context:

- This is an implemented state for the `repository-development-workflow` repo-local skill and mechanical workflow support.
- The workflow helps agents move from wall discussion to proposal, implementation plan, document sync, implementation, focused verification, release gates, PR/main CI, local/remote sync, and cleanup planning without weakening AGENTS.MD.
- The seven implemented phase ids are `context_triage`, `proposal`, `implementation_plan`, `fast_loop`, `mid_tests`, `release_gate`, and `main_sync_cleanup`.
- The workflow is for this lesson repository's own development. It must not replace `worklog-doc-sync` for product-document synchronization or `lesson-sync-gate` for final lesson/gate closure.
- Implemented artifacts include the workflow TSV, approval TSV, repo-local skill files, shared shell helper, CLI, standalone check, regression test, hook metadata, aggregate test wiring, CI structure wiring, and final-gate coverage wiring.
- Final-gate gap wiring includes `repository_development_workflow_status` so aggregate coverage recognizes `./tools/repository-development-workflow status`.
- The sync contract now lists the implemented runtime artifacts and the standalone check/test as required tests.

Next safe action:

- Use `skills/repository-development-workflow/SKILL.md` and `./tools/repository-development-workflow status|plan|guidance|gate` for future repository development workflow work.
- Treat PR CI, merge, main CI, local/remote sync, and cleanup as release or closure phases. Do not execute them from fast-loop guidance without explicit developer direction.
- If a future change extends the workflow, start from `docs/workflow/REPOSITORY_DEVELOPMENT_WORKFLOW.tsv` and `tools/lib/repository_development_workflow.sh` before changing skill text or hook/CI callers.

Stop and ask before:

- Editing AGENTS.MD, pre-commit, CI, final-gate coverage, branch/worktree deletion, remote deletion, product-repository deletion, push, merge, main CI waiting, local/remote sync, or any destructive operation.
- Weakening existing gates, removing required checks, changing STEP 1-7 or STEP 1-14 behavior, changing repo-local skill ownership, changing document synchronization ownership, or accepting any existing-feature tradeoff.
- Treating fast-loop recommendations as release proof.

Recovery notes:

- If the sync contract fails, first verify that the `SYNC-ID`, `STATUS`, `ARTIFACTS`, and `TESTS` lines match exactly across all five required docs.
- If an implemented artifact or test is listed but missing, restore the file or downgrade only through a new approved sync change; do not leave implemented metadata pointing at absent files.
- If the future workflow suggests cleanup execution, convert it to an approval-bound cleanup plan unless explicit developer approval exists.
- If repeated failures or a specification conflict appear, stop after the third repeated failure and request developer direction.

Current verification state:

- `bash -n tools/lib/repository_development_workflow.sh tools/repository-development-workflow tools/check_repository_development_workflow.sh tools/test_repository_development_workflow.sh tools/check_ci_workflow_structure.sh`: passed.
- `tools/repository-development-workflow list`: passed.
- `tools/repository-development-workflow gate --phase release_gate`: passed and reports policy-valid-only rather than proof.
- `tools/check_repository_development_workflow.sh`: passed.
- `tools/test_repository_development_workflow.sh`: passed.
- `tools/check_agents_skills.sh`: passed.
- `tools/check_test_plan_coverage.sh`: passed.
- `tools/check_ci_workflow_structure.sh`: passed.
- `tools/check_as_built_sync_contract.sh`: passed after implemented metadata was recorded.
- `tools/check_as_built_docs.sh`: passed after implemented metadata was recorded.
- `tools/check_workflow_pair_sync.sh`: passed.
- `tools/check_lesson_structure.sh`: passed.
- `tools/check_lesson14_structure.sh`: passed.
- `tools/test_test_plan.sh`: passed.
- `tools/test_git_hooks.sh`: passed.
- `tools/test_git_hooks_parallel.sh`: passed.
- `tools/test_ci_final_gate.sh`: passed.
- `tools/test_lesson_repository.sh`: passed after the approval-policy and `pre_commit_required` review fixes.
- `tools/git-hooks run --mode full --no-cache`: passed after the final-gate gap coverage fix.
- Read-only sub-agent review completed across implementation, wiring, and document synchronization; follow-up re-review found no unresolved release-blocking findings.

## Repository Development Workflow Runner Handoff

SYNC-ID: repository_development_workflow_runner
STATUS: implemented
ARTIFACTS: .gitignore,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/REPOSITORY_DEVELOPMENT_WORKFLOW.tsv,docs/workflow/REPOSITORY_DEVELOPMENT_RUNNER_POLICY.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,learning/REPOSITORY_DEVELOPMENT_APPROVALS.tsv,skills/repository-development-workflow/SKILL.md,skills/repository-development-workflow/references/repository-development.md,tools/lib/repository_development_workflow.sh,tools/lib/repository_development_runner.sh,tools/repository-development-workflow,tools/check_repository_development_workflow.sh,tools/test_repository_development_workflow.sh,docs/as-built/IMPLEMENTATION_PLAN.md,docs/workflow/TASK_TRACKER.md,docs/workflow/HANDOFF.md
TESTS: tools/check_repository_development_workflow.sh,tools/test_repository_development_workflow.sh,tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_workflow_pair_sync.sh

Restart context:

- This sync ID is implemented for local runner behavior.
- The developer approved runtime implementation for the `repository-development-workflow` skill.
- The runner converts the current policy-backed workflow into an approval-bound controller that can detect phases, plan checks, execute allowed non-destructive checks, record results, decide conservative reuse eligibility, and stop at approval or release gates.
- The existing seven phases remain authoritative: `context_triage`, `proposal`, `implementation_plan`, `fast_loop`, `mid_tests`, `release_gate`, and `main_sync_cleanup`.
- The existing `repository_development_workflow_skill` sync remains implemented and should be extended, not replaced.
- `AGENTS.MD` remains the top-level invariant source, especially no existing-feature tradeoffs, security-first implementation, no hidden destructive operations, and workflow-contract-based test selection.

Next safe action:

- Review the implemented diff, then run any additional medium checks selected by `./tools/repository-development-workflow guidance --phase mid_tests`.
- Do not treat runner records as release proof.
- Keep release, PR CI, merge, main CI, local/remote sync, and cleanup in their explicit approval-bound phases.

Stop and ask before:

- Changing AGENTS.MD, pre-commit, CI, final-gate coverage, GitHub workflow behavior, or release proof requirements.
- Allowing the runner to execute push, PR creation, CI monitoring, merge, main CI waiting, local/remote sync, branch deletion, worktree deletion, remote deletion, product-repository deletion, cleanup execution, arbitrary shell commands, credential handling, dashboard mutation, or any destructive operation.
- Weakening STEP 1-7, STEP 1-14, existing checks, existing document routes, repo-local skills, security gates, or existing release proof.

Verification for this sync:

```bash
./tools/check_repository_development_workflow.sh
./tools/test_repository_development_workflow.sh
./tools/check_test_plan_coverage.sh
./tools/test_test_plan.sh
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_workflow_pair_sync.sh
```

Recovery notes:

- If sync checks fail, first make `SYNC-ID`, `STATUS`, `ARTIFACTS`, and `TESTS` match exactly across the five synchronized documents and the contract row.
- If the runner cannot prove a previous PASS is reusable, run the check instead of reusing stale evidence.
- If release proof can be skipped through runner records, treat that as a blocking safety regression.
