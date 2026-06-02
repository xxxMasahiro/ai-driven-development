# Free Development Mode

Free Development Mode is an optional mode for after the structured lesson is complete.
It lets the learner choose any product idea and continue development while still following the workflow taught by this repository.

This mode does not replace the 7-day or 14-day lessons.
It starts only when the learner explicitly chooses it.

## Required Workflow

Use the same workflow learned in the lesson:

1. Confirm the product repository boundary.
2. Choose the product stack with the learner.
3. Define the product with `REQUIREMENTS.md`.
4. Convert requirements into `SPECIFICATION.md`.
5. Plan the work in `IMPLEMENTATION_PLAN.md`.
6. Track work in `TASK_TRACKER.md`.
7. Preserve restart context in `HANDOFF.md`.
8. Work on a branch when the change is not trivial.
9. Commit small, reviewable changes.
10. Run local tests.
11. Push to GitHub and confirm CI.
12. Update documentation before considering the work complete.

## Technology Choice Support

The learner may freely choose the technologies needed for the product, including:

- Programming languages
- Frontend frameworks
- Backend frameworks
- Databases
- Authentication
- Payment systems
- Hosting and deployment tools
- Testing tools
- External APIs and integrations
- Team development and Docker/container tools

The repository should help introduce, compare, and adopt those choices.
Do not force a default stack when the learner has chosen another one.
When a technology choice has operational risk, cost, credentials, security, or vendor lock-in implications, explain the tradeoff before implementation.

Record chosen technology decisions in the product repository, preferably in `SPECIFICATION.md`, `IMPLEMENTATION_PLAN.md`, `TASK_TRACKER.md`, or a dedicated architecture note if the project needs one.

## Product Setup Prompt

```text
I want to use Free Development Mode.
Please help me choose or confirm the product repository, then guide development using the workflow from this lesson repository.
Start with a dialogue about my goal, users, constraints, priorities, and success criteria.
Ask one question at a time when choices are unclear.
Help me choose the programming language, framework, database, payment system, and other tools needed for the product instead of assuming a fixed stack.
Do not skip requirements, specification, implementation plan, task tracking, handoff, Git sync, tests, or CI.
Ask for approval before each major workflow transition.
```

## Completion Gate

Free Development Mode work is ready only when these checks pass:

```bash
./tools/check_repository_boundary.sh --product-required
./tools/check_git_sync.sh --product --required
./tools/check_ci_status.sh --product --required
```

If a product does not have CI yet, create CI first and then run the gate again.

For team development or container work, use `advanced/TEAM_DEVELOPMENT_DOCKER.md`.
