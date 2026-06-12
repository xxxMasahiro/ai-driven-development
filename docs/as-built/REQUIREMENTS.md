# REQUIREMENTS.md

## Purpose

`ai-driven-development-lesson` teaches AI-driven development as a practical workflow.
The repository must help learners move from structured lessons into real product development without losing the core habits: dialogue, explicit requirements, specifications, implementation planning, task tracking, handoff, Git sync, tests, CI, review, and documentation.

## Required Capabilities

- Preserve the existing 7-day lesson.
- Preserve the existing 14-day lesson.
- Prevent accidental lesson progression without learner approval.
- Let learners choose explanation depth through learning modes A/B/C in both the 7-day and 14-day lessons.
- Allow the learning mode to be switched during either lesson.
- Let learners choose workflow display language and product development language in both the 7-day and 14-day lessons.
- Support common language choices for both language settings: `ja`, `en`, `ko`, `zh-CN`, `zh-TW`, `es`, `pt-BR`, `fr`, `de`, `id`, `vi`, `th`, `hi`, and `ar`.
- Allow learners to start from any lesson topic intentionally, without weakening normal ordered progression.
- Teach agent dialogue and goal-oriented prompt refinement as a core skill.
- Teach sub-agent use as role-based viewpoints that are orchestrated toward a goal.
- Provide Free Development Mode after structured lessons.
- Let learners choose any product stack in Free Development Mode, including languages, frameworks, databases, payment systems, hosting, testing tools, APIs, and integrations.
- Provide an advanced Team Development and Docker module.
- Teach Docker from basics to practical container development when the learner chooses it.
- Show that AI agents can make setup, configuration, debugging, and documentation easier.
- Keep all additions compatible with existing lesson checks and flows.
- Implement additions with refactorability, ecosystem fit, reusability, and generality in mind.
- Provide lesson-repository testing that does not require an external product repository.
- Keep the external product repository boundary explicit for real production operations tests.
- Keep as-built documents synchronized with the implemented lesson behavior.
- Provide a repeatable sub-agent review protocol for documentation, implementation, and learning-experience consistency.
- Provide Docker learning paths that work whether Docker is installed or not.
- Provide a document-language audit helper so remaining non-English Markdown can be found and translated without changing unrelated behavior.
- Provide a learner-facing menu command that groups learning, building/extending, and lesson-maintenance actions by intent.
- Provide a CLI dashboard for lesson status, development status, developer-memory themes, and illustration review availability.
- Provide an illustration request and review-material structure for learner-requested educational PNG illustrations.
- Support Role-Based Document Organization for role-specific Markdown files so design/as-built, workflow-state, and memory documents remain easy to find.
- Keep As-Built Synchronization explicit across the requirements, specification, implementation plan, task tracker, and handoff documents.
- Provide a resource-budgeted parallel execution guard for Git hooks, Playwright, CI, and aggregate checks without weakening existing serial verification paths.

## Implemented Remediation Requirements From Developer-Memory Audit

The 2026-06-02 developer-memory audit requirements are implemented additively.
The repository must keep the following remediation behavior active without trading away existing behavior or changing unrelated existing content.

- Organize lesson-side Markdown documents by role while keeping `AGENTS.MD` at the repository root.
- Provide a shared document-path layer so tools, checks, prompts, skills, and dashboard code do not hard-code final document locations.
- Move design/as-built documents, workflow-state documents, and memory/decision documents into separate directories through a safe migration.
- Remove final root-level copies of role-specific documents after references and checks are updated.
- Replace learner-facing `Day N` labels with `Step N` labels where practical.
- Hide internal step IDs from ordinary learner-facing output while preserving them for state files, command arguments, and diagnostics.
- Implement separate settings for workflow display language and product development language for both structured lesson versions.
- Preserve `zh` as a backward-compatible alias for `zh-CN`.
- Show learning-mode display names consistently while preserving A/B/C as internal IDs.
- Strengthen approval gates so start/pass actions require matching start/pass approvals.
- Make passage prompts invite questions and explain copy-paste command blocks in learner-friendly wording.
- Enforce `docs/workflow/TASK_TRACKER.md` and `docs/workflow/HANDOFF.md` as a synchronized pair for workflow state and restart context.
- Strengthen as-built document synchronization beyond shallow topic checks.
- Expand the CLI dashboard to show current step, progress, 7-day and 14-day language settings, learning-mode labels, next approval, sync-gate status, workflow-pair status, real CI status when available, developer-memory items, and illustration availability.
- Complete illustration request, metadata, generated-asset registration, and review-page support.
- Add an external-integration CLI path that can follow Free Development Mode or start from an existing product repository.
- Introduce required lesson-repository Playwright checks for dashboard and illustration-review quality after dependencies are installed.
- Wire the strengthened checks, product-gate tests, Playwright checks, and aggregate tests into CI and pre-commit without removing existing checks.
- Add failure-path tests for Free Development and Team Development gates.

## Implemented Menu Prerequisite Requirements

Menu prerequisite control is implemented additively and does not trade away any existing 7-day lesson, 14-day lesson, Free Development Mode, Team Development/Docker module, external-integration path, dashboard, checks, or repository-boundary behavior.

- The learner-facing menu item is named `3. 応用レッスン`.
- Keep the advanced/team-development/Docker behavior available under the renamed applied-learning menu item.
- Require the same pre-start settings for menu items 1 through 6:
  - learning mode,
  - workflow display language,
  - product development language,
  - relevant repository context and boundary confirmation,
  - learner approval before starting.
- Reuse the 7-day and 14-day language and learning-mode settings where they already exist.
- For applied-learning, Free Development Mode, product improvement, and external integration, inherit the most recently configured structured-lesson settings when available; otherwise require the learner to select them before start or gate passage.
- Keep product development language mandatory for any product-side work, including Free Development Mode, product improvement, and external integration.
- Use shared prerequisite logic rather than duplicating menu-specific shell branches.
- Preserve `status` commands as non-blocking discovery commands; enforce prerequisites through start, gate, or explicit menu-check commands.
- Provide a mechanically checkable entry for `5. 成果物を改善` through `tools/product-improvement status|start|gate`.
- Expand dashboard readiness output so menu items 1 through 6 show whether learning mode, workflow display language, product development language, repository context, and approval are ready.
- Keep requirements, specification, implementation plan, task tracker, handoff, developer memory, README/menu guidance, and relevant checks synchronized with this runtime behavior.
- Add tests that positively confirm the renamed menu label `3. 応用レッスン` appears.
- Add tests that fail if the old menu label returns, if menu items 1 through 6 can start without required settings, if missing-prerequisite failure paths are not enforced, or if existing 7-day/14-day behavior regresses.

## Implemented Documentation Map Requirements

The lesson repository explains its many rule, routing, skill, design, workflow, and memory documents in language that non-engineer learners can understand.
This implemented work is additive and does not trade away any existing 7-day lesson, 14-day lesson, menu, dashboard, checks, document synchronization, skills, memory workflow, or repository-boundary behavior.

- Provide a learner-facing documentation map guide at `guides/DOCUMENT_MAP.md`.
- Explain `AGENTS.MD` as the lesson repository's agent rulebook, including invariant rules, document root, routing table, and repo-local skills.
- Clearly distinguish lesson-side `AGENTS.MD` from product-side `AGENT.md`.
- Explain `docs/as-built/` as the design/as-built area for requirements, specification, and implementation plan.
- Explain `docs/workflow/` as the work-state area for task tracking and handoff.
- Explain Git hook policy documents as workflow controls:
  - `docs/workflow/GIT_HOOKS_POLICY.tsv`,
  - `docs/workflow/GIT_HOOK_CHECKS.tsv`,
  - `learning/GIT_HOOK_SETTINGS.tsv`.
- Explain `docs/memory/` as the memory/decision area, currently including `docs/memory/DEVELOPER_MEMORY.md`.
- Explain failure memory as product-side `FAILURE_MEMORY.md` or failure-recovery records where the lesson uses them, without falsely claiming that a lesson-side `docs/memory/FAILURE_MEMORY.md` file exists.
- Explain `skills/*/SKILL.md` as reusable agent procedures, not learner homework.
- Provide a CLI tour command at `tools/docs-tour`, with sections for status, rules, design, workflow, memory, skills, and all documents.
- Make the tour adapt to learning modes A/B/C so detailed learners get context, moderate learners get concise explanations, and workflow-only learners get file names and purposes.
- Provide `./tools/dashboard docs` and include the docs view in `./tools/dashboard all`.
- Show document categories, each document's purpose, relevant current workflow documents, `TASK_TRACKER`/`HANDOFF` pair status, and as-built synchronization status.
- Add copy-paste prompt examples that ask an agent to explain current progress and next actions from `docs/workflow/TASK_TRACKER.md` and `docs/workflow/HANDOFF.md` in learner-friendly terms.
- Add early-lesson guidance for both 7-day and 14-day flows so learners understand why the documents exist before being asked to use them.
- Keep repository source documents in English while allowing lesson/runtime explanations to follow the selected workflow display language.
- Provide mechanical checks through `tools/test_docs_tour.sh` and updates to existing structure/as-built/developer-memory checks, so the documentation-map guide, tour command, dashboard docs view, prompt examples, and synchronization are testable.
- `guides/DOCUMENT_MAP.md`, `tools/docs-tour`, `tools/test_docs_tour.sh`, and `./tools/dashboard docs` are required runtime artifacts.
- Validation is wired through `tools/test_docs_tour.sh`, structure checks, as-built checks, developer-memory checks, dashboard or Playwright tests, aggregate tests, CI, and pre-commit.
- Implementation verification preserves existing 7-day, 14-day, menu, dashboard, Free Development, Product Improvement, external-integration, product-gate, Playwright, CI, and pre-commit behavior.

## Implemented Product Repository Cleanup Requirements

The lesson repository provides a safe, explicit cleanup path for the external product repository created by the 7-day or 14-day lessons.
This implemented work is additive and does not trade away any existing 7-day lesson, 14-day lesson, menu, dashboard, checks, document synchronization, product-gate behavior, GitHub/CI workflow, docs-tour behavior, or repository-boundary behavior.

- `tools/product-repository-cleanup` is the dedicated cleanup command.
- `tools/product-repository-cleanup status` provides non-destructive discovery of the configured product repository path, local existence, Git status, nested-repository safety, configured repository name, remote URL when available, and remote GitHub status when safely checkable.
- `tools/product-repository-cleanup plan` provides a non-destructive local and remote cleanup procedure preview.
- `tools/product-repository-cleanup local --confirm task-tracker-repository` deletes only the configured local product repository after exact product-repository-name confirmation.
- `tools/product-repository-cleanup remote --confirm xxxMasahiro/task-tracker-repository` deletes only the configured GitHub product repository after exact full owner/repository confirmation.
- Local deletion and remote deletion remain separate commands; there is no `all` command and no automatic chained local-plus-remote deletion.
- Cleanup commands show target path, configured product repository name, GitHub owner/repository target where relevant, and safety status before any destructive operation.
- The local target must resolve to the configured product repository path, normally `$HOME/projects/task-tracker-repository`.
- Local deletion is rejected if the target is inside the lesson repository, does not match the configured product repository name, is not a Git repository, lacks `.git`, or cannot be identified as the Git top level safely.
- Local deletion requires exact confirmation text matching the configured product repository name.
- Remote deletion requires exact confirmation text matching the full GitHub owner/repository name.
- Remote deletion requires `gh`, GitHub authentication, and a successful `gh repo view` lookup before any delete call.
- Remote deletion shows the remote repository URL and owner/repository name immediately before deletion.
- Status, plan, local cleanup, and remote cleanup paths print clear operation logs.
- Dry-run and failure-path behavior is testable without deleting a real GitHub repository.
- `tools/test_product_repository_cleanup.sh` tests status, plan, missing confirmation, wrong confirmation, nested repository rejection, non-Git target rejection, temporary local cleanup behavior, and mocked remote deletion behavior.
- `tools/product-repository-cleanup` and `tools/test_product_repository_cleanup.sh` are required runtime artifacts.
- Validation is wired through `tools/test_product_repository_cleanup.sh`, structure checks, as-built checks, developer-memory checks, aggregate tests, CI, and pre-commit.
- Implementation verification preserves existing 7-day, 14-day, menu, dashboard, Free Development, Product Improvement, external-integration, product-gate, Playwright, docs-tour, CI, and pre-commit behavior.

## Implemented As-Built Sync Contract Requirements

The lesson repository strengthens mechanical enforcement for synchronization across the three design/as-built documents and the two workflow-state documents.
This implemented work is additive and does not trade away any existing `tools/check_as_built_docs.sh`, `tools/check_workflow_pair_sync.sh`, lesson flow, dashboard, CI, pre-commit, docs-tour, product-gate, product-repository cleanup, or developer-memory requirement behavior.

- `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv` records each synchronized improvement as a stable row.
- Each contract row must include a stable sync ID, status, title, required runtime artifacts, required tests, required document coverage, and runtime evidence where applicable.
- Require matching `SYNC-ID`, `STATUS`, `ARTIFACTS`, and `TESTS` blocks in all five synchronized documents:
  - `docs/as-built/REQUIREMENTS.md`,
  - `docs/as-built/SPECIFICATION.md`,
  - `docs/as-built/IMPLEMENTATION_PLAN.md`,
  - `docs/workflow/TASK_TRACKER.md`,
  - `docs/workflow/HANDOFF.md`.
- `tools/check_as_built_sync_contract.sh` fails when a contract sync ID is missing from any of the five documents.
- The check must fail when any of the five documents contains a `SYNC-ID` block that is absent from the contract.
- The check must fail when one document marks a sync ID as `planned` while another marks the same sync ID as `implemented`.
- The check must fail when document `ARTIFACTS` or `TESTS` blocks contain extra or missing entries compared with the contract.
- The check must fail when required artifacts or required tests listed in the contract are missing from the repository.
- The check must fail when runtime evidence files are missing or do not reference the sync ID, one of its artifacts, or one of its tests.
- The check must fail when required tests are not actively wired into aggregate tests, CI, and pre-commit after a sync ID is marked `implemented`; comments or inert text mentions are not enough.
- Keep the existing topic-based as-built check as a supporting compatibility check; do not remove or weaken it.
- Keep the existing `TASK_TRACKER.md` and `HANDOFF.md` workflow-pair check active; extend coverage rather than replacing the pair rule.
- `tools/as-built-sync status` shows sync IDs, five-document coverage, artifact presence, and test wiring status.
- `AGENTS.MD` routes sync-contract questions to the contract file, the five synchronized documents, and the new status/check commands.
- `tools/test_as_built_sync_contract.sh` covers complete synchronization, missing document blocks, unknown sync IDs, mixed planned/implemented status, extra artifacts/tests, missing artifacts, inert wiring, and missing active test wiring.
- The sync-contract check and regression test are wired into `tools/check_as_built_docs.sh`, `tools/test_lesson_repository.sh`, `.githooks/pre-commit`, `.github/workflows/ci.yml`, and `.github/workflows/lesson14-ci.yml`.
- Implementation must preserve refactorability, ecosystem fit, reusability, generality, and the no-existing-feature-tradeoff rule.

## Implemented Resource-Budgeted Parallel Guard Requirements

The lesson repository implements a conservative resource-budget guard for safe, optional parallel execution decisions around heavy verification work without trading away any existing 7-day lesson, 14-day lesson, Git hooks mode, CI check, pre-commit check, document route, dashboard behavior, or repository-boundary behavior.
The implementation provides policy files, user settings, a shared resource library, a CLI command, Git hooks integration, Playwright worker integration, CI wiring, and standalone plus aggregate tests.

- Let the user configure a repository memory budget as a percentage of total memory.
- Let the user configure a repository swap budget from both a percentage of free storage and a GiB upper limit.
- Calculate the effective repository swap budget as the smaller of the storage-percentage value and the GiB upper limit.
- Let the user configure the available-memory floor that turns caution states into serial fallback or explicit parallel-mode safe stop.
- Inspect the real local environment before heavy local checks, including memory, swap, disk free space, and active heavy processes where practical.
- Allow limited parallel execution decisions only when the resource check passes and no active heavy-process caution is detected.
- Keep serial execution available as the safe fallback.
- Define explicit parallel mode as "parallel if safe, fail closed if caution prevents safe parallelism" rather than silently overriding resource safety.
- Treat unknown heavy-work profiles as configuration errors instead of silently falling back to a different profile.
- Treat the 90 percent safe-stop state as a failing gate for starting new heavy verification work, including job recommendation and Playwright wrapper entry points.
- Monitor repository swap-budget usage in 10 percent increments.
- Treat 50, 60, 70, 80, and 90 percent as escalating stages for notice, warning, strong warning, parallel-addition stop, and serial fallback or safe stop.
- Avoid hidden OS mutation, `.wslconfig` writes, swap creation/deletion, `drop_caches`, privileged cleanup, arbitrary process killing, Docker/cgroups enforcement, or Security guard control-plane migration in the first implementation.
- Keep the resource guard reusable across Git hooks, Playwright, aggregate checks, and future CI/local verification design.
- Keep the new resource guard check runnable both standalone and from aggregate tests.

## Implemented Resource Guard Safe Cleanup Requirements

The lesson repository implements repo-local safe cleanup as an additive follow-up to the resource-budgeted parallel guard.
The goal is to prevent Playwright reports, test result directories, marked Git hooks cache files, and repo-local temporary artifacts from accumulating while preserving all existing lesson, CI, Git hooks, Playwright, documentation, and sync-contract behavior.

- Provide a cleanup workflow through the existing `tools/resource-guard` command.
- Keep cleanup targets in `docs/workflow/RESOURCE_POLICY.tsv` rather than hard-coded command branches.
- Keep cleanup settings in `learning/RESOURCE_SETTINGS.tsv` where user-facing resource behavior is already configured.
- Make dry-run inspection the default cleanup behavior.
- Require explicit `--safe` before any deletion occurs.
- Limit deletion to policy-approved paths inside the lesson repository.
- Reject repo-outside paths, path traversal, unsafe `.git` targets, and symlink escapes.
- Allow the marked `.git/pre-commit-cache` directory to be cleaned only when its cache marker is valid.
- Keep Playwright reports and test results cleanable without deleting global npm or Playwright caches.
- Keep cleanup tests runnable both standalone and from aggregate tests.
- Do not perform OS cache cleanup, `drop_caches`, swap mutation, `.wslconfig` mutation, Docker cleanup, process killing, or product repository deletion.
- Preserve existing `resource-guard status`, `check`, `recommend-jobs`, and `monitor` behavior.

## Implemented Resource Guard Summary And Parallel CI Requirements

The lesson repository must make resource guard behavior easier to understand and must use the existing resource guard decisions to improve verification speed without trading away safety, existing checks, or existing lesson behavior.
This implementation is synchronized from `docs/memory/DEVELOPER_MEMORY.md` and is present as runtime command, Git hooks runner, CI workflow, and regression-test behavior.

- Provide a user-facing `./tools/resource-guard summary` command that explains memory budget, swap budget, current state, local profile-specific recommended jobs, and the distinction between local and CI parallelism.
- Provide `./tools/resource-guard summary --short` for a compact operational view.
- Keep `status`, `monitor`, `recommend-jobs`, `check`, and `cleanup` unchanged as existing detailed or operational commands.
- Use existing `docs/workflow/RESOURCE_POLICY.tsv` profiles and existing `resource_guard_recommended_jobs` calculations instead of adding a `target_parallel_jobs` setting.
- Preserve the safety model where recommended jobs vary by workload profile; `git-hooks-full` may recommend four workers while Playwright and aggregate checks recommend fewer workers.
- Implement local Git hooks parallel execution only for checks explicitly classified as safe to run in parallel in `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv`.
- Keep serial execution available for checks that modify shared state, require ordered output, or are not classified as parallel-safe.
- Fall back to serial execution or stop safely when resource guard returns `serial`, `serial-fallback`, or `safe-stop`.
- Keep logs separated per check and display them in deterministic check order.
- Optimize GitHub Actions separately from local resource settings by splitting CI into runner-appropriate jobs rather than applying local `memory_budget_percent` directly to CI.
- Keep all existing checks present; CI job splitting must not remove or weaken existing verification.
- Require a CI workflow structure check so the split workflow mechanically verifies required job names, `needs` relationships, and required commands.
- Ensure main CI aggregate/full-hooks jobs install npm dependencies and Playwright dependencies before running aggregate repository tests or full hooks.
- Preserve explicit local/CI separation: local Git hooks and Playwright may use resource guard recommendations, while CI full hooks must keep the CI-safe local-resource bypass behavior such as `RESOURCE_GUARD_SKIP_LOCAL_CHECK=1` or an equivalent documented mechanism.
- Provide standalone tests for summary output and Git hooks parallel execution, and wire them into aggregate, pre-commit, and CI verification.
- Keep the `resource_guard_summary_parallel_ci` sync contract implemented with actual runtime artifacts, runtime tests, and runtime evidence.
- Keep the design configuration-driven, reusable, and independent of a specific product stack or single learner-facing phrase.

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

## Planned Learner Context Foundation Requirements

The lesson repository now has planned learner-context source documents for the next lesson-content implementation cycle.
This is a documentation foundation only; runtime lesson output is not considered implemented until a separate implementation plan connects the context to the 7-day lesson, 14-day lesson, applied lessons, dashboards, prompts, and checks.

- Provide a learner context directory at `learning/context/`.
- Keep the source context in English while preserving the existing runtime/display-language model for learner-facing output.
- Provide a main AI-driven development foundation text that explains purpose, dialogue, documents, Git, CI, tests, memory, skills, sub-agents, MCP/API, governance, security, quality, and free development.
- Provide a security foundation that covers prompt injection, secrets, permissions, external APIs, dependencies, Git/CI safety, and staged 7-day, 14-day, and applied security learning.
- Provide a machine-readable context map that future implementation can use to connect topics to lesson openings, per-topic explanations, recaps, and dashboard candidates.
- Preserve the existing 7-day lesson, 14-day lesson, menu, dashboard, Git workflow, Git hooks, as-built sync, docs-tour, and product-repository cleanup behavior.
- Do not mark runtime integration as complete until the next implementation plan adds tests and connects the context to lesson output.

## Planned Learner Context Runtime Integration Requirements

The lesson repository must connect the learner-context foundation to runtime guidance without treating all menu items as lessons.
This planned work is additive and must not trade away the existing 7-day lesson, 14-day lesson, applied lesson, Free Development Mode, Product Improvement, External Integration, lesson-maintenance behavior, menu behavior, dashboard behavior, Git workflow policy, Git hooks policy, CI, pre-commit, docs-tour, or as-built sync behavior.

- Treat 7-day, 14-day, and applied modules as learning contexts.
- Treat Free Development Mode, Product Improvement, External Integration, and lesson repository improvement as workflow contexts, not lessons.
- Keep Free Development Mode as a post-lesson or already-trained-user workflow that applies the repository's recommended AI-driven development process to user-selected products.
- Provide runtime guidance that can show opening context, per-topic context, and recap context for structured learning paths.
- Provide workflow guidance that can show purpose, required documents, safety checks, and copy-paste prompts for product-facing workflows.
- Use the existing learning mode, workflow display language, product development language, menu prerequisite, Git workflow, dashboard, and repository-boundary systems.
- Add or extend machine-readable context maps instead of hard-coding one-off branches or fixed phrases.
- Keep repository source context in English while allowing runtime facilitation to follow the selected workflow display language.
- Add a standalone context command and regression test that can also be called from aggregate tests, CI, and pre-commit.
- Keep new checks independent of a specific product stack, specific learner-facing phrase, or single narrow example.
- Do not mark this runtime integration as implemented until the command surface, lesson/workflow integration, dashboard integration, documentation synchronization, and tests are complete.

## Implemented Git Workflow Policy Requirements

The lesson repository lets users configure how much Git management and Git automation they want the workflow agent to perform.
This implemented work is additive and does not trade away any existing 7-day lesson, 14-day lesson, menu, dashboard, free-development, product-improvement, external-integration, product-repository cleanup, CI, pre-commit, or as-built sync-contract behavior.

- Provide a Git workflow policy definition at `docs/workflow/GIT_WORKFLOW_POLICY.tsv`.
- Provide current user-selected Git workflow settings at `learning/GIT_WORKFLOW_SETTINGS.tsv`.
- Let users allow or disallow normal working branches.
- Let users allow or disallow `git worktree`.
- Let users control whether direct work on `main` is allowed.
- Provide Git automation levels:
  - `manual`: Git actions are guidance only.
  - `commit`: the agent may proceed through commit after checks pass.
  - `pr_ci`: the agent may proceed through push, PR creation where applicable, and CI checks.
  - `sync`: the agent may proceed through main CI plus local/remote synchronization checks.
- Keep merge, branch deletion, worktree deletion, remote deletion, and other destructive Git operations behind explicit user confirmation even when automation is enabled.
- Provide Git monitoring for uncommitted changes, unpushed commits, local/remote divergence, unnecessary working branches, unnecessary worktrees, and current repository context.
- Provide a reusable command interface through `tools/git-workflow status|configure|set|allow|check|cleanup-plan`.
- Keep cleanup planning non-destructive; deletion commands are out of scope for the initial Git workflow policy plan.
- Separate lesson-repository Git state from product-repository Git state so the workflow cannot mix the two repositories.
- Reuse existing `tools/lib` patterns, repository-boundary checks, Git sync checks, CI checks, menu prerequisites, dashboard views, and aggregate tests where practical.
- Add `tools/test_git_workflow_policy.sh` to validate setting changes, invalid setting rejection, branch/worktree permission checks, automation-level decisions, dirty state detection, and local/remote sync monitoring.
- Wire `tools/test_git_workflow_policy.sh` into structure checks, as-built checks, aggregate tests, CI, and pre-commit without replacing existing Git sync or CI checks.

## Implemented Menu-Wide Git Workflow Policy Requirements

The lesson repository promotes Git workflow policy from a standalone support setting into a shared menu-level policy used across learning, building/extending, and lesson-maintenance paths.
This implemented work is additive and does not trade away any existing 7-day lesson, 14-day lesson, applied lesson, Free Development Mode, Product Improvement, External Integration, lesson-maintenance, dashboard, cleanup, CI, pre-commit, or as-built sync-contract behavior.

- Keep `tools/git-workflow status|configure|set|allow|check|cleanup-plan` as the existing Git policy source and command surface.
- Make menu categories reference the same Git policy:
  - learning paths: 7-day lesson, 14-day lesson, and applied lesson,
  - building and extending paths: Free Development Mode, Product Improvement, and External Integration,
  - lesson-maintenance path: lesson repository improvement.
- Show Git policy readiness in `tools/menu readiness` for menu items 1 through 7.
- Extend menu checks so Git policy files, selected values, and repository context are validated before menu workflows start.
- Keep `automation_level=manual` valid and non-blocking so existing workflows continue to start when Git automation is guidance-only.
- Interpret automation levels consistently across menu items:
  - `manual`: guidance and monitoring only,
  - `commit`: allow commit-level automation after required checks pass,
  - `pr_ci`: allow push, PR, and CI-check automation where applicable,
  - `sync`: allow main synchronization and local/remote sync checks where applicable.
- Keep merge, branch deletion, worktree deletion, remote deletion, and other destructive operations behind explicit user confirmation regardless of automation level.
- Add a safe check/start path for menu item 7 without weakening existing item 1 through 6 checks.
- Show menu-wide Git policy status in dashboard output.
- Add tests so invalid Git policy values, missing policy files, menu readiness output, item 1 through 7 checks, and no-tradeoff behavior are mechanically verified.

## Implemented Git Workflow Action Settings Requirements

The lesson repository must let users configure the manual or automatic behavior of each common Git workflow action.
This implemented work is additive and does not trade away existing `branch_allowed`, `worktree_allowed`, `main_direct_work_allowed`, `automation_level`, menu, dashboard, CI, cleanup, or as-built sync-contract behavior.

- Keep the existing Git management settings:
  - `branch_allowed`
  - `worktree_allowed`
  - `main_direct_work_allowed`
  - `automation_level`
- Treat `automation_level` as a compatibility preset for broad Git write automation.
- Add detailed action settings that can override the broad preset when the detailed setting key is present:
  - `commit_automation: manual|auto`
  - `push_automation: manual|auto`
  - `pr_creation: manual|auto`
  - `pr_ci_monitoring: manual|auto`
  - `merge_execution: manual|after_approval`
  - `developer_auto_merge_allowed: false|true`
  - `main_ci_monitoring: manual|auto`
  - `sync_monitoring: manual|auto`
- Detailed settings take precedence only when the detailed setting key is present.
- Preserve current `automation_level` behavior when a detailed setting key is absent.
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
- Preserve `ci` as a compatibility alias for CI monitoring so existing `tools/git-workflow allow ci` behavior is not removed.
- For push and PR creation, `auto` means the agent may execute the operation only after explicit approval for that operation is recorded; it never means approval-free execution.
- `merge_execution: after_approval` means the agent may execute merge only after explicit merge approval is recorded.
- Store Git action approvals in `learning/GIT_WORKFLOW_APPROVALS.tsv` and require matching action, repository, and branch receipts for detailed push, PR creation, and normal merge execution.
- `developer_auto_merge_allowed: true` is a developer-responsibility setting that may permit approval-free merge only when required gates pass: PR CI success, target PR and branch are clear, merge base is verified, the working tree is clean, local and remote state are checked, and failures stop the workflow.
- Developer-responsibility auto-merge must require gate evidence plus the actual Git repository state; setting `developer_auto_merge_allowed: true` alone is not sufficient.
- Keep branch deletion, worktree deletion, remote deletion, and product repository deletion behind explicit user confirmation regardless of merge settings.
- Let users inspect and change these detailed settings from the same Git management command surface: `tools/git-workflow status|configure|set`.
- Show the detailed settings in menu readiness and dashboard menu output.
- Apply the same detailed settings to menu items 1 through 7.
- Add tests for default values, valid changes, invalid value rejection, detailed-setting precedence, menu display, dashboard display, and preservation of existing lesson and product workflows.

## Implemented Git Hooks Policy Requirements

The lesson repository makes the existing pre-commit gate faster and easier to operate without weakening its safety.
This implemented work is additive and does not trade away any existing 7-day lesson, 14-day lesson, menu, dashboard, Git workflow policy, CI, pre-commit, documentation route, sync-contract behavior, or repo-local skill behavior.

- Keep the pre-commit workflow safe and serial by default.
- Avoid a normal learner-facing `off` mode for Git hooks; disabling safety checks is outside the standard workflow.
- Provide explicit Git hooks modes through `docs/workflow/GIT_HOOKS_POLICY.tsv` and `learning/GIT_HOOK_SETTINGS.tsv`:
  - `full`: run coverage equivalent to the current required pre-commit checks.
  - `fast`: use a cache to skip only checks that previously passed with unchanged relevant inputs.
  - `minimal`: run only the smallest safe mechanical set required for local orientation, never as a replacement for full verification before completion.
- Store the implemented check list in `docs/workflow/GIT_HOOK_CHECKS.tsv` so the runner does not hard-code the pre-commit command list.
- Store the local full/no-cache recommendation path policy in `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv` so the runner does not hard-code which changed files require heavier local verification.
- Treat malformed `docs/workflow/GIT_HOOK_CHECKS.tsv` rows, including unknown or empty mode tokens, as fail-closed configuration errors.
- Treat malformed `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv` rows as fail-closed configuration errors.
- Store hook cache data outside version control, under a Git-local cache area such as `.git/pre-commit-cache/`.
- Treat missing, stale, or corrupted cache entries as cache misses that force the relevant check to run.
- Build cache keys from reusable inputs such as hook mode, command identity, tool hashes, relevant file hashes, and staged or working-tree changes where practical.
- Keep CI and completion verification on full or no-cache execution so local cache behavior cannot hide regressions.
- Keep ordinary local pre-commit operation on the selected mode, such as `minimal`, while preserving full/no-cache CI as the final verification.
- Recommend local `tools/git-hooks run --mode full --no-cache` when changed files match the recommendation policy for Git hooks, CI, checks, tests, or as-built synchronization.
- Connect the implementation to existing settings, shared libraries, aggregate tests, CI, pre-commit, and repo-local skills instead of adding fixed one-off branches.
- Keep existing pre-commit wiring checks active by recognizing the `tools/git-hooks` runner plus `docs/workflow/GIT_HOOK_CHECKS.tsv` as active wiring, not as inert text.
- Keep new checks runnable as standalone commands and through the aggregate lesson repository test.
- Do not depend on a specific product stack, a specific learner-facing phrase, or one narrow case.
- Make the command surface learner-readable, including status, local verification recommendation, mode selection, cache clearing, normal run, no-cache run, and explicit mode run.
- Keep failure behavior conservative: if the hook runner cannot prove a cached pass is valid, it must run the check or fail.
- `tools/test_git_hooks.sh` must validate standalone policy and cache behavior: mode validation, invalid persisted settings, malformed check rows, invalid or empty check-row mode tokens, local full/no-cache recommendation behavior, cache-hit and cache-miss behavior, cache invalidation, no-cache behavior, minimal-mode required checks, failing-check cache refusal, and safe cache clearing.
- Full/no-cache coverage, aggregate-test wiring, CI wiring, and preservation of existing pre-commit behavior must be verified through `tools/git-hooks run --mode full --no-cache`, `.githooks/pre-commit`, `tools/test_lesson_repository.sh`, and the CI workflow definitions.
- Require developer approval before changing the minimal-mode required check list or skipping Playwright-related checks through cache beyond the implemented fail-closed cache behavior.

## Implemented Local Verification Scope Policy Requirements

The lesson repository must make local verification practical for day-to-day work without weakening the existing no-tradeoff rule, CI guarantees, pre-commit behavior, or sync-contract enforcement.
This implemented policy records a high-priority everyday agent rule that remains subordinate to the invariant that no existing-feature tradeoff is allowed.

- Agents must select verification from the workflow contract, changed paths, change risk, and user approval rather than personal preference.
- Agents must not add heavy verification, full repository checks, no-cache checks, CI final gates, or remote CI waiting solely by discretion.
- The Test Plan Manifest must remain the source for path-based required checks.
- The Git hooks check catalog must remain the source for check IDs and runnable commands.
- The Git hooks recommendation-path policy may recommend local full/no-cache verification, but a recommendation is not by itself permission for the agent to run a heavy check without presenting the need.
- Lightweight UI, wording, CSS, and layout adjustments must use the narrowest contract-relevant checks unless a safety boundary, schema, shared tool, CI, hook, or sync contract is changed.
- Document synchronization, contract, schema, shared tooling, Git hooks, CI, test infrastructure, and broad implementation changes must continue to use the contract-required synchronization, structure, target, aggregate, and full/no-cache verification paths.
- Required checks and recommended checks must remain distinguishable in user-facing reports and agent behavior.
- Heavy recommended checks must be presented before execution unless an immediate high-confidence safety condition requires stopping work.
- Existing CI and final verification semantics must remain available; this policy limits unnecessary local execution, not coverage.
- The implementation must stay policy-driven, reusable, stack-agnostic, and independent of a single file name, product stack, phrase, or one-off test case.

SYNC-ID: local_verification_scope_policy
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOKS_POLICY.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,learning/GIT_HOOK_SETTINGS.tsv,tools/lib/test_plan.sh,tools/test-plan,tools/lib/git_hooks_policy.sh,tools/git-hooks,tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_git_hooks.sh
TESTS: tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_git_hooks.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

## Implemented Security Guard Backfill Requirements

The lesson repository must provide an implemented Security guard backfill with runtime artifacts, standalone checks, aggregate-test wiring, Git hooks wiring, CI wiring, and pre-commit wiring.
This implemented work is additive and must not trade away the existing 7-day lesson, 14-day lesson, applied lesson, Free Development Mode, Product Improvement, External Integration, lesson-maintenance behavior, menu behavior, dashboard behavior, Git workflow policy, Git hooks policy, CI, pre-commit, docs-tour, resource guard, or as-built sync-contract behavior.

- Add security invariants to the lesson repository's agent rules so agent work treats untrusted text as data, resists prompt injection, protects secrets, requires least privilege for external APIs, and rejects UI-only, prompt-only, or keyword-filter-only security fixes as sufficient primary security controls.
- Keep `learner_context_foundation` and `learner_context_runtime_integration` as planned context work until runtime lesson behavior is actually implemented.
- Track Security guard backfill as its own sync scope instead of merging it into learner-context work.
- Require the Security guard backfill policy to cover prompt injection, secrets, destructive operations, dependency changes, Git/CI safety, and external service permissions.
- Require mechanical checks for security invariants to be runnable standalone and from aggregate tests.
- Keep the first implementation scoped to repository-local policy, documentation synchronization, and non-network checks; do not introduce Security guard control-plane migration, OS/WSL mutation, Docker/cgroups enforcement, swap mutation, process killing, or destructive cleanup.
- Require high-risk security findings to fail closed only when the check is high-confidence; warnings must remain distinct from blocking failures to avoid stopping safe existing workflows.

## Implemented Product Security Workflow Gate Requirements

The lesson repository must provide an implemented product-security workflow gate for menu items 4, 5, and 6 without replacing their existing gates.
The product-security gate must make Free Development, Product Improvement, and External Integration safer while preserving their current document, repository-boundary, Git sync, CI, and approval behavior.

- Provide a `product-security` command surface for product-side work, including status, preflight, advice, check, and gate behavior.
- Reuse existing repository-boundary checks and product repository configuration; do not scan unrelated directories or the user's full home directory.
- Add an advice layer that explains the relevant security concern without blocking progress.
- Add a non-destructive check layer that can inspect configured product-repository state for secrets, environment-file hygiene, external API/OAuth risk, dependency changes, log exposure, CI readiness, and product-repository boundary issues.
- Add a fail-closed gate layer for high-confidence unsafe states such as secret exposure, missing required external-integration approval, product-boundary violation, or failed required CI for the relevant product commit.
- Require menu item 6, External Integration, to collect explicit pre-implementation confirmation for connected service, sent data, received data, write behavior, OAuth scopes, token storage, redirect URI, token refresh and revoke behavior, webhook signature handling, rate limits, sandbox or test-account behavior, prohibited log output, and rollback or recovery approach.
- Require product security behavior to remain stack-agnostic so it can support user-selected languages, frameworks, databases, payment systems, APIs, and deployment tools.
- Require product security checks to avoid printing secret values; safe output may include categories, filenames, and safe location references only.
- Require dashboard and menu readiness output to show short learner-facing safety guidance before raw policy detail where appropriate.

## Implemented Test And CI Safe Time Optimization Requirements

The lesson repository should make local tests and remote CI faster without weakening safety, correctness, auditability, existing checks, or existing lesson behavior.
The implemented first phase adds observe-only planning, fail-closed coverage validation, result attestation, CI-safe Git hooks parallelism, and lightweight fixture copying while preserving all existing required verification.

- Preserve the existing 7-day lesson, 14-day lesson, menu, dashboard, Git workflow, Git hooks, product-security, Security guard checks, as-built sync, pre-commit, Playwright, and CI guarantees.
- Treat speed improvements as removal of duplicate work, redundant waiting, repeated setup, and repeated validation within the same verification path.
- Do not remove required safety gates, do not make security or as-built checks optional, and do not let changed-only test selection become authoritative in CI until observe-only evidence proves it is safe.
- Provide a Test Plan Manifest that can show which checks are required, which changes force full verification, and why each decision was made.
- Provide a Coverage Guard that fails closed when the Test Plan policy is malformed, references unknown Git hook checks, omits required dangerous-change patterns, weakens required dangerous-change full/CI escalation, or emits a force decision without full escalation.
- Provide Result Attestation that records policy hash, check-catalog hash, repository-state hash, manifest hash, generated run/force decisions, and final observe-only authority.
- Keep dangerous changes full/no-cache by default, including `AGENTS.MD`, `.github/workflows/`, `.githooks/`, `tools/git-hooks`, `tools/as-built-sync`, security/product-security logic, dependency lockfiles, Playwright configuration/tests, contract TSV files, and unknown paths.
- Keep local `minimal` and `fast` modes useful for feedback while preserving full/no-cache completion and CI verification.
- Prefer observe-only changed-only planning before using any changed-only decision to skip CI checks.
- Allow CI full-hooks execution to request an explicit runner-oriented worker count while local execution remains capped by resource guard recommendations.
- Provide a shared fixture-copy helper that excludes `.git`, `node_modules`, Playwright reports, test results, and cache directories from temporary repository copies.
- Keep gap-only final gates, strict-command single-pass reuse, Playwright evidence reuse, and authoritative changed-only CI selection as future work requiring additional mechanical proof and developer approval.
- Allow CI runner-oriented parallelism and dependency caching, but do not cache CI verification results.
- Require developer approval before changing required CI check names, making changed-only authoritative in CI, introducing quarantine, reducing full/no-cache scope, or merging workflow files in a way that affects required branch protection contexts.

## Implemented Test And CI Final Gate Optimization Requirements

The implemented test and CI final-gate optimization removes duplicate final-gate execution while preserving safety, correctness, auditability, and existing lesson behavior.
The implementation targets the current `aggregate-and-full-hooks` bottleneck without weakening the 7-day lesson, 14-day lesson, existing CI, existing checks, pre-commit behavior, as-built synchronization, security checks, product-security checks, or document routes.

- Replace the full hook's duplicate `test_lesson_repository.sh` execution with a hook-specific gap-only final gate that proves the hook catalog plus final gate still covers the standalone aggregate requirements.
- Keep `tools/test_lesson_repository.sh` available as the standalone exhaustive aggregate command.
- Reuse same-run Playwright success evidence in final aggregation when the commit SHA, workflow run, source job identity, Playwright configuration hash, test file hashes, dependency lockfile hash, and command identity match.
- Reuse same-run as-built and sync success evidence only when the relevant document hashes, sync-contract hash, checker hashes, command identity, and repository state hash match.
- Separate common final-gate behavior from Lesson14-specific final-gate behavior so `CI` keeps the common aggregate/full-hooks gate and `Lesson14 CI` keeps a Lesson14-specific final gate instead of duplicating the same heavy common final verification.
- Preserve existing `Lesson14 CI` `playwright-tests` and `aggregate-and-full-hooks` job contexts as compatibility gates unless developer approval is granted to change required check names.
- Recommend local `full --no-cache` verification when final-gate coverage, final-gate commands, CI evidence helpers, or as-built evidence helpers change.
- Add CI dependency caching for npm and Playwright browser dependencies where it is safe and supported by GitHub Actions.
- Do not persistently cache verification results across commits, branches, workflow runs, or repositories.
- Store same-run evidence as ephemeral CI artifacts or workspace files only for the current workflow run.
- Fail closed by rerunning or failing the relevant gate when evidence is missing, stale, corrupted, mismatched, or produced by a different command identity.
- Include evidence metadata for commit SHA, workflow name, job name, command ID, policy hash, check catalog hash, relevant input hashes, generated result hash, and creation time.
- Keep dangerous changes full/no-cache by default, including CI workflow changes, Git hook changes, as-built/sync changes, security/product-security changes, Playwright configuration changes, dependency changes, and unknown paths.
- Add cleanup and monitoring coverage for same-run evidence, Playwright reports, test results, temporary fixtures, and repo-local caches while preserving the prohibition on OS cache, global cache, Docker, swap, process, or product-repository cleanup without explicit approval.
- Require mechanical tests that prove the gap-only gate cannot drop aggregate coverage, Playwright evidence reuse cannot hide changed browser-test inputs, and as-built evidence reuse cannot hide changed synchronized documents.
- Require developer approval before changing required CI check names, reducing full/no-cache scope, making changed-only CI authoritative, sharing verification-result cache across runs, or accepting any existing-feature tradeoff.

## Implemented Test And CI Full Pipeline Acceleration Requirements

The test and CI acceleration cycle finishes the remaining safe speed work without reducing safety, correctness, auditability, existing lesson behavior, or required verification.
Runtime behavior is implemented through policy files, focused checks, CI workflow structure checks, and workflow wiring.

- GitHub Actions deprecation regressions are guarded mechanically without changing the meaning of any required check.
- Playwright setup is shortened through the shared `tools/ci-playwright-setup` wrapper, which uses npm's local cache preference, checks for an existing Chromium executable, and falls back to a normal install when cache state is missing or stale.
- Full Git hook parallelization is expanded only for checks classified in policy as mechanically independent; unclassified checks remain serial.
- Same-run evidence reuse remains scoped to the current run and does not introduce persistent verification-result cache across commits, branches, workflow runs, repositories, or users.
- Duplicated `policy-regression-tests` style work between `CI` and `Lesson14 CI` is reduced while preserving required workflow contexts and branch-protection compatibility.
- The `Lesson14 CI` compatibility contexts stay present but avoid rerunning common heavy browser, aggregate, and full-hook work already covered by the main `CI` workflow for the same commit.
- Changed-only CI remains observe-only until Coverage Guard, Result Attestation, full-CI comparison evidence, and developer approval prove that it can become authoritative safely.
- Preserve the existing Step 1-7 lesson path, Step 1-14 lesson path, applied lesson, menu, dashboard, Git workflow policy, Git hooks policy, Security guard checks, product-security checks, as-built sync, docs-tour, pre-commit, local full/no-cache verification, and remote CI behavior.
- Require focused regression coverage through `tools/test_ci_pipeline_acceleration.sh`, which is standalone-callable and aggregate-callable.
- Require developer approval before changing required workflow or job names, reducing full/no-cache scope, making changed-only CI authoritative, adding persistent verification-result cache, adding flaky quarantine, accepting an existing-feature tradeoff, or weakening any safety gate.

## CI Timing And Approved Auto-Improvement Requirements

The CI timing and approved auto-improvement cycle makes `aggregate-and-full-hooks` optimization evidence-driven before any future final-gate behavior change.
This implemented work is additive and does not trade away the Step 1-7 lesson path, Step 1-14 lesson path, applied lesson, menu, dashboard, Git workflow policy, Git hooks policy, Security guard checks, product-security checks, as-built sync, docs-tour, pre-commit, local full/no-cache verification, or remote CI behavior.

- Record per-check execution timing for the main `CI` final common aggregate/full-hooks checks in a machine-readable report.
- Preserve learner/maintainer readability by showing check name, duration, exit status, mode, command identity, relevant input hash, and whether same-run evidence was used.
- Store CI timing reports as workflow artifacts or same-run evidence files without storing secrets, tokens, private messages, environment dumps, or external service payloads.
- Strengthen CI status checking so the agent can distinguish main `CI` from `Lesson14 CI`, can target the current commit SHA, can inspect job state, and does not report success while a required workflow is still running.
- Generate CI improvement candidates from measured evidence rather than intuition.
- Improvement candidates must identify slow checks, same-run evidence reuse candidates, and safe parallelization candidates with reason, affected files, required verification, and developer approval requirement.
- The candidate generator must be proposal-only; it must not rewrite workflows, checks, policies, hook groups, synchronized documents, or tools by itself.
- Require developer approval before implementing any generated improvement candidate.
- Reuse same-run hash evidence only when command identity, relevant input hashes, policy hashes, repository-state hash, workflow/run identity, and success status match.
- Keep `full no-cache` as the safe baseline until measured evidence, same-run evidence validation, and developer approval justify any conditional operation.
- Treat conditional `full no-cache` scope reduction as a later approval-gated step, not as part of this measurement and proposal-only implementation.
- Keep CI optimization configuration-driven through existing policy files, shared libraries, checks, repo-local skills, aggregate tests, CI, and pre-commit.
- Do not introduce fixed one-off string checks, product-stack-specific behavior, or a tool that can only operate on the current task.
- Add new focused checks only when they are standalone-callable and aggregate-callable.
- Preserve fail-closed behavior when timing evidence is missing, stale, corrupted, produced by a different command, or generated for different inputs.

SYNC-ID: ci_timing_auto_improvement_plan
STATUS: implemented
ARTIFACTS: docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/check_ci_status.sh,tools/check_ci_workflow_structure.sh,tools/lib/ci_timing.sh,tools/ci-timing,tools/test_ci_timing.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_evidence.sh,tools/test_ci_final_gate.sh,tools/test_git_hooks_parallel.sh,tools/test_lesson_repository.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_ci_workflow_structure.sh,tools/test_ci_timing.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_evidence.sh,tools/test_ci_final_gate.sh,tools/test_git_hooks_parallel.sh,tools/check_as_built_sync_contract.sh

## Implemented CI Aggregate And Full-Hooks Split Requirements

The CI aggregate and full-hooks split shortens the main `CI` workflow wall time by running the lesson aggregate check and full Git hook regression as separate jobs after the same prerequisite gates pass.
It must preserve strict final verification, existing workflow behavior, and current full/no-cache semantics.

- Split only the main `CI` final common verification path into `lesson-aggregate`, `git-hooks-full-no-cache`, and `final-gate`.
- Keep `Lesson14 CI` compatibility contexts intact so existing branch-protection and document routes remain valid.
- Keep `tools/test_lesson_repository.sh --use-evidence --write-evidence` and `tools/git-hooks run --mode full --no-cache --jobs 4` authoritative; the split changes scheduling, not verification scope.
- Require `final-gate` to depend on both split jobs, run even when a split prerequisite fails, and fail closed when a prerequisite result or same-run Git hook evidence is missing, stale, mismatched, or unavailable.
- Preserve timing artifact output by collecting split timing parts, keeping each split job report in a non-colliding report file, and uploading the same final timing artifact pattern.
- Keep `CI_TIMING_REPORT` scoped to the timing wrapper so aggregate tests that include timing self-tests cannot inherit a parent job's report path.
- Keep uploaded same-run evidence filenames artifact-safe while preserving the original evidence id in metadata for verification.
- Use a stable Lesson14 compatibility marker for common split coverage instead of depending on learner-facing prose.
- Do not add persistent verification-result cache, changed-only authoritative CI, Git hook group matrix splitting, flaky quarantine, or conditional full/no-cache skipping in this implementation.
- Preserve the Step 1-7 lesson path, Step 1-14 lesson path, applied lesson, menu, dashboard, Git workflow policy, Git hooks policy, Security guard checks, product-security checks, as-built sync, docs-tour, pre-commit, local full/no-cache verification, and remote CI behavior.
- Require focused structure and acceleration checks that are standalone-callable and aggregate-callable.
- Require developer approval before changing required workflow contexts, reducing full/no-cache coverage, adding persistent cache semantics, making changed-only CI authoritative, or accepting any existing-feature tradeoff.

SYNC-ID: ci_aggregate_full_hooks_split
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,tools/check_ci_workflow_structure.sh,tools/test_ci_pipeline_acceleration.sh,tools/check_as_built_sync_contract.sh,tools/ci-timing,tools/test_ci_timing.sh,tools/lib/ci_evidence.sh,tools/test_ci_evidence.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_ci_workflow_structure.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_timing.sh,tools/test_ci_evidence.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

## Implemented Dashboard Control Center Data Layer Requirements

The implemented dashboard control center data layer provides a read-only, stable JSON contract for an AI-driven development control center before any React or browser UI is introduced.
It must make the current learning, development, maintenance, Git workflow, and Security guard state understandable without turning the dashboard into a new source of truth.

- Preserve `tools/dashboard`, `tools/menu`, `tools/lesson`, `tools/lesson14`, existing checks, existing CI, pre-commit, repo-local skills, document routes, and as-built synchronization behavior.
- Keep existing CLI, TSV, Markdown, policy files, and check commands as the source of truth.
- Provide the generic JSON data layer through `tools/dashboard-data` and shared `tools/lib/dashboard_data.sh` helpers rather than by parsing current CLI prose in a browser.
- Keep future React/Vite mechanics behind the dashboard control-center surface: learners and ordinary users should see a simple dashboard entry point, not Vite commands, dev-server details, package scripts, or implementation internals.
- Require the future control-center UI/UX to be understandable for non-engineers: the ordinary user action is only to open the dashboard/control center through the provided entry point, while setup, Vite startup, URL selection, JSON data loading, and check orchestration remain hidden behind maintained tooling.
- Require a dual-audience control-panel model: show lesson content, lesson progress, and lesson management in plain language for non-engineers, while also showing workflow content, workflow progress, workflow management, gates, evidence, and next operational actions with enough precision for intermediate and senior engineers to use in practical work.
- Preserve the repository's two-sided nature as a strict dashboard invariant: lesson state and workflow state must be visually and structurally distinguishable, easy to scan, easy to understand, and easy to operate without collapsing one side into the other.
- Distinguish lesson-in-progress, lesson-missing, lesson-unknown, and all-steps-completed states so completed 7-day or 14-day lesson state is not shown as unknown.
- Expose stable metadata such as schema version, generation time, source files, warnings, partial failures, current mode, concise guidance items, blockers, and next safe action.
- Separate `policy ready`, `settings ready`, `gate passed`, `approval required`, optional evidence, cached evidence, and unknown state so the UI cannot imply that a policy check is a completed safety gate.
- Keep the first control-center dashboard read-only: it may explain state and preview commands, but it must not run push, PR creation, merge, cleanup, deletion, external integration, OAuth/API, or other dangerous actions.
- Treat Markdown, logs, CLI output, generated content, and external output as untrusted text-as-data before display.
- Avoid storing or emitting secrets, tokens, private messages, full environment dumps, unnecessary raw logs, or external service payloads in dashboard JSON.
- Keep CI and GitHub status optional or evidence-based unless a required check explicitly asks for live validation.
- Require the dashboard schema check and dashboard-data checks to be standalone-callable and aggregate-callable.
- Avoid fixed one-off product-stack branches, UI-only security decisions, route-name-only checks, or text matching that only works for the current wording.
- Require developer approval before adding action execution from the UI, changing existing dashboard semantics, introducing React/Vite dependencies, or making network-dependent status authoritative.

Non-Goals:

- Do not replace `tools/dashboard` or existing command-line workflows.
- Do not move Security guard, Resource guard, Git workflow, CI evidence, or lesson progression logic into React.
- Do not make Vite startup, dev-server URLs, or frontend build tooling part of the ordinary learner-facing dashboard workflow.
- Do not require learners or non-engineer users to run multiple setup, server, URL, data, or verification commands just to access the control center.
- Do not implement dangerous operations, live external integrations, or credential flows from the initial control-center UI.
- Do not reduce full/no-cache, CI, pre-commit, as-built, lesson, product-security, or repository-boundary coverage for convenience.

SYNC-ID: dashboard_control_center_data_layer
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,tools/check_ci_workflow_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

## Implemented Dashboard Control Center React UI Requirements

The implemented React/Vite control-center UI turns the implemented read-only dashboard JSON layer into a browser dashboard while preserving the existing CLI dashboard, lesson flows, workflow checks, CI, pre-commit, and document routes.
This implementation is additive: it adds approved React/Vite dependencies, package scripts, browser runtime files, maintained entry tooling, and browser tests without replacing existing command-line workflows or adding UI action execution.

Purpose:

- Give non-engineer users a clear control-center view for lesson content, lesson progress, lesson management, concise points, and next safe learning action.
- Give intermediate and senior engineers a practical workflow control panel for workflow content, workflow progress, gate status, evidence, blockers, approvals, Git/CI sync, and next operational action.
- Keep the ordinary user interaction to one dashboard/control-center entry action; Vite startup, dev-server URLs, package scripts, JSON loading, and checks must stay behind maintained tooling.

Problems to solve:

- The current JSON data layer must be presented as an accessible browser control center without becoming a second source of truth.
- Lessons and workflows must both be visible without collapsing learning progress into workflow state or workflow gates into vague learner-only labels.
- Concise notes, points, warnings, and next safe actions need a consistent UI placement so users can understand what matters before starting or resuming work.

Target scope:

- Provide a read-only React/Vite UI that consumes `tools/dashboard-data` output rather than parsing `tools/dashboard` prose.
- Keep lesson and workflow surfaces visually and structurally distinct, with shared summary, guidance, blockers, and next-action areas.
- Use reusable frontend data adapters and component boundaries so the UI remains generic over the dashboard schema instead of hard-coding current wording or product-stack assumptions.
- Defer any lesson points, warnings, or next-action fields that are not present in the dashboard JSON contract until the data layer and schema are explicitly extended and tested.
- Keep UI checks standalone-callable and aggregate-callable, connected through existing dashboard schema/data tests, Playwright, Git hooks, pre-commit, CI, and repo-local validation routes.

Non-scope:

- Do not replace `tools/dashboard`, `tools/dashboard-data`, `tools/menu`, `tools/lesson`, or `tools/lesson14`.
- Do not expose React/Vite dependencies, package scripts, dev-server launchers, dev-server URLs, npm commands, or frontend build mechanics as the ordinary dashboard workflow.
- Do not execute push, PR creation, merge, cleanup, deletion, external integration, OAuth/API, credential, or destructive operations from the initial UI.
- Do not make live network or GitHub status authoritative for rendering unless a later approved check explicitly requires it.

Existing-feature impact:

- Existing 7-day, 14-day, applied lesson, menu, dashboard CLI, Git workflow, Git hooks, Security guard, product-security, as-built sync, docs-tour, CI, local full/no-cache, and pre-commit behavior must remain unchanged.
- No existing-feature tradeoff is allowed; if a future UI implementation appears to require one, it must stop and be redesigned.

Required document updates:

- Synchronize this implementation through `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv`, the three as-built documents, `docs/workflow/TASK_TRACKER.md`, and `docs/workflow/HANDOFF.md`.
- Keep the implemented dashboard data-layer block separate from this implemented React UI block.

Required tests:

- Run existing dashboard schema/data tests, the new dashboard control-center test, Playwright checks, as-built sync checks, structure checks, aggregate repository tests, full/no-cache Git hooks, pre-commit, and remote CI after synchronization.
- UI tests must avoid route-name-only, UI-only, keyword-only, current-wording-only, and product-stack-specific assertions.

Risks:

- Future frontend changes could accidentally duplicate source-of-truth logic already owned by CLI/helpers.
- The UI could over-simplify workflow gates, evidence, blockers, approvals, or next actions.
- Tooling could expose Vite mechanics to ordinary users.
- Browser rendering could leak untrusted text, secret-like data, raw logs, external payloads, or unnecessary absolute paths if data boundaries are weakened.

SYNC-ID: dashboard_control_center_react_ui_plan
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/dashboard-data,package.json,package-lock.json,vite.config.mjs,dashboard-control-center/index.html,dashboard-control-center/src/main.jsx,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/styles.css,tools/dashboard,tools/dashboard-control-center,tools/test_dashboard_control_center.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_lesson_playwright.sh,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,tools/check_ci_workflow_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_lesson_playwright.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_ci_workflow_structure.sh

## Implemented Dashboard Control Center Information Architecture Requirements

The dashboard control center must remain read-only while becoming easier to understand for ordinary learners and practical for engineers.
This implemented follow-up is additive to `dashboard_control_center_react_ui_plan`; it improves information architecture, visual hierarchy, device-language UI labels, and snapshot freshness visibility without changing the JSON source of truth or enabling browser-side command execution.

Purpose:

- Make the browser dashboard easier to scan by separating overview, lesson, development workflow, maintenance sync, and safety/action-preview content into clear categories.
- Align the implemented UI with the dashboard mock direction stored at `dashboard-control-center/mocks/archive/mock-categorized-dashboard.png` while preserving the repository's existing JSON contract and safety boundaries.
- Let fixed UI chrome follow the user's device language when supported, with English as the default and technical identifiers, commands, file paths, and data-derived text left unmodified when translation would reduce clarity or safety.
- Make snapshot age and generated time visible so users do not mistake optional or live-like fields for authoritative real-time status.

Problems to solve:

- The initial one-page vertical layout made the dashboard hard to understand because lessons, workflow, maintenance, security, and command previews appeared as one long surface.
- Command previews on the first screen made the read-only dashboard look more operational than intended.
- Fixed English-only UI labels were less comfortable for Japanese device environments, while translating all data-derived text in the browser would risk changing operational meaning.
- Snapshot data needed an obvious freshness boundary because the UI does not poll or run live checks.

Target scope:

- Add category navigation with an overview-first default view.
- Keep command previews isolated under Safety Actions while keeping them preview-only and non-executable.
- Add a small UI-localization layer for fixed labels, initially `en` and `ja`, using device language with English fallback.
- Format generated time and relative snapshot age using browser locale APIs.
- Keep lesson and workflow state separate and keep data-derived guidance, warnings, commands, file names, gate IDs, and source strings as data.
- Preserve reusable component and adapter boundaries so later phases can add manual refresh, safe polling, approved action execution, live CI/Git status, and broader localization without rewriting the first UI layer.

Non-scope:

- Do not implement automatic updates, WebSocket/live streaming, browser-triggered checks, command execution, GitHub/Git live authority, or broad multi-language coverage in this phase.
- Do not translate dashboard JSON prose, commands, gate IDs, file paths, raw source identifiers, or structured state ownership in the browser.
- Do not change `tools/dashboard-data`, `tools/dashboard`, 7-day lesson progression, 14-day lesson progression, existing CI, existing checks, existing document routes, or existing approval gates.
- Do not make frontend-only summaries authoritative for safety, CI, Git, approval, or gate decisions.

Existing-feature impact:

- Existing CLI dashboard, dashboard JSON producer, schema checks, React/Vite entry tooling, 7-day and 14-day lesson paths, Git hooks, pre-commit, CI, docs-tour, as-built sync, Security guard, Resource guard, Git workflow, and product-security behavior must remain unchanged.
- No existing-feature tradeoff is allowed; if a later live/action phase appears to require a tradeoff, implementation must stop and request developer approval.

Required document updates:

- Synchronize this follow-up through the as-built sync contract, the three as-built documents, `docs/workflow/TASK_TRACKER.md`, and `docs/workflow/HANDOFF.md`.
- Keep the implemented data-layer and initial React UI sync IDs separate from this categorized information-architecture sync ID.

Required tests:

- Keep `tools/test_dashboard_control_center.sh` standalone-callable and aggregate-callable.
- Extend Playwright coverage to verify overview-first navigation, category separation, Safety Actions command-preview isolation, no executable buttons, secret-like redaction, mobile layout, and `en`/`ja` fixed-label localization.
- Run existing dashboard schema/data checks, as-built sync checks, test-plan coverage, CI workflow structure checks, aggregate checks, Git hooks, and pre-commit before final PASS.

Risks:

- UI-local summaries could be mistaken for owner-layer truth if labels do not emphasize read-only snapshot behavior.
- Browser localization could accidentally translate data-derived operational text and change meaning.
- Category splitting could hide workflow or safety details from engineers if command previews, approvals, blockers, and unknown/optional states are not discoverable.
- Future live update and action-execution phases could blur the read-only boundary unless they are separately specified, approved, and tested.

SYNC-ID: dashboard_control_center_information_architecture
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,vite.config.mjs,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Implemented Dashboard Control Center Visual Polish Requirements

The dashboard control center must more closely match the approved categorized dashboard mock while preserving the implemented read-only JSON boundary, category information architecture, device-language label policy, and Safety Actions isolation.
This work is visual polish only; it must not change lesson progression, dashboard data ownership, command execution safety, CI/Git authority, or existing CLI behavior.

Purpose:

- Make the implemented browser dashboard look closer to `dashboard-control-center/mocks/archive/mock-categorized-dashboard.png` so the visual design matches the approved direction, not only the category structure.
- Improve scanability through a more compact status strip, 2x2 category-health layout, clearer overview hierarchy, and category shortcut cards.
- Keep the dashboard useful in Japanese and English environments without allowing visual polish to translate or reinterpret operational data.

Problems to solve:

- The previous implementation matched the mock's information architecture but still looked visually different from the mock.
- The Overview health area appeared as a vertical stack instead of the mock's compact card grid.
- The top status information used separated cards rather than a segmented operational strip.
- The sidebar lacked the mock-like bottom metadata and the overview lacked an Explore Pages-style secondary navigation area.

Target scope:

- Tune React markup and CSS to better match the mock's operational dashboard look: sidebar density, status strip, overview grid, health cards, category shortcuts, card spacing, borders, subtle depth, and responsive constraints.
- Keep all changes within existing React/Vite files and existing Playwright control-center checks.
- Add behavior-oriented visual layout assertions that check structure, relative layout, and responsive stability without depending on pixel-perfect screenshots or specific live data.

Non-scope:

- Do not add automatic refresh, live CI/Git status, command execution, broad localization, new dependencies, generated runtime images, SVG illustration systems, or backend changes.
- Do not make pixel-perfect matching to the image generator output a correctness requirement.
- Do not weaken existing dashboard schema, dashboard data, control-center safety, 7-day/14-day lesson, CI, Git hooks, pre-commit, or document synchronization checks.

Existing-feature impact:

- Existing dashboard data producer, control-center entry tooling, Playwright tests, aggregate tests, full hooks, pre-commit, CI workflow structure, and documentation routes remain active.
- Existing read-only behavior and preview-only command safety must remain unchanged.
- No existing-feature tradeoff is allowed.

Required document updates:

- Add this visual-polish sync ID to the as-built sync contract and the five synchronized documents.
- Keep `dashboard_control_center_data_layer`, `dashboard_control_center_react_ui_plan`, and `dashboard_control_center_information_architecture` intact as prior implemented layers.

Required tests:

- Extend `tools/test_dashboard_control_center.sh` coverage through the existing Playwright spec.
- Verify segmented snapshot status, 2x2 desktop health-card layout, Explore Pages/category shortcut presence, mobile no-overflow behavior, `en`/`ja` label behavior, no execution buttons, and Safety Actions command isolation.
- Run as-built sync checks, test-plan coverage, CI workflow structure checks, aggregate repository tests, full hooks, pre-commit, and final gate before PASS.

Risks:

- Visual polish could hide operational detail or make command previews appear less isolated.
- Overly exact screenshot matching could make tests brittle.
- Styling changes could regress Japanese text wrapping or mobile layout.
- Adding visual detail could accidentally create button-like action affordances for read-only links or commands.

SYNC-ID: dashboard_control_center_visual_polish
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Implemented Dashboard Control Center Mock Parity Requirements

The mock-parity follow-up is implemented as a data-backed visual and information-structure correction for the existing read-only React/Vite dashboard.
It must close the known gap between the visible dashboard and `dashboard-control-center/mocks/archive/mock-categorized-dashboard.png` without making the generated image itself the source of truth.

Problems to solve:

- The Next Safe Action area can become too tall because long issue lists are shown directly in the Overview.
- The mock-level primary action, including the Review lessons and accept for workflow intent, is not represented as structured dashboard data.
- Partial Failures need a compact Overview summary with access to full detail.
- Health cards use icon-like centers where the mock uses data-derived progress percentages.
- Explore Pages cards lack data-derived bottom metrics such as counts, units, progress, and state markers.
- The UI must not invent progress numbers or mock-specific fixed values when the dashboard JSON does not provide those values.

Target scope:

- Extend the dashboard data schema and producer with category metrics and a structured primary action derived from existing lesson, workflow, maintenance, Git, CI, and security status sources.
- Render the mock-aligned Overview composition: compact Next Safe Action, limited issue summaries with full detail preserved outside the Overview, central percentage rings, and Explore Pages metrics.
- Keep fixed UI labels localized through the existing `en`/`ja` boundary while preserving data-originated text, commands, file paths, gate IDs, and technical identifiers.
- Keep optional or unverified live checks as manual follow-ups instead of true Partial Failures.
- Keep the dashboard read-only and keep command previews isolated to Safety Actions.
- Keep tests structure-oriented and data-driven instead of depending on one fixed mock screenshot value.

Non-scope:

- Do not execute commands from the browser.
- Do not parse `tools/dashboard` prose in the browser.
- Do not add live CI/Git authority, broad localization, or new dependency stacks in this mock-parity layer.
- Do not weaken or replace the 7-day flow, 14-day flow, existing CI, existing checks, document routes, data-layer contract, or visual-polish layer.

Existing-feature impact:

- Existing dashboard data, React/Vite entry points, schema checks, Playwright checks, aggregate tests, Git hooks, CI, and pre-commit remain active.
- Existing 7-day and 14-day lesson behavior must be preserved.
- No existing-feature tradeoff is allowed.

Required document updates:

- Keep `dashboard_control_center_data_layer`, `dashboard_control_center_react_ui_plan`, `dashboard_control_center_information_architecture`, and `dashboard_control_center_visual_polish` as implemented layers.
- Add this mock-parity sync ID to the sync contract and the five synchronized documents.
- Update the dashboard data schema only for producer-owned fields needed by the UI.

Required tests:

- Dashboard schema and dashboard data checks must validate category metrics and structured primary action fields.
- Control-center tests must verify compact issue summary behavior, data-derived percentage rings, Explore Pages metrics, localization boundaries, read-only behavior, and command-preview isolation.
- Control-center tests must use at least two valid fixtures with different metrics so hard-coded mock percentages or counts fail.
- Mock-parity acceptance requires compact Next Safe Action, compact issue summaries with full detail reachable through category pages, visible Partial Failures when true failures exist, central percentage rings, Explore Pages bottom metrics, and no fixed mock values.
- Aggregate and sync checks must continue to pass.
- The sync-contract `TESTS` field lists directly wired standalone checks; aggregate test, full/no-cache hooks, pre-commit, and final gate remain required final verification evidence outside that field.

Risks:

- Mock parity could accidentally become pixel-copy testing or fixed-value testing.
- Optional or unverified checks could be mislabelled as true failures.
- New percentages could imply gate authority if they are not clearly derived scan aids.
- Additional cards could regress mobile or Japanese text wrapping.

SYNC-ID: dashboard_control_center_mock_parity
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/fixtures/dashboard-control-center-invalid.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Implemented Dashboard Control Center Live Snapshot Sync Requirements

The live-snapshot follow-up is implemented as a safe read-only refresh layer for the React/Vite control center.
It must let an already-open dashboard update from newly published dashboard JSON without a page reload and without allowing the browser to run repository commands.

Problems to solve:

- The current dashboard updates only after a page reload.
- The control-center CLI writes one snapshot before opening the UI, so an adjacent running CLI can diverge from the browser display.
- Invalid or partially written JSON could cause a blank or misleading dashboard if refresh is not fail-closed.

Target scope:

- Make the control-center snapshot writer publish JSON atomically through validate-then-rename behavior.
- Make the control-center open command refresh the JSON snapshot on a small configurable interval while the dev server is running.
- Make the React app poll only the dashboard JSON endpoint with GET requests, detect changed snapshots through producer-owned snapshot identity, update without reload, and retain the last known good snapshot on invalid, missing, or temporarily failed reads.
- Surface stale or refresh-error state as UI status without converting it into CI, Git, approval, or security authority.

Non-scope:

- Do not add WebSocket, server-sent events, browser-triggered checks, browser-triggered Git/GitHub/CI calls, or command execution.
- Do not add automatic merge, push, PR creation, destructive operations, or approval bypass.
- Do not weaken existing snapshot, schema, control-center, CI, or pre-commit coverage.

Existing-feature impact:

- Existing manual snapshot generation, Vite dashboard opening, data validation, no-prose parsing rule, and read-only safety boundary must keep working.
- 7-day, 14-day, existing CI, existing checks, and existing document navigation remain unaffected.
- No existing-feature tradeoff is allowed.

Required document updates:

- Add this live-sync sync ID to the sync contract and the five synchronized documents.
- Update the dashboard data schema only where snapshot identity or live refresh state needs a producer-owned field.
- Keep live sync separate from mock parity so future command execution or CI/Git live authority cannot be smuggled into this read-only refresh layer.

Required tests:

- Standalone control-center checks must cover atomic snapshot writing, valid JSON publication, read-only source boundaries, and static no-command-execution invariants.
- Playwright coverage must verify a visible update without page reload and last-known-good behavior on a failed refresh.
- Aggregate, sync, test-plan, and CI-structure checks must continue to pass.
- The sync-contract `TESTS` field lists directly wired standalone checks; aggregate test, full/no-cache hooks, pre-commit, and final gate remain required final verification evidence outside that field.

Risks:

- Polling too often could make local development noisy or slow.
- Partial writes could break the UI if the writer is not atomic.
- Refresh failures could be mistaken for authoritative gate failures.
- Test timing could become flaky unless update tests are deterministic.

SYNC-ID: dashboard_control_center_live_snapshot_sync
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/dashboard-control-center,vite.config.mjs,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/fixtures/dashboard-control-center-invalid.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Implemented Dashboard Control Center Mock-Aligned Overview Requirements

The mock-aligned Overview follow-up makes the browser control center match `dashboard-control-center/mocks/archive/mock-categorized-dashboard.png` more closely while preserving the read-only repository control-panel boundary.
The work is additive to the implemented data layer, React UI, information architecture, visual polish, mock parity, and live snapshot sync layers.

Problems to solve:

- The visible main header and snapshot explanation add non-mock chrome above the operational dashboard content.
- The Next Safe Action card is not yet visually strong enough as the primary decision area.
- The Next Safe Action heading, emphasized action row, and metadata rows need to match the mock hierarchy instead of using one uniformly colored card.
- Empty Partial Failures are not explicitly represented as a stable no-failure state.
- Manual follow-ups can appear at the same visual level as true Partial Failures.
- Overview expansion controls can change page height and make the control panel less stable.
- Repeated navigation, status, card, summary, and detail rows need mock-aligned left-side visual anchors for scanning.
- The four health rings need stable category color identity so frequent users can recognize lesson, workflow, maintenance, and safety at a glance.
- The bottom read-only notice needs wording specific to this repository control panel.

Implemented scope:

- The Overview begins with compact status information and mock-aligned operational cards instead of a large page header.
- An accessible page title is preserved without displaying the previous large header block.
- The visible snapshot explanation block is removed from the Overview.
- Next Safe Action is structured with a leading safe-action icon outside the emphasized action row, a green-accented action title row, and white icon-led metadata rows.
- Partial Failures is always shown; when there are no true failures, it shows a concise none state instead of hiding the category.
- Manual follow-ups are in a separate third-row summary card that shows necessary summary information and links to detail pages.
- Overview disclosure expansion that changes the page layout is avoided; detailed lists route to the existing category pages.
- Consistent mock-aligned left-side icons or glyphs are added to navigation, status, repeated item rows, summaries, and cards without making them executable controls.
- Health cards and Explore Pages remain data-driven through existing metrics rather than fixed mock values.
- The four health rings use distinct category colors for lessons, workflow, maintenance, and safety.
- The generic bottom read-only warning is replaced with a concise repository-control-panel notice.
- The visible Category Health heading is removed while keeping the category-health region available to assistive technology.
- The four health cards are height-aligned within the grid.

Non-scope:

- Do not add browser command execution, browser-triggered checks, live authoritative CI/Git status, destructive operations, or new dependency stacks.
- Do not change the dashboard JSON producer ownership model or parse `tools/dashboard` prose in the browser.
- Do not change 7-day lessons, 14-day lessons, existing CI, existing checks, pre-commit behavior, document routes, or command-preview safety boundaries.
- Do not make the mock image a pixel-perfect test oracle.

Existing-feature impact:

- Existing dashboard schema, data producer, live snapshot sync, last-known-good behavior, Safety Actions isolation, localization boundary, aggregate tests, Git hooks, CI, and pre-commit must remain active.
- The Overview changes must preserve read-only behavior and all existing category navigation paths.
- No existing-feature tradeoff is allowed.

Implemented document updates:

- Add this sync ID to the sync contract and the five synchronized documents.
- Keep this work separate from the earlier mock-parity and live-snapshot sync layers so future command execution or live authority cannot be smuggled into a visual-alignment follow-up.

Implemented tests:

- Control-center Playwright coverage verifies the removed visible header chrome, removed visible Category Health heading, stable Partial Failures none state, separate manual follow-up summary, mock-aligned Next Safe Action structure, global left-side icon anchors, distinct health-ring category colors, bottom repository notice, and no Overview expansion dependency.
- Existing schema, data, sync, test-plan, CI-structure, aggregate, hook, pre-commit, and final-gate checks remain required.

Risks:

- Removing the visible header could remove the only accessible page title if not replaced with an accessible equivalent.
- Added icons could create mobile overflow or decorative accessibility noise.
- Moving follow-ups could hide necessary operator context unless the summary and detail links remain clear.
- Mock-aligned styling could accidentally create command-like affordances if links and previews are not kept distinct.

SYNC-ID: dashboard_control_center_mock_aligned_overview
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Implemented Dashboard Control Center Detail-Page Mock Parity Requirements

The detail-page mock-parity follow-up aligns the four category detail pages with the approved detail mock images while preserving the existing read-only dashboard data model and live snapshot behavior.
The work is additive to the implemented Overview mock alignment and uses the four copied reference images as the UI/UX source of truth for hierarchy, density, color direction, and icon direction while keeping screenshot equality out of the automated contract.

Problems solved:

- Detail pages currently read like raw status data lists, so general repository users cannot immediately tell what they are checking or what decision the page supports.
- The workflow icon still differs from the approved mock direction and can look like eyeglasses.
- The Overview and detail pages do not consistently reuse the same workflow icon, category colors, status hierarchy, and scan-first visual language.
- The risk pill can look off-center for single-character Japanese values such as `低`.
- Workflow detail labels expose technical keys such as `Development.Product Repository` as primary headings.
- Detail cards can be too empty or too evenly weighted, which hides approval-required, unknown, failed, blocked, missing, and manual-follow-up priorities.
- Partial Failures, manual follow-ups, warnings, and command previews need clearer visual separation without adding browser execution affordances.

Implemented scope:

- Added reusable detail-page chrome and decision summaries that show what each page checks, current judgment, must-review items, and the next safe check.
- Applied the summary pattern to Lessons, Development Workflow, Maintenance Sync, and Safety Actions.
- Replaced the workflow category icon with a centralized branching `Network` icon component reused across navigation, Overview, Explore Pages, and workflow detail surfaces.
- Kept Lessons blue, Workflow teal, Maintenance purple, and Safety green while preserving separate warning/error colors.
- Reworked Lessons into mock-aligned inspection panels with a status band, prominent lesson heading, warning callout, and row-based checks.
- Reworked Development Workflow into prioritized must-review and ready row lists with human-readable labels and secondary technical keys.
- Reworked Maintenance Sync into status cards, a manual confirmation table, and an expanded source boundary panel.
- Reworked Safety Actions into safety status cards, a Partial Failures table, display-only command preview cards, and a read-only notice.
- Kept risk/status pill content centered for short and localized labels.
- Preserved English as the repository-standard data language while using the existing translator boundary to display fixed UI labels and known control-center source/intent labels in the viewer's resolved UI locale.
- Kept lesson/workflow language settings as user-selected state fields, not as the UI locale resolver.
- Tightened the detail pages against the approved mocks so the active category icon, page header, first-row decision summary, status-card icon containers, failure severity icons, and display-only command-preview grouping read like the visual source references instead of generic data panels.
- Expanded the first-row decision summaries to support concise bullets, count badges, and safe in-page/category links so non-engineer users can identify what is checked, what can be decided, and where to look next without relying on external explanation.
- Kept all added user-facing labels behind the existing UI locale translator boundary; no Japanese-only runtime literals are added, and source evidence remains displayed as sanitized data.

Non-scope:

- Do not add browser command execution, browser-triggered checks, live authoritative CI/Git status, destructive operations, schema ownership changes, or new dependency stacks.
- Do not change 7-day lessons, 14-day lessons, existing CI, existing checks, pre-commit behavior, document routes, or command-preview safety boundaries.
- Do not make the generated detail mock images pixel-perfect test oracles.
- Do not hard-code fixture-specific counts or wording into runtime logic.
- Do not treat lesson display language or product development language settings as the control-panel UI locale.

Existing-feature impact:

- Existing dashboard schema, data producer, live snapshot sync, last-known-good behavior, Safety Actions isolation, localization boundary, aggregate tests, Git hooks, CI, and pre-commit must remain active.
- The detail-page changes must preserve all existing category routes and read-only source boundaries.
- No existing-feature tradeoff is allowed.

Required document updates:

- Synchronize this sync ID through the sync contract and the five synchronized documents.
- Keep this work distinct from Overview mock alignment so future detail-page changes can be validated independently.

Required tests:

- Control-center Playwright coverage must verify each detail page exposes the decision summary, active navigation, no command execution buttons, readable workflow titles, unified workflow icons, centered short risk labels, safe command-preview presentation, and no mobile overflow.
- Existing sync, test-plan, CI-structure, aggregate, hook, pre-commit, and final-gate checks remain required final verification evidence.

Risks:

- Adding summaries could duplicate data unless they are derived from existing dashboard data and translator helpers.
- Hiding technical keys too aggressively could reduce developer traceability unless raw keys remain available as secondary labels.
- Stronger safety styling could make read-only command previews look actionable unless labels and button absence remain explicit.
- Mock-aligned layouts could break on variable-length data unless responsive constraints and non-hard-coded tests are maintained.

SYNC-ID: dashboard_control_center_detail_mock_parity
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/archive/mock-detail-lessons.png,dashboard-control-center/mocks/archive/mock-detail-workflow.png,dashboard-control-center/mocks/archive/mock-detail-maintenance.png,dashboard-control-center/mocks/archive/mock-detail-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Mechanical Enforcement

- 14-day progression requires approval receipts through `tools/lesson14 承認`.
- 7-day `setup.index` cannot pass before learning mode, workflow display language, and product development language are selected.
- 14-day `setup.index` cannot pass before learning mode, workflow display language, and product development language are selected.
- Developer-memory requirements are checked by `tools/check_developer_memory_requirements.sh`.
- Lesson-side validation is checked by `tools/test_lesson_repository.sh`.
- 7-day CLI behavior is checked by `tools/test_lesson.sh`.
- 14-day CLI behavior is checked by `tools/test_lesson14.sh`.
- Free/Team product gates are regression-tested with a temporary product repository through `tools/test_product_gate_tools.sh`.
- Product repository cleanup is regression-tested with temporary local repositories and a fake `gh` command through `tools/test_product_repository_cleanup.sh`.
- Product security workflow gates are regression-tested through `tools/test_product_security.sh` and existing product gate tests.
- As-built document consistency is checked by `tools/check_as_built_docs.sh`.
- Security guard invariants are checked by `tools/check_security_invariants.sh` and `tools/test_security_invariants.sh`.
- Sub-agent review protocol presence is checked by `tools/check_review_protocol.sh`.
- Real product operations are checked by `tools/test_production_operations.sh` only when an external product repository exists.
- Free Development Mode is gated by `tools/free-development gate`.
- Team Development and Docker is gated by `tools/team-development gate`.
- Product Improvement is gated by `tools/product-improvement gate`.
- Documentation Map is checked by `tools/test_docs_tour.sh`.
- Documentation Map runtime status is shown by `tools/docs-tour status` and `tools/dashboard docs`.
- Menu prerequisites are checked by `tools/menu check <1|2|3|4|5|6>` and `tools/test_menu_prerequisites.sh`.
- The learner-facing menu is checked by `tools/menu` and developer-memory requirement checks.
- Git workflow policy settings are checked by `tools/git-workflow status`, `tools/git-workflow cleanup-plan`, and `tools/test_git_workflow_policy.sh`.
- Git hooks policy settings are checked by `tools/git-hooks status`, `tools/test_git_hooks.sh`, and full/no-cache CI hook runs.
- Dashboard and illustration entry points are checked by structure and developer-memory requirement checks.
- Remediation remains complete only while the audit items above are implemented, synchronized into these as-built documents, and covered by mechanical checks that fail when the requirement is missing.
- Remediation checks and implementations must remain refactorable, ecosystem-friendly, reusable, and general.

## Non-Goals

- Do not replace the 7-day flow.
- Do not replace the 14-day flow.
- Do not introduce a tradeoff against existing behavior, checks, or learner workflows.
- Do not force a fixed product technology stack.
- Do not require Docker execution when Docker is not installed or the learner has not chosen container implementation.
- Do not skip requirements, specifications, plans, task tracking, handoff, Git sync, tests, or CI in Free Development Mode.
- Do not recreate or depend on `task-tracker-repository` during lesson-repository validation.
- Do not weaken current tests, CLI commands, lesson flows, free-development flow, advanced modules, or repository-boundary rules while implementing remediation.
- Do not change unrelated existing documentation content as part of the remediation.

## Completion Criteria

- All lesson structure and sync checks pass.
- Developer-memory requirements check passes.
- Lesson repository aggregate test passes.
- Implemented 7-day parity verification passes `./tools/test_lesson.sh` and `./tools/test_lesson_repository.sh`.
- Implemented language-list expansion verification passes `./tools/test_lesson.sh`, `./tools/test_lesson14.sh`, and `./tools/test_lesson_repository.sh`.
- `docs/workflow/TASK_TRACKER.md`, `docs/workflow/HANDOFF.md`, `docs/as-built/REQUIREMENTS.md`, `docs/as-built/SPECIFICATION.md`, and `docs/as-built/IMPLEMENTATION_PLAN.md` reflect the same as-built state.
- `task-tracker-repository` remains outside this repository and may remain deleted unless a real product operations test is explicitly requested.
- The developer-memory audit remains cleared only while all remediation requirements in this document are implemented or mechanically enforced.

## Planned Lesson Display Label Policy Requirements

SYNC-ID: lesson_display_label_policy
STATUS: implemented
ARTIFACTS: docs/workflow/LESSON_DISPLAY_LABELS.tsv,tools/lib/lesson_display_labels.sh,tools/lib/lesson_common.sh,tools/lib/lesson_runtime.sh,tools/menu,tools/dashboard,tools/learn,tools/helpdesk,tools/lesson14,tools/roadmap,tools/docs-tour,README.md,AGENTS.MD,index.md,index-14-days.md,ai-driven-task-tracker-scenario.md,guides/LESSON_14_DAYS.md,learning/ROADMAP.md,lesson/LESSON_FLOW_14_DAYS.tsv,prompts/PROMPTS.md,prompts/PROMPTS_14_DAYS.md,playbooks/AGENT_PLAYBOOK.md,playbooks/AGENT_PLAYBOOK_14_DAYS.md,tools/check_learner_display.sh,tools/test_menu_prerequisites.sh,tools/check_lesson14_sync.sh,tools/check_agents_skills.sh
TESTS: tools/check_learner_display.sh,tools/test_menu_prerequisites.sh,tools/check_lesson14_sync.sh,tools/check_agents_skills.sh,tools/test_lesson14.sh

The lesson repository separates learner-facing display labels from internal compatibility names before replacing old lesson-duration wording.
This implemented work improves learner-facing clarity without weakening the existing Step 1-7 path, Step 1-14 path, Lesson14 sync gates, CI, pre-commit, as-built synchronization, skills, prompts, dashboard, or historical learning records.

- Learner-facing menu and dashboard output must use a stable STEP-oriented course label such as `STEP 1-7: 基礎レッスン` and `STEP 1-14: 実践レッスン`.
- Internal compatibility names must remain available, including `tools/lesson`, `tools/lesson14`, `index.md`, `index-14-days.md`, `_14_DAYS` files, `dayN.*` step IDs, and `check_lesson14_*` commands.
- `Step N/14` must not be blindly renamed because it is also used as a Lesson14 sync-gate key.
- Learner-facing documentation, prompts, playbooks, menu output, dashboard output, roadmap output, learning helpdesk output, and new learning records must not keep misleading `7日間レッスン`, `14日間レッスン`, or learner-facing `Day` wording.
- Existing historical learning logs must not be bulk rewritten; new output should use the new display policy while old records remain auditable evidence.
- The learner-display check must detect more than `Day N`; it must also catch learner-facing `Day別`, `各Day`, `DayまたはStep`, Markdown `| Day |` headings, and old course labels outside approved internal or historical contexts.
- The learner-display check detects the active learner-surface regressions listed above while preserving approved internal and historical compatibility contexts.
- Checks must distinguish learner-facing forbidden labels from allowed internal compatibility names instead of relying on a global string replacement.
- Any display-label implementation must remain reusable, policy-driven, and independent of a specific product stack, language, or single hard-coded Japanese phrase.

## Implemented External Product Repository Authority Requirements

SYNC-ID: external_product_repository_authority
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/test_product_repository_authority.sh,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/check_ci_workflow_structure.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

The lesson repository must treat external product repositories as first-class workflow sources without copying the lesson repository wholesale.
This implemented work is additive and must not trade away existing 7-day lessons, 14-step lessons, existing CI, existing checks, existing document routes, product-repository cleanup, dashboard read-only behavior, or repository-boundary safety.

- Define a reusable product-repository structure contract that keeps product root files lean while moving product design, workflow, memory, and operation declarations under `docs/` and `ops/`.
- Keep product-side `AGENT.md` at the product repository root and keep lesson-side `AGENTS.MD` as the lesson repository rulebook.
- Preserve existing root-level product document compatibility through a shared product document path resolver until all product workflows are migrated.
- Let `task-tracker-repository` and future free-development product repositories share the same operational skeleton while allowing stack-specific additions through manifests.
- Make required, optional, and contextual product repository elements mechanically distinguishable by context and product type.
- Avoid stack-specific dashboard branches by reading product manifests for tests, CI, integrations, security, approvals, and dashboard-visible surfaces.
- Add product gate evidence as the authoritative read model for product Git, document, CI, security, approval, and gate status.
- Bind product evidence to product repository context, product HEAD, observation time, freshness, authority, required-in-context state, blockers, and next manual command previews.
- Keep evidence read-only for dashboard consumers and keep browser pages unable to execute shell, Git, GitHub, CI, or `tools/*` commands.
- Keep `tools/dashboard-data` as a read-only snapshot producer that reads existing product manifests and evidence only; it must not fetch remotes, call GitHub, run CI, create evidence, or mutate repositories.
- Show missing product repository state as a product-operation blocker without blocking unrelated lesson progress.
- Expose product-operation blockers separately from lesson-only blockers so a missing product repository cannot incorrectly stop lesson-only progress.
- Extend dashboard data state handling to distinguish not-run evidence and stale evidence from generic unknown state.
- Preserve English as the repository-standard source data language while allowing UI display to use the existing locale boundary.
- Keep tests and checks policy-driven, standalone-runnable, aggregate-runnable, and independent of one product stack, one wording, or one fixture case.

## Implemented STEP 1-14 Product Launch Quality Gate Requirements

SYNC-ID: step_1_14_product_launch_quality_gate
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,lesson/SYNC_GATES_14_DAYS.tsv,lesson/LESSON_FLOW_14_DAYS.tsv,prompts/PROMPTS_14_DAYS.md,skills/lesson-sync-gate/SKILL.md,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/product-launch-check,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

STEP 1-14 product completion must guarantee that the generated product works through the user-facing launch path documented by the product repository.
This implemented work was the first priority because a lesson product that does not work as documented undermines learner trust before dashboard synchronization or external-repository automation can be meaningful.

Required outcomes:

- Treat the product README launch path as the user-facing authority for final product readiness.
- Require the STEP 1-14 task-tracker product to support opening `index.html` directly unless a later approved specification changes the official launch path.
- Add a lesson-side completion gate that prevents final STEP 1-14 completion when the documented launch path is unverified or failing.
- Ensure the Add Task user flow, task rendering, counters, status changes, and completed-task cleanup are checked through the documented launch path.
- Keep URL query parameters out of the product input contract unless a separate approved requirement adds them.
- Keep product implementation reusable and maintainable rather than adding a one-off browser workaround.
- Keep new launch-path checks standalone-runnable and aggregate-runnable through existing lesson and product-gate verification.
- Expose launch-path verification through `tools/product-launch-check` and `tools/test_product_launch_check.sh`, and keep those runtime artifacts recorded in the sync contract artifacts and tests.
- Preserve STEP 1-7, STEP 1-14 ordered progression, existing CI, existing checks, existing document routes, and existing repository-boundary behavior.

Non-scope:

- Do not change the official launch path from direct `index.html` opening to an HTTP-server-only path without developer approval.
- Do not add a bundler, new dependency, external service, or browser-side command execution as part of this planned gate.
- Do not make the lesson completion gate depend on one hard-coded product phrase, one browser URL, or one fixture-only case.

## Implemented Product Authority Evidence Status Propagation Requirements

SYNC-ID: product_authority_evidence_status_propagation
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/test_product_repository_authority.sh,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/test_dashboard_data.sh,tools/test_dashboard_schema.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

Product authority must report product evidence accurately before dashboard context or workflow automation relies on it.
This implemented work was the second priority because incorrect evidence aggregation would make later dashboard and free-development displays authoritative-looking but wrong.

Required outcomes:

- Multiple product evidence rows must produce valid JSON.
- Required evidence with `failed`, `blocked`, `unknown`, `stale`, or `not_run` state must become product-operation blocker or manual-required state as appropriate.
- Context-mismatched evidence must not be treated as healthy evidence for the selected workflow context.
- Evidence status, freshness, authority, source id, required-in-context state, blocker reason, and next command preview must remain distinct fields.
- Product-operation blockers must remain scoped to product operations and must not block unrelated lesson-only progress.
- Dashboard-data must read product authority state but must not invent healthier status from missing or stale evidence.
- Tests must remain policy-driven and must not depend on one product stack, one wording, or one evidence row order.

Non-scope:

- Do not add evidence writing, GitHub polling, CI execution, Git fetch, or repository mutation to product authority.
- Do not remove root-level legacy product document compatibility.

## Implemented Free Development Product Repository Scaffold Requirements

SYNC-ID: free_development_product_repo_scaffold
STATUS: implemented
ARTIFACTS: free-development/FREE_DEVELOPMENT_MODE.md,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,tools/free-development,tools/product-improvement,tools/external-integration,tools/product-scaffold-check,tools/test_product_scaffold_check.sh,tools/test_product_gate_tools.sh,tools/test_product_repository_authority.sh,tools/check_workflow_pair_sync.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_product_scaffold_check.sh,tools/test_product_gate_tools.sh,tools/test_product_repository_authority.sh,tools/check_workflow_pair_sync.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

Free Development Mode must create and validate external product repositories with the same operational clarity as the STEP 1-14 product repository while allowing stack-specific additions.
This implemented work was the third priority because selected-context dashboard display needs external repositories to expose a clear product skeleton and source authority.

Required outcomes:

- Keep product repository roots lean and predictable.
- Place product design documents under `docs/product/`, workflow documents under `docs/workflow/`, memory and recovery documents under `docs/memory/`, and operation declarations under `ops/`.
- Keep root-level `AGENT.md`, `README.md`, selected entry files, and standard control directories discoverable.
- Declare entrypoint, runtime source, test source, CI, security, dashboard, and integration evidence through manifests rather than fixed stack-specific branches.
- Block root-level duplicate product documents under the current `product_repository_canonical_docs_only` contract.
- Let Free Development, Product Improvement, and External Integration share the same product repository authority model.
- Ensure scaffold validation is standalone-runnable and aggregate-runnable.
- Expose scaffold validation through `tools/product-scaffold-check` and `tools/test_product_scaffold_check.sh`, and keep those runtime artifacts recorded in the sync contract artifacts and tests.

Non-scope:

- Do not copy the entire lesson repository structure into external product repositories.
- Do not require one product stack, one framework, one language, one CI provider, or one generated app shape.

## Implemented Dashboard Control Center Selected Context Sync Requirements

SYNC-ID: dashboard_control_center_selected_context_sync
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

The dashboard control center must use a selected context data contract so the top-level menu selection, product repository, workflow context, lesson progress, Git state, CI state, Security state, evidence, blockers, and next safe action describe the same current target.
This implemented work is additive to the implemented dashboard data layer, live snapshot sync, mock-aligned Overview, detail-page mock parity, and external product repository authority.
This implemented work was the fourth priority in the current sequence and consumes the launch-quality, evidence-status, and scaffold contracts rather than absorbing their responsibilities.

Required outcomes:

- Add producer-owned `selected_context` and `available_contexts` data before the browser UI relies on menu selection.
- Resolve STEP 1-7, STEP 1-14, applied lessons, Free Development, Product Improvement, External Integration, and lesson-repository improvement through a shared context resolver rather than fixed UI branches.
- Keep `task-tracker-repository` as the STEP 1-14 standard product repository while allowing other product repositories to be selected by context without hard-coded repo-name assumptions.
- Remove the `product-improvement` dashboard-data fixed context by passing the selected workflow context to product authority, Git, CI, and Security status readers.
- In this requirement, status readers are read-only readers of existing settings, manifests, and evidence; they are not command executors and must not run Git, GitHub, CI, product-security, product-authority, or shell commands.
- Preserve product authority evidence states, including `failed`, `blocked`, `stale`, and `not_run`, and surface product-operation blockers without blocking unrelated lesson-only progress.
- Keep dashboard-data and browser pages read-only; they may read existing settings, manifests, and evidence but must not run Git, GitHub, CI, shell, product-security, product-authority checks, or evidence writers.
- Separate true Partial Failures from optional, cached, or not-yet-collected manual follow-ups.
- Display Git management settings and Security checks as cross-cutting selected-context status, with details distributed through workflow, maintenance, and safety pages.
- Use the `mock-context-*` images as UI/UX source references for intuitive non-engineer comprehension while keeping generated images out of pixel-perfect automated contracts.
- Keep English as the repository-standard source data language and use the existing UI-locale boundary for fixed labels and known control-center labels.

Non-scope:

- Do not add browser command execution, POST-based dashboard actions, automatic push, merge, remote deletion, OAuth, GitHub API calls, or live authoritative CI/Git polling.
- Do not remove root-level legacy product document compatibility.
- Do not weaken STEP 1-7, STEP 1-14, existing CI, existing checks, existing document routes, Git hooks, pre-commit, or dashboard read-only boundaries.
- Do not depend on one product stack, one repository name, one language, one fixture, or one specific UI phrase.

Required verification:

- Product authority tests must cover multiple evidence rows, failed/blocked/stale/not-run evidence, and context-specific blockers.
- Dashboard schema and data tests must cover selected context, available contexts, context-specific product authority, and safe status vocabulary.
- Browser control-center tests must cover the selected-context selector, mock-context-aligned summaries, read-only behavior, Partial Failures none state, blocker/manual-follow-up separation, and no command execution.
- Synchronization checks must keep this implemented work coherent across the five synchronized documents and sync contract.

## Implemented Dashboard Control Center Context Mock Source Of Truth Requirements

SYNC-ID: dashboard_control_center_context_mock_source_of_truth
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

The dashboard control center must treat `mock-context-overview.png`, `mock-context-lessons.png`, `mock-context-workflow.png`, `mock-context-maintenance.png`, and `mock-context-safety.png` as the UI/UX source of truth for the current control-center redesign.
This implemented work is additive to selected-context sync and must not trade away STEP 1-7, STEP 1-14, existing CI, existing checks, existing document routes, live snapshot sync, localization boundaries, or the read-only dashboard safety model.

Required outcomes:

- Rebuild the browser control-center information architecture around the five `mock-context-*` images rather than extending the older categorized dashboard layout.
- Render a detailed left sidebar with the mock-aligned main navigation, repository group, other/help group, active-page visual identity, and read-only notice.
- Render the Overview with a visible header, seven menu tiles, selected-context strip, four current-status cards, Git management settings, Security confirmation, four Explore Pages cards, and a concise read-only control-panel notice.
- Render Lessons, Development Workflow, Maintenance Sync, and Safety Confirmation as page-specific mock-aligned surfaces that explain what is checked, what can be judged, what needs review, and what safe next step exists.
- Keep all progress numbers, status values, blockers, Git/CI/Security state, Partial Failures, command previews, maintenance evidence rows, and current-step fields producer-owned rather than hard-coded from a screenshot.
- Extend dashboard data only through schema-backed, reusable, policy-aware fields that connect to existing settings, shared libraries, repo-local skills, checks, and fixtures.
- Keep fixed UI labels behind the existing UI-locale boundary. Repository source data remains English; lesson/workflow display language and product development language remain workflow settings and must not be confused with the control-panel UI locale.
- Preserve Partial Failures as true failed, blocked, or unknown current-context conditions. Optional, cached, not-run, or manual-required checks must not be visually promoted to healthy or hidden as no-failure state.
- Keep command previews display-only and non-executable.
- Add tests that validate mock-aligned structure and safety behavior without making generated images pixel-perfect automated oracles.

Non-scope:

- Do not add browser command execution, POST actions, live GitHub/CI polling, Git fetch, product-security execution, product-authority execution, evidence writing, push, merge, remote deletion, OAuth, token handling, or destructive operations.
- Do not encode one product stack, one repository name, one language, one fixture, one Japanese phrase, or one screenshot value as runtime logic.
- Do not remove root-level legacy product document compatibility.
- Do not weaken existing dashboard-data ownership, live snapshot sync, command-preview isolation, Git hooks, pre-commit, CI, or as-built synchronization.

Required verification:

- Dashboard schema and data tests must cover any new producer-owned fields used by the mock-aligned UI.
- Browser control-center tests must cover sidebar groups, seven menu tiles, selected context, four Overview status cards, page-specific detail layouts, read-only behavior, no command execution, i18n labels, and mobile no-overflow.
- Synchronization checks must pass before runtime implementation starts.

## Implemented Dashboard Control Center Exact Mock Alignment Correction Requirements

SYNC-ID: dashboard_control_center_mock_exact_alignment_correction
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,free-development/FREE_DEVELOPMENT_MODE.md,templates/TEMPLATES.md,lesson/SYNC_GATES_14_DAYS.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/lib/product_repository_authority.sh,tools/free-development,tools/product-improvement,tools/external-integration,tools/product-scaffold-check,tools/product-launch-check,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

The dashboard control center implemented a corrective pass because the earlier mock-source work did not satisfy developer visual review for exact mock-aligned design, color contrast, icon treatment, content amount, and non-engineer comprehension.
This implemented correction treats the five current `mock-context-*` files as the human UI/UX source of truth while keeping dashboard state producer-owned and the browser read-only.

Required outcomes:

- Keep this explicit correction sync ID separate from earlier implemented dashboard mock-parity IDs.
- Preserve STEP 1-7, STEP 1-14, existing CI, existing checks, existing document routes, Git hooks, pre-commit, live snapshot sync, localization boundaries, and dashboard read-only behavior.
- Align Overview, Lessons, Development Workflow, Maintenance Sync, and Safety Confirmation with the current mocks for layout, density, color contrast, icon shape, icon background fill or transparency, sidebar content, and displayed content amount.
- Replace generic dashboard detail structures where they obscure page-specific judgment with page-specific structures that match what each mock is designed to make understandable.
- Keep fixed labels in the control-panel localization layer and keep repository source data English by default; do not confuse control-panel UI locale with lesson display language or product development language settings.
- Make menu selection a selected-context display concern backed by producer-owned data rather than browser-invented state.
- Require displayed menu choices to have complete producer-owned context data or an explicit incomplete state before the UI treats them as selectable live contexts; a thin menu id/status list is not enough for the corrected runtime.
- Ensure Git, CI, Security, product evidence, blockers, current step, command previews, and Partial Failures are shown from schema-backed producer data or as safe `blocked`, `unknown`, `manual_required`, `not_run`, or `stale` states.
- Propagate external product repository evidence into selected-context Git, CI, and Security status instead of leaving those cards at policy or snapshot defaults.
- Treat required product evidence as ready only when the evidence is current and authoritative; advisory, cached, stale, not-run, blocked, failed, or unknown required evidence must not be promoted to healthy dashboard state.
- Ensure page-level lesson, maintenance, and safety card descriptions are grounded in producer-owned status, evidence rows, snapshot identity, or security rows rather than fixed success or pending prose.
- Keep external product repository handling policy-driven and manifest-backed so Free Development, Product Improvement, and External Integration do not fall back to fixed `task-tracker-repository` or root-document assumptions.
- Keep `docs/memory/` as part of the standard external repository scaffold shape while allowing individual memory files to remain optional until the product workflow uses them.
- Strengthen product launch and scaffold requirements without introducing one stack, one framework, one product name, one screenshot value, one language phrase, or one fixture-only case.

Non-scope:

- Do not add browser command execution, POST actions, GitHub or CI polling, Git fetch, product-security execution, product-authority execution, evidence writing, push, merge, remote deletion, OAuth, token handling, destructive operations, or cleanup automation.
- Do not create pages for repository information, documents, settings, help, or changelog until corresponding mocks and requirements exist.
- Do not delete root-level legacy product document compatibility.
- Do not make generated mock images pixel-perfect automated test oracles.

Implemented verification:

- The five synchronized documents and sync contract agree on this implemented sync ID.
- Dashboard schema, dashboard data, dashboard browser control-center, product authority, scaffold, launch, product gate, STEP 1-14 sync, STEP 1-14 aggregate, and as-built synchronization checks are required for this implemented state.
- Runtime checks remain targeted to the changed producer, UI, product repository, and STEP 1-14 launch-quality surfaces under AGENTS.MD local-verification scope rules.

## Implemented Dashboard Lessons Page Exact Mock Alignment Requirements

SYNC-ID: dashboard_control_center_lessons_page_exact_mock_alignment
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

The completed dashboard UI/UX task focused on the Lessons page and treated `dashboard-control-center/mocks/mock-context-lessons.png` as the human design source of truth.
The goal was to make the Lessons page match the mock in visible hierarchy, content amount, color contrast, icon shape, icon background fill or transparency, and responsive behavior before broad verification.

Required outcomes:

- Preserve the already implemented Overview, Development Workflow, Maintenance Sync, Safety Confirmation, selected-context sync, live snapshot sync, product authority behavior, and read-only browser boundary.
- Align the Lessons page with the mock for page header, common status area, menu selection presentation, lesson-progress presentation, lesson rows, status or evidence cards, action affordances, icon identity, spacing, and responsive layout.
- Keep the page understandable without explanatory text outside the mock-backed hierarchy.
- Keep displayed lesson status, current step, progress, blockers, approvals, language settings, follow-up states, and repository facts producer-owned and schema-backed.
- Keep fixed control-panel labels in the localization layer; do not confuse UI locale with lesson display language or product development language settings.
- Use shared components and design tokens only when they improve exact mock fidelity, reuse, and maintainability without adding fixed screenshot values or one-off branches.

Non-scope:

- Do not redesign other pages except for non-breaking shared tokens or components needed to keep the mock family consistent.
- Do not add browser command execution, POST actions, GitHub or CI polling, product-security execution, product-authority execution, evidence writing, push, merge, remote deletion, OAuth, token handling, destructive operations, or cleanup automation.
- Do not create repository information, documents, settings, help, or changelog pages.
- Do not weaken STEP 1-7, STEP 1-14, existing CI, existing checks, Git hooks, pre-commit, live snapshot sync, as-built synchronization, or canonical product document enforcement.

## Implemented Dashboard Control Center Visual Refinement Follow-up Requirements

SYNC-ID: dashboard_control_center_visual_refinement_followup
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/memory/DEVELOPER_MEMORY.md,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

The dashboard control center must preserve the mock-backed design while incorporating developer visual review refinements across Lessons, Development Workflow, Maintenance Sync, Safety Confirmation, and the shared sidebar.
This implemented follow-up is additive to the exact mock alignment correction and does not change the read-only dashboard boundary.

Required outcomes:

- Use the same sidebar menu structure, grouping, active state, and brand color on every dashboard page.
- Keep Lessons and Overview progress animation restrained: it runs once, counts numbers in under one second, and does not animate icons, percentages, gradients, fades, or shine effects.
- Render lesson progress cards with plain white backgrounds, solid progress bars, clear numerator/denominator weight, three lesson choices, and responsive stacking before cramped text appears.
- Keep Workflow, Maintenance, Safety, and Lessons bottom notices visually consistent.
- Make Maintenance source and reference values copyable with copy icons outside the value field, one-line ellipsis, and keyboard or hover tooltip bubbles with a small pointer.
- Make Safety command previews display-only, vertically stacked above Security policy, larger and more readable, with copy controls outside the command field and the same tooltip behavior as Maintenance references.
- Use non-engineer-readable localized fixed labels for known control-center concepts, including security gates, failures or blocking state, approval-required details, and maintenance evidence labels.
- Preserve producer-owned dashboard data and do not invent Git, CI, Security, lesson, evidence, or blocker state in React.
- Preserve responsive no-overflow behavior across desktop, tablet, narrow desktop, and phone widths.

Non-scope:

- Do not add browser command execution, POST actions, live Git/GitHub/CI polling, product-security execution, product-authority execution, evidence writing, push, merge, cleanup, remote deletion, OAuth, token handling, or destructive operations.
- Do not create runtime pages for repository information, documents, settings, help, or changelog.
- Do not make generated mock image equality an automated test oracle.

## Implemented Menu Product Display Profile Confirmation Requirements

SYNC-ID: menu_product_display_profile_confirmation
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/MENU_PRODUCT_PROFILE_POLICY.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/lesson_common.sh,tools/lib/product_repository_authority.sh,tools/product-profile,tools/menu,tools/lesson,tools/lesson14,tools/free-development,tools/product-improvement,tools/external-integration,tools/team-development,tools/product-scaffold-check,tools/test_menu_prerequisites.sh,tools/test_lesson.sh,tools/test_lesson14.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_menu_prerequisites.sh,tools/test_lesson.sh,tools/test_lesson14.sh,tools/test_dashboard_data.sh,tools/check_lesson_structure.sh,tools/check_agents_skills.sh

The seven progress-menu choices must confirm the learner-visible product name or work-target name before the workflow can proceed.
The dashboard must display that name from a producer-owned profile, not from repository names, UI inference, or prose extraction.

Required outcomes:

- Store product display identity in a small confirmed profile rather than hard-coding `タスク管理表` or any other product name in React.
- Use `docs/workflow/MENU_PRODUCT_PROFILE_POLICY.tsv` for menu-specific scope and recommendation text.
- Use external product repository `ops/PRODUCT_PROFILE.json` for menu items 1 through 6 and a lesson-repository learning profile for menu item 7.
- Treat STEP 1-14's recommended name as `タスク管理表` only as a policy-backed recommendation that still requires confirmation.
- Keep free development and product improvement name entry blank unless a confirmed profile already exists.
- Keep fixed dashboard labels localized by environment while preserving producer-owned product names as profile data.
- Validate the profile as data only; do not execute commands, read secrets, call APIs, poll GitHub, or write evidence from the dashboard.

Non-scope:

- Do not make the dashboard a profile editor.
- Do not infer a confirmed product name from requirements, specification, implementation plan, repository path, branch name, or file tree.
- Do not require menu 7 to use the external product repository.

## Implemented Product Repository Canonical Docs Only Requirements

SYNC-ID: product_repository_canonical_docs_only
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_REPOSITORY_FORBIDDEN_ROOT_PATHS.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,prompts/PROMPTS.md,prompts/PROMPTS_14_DAYS.md,lesson/LESSON_FLOW.tsv,lesson/LESSON_FLOW_14_DAYS.tsv,lesson/SYNC_GATES_14_DAYS.tsv,playbooks/AGENT_PLAYBOOK.md,playbooks/AGENT_PLAYBOOK_14_DAYS.md,templates/TEMPLATES.md,skills/task-tracker-docs/SKILL.md,skills/task-tracker-docs/references/product-docs.md,skills/worklog-doc-sync/SKILL.md,skills/worklog-doc-sync/references/worklog-sync.md,skills/lesson-sync-gate/SKILL.md,skills/lesson-sync-gate/references/sync-gates.md,skills/learning-progress-helpdesk/references/progress-helpdesk.md,tools/lib/product_repository_authority.sh,tools/product-scaffold-check,tools/product-improvement,tools/external-integration,tools/dashboard-data,tools/dashboard,tools/check_workflow_pair_sync.sh,tools/check_agents_skills.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_security.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_security.sh,tools/check_agents_skills.sh,tools/test_dashboard_data.sh,tools/test_lesson14.sh,tools/check_lesson_structure.sh,tools/check_lesson14_sync.sh

External product repositories must use canonical documentation paths for product, workflow, and memory documents.
Root-level duplicate Markdown documents are not accepted as compatibility fallbacks because they hide drift, confuse the dashboard, and can cause agents to update the wrong file.

Required outcomes:

- Treat `docs/product/REQUIREMENTS.md`, `docs/product/SPECIFICATION.md`, and `docs/product/IMPLEMENTATION_PLAN.md` as the only product design document locations.
- Treat `docs/workflow/TASK_TRACKER.md` and `docs/workflow/HANDOFF.md` as the only product workflow pair locations.
- Treat product memory files as `docs/memory/*` documents when used, including developer, session, and failure memory.
- Keep root `AGENT.md` and `README.md` as the standard root-level product entry files.
- Expose forbidden root duplicate paths as a reusable TSV policy instead of hard-coded one-off branches.
- Make authority, scaffold, dashboard data, workflow-pair sync, prompts, playbooks, and skills all point to the same canonical product paths.
- Keep the dashboard and lesson flows read-only with respect to product documents; they may report blockers but must not repair product repositories automatically.

Non-scope:

- Do not delete or rewrite external product repository content unless the operation is explicitly part of product repository maintenance.
- Do not relax repository boundary checks, approval requirements, security checks, Git/CI gates, or product profile validation.
- Do not trade off existing STEP 1-7, STEP 1-14, dashboard read-only behavior, localization, or product authority evidence semantics.

## Implemented Dashboard Control Center Documents Guided Catalog Requirements

SYNC-ID: dashboard_control_center_documents_guided_catalog
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/dashboard_data.sh,tools/lib/document_paths.sh,tools/lib/product_repository_authority.sh,tools/dashboard-data,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

The dashboard control center must make the Documents page a guided, read-only document navigation surface rather than a flat file list or a maintenance evidence surface.
This implemented work is additive and must not trade away STEP 1-7, STEP 1-14, existing CI, existing checks, existing document routes, docs-tour behavior, repository information, maintenance sync, safety confirmation, Git hooks, pre-commit, localization boundaries, or dashboard read-only ownership.

Required outcomes:

- Present documents by learner intent, such as confirming what is being built, checking current progress, understanding decision history, and finding help when stuck.
- Keep Git/CI status, evidence rows, command previews, source-command details, and security gate details on their dedicated pages instead of making them the Documents page's primary content.
- Add a producer-owned documents catalog to dashboard data before the browser UI depends on document groups, status, priority, or related-page routing.
- Keep document structure data in existing dashboard data/schema paths and shared dashboard data helpers; do not add React-only fixed document arrays.
- Use localized fixed labels for known dashboard concepts while keeping file paths, ids, command text, and repository facts as sanitized producer data.
- Show non-engineer-readable display names in the primary UI, with concrete file paths available as secondary copyable or tooltip-backed details.
- Preserve existing `tools/docs-tour`, `guides/DOCUMENT_MAP.md`, `tools/dashboard docs`, maintenance source grounding, and repository information behavior.
- Keep any new document validation runnable standalone and connectable to aggregate checks if a new test entry point is introduced later.

Non-scope:

- Do not add browser command execution, POST actions, live Git/GitHub/CI polling, evidence writing, document editing, product repository mutation, cleanup, merge, push, OAuth, token handling, or destructive operations.
- Do not infer document meaning from one product stack, one repository name, one fixture, one language phrase, or one exact UI sentence.
- Do not remove existing docs-tour, dashboard-data, maintenance, safety, repository information, or update-history routes.
- Do not accept any existing-feature tradeoff to simplify the Documents page.

## Implemented Agent Escalated Verification Policy Requirements

SYNC-ID: agent_escalated_verification_policy
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv
TESTS: tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_agents_skills.sh

Agents must not waste verification time by first running known sandbox-incompatible, non-destructive visual or environment checks without the required execution scope.
When the work requires Playwright/Chromium screenshots, browser-based visual inspection, local port observation, or equivalent non-destructive environment observation that is known to need escalated execution in this environment, the agent must run it with the required execution scope from the start and complete the evidence-gathering step before reporting design conclusions.

Required outcomes:

- Treat Playwright/Chromium real-screen inspection as evidence only after the browser has actually launched, the page has loaded, and screenshots or equivalent observations have been collected.
- Run known sandbox-incompatible, non-destructive checks with the required execution scope from the first attempt instead of failing once and retrying.
- Do not ask for a separate developer policy decision before these non-destructive verification commands when the active task already requires the check.
- Preserve minimum necessary verification scope; this policy does not authorize broad, unrelated, or heavy tests.
- Keep dangerous, credential-bearing, destructive, write-heavy, external-service, dependency-changing, push, merge, cleanup, delete, and CI-failure override actions outside this exception.

Non-scope:

- Do not weaken authentication, secret handling, destructive-operation, external repository, Git/CI, pre-commit, repository-boundary, or security-gate approval rules.
- Do not treat screenshot capture as permission for browser command execution, POST requests, live GitHub/CI polling, evidence writing, dashboard mutation, or product repository mutation.
- Do not replace developer visual judgment with screenshot equality tests or claim visual parity without inspecting the captured page.

## Implemented Dashboard Control Center Settings Safe Change Requirements

SYNC-ID: dashboard_control_center_settings_safe_change_plan
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/lib/dashboard_data.sh,tools/lib/git_workflow_policy.sh,tools/dashboard-data,tools/dashboard-settings,tools/dashboard-control-center,vite.config.mjs,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh
TESTS: tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_git_workflow_policy.sh,tools/test_lesson.sh,tools/test_lesson14.sh,tools/test_menu_prerequisites.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh

The Settings page must be a non-engineer-readable surface for reviewing and changing allowlisted lesson and workflow settings through a narrow repo-local settings update path.
This implemented work is additive and must not trade away STEP 1-7, STEP 1-14, existing CI, existing checks, existing document routes, repo-local skills, Git hooks, pre-commit, localization boundaries, or existing read-only pages outside the Settings allowlist.

Required outcomes:

- Show the current selected menu, workflow context, target repository, product type, and freshness from producer-owned dashboard data so the user knows which settings are being inspected.
- Replace the current status-only Settings card gallery with readable setting rows that expose the current value, status, source, changeability, and related page for context, learning, workflow, and safety settings.
- Add a schema-backed `settings` catalog before the browser UI depends on setting groups, values, allowed values, editability, approval level, or update previews.
- Keep `tools/dashboard-data` read-only. It may emit the settings catalog from existing settings, policies, selected context, and status sources, but it must not write settings, refresh evidence, or execute live checks.
- Treat a larger Settings popup as a review and confirmation surface. It must show current value, proposed value, impact, target file, required confirmation, validation state, and safe update preview before applying any change.
- Implement actual writes only through `tools/dashboard-settings` and the Vite `/dashboard-settings/plan` and `/dashboard-settings/apply` middleware; the browser must not write files directly, run arbitrary tools, accept arbitrary paths, or execute shell text.
- Accept Settings mutation requests only as same-origin `application/json` POSTs to the implemented plan/apply endpoints, and reject cross-origin or non-JSON browser mutation attempts before invoking the update tool.
- Restrict editable settings to allowlisted, reusable settings such as lesson learning mode, workflow display language, product development language, and safe Git workflow settings that already have policy-backed storage.
- Treat the workflow display language setting as the source for lesson guidance, workflow display text, and Dashboard Control Center fixed UI labels where dashboard translations exist.
- Emit the selected workflow language and the resolved dashboard UI locale from producer-owned dashboard data so React does not infer the Settings result from browser language alone.
- `tools/dashboard-settings apply ... --confirm` must validate the setting id, value, menu id, target file, and dashboard snapshot output boundary, write through a same-directory temporary file plus atomic rename, and regenerate the dashboard snapshot after a successful write.
- After a successful Settings apply, the browser must refetch the regenerated dashboard snapshot immediately and update fixed UI labels without a full page reload; periodic polling remains a fallback, not the primary apply feedback path.
- Treat product or work target naming as display-only in this sync ID. Any future naming write path must use the existing product-profile authority, repository-boundary checks, and a separate approved write contract.
- Keep approval state, Git/CI execution, merge, push, cleanup, deletion, evidence writing, product-security gates, GitHub polling, OAuth, secrets, and external service operations outside editable Settings rows.
- Use existing setting files, shared libraries, validation commands, repo-local skills, aggregate-capable tests, CI, and pre-commit wiring; do not add fixed values, one-off branches, one stack, one product name, one language phrase, or one fixture-only case.
- Dashboard fixed-label dictionaries now follow `dashboard_control_center_full_locale_ui_support`: all standard lesson language codes resolve to matching Dashboard UI dictionaries, while unsupported custom language values remain workflow-language records unless a later locale policy promotes them.

Non-scope:

- Do not make the browser dashboard a general editor or command runner.
- Do not weaken the existing GET/read-only data-serving guard, browser command execution guard, or display-only command preview contract outside the implemented Settings plan/apply endpoints.
- Do not move Git/CI run history, evidence tables, dangerous-operation execution, repository file-tree education, document catalog behavior, or update history into the Settings page.
- Do not implement external product repository mutation, approval-state mutation, security-gate mutation, Git/CI execution, network polling, push, merge, cleanup, deletion, OAuth, or credential handling from Settings.

## Implemented Dashboard Control Center Full Locale UI Support Requirements

SYNC-ID: dashboard_control_center_full_locale_ui_support
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/lib/lesson_common.sh,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/dashboard-settings,tools/dashboard-control-center,tools/test_dashboard_i18n.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh,tools/test_lesson_repository.sh,vite.config.mjs,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js
TESTS: tools/test_dashboard_i18n.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh

Dashboard Control Center treats the Settings-selected learning and workflow display language as the Dashboard fixed UI language for every standard lesson language, not only Japanese and English.
This implemented work extends the implemented Settings safe-change path and must not trade away STEP 1-7, STEP 1-14, existing CI, existing checks, document routes, repo-local skills, Git hooks, pre-commit, the safe Settings writer, or read-only dashboard pages outside the allowlisted Settings mutation boundary.

Required outcomes:

- Support Dashboard fixed UI labels for the standard language set `ja`, `en`, `ko`, `zh-CN`, `zh-TW`, `es`, `pt-BR`, `fr`, `de`, `id`, `vi`, `th`, `hi`, and `ar`, while preserving the existing `zh` to `zh-CN` alias and existing custom-language recording behavior for lesson settings.
- Keep one shared locale policy for language codes, aliases, browser `Intl` locale ids, text direction, native display name, and English display name; do not duplicate independent language lists in React, shell, schema, fixtures, and tests.
- Let the workflow display language row control lesson guidance, workflow display text, and Dashboard fixed UI labels when the value is one of the supported standard codes.
- Keep the product development language setting separate from Dashboard UI language; it describes the language used in generated product artifacts and must not drive the Dashboard shell.
- After Settings apply succeeds, update the Dashboard fixed UI language in React immediately from the validated apply response, then refetch the regenerated snapshot as authoritative data. Do not change visible UI language before the server-side apply path succeeds.
- Keep the existing snapshot refetch and polling paths as recovery and authority checks, but do not require a full page reload for language changes.
- Add a short Settings-page notice explaining that some data can take a moment to refresh and that the Dashboard updates automatically after the setting is applied.
- Preserve safe fallbacks for legacy snapshots that lack full locale metadata, but do not silently reduce a supported standard language to English once a matching dictionary is required by this sync ID.
- Add Arabic right-to-left support for Dashboard chrome while keeping file paths, commands, ids, hashes, branch names, code, and other technical values readable in left-to-right isolation.
- Keep translations behind the existing dashboard localization boundary. Repository facts, source paths, command previews, ids, and evidence remain sanitized producer data and must not be translated by ad hoc runtime logic.
- Use curated static dictionaries and validation; do not call automatic translation services, external APIs, network services, or model-generated translation at runtime.
- Keep regular CI time bounded by static dictionary completeness checks and representative browser coverage. Full all-language browser smoke is a release or explicit final-gate activity, not a routine per-change explosion.
- The localization check runs standalone and is callable from aggregate dashboard or final-gate tests.

Non-scope:

- Do not add browser file writes, arbitrary command execution, live Git/GitHub/CI polling, evidence writing, approval-state mutation, product repository mutation, push, merge, cleanup, deletion, OAuth, token handling, or credential handling.
- Do not use language-specific component branches, stack-specific fixtures, exact phrase-only assertions, or one-off hardcoded cases as the main implementation strategy.
- Do not weaken the implemented Settings plan/apply same-origin JSON POST boundary, `execFile` use, allowlisted setting ids, atomic writes, snapshot output boundary, or malformed data validation.
- Do not make unsupported custom language values require a full Dashboard dictionary in this sync ID; custom values remain recorded workflow data unless later promoted through a separate approved locale policy.

## Implemented Dashboard Control Center Settings Apply Feedback Requirements

SYNC-ID: dashboard_control_center_settings_apply_feedback
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_i18n.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_control_center.sh
TESTS: tools/test_dashboard_i18n.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh

Settings apply feedback must make the difference between saved settings and Dashboard snapshot reconciliation clear to non-engineer users.
This implemented work is an additive UX follow-up to `dashboard_control_center_settings_safe_change_plan` and `dashboard_control_center_full_locale_ui_support`; it must not trade away STEP 1-7, STEP 1-14, existing CI, existing checks, existing document routes, repo-local skills, Git hooks, pre-commit, localization boundaries, or the implemented Settings mutation boundary.

Required outcomes:

- After a successful Settings apply, show progress for Dashboard reflection only when reconciliation takes longer than a short named UI-policy delay; instant reflection should not be slowed by a forced modal.
- Treat Settings save success and snapshot reflection confirmation as separate user-visible states. Do not present snapshot reflection as complete until a refetched snapshot confirms the requested value.
- Keep the refetched snapshot authoritative. If a successful apply response and the refetched snapshot disagree, the snapshot wins and the UI shows a safe visible warning instead of keeping an unverified optimistic state.
- For ordinary editable settings, confirm reflection by matching the requested setting id and value against the Settings row in the refetched snapshot.
- For `workflow_language`, additionally confirm `summary.workflow_language`, `summary.display_locale`, `summary.ui_locale`, `summary.ui_direction`, and the Settings row so Dashboard UI language, direction, and settings data converge.
- Close or move away from the existing confirmation dialog before showing apply feedback so the existing focus trap is not nested with a second modal.
- Use a non-modal status window or equivalent small status surface with accessible live-region semantics for normal progress; use an alert state only for timeout, mismatch, or refresh failure.
- Preserve no-reload language switching. The UI may switch from validated apply metadata after server success, but the snapshot remains the final reconciliation source.
- Remove the row-level `確認のみ` and `ここで変更可能` chips from Settings rows. Keep status pills, and move changeability into the right-end action area and accessible row label.
- Show editable rows as `ここで変更可能` in the right-end action area and review-only rows as `確認`, using localized labels and wrapping-safe layout for long standard-language labels.
- Increase the Settings confirmation eyebrow text, such as `設定確認`, slightly without changing the modal title hierarchy, body text, buttons, or compact mobile layout.
- Add any new fixed labels to the existing Dashboard dictionary completeness path for all standard Dashboard UI locales.

Non-scope:

- Do not add browser mutation routes, new writers, new dependencies, external services, automatic translation, runtime translation APIs, evidence writing, Git/GitHub/CI execution, approval-state mutation, push, merge, cleanup, deletion, OAuth, credentials, or external product repository writes.
- Do not reduce or remove existing editable Settings capability in this sync ID. If a future safety review proposes changing currently editable Git workflow settings to display-only, treat that as a separate approval-required contract because it may trade off implemented behavior.
- Do not broaden the snapshot schema, Settings writer allowlist, Vite middleware responsibilities, CI/pre-commit coverage, or test-plan wiring unless the existing contract cannot satisfy this UX feedback safely.
- Do not depend on one language phrase, one fixture, one product stack, or one exact text assertion as the primary guarantee.

## Implemented Dashboard Control Center Settings Consistency Gate Requirements

SYNC-ID: dashboard_control_center_settings_consistency_gate
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,tools/lib/git_workflow_policy.sh,tools/git-workflow,tools/dashboard-settings,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_git_workflow_policy.sh,tools/test_dashboard_i18n.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh
TESTS: tools/test_git_workflow_policy.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_i18n.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh

The Settings page prevents users from applying combinations that make the Dashboard workflow impossible, misleading, or unsafe while preserving the implemented safe Settings writer and current non-Settings behavior.
This implemented work is additive and must not trade away STEP 1-7, STEP 1-14, existing CI, existing checks, existing document routes, repo-local skills, Git hooks, pre-commit, localization, or read-only dashboard pages outside the implemented Settings mutation boundary.

Required outcomes:

- Validate Settings changes against the candidate full settings state before writing, not only against the single changed value.
- Reject candidate Git workflow settings that leave no approved write path, including `branch_allowed=false` together with `main_direct_work_allowed=false`; `worktree_allowed` must not be treated as an independent write path unless a later approved detached-worktree policy explicitly defines that behavior.
- Reject candidate settings where branch-dependent automation is enabled while normal branch work is disallowed. The implemented gate treats `pr_creation=auto`, `pr_ci_monitoring=auto`, and `merge_execution=after_approval` with `branch_allowed=false` as write-time errors; already persisted inconsistent states are displayed as blocked while still allowing recovery changes.
- Allow users to recover from an already inconsistent settings file by accepting changes that move the full candidate state to a valid state.
- Keep `automation_level` compatible with the current policy model: it may remain a preset or summary while detailed action settings provide explicit behavior. Turning it into a hard upper bound requires separate developer approval.
- Do not silently change the runtime precedence between `merge_execution=manual` and `developer_auto_merge_allowed=true`. Until the developer approves new precedence, the Dashboard must not present the combination as ready automation; it must show a qualified non-ready state such as approval-required, manual-required, or blocked while preserving the existing runtime behavior.
- Show effective workflow status, reason, and next safe action from producer-owned data so a non-engineer can understand whether a setting is ready, blocked, waiting for approval, manual-only, optional, or not applicable.
- Keep Settings write authority in `tools/dashboard-settings` and reusable validation in the owner layer, especially `tools/lib/git_workflow_policy.sh`; React may display validation results but must not be the source of policy truth.
- Keep lesson and workflow language settings separate from product development language while showing the effective Dashboard UI language from the existing full-locale policy.
- Show context-dependent rows as `not_applicable` or blocked when the selected menu does not require a product repository, uses the lesson repository as the work target, or needs an external integration context.
- Separate learner approval status from missing or unknown approval evidence so the Dashboard does not show an approval-dependent workflow as ready when the source is absent.
- Use reusable schema/status fields and tests; do not encode one product name, one stack, one Japanese or English phrase, one fixture value, or one special menu as the main guarantee.

Non-scope:

- Do not add browser mutation endpoints, writers beyond `tools/dashboard-settings`, dependencies, external services, live Git/GitHub/CI polling, evidence writing, approval-state mutation, push, merge, cleanup, deletion, OAuth, credentials, or external product repository writes.
- Do not reduce existing safe Settings editability merely by moving rows to display-only. If an existing editable setting needs a new safety rule, enforce it through candidate validation and clear recovery paths.
- Do not change destructive-operation policy, GitHub authority, approval receipt format, approval expiry, or HEAD-SHA binding in this sync ID; those security hardening items need a separate approved contract if runtime behavior must change.
- Do not weaken schema validation, same-origin JSON POST handling, `execFile`, atomic writes, snapshot output boundaries, CI, pre-commit, or aggregate test wiring.

## Implemented Product Workflow Git Usage Modes Requirements

SYNC-ID: product_workflow_git_usage_modes
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/MENU_PRODUCT_PROFILE_POLICY.tsv,docs/workflow/PRODUCT_WORKFLOW_GIT_USAGE_POLICY.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,learning/PRODUCT_WORKFLOW_GIT_USAGE_SETTINGS.tsv,learning/context/WORKFLOW_CONTEXT_MAP.tsv,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/lib/product_workflow_git_usage.sh,tools/free-development,tools/product-improvement,tools/external-integration,tools/check_repository_boundary.sh,tools/product-scaffold-check,tools/lib/product_security.sh,tools/product-security,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/dashboard-data,tools/dashboard-settings,tools/lib/dashboard_data.sh,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,vite.config.mjs,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tools/test_product_git_usage_modes.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_product_git_usage_modes.sh,tools/test_product_gate_tools.sh,tools/test_product_scaffold_check.sh,tools/test_product_security.sh,tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_settings.sh,tools/test_dashboard_i18n.sh,tools/test_dashboard_control_center.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_workflow_pair_sync.sh,tools/check_lesson_structure.sh

Free Development, Product Improvement, and External Integration support small external-product work that does not always need remote Git or CI while preserving the existing strict Git/CI workflow as the default.
This implemented work is additive and does not trade away STEP 1-7, STEP 1-14, existing CI, existing checks, existing document routes, repo-local skills, product-security checks, product authority, Settings writer safety, or Dashboard read-only behavior outside the allowlisted Settings mutation boundary.

Required outcomes:

- Add a product-workflow Git usage mode for product-scoped workflow contexts, separate from the existing Git workflow action settings.
- Support the implemented modes `none`, `local`, `remote_sync`, and `ci`.
- Keep the default mode equivalent to the current strict `ci` behavior so existing Free Development, Product Improvement, External Integration, STEP 1-7, STEP 1-14, Git sync, and CI gates do not weaken by default.
- Treat `none` as "Git/remote/CI not used", not as "no checks". Product workspace boundary, canonical product documents, scaffold authority, product-security checks, secret scanning, external-integration approval, and required local checks remain in force.
- Treat `local` as requiring a local Git worktree and local Git safety checks, without requiring remote sync or CI.
- Treat `remote_sync` as requiring local Git plus remote/upstream sync, without requiring CI unless the workflow separately selects `ci`.
- Treat `ci` as the current strict path: local Git, remote sync, and CI are required.
- Show Git and CI rows as required, optional, or not applicable from producer-owned dashboard data; React must not infer mode applicability from menu names or raw text.
- Let the Settings page change only the Git usage mode through a guarded, allowlisted Settings path when the selected workflow context supports it.
- Keep the existing Git workflow policy as the policy for actions when Git is used. Do not mix "whether Git is used" into `GIT_WORKFLOW_SETTINGS.tsv`.
- Do not create a new `.git`-less authoritative evidence store in this sync ID. When Git is not applicable, Git and CI evidence rows are represented as `not_applicable`; explicit developer approval remains required before accepting a replacement evidence storage, freshness model, or product-head binding design.

Non-scope:

- Do not remove or weaken current strict Git/CI completion gates by default.
- Do not change STEP 1-7 or STEP 1-14 lesson sync gates.
- Do not make Dashboard execute Git, CI, product-security, product-authority, product mutation, push, merge, cleanup, deletion, OAuth, external-service, or evidence-writing operations.
- Do not make React the source of product workflow policy truth.
- Do not reduce existing Settings editability, schema validation, same-origin JSON POST handling, `execFile`, atomic writes, snapshot output boundaries, CI, pre-commit, or aggregate-test coverage.

## Implemented Repository Development Workflow Workflow Skill Requirements

SYNC-ID: repository_development_workflow_skill
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/REPOSITORY_DEVELOPMENT_WORKFLOW.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,learning/REPOSITORY_DEVELOPMENT_APPROVALS.tsv,skills/repository-development-workflow/SKILL.md,skills/repository-development-workflow/references/repository-development.md,skills/repository-development-workflow/agents/openai.yaml,tools/lib/repository_development_workflow.sh,tools/repository-development-workflow,tools/check_repository_development_workflow.sh,tools/test_repository_development_workflow.sh,tools/check_agents_skills.sh,tools/test_lesson_repository.sh,tools/check_ci_workflow_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_repository_development_workflow.sh,tools/test_repository_development_workflow.sh

Lesson-repository development requires a repo-local workflow skill and mechanical policy support so agents can move from developer wall discussion to proposal, implementation planning, document synchronization, implementation, focused verification, release gates, PR/main CI, local/remote synchronization, and cleanup planning without weakening AGENTS.MD or existing lesson behavior.

Required outcomes:

- Provide a repo-local `repository-development-workflow` skill for this repository's own development work; it must support AGENTS.MD rather than replace it.
- Keep `worklog-doc-sync` as the product-document synchronization skill and `lesson-sync-gate` as the final lesson/gate closure skill. The new skill must route to them instead of absorbing their responsibilities.
- Define stable machine-readable phase ids for `context_triage`, `proposal`, `implementation_plan`, `fast_loop`, `mid_tests`, `release_gate`, and `main_sync_cleanup`.
- Separate implementation-time fast loops from release proof. Fast local checks may guide work, but release closure must still require the policy-defined sync, structure, aggregate, pre-commit/full, PR CI, main CI, local/remote sync, and cleanup confirmation.
- Provide a policy-backed source of truth, shared validation layer, CLI guidance/gate commands, standalone check, and regression test, then wire them into hooks, aggregate tests, CI, final-gate coverage, and repo-local skill discovery.
- Make all new checks callable directly and from aggregate checks.
- Validate malformed workflow policy rows, missing wiring, weakened AGENTS invariants, missing PR/main CI requirements, and unsafe cleanup guidance.
- Preserve STEP 1-7, STEP 1-14, existing CI, existing checks, existing document routes, repo-local skills, security gates, and document synchronization ownership boundaries.
- Treat branch, worktree, product-repository, remote, and cleanup deletion as approval-bound operations. The workflow may propose cleanup plans, but must not execute destructive cleanup without explicit developer approval.
- Avoid fixed one-off branching based on one product stack, one exact phrase, one menu, or one special case.

Non-scope:

- This implementation does not execute push, merge, main CI waiting, local/remote synchronization, branch deletion, worktree deletion, remote deletion, product-repository deletion, or cleanup deletion; those remain approval-bound closure-phase actions.
- The new workflow skill must not weaken AGENTS.MD, STEP 1-7, STEP 1-14, existing gates, Git hooks, pre-commit, CI, document routes, or existing repo-local skills.
- The new workflow skill must not create a shortcut around developer approvals, security gates, evidence requirements, destructive-operation policy, or final-gate proof.
