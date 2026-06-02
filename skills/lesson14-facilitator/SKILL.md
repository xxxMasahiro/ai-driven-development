---
name: lesson14-facilitator
description: Guide the repo-local 14-day AI-driven development lesson. Use when the user wants to start, resume, route, or facilitate the 14-day lesson; inspect roadmap/helpdesk state; enforce one-question-at-a-time flow; prevent lesson skipping; or decide which lesson document, prompt, or command to use next.
---

# Lesson14 Facilitator

## Workflow

1. Read `AGENTS.MD` first.
2. Read `index-14-days.md`, then `learning/ROADMAP.md`.
3. Run the starting checks:

```bash
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/lesson14 status
./tools/roadmap status
```

4. Use only the current `tools/lesson14` step during normal progression. Do not skip locked future steps unless the learner explicitly chooses a new start position with `tools/lesson14 開始位置 <step_id> --confirm`.
5. Before moving to the next lesson item, ask for explicit user approval.
6. Ask one short question at a time.
7. If the learning mode is not known, ask the learner to choose:
   - A: detailed explanation
   - B: brief supplemental explanation
   - C: workflow only
8. Match explanations to the selected learning mode.
9. Provide prompts from `prompts/PROMPTS_14_DAYS.md` in copy-paste form.
10. Record questions and resolved confusion with `tools/helpdesk` when useful.
11. Before passing a sync gate, route to `skills/lesson-sync-gate/SKILL.md`.
12. Before product-repository development, prompt the learner to open a separate Ubuntu/WSL CLI window for `$HOME/projects/task-tracker-repository/`.

## Document Routes

Read `references/routes.md` when choosing the next document or command.

Core routes:

```text
14-day entry: index-14-days.md
Roadmap: learning/ROADMAP.md
Agent playbook: playbooks/AGENT_PLAYBOOK_14_DAYS.md
Prompts: prompts/PROMPTS_14_DAYS.md
Flow: lesson/LESSON_FLOW_14_DAYS.tsv
State: learning/LESSON_STATE_14_DAYS.tsv
Sync gates: lesson/SYNC_GATES_14_DAYS.tsv
Help desk: learning/HELP_DESK.md
```

## Guardrails

- Keep 7-day files separate from 14-day files.
- If the user has not chosen 7-day or 14-day mode, ask before starting. Do not default silently to 7-day.
- Do not run multiple lesson items in sequence without user approval between them.
- Use `LEARNING_TASK_TRACKER_14_DAYS.md` and `LEARNING_HANDOFF_14_DAYS.md` for 14-day progress.
- Prompt for a separate Ubuntu/WSL CLI window before entering product-repository development.
- Use `tools/check_repository_boundary.sh` before product-repository work.
- Use `tools/lesson14 復習 <step_id>` only for completed steps.
- If the learner asks to jump ahead, show the current required step and continue there.

## Learning Modes

```text
A: Detailed explanation
Explain the purpose, benefit, terminology, and what will happen before each task.

B: Brief explanation
Give only short terminology and context notes before each task.

C: Workflow only
Skip conceptual explanation and show only the action, prompt, command, and checks.
```

For Step 12/14 and Step 13/14, always teach step by step. Explain why sub-agents, skills, and MCP are useful, then provide copy-paste prompts or commands for the learner to run. Stop after each role, skill, or MCP step and ask for approval before continuing.

Before any MCP-related work, do not implement or simulate the connection first. Explain the connection goal, the external tool or resource, the input, the output, the learner benefit, the minimal scope, the difference from a real MCP server, the files or UI behavior that may change, and the verification checks. Show short learner-facing request text, ask for approval, and only then create or update product files, tests, and paired workflow documents.

## Completion

Finish a turn only after the requested lesson action is handled, checks pass, or a concrete blocker requiring user approval is identified.
