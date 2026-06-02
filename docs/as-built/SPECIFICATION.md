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
- Applied-learning, Free Development Mode, product improvement, and external integration read a shared settings view that can inherit the latest configured structured-lesson settings.
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

### Planned Product Repository Cleanup

The product-repository cleanup improvement is planned and not yet implemented in the current runtime.
It must be added without replacing or weakening existing lesson flow, menu behavior, dashboard behavior, checks, skills, memory documents, product-gate behavior, GitHub/CI workflow, docs-tour behavior, or as-built/workflow synchronization.

- `tools/product-repository-cleanup` will provide a dedicated cleanup entry point for the external product repository created by the 7-day or 14-day lessons.
- `tools/product-repository-cleanup status` will inspect and print the configured product repository path, local existence, nested-repository safety, Git repository status, configured repository name, remote URL when available, and remote GitHub existence when it can be checked safely.
- `tools/product-repository-cleanup plan` will print the safe cleanup procedure without deleting anything.
- `tools/product-repository-cleanup local --confirm task-tracker-repository` will be the intended local deletion shape.
- Local deletion will fail unless the target path equals the configured external product repository path, is outside the lesson repository, matches the configured product repository name, contains `.git`, and receives the exact confirmation text.
- `tools/product-repository-cleanup remote --confirm xxxMasahiro/task-tracker-repository` will be the intended remote deletion shape.
- Remote deletion will fail unless GitHub authentication works, the repository can be viewed, the owner/repository confirmation text matches exactly, and the target URL is shown before deletion.
- Local deletion and remote deletion will remain separate operations; no `all` or automatic chained deletion operation will be provided.
- The command will print a clear operation log for status, plan, local cleanup, and remote cleanup paths.
- Tests will not delete a real GitHub repository; they will cover dry-run/status/plan behavior, missing confirmation failures, wrong target failures, nested repository rejection, non-Git target rejection, and mocked or non-destructive remote failure paths.
- `tools/test_product_repository_cleanup.sh` will cover the cleanup command and will be wired into structure checks, as-built checks, developer-memory checks, aggregate tests, CI, and pre-commit when implemented.
- At this planning-synchronization stage, `tools/product-repository-cleanup` and `tools/test_product_repository_cleanup.sh` are planned artifacts and are not yet part of runtime dispatch or aggregate checks.
- Implementation completion will require validation wiring through `tools/test_product_repository_cleanup.sh`, structure checks, as-built checks, developer-memory checks, aggregate tests, CI, and pre-commit.
- The validation suite must preserve existing 7-day, 14-day, menu, dashboard, Free Development, Product Improvement, external-integration, product-gate, Playwright, docs-tour, CI, and pre-commit behavior.

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
- `tools/check_review_protocol.sh` validates the review protocol.
- `tools/check_developer_memory_requirements.sh` validates that developer-memory requirements are represented mechanically.
- `tools/menu`, `tools/dashboard`, and `tools/illustrations` validate the menu, dashboard, and illustration entry points at runtime.
- `tools/test_menu_prerequisites.sh` validates menu readiness, start approval, missing-prerequisite failure paths, the `3. 応用レッスン` label, and the absence of the old menu label.
- `tools/test_lesson_start_position.sh` validates learner-selected start positions.
- `tools/test_lesson.sh` validates 7-day CLI behavior, including learning mode, workflow display language, product development language, and setup gating.
- `tools/test_lesson14.sh` validates lesson14 CLI behavior.
- `tools/test_lesson_repository.sh` runs the lesson-side validation suite without requiring `task-tracker-repository`.
- `tools/test_production_operations.sh` validates the end-to-end production operations path when an external product repository exists.
- Latest local verification for the 7-day parity change passed `./tools/test_lesson.sh` and `./tools/test_lesson_repository.sh`.
- Latest local verification for the language-list expansion passed `./tools/test_lesson.sh`, `./tools/test_lesson14.sh`, and `./tools/test_lesson_repository.sh`.

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
