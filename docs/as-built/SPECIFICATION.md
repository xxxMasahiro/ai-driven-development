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
- `tools/dashboard lesson` shows 14-day lesson status, 7-day lesson status, both lesson language settings, learning mode labels, helpdesk information, and developer-memory themes.
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

SYNC-ID: learner_context_foundation
STATUS: planned
ARTIFACTS: learning/context/README.md,learning/context/AI_DRIVEN_DEVELOPMENT_FOUNDATION.md,learning/context/SECURITY_FOUNDATION.md,learning/context/LESSON_CONTEXT_MAP.tsv
TESTS: tools/test_lesson_repository.sh

SYNC-ID: learner_context_runtime_integration
STATUS: planned
ARTIFACTS: learning/context/README.md,learning/context/LESSON_CONTEXT_MAP.tsv
TESTS: tools/test_lesson_repository.sh
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

## Product Repository Boundary

The default lesson-created product repository path is outside this repository:

```text
/home/masahiro/projects/task-tracker-repository
```

The boundary is checked by `tools/check_repository_boundary.sh --product-required`.
Lesson-repository validation does not recreate that repository and does not depend on it.
Real 7-day, 14-day, Free Development, and Team Development product workflows may require a product repository after the learner intentionally creates or selects one.
