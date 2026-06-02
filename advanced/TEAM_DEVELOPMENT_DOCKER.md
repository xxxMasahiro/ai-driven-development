# Team Development and Docker

This is an advanced, optional module for after the structured lessons or during Free Development Mode.
It teaches team development and Docker through the same AI-driven workflow used in this repository.

The goal is not to make learners memorize Docker setup.
The goal is to help learners experience how an agent can make team setup, container design, debugging, and documentation much smoother.

## Learning Goals

- Understand why teams standardize development environments.
- Use an agent to turn a product goal into a team workflow.
- Learn the Docker basics needed for practical container development.
- Use Docker to make local development reproducible.
- Record setup, troubleshooting, and handoff information so teammates can continue the work.

## AI-Driven Team Workflow

Use dialogue with the agent before writing configuration:

1. Explain the product goal and team situation.
2. Ask what must be standardized for all teammates.
3. Decide the local development stack.
4. Decide which services need containers.
5. Generate minimal Docker files.
6. Run and debug the containers.
7. Add tests and CI checks.
8. Document setup and known issues.

The learner should use the product repository CLI for implementation and testing.
The lesson repository CLI remains the place for guidance, approvals, and gates.

## Docker Learning Path

Start with the basics and only deepen when the product needs it:

1. What a container is.
2. What an image is.
3. What a `Dockerfile` does.
4. What build context means.
5. How ports and environment variables are passed.
6. How volumes affect local development.
7. How `docker compose` coordinates multiple services.
8. How logs, shell access, and rebuilds help debugging.
9. How container startup belongs in README and HANDOFF.
10. How CI should verify container-dependent work when practical.

## Agent Prompt

```text
I want to learn team development and Docker in an AI-driven way.
Use the product repository CLI for implementation.
First ask one question at a time about the product goal, team members, required services, local setup pain points, database needs, environment variables, ports, and CI requirements.
Then propose a minimal Docker introduction path.
Do not create Docker files until I approve the plan.
After implementation, help me run, debug, document, and test the container workflow.
```

## Sub-Agent Roles

Use role prompts when the work becomes multi-perspective:

- Team lead: checks whether the workflow is easy for teammates.
- Docker engineer: checks Dockerfile and compose design.
- Security reviewer: checks secrets, environment variables, and exposed ports.
- CI reviewer: checks whether the container workflow can be tested in CI.
- Documentation reviewer: checks README, TASK_TRACKER, and HANDOFF.

The orchestrating agent must combine these findings against the product goal.
It should explicitly decide what to adopt, defer, or reject.

## Completion Gate

This advanced module is ready when:

- The product repository boundary is correct.
- Product Git state is clean and synced.
- Product CI is passing.
- The team/Docker plan is documented in the product repository when the learner chooses to implement it.
- Docker commands were tested when Docker is available in the environment.

```bash
./tools/check_repository_boundary.sh --product-required
./tools/check_git_sync.sh --product --required
./tools/check_ci_status.sh --product --required
```

If Docker is not installed yet, the module can still teach planning and setup.
Actual container execution should be completed after Docker is installed.
