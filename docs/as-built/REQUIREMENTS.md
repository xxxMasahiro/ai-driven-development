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
- For applied-learning, Free Development Mode, product improvement, and external integration, inherit the latest configured structured-lesson settings when available; otherwise require the learner to select them before start or gate passage.
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
```

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
- As-built document consistency is checked by `tools/check_as_built_docs.sh`.
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
- Latest 7-day parity verification passes `./tools/test_lesson.sh` and `./tools/test_lesson_repository.sh`.
- Latest language-list expansion verification passes `./tools/test_lesson.sh`, `./tools/test_lesson14.sh`, and `./tools/test_lesson_repository.sh`.
- `docs/workflow/TASK_TRACKER.md`, `docs/workflow/HANDOFF.md`, `docs/as-built/REQUIREMENTS.md`, `docs/as-built/SPECIFICATION.md`, and `docs/as-built/IMPLEMENTATION_PLAN.md` reflect the same as-built state.
- `task-tracker-repository` remains outside this repository and may remain deleted unless a real product operations test is explicitly requested.
- The developer-memory audit remains cleared only while all remediation requirements in this document are implemented or mechanically enforced.
