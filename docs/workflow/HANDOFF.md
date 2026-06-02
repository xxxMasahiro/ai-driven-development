# HANDOFF.md

## Current State

The lesson repository is in an implemented menu prerequisite state.
The current validation scope is lesson-side only; it must not recreate or depend on `task-tracker-repository`.
Existing 7-day lessons, 14-step lessons, free-development flow, advanced modules, checks, and repository-boundary behavior must not be weakened or replaced.
The implementation adds shared menu prerequisite control for menu items 1 through 6 while preserving refactorability, ecosystem fit, reusable design, generality, and the no-existing-feature-tradeoff rule.

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
- Menu items 1 through 6 have shared prerequisite checks for learning mode, workflow display language, product development language, repository boundary where relevant, and learner approval before start.
- `status` commands remain non-blocking; `start`, `gate`, and `check` enforce prerequisites.
- `tools/product-improvement status|start|gate` provides the mechanical entry for product improvement.
- Dashboard readiness output shows menu items 1 through 6.
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
tools/check_as_built_docs.sh
tools/check_developer_memory_requirements.sh
tools/check_review_protocol.sh
tools/menu
tools/dashboard
tools/illustrations
tools/test_lesson.sh
tools/test_lesson_repository.sh
tools/test_product_gate_tools.sh
tools/test_production_operations.sh
```

## Next Step

The synchronized menu prerequisite implementation is now represented across the three design/as-built documents and two workflow-state documents.

Implemented scope:

- Rename the learner-facing menu item to `3. 応用レッスン`.
- Keep the Team Development and Docker path available through the renamed applied-learning item.
- Require learning mode, workflow display language, product development language, repository context/boundary confirmation where relevant, and learner approval before starting menu items 1 through 6.
- Reuse existing 7-day and 14-day settings where available.
- For applied-learning, Free Development Mode, product improvement, and external integration, inherit the latest configured structured-lesson settings when possible; otherwise require missing settings before start or gate passage.
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

Latest local verification passed the lesson-side verification sequence:

```bash
./tools/check_lesson_structure.sh
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/check_as_built_docs.sh
./tools/check_review_protocol.sh
./tools/check_developer_memory_requirements.sh
./tools/menu
./tools/dashboard all
./tools/illustrations list
./tools/test_menu_prerequisites.sh
./tools/test_lesson_start_position.sh
./tools/test_lesson.sh
./tools/test_lesson14.sh
./tools/test_product_gate_tools.sh
./tools/test_lesson_repository.sh
```

The expected terminal evidence is:

```text
7-day lesson CLI tests passed.
Lesson14 CLI tests passed.
Lesson repository test passed.
```

Run `tools/test_production_operations.sh` only when a product repository is intentionally present.
