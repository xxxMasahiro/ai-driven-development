# Learner Context Foundation

This directory contains source context for learner-facing AI-driven development lessons.
The files here are not runtime lesson logic.
They are the structured teaching foundation that future lesson implementation can connect to `index.md`, `index-14-days.md`, applied lessons, Free Development Mode, dashboards, and review material.

Repository source documents stay in English.
When a learner selects a workflow display language, the lesson facilitator or runtime output can translate and summarize this source context for that language.

## Files

| File | Role |
| --- | --- |
| `AI_DRIVEN_DEVELOPMENT_FOUNDATION.md` | The main learner-facing conceptual text for AI-driven development. |
| `SECURITY_FOUNDATION.md` | Staged security context for 7-day, 14-day, and applied lessons. |
| `LESSON_CONTEXT_MAP.tsv` | A machine-readable map that connects context topics to lesson phases. |

## How Future Lesson Work Should Use This Directory

Use these documents in three lesson moments:

1. **Lesson opening**
   - Show the big picture before the learner starts the workflow.
   - Explain why AI-driven development uses documents, prompts, Git, tests, approvals, and review loops.

2. **Per-topic lesson guidance**
   - Show the matching context section when a lesson reaches that topic.
   - Add concrete examples, prompt examples, safety notes, and small checks.
   - Keep the explanation depth aligned with the selected learning mode.

3. **Final reflection**
   - Summarize what the learner can now do.
   - Connect structured lessons to Free Development Mode, applied lessons, and product improvement.

## Synchronization Rules

These context files are synchronized as planned foundation material, not as implemented runtime lesson behavior.
Future implementation plans should decide how each context topic is rendered in:

- `index.md`
- `index-14-days.md`
- `lesson/LESSON_FLOW.tsv`
- `lesson/LESSON_FLOW_14_DAYS.tsv`
- `tools/lesson`
- `tools/lesson14`
- `tools/dashboard`
- future browser dashboard views

Do not treat the context files as proof that runtime output has already changed.
Runtime integration requires a separate implementation plan and verification pass.
