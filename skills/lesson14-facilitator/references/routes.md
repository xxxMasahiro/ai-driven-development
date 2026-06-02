# Lesson14 Routes

Use these routes when facilitating the 14-day lesson.

| Need | Read | Command |
| --- | --- | --- |
| Current position | `lesson/LESSON_FLOW_14_DAYS.tsv`, `learning/LESSON_STATE_14_DAYS.tsv` | `./tools/lesson14 status` |
| Roadmap | `learning/ROADMAP.md` | `./tools/roadmap status` |
| Help desk | `learning/HELP_DESK.md` | `./tools/helpdesk 一覧` |
| Copy-paste prompt | `prompts/PROMPTS_14_DAYS.md` | none |
| Agent procedure | `playbooks/AGENT_PLAYBOOK_14_DAYS.md` | none |
| Sync gate | `lesson/SYNC_GATES_14_DAYS.tsv` | `./tools/lesson14 通過 <step_id> "メモ"` |
| Repository boundary | `lesson/LESSON_CONFIG_14_DAYS.tsv` | `./tools/check_repository_boundary.sh` |
| AGENTS/skills integrity | `AGENTS.MD`, `skills/*/SKILL.md` | `./tools/check_agents_skills.sh` |

Before product-repository development, the facilitator must prompt the learner to open a separate Ubuntu/WSL CLI window for `$HOME/projects/task-tracker-repository/`.

## Step Handling

```text
current: may start or pass
locked: may not start, pass, or revisit
completed: may revisit
```

The learner may freely review completed content. During normal progression they may not skip unfinished future content, but they can explicitly choose a new start position with `tools/lesson14 開始位置 <step_id> --confirm`.
