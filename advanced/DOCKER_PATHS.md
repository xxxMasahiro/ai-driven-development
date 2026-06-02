# Docker Learning Paths

This file separates Docker learning paths so the advanced module works whether Docker is installed or not.

## Path A: Docker Not Installed

Use this path when `docker --version` is unavailable.

Learning focus:

- What containers solve for a team.
- Difference between host environment and container environment.
- What a `Dockerfile` is.
- What `docker compose` is for.
- Which product services would benefit from containers.
- What must be documented before installation.

Expected output:

- A short container adoption plan.
- Required services, ports, environment variables, and data persistence notes.
- Installation prerequisites and risks.

## Path B: Docker Installed

Use this path when `docker --version` is available.

Learning focus:

- Build an image.
- Run a container.
- Pass environment variables.
- Map ports.
- Inspect logs.
- Rebuild after changes.
- Use `docker compose` when multiple services are needed.

Expected output:

- Working container command or compose workflow.
- README setup instructions.
- HANDOFF troubleshooting notes.
- CI plan when container checks are practical.

## Agent Guidance

The agent should not force Docker into products that do not need it.
When Docker is useful, the agent should make the setup understandable and incremental.
The learner should experience how AI-driven dialogue reduces the cost of setup, configuration, and debugging.
