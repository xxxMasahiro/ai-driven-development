# Document Map

This guide explains the document system used by this lesson repository.
It is written for learners who may not yet know why an AI-driven development workflow uses many Markdown files.

The short version:

- `AGENTS.MD` tells an agent how to operate inside this lesson repository.
- `docs/as-built/` describes what this lesson repository is meant to provide and how it is implemented.
- `docs/workflow/` records current work state and restart context.
- `docs/memory/` records stable maintainer intent and decisions.
- `learning/context/` stores learner-facing source context that future lesson implementation can render in the selected display language.
- `skills/*/SKILL.md` stores reusable agent procedures.
- Product repositories have their own documents, such as `AGENT.md`, `docs/workflow/TASK_TRACKER.md`, `docs/workflow/HANDOFF.md`, and `docs/memory/FAILURE_MEMORY.md`.

## Why This Exists

AI-driven development works best when the agent can inspect clear context instead of guessing.
These documents give the agent a stable map:

- rules that must not be broken,
- design intent,
- current progress,
- restart notes,
- durable maintainer preferences,
- reusable procedures.

For a learner, the documents are not homework.
They are the shared workspace that lets a learner and an agent keep the same understanding over time.

## Agent Rulebook

`AGENTS.MD` is the first file an agent should read in this repository.
It is the lesson-side agent rulebook.

It contains:

- invariant rules,
- the document root table,
- the routing table,
- repo-local skills,
- standard checks.

Important distinction:

- `AGENTS.MD` belongs to this lesson repository.
- `AGENT.md` belongs to a product repository created by a learner.

Do not merge these roles.
The lesson repository teaches and controls the workflow.
The product repository records product-specific context.

## Design Documents

The design documents live in `docs/as-built/`.

| File | Plain-language role |
| --- | --- |
| `docs/as-built/REQUIREMENTS.md` | What this lesson repository must provide |
| `docs/as-built/SPECIFICATION.md` | How the repository behavior is specified |
| `docs/as-built/IMPLEMENTATION_PLAN.md` | How the repository is implemented and verified |

These documents are useful when a learner asks:

- What are we trying to build or improve?
- What behavior should exist?
- What should be changed first?
- How do we know the change is complete?

## Workflow Documents

The workflow documents live in `docs/workflow/`.

| File | Plain-language role |
| --- | --- |
| `docs/workflow/TASK_TRACKER.md` | What is done, in progress, planned, or blocked |
| `docs/workflow/HANDOFF.md` | How to restart the work safely later |
| `docs/workflow/GIT_HOOKS_POLICY.tsv` | Which Git hook modes exist and which mode is the default |
| `docs/workflow/GIT_HOOK_CHECKS.tsv` | Which checks run in each Git hook mode |
| `docs/workflow/GIT_HOOK_RECOMMENDATION_PATHS.tsv` | Which changed files should make the agent recommend local `full --no-cache` verification |
| `learning/GIT_HOOK_SETTINGS.tsv` | The current local Git hook mode selected for this workspace |

These two files should be treated as a pair.
If one changes, check whether the other should change too.

The pair helps answer:

- Where are we now?
- What changed recently?
- What should happen next?
- What should a future agent know before continuing?
- Which Git checks run automatically before commit?

## Memory Documents

The lesson memory documents live in `docs/memory/`.

| File | Plain-language role |
| --- | --- |
| `docs/memory/DEVELOPER_MEMORY.md` | Stable maintainer intent, preferences, review findings, and follow-up requirements |

Product repositories may also use memory documents.
For example, a product-side `docs/memory/FAILURE_MEMORY.md` records failures, recovery steps, and prevention notes.

This lesson repository does not currently have a lesson-side `docs/memory/FAILURE_MEMORY.md`.
When the lesson discusses failure memory, it means product-side `docs/memory/FAILURE_MEMORY.md` or failure-recovery records used in lesson practice.

## Learner Context Documents

Learner context documents live in `learning/context/`.

| File | Plain-language role |
| --- | --- |
| `learning/context/README.md` | Explains how learner context is organized and how future lesson work should use it |
| `learning/context/AI_DRIVEN_DEVELOPMENT_FOUNDATION.md` | Provides the main conceptual text for AI-driven development lessons |
| `learning/context/SECURITY_FOUNDATION.md` | Provides staged security context for 7-day, 14-day, and applied lessons |
| `learning/context/LESSON_CONTEXT_MAP.tsv` | Maps context topics to lesson openings, per-topic explanations, recaps, and dashboard candidates |

These documents are source context for lesson text.
They are not proof that runtime lesson output has already changed.
Future implementation work should connect this context to lesson commands, prompts, dashboards, and review material while preserving selected display-language behavior.

## Skills

Repo-local skills live under `skills/*/SKILL.md`.

They are reusable procedures for the agent, not extra reading assignments for the learner.
For example:

- `skills/lesson-sync-gate/SKILL.md` explains synchronization-gate validation.
- `skills/worklog-doc-sync/SKILL.md` explains how to keep work logs and design documents aligned.

Skills help the agent repeat the same workflow consistently.

## Prompt Examples

Use these prompts when the document set feels overwhelming.

```text
Read docs/workflow/TASK_TRACKER.md and docs/workflow/HANDOFF.md.
Explain the current progress, what was completed, and the next safe action in plain language.
Do not edit files yet.
```

```text
Read docs/as-built/REQUIREMENTS.md, docs/as-built/SPECIFICATION.md, and docs/as-built/IMPLEMENTATION_PLAN.md.
Explain what each document is responsible for and whether they describe the same planned or implemented state.
Do not edit files yet.
```

```text
Read AGENTS.MD.
Explain the invariant rules, document root, routing table, and repo-local skills in learner-friendly language.
Do not edit files yet.
```

## CLI Tour

The command-line tour is:

```bash
./tools/docs-tour status
./tools/docs-tour rules
./tools/docs-tour design
./tools/docs-tour workflow
./tools/docs-tour memory
./tools/docs-tour skills
./tools/docs-tour all
```

The tour adapts its explanation depth to the current learning mode when a mode has been selected:

- A: fuller explanations with purpose, benefit, and examples.
- B: concise explanations with short context.
- C: direct file names and purposes.

## Dashboard View

The dashboard view is:

```bash
./tools/dashboard docs
./tools/dashboard all
```

The docs view summarizes:

- document categories,
- key files,
- current workflow relevance,
- `TASK_TRACKER` and `HANDOFF` pair status,
- as-built synchronization status,
- the next recommended document action.

## Suggested Learning Order

For a first pass, use this order:

1. Read `AGENTS.MD` only enough to understand the rulebook role.
2. Read this document map.
3. Use `./tools/docs-tour status`.
4. Learn the as-built trio.
5. Learn the `TASK_TRACKER` and `HANDOFF` pair.
6. Learn developer memory after seeing a real improvement or problem recorded.
7. Learn skills when the lesson reaches reusable agent procedures.

The goal is not to memorize files.
The goal is to know which document to ask the agent about when you need context.
