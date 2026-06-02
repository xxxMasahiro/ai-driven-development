# HANDOFF.md

## Current State

The lesson repository is in a developer-memory remediation planning synchronization phase.
The current validation scope is lesson-side only; it must not recreate or depend on `task-tracker-repository`.
Existing 7-day lessons, 14-step lessons, free-development flow, advanced modules, checks, and repository-boundary behavior must not be weakened or replaced.
Future implementation must preserve refactorability, ecosystem fit, reusable design, generality, and the no-existing-feature-tradeoff rule.

## Key Implemented Capabilities

- 14-day approval enforcement.
- Learning mode A/B/C selection and switching.
- Learner-selected start positions.
- Free Development Mode.
- Team Development and Docker advanced module.
- Dialogue and wall-bouncing as core AI-driven development learning.
- Role-based sub-agent use and orchestration.
- MCP purpose-before-workflow guidance for Day 13.
- Developer-memory requirement checks.
- Learner-facing menu, dashboard, and illustration review entry points.
- As-built document checks.
- Sub-agent review protocol.
- Lesson repository aggregate test.
- Real product operations test for explicit product-repository runs.
- Quality constraints: refactorability, ecosystem fit, reusability, generality, and no existing-feature tradeoffs.

## Open Remediation Plan

The 2026-06-02 unfinished developer-memory audit must be implemented additively.
The synchronized plan covers these items:

1. Shared document-path support.
2. Safe role-based Markdown document migration.
3. Learner-facing `Day N` to `Step N` wording.
4. Internal step ID hiding in ordinary learner-facing output.
5. Separate workflow display language and product development language settings.
6. Learning-mode display labels for A/B/C.
7. Stronger start/pass approval gate pairing.
8. Question-inviting passage prompts and command-block explanations.
9. Paired `TASK_TRACKER.md` and `HANDOFF.md` synchronization checks.
10. Stronger as-built synchronization checks.
11. Expanded CLI dashboard views.
12. Completed illustration metadata, asset registration, and review page.
13. External-integration CLI path with `status`, `start`, and `gate`.
14. Staged lesson-repository Playwright checks.
15. CI and pre-commit integration for strengthened checks.
16. Free Development and Team Development failure-path tests.

## Important Files

```text
REQUIREMENTS.md
SPECIFICATION.md
IMPLEMENTATION_PLAN.md
TASK_TRACKER.md
HANDOFF.md
DEVELOPER_MEMORY.md
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
tools/test_lesson_repository.sh
tools/test_product_gate_tools.sh
tools/test_production_operations.sh
```

## Next Step

Verify that the remediation plan is synchronized across the three design/as-built documents and two workflow-state documents.
Then run the lesson-side verification sequence:

```bash
./tools/check_lesson_structure.sh
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/check_as_built_docs.sh
./tools/check_review_protocol.sh
./tools/check_developer_memory_requirements.sh
./tools/test_lesson_start_position.sh
./tools/test_lesson14.sh
./tools/test_product_gate_tools.sh
./tools/test_lesson_repository.sh
```

Use xhigh sub-agent review results to fix any remaining synchronization inconsistencies before implementing the remediation backlog.
Run `tools/test_production_operations.sh` only when a product repository is intentionally present.
