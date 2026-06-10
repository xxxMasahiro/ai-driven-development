# SPECIFICATION.md

## As-Built Components

### Lesson Control

- `tools/lesson` controls the 7-day lesson.
- `tools/lesson14` controls the 14-day lesson.
- `tools/lesson14 承認 <start|pass> <step_id> "memo"` records approval receipts.
- `tools/lesson 学習モード <A|B|C>` records and switches 7-day explanation depth.
- `tools/lesson 表示言語 <ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar>` records 7-day workflow display language.
- `tools/lesson 開発言語 <ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar>` records 7-day product development language.
- `tools/lesson14 学習モード <A|B|C>` records and switches explanation depth.
- `tools/lesson14 表示言語 <ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar>` records 14-day workflow display language.
- `tools/lesson14 開発言語 <ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar>` records 14-day product development language.
- `tools/lesson 開始位置 <step_id> --confirm` changes the 7-day start position intentionally.
- `tools/lesson14 開始位置 <step_id> --confirm` changes the 14-day start position intentionally.
- `tools/lesson14 初期化 --confirm` resets 14-day runtime state for a fresh run.
- English aliases are available for the same lesson controls where implemented, including `approve`, `learning-mode`, `start-at`, and `reset`.

### Learning Modes

- A: detailed explanation.
- B: brief supplemental explanation.
- C: workflow only.
- Mode can be changed during either structured lesson.
- 7-day `setup.index` cannot pass until learning mode, workflow display language, and product development language are selected.
- 14-day `setup.index` cannot pass until learning mode, workflow display language, and product development language are selected.

### Dialogue And Sub-Agent Learning

- `guides/LESSON_14_DAYS.md` defines dialogue and wall-bouncing with the agent as a core learning objective.
- `prompts/PROMPTS_14_DAYS.md` includes a wall-bouncing prompt.
- Step 12/14 teaches sub-agents as role-based viewpoints.
- The orchestrating agent must decide what to adopt, defer, or reject based on the learner's goal.

### Free Development Mode

- `free-development/FREE_DEVELOPMENT_MODE.md` defines optional post-lesson product development.
- `tools/free-development status` shows mode context.
- `tools/free-development start` prints the start prompt.
- `tools/free-development gate` checks product boundary, Git sync, and CI.
- Learners can choose languages, frameworks, databases, payment systems, hosting, testing tools, APIs, and integrations.

### Team Development And Docker

- `advanced/TEAM_DEVELOPMENT_DOCKER.md` defines the advanced module.
- `advanced/DOCKER_PATHS.md` separates the no-Docker and Docker-installed learning paths.
- `tools/team-development status` reports module status and Docker availability.
- `tools/team-development start` prints the start prompt.
- `tools/team-development gate` checks product boundary, Git sync, CI, and Docker availability when Docker is installed.
- Docker execution is optional unless Docker is available and the learner chooses container implementation.

### Menu And Dashboard

- `tools/menu` displays the approved learner-facing menu grouped by intent:
  - learning paths,
  - building and extending paths,
  - lesson-maintenance paths.
- The menu explicitly shows the progression from Free Development Mode to product improvement to external integration.
- `tools/dashboard lesson` shows STEP 1-14 and STEP 1-7 lesson status, both lesson language settings, learning mode labels, helpdesk information, and developer-memory themes.
- `tools/dashboard development` shows product repository status and workflow document presence when a product repository exists.
- `tools/dashboard illustrations` shows illustration request and review records.
- `tools/dashboard all` combines the lesson, development, and illustration views.

### Menu Prerequisite Control

Menu-control prerequisites are implemented without replacing or weakening any existing menu entry, lesson flow, dashboard view, product gate, or repository-boundary check.

- The learner-facing menu label is `3. 応用レッスン`.
- The renamed applied-learning item continues to route to the existing Team Development and Docker learning path.
- Menu items 1 through 6 share one prerequisite model:
  - learning mode,
  - workflow display language,
  - product development language,
  - repository context and boundary confirmation where relevant,
  - learner approval before start.
- 7-day and 14-day menu entries use their existing lesson setting files and setup gates.
- Applied-learning, Free Development Mode, product improvement, and external integration read a shared settings view that can inherit the most recently configured structured-lesson settings.
- If the shared settings view cannot resolve learning mode, workflow display language, or product development language, start/gate/check commands instruct the learner to select the missing setting before proceeding.
- `status` commands remain non-blocking and available for orientation even when prerequisites are missing.
- Enforcement is implemented through reusable helper logic in `tools/lib/lesson_common.sh`, with composable menu prerequisite checks used by menu-specific tools.
- Product improvement has a mechanically checkable entry point: `tools/product-improvement status|start|gate`.
- Dashboard output exposes readiness for menu items 1 through 6 and does not hide existing dashboard information.
- Tests validate the renamed menu label, absence of the old label in learner-facing menu output, missing-prerequisite failure paths for missing settings, and unchanged 7-day/14-day behavior.

### Implemented Documentation Map And Tour

The documentation-map improvement is implemented in the current runtime.
It was added without replacing or weakening existing lesson flow, menu behavior, dashboard behavior, checks, skills, memory documents, or as-built/workflow synchronization.

- `guides/DOCUMENT_MAP.md` explains the repository documents through learner-facing categories:
  - rules and routing,
  - design/as-built,
  - workflow state,
  - memory and decisions,
  - skills and reusable agent procedures.
- The guide explains `AGENTS.MD` as the lesson-side agent rulebook and separately explains product-side `AGENT.md` where relevant.
- The guide explains the `AGENTS.MD` invariant rules, document root table, routing table, and repo-local skills in non-engineer-friendly terms.
- The guide explains `docs/as-built/REQUIREMENTS.md`, `docs/as-built/SPECIFICATION.md`, and `docs/as-built/IMPLEMENTATION_PLAN.md` as the design/as-built trio.
- The guide explains `docs/workflow/TASK_TRACKER.md` and `docs/workflow/HANDOFF.md` as the paired progress and restart-context documents.
- The guide, CLI tour, and dashboard docs view explain `docs/workflow/GIT_HOOKS_POLICY.tsv`, `docs/workflow/GIT_HOOK_CHECKS.tsv`, and `learning/GIT_HOOK_SETTINGS.tsv` as the Git hook policy and current local hook-mode controls.
- The guide explains `docs/memory/DEVELOPER_MEMORY.md` as developer intent and stable preference memory.
- The guide explains failure memory as product-side `FAILURE_MEMORY.md` or failure-recovery records when used by the lesson, without inventing a lesson-side file that does not exist.
- `tools/docs-tour` provides `status`, `rules`, `design`, `workflow`, `memory`, `skills`, and `all` views.
- `tools/docs-tour` output uses the current learning mode when available:
  - A: fuller explanation with purpose, benefit, and examples,
  - B: short supplemental explanation,
  - C: file names and direct purposes only.
- `tools/dashboard docs` shows document categories, key files, current workflow relevance, workflow-pair sync status, as-built sync status, and a next recommended document action.
- `tools/dashboard all` includes the docs view without removing existing menu, lesson, development, or illustration views.
- Prompt examples are included so learners can ask an agent to explain `TASK_TRACKER` and `HANDOFF`, or the as-built trio, in plain language.
- 7-day and 14-day guidance introduces the documentation map before learners are expected to use the documents deeply.
- `tools/test_docs_tour.sh` covers guide presence, tour command behavior, dashboard docs output, prompt examples, structure integration, and as-built/workflow synchronization.
- `guides/DOCUMENT_MAP.md`, `tools/docs-tour`, `tools/test_docs_tour.sh`, and `./tools/dashboard docs` are part of the runtime dispatcher and aggregate checks.
- Validation is wired through `tools/test_docs_tour.sh`, structure checks, as-built checks, developer-memory checks, dashboard or Playwright tests, aggregate tests, CI, and pre-commit.
- The new validation must preserve existing 7-day, 14-day, menu, dashboard, Free Development, Product Improvement, external-integration, product-gate, Playwright, CI, and pre-commit behavior.

### Implemented Product Repository Cleanup

The product-repository cleanup improvement is implemented in the current runtime.
It was added without replacing or weakening existing lesson flow, menu behavior, dashboard behavior, checks, skills, memory documents, product-gate behavior, GitHub/CI workflow, docs-tour behavior, or as-built/workflow synchronization.

- `tools/product-repository-cleanup` provides a dedicated cleanup entry point for the external product repository created by the 7-day or 14-day lessons.
- `tools/product-repository-cleanup status` inspects and prints the configured product repository path, local existence, nested-repository safety, Git repository status, configured repository name, remote URL when available, and remote GitHub existence when it can be checked safely.
- `tools/product-repository-cleanup plan` prints the safe cleanup procedure without deleting anything.
- `tools/product-repository-cleanup local --confirm task-tracker-repository` is the local deletion shape.
- Local deletion fails unless the target path is the configured external product repository path, is outside the lesson repository, matches the configured product repository name, contains `.git`, resolves as the Git top level, and receives the exact confirmation text.
- `tools/product-repository-cleanup remote --confirm xxxMasahiro/task-tracker-repository` is the remote deletion shape.
- Remote deletion fails unless GitHub authentication works, the repository can be viewed, the owner/repository confirmation text matches exactly, and the target URL is shown before deletion.
- Local deletion and remote deletion remain separate operations; no `all` or automatic chained deletion operation is provided.
- The command prints a clear operation log for status, plan, local cleanup, and remote cleanup paths.
- Runtime discovery is exposed through the menu, dashboard development view, README command list, AGENTS routing, and mechanical checks.
- Tests do not delete a real GitHub repository; they cover status/plan behavior, missing confirmation failures, wrong target failures, nested repository rejection, non-Git target rejection, temporary local cleanup behavior, and fake-`gh` remote deletion behavior.
- `tools/test_product_repository_cleanup.sh` covers the cleanup command and is wired into structure checks, as-built checks, developer-memory checks, aggregate tests, CI, and pre-commit.
- `tools/product-repository-cleanup` and `tools/test_product_repository_cleanup.sh` are part of runtime dispatch and aggregate checks.
- The validation suite preserves existing 7-day, 14-day, menu, dashboard, Free Development, Product Improvement, external-integration, product-gate, Playwright, docs-tour, CI, and pre-commit behavior.

### Illustration Review Support

- `tools/illustrations list` shows illustration records.
- `tools/illustrations request <step_id> <topic>` records a request for a learner-facing educational PNG illustration.
- Actual image generation is still performed by the agent with `imagegen`.
- Generated or requested illustration metadata is stored under `illustrations/lesson14/`.
- `illustration-review/index.html` is the initial dedicated review page for large-format illustration review.

### As-Built Synchronization

- `docs/as-built/REQUIREMENTS.md`, `docs/as-built/SPECIFICATION.md`, `docs/as-built/IMPLEMENTATION_PLAN.md`, `docs/workflow/TASK_TRACKER.md`, and `docs/workflow/HANDOFF.md` describe the lesson-side as-built state.
- `reviews/SUBAGENT_REVIEW_PROTOCOL.md` defines the multi-perspective review process.
- `tools/list_non_english_docs.sh` lists Markdown files that still contain Japanese text so translation work can be scoped explicitly.

### Implemented As-Built Sync Contract

The as-built sync-contract improvement is implemented in runtime.
It was added without replacing or weakening existing lesson flow, document-path support, as-built checks, workflow-pair checks, developer-memory checks, dashboard behavior, CI, pre-commit, docs-tour behavior, product-gate behavior, or product-repository cleanup behavior.

- `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv` is the contract source for synchronized improvement IDs.
- Contract rows record sync ID, status, title, required artifacts, required tests, required document coverage, and runtime evidence where applicable.
- Each of the five synchronized documents includes matching sync blocks for each contract row:
  - `SYNC-ID`,
  - `STATUS`,
  - `ARTIFACTS`,
  - `TESTS`.
- `tools/check_as_built_sync_contract.sh` validates the contract against all five documents.
- The validator fails when any sync ID is missing from any synchronized document.
- The validator fails when a synchronized document contains a `SYNC-ID` block that is absent from the contract.
- The validator fails when planned and implemented statuses are mixed for the same sync ID.
- The validator fails when document `ARTIFACTS` or `TESTS` blocks contain extra or missing entries compared with the contract.
- The validator fails when required artifacts or required tests listed by the contract are missing from the repository.
- The validator fails when runtime evidence files are missing or do not reference the sync ID, one of its artifacts, or one of its tests.
- For implemented sync IDs, the validator fails when required tests are not actively wired into aggregate tests, CI, and pre-commit; comments or inert text mentions do not satisfy wiring.
- `tools/check_as_built_docs.sh` calls the sync-contract check while preserving the existing topic-based checks.
- `tools/check_workflow_pair_sync.sh` remains active for the `TASK_TRACKER.md` and `HANDOFF.md` pair; the contract check adds five-document coverage instead of replacing pair synchronization.
- `tools/as-built-sync status` shows sync IDs, document coverage, artifact existence, and test-wiring status for learners and agents.
- `AGENTS.MD` exposes a routing-table entry and standard checks for the sync-contract status and validator.
- `tools/test_as_built_sync_contract.sh` tests complete synchronization, a missing sync block, an unknown sync ID, mixed planned/implemented status, extra artifacts/tests, missing artifacts, inert wiring, and missing active test wiring.
- CI, pre-commit, and aggregate test wiring now include the runtime validator and regression test.
- The implementation remains refactorable, ecosystem-friendly, reusable, general, and additive.

### Implemented Resource-Budgeted Parallel Guard

The resource-budgeted parallel guard is implemented as a conservative resource budget and monitoring model for local and CI verification improvements while preserving the existing `full`, `fast`, and `minimal` Git hooks semantics.

- User settings are stored in `learning/RESOURCE_SETTINGS.tsv`:
  - memory budget percentage,
  - swap storage-free percentage,
  - swap GiB upper limit,
  - maximum parallel jobs or automatic job recommendation mode,
  - available-memory floor percentage.
- Effective swap budget:
  - `effective_swap_budget = min(free_storage * swap_storage_percent, swap_gib_limit)`.
- The repository memory budget is an operational budget for heavy checks, not a hard OS-level memory limit.
- `tools/lib/resource_guard.sh` and `tools/resource-guard` inspect real environment state before heavy local work:
  - memory availability,
  - swap availability and usage,
  - disk free space,
  - active heavy process indicators where practical.
- Active heavy-process detection downgrades optional automatic parallel recommendations to serial fallback.
- `resource_mode=serial` forces one-worker recommendations.
- `resource_mode=automatic` allows limited parallelism only when no caution state is detected and otherwise falls back to serial recommendations.
- `resource_mode=parallel` requests parallel execution explicitly; if a caution state prevents safe parallel execution, the guard fails closed instead of silently falling back.
- Monitoring stages use repository swap-budget usage:
  - 10 percent: record only,
  - 20 percent: record only,
  - 30 percent: record only,
  - 40 percent: record only,
  - 50 percent: notice,
  - 60 percent: warning,
  - 70 percent: strong warning,
  - 80 percent: do not start new heavy parallel work,
  - 90 percent: return the next phase to serial execution or safe stop.
- A 90 percent threshold must not imply arbitrary process termination.
- A 90 percent threshold makes `tools/resource-guard check --profile <profile>` and `tools/resource-guard recommend-jobs --profile <profile>` fail closed for new heavy verification work while leaving explicit developer recovery decisions outside the tool.
- Heavy work profiles are stored in `docs/workflow/RESOURCE_POLICY.tsv` and are reusable rather than tied to one product stack, one lesson sentence, or one command string.
- Unknown heavy-work profiles are rejected as configuration errors.
- `tools/resource-guard status`, `check --profile`, `recommend-jobs --profile`, and `monitor --profile` are the CLI entry points.
- Git hooks integration keeps `minimal` lightweight and does not redefine `full`, `fast`, or `minimal`; resource checks run before `full` and `fast` paths when resource policy/settings files exist.
- Playwright uses `PLAYWRIGHT_WORKERS`, and `tools/test_lesson_playwright.sh` obtains the local recommendation from `tools/resource-guard recommend-jobs --profile playwright` without hiding safe-stop failures.
- CI integration preserves all required checks, adds direct resource guard regression coverage, routes Playwright dashboard checks through `tools/test_lesson_playwright.sh`, and uses workflow concurrency cancellation without treating CI runner resources as local WSL settings.
- The implementation does not perform `.wslconfig` writes, swap creation or deletion, privileged cache cleanup, arbitrary process killing, Docker/cgroups enforcement, or Security guard control-plane migration.

### Implemented Resource Guard Safe Cleanup

Safe cleanup is implemented as a `tools/resource-guard cleanup` action that reuses the resource guard policy/settings model.

- CLI entry points:
  - `tools/resource-guard cleanup --dry-run`
  - `tools/resource-guard cleanup --safe`
  - `tools/resource-guard cleanup --safe --older-than <hours|Nh>`
  - `tools/resource-guard cleanup --profile <profile|all> --dry-run`
- Default cleanup action is dry-run; deletion requires explicit `--safe`.
- `cleanup_safe_delete_enabled=false` in `learning/RESOURCE_SETTINGS.tsv` blocks safe deletion even when `--safe` is provided.
- `cleanup_older_than_hours` provides the default age filter; `--older-than` overrides it for one command.
- Cleanup targets are `cleanup_target` rows in `docs/workflow/RESOURCE_POLICY.tsv`.
- A cleanup target row stores an id, a repository-relative path, applicable profile names, and a learner-facing description.
- The current policy-approved targets are:
  - `playwright-report` for Playwright HTML reports,
  - `test-results` for Playwright test results,
  - `.git/pre-commit-cache` for the marked Git hooks cache.
- The `all` cleanup profile includes every cleanup target; a named profile includes only matching target rows.
- Cleanup rejects absolute paths, path traversal, unsafe `.git` paths, paths resolving outside the lesson repository, and symlink targets.
- `.git/pre-commit-cache` is deleted only if it contains the expected `git-hooks-cache-v1` marker.
- Dry-run reports `cleanup-would-delete` without deleting anything.
- Safe deletion reports `cleanup-deleted` only after removing a validated target.
- Missing targets are reported as `cleanup-missing` and do not fail the cleanup plan.
- Recent targets are reported as `cleanup-kept-recent` when an age filter is active.
- The implementation does not clean global caches, OS caches, swap, Docker resources, running processes, product repositories, or files outside the lesson repository.

### Implemented Resource Guard Summary And Parallel CI

The resource guard summary and parallel verification implementation extends the existing resource-budgeted guard without changing its current safety model.
The feature is implemented through the resource guard command, local Git hooks runner, CI job split, structure check, and regression tests.

- `tools/resource-guard summary` shows a learner-friendly operational summary.
  - It includes memory budget percent, memory budget MiB, available memory MiB, effective swap budget, repository swap-budget usage percent, usage stage, current decision, local profile-specific recommended jobs, and a short explanation that profile weights produce different parallel counts.
  - It explains that local `memory_budget_percent` controls local execution only.
  - It explains that GitHub Actions uses CI job structure rather than the local PC memory setting.
- `tools/resource-guard summary --short` shows the compact form of the same information without extended explanatory paragraphs.
- Profile names and job recommendations are derived from `docs/workflow/RESOURCE_POLICY.tsv` and existing `resource_guard_recommended_jobs` behavior.
- The implementation does not add `target_parallel_jobs`; `max_parallel_jobs` remains an upper bound and `auto` remains calculation-driven.
- Local Git hooks full or fast execution obtains the `git-hooks-full` recommendation and uses it as the maximum worker count for parallel-safe checks.
- Minimal Git hooks execution remains conservative and can stay serial.
- `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv` classifies checks as parallel-safe, serial, heavy, or final-gate behavior without changing the existing `docs/workflow/GIT_HOOK_CHECKS.tsv` four-column contract.
- Checks missing from the parallel group configuration are treated as serial by default.
- Parallel check output is captured per check and replayed in check definition order.
- Any failed parallel check makes the whole run fail and reports the failing check id.
- Resource guard `safe-stop` prevents new parallel verification work.
- Resource guard serial or fallback states reduce local execution to serial behavior.
- GitHub Actions CI is split into runner-oriented jobs:
  - `syntax-checks`,
  - `structure-docs-checks`,
  - `policy-regression-tests`,
  - `lesson-cli-tests`,
  - `playwright-tests`,
  - final `aggregate-and-full-hooks`.
- CI job splitting must preserve existing check coverage and may only optimize execution structure.
- A required CI workflow structure check verifies the split workflow's required job names, `needs` relationships, and required command coverage.
- The final `aggregate-and-full-hooks` job installs npm dependencies and Playwright dependencies before running aggregate repository tests or full hooks, because GitHub Actions jobs do not share dependency setup from prior jobs.
- CI full-hooks execution keeps the CI-safe local-resource bypass behavior `RESOURCE_GUARD_SKIP_LOCAL_CHECK=1`.
- Local Playwright and Git hooks can use resource guard recommendations, but GitHub Actions job splitting is runner-oriented and will not apply local WSL memory settings directly.
- The `resource_guard_summary_parallel_ci` sync contract is implemented with actual runtime artifacts, runtime tests, and runtime evidence.

### As-Built Sync Contract Records

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

### Planned Learner Context Foundation

The learner context foundation is represented as source documentation under `learning/context/`.
It is planned material for the next lesson-content implementation cycle and is not runtime lesson behavior yet.

- `learning/context/README.md` defines the role, file structure, usage moments, and synchronization boundary for learner context.
- `learning/context/AI_DRIVEN_DEVELOPMENT_FOUNDATION.md` provides the main conceptual lesson text for AI-driven development.
- `learning/context/SECURITY_FOUNDATION.md` provides staged security learning content for 7-day, 14-day, and applied lessons.
- `learning/context/LESSON_CONTEXT_MAP.tsv` maps context topics to lesson openings, per-topic deepening, final recaps, security coverage, prompt examples, and dashboard candidates.
- `guides/DOCUMENT_MAP.md` links to the context directory so learners and agents can find it.
- Runtime integration must be specified separately before lesson commands, lesson flows, prompts, dashboards, or browser views render this material.

### Planned Learner Context Runtime Integration

The runtime integration is planned, not implemented.
It must render learner context through existing lesson and workflow controls while preserving the distinction between learning paths and work-producing workflows.

- Learning context targets:
  - `lesson-7` for the 7-day structured lesson.
  - `lesson-14` for the 14-day structured lesson.
  - `applied` for applied learning modules such as Team Development and Docker.
- Workflow context targets:
  - `free-development` for post-lesson or trained-user product development.
  - `product-improvement` for improving an existing product repository.
  - `external-integration` for connecting a product to external services or APIs.
  - `lesson-maintenance` for improving this lesson repository itself.
- Free Development Mode is not a lesson target; it is a workflow target that uses the learned process to build user-selected products.
- Planned command surface:
  - `tools/lesson-context status`
  - `tools/lesson-context opening lesson-7|lesson-14|applied`
  - `tools/lesson-context step lesson-7|lesson-14 <step_id>`
  - `tools/lesson-context recap lesson-7|lesson-14|applied`
  - `tools/lesson-context workflow free-development|product-improvement|external-integration|lesson-maintenance`
- Planned shared implementation:
  - `tools/lib/lesson_context.sh` loads context maps and reuses existing lesson-common settings.
  - `learning/context/LESSON_CONTEXT_MAP.tsv` remains the learning-context source.
  - A future `learning/context/WORKFLOW_CONTEXT_MAP.tsv` separates workflow contexts from lesson contexts.
- Runtime output must respect the selected learning mode where applicable.
- Runtime output must preserve workflow display language and product development language separation.
- Dashboard integration must show learning context and workflow context in separate areas.
- Menu integration must continue to group learning, building/extending, and lesson-maintenance actions without reclassifying Free Development Mode as a lesson.
- Planned validation must be available through `tools/test_lesson_context.sh` and aggregate repository checks after implementation.

### Implemented Git Workflow Policy

The Git workflow policy lets users choose the Git-management permissions and automation level used by the lesson and post-lesson workflows.
It is additive and preserves existing lesson progression, approvals, menu prerequisites, dashboard behavior, product-gate behavior, product-repository cleanup, CI, pre-commit, and as-built synchronization.

- `docs/workflow/GIT_WORKFLOW_POLICY.tsv` defines supported policy keys, accepted values, defaults, and learner-facing labels.
- `learning/GIT_WORKFLOW_SETTINGS.tsv` stores the current selected values.
- `tools/lib/git_workflow_policy.sh` provides reusable policy loading, validation, permission helpers, automation-level decisions, repository-context detection, and Git monitor helpers.
- `tools/git-workflow status` shows the selected policy and current Git monitoring result.
- `tools/git-workflow configure` guides users through the settings and shows safe copy-paste commands.
- `tools/git-workflow set <key> <value>` updates one setting after validating the key and value.
- `tools/git-workflow allow <branch|worktree|main-direct|commit|push|pr|ci|sync>` checks whether a requested Git action is allowed by the current settings.
- `tools/git-workflow check` inspects repository state, including uncommitted changes, local/remote divergence through configured upstreams, candidate cleanup branches, candidate cleanup worktrees, and whether the current repository is the lesson, product, or a custom repository.
- `tools/git-workflow cleanup-plan` lists candidate branch/worktree cleanup actions without deleting anything.
- The command layer separates lesson-repository Git state from product-repository Git state so the workflow cannot mix repositories.
- Supported branch policy includes allowing or disallowing normal working branches.
- Supported worktree policy includes allowing or disallowing `git worktree`.
- The policy includes a main-direct-work setting so direct work on `main` can be controlled explicitly.
- Automation levels are:
  - `manual`: guidance only.
  - `commit`: allow automated commit after checks pass.
  - `pr_ci`: allow automated push, PR creation where applicable, and CI checks.
  - `sync`: allow automated main CI and local/remote synchronization checks.
- Destructive or high-impact operations remain confirmation-gated even when automation is enabled, including merge, branch deletion, worktree deletion, and remote deletion.
- The policy is reusable across 7-day lessons, 14-day lessons, applied lessons, Free Development Mode, product improvement, and external integration.
- Dashboard output reuses the status data to show Git-management readiness.
- Menu output exposes `./tools/git-workflow status` and `./tools/git-workflow configure` as the Git management settings entry.
- `tools/test_git_workflow_policy.sh` validates default settings, setting changes, invalid setting rejection, branch/worktree permission decisions, automation-level decisions, dirty-state detection, local/remote sync detection, repository separation, and non-destructive cleanup planning.
- `tools/test_git_workflow_policy.sh` is wired into structure checks, as-built checks, aggregate tests, CI, and pre-commit without replacing existing Git sync or CI checks.

### Implemented Menu-Wide Git Workflow Policy

The menu-wide Git workflow policy makes the existing Git policy available as a shared menu-level control.
It is additive and preserves existing lesson progression, approval gates, menu prerequisite checks, dashboard behavior, product-gate behavior, product-repository cleanup, CI, pre-commit, docs-tour behavior, and as-built synchronization.

- The existing `tools/git-workflow` command remains the source for Git policy status, configuration, validation, action permission checks, repository monitoring, and cleanup planning.
- `tools/menu readiness` displays the current Git policy state for items 1 through 7.
- `tools/menu check <1|2|3|4|5|6>` adds Git policy validation without weakening the existing learning-mode, display-language, product-language, repository-boundary, or approval checks.
- `tools/menu check 7` and `tools/menu start 7 --confirm` provide a safe lesson-maintenance check/start path.
- Git policy validation confirms that `docs/workflow/GIT_WORKFLOW_POLICY.tsv` exists, `learning/GIT_WORKFLOW_SETTINGS.tsv` exists or can resolve defaults, selected values are valid, and repository context can be identified.
- `automation_level=manual` remains a valid pass state because it means Git automation is guidance-only.
- Menu-wide automation levels are interpreted consistently:
  - `manual`: guidance and monitoring only,
  - `commit`: commit-level automation only after required checks pass,
  - `pr_ci`: push, PR, and CI-check automation where applicable,
  - `sync`: main synchronization plus local/remote sync checks where applicable.
- Menu items that affect product repositories evaluate Git context against the product repository; lesson-maintenance evaluates Git context against the lesson repository.
- Dashboard output includes a menu-wide Git policy summary in the menu view without hiding existing dashboard sections.
- High-impact Git operations remain outside automatic menu progression unless explicit user confirmation is given.
- Runtime validation is added to menu prerequisite tests, aggregate tests, CI, and pre-commit.

### Implemented Git Workflow Action Settings

The implemented Git workflow action settings split broad Git automation from action-by-action behavior.
The feature remains additive: existing settings, command names, menu checks, dashboard views, cleanup controls, CI checks, and sync-contract enforcement stay available.

- Existing settings remain supported:
  - `branch_allowed`
  - `worktree_allowed`
  - `main_direct_work_allowed`
  - `automation_level`
- `automation_level` remains a compatibility preset and broad write-automation setting.
- When a detailed action setting key is present, the detailed setting takes precedence over the broad preset for its specific action.
- When a detailed action setting key is absent, the resolver falls back to `automation_level` so current implemented behavior is preserved.
- Supported detailed settings are:
  - `commit_automation: manual|auto`
  - `push_automation: manual|auto`
  - `pr_creation: manual|auto`
  - `pr_ci_monitoring: manual|auto`
  - `merge_execution: manual|after_approval`
  - `developer_auto_merge_allowed: false|true`
  - `main_ci_monitoring: manual|auto`
  - `sync_monitoring: manual|auto`
- Default values are:
  - `commit_automation: auto`
  - `push_automation: manual`
  - `pr_creation: manual`
  - `pr_ci_monitoring: auto`
  - `merge_execution: after_approval`
  - `developer_auto_merge_allowed: false`
  - `main_ci_monitoring: auto`
  - `sync_monitoring: auto`
- These detailed defaults are active after implementation; `automation_level` remains available as a compatibility preset when detailed action keys are absent.
- Helper behavior:
  - `git_workflow_action_mode commit` returns the resolved mode for commit.
  - `git_workflow_action_mode push` returns the resolved mode for push.
  - `git_workflow_action_mode pr` returns the resolved mode for PR creation.
  - `git_workflow_action_mode ci` remains a compatibility alias for CI monitoring.
  - `git_workflow_action_mode pr_ci` returns the resolved mode for PR CI monitoring.
  - `git_workflow_action_mode merge` returns `manual`, `after_approval`, or `developer_auto` for merge execution.
  - `git_workflow_action_mode main_ci` returns the resolved mode for main CI monitoring.
  - `git_workflow_action_mode sync` returns the resolved mode for local/remote sync monitoring.
- `tools/git-workflow status` and `tools/git-workflow configure` show the detailed action settings in learner-readable form.
- `tools/git-workflow set <key> <value>` validates detailed keys and rejects unsupported values.
- `tools/git-workflow approve <push|pr|merge> "memo"` records action, repository root, branch, timestamp, and memo in `learning/GIT_WORKFLOW_APPROVALS.tsv`.
- `tools/git-workflow allow push|pr|merge` requires a matching approval receipt when the relevant detailed setting is present and permits the action.
- `tools/menu readiness` and `tools/dashboard menu` display the detailed action settings for menu items 1 through 7.
- For push and PR creation, `auto` means the agent may execute the operation only after explicit approval for that operation is recorded; it never means approval-free execution.
- `merge_execution: after_approval` means merge execution is automated only after explicit merge approval is recorded.
- `developer_auto_merge_allowed: true` may resolve merge to `developer_auto` only in developer-responsibility mode after required gates pass: PR CI success, clear target PR and branch, verified merge base, clean working tree, checked local/remote state, and stop-on-failure behavior.
- Developer-responsibility auto-merge uses explicit gate evidence plus the actual repository monitor; the setting alone does not permit approval-free merge.
- Branch deletion, worktree deletion, remote deletion, and product repository deletion remain behind explicit user confirmation regardless of merge settings.

### Implemented Git Hooks Policy And Cache

The implemented Git hooks policy keeps the current pre-commit safety model while adding mode selection and a conservative cache.
The runtime behavior is implemented through a reusable hook runner and synchronized as `git_hooks_policy`.

- Implemented modes:
  - `full`: run the complete required pre-commit coverage and remain the completion/CI-equivalent local mode.
  - `fast`: run the same logical checks as needed, but reuse successful results only when relevant inputs are unchanged.
  - `minimal`: run core mechanical checks for quick local feedback; it remains insufficient for final completion by itself.
- No normal `off` mode is part of the implemented learner-facing workflow.
- Cache storage is Git-local and untracked, such as `.git/pre-commit-cache/`.
- Cache lookup must fail closed:
  - missing cache entries are misses,
  - corrupted entries are misses,
  - changed command identity is a miss,
  - changed tool or input hashes are misses.
- Cache keys include hook mode, command identity, relevant tool files, relevant document or state inputs, and Git diff or staged content where practical.
- Cache is disabled while untracked files are present so untracked content cannot create a false cache hit.
- Command surface:
  - `tools/git-hooks status`,
  - `tools/git-hooks recommend`,
  - `tools/git-hooks recommend --paths <path>...`,
  - `tools/git-hooks mode <full|fast|minimal>`,
  - `tools/git-hooks cache clear`,
  - `tools/git-hooks run`,
  - `tools/git-hooks run --no-cache`,
  - `tools/git-hooks run --mode <full|fast|minimal>`.
- `.githooks/pre-commit` delegates to `tools/git-hooks run`.
- `docs/workflow/GIT_HOOK_CHECKS.tsv` stores the serial check list and mode membership.
- `docs/workflow/GIT_HOOK_CHECKS.tsv` rows fail closed when required fields are missing, the field count is not exact, or a mode token is empty or outside the accepted policy modes.
- `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv` stores path patterns that recommend local `tools/git-hooks run --mode full --no-cache` when Git hooks, CI, checks, tests, or as-built synchronization behavior changes.
- `tools/git-hooks recommend` inspects current changed paths and prints whether local `minimal` is sufficient for ordinary quick feedback or whether local `full --no-cache` is recommended before push.
- `tools/git-hooks recommend --paths <path>...` evaluates explicit paths for tests, diagnostics, and agent planning without depending on the current working tree.
- `docs/workflow/GIT_HOOKS_POLICY.tsv` stores accepted hook modes and the default mode.
- `learning/GIT_HOOK_SETTINGS.tsv` stores the current hook mode.
- `tools/lib/git_hooks_policy.sh` provides reusable policy loading, mode validation, status output, local verification recommendation, cache-key generation, cache clearing, and serial check execution.
- `tools/test_git_hooks.sh` validates standalone policy and cache behavior: mode parsing, invalid persisted settings, malformed check rows, invalid or empty check-row mode tokens, local full/no-cache recommendation behavior, cache hit and miss behavior, invalidation, no-cache operation, minimal-mode required checks, failing-check cache refusal, and safe cache clearing.
- Full/no-cache coverage, aggregate test wiring, CI wiring, and preservation of existing checks are validated by `tools/git-hooks run --mode full --no-cache`, `.githooks/pre-commit`, `tools/test_lesson_repository.sh`, and the CI workflow definitions.
- Existing sync, AGENTS/skills, developer-memory, and status checks recognize `.githooks/pre-commit` -> `tools/git-hooks` -> `docs/workflow/GIT_HOOK_CHECKS.tsv` as active wiring while preserving direct-command detection; as-built active pre-commit wiring is checked against full-mode coverage so a local `minimal` setting does not weaken implemented sync-contract verification.
- CI must not rely on local cache state; CI should run full or no-cache verification.

### Implemented Local Verification Scope Policy

The local verification scope policy is implemented as a documentation and contract alignment rule over the existing Test Plan Manifest and Git hooks policy.
It does not redefine `full`, `fast`, `minimal`, full/no-cache semantics, CI final gates, or remote CI behavior.

- `AGENTS.MD` records the high-priority everyday rule for agents.
- The rule is lower priority than the no-existing-feature-tradeoff invariant.
- `docs/workflow/TEST_PLAN_MANIFEST.tsv` remains the path-to-required-checks contract.
- `docs/workflow/GIT_HOOK_CHECKS.tsv` remains the check-id-to-command catalog.
- `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv` remains the local full/no-cache recommendation policy.
- `learning/GIT_HOOK_SETTINGS.tsv` remains the persisted local hook mode selection.
- `.githooks/pre-commit` delegates to `tools/git-hooks run`, which uses the selected mode unless an explicit mode is passed.
- Agents must treat `tools/git-hooks recommend` output as planning guidance and must present heavy recommended checks before running them when user approval is not already clear.
- Agents must distinguish:
  - required checks from `TEST_PLAN_MANIFEST.tsv`;
  - runnable commands from `GIT_HOOK_CHECKS.tsv`;
  - local full/no-cache recommendations from `GIT_HOOK_RECOMMENDATION_PATHS.tsv`;
  - final CI or completion evidence from remote workflows and final gates.
- Lightweight UI, wording, CSS, or layout changes may use narrow target verification when they do not alter schema, command execution boundaries, shared tooling, CI, hooks, or sync contracts.
- Contract, schema, shared tooling, Git hooks, CI, test infrastructure, or broad implementation changes continue to require the contract-defined broader verification path.
- The policy changes agent execution behavior and documentation alignment only; it does not remove any check from CI, pre-commit, aggregate tests, or sync-contract enforcement.

SYNC-ID: local_verification_scope_policy
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOKS_POLICY.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,learning/GIT_HOOK_SETTINGS.tsv,tools/lib/test_plan.sh,tools/test-plan,tools/lib/git_hooks_policy.sh,tools/git-hooks,tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_git_hooks.sh
TESTS: tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_git_hooks.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

### Design Quality Constraints

- Additions must preserve existing 7-day and 14-day behavior.
- Tooling should reuse the existing `tools/lib` runtime/config patterns where practical.
- Checks should be composable so they can run independently or through `tools/test_lesson_repository.sh`.
- Free Development Mode must stay stack-agnostic so learners can choose their ecosystem.
- No implementation may trade away an existing feature to add a new one.
- Remediation must remain refactorable, ecosystem-friendly, reusable, and general.

### Verification

- `tools/check_lesson_structure.sh` validates the 7-day structure.
- `tools/check_lesson14_structure.sh` validates the 14-day structure.
- `tools/check_lesson14_sync.sh` validates 14-day document synchronization.
- `tools/check_agents_skills.sh` validates AGENTS and skills integration.
- `tools/check_as_built_docs.sh` validates the five role-organized as-built/workflow documents.
- `tools/check_as_built_sync_contract.sh` validates the five-document sync contract.
- `tools/as-built-sync status` validates learner/agent-facing sync-contract status output.
- `tools/check_review_protocol.sh` validates the review protocol.
- `tools/check_developer_memory_requirements.sh` validates that developer-memory requirements are represented mechanically.
- `tools/menu`, `tools/dashboard`, and `tools/illustrations` validate the menu, dashboard, and illustration entry points at runtime.
- `tools/test_menu_prerequisites.sh` validates menu readiness, start approval, missing-prerequisite failure paths, the `3. 応用レッスン` label, and the absence of the old menu label.
- `tools/test_product_repository_cleanup.sh` validates product repository cleanup status, plan, confirmation gates, boundary rejection, non-Git rejection, temporary local deletion, and fake-`gh` remote deletion behavior.
- `tools/test_as_built_sync_contract.sh` validates complete synchronization, unknown sync IDs, mixed statuses, extra artifacts/tests, missing artifacts, inert wiring, and missing active test wiring.
- `tools/test_git_workflow_policy.sh` validates Git workflow setting validation, permission decisions, repository monitoring, local/upstream sync detection, repository separation, and non-destructive cleanup planning.
- `tools/test_git_hooks.sh` validates Git hooks mode settings, cache behavior, malformed configuration failure paths including invalid mode tokens, minimal-mode behavior, and no-cache behavior.
- `tools/test_lesson_start_position.sh` validates learner-selected start positions.
- `tools/test_lesson.sh` validates 7-day CLI behavior, including learning mode, workflow display language, product development language, and setup gating.
- `tools/test_lesson14.sh` validates lesson14 CLI behavior.
- `tools/test_lesson_repository.sh` runs the lesson-side validation suite without requiring `task-tracker-repository`.
- `tools/test_production_operations.sh` validates the end-to-end production operations path when an external product repository exists.
- Implemented local verification for the 7-day parity change passed `./tools/test_lesson.sh` and `./tools/test_lesson_repository.sh`.
- Implemented local verification for the language-list expansion passed `./tools/test_lesson.sh`, `./tools/test_lesson14.sh`, and `./tools/test_lesson_repository.sh`.

## Implemented Remediation Specification

The following specifications describe the implemented developer-memory remediation state.
They are additive to the current as-built components and must not weaken or replace existing lesson behavior.

### Role-Based Document Organization

- `AGENTS.MD` remains the root agent entry.
- Lesson-side design/as-built documents are addressed through a shared document-path layer.
- Workflow-state documents are addressed as a paired progress/restart-context group.
- Memory/decision documents are addressed as a separate memory group.
- Checks fail when final role-specific documents remain at the repository root after migration is complete.
- During migration, references in tools, guides, prompts, skills, dashboard output, CI, and tests are updated before root-level copies are removed.

### Learner-Facing Step Labels And Display Names

- Learner-facing materials use `Step N` labels where practical.
- Internal step IDs remain valid in TSV state files, command arguments, debug logs, and diagnostics.
- Runtime status and dashboard output map internal IDs to learner-friendly display names.
- Copy-paste command blocks may include internal IDs when the command requires them.

### Language Settings

- Workflow display language and product development language are separate settings in both 7-day and 14-day flows.
- Supported standard language codes are `ja`, `en`, `ko`, `zh-CN`, `zh-TW`, `es`, `pt-BR`, `fr`, `de`, `id`, `vi`, `th`, `hi`, and `ar`.
- The legacy `zh` input is normalized to `zh-CN`.
- Non-empty unsupported values remain accepted as `custom` to preserve existing flexibility.
- Workflow display language controls lesson guidance, dashboard text, prompts, and facilitation output.
- Product development language controls generated or proposed product-side documents and product-facing text.
- The lesson repository source remains English.
- Dashboard and status commands show both settings when relevant.
- 7-day settings are stored in `learning/LESSON_MODE.tsv`, `learning/WORKFLOW_DISPLAY_LANGUAGE.tsv`, and `learning/PRODUCT_DEVELOPMENT_LANGUAGE.tsv`.
- 14-day settings are stored in `learning/LESSON_MODE_14_DAYS.tsv`, `learning/WORKFLOW_DISPLAY_LANGUAGE_14_DAYS.tsv`, and `learning/PRODUCT_DEVELOPMENT_LANGUAGE_14_DAYS.tsv`.

### Learning Mode Display Labels

- A/B/C remain stable internal learning-mode IDs.
- Learner-facing output displays:
  - A: `じっくり説明`.
  - B: `ほどよく説明`.
  - C: `手順だけ`.
- Runtime output, dashboard output, guides, prompts, and checks use or validate the display labels where learner-facing text is involved.

### Approval And Passage Guidance

- 14-day start actions require matching start approvals.
- 14-day pass actions require matching pass approvals.
- Checks validate that 14-day approval/action pairs are complete and in the correct order.
- 7-day progression keeps ordered runtime control and user-approval facilitation without adding receipt storage.
- Start/pass prompts invite questions before continuing.
- Command blocks are introduced with short learner-friendly explanations.

### Paired Workflow Documents

- `docs/workflow/TASK_TRACKER.md` and `docs/workflow/HANDOFF.md` are treated as one workflow-state pair.
- Checks validate compatible current status, next action, and restart context.
- Dashboard reports whether the pair is synchronized.
- A workflow-state update that changes only one file fails unless an explicit reason is recorded.

### As-Built Synchronization

- The five as-built documents agree on current status, completed work, remaining work, test evidence, and known gaps.
- Synchronization checks validate agreement rather than only checking for topic keywords.

### Dashboard Expansion

- Lesson dashboard shows current step, progress, 7-day and 14-day learning-mode labels, 7-day and 14-day workflow display language, 7-day and 14-day product development language, helpdesk/question records, developer-memory open items, next approval, sync-gate status, and illustration availability.
- Development dashboard shows product repository, current objective, workflow document status, paired tracker/handoff synchronization, developer-memory items, Git status, real CI status when available, and next recommended action.
- Dashboard data is structured so a future browser dashboard can reuse it without replacing CLI behavior.
- Dashboard product status uses the same configured product repository path that product checks use.

### Illustration Review Completion

- Illustration records include step, topic, status, asset path, learning mode, display language, source explanation, summary, key terms, and generation timestamp.
- Requested illustrations can be updated to available generated assets.
- Asset paths avoid collisions for non-ASCII topics.
- The review page reads illustration records and presents review material in a useful order with explanatory text.

### External Integration Path

- A dedicated external-integration CLI supports `status`, `start`, and `gate`.
- The path works both after Free Development Mode and from an existing product repository.
- The gate checks product scope documents (`REQUIREMENTS.md`, `SPECIFICATION.md`, and `IMPLEMENTATION_PLAN.md`), product boundary, paired workflow documents, Git sync, and CI when applicable.

### Lesson-Repository Playwright

- Playwright checks are required after `npm install` and validate dashboard and illustration-review quality.
- Existing CLI lesson flow, documentation checks, and sync gates remain active.
- Browser tests complement existing checks and do not replace them.

### CI, Pre-Commit, And Gate Failure Tests

- Strengthened checks, product-gate tests, Playwright checks, and the aggregate lesson test are wired into CI and pre-commit without removing existing checks.
- Free Development and Team Development tests cover success and failure paths, including missing product repository, dirty Git state, CI failure, Docker installed/not-installed paths, and status/start output.

### Implemented Security Guard Backfill

Security guard backfill is implemented as a repository-security invariant layer, not as a replacement for the existing lesson-context foundation.

- `AGENTS.MD` contains explicit security invariants for untrusted text as data, prompt injection, secrets, least privilege, owner-layer fixes, destructive operations, dependency changes, Git/CI, and rejection of prompt-only security fixes.
- `docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv` defines security surfaces and required evidence for prompt injection, secrets, destructive actions, dependency changes, Git/CI safety, and external service permissions.
- `tools/check_security_invariants.sh` validates policy shape, required invariant IDs, evidence files, and evidence patterns.
- `tools/test_security_invariants.sh` verifies success and failure paths for missing invariants and missing evidence.
- The implementation is repo-local and non-networked. It does not mutate OS/WSL settings, create or delete swap, kill processes, enforce Docker/cgroups policy, or migrate to a Security guard control plane.

### Implemented Product Security Workflow Gate

Product security workflow gating is implemented as an additive gate for menu items 4, 5, and 6.
It must not replace existing Free Development, Product Improvement, External Integration, repository-boundary, Git sync, CI, or document-sync gates.

- `tools/product-security` exposes discovery and gate behavior through `status`, `preflight`, `advise`, `check`, and `gate`.
- `status` and `advise` are non-blocking.
- `check` runs non-destructive inspection against only the configured product repository.
- `gate` fails closed only on high-confidence unsafe states or missing required approvals.
- `docs/workflow/PRODUCT_SECURITY_POLICY.tsv` distinguishes warning conditions from blocking conditions.
- `learning/context/WORKFLOW_CONTEXT_MAP.tsv` maps menu 4, 5, and 6 workflow contexts to product-security safety summaries and approval requirements.
- Product-side secret detection will not print secret values; it will report safe metadata such as category and file reference.
- External Integration requires explicit confirmation of service, sent and received data, write behavior, OAuth scopes, token storage, redirect URI, token refresh and revoke behavior, webhook signature handling, rate limits, sandbox or test-account usage, prohibited log output, and rollback or recovery approach before implementation proceeds.
- Product Improvement presents security review prompts for dependencies, authentication, API settings, storage, deletion, and logging behavior changes.
- Free Development presents security assumptions once a product stack and product repository are selected.
- Product security behavior uses existing product repository configuration and repository-boundary semantics instead of scanning unrelated directories.
- Dashboard and menu readiness output present product-security status and short safety guidance before detailed raw settings where security status is relevant.

### Implemented Test And CI Safe Time Optimization

The test and CI optimization layer is implemented as an additive verification-planning and safe-execution layer.
It explains, records, and validates test selection while keeping existing full/no-cache verification intact.

- `docs/workflow/TEST_PLAN_MANIFEST.tsv` is the machine-readable policy source for risk classes, required checks, full/no-cache escalation, CI requirements, cache scope, quarantine permission, and learner-readable reasons.
- `tools/test-plan status|manifest|coverage|attest` provides the command surface for observing planned verification.
- The generated manifest distinguishes `run`, `force`, and safe fallback decisions without making changed-only selection authoritative.
- Every generated decision includes a reason that can be shown to a learner and inspected by a maintainer.
- `tools/check_test_plan_coverage.sh` compares the manifest policy against the configured check catalog and fails closed when required checks are missing, dangerous path coverage is missing, or an unknown check is referenced.
- `tools/test_test_plan.sh` covers normal manifest output, full-escalation paths, attestation output, unknown-check failure, and missing-dangerous-pattern failure.
- `tools/test-plan attest` records policy hash, check-catalog hash, repository-state hash, manifest hash, generated decisions, and final observe-only status.
- CI full-hooks execution keeps `--mode full --no-cache` and uses `--jobs 4` with `RESOURCE_GUARD_SKIP_LOCAL_CHECK=1`, while local Git hooks remain capped by resource guard recommendations.
- `tools/fixture-copy` and `tools/lib/fixture_copy.sh` provide lightweight temporary repository copies that exclude `.git`, `node_modules`, `playwright-report`, `test-results`, and cache directories.
- `tools/test_fixture_copy.sh` validates fixture-copy exclusions and failure paths.
- Future same-run cache should be ephemeral and scoped to a single command or CI run; it must not reuse persistent local hook cache semantics for CI verification.
- Future same-run cache may reuse only results whose input hashes, command identities, policy hashes, and relevant repository state match within the same run.
- Standalone commands remain strict by default. Internal skip or no-validate options, if added later, must be opt-in and used only by verified aggregate/hook callers that already ran the strict check.
- `test_lesson_repository.sh` should remain available as a standalone exhaustive command.
- A future hook-specific gap-only final gate should replace duplicate aggregate work only after a mechanical coverage check proves the hook catalog plus gap gate covers the standalone aggregate requirements.
- Future CI aggregation may verify required job results and attestation artifacts instead of rerunning expensive checks only after mechanical coverage proof and developer approval.
- CI dependency caching may cover npm dependencies and Playwright browser downloads; CI must not cache full verification results.
- Flaky quarantine is out of scope until a policy file, owner, expiry, issue reference, separate lane, and degraded-coverage reporting exist.

### Implemented Test And CI Final Gate Optimization Specification

The final-gate optimization converts the duplicate heavy verification into evidence-based same-run verification.
It does not make changed-only CI authoritative and does not remove standalone aggregate or full/no-cache commands.

- `tools/test_lesson_repository.sh` remains the exhaustive aggregate command for local diagnosis and explicit full validation.
- `tools/git-hooks run --mode full --no-cache` uses a hook-specific gap-only final gate instead of rerunning `tools/test_lesson_repository.sh` in full after every individual hook row has already run.
- The gap-only gate must compare the Git hook check catalog and `docs/workflow/FINAL_GATE_COVERAGE.tsv` with the aggregate command's required checks and fail closed when any aggregate requirement is not covered by an individual hook row, same-run evidence, or an explicit final-gap command.
- The gap-only gate must be testable as a standalone command and callable from the aggregate suite.
- Playwright evidence reuse is valid only within the same workflow run and only when commit SHA, workflow run ID, job identity, Playwright config hash, Playwright test file hashes, package lockfile hash, command identity, and result status match.
- As-built and sync evidence reuse is valid only within the same command or workflow run and only when synchronized document hashes, `AS_BUILT_SYNC_CONTRACT.tsv` hash, checker hashes, command identity, repository-state hash, and result status match.
- Evidence files must be repo-local or workflow-local and must not contain secrets, tokens, private messages, environment dumps, or raw external service payloads.
- Evidence files must include enough metadata for a later gate to reject stale or unrelated evidence without reading logs.
- CI dependency cache may use GitHub Actions dependency caching for npm and Playwright dependencies; verification-result cache must not be restored from a previous commit or previous workflow run.
- `CI` should keep common gates such as syntax, structure, policy regressions, Playwright, and final common verification.
- `Lesson14 CI` should keep Lesson14-specific gates and should avoid duplicating the same common final aggregate/full-hooks gate.
- `Lesson14 CI` should preserve the legacy `playwright-tests` and `aggregate-and-full-hooks` job contexts as lightweight compatibility gates; these compatibility gates must not rerun browser tests, `tools/test_lesson_repository.sh`, or `tools/git-hooks run --mode full --no-cache`.
- The Git hooks recommendation policy should recommend local `full --no-cache` verification for final-gate coverage, final-gate command, same-run evidence, and as-built evidence implementation changes.
- If required check names or branch-protection expectations prevent workflow consolidation, the implementation must preserve the names and reduce internal duplicate work instead.
- Cache or evidence mismatch, absence, parse failure, untrusted metadata, or changed input must rerun the relevant check or fail closed.
- Cleanup coverage should include Playwright reports, test results, temporary fixtures, same-run evidence, and repo-local cache directories; it must not clean OS, global dependency, Docker, swap, process, product repository, or user-home caches without explicit approval.

### Implemented Test And CI Full Pipeline Acceleration Specification

The implemented acceleration cycle is policy-driven and fail-closed.
It builds on the existing Test Plan Manifest, Git hook check catalog, Git hook parallel groups, recommendation paths, final-gate gap commands, final-gate coverage map, CI evidence helpers, as-built evidence helpers, resource guard, local Git hook runner, and CI workflow structure checks.

- GitHub Actions deprecation handling rejects old major action versions and `continue-on-error: true` without changing the required check meaning.
- Playwright setup runs through `tools/ci-playwright-setup`, which prefers npm cache reuse, checks whether Chromium is already available, and installs normally when the dependency or browser cache is missing, stale, or unsupported.
- Full-hook parallel expansion is controlled by `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv` or equivalent policy data, not by hard-coded command names.
- A check may run in parallel only when its inputs, outputs, temporary paths, logs, and side effects are classified as independent.
- Same-run evidence reuse must remain scoped to the same command or workflow run and must reject mismatched command IDs, input hashes, policy hashes, repository-state hashes, or success status.
- As-built, sync, docs-tour, final-gate, and similar documentation checks may reuse evidence only after their relevant documents, contract files, checker files, and command identities are included in the evidence metadata.
- `CI` and `Lesson14 CI` reduce duplicated common policy-regression work by separating common verification from lesson-specific compatibility verification while preserving required workflow/job contexts unless developer approval changes them.
- `Lesson14 CI` preserves its compatibility job names but must not rerun browser tests, `tools/test_lesson_repository.sh`, or full Git hooks when the main `CI` workflow provides the common gate for the same commit.
- As-built sync-contract validation accepts the Lesson14 compatibility split only when the main `CI` workflow still provides active coverage for the relevant test.
- As-built sync-contract validation may cache wiring lookup results only inside the current checker process; it must not cache verification results across commands, commits, workflow runs, repositories, or users.
- GitHub Actions optimization uses runner-oriented job splitting and cache-aware setup; it does not rely on local WSL memory limits as CI policy.
- Changed-only CI remains observe-only until a future approved change makes it authoritative.
- `tools/test_ci_pipeline_acceleration.sh` verifies the acceleration contract as a standalone check and is wired into aggregate lesson-repository validation.
- Future implementation candidates such as `tools/ci-metrics` may be added only after they exist, are generic, are testable, and are connected to the sync contract.

### CI Timing And Approved Auto-Improvement Specification

The implemented CI timing and approved auto-improvement cycle extends the existing CI acceleration work with measured evidence and proposal-only recommendations.
It does not make any generated recommendation authoritative and does not change full/no-cache coverage until a later developer-approved implementation does so.

- `tools/ci-timing run` wraps a command, preserves the wrapped command exit status, and appends one machine-readable TSV row.
- `tools/lib/ci_timing.sh` stores timing output in `CI_TIMING_DIR` or the repository-local `.git/ci-timing` path with a marker file, refusing unsafe, symlinked, or unmarked non-empty timing directories.
- Timing records are generated for the main `CI` final common `Lesson aggregate test` and `Git hooks full no-cache regression` checks, including the current split `lesson-aggregate` and `git-hooks-full-no-cache` jobs.
- A timing record includes check id, display name, command id, mode, start time, end time, duration seconds, exit status, command hash, relevant input hash, policy hash, repository-state hash, evidence-use status, workflow name, job name, run id, commit SHA, and creation time.
- Timing output is machine-readable and uploaded as the `ci-timing-${{ github.run_id }}-${{ github.run_attempt }}` GitHub Actions artifact.
- Timing output must not include secrets, tokens, private messages, full environment dumps, external service payloads, or raw logs that are not needed for duration analysis.
- `tools/check_ci_status.sh` distinguishes workflow name, run id when supplied, commit SHA when available, run status, job status, and conclusion so one successful workflow cannot mask another still-running required workflow.
- When called from this lesson repository with `--required` and no explicit workflow, `tools/check_ci_status.sh` requires both `CI` and `Lesson14 CI` for the target branch/commit.
- When called from another repository or with an explicit `--workflow`, `tools/check_ci_status.sh` preserves the narrower single-workflow behavior.
- `tools/ci-timing propose` is read-only.
- Proposal generation reports slow checks, same-run hash-evidence reuse candidates, and parallel-group candidates with reason, affected files, required verification, and developer-approval requirement.
- Proposal generation must not edit `.github/workflows/`, `docs/workflow/`, `.githooks/`, `tools/`, or any synchronized document.
- Same-run evidence reuse can be recommended only when input hashes, command identity, policy hash, repository-state hash, workflow/run identity, and success status are available.
- Missing, stale, corrupted, mismatched, or untrusted evidence should lead to strict rerun or explicit failure, not silent success.
- Conditional `full no-cache` operation remains a future approval-gated mode.
- Existing policy files and check catalogs remain the integration points; this implementation connects through them instead of adding hard-coded product-stack branches.

SYNC-ID: ci_timing_auto_improvement_plan
STATUS: implemented
ARTIFACTS: docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/check_ci_status.sh,tools/check_ci_workflow_structure.sh,tools/lib/ci_timing.sh,tools/ci-timing,tools/test_ci_timing.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_evidence.sh,tools/test_ci_final_gate.sh,tools/test_git_hooks_parallel.sh,tools/test_lesson_repository.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_ci_workflow_structure.sh,tools/test_ci_timing.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_evidence.sh,tools/test_ci_final_gate.sh,tools/test_git_hooks_parallel.sh,tools/check_as_built_sync_contract.sh

### Implemented CI Aggregate And Full-Hooks Split Specification

The implemented split keeps the same prerequisite gates and strict final checks while moving the two slow final common checks into independent jobs.
The main `CI` workflow provides the active common verification; `Lesson14 CI` remains a compatibility workflow for Lesson14-specific and legacy context coverage.

- `lesson-aggregate` depends on syntax, structure/docs, policy regressions, 7-day CLI, and Playwright evidence jobs.
- `lesson-aggregate` downloads same-run Playwright evidence, sets `CI_EVIDENCE_SOURCE_JOB: lesson-aggregate`, writes timing to `lesson-aggregate.tsv`, records timing with `tools/ci-timing run lesson_aggregate`, and runs `tools/test_lesson_repository.sh --use-evidence --write-evidence`.
- `git-hooks-full-no-cache` depends on the same prerequisite gates, downloads same-run Playwright evidence, sets `CI_EVIDENCE_SOURCE_JOB: git-hooks-full-no-cache`, records timing with `tools/ci-timing run git_hooks_full_no_cache`, and runs `tools/git-hooks run --mode full --no-cache --jobs 4`.
- `git-hooks-full-no-cache` uploads the same-run Git hook evidence artifact for the current run attempt.
- `git-hooks-full-no-cache` writes timing to `git-hooks-full-no-cache.tsv` so final artifact download cannot overwrite the lesson aggregate timing report.
- `tools/ci-timing run` unsets `CI_TIMING_REPORT` only for the wrapped child command after reading it for the wrapper report path, preventing nested timing tests from writing to or deleting the parent job report.
- `tools/lib/ci_evidence.sh` writes artifact-safe evidence filenames and keeps the original evidence id in the evidence metadata so final-gate validation remains id-based.
- `final-gate` depends on both split jobs, uses `if: ${{ always() }}` so the context is not skipped when a split prerequisite fails, validates both prerequisite results, downloads the same-run Git hook evidence artifact, sets `CI_FINAL_GATE_REQUIRE_HOOK_EVIDENCE: "1"` and `CI_EVIDENCE_EXPECT_SOURCE_JOB: git-hooks-full-no-cache`, and runs `tools/ci-final-gate`.
- `final-gate` downloads timing-part artifacts with `merge-multiple: true` and uploads the final `ci-timing-${{ github.run_id }}-${{ github.run_attempt }}` timing report.
- `Lesson14 CI` keeps the legacy compatibility `aggregate-and-full-hooks` job context and does not adopt the main `CI` split in this implementation.
- `Lesson14 CI` declares the stable `CI_COMMON_COVERAGE_SOURCE: ci-split-common-coverage` compatibility marker so structure and sync checks do not depend on free-form prose.
- The implementation must not introduce persistent verification-result cache, conditional full/no-cache skipping, changed-only authoritative behavior, or Git hook group matrix splitting.
- `tools/check_ci_workflow_structure.sh` and `tools/test_ci_pipeline_acceleration.sh` mechanically verify the split structure, evidence handoff, no-cache semantics, and timing artifact wiring.

SYNC-ID: ci_aggregate_full_hooks_split
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,tools/check_ci_workflow_structure.sh,tools/test_ci_pipeline_acceleration.sh,tools/check_as_built_sync_contract.sh,tools/ci-timing,tools/test_ci_timing.sh,tools/lib/ci_evidence.sh,tools/test_ci_evidence.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/check_ci_workflow_structure.sh,tools/test_ci_pipeline_acceleration.sh,tools/test_ci_timing.sh,tools/test_ci_evidence.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

### Implemented Dashboard Control Center Data Layer Specification

The implemented data layer defines the stable machine-readable contract for a future AI-driven development control center.
The contract is read-only and is separate from the existing learner-facing CLI dashboard.
`docs/workflow/DASHBOARD_DATA_SCHEMA.tsv` records the implemented field paths, allowed states, source groups, and safety requirements for the runtime JSON producer.

The runtime command is `tools/dashboard-data`; extending `tools/dashboard` with a JSON mode remains a separate developer-approved change.
The existing `tools/dashboard all` output remains a human-readable compatibility surface and must not become the browser parsing contract.
Any later React/Vite consumer must present the control center as a simple dashboard-backed experience; Vite commands, dev-server URLs, package scripts, and frontend implementation details are not part of the ordinary learner-facing workflow.
For non-engineer users, the intended interaction is a single dashboard/control-center entry action; maintained tooling must absorb setup, Vite startup, URL selection, JSON data loading, and verification orchestration.
The future UI should use a layered control-panel model: lesson content, lesson progress, and lesson management need plain-language summaries, while workflow content, workflow progress, workflow management, gates, evidence, partial failures, and next operational actions need precise status detail that remains useful to intermediate and senior engineers.
The repository has two first-class surfaces, lessons and workflows; any future control panel must keep those surfaces distinguishable in navigation, grouping, labels, and status hierarchy while keeping both easy to scan, understand, and operate.

Implemented top-level JSON fields:

- `schema_version`: stable version for consumers.
- `generated_at`: snapshot generation time.
- `source_files`: source file references used to build the snapshot.
- `source_commands`: read-only command identities used to build the snapshot.
- `warnings`: non-fatal warnings.
- `partial_failures`: optional lookup failures, slow command failures, unavailable evidence, or skipped live checks.
- `summary`: current control-center mode, concise guidance items, next safe action, and blocking items.
- `lessons`: STEP 1-7, STEP 1-14, and applied lesson status from existing lesson/menu sources.
- `development`: product repository, product documents, Git sync, and CI status from existing product workflow sources.
- `maintenance`: as-built sync, workflow pair, developer-memory, and repo-local skill state from existing maintenance checks.
- `git_workflow`: Git workflow policy and action-setting state from existing Git workflow settings.
- `security`: product-security and dangerous-operation readiness from existing policy and gate sources.
- `actions`: command previews that explain intent, target, risk, approval requirement, and manual command text without running the command.

Allowed state vocabulary:

```text
missing
ready
passed
failed
blocked
unknown
approval_required
optional
cached
```

The implemented data layer keeps these concepts as separate fields:

- policy readiness versus gate passage;
- settings readiness versus user approval;
- cached or same-run evidence versus required live validation;
- optional dashboard lookup failure versus required check failure;
- command preview versus command execution.

Partial failure entries must identify at least the source, non-authoritative failure status, safe reason, and optional required follow-up command.
Command preview entries must identify intent, target, risk level, approval requirement, command text, and execution mode.
The initial execution mode for dangerous operations is preview-only.

Data sources must be existing reusable sources where available, including lesson state/settings files, menu prerequisite helpers, Git workflow settings, product-security policy, as-built sync contract, and shared `tools/lib/dashboard_data.sh` helpers.
The implementation must prefer structured TSV/settings reads or reusable helper calls over brittle parsing of prose output.
Lesson status objects must distinguish an active current step from all-steps-completed state; when every state row is completed, the dashboard data uses `status: "passed"` with `current_step: "all steps completed"` instead of `unknown`.
If a source is unavailable or too slow for the dashboard snapshot, the JSON producer should return a valid snapshot with a `partial_failures` entry and a `required_command` or equivalent manual next check.

Security specification:

- Treat Markdown, CLI output, logs, generated text, external responses, and user text as untrusted text-as-data.
- Do not emit secrets, tokens, private messages, full environment dumps, raw CI logs, credential material, or unnecessary absolute paths.
- Do not rely on route names, UI-only checks, keyword filters, or prompt text as the owner-layer safety control.
- Keep dangerous operations as command previews requiring explicit developer approval before any later execution feature is considered.

SYNC-ID: dashboard_control_center_data_layer
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_GAP_COMMANDS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,tools/check_ci_workflow_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

### Implemented Dashboard Control Center React UI Specification

The implemented React/Vite UI is a read-only browser consumer for the implemented dashboard JSON data layer.
It must treat `tools/dashboard-data` and `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv` as the contract boundary, and it must not parse learner-facing CLI prose or move existing CLI, policy, evidence, Git, CI, Security guard, Resource guard, or lesson progression logic into React.

Implemented surface model:

- A top control-center summary that shows current mode, concise guidance, blockers, and next safe action from the dashboard JSON.
- A lesson area for STEP 1-7, STEP 1-14, and applied lesson state, with progress, current step or all-steps-completed state, lesson points, warnings, and next learning action in plain language.
- A workflow area for product/development state, workflow document status, Git sync, CI status, gates, evidence, approvals, blockers, and next operational action with enough precision for practical engineering work.
- A maintenance area for as-built sync, workflow pair sync, developer-memory state, repo-local skill state, and relevant documentation routes.
- A security/action-preview area that clearly separates policy readiness, settings readiness, gate passage, approval requirement, cached or same-run evidence, optional lookup failures, and unknown state.

Implemented data handling:

- UI data adapters must consume structured JSON fields and allowed state values rather than current prose labels.
- UI data adapters must not synthesize lesson points, warnings, or next learning actions from CLI prose; if those fields are needed, the dashboard JSON schema and producer must be extended first.
- Untrusted Markdown, CLI-derived strings, generated text, warnings, partial failures, and external output must be rendered as data, not executable markup or commands.
- Secret-like values, raw logs, private messages, full environment dumps, credential material, and unnecessary absolute paths must stay out of the UI data path.
- Command previews may explain intent, target, risk, approval requirement, and manual command text, but the initial UI execution mode remains preview-only.

Implemented UX constraints:

- Ordinary users access the control center through a maintained dashboard entry point; they should not need to run npm scripts, choose ports, start Vite manually, or invoke JSON/check commands manually.
- The UI must keep lesson status and workflow status visibly distinct in navigation, grouping, labels, density, and status hierarchy.
- It must provide concise notes and points near lesson/workflow cards without turning the UI into a tutorial wall or hiding operational detail from engineers.
- It must not use frontend-only state to decide safety, gate passage, approval, or CI truth.

Implemented verification:

- Keep `tools/test_dashboard_schema.sh` and `tools/test_dashboard_data.sh` as the contract guards.
- `tools/test_dashboard_control_center.sh` validates snapshot generation through `tools/dashboard-data`, React/Vite build output, browser rendering against a generic dashboard JSON fixture, state vocabulary coverage, lesson/workflow separation, command-preview safety, secret-like redaction, and responsive layout.
- Browser tests are standalone-callable and aggregate-callable, and connect through existing Playwright, Git hooks, pre-commit, CI, and as-built synchronization routes.

SYNC-ID: dashboard_control_center_react_ui_plan
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/dashboard-data,package.json,package-lock.json,vite.config.mjs,dashboard-control-center/index.html,dashboard-control-center/src/main.jsx,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/styles.css,tools/dashboard,tools/dashboard-control-center,tools/test_dashboard_control_center.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_lesson_playwright.sh,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,tools/check_ci_workflow_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_lesson_playwright.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_ci_workflow_structure.sh

### Implemented Dashboard Control Center Information Architecture Specification

The categorized dashboard control center is an implemented UI follow-up to the read-only React/Vite control center.
It keeps the dashboard JSON producer authoritative and changes only the browser information architecture, fixed UI labels, visual hierarchy, and tests.

Implemented category model:

- The dashboard opens on Overview by default.
- A persistent category navigation exposes:
  - Overview,
  - Lessons,
  - Development Workflow,
  - Maintenance Sync,
  - Safety Actions.
- Overview shows snapshot state, mode, generated time, relative age, read-only state, blocker count, next safe action, guidance, blockers, partial failures, warnings, and category-health cards.
- Lessons shows lesson cards for all structured lesson entries present in JSON, including status, current step, settings readiness, points, warnings, and next learning action.
- Development Workflow combines `development` and `git_workflow` JSON sections without flattening them into lesson state.
- Maintenance Sync shows `maintenance` JSON fields and source-boundary counts for source files, source commands, and read-only state.
- Safety Actions shows security status and command previews; command previews are not shown on the default Overview page.

Implemented localization model:

- Fixed UI chrome uses browser device language when supported.
- The first implemented locale set is `en` and `ja`; unsupported languages fall back to English.
- English remains the default.
- Technical identifiers and data-originated text remain unmodified in the browser when translation would risk changing meaning:
  - command text,
  - file paths,
  - gate IDs,
  - source file names,
  - source command names,
  - dashboard JSON guidance or warning prose,
  - product/repository identifiers.
- Dates and relative snapshot age use standard browser `Intl` APIs for the selected locale.

Implemented safety and data boundaries:

- The UI remains read-only.
- Navigation is category selection only and does not execute repository commands.
- There are no command-execution buttons.
- Command preview text is displayed only when `execution_mode` is `preview_only` and `non_executable` is true.
- Secret-like strings and unnecessary absolute paths continue to be redacted or normalized by the dashboard data display helpers.
- Frontend category-health summaries are scan aids only; they are not used as safety, approval, Git, CI, or gate truth.
- The implementation does not add automatic polling, live status authority, WebSocket updates, or browser-triggered command execution.

Implemented visual model:

- The UI follows the generated mock's high-level structure: left category navigation, top snapshot strip, Overview first screen, category health cards, and command previews isolated under Safety Actions.
- The implementation is not a pixel-copy of the generated PNG; repository constraints, real dashboard schema, responsive behavior, accessibility, and safety boundaries take priority.
- Cards keep compact operational density, 8px radii, stable grid dimensions, and responsive constraints.
- The palette uses restrained neutrals with distinct blue, teal, green, amber, and red state accents rather than a one-note color theme.

Implemented verification:

- `tools/test_dashboard_control_center.sh` still validates snapshot generation, data-source boundaries, Vite data validation, build output, and Playwright rendering.
- Playwright coverage now checks categorized navigation, Overview-first behavior, command-preview isolation, no buttons, Safety Actions preview visibility, secret-like redaction, desktop/mobile layout, and `en`/`ja` fixed-label localization.
- Existing dashboard schema/data tests remain active so the UI does not become a source of truth.

SYNC-ID: dashboard_control_center_information_architecture
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,vite.config.mjs,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

### Implemented Dashboard Control Center Visual Polish Specification

The visual-polish layer refines the categorized read-only dashboard to more closely follow `dashboard-control-center/mocks/archive/mock-categorized-dashboard.png`.
It is a frontend-only visual and layout layer over the existing dashboard JSON contract.

Implemented visual model:

- The sidebar keeps the category navigation persistent on desktop and compact on smaller viewports.
- The sidebar includes read-only and last-updated context so the control-center state remains visible outside the main content.
- The snapshot status area is a segmented operational strip instead of disconnected cards.
- Overview keeps a clear two-column desktop composition: next safe action and issue lists on the left, category health on the right.
- Category health cards use a 2x2 desktop layout with compact status rings and status pills.
- Overview includes an Explore Pages section with shortcut cards for the five dashboard categories.
- Cards keep 8px radii, restrained borders, subtle depth, stable dimensions, and responsive wrapping.
- The palette remains neutral and operational with distinct state accents rather than a single dominant hue.

Implemented layout constraints:

- Desktop should show the health-card area as two columns when the viewport has enough width.
- Mobile and narrow tablet layouts collapse without horizontal overflow.
- Text must wrap within cards, pills, and navigation items without covering adjacent content.
- Visual affordances must distinguish navigation links from executable actions; no command execution buttons are added.

Implemented safety constraints:

- Visual polish must not change the read-only data boundary.
- Command previews remain isolated to Safety Actions.
- The dashboard still renders untrusted text as data and preserves secret-like redaction.
- Health cards, shortcut cards, and status rings are scan aids only; they do not become authoritative gate, approval, CI, Git, or Security truth.

Implemented verification:

- Playwright checks assert the visual structure rather than exact screenshot pixels.
- Coverage includes segmented status items, desktop 2x2 health-card placement, Explore Pages shortcut cards, mobile no-overflow behavior, localized fixed labels, Safety Actions isolation, and absence of command-execution buttons.
- Existing dashboard data and schema checks remain the owner-layer contract tests.

SYNC-ID: dashboard_control_center_visual_polish
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

### Implemented Dashboard Control Center Mock Parity Specification

The mock-parity layer is implemented as a schema-backed UI correction over the existing read-only categorized dashboard.
It must align the real dashboard with the information density and major layout decisions shown in `dashboard-control-center/mocks/archive/mock-categorized-dashboard.png` while preserving real data authority and responsive behavior.

Implemented data model:

- The dashboard JSON producer owns category metrics; the browser must not invent health percentages, item counts, or step counts.
- Summary data includes a structured primary action with title, description, target, expected result, risk or readiness state, and source.
- Summary data includes category metrics for Overview, Lessons, Workflow, Maintenance, and Security.
- Category metrics include total count, healthy count, warning count, problem count, percentage, unit, and status.
- Partial Failures remain separate from required blockers and optional/manual follow-ups.
- Optional or unverified live checks must not be silently promoted into true failures.
- Optional or unverified live checks are represented as manual follow-ups, while `partial_failures` is reserved for true failed, blocked, or unknown failure conditions.

Implemented UI model:

- Overview shows a compact Next Safe Action card with the structured primary action.
- Issue summaries show a short Overview preview first and preserve full list access on the relevant category pages; `dashboard_control_center_mock_aligned_overview` supersedes the earlier Overview expansion path.
- Health cards use circular progress rings with the percentage value in the center, not icon-like centers.
- Health card labels and descriptions remain fixed UI chrome and follow the existing device-language boundary.
- Explore Pages cards show bottom metrics from category metric data, including unit, state marker, and percentage where available.
- Category navigation, Safety Actions command preview isolation, and read-only behavior remain unchanged.
- Mock parity is accepted by concrete structural behavior: compact primary action, compact issue summaries with detail access outside the Overview, visible Partial Failures for true failures, central percentage text in rings, Explore Pages metric rows, and alternate fixture values that catch hard-coded percentages or counts.

Implemented safety model:

- Percentages and counts are scan aids only; they do not replace gate, CI, Git, approval, or security status.
- The UI renders data-originated text as data, preserving redaction and avoiding browser-side command interpretation.
- Command previews remain non-executable and isolated under Safety Actions.

Implemented verification:

- Schema tests validate the new metric and primary-action field shapes.
- Data tests verify that metrics are produced from structured status sources rather than the mock image.
- Playwright tests verify mock-aligned structure across at least two valid fixtures without brittle pixel-perfect screenshot matching.
- Existing no-overflow, localization, Safety Actions, and source-boundary tests remain active.
- Aggregate test, full/no-cache hooks, pre-commit, and final gate are final verification evidence separate from the sync-contract `TESTS` field.

SYNC-ID: dashboard_control_center_mock_parity
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/fixtures/dashboard-control-center-invalid.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

### Implemented Dashboard Control Center Live Snapshot Sync Specification

The live-snapshot layer is implemented as a read-only snapshot refresh system around the existing Vite dashboard.
It must update an open browser session from the dashboard JSON file without requiring a page reload and without giving the browser any command execution path.

Implemented producer and writer model:

- `tools/dashboard-data` remains the authoritative JSON producer.
- `tools/dashboard-control-center snapshot` writes a validated JSON snapshot atomically.
- `tools/dashboard-control-center open` publishes an initial snapshot, runs the Vite server, and refreshes the snapshot periodically while open.
- Snapshot publication uses a temporary file, JSON validation, and rename so the browser does not read partial JSON.
- Refresh interval is configurable through repository-local command configuration or environment, not through hard-coded case branches.
- `tools/dashboard-data` publishes producer-owned `snapshot_id` and `content_hash` metadata so browser change detection does not depend on UI-invented identity.

Implemented browser model:

- The React app polls only the dashboard data endpoint with GET.
- The browser never calls Git, GitHub, CI, shell, or `tools/*` command endpoints.
- Snapshot identity is detected through producer-owned `snapshot_id` and `content_hash`; the browser treats a changed identity as the only reason to replace last-known-good data.
- When a newer valid snapshot arrives, the UI updates in place without a full reload.
- When a refresh fails, returns invalid JSON, or violates schema validation, the UI keeps the last known good snapshot and surfaces stale/refresh-error state.
- A missing initial snapshot remains a clear load failure rather than an invented dashboard state.

Implemented safety model:

- Live refresh does not make CI/Git/security information authoritative unless the producer has evidence for it.
- Browser polling must not use POST, PUT, PATCH, DELETE, shell execution, child processes, or command preview execution.
- Snapshot status and staleness indicators are display state only.

Implemented verification:

- Control-center shell tests validate atomic snapshot generation and source boundaries.
- Static checks reject browser command execution paths and non-GET dashboard-data fetches.
- Playwright tests simulate data changing while the page remains open.
- Playwright tests simulate failed refresh and verify last-known-good behavior.
- Existing schema, data, aggregate, sync, and CI-structure checks remain active.
- Aggregate test, full/no-cache hooks, pre-commit, and final gate are final verification evidence separate from the sync-contract `TESTS` field.

SYNC-ID: dashboard_control_center_live_snapshot_sync
STATUS: implemented
ARTIFACTS: docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/dashboard-control-center,vite.config.mjs,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/fixtures/dashboard-control-center-invalid.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

### Implemented Dashboard Control Center Mock-Aligned Overview Specification

The mock-aligned Overview layer is implemented as a visual and interaction refinement of the existing read-only React/Vite control center.
It uses existing dashboard data and category metrics; it does not introduce new authority or browser-side command capability.

Implemented Overview structure:

- The visible `app-header` chrome is removed from the main canvas.
- An accessible page title remains available for screen readers and tests without displaying the large current header.
- The visible snapshot explanation row is removed from the Overview.
- The status strip remains compact and data-driven.
- The visible Category Health heading is removed while the category-health region remains available through an accessible label.
- The four health cards are height-aligned in the grid.
- The primary content area follows the mock hierarchy:
  - Next Safe Action as the dominant left card.
  - Category health cards as the right-side scan area.
  - Partial Failures and Manual Follow-ups as separate third-row summaries.
  - Explore Pages below the operational summaries.
  - A concise repository-control-panel read-only notice at the bottom.

Implemented Next Safe Action behavior:

- The section uses a safe-action icon with the label/helper text outside the emphasized action row.
- Only the primary action title/status row uses the green-accented surface.
- Target, expected result, and risk render as white icon-led metadata rows below the emphasized action row.
- Target, expected result, and risk remain sourced from `summary.primary_action`.
- Data-originated text continues to pass through the existing display/redaction helpers.
- Risk/status pills remain display-only and do not become execution controls.

Implemented Partial Failures behavior:

- Overview always renders the Partial Failures summary category.
- When `partial_failures` is empty, the card shows a stable none state.
- When true failures exist, the card shows a compact count and a small non-expanding summary.
- Optional, cached, or unverified manual follow-ups are not shown as true Partial Failures.

Implemented Manual Follow-ups behavior:

- Manual follow-ups are summarized separately from Partial Failures.
- The Overview shows only a count, a concise representative summary where useful, and navigation to the relevant detail surface.
- Detailed follow-up lists remain outside the Overview so the control-panel layout does not depend on expanding disclosure content.

Implemented icon and layout behavior:

- Navigation, status-strip items, health cards, Explore Pages, summary cards, detail cards, and command previews use decorative `aria-hidden` icons or glyphs as left visual anchors.
- Health rings and category icons keep four distinct category colors consistent with the mock direction: lesson blue, workflow teal, maintenance purple, and safety green.
- Issue states keep warning/error colors separate from the category colors.
- Health-card and Explore Pages values continue to come from `summary.category_metrics`.
- Responsive constraints must prevent horizontal overflow at the existing mobile viewport coverage.

Implemented safety model:

- The Overview contains links and read-only summaries only.
- It must not add Run, Execute, Apply, Merge, Push, Check, shell, Git, GitHub, CI, or `tools/*` execution paths.
- The bottom notice is UI chrome specific to this repository control panel and does not replace safety checks.

Implemented verification:

- Playwright checks validate structure and behavior rather than pixel-perfect screenshot equality.
- Tests cover a non-empty Partial Failures fixture and a live-update fixture where Partial Failures is empty.
- Tests verify the removed visible Category Health heading, none state, separate manual follow-up summary, repository notice, global icon anchors, distinct health-ring category colors, no command buttons, mobile no-overflow, and live refresh behavior.

SYNC-ID: dashboard_control_center_mock_aligned_overview
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/archive/mock-categorized-dashboard.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

### Implemented Dashboard Control Center Detail-Page Mock Parity Specification

The detail-page mock-parity layer is implemented as a visual and information-architecture refinement of the read-only React/Vite control center.
It uses the approved detail mock images as the UI/UX source of truth for hierarchy, density, color direction, and icon direction while continuing to render from the existing dashboard snapshot.

Implemented shared detail-page structure:

- Every detail page starts with a mock-aligned page header containing category icon, title, explanatory subtitle, last-updated metadata, and read-only snapshot framing.
- Each detail page then renders a compact decision summary.
- The decision summary contains four semantic cells:
  - what this page checks;
  - current judgment;
  - must-review items;
  - next safe check.
- Decision-summary cells may render compact bullet lists, count badges, safe in-page or category links, and tone-specific emphasis when that information is derived from existing dashboard snapshot state.
- Decision summary text comes from fixed localized UI labels and existing dashboard data, not fixture-specific branches.
- Category color and icon identity must continue from the Overview into the detail page.
- Category header icons and card icons use per-category presentation rules rather than one generic rounded-square treatment, while keeping all decorative icons hidden from assistive labels.
- Decorative icons remain `aria-hidden` unless they are part of an accessible label.
- The UI locale resolver can consume future `summary.display_locale`, `summary.ui_locale`, or `summary.environment_locale` hints before falling back to browser languages.
- Lesson/workflow language settings remain user-selected workflow state fields and are not used as the control-panel UI locale.

Implemented icon behavior:

- The workflow category uses one centralized branching workflow icon component that matches the approved mock icon wherever the workflow category itself appears.
- The same workflow icon component is reused for navigation, Overview health cards, Explore Pages, workflow detail page header, and workflow category summary rows.
- Workflow item rows may use more specific icons for repository, documents, sync, CI, policy, settings, gate, and approval while keeping the category icon language consistent.
- Safety status and Partial Failures severity rows use distinct glyphs for failure, block, warning, gate, and approval states instead of a single generic alert icon.

Implemented page behavior:

- Lessons detail:
  - explains whether lesson readiness is sufficient before treating workflow readiness as clear;
  - renders mock-aligned lesson inspection panels with status bands, lesson icons, warning callouts, and row-based checks;
  - derives the primary warning callout from structured lesson setting status fields instead of matching warning text;
  - keeps reference files and internal keys secondary.

- Development Workflow detail:
  - explains whether workflow status can be treated as operationally ready;
  - separates must-review items from ready items as full-width checklist rows;
  - orders approval-required and unknown states before ready states;
  - uses human-readable titles while keeping technical keys as secondary metadata.

- Maintenance Sync detail:
  - explains whether the dashboard snapshot and maintenance sync state can be trusted;
  - groups manual follow-ups, warnings, and source boundaries as a confirmation table and reference boundary panel;
  - presents command-like references as read-only reference chips or code, never buttons.

- Safety Actions detail:
  - explains what is stopped, why it is stopped, and what approval is needed;
  - makes Partial Failures a scannable severity table distinct from manual follow-ups and Command Previews;
  - labels Command Previews as display-only and keeps preview cards visually non-executable with command chips, not buttons;
  - groups display-only command previews as a compact read-only section rather than a set of action controls;
  - emphasizes failed, blocked, approval-required, and critical states without adding action controls.

Implemented layout behavior:

- Detail pages use stable responsive constraints rather than language-specific branches.
- Cards, rows, pills, and code chips must not overlap or force horizontal overflow at the existing mobile viewport coverage.
- Short localized pill labels such as `低` are visually centered.
- Empty or sparse status cards should include concise meaning or metrics derived from available data rather than large blank areas.

Implemented safety model:

- Detail pages contain links, summaries, status rows, read-only code/reference chips, and command previews only.
- They must not add Run, Execute, Apply, Merge, Push, Check, shell, Git, GitHub, CI, or `tools/*` execution paths.
- Command text remains untrusted data and continues to pass through the existing display/redaction helpers.

Implemented verification:

- Playwright checks validate structure, behavior, and safety boundaries rather than pixel-perfect equality with generated mock images.
- Tests cover the four detail pages, the unified workflow icon category, decision summary presence, readable workflow titles, centered short risk labels, no command buttons, safe command-preview labeling, mobile no-overflow, and existing live refresh behavior.

SYNC-ID: dashboard_control_center_detail_mock_parity
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/archive/mock-detail-lessons.png,dashboard-control-center/mocks/archive/mock-detail-workflow.png,dashboard-control-center/mocks/archive/mock-detail-maintenance.png,dashboard-control-center/mocks/archive/mock-detail-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/test_lesson_repository.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

## Product Repository Boundary

The default lesson-created product repository path is configured outside this repository.
The boundary is checked by `tools/check_repository_boundary.sh --product-required`.
Lesson-repository validation does not recreate that repository and does not depend on it.
Real 7-day, 14-day, Free Development, and Team Development product workflows may require a product repository after the learner intentionally creates or selects one.

## Planned Lesson Display Label Policy Specification

SYNC-ID: lesson_display_label_policy
STATUS: implemented
ARTIFACTS: docs/workflow/LESSON_DISPLAY_LABELS.tsv,tools/lib/lesson_display_labels.sh,tools/lib/lesson_common.sh,tools/lib/lesson_runtime.sh,tools/menu,tools/dashboard,tools/learn,tools/helpdesk,tools/lesson14,tools/roadmap,tools/docs-tour,README.md,AGENTS.MD,index.md,index-14-days.md,ai-driven-task-tracker-scenario.md,guides/LESSON_14_DAYS.md,learning/ROADMAP.md,lesson/LESSON_FLOW_14_DAYS.tsv,prompts/PROMPTS.md,prompts/PROMPTS_14_DAYS.md,playbooks/AGENT_PLAYBOOK.md,playbooks/AGENT_PLAYBOOK_14_DAYS.md,tools/check_learner_display.sh,tools/test_menu_prerequisites.sh,tools/check_lesson14_sync.sh,tools/check_agents_skills.sh
TESTS: tools/check_learner_display.sh,tools/test_menu_prerequisites.sh,tools/check_lesson14_sync.sh,tools/check_agents_skills.sh,tools/test_lesson14.sh

This implemented policy defines separate categories for display labels, progress keys, internal aliases, and historical evidence.
The policy is implemented before learner-facing STEP wording is considered complete.

- Course display labels are learner-facing names for menu, dashboard, README, index, guides, prompts, playbooks, docs-tour surfaces, and normal CLI output.
- Progress keys such as `Step N/7` and `Step N/14` remain valid for lesson flow, roadmap lookup, sync-gate matching, tests, and command diagnostics.
- Internal compatibility names such as `7-day`, `14-day`, `lesson14`, `index-14-days.md`, `_14_DAYS`, and `dayN.*` remain valid in filenames, command names, TSV keys, tests, internal diagnostics, and compatibility guidance.
- Historical records in `learning/LEARNING_TASK_TRACKER*.md`, `learning/LEARNING_HANDOFF*.md`, approvals, and helpdesk archives remain auditable and are not blanket-renamed.
- New learner-facing output should avoid exposing `dayN.*` step IDs unless it is explicitly presenting a command ID or diagnostic value.
- `tools/check_learner_display.sh` uses the display-label policy and active-surface checks to fail when old learner-facing labels appear in active learner surfaces.
- `tools/menu`, `tools/dashboard`, `tools/roadmap`, `tools/lesson14`, `tools/learn`, and `tools/helpdesk` share or consume the same display-label boundary so new learner-facing output avoids old course labels and raw internal step IDs.
- `tools/check_lesson14_sync.sh`, `tools/check_lesson14_structure.sh`, and `tools/test_lesson14.sh` must continue to protect the `Step N/14` sync-gate contract unless a later approved implementation separates sync keys from display labels mechanically.
- The implementation adds `docs/workflow/LESSON_DISPLAY_LABELS.tsv` and `tools/lib/lesson_display_labels.sh` as the reusable display-label policy and shared helper.

## Implemented External Product Repository Authority Specification

SYNC-ID: external_product_repository_authority
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/test_product_repository_authority.sh,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,tools/test_lesson_repository.sh,tools/check_lesson_structure.sh,tools/check_lesson14_structure.sh,.github/workflows/ci.yml,.github/workflows/lesson14-ci.yml,tools/check_ci_workflow_structure.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_test_plan_coverage.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

This implemented specification defines the contract for operating external product repositories and reporting their state to the dashboard.

Product repository structure:

- Product repositories keep only root-level operational entry files that must be immediately discoverable, including `.git`, `AGENT.md`, `README.md`, `.gitignore`, selected stack entry files, and optional CI configuration.
- Product design documents live under `docs/product/`.
- Product workflow documents live under `docs/workflow/`.
- Product memory and recovery documents live under `docs/memory/` when used.
- Product operation manifests live under `ops/`.
- `docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv` is the lesson-side policy source for the expected product skeleton.
- The structure policy records required mode, workflow contexts, product types, validation rule, dashboard visibility, canonical path, and legacy paths.
- Root-level duplicate product documents are blocked by the shared resolver; the canonical structure is `docs/product/`, `docs/workflow/`, and `docs/memory/`.
- Standard root control directories such as `.github/workflows/` and `.githooks/` remain root-level control directories, not docs cleanup targets.

Manifest contract:

- `ops/STAGE_MANIFEST.tsv` declares lifecycle stages.
- `ops/TEST_PLAN_MANIFEST.tsv` declares tests and whether they are required in the current product context.
- `ops/CI_MANIFEST.tsv` declares CI workflows and required status expectations.
- `ops/INTEGRATION_MANIFEST.tsv` declares external integrations and approval needs.
- `ops/SECURITY_MANIFEST.tsv` declares security checks and required evidence.
- `ops/DASHBOARD_MANIFEST.tsv` declares product surfaces that may appear in the dashboard.
- Manifest column contracts are defined in `docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv` so each `ops/*_MANIFEST.tsv` can be parsed without stack-specific code.
- Missing optional manifests must be visible as optional or unknown state, not silently treated as healthy.
- Missing required manifests must be visible as blockers for product operations.

Evidence contract:

- Product gate evidence is stored under the product repository `.git/product-gate-evidence/` area so routine source commits do not persist volatile local evidence.
- Evidence items use stable source ids and a fixed status vocabulary.
- Evidence binds observations to workflow context, product root, product HEAD where applicable, observation time, freshness state, required-in-context state, authority, source artifacts, blockers, and read-only next-command previews.
- `docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv` is the lesson-side policy source for evidence fields.
- Evidence index rows use the fixed TSV columns recorded in the evidence schema.
- Evidence statuses include `not_run` and `stale`; dashboard schema and UI state handling must preserve those meanings instead of collapsing them into `unknown`.
- Source ids use the fixed namespaces recorded in the evidence schema, including `repositories.product` for missing product repositories.

Dashboard contract:

- `docs/workflow/DASHBOARD_DATA_SCHEMA.tsv` defines product authority, manifest summary, evidence summary, and product-operation blocker fields before the dashboard UI relies on them.
- `tools/dashboard-data` exposes product authority, manifest summary, and evidence summary as structured data.
- `tools/dashboard-data` reads existing product manifests and evidence only. It must not create product evidence, run product checks, call `gh`, fetch remotes, query GitHub Actions, or mutate the product repository.
- Dashboard UI must render producer-owned product status and freshness instead of inventing state from UI labels.
- Product repository missing status blocks product operations only; it does not block lesson-only progress.
- Product-operation blockers must be source-scoped in product authority data rather than mixed into lesson-only summary blockers.
- The browser remains read-only and may reload or poll data, but it must not execute product checks or mutate repositories.

## Implemented STEP 1-14 Product Launch Quality Gate Specification

SYNC-ID: step_1_14_product_launch_quality_gate
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,lesson/SYNC_GATES_14_DAYS.tsv,lesson/LESSON_FLOW_14_DAYS.tsv,prompts/PROMPTS_14_DAYS.md,skills/lesson-sync-gate/SKILL.md,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/product-launch-check,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

The STEP 1-14 final product launch contract is defined by the product repository's user-facing README launch instructions.
For the standard task-tracker product, the implemented contract is direct browser opening of `index.html` without requiring a local HTTP server unless a later approved specification changes that launch path.

Launch-gate behavior:

- The lesson completion gate must verify the documented product launch path, not only a server-based developer test path.
- The gate must check the primary user workflow: add a task, show it in the list, update active/done counters, change status, and clear completed tasks.
- The gate must fail when the product README promises direct opening but the runtime code only works through HTTP server module loading.
- The gate must treat URL query parameters such as `?title=...` as a failure symptom unless a future requirement explicitly adds query-prefill behavior.
- The final STEP 1-14 completion flow must not pass solely because unit tests, HTTP-only E2E, CI, or document checks pass.
- Product-side README, requirements, specification, implementation plan, task tracker, and handoff must describe the same launch path and verification path.

Verification contract:

- Product launch-path verification must be runnable directly for a product repository and callable from the lesson aggregate path.
- The implemented launch verifier is exposed through `tools/product-launch-check` and `tools/test_product_launch_check.sh`.
- The sync contract records the launch verifier runtime artifacts and tests now that they exist.
- Existing STEP 1-14 sync gates remain ordered and approval-controlled.
- When the product repository is missing, lesson-side checks must report the missing product context safely rather than recreating or mutating the repository.

## Implemented Product Authority Evidence Status Propagation Specification

SYNC-ID: product_authority_evidence_status_propagation
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/test_product_repository_authority.sh,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/test_dashboard_data.sh,tools/test_dashboard_schema.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

Product authority evidence aggregation must be deterministic, context-aware, and blocker-preserving.

Evidence aggregation contract:

- The evidence index may contain zero, one, or many rows.
- Multiple rows that match the requested workflow context or `all` must emit a valid JSON array.
- Invalid evidence rows must not corrupt the dashboard JSON output; they must be reported as failed, blocked, or unknown authority state.
- Required evidence in `failed` or `blocked` state must create product-operation blockers.
- Required evidence in `stale`, `not_run`, or `unknown` state must create stale, not-run, unknown, or manual-required product-operation state rather than being treated as ready.
- Optional evidence must remain visible without becoming a required blocker.
- Context-mismatched evidence must not improve the selected context status.

Status contract:

- `status`, `freshness_state`, `authority`, `required_in_context`, `blocked_by`, and `next_command` remain separate fields.
- Product authority status must derive from the worst applicable required evidence and required structure state.
- Product-operation blockers must remain separate from lesson-only blockers and summary manual follow-ups.
- Product authority remains read-only; evidence creation is a separate future capability.

## Implemented Free Development Product Repository Scaffold Specification

SYNC-ID: free_development_product_repo_scaffold
STATUS: implemented
ARTIFACTS: free-development/FREE_DEVELOPMENT_MODE.md,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,tools/free-development,tools/product-improvement,tools/external-integration,tools/product-scaffold-check,tools/test_product_scaffold_check.sh,tools/test_product_gate_tools.sh,tools/test_product_repository_authority.sh,tools/check_workflow_pair_sync.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_product_scaffold_check.sh,tools/test_product_gate_tools.sh,tools/test_product_repository_authority.sh,tools/check_workflow_pair_sync.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

Free Development product repositories use a policy-driven scaffold contract rather than a copied lesson-repository shape.

Scaffold contract:

- Root-level files are limited to immediately discoverable product controls such as `.git`, `AGENT.md`, `README.md`, `.gitignore`, selected runtime entry files, and standard control directories.
- Product requirements, specification, and implementation plan are canonical under `docs/product/`.
- Product task tracker and handoff are canonical under `docs/workflow/`.
- Product memory and recovery files are canonical under `docs/memory/` when present.
- Operation declarations are canonical under `ops/`.
- Legacy root product documents remain readable through shared resolvers until compatibility is intentionally removed through a later approved migration.
- A manifest-backed entrypoint declaration must identify the browser or runtime entrypoint, source authority, test authority, CI authority, security authority, and dashboard-visible surfaces.
- The implemented scaffold validator is exposed through `tools/product-scaffold-check` and `tools/test_product_scaffold_check.sh`.
- Any new scaffold manifest file added at runtime must be added to the sync contract artifacts when the file exists.
- Scaffold validation must use product type and workflow context, not hard-coded product names or stack-specific branches.

Workflow contract:

- Free Development, Product Improvement, and External Integration must use the same product-repository authority rules.
- Missing required scaffold entries block product operations but must not block unrelated lesson-only progress.
- Optional stack-specific files are allowed when declared through policy or manifests.

## Implemented Dashboard Control Center Selected Context Sync Specification

SYNC-ID: dashboard_control_center_selected_context_sync
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/lib/product_repository_authority.sh,tools/product-repository-authority,tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

This implemented specification defines the selected-context contract that the browser dashboard uses to present menu-specific live state as intuitive control-panel content.
This fourth-priority dashboard specification displays the data produced by the launch-quality, evidence-status, and scaffold contracts rather than making the browser responsible for those decisions.

Selected-context data contract:

- `selected_context` is producer-owned dashboard JSON data that identifies the current menu, workflow context, target repository, product type, lesson step, next safe action, Git state, CI state, Security state, authority evidence, blockers, and update metadata.
- `available_contexts[]` lists the menu choices the UI may show, including STEP 1-7, STEP 1-14, applied lessons, Free Development, Product Improvement, External Integration, and lesson-repository improvement.
- UI selection may choose which available context to display, but the UI must not invent repository names, workflow context, authority status, progress percentages, blockers, or command previews.
- The default selected context is resolved by the producer from existing lesson state, workflow settings, menu prerequisites, and product authority inputs.
- Lesson display language and product development language remain workflow state. They are not the control-panel UI locale resolver.

Context resolver behavior:

- The resolver uses existing policy and settings sources, including lesson config files, workflow context maps, Git workflow settings, product structure policy, product gate evidence schema, product manifests, and current lesson state.
- Resolver status readers mean read-only access to existing settings, manifests, and evidence read models; they do not execute shell commands, Git, GitHub, CI, product-security, product-authority, or evidence writers.
- STEP 1-14 may continue to resolve `task-tracker-repository` as its standard product repository.
- Free Development, Product Improvement, and External Integration must resolve product repository and workflow context through policy-backed context data, not hard-coded `task-tracker-repository` or `product-improvement` assumptions.
- Lesson-repository improvement is a lesson-repository context and must not be treated as an external product operation unless a later approved workflow explicitly selects one.

Evidence and status behavior:

- Product authority must preserve `not_run` and `stale` states and must promote `failed` and `blocked` evidence into product authority status and product-operation blockers.
- Multiple evidence rows must produce valid JSON and deterministic latest/status aggregation.
- Partial Failures contain true failed, blocked, or unknown conditions that affect the current selected context.
- Optional, cached, not-run, not-collected, and manual-required checks belong in manual follow-up or evidence sections unless they are current blockers.
- Auto-merge availability must be evidence-backed; missing developer auto-merge gate evidence is a blocker or manual-required state, not a ready state.

Dashboard read-only boundary:

- `tools/dashboard-data` reads existing state, settings, manifests, and evidence only.
- `tools/dashboard-data` must not create evidence, fetch remotes, call GitHub, run CI, run product checks, mutate repositories, or treat browser state as authoritative.
- Browser pages may fetch dashboard JSON with GET and may keep last-known-good data, but must not execute shell, Git, GitHub, CI, `tools/*`, product-security, product-authority, merge, push, or cleanup commands.

UI behavior:

- The Overview shows a menu selector, selected-context summary, four context-aware status cards, Git management overview, and Security overview.
- Detail pages start with a current-state summary explaining what is checked, what can be decided, what needs review, and the next safe check for the selected context.
- The five `mock-context-*` images guide hierarchy, icon direction, density, color identity, and intuitive comprehension without becoming screenshot-equality test oracles.
- Source files, source commands, and read-only boundaries are presented as evidence or data-grounding details, not as primary user tasks.

## Implemented Dashboard Control Center Context Mock Source Of Truth Specification

SYNC-ID: dashboard_control_center_context_mock_source_of_truth
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

This implemented specification makes the five `mock-context-*` images the current UI/UX authority while keeping `tools/dashboard-data` and the dashboard schema as the state authority.

Shell and navigation:

- The browser app uses a shared shell with fixed brand, main navigation, repository/navigation support links, page-specific active styling, and a read-only notice.
- The sidebar is a navigation surface only. It must not expose executable Git, CI, Security, or repository commands.
- Navigation anchors remain stable for `#overview`, `#lessons`, `#workflow`, `#maintenance`, and `#safety`.

Overview:

- The Overview header shows the page identity, selected-menu purpose, generated or refreshed timestamp, and a read-only refresh affordance that fetches or reloads dashboard JSON without running commands.
- The menu-tile strip renders the seven workflow/menu choices from `available_contexts[]` and the selected state from `selected_context.menu_id`.
- Selecting a non-authoritative menu option may change display focus only when producer-owned data for that context is available; otherwise the UI must show it as inspectable summary data, not as newly authoritative state.
- The selected-context strip renders current context, target repository, next safe action, and update time from producer-owned fields.
- Overview status cards render lesson progress, Git status, CI status, and Security status from dashboard data, not from hard-coded mock numbers.
- Git management settings and Security confirmation are cross-cutting summaries with details routed to Workflow, Maintenance, and Safety pages.

Detail pages:

- Lessons renders selected lesson state, progress, current step, next learning action, lesson choices, status table, and lesson-health notice from lesson and selected-context data.
- Development Workflow renders Git action settings, Git sync, CI, PR/Merge, product evidence, next step, recent workflow evidence where available, and read-only evidence notices from producer-owned status and evidence fields.
- Maintenance Sync renders as-built sync, workflow pair, developer memory, repo-local skills, Git workflow settings, Security policy, evidence rows, source files, source commands, and read-only source boundaries from maintenance, Git workflow, Security, and metadata fields.
- Safety Confirmation renders Security gate, approvals, dangerous operations, Partial Failures, command previews, and Security policy state from `security`, `partial_failures`, and `actions.command_previews`.

Data and localization:

- React may normalize display shape, but it must not invent healthier status, repository identity, command authority, current step, progress totals, evidence freshness, or blocker state.
- New fields needed for current-step labels, operation rows, maintenance evidence rows, approvals, dangerous-operation summaries, or command-preview grouping must be added to `DASHBOARD_DATA_SCHEMA.tsv` before UI reliance.
- Fixed labels use `i18n.js`; data-originated identifiers, command text, paths, source ids, and evidence ids remain sanitized data.
- The UI locale may use browser/environment hints. Lesson workflow display language and product development language remain separate workflow settings.

Safety:

- The browser uses GET-only snapshot reads and last-known-good behavior.
- Run, Execute, Apply, Merge, Push, Check, shell, Git, GitHub, CI, `tools/*`, product-security, product-authority, and cleanup command execution remain outside the browser UI.
- Partial Failures and manual follow-ups remain separate categories.

Verification:

- Tests verify the mock-aligned structure, data-backed fields, read-only boundary, command-preview isolation, i18n labels, and responsive no-overflow behavior without requiring pixel-perfect screenshot equality.

## Implemented Dashboard Control Center Exact Mock Alignment Correction Specification

SYNC-ID: dashboard_control_center_mock_exact_alignment_correction
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,docs/workflow/TEST_PLAN_MANIFEST.tsv,docs/workflow/GIT_HOOK_CHECKS.tsv,docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv,docs/workflow/FINAL_GATE_COVERAGE.tsv,free-development/FREE_DEVELOPMENT_MODE.md,templates/TEMPLATES.md,lesson/SYNC_GATES_14_DAYS.tsv,tools/lib/dashboard_data.sh,tools/dashboard-data,tools/lib/product_repository_authority.sh,tools/free-development,tools/product-improvement,tools/external-integration,tools/product-scaffold-check,tools/product-launch-check,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_launch_check.sh,tools/test_product_gate_tools.sh,tools/check_lesson14_sync.sh,tools/test_lesson14.sh,tools/check_test_plan_coverage.sh,tools/test_test_plan.sh,tools/test_git_hooks.sh,tools/test_git_hooks_parallel.sh,tools/test_ci_final_gate.sh,tools/check_ci_workflow_structure.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

This implemented correction specifies the exact mock-aligned dashboard control-center runtime now used for the developer-approved visual target.
The browser remains a renderer of producer-owned state, and the rendered structure now lets the current mocks define the user-facing hierarchy instead of the older generic dashboard components.

Data contract:

- The producer must expose enough selected-context data for every selectable menu context that the UI displays.
- `available_contexts[]` must not remain a thin menu/status list for the corrected runtime. It must either be expanded with the full fields needed by the selected-context UI or be paired with a `contexts_by_menu` style producer-owned map that carries repository, workflow context, step, Git, CI, Security, evidence, blocker, metric, and update data for each displayed menu.
- The UI may choose an available context for display, but it must not invent repository identity, workflow context, Git status, CI status, Security status, product evidence, blockers, current step, command-preview groups, or progress percentages.
- If a context lacks complete producer-owned data, the UI must display a safe incomplete state such as `blocked`, `unknown`, `manual_required`, `not_run`, or `stale`; it must not fill the gap with mock text.
- Selected-context Git, CI, and Security status are derived from the product authority evidence axis for the active product workflow context. Product-operation blockers and required evidence items with matching `product.git.*`, `product.ci.*`, or `product.security.*` source ids take precedence over generic policy defaults.
- Required evidence with `status=passed` is authoritative only when `freshness_state=current` and `authority=authoritative`. Advisory, cached, stale, not-run, failed, blocked, or unknown required evidence remains non-healthy and must remain visible through blockers, selected-context status, evidence rows, or safe manual-required state.
- Lesson live status, Maintenance status cards, and Safety status cards render descriptions from lesson setting states, snapshot identity, maintenance evidence rows, security approval rows, dangerous-operation rows, and current-context Partial Failures rather than fixed explanatory prose.
- Category metrics must distinguish selected-context progress from optional, unknown, not-run, cached, or manual follow-up state.
- Partial Failures are limited to current-context failed, blocked, or unknown conditions. Optional and not-yet-collected evidence remain manual follow-up or evidence detail unless they block the selected context.

UI structure:

- The React shell must be split into page-specific surfaces for Overview, Lessons, Development Workflow, Maintenance Sync, and Safety Confirmation.
- Shared components may cover shell, sidebar, icon badge, status pill, data sanitization, i18n labels, and read-only notice behavior.
- Generic decision or snapshot components must not erase page-specific meaning when a mock uses different hierarchy, numbered steps, status rows, tables, command-preview groups, or evidence panels.
- Sidebar groups, active-state styling, icon identity, color identity, contrast, card density, icon centering, background fill or transparency, and content amount must follow the current mock family.
- Repository information, documents, settings, help, and changelog pages remain non-runtime surfaces until a later mock-backed specification adds them.

Product repository and evidence behavior:

- STEP 1-14 may keep `task-tracker-repository` as its standard product repository.
- Free Development, Product Improvement, and External Integration must resolve target repositories through policy-backed context data, not fixed dashboard assumptions.
- Product scaffold expectations remain canonical under `docs/product/`, `docs/workflow/`, `docs/memory/`, `ops/`, `src/`, and `tests/`, with root duplicate Markdown documents blocked.
- `docs/memory/` is a standard directory in the external product scaffold. Individual memory documents may remain optional and appear only when the workflow uses them, but the scaffold and validators must not treat the directory concept as a stack-specific exception.
- Product manifest entries must identify entrypoint, source authority, test authority, CI, security, and dashboard-visible surfaces without stack-specific branches.
- Launch verification must connect README launch instructions with the manifest-backed entrypoint and user workflow before STEP 1-14 final completion depends on it.

Safety boundary:

- `tools/dashboard-data` remains a read-only producer. It may read existing settings, manifests, and evidence but must not create evidence, run Git, call GitHub, run CI, execute product-security or product-authority checks, or mutate repositories.
- Browser pages use GET-only snapshot reads and must not expose executable operations.
- Any future evidence writer, auto-merge execution, repository mutation, or live network polling belongs to a separate approved specification.

Verification contract:

- This implemented sync ID requires dashboard schema/data, browser control center, product authority, scaffold, launch quality, product gate, STEP 1-14 sync, STEP 1-14 aggregate, and as-built synchronization checks.
- The sync contract and all five synchronized blocks carry the same targeted runtime `TESTS` list for the implemented state.
- Future changes remain governed by AGENTS.MD local-verification scope and must run only the checks required by changed surfaces and the active workflow contract.

## Implemented Dashboard Lessons Page Exact Mock Alignment Specification

SYNC-ID: dashboard_control_center_lessons_page_exact_mock_alignment
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

The Lessons page remains a read-only renderer of producer-owned dashboard data for the selected workflow context.
`dashboard-control-center/mocks/mock-context-lessons.png` was the visual and content-quantity source of truth for this implemented pass.

Required behavior:

- Render the Lessons page with the same visible page structure, icon treatment, color contrast, density, label hierarchy, progress presentation, and card content amount shown by the current Lessons mock.
- Reuse existing dashboard data fields for lesson mode, lesson progress, current step, approvals, blockers, follow-up state, repository identity, language settings, Git/CI/Security summaries, and evidence state.
- Display safe incomplete states when producer data is missing; the React view must not invent progress, blocker, approval, Git, CI, Security, or repository facts.
- Keep the control-panel UI locale separate from lesson display language and product development language.
- Keep the sidebar and common status surfaces consistent with the current mock family while making only the Lessons page the runtime scope of this planned pass.
- Preserve responsive behavior so desktop, narrow desktop, tablet, and phone widths do not overflow or hide primary labels.

Implementation boundary:

- Runtime changes should stay in `dashboard-control-center/src/App.jsx`, `dashboard-control-center/src/i18n.js`, `dashboard-control-center/src/styles.css`, and the related Playwright coverage unless a missing producer field is discovered.
- If a missing producer field is discovered, stop and plan the schema and producer change instead of filling the UI with fixed text.
- Do not turn mock image equality into an automated oracle. Use Playwright and screenshots for human visual inspection, and use tests for structural and behavior regressions.

## Implemented Dashboard Control Center Visual Refinement Follow-up Specification

SYNC-ID: dashboard_control_center_visual_refinement_followup
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/memory/DEVELOPER_MEMORY.md,dashboard-control-center/mocks/mock-context-overview.png,dashboard-control-center/mocks/mock-context-lessons.png,dashboard-control-center/mocks/mock-context-workflow.png,dashboard-control-center/mocks/mock-context-maintenance.png,dashboard-control-center/mocks/mock-context-safety.png,dashboard-control-center/src/App.jsx,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh
TESTS: tools/test_dashboard_control_center.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh,tools/check_test_plan_coverage.sh,tools/check_ci_workflow_structure.sh

This specification defines the post-review visual refinement layer for the dashboard control center.
The browser remains a read-only renderer, and the refinement is limited to UI hierarchy, localized fixed labels, copy affordances, animation behavior, and responsive layout.

Sidebar contract:

- Every implemented page uses the same sidebar items and groups.
- The active item, sidebar brand color, and support-group spacing must not vary by page.
- Links for repository information, documents, settings, help, and changelog remain navigation placeholders until a later mock-backed runtime page exists.

Animation and progress contract:

- Lesson progress animation is decorative and must not change state semantics.
- Number count-up runs only on first render and completes within one second.
- Progress cards, progress bars, icons, and percentage labels use solid colors and white card backgrounds.
- Fractions may style denominator text smaller than the numerator, but numerator digits must remain uniform.

Copy and tooltip contract:

- Source, reference, and command-preview fields keep values on one line with ellipsis when they overflow.
- Copy controls sit outside the value field and use a copy icon, not a file-open icon.
- Hover and keyboard focus on the value field or copy control show the full value in a compact tooltip bubble with a visible pointer.
- Copy behavior must copy the underlying full value, not the truncated display string.

Localization and data contract:

- Fixed control-center labels use `i18n.js` and may adapt to the user environment.
- Known English producer details may be mapped to localized fixed labels only when the meaning is controlled by this dashboard contract.
- File paths, command text, source ids, evidence ids, and repository facts remain sanitized producer data.
- React must not invent healthier Git, CI, Security, lesson, evidence, or blocker state.

Responsive contract:

- Cards, tables, source fields, command previews, and sidebar surfaces must avoid horizontal overflow on desktop, narrow desktop, tablet, and phone widths.
- Lesson cards and dense status grids must stack before labels or key values become cramped.
- Safety command previews use a vertical layout so the command and policy panels keep readable width.

## Implemented Menu Product Display Profile Confirmation Specification

SYNC-ID: menu_product_display_profile_confirmation
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/MENU_PRODUCT_PROFILE_POLICY.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/lesson_common.sh,tools/lib/product_repository_authority.sh,tools/product-profile,tools/menu,tools/lesson,tools/lesson14,tools/free-development,tools/product-improvement,tools/external-integration,tools/team-development,tools/product-scaffold-check,tools/test_menu_prerequisites.sh,tools/test_lesson.sh,tools/test_lesson14.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_menu_prerequisites.sh,tools/test_lesson.sh,tools/test_lesson14.sh,tools/test_dashboard_data.sh,tools/check_lesson_structure.sh,tools/check_agents_skills.sh

Profile contract:

- `docs/workflow/MENU_PRODUCT_PROFILE_POLICY.tsv` maps each menu choice to a stable menu id, profile scope, optional recommended Japanese and English name, localized description, and safe source-document list.
- Product-scope profile data lives in the external repository at `ops/PRODUCT_PROFILE.json`.
- Lesson-scope profile data lives under the lesson repository learning state and is used only for menu 7.
- `ops/PRODUCT_PROFILE.json` uses `schema_version: "1.0.0"`, `profile_kind: "product_display_profile"`, locale-keyed `display_name`, locale-keyed `description`, `source: "learner_confirmed"`, `confirmed_at`, and safe relative `source_documents`.

Runtime contract:

- `tools/product-profile set` requires `--confirm`; product-scope writes also require the product repository boundary check.
- `tools/menu check/start` requires the profile for all seven menu choices.
- `tools/lesson` and `tools/lesson14` require the profile before passing `setup.index`.
- Free Development, Product Improvement, External Integration, and Applied Lesson direct `start` and `gate` commands require the same profile prerequisite.
- `tools/product-repository-authority` exposes `development.product_authority.product_summary` from `ops/PRODUCT_PROFILE.json`; missing or invalid profiles remain `missing` or `failed` and are not replaced with inferred names.
- The React dashboard chooses `product_summary.display_name[locale]`, then Japanese, then English, then producer fallback `name`.

Security contract:

- Profile strings are sanitized as display text, limited in length, and rejected when they contain unsupported control characters.
- Source document entries must remain safe relative paths.
- The dashboard remains read-only and cannot write or edit the profile.

## Implemented Product Repository Canonical Docs Only Specification

SYNC-ID: product_repository_canonical_docs_only
STATUS: implemented
ARTIFACTS: AGENTS.MD,docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv,docs/workflow/PRODUCT_REPOSITORY_FORBIDDEN_ROOT_PATHS.tsv,docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv,prompts/PROMPTS.md,prompts/PROMPTS_14_DAYS.md,lesson/LESSON_FLOW.tsv,lesson/LESSON_FLOW_14_DAYS.tsv,lesson/SYNC_GATES_14_DAYS.tsv,playbooks/AGENT_PLAYBOOK.md,playbooks/AGENT_PLAYBOOK_14_DAYS.md,templates/TEMPLATES.md,skills/task-tracker-docs/SKILL.md,skills/task-tracker-docs/references/product-docs.md,skills/worklog-doc-sync/SKILL.md,skills/worklog-doc-sync/references/worklog-sync.md,skills/lesson-sync-gate/SKILL.md,skills/lesson-sync-gate/references/sync-gates.md,skills/learning-progress-helpdesk/references/progress-helpdesk.md,tools/lib/product_repository_authority.sh,tools/product-scaffold-check,tools/product-improvement,tools/external-integration,tools/dashboard-data,tools/dashboard,tools/check_workflow_pair_sync.sh,tools/check_agents_skills.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_security.sh
TESTS: tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/test_product_security.sh,tools/check_agents_skills.sh,tools/test_dashboard_data.sh,tools/test_lesson14.sh,tools/check_lesson_structure.sh,tools/check_lesson14_sync.sh

Canonical path contract:

- `docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv` declares canonical product repository paths and uses `legacy_paths=none` for product docs, workflow docs, and product memory docs.
- `docs/workflow/PRODUCT_REPOSITORY_FORBIDDEN_ROOT_PATHS.tsv` maps forbidden root-level Markdown paths to their canonical paths and source ids.
- `tools/lib/product_repository_authority.sh` validates both policy files and blocks matching root duplicates before reporting a structure item as ready.
- `tools/product-scaffold-check` evaluates required and optional structure rows so optional memory root duplicates are also blocked.
- `tools/check_workflow_pair_sync.sh --product` and `--repo` read only `docs/workflow/TASK_TRACKER.md` and `docs/workflow/HANDOFF.md`, and fail when root duplicates exist.

Producer and dashboard contract:

- `tools/dashboard-data` reports product document readiness from canonical paths only.
- `tools/dashboard` displays canonical product document paths and paired workflow state from `docs/workflow`.
- `tools/product-improvement` and `tools/external-integration` require canonical product design documents at gate time and show canonical paths in start prompts.
- Prompt, playbook, skill, lesson-flow, and sync-gate text directs agents and learners to canonical product paths, while lesson repository documents continue to use `docs/as-built`, `docs/workflow`, and `docs/memory`.

External repository boundary contract:

- This lesson repository records the generic canonical path policy and validation behavior only.
- Product repository file cleanup, manifest edits, and repository-index regeneration remain external repository state and are not recorded as lesson repository source of truth.

## Implemented Dashboard Control Center Documents Guided Catalog Specification

SYNC-ID: dashboard_control_center_documents_guided_catalog
STATUS: implemented
ARTIFACTS: docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv,docs/workflow/DASHBOARD_DATA_SCHEMA.tsv,tools/lib/dashboard_data.sh,tools/lib/document_paths.sh,tools/lib/product_repository_authority.sh,tools/dashboard-data,dashboard-control-center/src/App.jsx,dashboard-control-center/src/dashboardData.js,dashboard-control-center/src/i18n.js,dashboard-control-center/src/styles.css,tests/fixtures/dashboard-control-center.json,tests/fixtures/dashboard-control-center-live-update.json,tests/playwright/dashboard-control-center.spec.js,tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh
TESTS: tools/test_dashboard_schema.sh,tools/test_dashboard_data.sh,tools/test_dashboard_control_center.sh,tools/test_product_repository_authority.sh,tools/test_product_scaffold_check.sh,tools/check_as_built_sync_contract.sh,tools/check_as_built_docs.sh

Documents data contract:

- `tools/dashboard-data` remains the producer for dashboard Documents page state.
- The producer exposes a generic documents catalog shape before the React page depends on document grouping, order, status, or related-page routing.
- The implemented catalog shape remains stack-neutral and wording-neutral, using stable fields such as document id, group id, role id, path, audience, order, status, status source, related dashboard surface, and related display-only command metadata.
- `DASHBOARD_DATA_SCHEMA.tsv` and `dashboardData.js` must validate the documents section before UI reliance when the section is present.
- Missing or incomplete document catalog data must render as a safe incomplete state; React must not invent document readiness, document paths, evidence state, workflow status, or command execution behavior.

Documents UI contract:

- The Documents page presents a guided reading surface organized by purpose, not a primary evidence table.
- Primary labels use non-engineer-readable localized display names.
- File paths and technical document ids remain secondary data, shown through compact chips, copy affordances, or tooltip details where appropriate.
- The UI must keep fixed labels in `i18n.js` and must not rewrite producer-owned path, id, command, or evidence values as if they were localization strings.
- The page links users to Maintenance Sync for evidence/source grounding, Safety Confirmation for security gates, Development Workflow for Git/CI flow, Repository Information for file structure, and exposes display-only `tools/docs-tour all` and `tools/dashboard docs` references for broader document explanations.
- Responsive behavior must use existing dashboard card, sidebar, tooltip, and no-overflow patterns so desktop, narrow desktop, tablet, and phone widths remain readable.

Safety and compatibility contract:

- Browser behavior remains GET/read-only and cannot execute Git, GitHub, CI, shell, product-security, product-authority, document generation, evidence writing, merge, push, cleanup, or external repository mutation.
- Existing docs-tour, `tools/dashboard docs`, maintenance evidence, repository information, update history, STEP 1-7, STEP 1-14, Git hooks, pre-commit, and CI wiring remain intact.
- If a new dashboard document test is later introduced, it must run as a standalone command and be callable from aggregate tests without depending on a single product stack or one exact phrase.
