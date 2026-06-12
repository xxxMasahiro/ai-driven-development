---
name: repository-development-workflow
description: Guide policy-backed development inside this lesson repository. Use when turning developer wall discussion into proposals, implementation plans, document sync, implementation, focused verification, release gates, PR/main CI, local/remote sync, or approval-bound cleanup for the lesson repository itself.
---

# Repository Development Workflow

Use this skill for this repository's own development. It supports `AGENTS.MD`; it does not replace AGENTS.MD, `worklog-doc-sync`, or `lesson-sync-gate`.

## Required Sequence

1. Read `AGENTS.MD`.
2. Run or inspect:

```bash
./tools/repository-development-workflow status
./tools/repository-development-workflow list
```

3. Choose the current phase from `docs/workflow/REPOSITORY_DEVELOPMENT_WORKFLOW.tsv`:
   `context_triage`, `proposal`, `implementation_plan`, `fast_loop`, `mid_tests`, `release_gate`, or `main_sync_cleanup`.
4. For detailed steps, read `references/repository-development.md`.
5. Use `./tools/repository-development-workflow guidance --phase <phase_id>` before selecting checks.
6. Use `./tools/repository-development-workflow gate --phase <phase_id>` before moving to a stricter phase.
7. Use the runner dry-run before local execution:

```bash
./tools/repository-development-workflow detect
./tools/repository-development-workflow plan-run --phase fast_loop --check-set required
./tools/repository-development-workflow run --phase fast_loop --check-set required --execute --approved
./tools/repository-development-workflow status --runs
./tools/repository-development-workflow next --phase fast_loop
```

8. If product documents are involved, route to `skills/worklog-doc-sync/SKILL.md`.
9. If final lesson gates or STEP 1-14 synchronization are involved, route to `skills/lesson-sync-gate/SKILL.md`.

## Guardrails

- Existing-feature tradeoffs are forbidden.
- STEP 1-7, STEP 1-14, existing CI, existing checks, existing document routes, repo-local skills, and security gates remain authoritative.
- Fast implementation loops do not replace release proof.
- Runner records can support fast-loop and medium-test decisions only when fingerprints match; they are not release proof.
- `plan-run` is the default safe path. `run --phase ... --execute` is limited to allowed non-destructive local checks and still needs `--approved` for approval-bound phases.
- New checks must be standalone and aggregate-callable.
- Destructive cleanup, push, merge, main CI waiting, and local/remote sync are approval-bound.
- Do not add fixed one-off branches for one product stack, phrase, menu, or case.

## Validation

Use the standalone check first:

```bash
./tools/check_repository_development_workflow.sh
./tools/test_repository_development_workflow.sh
```

Then use the workflow's recommended or required checks for the current phase. Release closure remains governed by the existing aggregate, full hooks, CI, and sync gates.
