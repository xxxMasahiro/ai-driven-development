# TASK_TRACKER.md

## Current Status

The lesson repository includes mechanical enforcement, flexible lesson entry, Free Development Mode, Team Development and Docker advanced module, dialogue-centered learning, as-built synchronization checks, sub-agent review protocol, menu/dashboard/illustration entry points, 7-day and 14-day lesson language controls, and lesson-side aggregate testing.

The previous implemented change promotes the Git workflow policy into a shared menu-level policy for menu items 1 through 7, including branch permission, `git worktree` permission, direct-main permission, automation level, Git monitoring, and non-destructive cleanup planning.
The previous implemented change added user-configurable Git workflow policy settings and the as-built sync contract that mechanically enforces synchronization across the three design/as-built documents and the two workflow-state documents.
The current implemented Git workflow action settings split Git workflow behavior into detailed settings for commit, push, PR creation, PR CI monitoring, merge execution, developer-responsibility auto-merge, main CI monitoring, and local/remote sync monitoring.
The current implemented Git hooks policy provides faster safe serial pre-commit operation through `full`, `fast`, and `minimal` modes, conservative Git-local caching, and a path-based local full/no-cache recommendation command.
The current implemented resource-budgeted parallel guard provides safe optional parallel execution decisions for Git hooks, Playwright, CI, and aggregate checks through user-configured memory and swap budgets.
The current implemented test and CI safe time optimization first phase adds observe-only Test Plan Manifest behavior, Coverage Guard, Result Attestation, CI-safe Git hooks parallelism, and lightweight fixture-copy optimization while preserving full/no-cache verification.
The current planned learner context foundation prepares source documents under `learning/context/` for the next lesson-content implementation cycle; runtime lesson output has not been changed by that foundation step.
The current planned learner context runtime integration separates learning context from workflow context; Free Development Mode remains a workflow, not a lesson.
The current implemented Security guard backfill adds repository-level security invariants, a policy table, a reusable checker, standalone tests, aggregate-test wiring, Git hooks wiring, CI wiring, and pre-commit wiring.
The current implemented product security workflow gate adds `tools/product-security status|preflight|advise|check|gate` for menu items 4, 5, and 6 while preserving their existing document, repository-boundary, Git sync, CI, and approval gates.
The current implemented CI timing and approved auto-improvement cycle records measured final common aggregate/full-hooks timing, strengthens CI status targeting, provides read-only improvement proposals, and keeps future full/no-cache policy refinement developer-approved.
The current implemented CI aggregate and full-hooks split runs main `CI` lesson aggregate and full/no-cache Git hook verification as separate jobs with a strict final gate; cache policy and full/no-cache semantics are unchanged.
The current implemented dashboard control center data layer provides a read-only JSON source behind an AI-driven development control center.
The current implemented dashboard control center React UI is documented as `dashboard_control_center_react_ui_plan`; it provides a read-only browser control-center scope with maintained entry tooling, standalone/aggregate browser checks, and no UI action execution.
The current implemented dashboard control center information architecture is documented as `dashboard_control_center_information_architecture`; it organizes the browser dashboard into categories, adds `en`/`ja` fixed-label localization, shows snapshot freshness, and keeps command previews isolated under Safety Actions.
The current implemented dashboard control center visual polish is documented as `dashboard_control_center_visual_polish`; it aligns the categorized read-only dashboard more closely with the generated mock while preserving safety and data boundaries.
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
- Added `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv`.
- Added `docs/workflow/RESOURCE_POLICY.tsv`.
- Added `learning/RESOURCE_SETTINGS.tsv`.
- Added `tools/lib/resource_guard.sh`.
- Added `tools/resource-guard status|check|recommend-jobs|monitor`.
- Added `tools/test_resource_guard.sh`.
- Added `learning/GIT_HOOK_SETTINGS.tsv`.
- Added `tools/lib/git_hooks_policy.sh`.
- Added `tools/git-hooks status|mode|cache|run`.
- Added `tools/git-hooks recommend`.
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
- Added Security guard invariants, policy, checker, and tests.
- Added product-security policy, context map, command surface, gates, dashboard/menu visibility, and tests.
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
- The implemented resource-budgeted parallel guard is synchronized in the same five documents as verification-performance safety behavior.
- The planned learner context foundation is synchronized in the same five documents as documentation foundation work for the next implementation plan.
- The planned learner context runtime integration is synchronized in the same five documents as the next runtime implementation plan.
- The implemented Security guard backfill is synchronized in the same five documents as repository-security invariant enforcement.
- The implemented product security workflow gate is synchronized in the same five documents as menu 4/5/6 runtime security gate enforcement.
- The implemented CI timing and approved auto-improvement cycle is synchronized in the same five documents as the evidence-driven CI optimization proposal mechanism.
- The implemented dashboard control center data layer is synchronized in the same five documents as the read-only dashboard data implementation.
- The synchronization passes only when the implemented content is present in all five documents.
- Preserve refactorability, ecosystem fit, reusable design, generality, and the no-existing-feature-tradeoff rule while maintaining the implemented remediation.

## Implemented Resource-Budgeted Parallel Guard Work

Status: implemented.
Runtime resource policy, user settings, command surface, Git hooks integration, Playwright worker integration, CI wiring, and tests are present.

- [x] Add a resource policy source for warning thresholds, fallback stages, and reusable heavy-work profiles.
- [x] Add a user settings source for memory percentage, swap storage percentage, swap GiB upper limit, maximum parallel jobs, mode, and available-memory floor.
- [x] Add a shared resource guard library for memory, swap, disk, heavy-process, and budget calculations.
- [x] Add a `tools/resource-guard` command with status, check, job recommendation, and monitor actions.
- [x] Connect optional resource checks to Git hooks without changing `full`, `fast`, or `minimal` semantics.
- [x] Enforce active-heavy-process fallback, explicit parallel-mode safe-stop, unknown-profile rejection, and safe-stop failure before new heavy verification work.
- [x] Connect Playwright and aggregate checks conservatively, with serial fallback through worker recommendation, fail-closed safe-stop behavior, and CI dashboard checks routed through the shared wrapper.
- [x] Keep CI checks intact while adding resource guard regression coverage and duplicate-run cancellation.
- [x] Add standalone resource-guard tests and wire them into aggregate tests after implementation.
- [x] Move `resource_budget_parallel_guard` to implemented after runtime artifacts and tests exist.

## Implemented Resource Guard Safe Cleanup Work

Status: implemented.
Repo-local safe cleanup is available through `tools/resource-guard cleanup`.
The implementation is additive to the existing resource guard and does not change the meaning of existing resource status, check, job recommendation, monitor, Git hooks, Playwright, CI, or lesson commands.

- [x] Add cleanup defaults and cleanup targets to `docs/workflow/RESOURCE_POLICY.tsv`.
- [x] Add cleanup user settings to `learning/RESOURCE_SETTINGS.tsv`.
- [x] Add reusable cleanup planning, path validation, repo-boundary, symlink rejection, age filter, and safe-delete helpers to `tools/lib/resource_guard.sh`.
- [x] Add `tools/resource-guard cleanup --dry-run`.
- [x] Add `tools/resource-guard cleanup --safe`.
- [x] Add `tools/resource-guard cleanup --safe --older-than <hours|Nh>`.
- [x] Add `tools/resource-guard cleanup --profile <profile|all> --dry-run`.
- [x] Add standalone cleanup regression coverage in `tools/test_resource_cleanup.sh`.
- [x] Wire cleanup regression into `tools/test_lesson_repository.sh`.
- [x] Wire cleanup regression into Git hooks policy and both GitHub Actions workflows.
- [x] Move `resource_guard_safe_cleanup` to implemented after runtime artifacts and tests exist.

## Implemented Resource Guard Summary And Parallel CI Work

Status: implemented.
The developer-approved proposal and implementation plan are recorded in `docs/memory/DEVELOPER_MEMORY.md`.
Runtime implementation is present for summary output, local Git hooks parallel execution, CI job splitting, CI structure checks, and regression wiring.

- [x] Record the proposal and implementation plan in developer memory.
- [x] Synchronize this implemented work into the five as-built/workflow documents.
- [x] Add `tools/resource-guard summary`.
- [x] Add `tools/resource-guard summary --short`.
- [x] Add summary helpers to `tools/lib/resource_guard.sh`.
- [x] Add `tools/test_resource_guard_summary.sh`.
- [x] Add `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv`.
- [x] Add local Git hooks parallel runner support while preserving existing serial fallback behavior.
- [x] Add `tools/test_git_hooks_parallel.sh`.
- [x] Split GitHub Actions workflows into CI-runner-oriented jobs without removing existing checks.
- [x] Add required CI workflow structure checks for split workflow job names, `needs`, and required commands.
- [x] Ensure main CI aggregate/full-hooks jobs install npm dependencies and Playwright dependencies before running aggregate repository tests or full hooks.
- [x] Preserve explicit local/CI separation, including CI-safe local-resource bypass behavior for CI full hooks.
- [x] Wire new tests into aggregate, pre-commit, and CI.
- [x] Update sync contract artifacts, tests, and runtime evidence from planning-only entries to actual runtime entries.
- [x] Move `resource_guard_summary_parallel_ci` to implemented after runtime artifacts and tests pass locally.

## Implemented Security Guard Backfill Work

Status: implemented.
Repository-level security invariants, policy, checker, tests, aggregate wiring, Git hooks wiring, CI wiring, and pre-commit wiring are present.

- [x] Record the final proposal and implementation plan in developer memory.
- [x] Add `safeflow_security_backfill` as an implemented sync contract row using runtime artifacts and runtime evidence.
- [x] Synchronize the implemented work into the five as-built/workflow documents.
- [x] Add additive AGENTS.MD security-invariant wording.
- [x] Add `docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv`.
- [x] Add reusable security-invariant library and checks.
- [x] Add standalone and aggregate regression tests.
- [x] Wire the checks into Git hooks, CI, and pre-commit.
- [x] Move `safeflow_security_backfill` to implemented after runtime artifacts and tests pass.

## Implemented Product Security Workflow Gate Work

Status: implemented.
Product-security policy, workflow-context metadata, command surface, gate integration, tests, aggregate wiring, Git hooks wiring, CI wiring, and pre-commit wiring are present.

- [x] Record the final proposal and implementation plan in developer memory.
- [x] Add `product_security_workflow_gate` as an implemented sync contract row using runtime artifacts and runtime evidence.
- [x] Synchronize the implemented work into the five as-built/workflow documents.
- [x] Add product security policy and workflow-context risk metadata.
- [x] Add a reusable product-security library.
- [x] Add `tools/product-security status|preflight|advise|check|gate`.
- [x] Add fixture-based product security tests.
- [x] Connect product-security checks to Free Development, Product Improvement, and External Integration without replacing existing gates.
- [x] Add External Integration OAuth/API and logging preflight confirmation.
- [x] Add dashboard and menu safety summaries.
- [x] Wire the checks into Git hooks, CI, pre-commit, and aggregate tests.
- [x] Move `product_security_workflow_gate` to implemented after runtime artifacts and tests pass.

## Implemented Test And CI Safe Time Optimization Work

Status: implemented safe first phase.
This runtime implementation preserves full/no-cache completion verification, existing CI guarantees, existing pre-commit behavior, existing Git hooks mode meanings, and all 7-day/14-day lesson checks.

- [x] Record the plan as `test_ci_safe_time_optimization_plan` in the as-built sync contract.
- [x] Synchronize the plan into the three as-built documents and the two workflow-state documents.
- [x] Add Test Plan Manifest support in observe-only mode.
- [x] Add learner-readable reasons for run/force decisions.
- [x] Add Coverage Guard that fails closed on malformed policy rows, unknown Git hook check references, missing dangerous-change patterns, weakened full/CI escalation for required dangerous patterns, force decisions without full escalation, and unsafe changed-only decisions.
- [x] Add Result Attestation for policy hashes, check hashes, repository-state hash, manifest hash, generated run/force decisions, and final observe-only status.
- [x] Add CI-safe full-hooks parallel worker control while preserving `--mode full --no-cache`.
- [x] Add a shared fixture-copy helper that excludes `.git`, `node_modules`, reports, test results, and cache directories.
- [x] Wire the new checks into Git hooks, aggregate tests, CI, pre-commit, and CI workflow structure validation.
- [ ] Add a hook-specific gap-only final gate after mechanical coverage proof exists and developer approval is granted.
- [ ] Add safe as-built single-pass internal options while keeping strict standalone defaults.
- [ ] Remove duplicate Playwright execution within a single verification path without removing Playwright coverage.
- [ ] Keep changed-only behavior observe-only until Coverage Guard and Result Attestation have proven safe against full CI and developer approval is granted.

## Implemented Test And CI Final Gate Optimization Work

Status: implemented; local verification passed, and remote `CI` / `Lesson14 CI` remain the external completion gates for the pushed commit.
This implementation completes the test and CI runtime optimization work.
It targets the current `aggregate-and-full-hooks` bottleneck while preserving existing CI, pre-commit, full/no-cache safety, 7-day lesson behavior, 14-day lesson behavior, security checks, product-security checks, and as-built synchronization.

- [x] Record the next implementation plan as `test_ci_final_gate_optimization_plan` in the as-built sync contract.
- [x] Synchronize the plan into the three as-built documents and the two workflow-state documents.
- [x] Add same-run evidence primitives with commit SHA, workflow/job identity, command ID, policy hash, check catalog hash, input hashes, repository-state hash, and timestamp.
- [x] Add as-built and sync evidence reuse for identical same-run inputs while keeping strict standalone commands unchanged.
- [x] Add Playwright evidence generation and reuse so final aggregation does not rerun Playwright when same-run evidence is valid.
- [x] Add a hook-specific gap-only final gate so full hooks do not rerun `tools/test_lesson_repository.sh` after equivalent hook coverage has already run.
- [x] Add `docs/workflow/FINAL_GATE_COVERAGE.tsv` so aggregate requirements must be covered by hook evidence or explicit final-gap commands.
- [x] Keep `test_lesson_start_position` and `test_lesson14` covered by dedicated full/fast hook rows before the final gate.
- [x] Split `Lesson14 CI` to use a Lesson14-specific final gate instead of duplicating the common aggregate/full-hooks final gate.
- [x] Preserve the legacy `Lesson14 CI` `playwright-tests` and `aggregate-and-full-hooks` job contexts as lightweight compatibility gates.
- [x] Add a mechanical final-gate test proving missing or stale same-run evidence fails closed and valid evidence runs only final-gap commands.
- [x] Reduce duplicate common final-gate work between `CI` and `Lesson14 CI` internally while preserving required workflow names.
- [x] Extend full/no-cache recommendation paths for final-gate coverage, final-gate commands, CI evidence, and as-built evidence implementation changes.
- [x] Add GitHub Actions npm dependency caching.
- [x] Add safe Playwright browser dependency caching where supported by hosted runners.
- [x] Keep verification-result cache limited to same-run evidence only; do not restore verification results across commits, branches, workflow runs, or repositories.
- [x] Add cleanup coverage for same-run evidence, Playwright reports, test results, temporary fixtures, and repo-local caches.
- [x] Extend `tools/check_ci_workflow_structure.sh` to enforce the optimized final-gate shape.
- [x] Keep new checks standalone and callable from `tools/test_lesson_repository.sh`.
- [x] Pass local aggregate tests, full/no-cache hooks, pre-commit, and sub-agent verification.
- [x] Keep remote `CI` / `Lesson14 CI` as required external completion gates before final reporting.

## Implemented Test And CI Full Pipeline Acceleration Work

Status: implemented.
This work completes the next test/CI acceleration cycle after final-gate evidence reuse.
Runtime behavior is implemented through CI workflow wiring, policy rows, focused checks, and aggregate validation.

- [x] Record the plan as `test_ci_full_pipeline_acceleration_plan` in the as-built sync contract.
- [x] Synchronize the plan into the three as-built documents and the two workflow-state documents.
- [x] Guard against GitHub Actions deprecation regressions without changing required check meanings.
- [x] Optimize Playwright setup through cache-aware dependency/browser setup and fallback installs.
- [x] Expand full-hook parallelization only for mechanically proven independent checks.
- [x] Keep same-run evidence reuse scoped to current-run evidence without adding persistent verification-result cache.
- [x] Reduce duplicated policy-regression work between `CI` and `Lesson14 CI` while preserving required contexts.
- [x] Preserve optimized `aggregate-and-full-hooks` final-gate guarantees while avoiding duplicated heavy Lesson14 compatibility work.
- [x] Keep changed-only CI observe-only until proof and developer approval allow any authoritative behavior.
- [x] Add `tools/test_ci_pipeline_acceleration.sh` and keep it standalone plus aggregate-callable.
- [x] Add `tools/ci-playwright-setup` for shared CI Playwright setup behavior.
- [x] Wire the focused check into Git hook policy, test-plan manifest coverage, workflow structure checks, and lesson repository aggregate validation.
- [x] Keep as-built sync-contract compatibility checks fast with process-local wiring lookup caching only.
- [x] Pass local verification, remote `CI`, and remote `Lesson14 CI` after implementation.

## CI Timing And Approved Auto-Improvement Work

Status: implemented.
This cycle adds measured final common aggregate/full-hooks timing and proposal-only recommendations before any full/no-cache behavior changes.
It preserves the current final-gate behavior and leaves generated improvements approval-gated.

- [x] Synchronize the plan into the three as-built documents and the two workflow-state documents.
- [x] Add machine-readable timing report support for final common aggregate/full-hooks checks through `tools/ci-timing`.
- [x] Store timing reports as CI artifacts without secrets or raw environment data.
- [x] Strengthen `tools/check_ci_status.sh` so required workflow identity, current commit SHA when available, run state, job state, and conclusion are not confused across `CI` and `Lesson14 CI`.
- [x] Add read-only CI improvement proposal generation from measured evidence.
- [x] Report slow checks, same-run evidence reuse candidates, and safe parallelization candidates with reason, affected files, required verification, and developer approval requirement.
- [x] Keep same-run hash evidence reuse recommendations gated by command identity, input hashes, policy hashes, repository-state hash, workflow/run identity, and success status.
- [x] Add `test_ci_timing` as a standalone and aggregate-callable regression test.
- [x] Keep conditional `full no-cache` scope reduction as a later approval-gated step.
- [x] Require developer approval before implementing any generated improvement candidate or changing final-gate/full-no-cache behavior.

SYNC-ID: ci_timing_auto_improvement_plan
STATUS: implemented
ARTIFACTS: docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/check_ci_status.sh,tools/check_ci_workflow_structure.sh,tools/lib/ci_timing.sh,tools/ci-timing,tools/test_ci_timing.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_evidence.sh,tools/test_ci_final_gate.sh,tools/test_git_hooks_parallel.sh,tools/test_lesson_repository.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_ci_workflow_structure.sh,tools/test_ci_timing.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_evidence.sh,tools/test_ci_final_gate.sh,tools/test_git_hooks_parallel.sh,tools/check_as_built_sync_contract.sh

## CI Aggregate And Full-Hooks Split Work

Status: implemented; local verification, sub-agent review, commit, push, required remote `CI` and `Lesson14 CI`, and local/remote sync passed.
This cycle implements only the approved first timing-based acceleration candidate: split the main `CI` final common verification job into parallel lesson aggregate and full Git hook jobs with a strict final gate.
Cache policy changes are out of scope for this cycle.

- [x] Confirm scope: no persistent verification-result cache, no conditional full/no-cache skipping, no changed-only authoritative CI, no Git hook group matrix split, and no flaky quarantine.
- [x] Preserve existing Step 1-7, Step 1-14, applied lesson, menu, dashboard, Git workflow, Git hooks, Security guard, product-security, docs-tour, as-built sync, pre-commit, local full/no-cache, and remote CI behavior.
- [x] Add `ci_aggregate_full_hooks_split` to the as-built sync contract as `implemented`.
- [x] Split main `CI` into `lesson-aggregate`, `git-hooks-full-no-cache`, and `final-gate`.
- [x] Keep `Lesson14 CI` compatibility contexts unchanged.
- [x] Keep `tools/test_lesson_repository.sh --use-evidence --write-evidence` and `tools/git-hooks run --mode full --no-cache --jobs 4` as the authoritative heavy checks.
- [x] Require `final-gate` to always start, validate split prerequisite results, consume same-run Git hook evidence, and fail closed when evidence is missing or mismatched.
- [x] Avoid timing artifact filename collisions by writing split timing reports to distinct files.
- [x] Prevent split-job `CI_TIMING_REPORT` paths from leaking into nested timing self-tests.
- [x] Keep same-run evidence filenames safe for GitHub artifact upload while preserving original evidence ids in metadata.
- [x] Use a stable Lesson14 compatibility marker instead of a free-form prose dependency.
- [x] Update `tools/check_ci_workflow_structure.sh` for the split job graph, evidence handoff, and timing artifact merge.
- [x] Update `tools/test_ci_pipeline_acceleration.sh` so the split remains standalone and aggregate-callable.
- [x] Run synchronization, structure, focused CI, aggregate, full/no-cache, and pre-commit verification after artifact-safety fixes.
- [x] Complete sub-agent review and resolve findings after artifact-safety fixes.
- [x] Commit, push, confirm required remote `CI` and `Lesson14 CI`, and verify local/remote sync.

SYNC-ID: ci_aggregate_full_hooks_split
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,tools/check_ci_workflow_structure.sh,tools/test_ci_pipeline_acceleration.sh,tools/check_as_built_sync_contract.sh,tools/ci-timing,tools/test_ci_timing.sh,tools/lib/ci_evidence.sh,tools/test_ci_evidence.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_ci_workflow_structure.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_timing.sh,tools/test_ci_evidence.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

## Implemented Dashboard Control Center Data Layer Work

Status: implemented.
The runtime implementation provides a read-only data layer before any React/Vite or browser UI work.
The implementation keeps the existing `tools/dashboard` CLI as a human-readable compatibility surface and adds a stable JSON source for an AI-driven development control center.
Future React/Vite mechanics must remain hidden behind the dashboard control-center surface so ordinary users do not need to see Vite commands, dev-server URLs, package scripts, or frontend internals.
The intended future user path is one action: open the dashboard/control center through the provided entry point while maintained tooling handles setup, Vite startup, URL selection, JSON loading, and checks.
The intended future UI is dual-audience: non-engineers should see lesson content/progress/management clearly, and intermediate or senior engineers should see practical workflow content/progress/management, gate, evidence, blocker, approval, and next-action state without losing operational detail.
The dashboard must preserve the repository's two first-class surfaces, lessons and workflows, as separate but coordinated control-panel areas.

- [x] Add `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv` as the implemented source for field paths, source groups, state vocabulary, and safety requirements.
- [x] Add `tools/test_dashboard_schema.sh` as a standalone and aggregate-callable schema drift guard.
- [x] Add reusable dashboard-data helpers under `tools/lib/`.
- [x] Add `tools/dashboard-data` as a read-only JSON producer.
- [x] Add concise lesson/workflow guidance items to the read-only dashboard summary contract.
- [x] Represent all-steps-completed lesson state as `passed` instead of `unknown`.
- [x] Add `tools/test_dashboard_data.sh` as a standalone-callable and aggregate-callable focused test.
- [x] Wire the focused test into aggregate validation, Git hooks, pre-commit, CI, and the sync contract after runtime artifacts exist.
- [x] Add `dashboard_control_center_data_layer` to the as-built sync contract as `implemented`.
- [x] Synchronize the implemented work across the three as-built documents and the two workflow-state documents.
- [ ] Add a React/Vite read-only UI only after the JSON schema and tests are stable and approved.
- [ ] When the React/Vite UI is approved, expose it through the dashboard control center rather than through Vite-specific learner-facing workflow.
- [ ] Keep the future non-engineer workflow to a single dashboard/control-center entry action.
- [ ] Keep workflow status practical for intermediate and senior engineers; do not collapse gates, evidence, blockers, approvals, and next operational actions into vague learner-only labels.
- [ ] Keep lesson status and workflow status visually and structurally distinct in future control-panel navigation and grouping.

Implemented constraints:

- Do not parse `tools/dashboard` prose in a browser.
- Do not make the dashboard a new source of truth.
- Do not expose Vite startup, dev-server URLs, package scripts, or frontend internals as the ordinary dashboard workflow.
- Do not require ordinary users to run multiple setup, server, URL, data, or verification commands to access the control center.
- Do not make workflow management so simplified that engineers lose gate, evidence, blocker, approval, or next-action detail needed for real work.
- Do not hard-code UI-only hints; keep concise guidance available through the dashboard data contract.
- Do not merge lesson progress and workflow progress into an ambiguous single status surface.
- Do not run push, PR creation, merge, cleanup, deletion, OAuth/API, external integration, or other dangerous actions from the initial dashboard.
- Do not mix `policy ready`, `settings ready`, `gate passed`, `approval required`, `optional`, `cached`, or `unknown` state.
- Do not add fixed product-stack branches or current-wording-only checks.

SYNC-ID: dashboard_control_center_data_layer
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,tools/check_ci_workflow_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

## Implemented Dashboard Control Center React UI Work

Status: implemented.
This work implements the dashboard/control-center React UI after the planned sync and developer approval for React/Vite dependencies, package scripts, runtime files, maintained entry tooling, and browser test wiring.
It is additive and does not replace `tools/dashboard`, parse `tools/dashboard` prose, move owner-layer checks into React, make frontend state authoritative, or execute commands from the UI.

- [x] Organize the implementation proposal around purpose, problems, scope, non-scope, existing-feature impact, document updates, tests, and risks.
- [x] Define the implementation plan around change targets, order, document synchronization, verification, recovery, and developer approval gates.
- [x] Keep `dashboard_control_center_data_layer` as the implemented JSON source and maintain a separate sync ID for the React UI phase.
- [x] Require one ordinary user entry action for the future control center, with Vite mechanics hidden by maintained tooling.
- [x] Require lesson and workflow surfaces to remain separate and practical for both non-engineer users and engineers.
- [x] Keep the initial future UI read-only and command-preview-only.
- [x] Extend the dashboard JSON contract before rendering lesson points, warnings, or next actions as structured fields.
- [x] Obtain developer approval before adding React/Vite dependencies, package scripts, dev-server wrappers, browser runtime files, or browser test wiring.
- [x] Implement the UI after planned sync and local checks, with sub-agent review findings resolved before final PASS.
- [x] Add standalone-callable and aggregate-callable UI tests after runtime artifacts exist.
- [ ] Keep future action execution, live authoritative network/GitHub status, and existing `tools/dashboard` semantic changes behind separate developer approval.

SYNC-ID: dashboard_control_center_react_ui_plan
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/dashboard-data,package.json,package-lock.json,vite.config.mjs,dashboard-control-center/index.html,dashboard-control-center/src/main.jsx,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/styles.css,tools/dashboard,tools/dashboard-control-center,tools/test_dashboard_control_center.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_lesson_playwright.sh,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,tools/check_ci_workflow_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_lesson_playwright.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_ci_workflow_structure.sh

## Implemented Dashboard Control Center Information Architecture Work

Status: implemented.
This work implements the wall-bounced dashboard UI direction as a categorized read-only control-center improvement.
It follows the generated mock's information architecture while preserving the dashboard JSON data source, CLI dashboard, existing lessons, checks, CI, pre-commit, and no-UI-execution boundary.

- [x] Organize the implementation proposal around purpose, solved problems, target scope, non-scope, existing-feature impact, required document updates, required tests, and risks.
- [x] Present and implement the plan around changed files, implementation order, document synchronization, verification, failure recovery, and approval boundaries.
- [x] Add category navigation for Overview, Lessons, Development Workflow, Maintenance Sync, and Safety Actions.
- [x] Make Overview the default first screen with snapshot status, generated time, relative age, read-only state, blockers, next safe action, and category health.
- [x] Keep command previews out of Overview and show them only under Safety Actions as preview-only, non-executable data.
- [x] Add fixed-label localization for `en` and `ja` using device language with English fallback.
- [x] Keep commands, file paths, gate IDs, source names, and dashboard JSON prose unmodified by browser-side translation.
- [x] Preserve secret-like redaction, absolute-path normalization, no-button command execution, and mobile layout constraints.
- [x] Extend Playwright coverage for category navigation, localization, Safety Actions isolation, redaction, and responsive layout.
- [ ] Keep automatic updates, UI command execution, live authoritative CI/Git status, and broad localization for separately approved future phases.

SYNC-ID: dashboard_control_center_information_architecture
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,vite.config.mjs,dashboard-control-center/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Implemented Dashboard Control Center Visual Polish Work

Status: implemented.
This work brings the categorized dashboard closer to `dashboard-control-center/mock-categorized-dashboard.png` as a visual polish layer only.
It does not change command execution, live status authority, dashboard data ownership, existing CLI dashboard behavior, or existing lesson/check/CI behavior.

- [x] Organize the implementation proposal around purpose, problems, scope, non-scope, existing-feature impact, document updates, tests, and risks.
- [x] Define the implementation plan around file targets, implementation order, document synchronization, verification, recovery, and approval gates.
- [x] Keep visual polish separate from `dashboard_control_center_data_layer`, `dashboard_control_center_react_ui_plan`, and `dashboard_control_center_information_architecture`.
- [x] Make the top snapshot status closer to the mock's segmented operational strip.
- [x] Move desktop Overview health cards toward a compact 2x2 layout.
- [x] Add Explore Pages-style category shortcuts without creating command execution affordances.
- [x] Add sidebar read-only and last-updated context.
- [x] Preserve `en`/`ja` fixed-label behavior and data-text non-translation.
- [x] Extend Playwright checks for visual structure without pixel-perfect screenshot matching.
- [ ] Keep automatic refresh, live CI/Git authority, UI-triggered checks, command execution, new dependencies, and broad localization for later separately approved phases.

SYNC-ID: dashboard_control_center_visual_polish
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

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

## Planned Learner Context Runtime Integration Synchronization

The next planned implementation connects learner context to runtime output while preserving the distinction between lessons and workflows.

- Learning context targets are 7-day lesson, 14-day lesson, and applied lesson.
- Workflow context targets are Free Development Mode, Product Improvement, External Integration, and lesson repository maintenance.
- Free Development Mode remains a workflow that applies the learned AI-driven development process to user-selected products.
- Planned runtime artifacts include `tools/lib/lesson_context.sh`, `tools/lesson-context`, `learning/context/WORKFLOW_CONTEXT_MAP.tsv`, and `tools/test_lesson_context.sh`.
- Planned integration points include `tools/lesson`, `tools/lesson14`, `tools/team-development`, `tools/free-development`, `tools/product-improvement`, `tools/external-integration`, `tools/menu`, and `tools/dashboard`.
- Planned tests must run standalone and through aggregate checks, CI, and pre-commit.
- Current work is synchronization only; runtime output is not yet changed.

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
- Store the local full/no-cache recommendation path policy in `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv`.
- Provide a reusable command surface for hook status, mode selection, cache clearing, normal run, no-cache run, and explicit mode run.
- Provide a reusable recommendation surface so local full/no-cache is recommended for Git hooks, CI, checks, tests, or as-built synchronization changes, while ordinary local work can stay on the selected mode such as `minimal`.
- Connect the implementation to existing settings files, `tools/lib` helpers, aggregate tests, CI, pre-commit, and repo-local skills.
- Preserve existing wiring enforcement by teaching the existing checks and status output to recognize runner-based pre-commit dispatch.
- Keep CI and completion verification on full or no-cache execution.
- Add `tools/test_git_hooks.sh` for standalone policy/cache validation, invalid persisted settings, malformed check rows, invalid or empty mode tokens, invalidation, no-cache behavior, minimal-mode coverage, failing-check cache refusal, and safe cache clearing.
- Extend `tools/test_git_hooks.sh` for local verification recommendation behavior.
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
Current local pre-commit mode remains selectable through `learning/GIT_HOOK_SETTINGS.tsv`; CI and final verification remain full/no-cache.
The implemented verification sequence includes `./tools/check_as_built_sync_contract.sh`, `./tools/as-built-sync status`, `./tools/test_as_built_sync_contract.sh`, `./tools/test_git_workflow_policy.sh`, `./tools/test_git_hooks.sh`, `./tools/git-hooks run --mode full --no-cache`, and `.githooks/pre-commit`.
Real product operations testing remains available through `tools/test_production_operations.sh` when an external product repository is intentionally recreated.

## Remaining Work

- Implemented sync ID `lesson_display_label_policy` for the STEP display-label cleanup.
  The issue is not a global text replacement: learner-facing labels, `Step N/14` sync-gate keys, internal compatibility names, and historical records must be separated before implementation.
  Added `docs/workflow/LESSON_DISPLAY_LABELS.tsv` and `tools/lib/lesson_display_labels.sh` so menu, dashboard, roadmap, lesson14 reset/runtime, learning-record, and helpdesk output use shared STEP display labels.
  Updated learner-facing menu, dashboard, roadmap, lesson14 reset/runtime output, learn/helpdesk record labels, README, AGENTS routing text, index files, guides, prompts, playbooks, and scenario text while preserving `Step N/14` sync gates, internal aliases, and historical learning records.
  Expanded `tools/check_learner_display.sh` and `tools/test_menu_prerequisites.sh` so active learner-facing old duration labels fail while internal compatibility names remain valid.

SYNC-ID: lesson_display_label_policy
STATUS: implemented
ARTIFACTS: docs/workflow/LESSON_DISPLAY_LABELS.tsv,tools/lib/lesson_display_labels.sh,tools/lib/lesson_common.sh,tools/lib/lesson_runtime.sh,tools/menu,tools/dashboard,tools/learn,tools/helpdesk,tools/lesson14,tools/roadmap,tools/docs-tour,README.md,AGENTS.MD,index.md,index-14-days.md,ai-driven-task-tracker-scenario.md,guides/LESSON_14_DAYS.md,learning/ROADMAP.md,lesson/LESSON_FLOW_14_DAYS.tsv,prompts/PROMPTS.md,prompts/PROMPTS_14_DAYS.md,playbooks/AGENT_PLAYBOOK.md,playbooks/AGENT_PLAYBOOK_14_DAYS.md,tools/check_learner_display.sh,tools/test_menu_prerequisites.sh,tools/check_lesson14_sync.sh,tools/check_agents_skills.sh
TESTS: tools/check_learner_display.sh,tools/test_menu_prerequisites.sh,tools/check_lesson14_sync.sh,tools/check_agents_skills.sh,tools/test_lesson14.sh

- For `test_ci_final_gate_optimization_plan`, commit and push only after local checks pass; final reporting remains gated on remote `CI` and `Lesson14 CI` for the pushed commit.
- For future test/CI acceleration work after `test_ci_full_pipeline_acceleration_plan`, start from a clean Git state, preserve required workflow names, and keep new plans non-authoritative until runtime changes and tests are complete.
- Translate remaining learner-facing Markdown files to English using the audit output from `tools/list_non_english_docs.sh`.
