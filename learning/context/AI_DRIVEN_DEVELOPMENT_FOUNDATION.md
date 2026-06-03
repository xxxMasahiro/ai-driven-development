# AI-Driven Development Foundation

This document is source material for learner-facing lesson text.
It explains the concepts that should appear before, during, and after the structured lessons.
The goal is to help learners understand why the workflow exists, not only how to run commands.

## Teaching Goal

AI-driven development is not simply asking an AI agent to write code.
The learner is building a workflow where a human sets the goal, gives context, checks the result, and decides when automation is safe.
The agent helps with research, planning, implementation, testing, review, and documentation, but the learner remains responsible for direction and judgment.

A strong learner should finish the lessons able to:

- explain what they want to build,
- turn that goal into requirements, specifications, and an implementation plan,
- ask an agent for useful help without overloading the prompt,
- use Git, tests, CI, and review to make progress safely,
- recover from interruptions and failures,
- decide when to use skills, sub-agents, MCP, APIs, and external tools,
- move from lesson exercises into their own product development.

## Common Section Shape

Future lesson text should reuse this shape when possible:

1. **What you will be able to do**
   - State the practical ability the learner gains.

2. **What we are doing now**
   - Describe the current workflow step in plain language.

3. **Why this matters**
   - Explain the benefit and what problem it prevents.

4. **Concrete example**
   - Show a small scenario that connects the concept to the task tracker or a real product.

5. **Weak prompt**
   - Show a vague or risky request.

6. **Better prompt**
   - Show a shorter, clearer request that a non-engineer can copy.

7. **Copy-paste prompt**
   - Provide one practical prompt that the learner can use immediately.

8. **Safety check**
   - Show what the learner should confirm before continuing.

9. **Small reflection**
   - Ask one short question that checks whether the learner understands the purpose.

10. **Connection to the next topic**
   - Explain why the next step follows naturally.

## 1. AI-Driven Development

AI-driven development means designing a development process where a human and an AI agent work together.
The important skill is not typing long prompts.
The important skill is giving the agent a clear goal, useful context, safe boundaries, and a way to verify the result.

In this repository, the learner does not only make a task tracker.
The learner practices a repeatable workflow:

- decide what should be built,
- write down the intent,
- ask the agent to propose or implement a small change,
- test the result,
- record the current state,
- improve the product in small steps.

### Better Prompt Example

```text
I want to make the task tracker easier to use.
Read the current requirements and specification, then suggest one small improvement.
Do not edit files yet.
```

## 2. Human And Agent Roles

The learner owns the purpose, priorities, constraints, and final judgment.
The agent can help with options, implementation, tests, and explanations.

This role split matters because AI output can look confident even when it is wrong.
The learner should ask the agent to explain tradeoffs, verify assumptions, and show how the result was checked.

### Copy-Paste Prompt

```text
Before editing, explain the goal, the files you will inspect, the change you plan to make, and how you will verify it.
Keep the explanation short and learner-friendly.
```

## 3. Prompts And Context

A prompt is the request the learner gives to the agent.
Context is the background the agent needs to make a good decision.

Good prompts are usually not complicated.
They say:

- what the learner wants,
- what the agent should inspect,
- what the agent should not do yet,
- how the result should be checked.

The lesson should teach learners to start simple, then refine through dialogue.
For non-engineer learners, a short plain request is often better than a large technical instruction.

### Weak Prompt

```text
Make the app better.
```

### Better Prompt

```text
I want the task list to be easier to understand.
Please inspect the current files and suggest one small UI improvement before editing.
```

## 4. AGENTS.MD And Product AGENT.md

`AGENTS.MD` is the lesson repository's rulebook for agents.
It tells the agent which lesson entry to use, which documents matter, which checks exist, and which actions require user approval.

Product repositories may use their own `AGENT.md`.
That product-side file records product-specific rules, such as the product goal, technology stack, coding style, and operating constraints.

This distinction helps the learner understand that one repository teaches the workflow, while another repository contains the product being built.

## 5. Requirements, Specification, And Implementation Plan

The three design documents help prevent the agent from guessing.

| Plain heading | File | Purpose |
| --- | --- | --- |
| Requirements | `REQUIREMENTS.md` | What should be built and what should not be built yet. |
| Specification | `SPECIFICATION.md` | How the product or workflow should behave. |
| Implementation Plan | `IMPLEMENTATION_PLAN.md` | The order of work and how completion will be checked. |

The lesson should introduce the plain heading first, then show the file name.
This keeps the text readable for learners who do not yet know the file names.

### Copy-Paste Prompt

```text
I want to define what we are building first.
Please help me turn my goal into requirements, and keep implementation details for later.
```

## 6. Task Tracker And Handoff

`TASK_TRACKER.md` records progress.
`HANDOFF.md` records how to restart safely.
They should be treated as a pair.

The task tracker answers:

- What is done?
- What is in progress?
- What is still planned?
- What is blocked?

The handoff answers:

- Where should the next session resume?
- What should the next agent read first?
- What must not be changed accidentally?
- Which checks were last run?

This is one of the best ways for learners to understand why memory matters.
They can stop a session, restart, and see whether the agent can continue from the recorded state.

## 7. Memory Documents

Memory documents keep stable intent and lessons learned across sessions.
They are not all the same.

| Memory type | Plain purpose |
| --- | --- |
| Developer memory | Stable maintainer intent, preferences, review findings, and future requirements. |
| Failure memory | What failed, how it was recovered, and how to prevent it next time. |
| Session memory | Temporary notes for the current work session. |
| Protocol memory | Stable operating rules or process decisions. |

The learner should see memory as a way to make agent work more consistent, not as extra paperwork.

## 8. PoC And Agile Development

A proof of concept is a small test that asks, "Can this idea work at all?"
Agile development means improving in small cycles instead of trying to finish everything at once.

AI-driven development works well with this approach because the learner can ask the agent for a small change, test it, then adjust the next request.

### Copy-Paste Prompt

```text
Build the smallest version that proves this idea works.
Avoid extra features until we confirm the basic behavior.
```

## 9. Acceptance Criteria And Evaluation

Acceptance criteria define what must be true before a task is considered complete.
Evaluation, or eval, checks whether the result meets those criteria.

For a task tracker, examples are:

- a non-empty task can be added,
- an empty task is rejected,
- the task appears in the list,
- the result can be checked locally.

The learner should learn to ask the agent for checks, not only code.

## 10. Code Quality Basics

The lesson should teach four quality ideas as practical judgment tools:

| Quality idea | Learner-friendly meaning |
| --- | --- |
| Refactorability | The code can be improved later without starting over. |
| Ecosystem fit | The implementation uses normal tools and patterns for that technology. |
| Reusability | Useful pieces can be used again instead of copied in many places. |
| Generality | The solution handles the real shape of the problem, not only one narrow example. |

### Copy-Paste Prompt

```text
Please implement this in a way that is easy to revise later.
Use existing project patterns where possible, and avoid one-off logic that only works for this single example.
```

## 11. Git, GitHub, And CI

Git records change history.
GitHub hosts the repository and supports collaboration.
CI runs checks automatically so mistakes can be caught earlier.

The learner should understand common actions in plain language:

| Action | Plain meaning |
| --- | --- |
| commit | Save a meaningful checkpoint locally. |
| push | Send local commits to GitHub. |
| PR | Ask for a reviewed change path before merging. |
| CI | Automatically check the change. |
| merge | Accept the change into the main line. |
| sync | Confirm local and remote repositories agree. |

Git automation should remain configurable.
Some steps can be automatic, but high-impact actions such as merge or deletion need explicit safety rules.

## 12. Harness Engineering

Harness engineering means building the environment that lets the agent work safely and repeatedly.
Examples include test commands, validation scripts, dashboards, pre-commit hooks, CI workflows, and clear document routes.

The learner does not need to master the term immediately.
They should understand the practical idea: the agent performs better when the workspace gives it checks and boundaries.

## 13. Governance Layer

A governance layer is the set of rules that controls what the agent may do.
In this repository, governance appears as:

- invariant rules,
- approval gates,
- Git workflow settings,
- repository boundary checks,
- sync contracts,
- security checks,
- stop conditions for risky operations.

This helps the learner see that AI-driven development is not only faster coding.
It is controlled automation.

## 14. Human-In-The-Loop And Human-Out-Of-The-Loop

Human-in-the-loop means the human approves or guides an action.
Human-out-of-the-loop means the action may run automatically under predefined rules.

Structured lessons should emphasize human-in-the-loop behavior first.
Applied lessons may discuss limited human-out-of-the-loop operation, but only when checks, logs, approval policy, and recovery paths are clear.

## 15. Skills, Sub-Agents, And Multi-Agent Work

A skill is a reusable procedure for the agent.
A sub-agent is a separate role or viewpoint.
Multi-agent work uses several viewpoints and then has an orchestrator decide what to adopt.

Learners should see why roles matter before they see a completed role plan.
For example:

- Planner: checks whether the plan makes sense.
- Builder: focuses on implementation.
- Reviewer: looks for risks and missing tests.
- Validator: checks evidence and commands.
- Director: keeps the work aligned with the goal.

The lesson should not expose advanced framework details too early.
It should first show practical role-based review.

## 16. MCP, APIs, And External Integration

MCP and APIs let agents connect to external tools or services.
This can make development more powerful, but it also introduces security and permission concerns.

The lesson should explain the purpose before running an integration workflow:

- What external tool are we connecting to?
- What data can it see?
- What can it change?
- What permission is required?
- How do we verify the result?

## 17. Dashboard And Review Material

A dashboard can help learners see progress, questions, developer-memory items, document status, Git status, and illustration review material.

The dashboard should support both learning mode and post-lesson development.
It should help the learner review what happened, not hide the workflow.

## 18. Free Development And Self-Directed Work

After structured lessons, learners should be able to choose their own product goal.
The same workflow still applies:

- define the goal,
- write requirements,
- specify behavior,
- plan implementation,
- build in small steps,
- test and review,
- record progress and handoff,
- improve the product.

The lesson should make clear that the learner is not leaving the workflow behind.
They are applying it to their own product.

## Final Message For Learners

The aim is not to become a person who simply uses AI.
The aim is to become a person who can design a safe and useful development workflow where AI can help produce real software.
