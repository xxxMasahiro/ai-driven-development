# DEVELOPER_MEMORY.md

## Purpose

Developer-owned notes for maintaining this lesson repository.

This file records design decisions, reviewer feedback, known risks, and follow-up work for `ai-driven-development-lesson`.
It is not a learner-facing progress log.

## Current Operation Test

- Started at: 2026-06-02
- Scope: developer visual operation test for the lesson flow.
- Rule: if the developer points out an improvement or problem during this operation test, record it in `## Notes`.
- Reset note: previous developer-memory records were intentionally removed before this operation test.

## Mechanical Baseline Requirements

- Approval checkpoints now have tooling enforcement and must remain active for lesson progression.
- The lessons support `tools/lesson 学習モード <A|B|C>` and `tools/lesson14 学習モード <A|B|C>`, and the learning mode can be changed at any time during either lesson.
- Implementation choices must remain refactorable, ecosystem-friendly, reusable, and general.
- Existing functionality must not be traded away when adding new lesson features, workflow checks, or learner-facing guidance.

## Systematic Review Index

This section organizes the chronological operation-test feedback into stable implementation themes.
Do not delete the chronological notes below; they preserve original developer intent and wording.

### Invariant Protocols

- Approval is required before starting or passing each lesson item.
- Existing features must not be traded away.
- Implementation should preserve refactorability, ecosystem fit, reusability, and generality.
- Learner-facing text should be clear for first-time learners while still supporting post-lesson workflow users.
- `TASK_TRACKER.md` and `HANDOFF.md` should be treated as a paired workflow state and restart-context record.
- Final tests pass only when every improvement or problem recorded in this developer memory has been implemented, synchronized into the lesson materials, or represented by an explicit mechanical check that fails when the requirement is missing.

Related notes:

- `Passage Prompt Should Invite Questions`
- `Learner-Friendly By Default Invariant`
- `Teach How To Prompt The Agent For Each Step`
- `Explain Lesson Control Commands`

### Entry, Navigation, And Menu

- Let learners choose 7-day or 14-day mode before starting.
- Let learners choose and switch learning mode during the lesson.
- Use learner-friendly display labels for learning modes.
- Use `Step` for learner-facing progress labels where practical.
- Provide a `メニュー` entry that groups available actions by user intent.

Approved menu structure:

```text
メニュー

【学ぶ】
1. 7日間レッスン
   基礎を短く一周する

2. 14日間レッスン
   GitHub、CI、E2E、PR、サブエージェント、スキル、MCPまで学ぶ

3. 応用レッスン
   Docker、git worktree、チーム開発、より実務的な検証を学ぶ

【作る・発展させる】
4. 自由開発
   自分で成果物を決め、この教材のワークフローで開発する

5. 成果物を改善
   完了、削除、保存、デザイン改善などを追加する

6. 外部連携
   自由開発や既存成果物を、Googleカレンダーなど外部ツールと連携させる

【整える】
7. 教材そのものを改善
   レッスン、プロンプト、ダッシュボード、文書、運用テストを改善する
```

Menu relationship rule:

- `自由開発` is the entry point for building a learner-defined product.
- `成果物を改善` is the immediate improvement cycle for that product.
- `外部連携` is the follow-up path for extending the product with external tools.
- `外部連携` must also remain independently selectable for users who already have an existing product repository.

Related notes:

- `Display Language Selection`
- `Learning Mode Display Names`
- `Rename Day Labels To Step`
- `Show Current Step Position`
- `Organize Menu Display`

### Learning Experience And Agent Dialogue

- The lesson should teach agent collaboration, not hidden automation.
- Learners should practice stating a simple objective, letting the agent inspect context, reviewing results, refining, verifying, and repeating.
- Reusable request text should be shown as `そのまま使える依頼文:` with clear spacing.
- The developer-memory workflow should be taught through real dialogue and approval.

Related notes:

- `Practice Developer Memory Through Dialogue`
- `Teach How To Prompt The Agent For Each Step`
- `Explain Sub-Agent Roles Before Designing Them`
- `Explain Skill Purpose Before Creating Skills`
- `Explain MCP Purpose Before MCP Workflows`

### Dashboard, Illustrations, And Review Material

- Add a dashboard usable during lessons and after lesson completion.
- Support lesson and development views.
- Support on-demand educational PNG illustrations generated through the agent workflow.
- Generated illustrations should become review material and should be available through dedicated review pages.

Related notes:

- `Workflow Dashboard`
- `On-Demand Lesson Illustrations`
- `Illustration Review Pages`
- `Add Playwright To Lesson Repository For Dashboard Quality`

### Document Organization And Synchronization

- Organize Markdown documents by role when implementing the document-structure refinement.
- Keep `AGENTS.MD` as the root agent entry.
- Treat design documents, workflow-state documents, and memory documents as different categories.
- Long document lists should be grouped by role in learner-facing explanations.
- Hide internal step IDs from ordinary learner-facing output.
- Provide a learner-facing document map through `guides/DOCUMENT_MAP.md`, `tools/docs-tour`, and `tools/dashboard docs` so learners can understand rules, routing, as-built documents, workflow documents, memory documents, and skills before document-heavy work.
- Keep the document map mechanically enforced through `tools/test_docs_tour.sh`, structure checks, as-built checks, developer-memory checks, aggregate tests, CI, and pre-commit.

Related notes:

- `Organize Markdown Documents By Role`
- `Hide Internal Step IDs From Learners`
- `Group Long Document Lists By Role`
- `Separate Workflow Display Language And Product Development Language`
- `Explain Repository Documents To Learners`

### Advanced And Post-Lesson Paths

- Layer the curriculum into foundation, practice, and advanced material.
- Advanced material should focus on practical learner value: `git worktree`, Docker/Dev Container, team development basics, Playwright advanced use, small database introduction, practical MCP mini-integration, and free development mode.
- Do not include Kanban/task-state/approval/gate/source-hash/receipt/control-plane operations in this lesson or its advanced mode.
- Those topics belong to a separate workflow framework product.

Related notes:

- `Layer Lessons As Foundation, Practice, Advanced`
- `Explain Sub-Agent Roles Before Designing Them`

## Chronological Operation Test Notes

### 2026-06-02: Operation Test Feedback - Display Language Selection

Developer feedback:

- Add a language selection step immediately after lesson start.
- Candidate display languages include Japanese, English, Korean, Chinese, and other major learner-facing languages.
- Standard language choices should include `ja`, `en`, `ko`, `zh-CN`, `zh-TW`, `es`, `pt-BR`, `fr`, `de`, `id`, `vi`, `th`, `hi`, and `ar`.
- Preserve `zh` as a backward-compatible alias for `zh-CN`, and keep non-empty custom language labels available for cases outside the standard list.
- Repository source content must remain English-only across implementation programs, documentation, and license files.
- The selected language is not a source-document language. It is an instruction to the agent to translate lesson and workflow runtime messages when presenting them to the learner.
- The language setting should affect displayed lesson guidance, prompts, workflow explanations, and agent-facing runtime facilitation text.

### 2026-06-02: Operation Test Feedback - Learning Mode Display Names

Developer feedback:

- The A/B/C learning modes should have short labels that are easier for non-engineers to understand.
- Keep A/B/C as stable internal mode IDs.
- Use clearer learner-facing display names:
  - A: `じっくり説明`
  - B: `ほどよく説明`
  - C: `手順だけ`
- These labels should be used when presenting learning-mode choices during lesson and workflow execution.

### 2026-06-02: Operation Test Feedback - Rename Day Labels To Step

Developer feedback:

- Replace learner-facing `Step 1/14`, `Step 2/14`, and similar labels with `Step 1`, `Step 2`, and similar labels.
- Reason: actual study time and calendar days depend on each learner's pace, so `Step` communicates ordered progress more clearly than `Day`.
- Keep the intent of the sequence and sync gates unchanged.
- Review flow files, roadmap, prompts, guides, tracker, handoff, and runtime messages for learner-facing `Day` terminology during implementation.

### 2026-06-02: Operation Test Feedback - Passage Prompt Should Invite Questions

Developer feedback:

- Current passage prompts can sound like the only available response is `はい`.
- The lesson should explicitly invite questions before advancing.
- Preferred learner-facing wording:

```text
この項目を通過してよければ「はい」と返してください。
質問や気になる点があれば、その内容を入力してください。
```

- Use this nuance when presenting pass/advance prompts during lesson facilitation.

### 2026-06-02: Operation Test Feedback - Practice Developer Memory Through Dialogue

Developer feedback:

- The lesson should let learners experience the same workflow used in this operation test.
- Learners should point out an improvement or concern during the lesson.
- The agent should discuss options first, not immediately record or implement.
- After learner approval, the agent records the item in `DEVELOPER_MEMORY.md`.
- This practice helps learners understand why developer memory exists: to preserve intent, rationale, decisions, and unimplemented improvements before they are synchronized into requirements, specifications, implementation plans, task trackers, and handoff notes.

### 2026-06-02: Operation Test Feedback - Workflow Dashboard

Developer feedback:

- Add a dashboard that can be used both during lessons and after lesson completion when users develop with this repository's workflow.
- The dashboard should not be lesson-only.
- It should have lesson-oriented and development-oriented views.
- Lesson view should show current step, learning mode, display language, progress, question/helpdesk records, developer-memory items, next approval, sync-gate status, and lesson illustrations.
- Lesson view should show whether illustrations are available for each step/topic and link to a dedicated illustration review page.
- Development view should show product repository, current objective, requirements/specification/implementation-plan status, TASK_TRACKER/HANDOFF status, developer-memory items, Git status, CI status, and next recommended action.
- Start with a CLI dashboard such as `tools/dashboard lesson`, `tools/dashboard development`, and `tools/dashboard all`.
- Design the dashboard around reusable structured data so it can later be extended to HTML/browser display without replacing the CLI workflow.

### 2026-06-02: Operation Test Feedback - On-Demand Lesson Illustrations

Developer feedback:

- Add an on-demand illustration feature for lesson explanations.
- During a lesson, a learner should be able to ask the agent to create an illustration for a difficult explanation.
- The CLI remains the request entry point, but the generated illustration should be displayed through the dashboard.
- The agent should receive or assemble an illustration-generation command, use the current lesson context and explanation target, and generate the image with `imagegen`.
- Generated images should be PNG assets, not simple SVG diagrams.
- The illustrations should be sized for readable educational material.
- Visual style should be gentle, soft, and suitable for non-engineers.
- Human figures are allowed when useful, but the style should not be anime or manga; it should feel like calm educational content.
- Store generated assets with metadata so they can be reused and displayed for the relevant step, explanation, language, and generation timestamp.
- Generated illustrations should be reusable review material, not one-off assets.
- Candidate storage shape:

```text
illustrations/
  lesson14/
    <step_id>/
      <topic-slug>.png
      metadata.json
```

### 2026-06-02: Operation Test Feedback - Illustration Review Pages

Developer feedback:

- Generated lesson illustrations should not be one-off assets.
- Once generated, illustrations should be reusable as review material.
- Learners should be able to reread generated illustrations in order after the lesson or during review.
- Each illustration should be displayed with related explanatory text, such as topic summary, key terms, step ID, learning mode, display language, and source explanation.
- Use a dedicated illustration review page for large, readable display instead of only embedding images in a compact dashboard.
- The dashboard should link to the dedicated review page and show illustration availability by step/topic.
- Review ordering should support step order, generation order, and topic order where practical.
- Keep this feature consistent with the on-demand illustration metadata so the same generated PNG and metadata can power both dashboard summaries and review pages.

### 2026-06-02: Operation Test Feedback - Organize Markdown Documents By Role

Developer feedback:

- As the repository grows, Markdown files other than `AGENTS.MD` should be organized into directories by role.
- Requirements, specification, and implementation plan documents should be treated as design documents.
- Task tracker and handoff documents should be treated as operation/progress documents.
- Developer memory and related memory documents should be treated as memory/decision documents.
- This would improve repository readability and make document roles clearer.
- Final target: root-level copies of these role-specific documents should not remain.
- Root-level files may temporarily provide migration guidance only while references are being updated.
- Implementation must avoid breaking existing references, checks, lesson flows, prompts, or skills.
- A safe migration should define the target directory structure, update checks and references, verify compatibility during migration, then remove root-level copies after all references are moved.

### 2026-06-02: Operation Test Feedback - Hide Internal Step IDs From Learners

Developer feedback:

- Avoid showing internal step IDs such as `day3.memory-docs` directly to learners during normal lesson facilitation.
- Internal IDs are useful for tools, state files, tests, and automation, but learner-facing messages should use short, understandable display names.
- Example: show `Step 3: メモ文書の役割` or `メモ文書の役割` instead of `day3.memory-docs`.
- When a command requires the internal ID, show it only inside the copy-paste command block.
- The surrounding explanation, current step label, dashboard, progress display, and pass/advance prompts should prefer learner-friendly labels.
- This should align with the planned rename from `Day` labels to `Step` labels.

### 2026-06-02: Operation Test Feedback - Group Long Document Lists By Role

Developer feedback:

- Long document lists should be grouped by role before showing individual file names.
- The lesson is for non-engineers, so explanations should start with the purpose of each group rather than a raw list of filenames.
- Preferred learner-facing grouping:
  - Documents for deciding what to build: requirements, specification, implementation plan.
  - Documents for moving the work forward: task tracker, handoff.
  - Documents for remembering context: session memory, failure memory, developer memory.
  - Agent entry document: `AGENT.md`.
- During lessons, first show the short grouped explanation, then show filename-level details only when needed.

### 2026-06-02: Operation Test Feedback - Learner-Friendly By Default Invariant

Developer feedback:

- Learner-facing lesson content should be understandable to non-engineers and first-time learners by default.
- The repository is also used by learners who have completed the lesson as a repeatable workflow for real development, so explanations should support both first-pass learning and later workflow use.
- This should become an invariant rule in `AGENTS.MD`, aligned with the existing no-tradeoff and implementation-quality invariants.
- Learner-facing explanations should prioritize plain purpose, role, and next action before technical names, internal IDs, or file lists.
- Technical terms, filenames, commands, and internal identifiers should be introduced only when they are needed for the next action.
- When technical terms are necessary, explain them briefly in non-engineer-friendly language.
- This policy should guide lesson messages, prompts, dashboards, helpdesk records, document explanations, and future workflow tooling without preventing concise workflow-oriented operation for experienced repeat users.
- Implementation should update `AGENTS.MD` safely without weakening existing invariant rules or confusing `AGENTS.MD` with product-side `AGENT.md`.

### 2026-06-02: Operation Test Feedback - Separate Workflow Display Language And Product Development Language

Developer feedback:

- Language settings must distinguish between workflow display language and product development language.
- Workflow display language controls lesson guidance, workflow prompts, explanations, dashboard text, and agent facilitation messages.
- Product development language controls external product repository content, including requirements, specification, implementation plan, README, UI text, comments where appropriate, and other product-facing documents.
- The lesson repository source itself must remain English-only.
- Before entering product development steps, the workflow should ask the user to choose the product development language.
- Product document drafts shown during the lesson should be displayed in the selected product development language.
- Generated files in the external product repository should use the selected product development language unless the user explicitly chooses otherwise.
- The selected product development language should be recorded so later steps, dashboard views, and free-development workflow can reuse it.
- This must be implemented without changing unrelated existing content or weakening existing workflow controls.

Operation test decision:

- Product development language for the current `task-tracker-repository` run: Japanese.
- The existing English `REQUIREMENTS.md` draft should be treated as a temporary draft and synchronized to Japanese before the product design documents are finalized.

### 2026-06-02: Operation Test Feedback - Show Current Step Position

Developer feedback:

- Learner-facing step messages should show where the current step sits in the full lesson path.
- Example issue: `GitHubへ送って状態を確認する` is understandable as a step label, but it does not show whether this is step 5 of 14, step 6 of 14, or another position.
- Display a concise progress marker near the learner-facing step name, such as `Step 5/14: GitHubへ送って状態を確認する`.
- The marker should use learner-facing `Step` wording, not `Day`, and should avoid exposing internal IDs except inside copy-paste command blocks.
- This should apply consistently to lesson prompts, approval requests, dashboard progress, and step completion messages.

Required display refinement:

- Learner-facing step headers and completion messages must include both the step group and the item position in the full lesson sequence.
- Bad example:
  - `Step 9/14: PRをmergeしてmainを同期する`
- Good example:
  - `Step 9/14: PRをmergeしてmainを同期する（項目 37/58） の作業が完了しました。`
- Apply this pattern consistently for all lesson steps, including start prompts, completion summaries, dashboard current-step displays, and pass/advance messages.
- The item count should represent the current item position in the complete lesson flow, while `Step 9/14` represents the broader lesson section.
- Avoid presenting only the section-level `Step N/14` label when the learner also needs to know their exact progress through the full item sequence.

### 2026-06-02: Operation Test Feedback - Explain Lesson Control Commands

Developer feedback:

- Copy-paste lesson control commands are useful because they show what the agent records and executes.
- However, command blocks such as `./tools/lesson14 承認 ...` and `./tools/lesson14 通過 ...` can be stressful or unclear for non-engineer learners if shown without context.
- Before lesson control command blocks, show a short explanation of what the commands are for.
- Preferred learner-facing wording:
  - `次の2行は、このステップを「承認済み」「完了済み」として記録するためのコマンドです。`
  - `通常はエージェントが実行するので、内容だけ確認できれば大丈夫です。`
- This explanation should appear before approval/pass command blocks where the learner may otherwise wonder whether they must understand or manually run the commands.
- The explanation must not hide the command block, because copy-paste visibility remains useful for transparency and repeat workflow use.

### 2026-06-02: Operation Test Feedback - Layer Lessons As Foundation, Practice, Advanced

Developer feedback:

- Organize lesson concepts into three layers so learners can understand what is basic, what is practical workflow training, and what is advanced professional usage.
- Foundation lessons should cover the minimum concepts needed to follow the workflow, such as `branch`, `commit`, `push`, pull request, merge, and basic CI.
- Practice lessons should cover realistic development workflow, such as multiple branches, PR review, CI checks, Playwright-based verification, handoff, and recovery.
- Advanced lessons should cover higher-complexity tools and team-oriented practices, such as `git worktree`, Docker, MCP integration, multiple agents/sub-agents, and team development.
- `git worktree` should be added as an advanced lesson topic rather than forced into the main 14-step path.
- Explain `git worktree` as a way to open another working folder for a different branch without disturbing the current work.
- The value of `git worktree` should be taught through practical scenarios, such as checking a review branch, handling an urgent fix while preserving ongoing work, or assigning separate folders to multiple agents.
- This must be introduced without weakening or replacing the existing branch-based workflow.
- The lesson structure should keep beginner cognitive load low while giving post-lesson users a clear path toward more practical and advanced workflow use.

Advanced-mode scope refinement:

- Advanced mode should focus on practical development skills that learners can use directly after the main lesson, not on building a workflow-control framework.
- Recommended advanced-mode topics, in priority order:
  - `git worktree`: open separate working folders for different branches, review work, urgent fixes, or multiple agent assignments without disturbing the current branch.
  - Docker / Dev Container: make development environments reproducible and show how agents can help with environment setup that is usually difficult for beginners.
  - Team development basics: issues, pull request review, reviewer comments, role assignment, branch ownership, and main-branch synchronization.
  - Playwright advanced use: screenshot checks, visual review support, accessibility checks, and layout regression detection.
  - Small database introduction: use a practical storage feature such as SQLite or Supabase for task persistence, then update requirements, specification, tests, and CI accordingly.
  - Practical MCP mini-integration: connect the workflow to an external tool such as Google Calendar at a small, understandable scope, without turning the lesson into MCP server framework development.
  - Free development mode: let the learner choose their own product and apply the repository workflow from requirements through implementation, verification, synchronization, and reflection.
- Sub-agent content in advanced mode should remain limited to practical role thinking, such as Director, Planner, Builder, Reviewer, and Validator as lightweight perspectives.
- Advanced mode must not teach or require Kanban workflow systems, task-state machines, approval-control systems, gate-control systems, receipt-driven approval, source-hash discipline, route control, Telegram approval receipts, workflow status dashboards, or bounded automation control planes.
- Those excluded topics belong to a separate workflow framework/control-plane product, not to this AI-driven development lesson.
- This advanced-mode scope must not weaken the current main lesson, the branch-based workflow, the approval-before-advance rule, learner-friendly defaults, existing feature behavior, or the no-tradeoff rule.

### 2026-06-02: Operation Test Feedback - Teach How To Prompt The Agent For Each Step

Developer feedback:

- Step transition messages should not only describe what the workflow will do next.
- Learners need to understand how to ask the agent to perform the next development task.
- Example issue: `Step 7/14: タスクを追加する動きを作る` explains that `app.js` will be created, but it does not teach how to create `app.js` through agent dialogue.
- For each development step, especially implementation steps, provide learning-oriented guidance before execution:
  - What the learner is trying to achieve.
  - What information the agent needs from the existing documents and code.
  - What kind of prompt the learner can give the agent.
  - What the agent should confirm before editing files.
  - What risks or mistakes to watch for.
  - What checks should be run after implementation.
- Provide copy-paste prompts that learners can use directly when asking an agent to do the work.
- In detailed learning mode, show the thinking process and prompt construction more explicitly.
- In moderate learning mode, show a short prompt and a brief caution.
- In workflow-only mode, show only the required command/workflow with minimal explanation.
- This should reinforce the repository's core lesson: AI-driven development is not just executing a workflow, but learning how to communicate goals, constraints, context, checks, and acceptance criteria to an agent.

Important refinement:

- Do not make learner-facing prompts overly long or technical by default.
- The core learning goal is not to train users to write perfect, exhaustive prompts on the first try.
- The core learning goal is to help users start from a short, plain-language objective, then improve the result through dialogue with the agent.
- Preferred simple prompt style:
  - `入力したタスクを一覧へ追加できるようにしたいので、仕様書を見て適切に実装してください。`
- The lesson should teach the cycle of:
  - State the goal simply.
  - Let the agent inspect specifications and existing files.
  - Review the result.
  - Ask for refinements to behavior, layout, wording, or visual design.
  - Use tools such as Playwright when useful so the agent can inspect and adjust the product more like a human visual reviewer.
- This principle applies across all lessons, not only the `app.js` task.
- Detailed learning mode may explain why the simple prompt works, but it should not intimidate learners with a large prompt before they experience the basic dialogue loop.
- The lesson should emphasize practical agent collaboration: request, inspect, refine, verify, and repeat.

Prompt display refinement:

- Learner-facing agent prompts should be visually and textually distinguishable from ordinary explanation.
- Avoid relying only on the technical word `prompt` for first-time learners.
- Preferred label:
  - `そのまま使える依頼文:`
- In detailed learning mode, explain that this kind of request text is also called a prompt.
- Example display:
  - `そのまま使える依頼文:`
  - `タスク追加機能の確認結果を、あとで再開しやすいように記録してください。`
- This should be used consistently whenever the lesson shows text that the learner may copy or adapt to ask an agent for work.
- When showing reusable request text, add clear vertical spacing before and after the request block so it does not visually blend into the surrounding explanation.
- This spacing rule applies across all lessons, not only implementation steps.
- The learner should be able to quickly distinguish:
  - Step status and next-step explanation.
  - Reusable request text for the agent.
  - Learning-mode explanation.
  - Approval/pass command blocks.
- Keep the display calm and readable by separating these blocks with blank lines or equivalent spacing in dashboard/UI contexts.

Handoff prompt refinement:

- When teaching interruption/restart or handoff-related steps, reusable request text should mention both `TASK_TRACKER.md` and `HANDOFF.md` when both need to stay synchronized.
- Preferred wording for handoff interruption steps:
  - `ここで作業を中断しても再開できるように、TASK_TRACKER.mdとHANDOFF.mdを現在の状態に合わせて整理してください。`
- Rationale:
  - `TASK_TRACKER.md` records overall work progress.
  - `HANDOFF.md` records restart context and next actions.
  - Updating only `HANDOFF.md` can leave progress tracking and restart context inconsistent.
- This refinement should align displayed reusable request text with the actual workflow, which updates both documents when the current state changes.
- Treat `TASK_TRACKER.md` and `HANDOFF.md` as a required pair for workflow progress and restart context.
- When one of these files is updated because work state changed, the agent should check whether the other file also needs a corresponding update.
- Lesson prompts, examples, checks, and dashboard views should present them as paired documents where appropriate, not as unrelated files.

Interruption/restart practice refinement:

- Step 8 should include an option for learners to actually stop the session and restart later using the paired `TASK_TRACKER.md` and `HANDOFF.md`.
- This should help learners experience why handoff and progress tracking are useful, instead of only hearing an explanation.
- The interruption/restart experience should be optional, not forced, because some learners may want to continue the lesson without breaking flow.
- If the learner chooses the real interruption path, the lesson should clearly show:
  - Which files to read first after restart.
  - Which command to run first, such as `git status --short --branch`.
  - How to confirm they returned to the correct repository and current workflow state.
  - How to resume the next lesson step safely.
- If the learner chooses to continue immediately, the lesson should still perform a simulated restart check by reading the paired progress/handoff documents and confirming the next action.
- After either path, include a short reflection prompt about whether the paired documents made restart easier.

Mechanical consistency refinement:

- Because `TASK_TRACKER.md` and `HANDOFF.md` are critical handoff documents, their consistency should not rely only on protocol instructions or agent discipline.
- Add mechanical checks that verify these paired documents remain synchronized in the workflow.
- The checks should confirm, at minimum, that:
  - Both files exist when a product repository uses the lesson workflow.
  - Both files describe compatible current state.
  - Both files describe compatible next actions.
  - Updates that change workflow state do not modify only one of the paired files without an explicit, justified reason.
- These checks should be integrated into lesson gates, production-operation tests, and dashboard/status tooling where practical.
- The goal is to make inaccurate handoff state hard to miss before continuing the workflow.
- This must be implemented without weakening existing documentation workflows, learner readability, or the paired-document update policy.

### 2026-06-02: Operation Test Feedback - Add Playwright To Lesson Repository For Dashboard Quality

Developer feedback:

- The lesson repository is planned to include a dashboard for lesson progress, questions, developer memory, paired progress/handoff documents, and review materials.
- To support smooth, accurate, and efficient development of that dashboard, introduce Playwright into the lesson repository itself.
- Playwright should be used not only for product-repository E2E testing lessons, but also for validating the lesson repository's own UI/dashboard quality.
- Intended lesson-repository Playwright checks include:
  - Dashboard main views render correctly.
  - Lesson progress and current step display are readable.
  - Reusable request text blocks have clear spacing and are visually distinguishable.
  - Approval/pass command blocks remain readable and do not overwhelm learner-facing content.
  - Paired `TASK_TRACKER.md`/`HANDOFF.md` status is displayed consistently.
  - Generated illustration review pages and related explanatory text render correctly once implemented.
- Integrate Playwright gradually and safely so it does not break existing CLI lesson flow, documentation workflow, sync gates, or current tests.
- If Playwright is added to CI, do so in a staged way that complements existing checks rather than replacing them.
- Existing feature tradeoffs remain prohibited.

### 2026-06-02: Operation Test Feedback - Explain Sub-Agent Roles Before Designing Them

Developer feedback:

- Step 12 currently lets the agent create a sub-agent role plan before showing the learner what roles will be assigned and why.
- This is confusing because the learner sees `複数サブエージェントの役割分担を設計する（項目 47/58） の作業が完了しました` without first understanding the role options, their responsibilities, or how they support a practical workflow.
- Before creating or updating a sub-agent role plan, the lesson must show the learner:
  - Candidate roles.
  - Each role's responsibility.
  - Each role's authority or decision scope.
  - How the roles cooperate.
  - Why this structure is useful in AI-driven development.
  - Which simplified role set will be used for the current lesson.
- The lesson should explain that sub-agent role design is not only a way to get multiple opinions. It is also a practical way to separate responsibility, reduce overlooked issues, and support more autonomous workflow operation.
- The explanation may reference practical organizational patterns, such as Director, Planner, Reviewer, Builder, and Validator, while keeping the current beginner lesson lighter than a full production workflow.
- For this repository's Step 12 flow, the agent should first present role candidates and ask for learner approval before writing files such as `SUBAGENT_REVIEW_PLAN.md`.
- A suitable beginner-friendly progression is:
  - Explain the concept of role delegation.
  - Show a full practical pattern as context: Director, Planner, Reviewer, Builder, Validator.
  - Explain why the lesson uses a smaller set for this task.
  - Present the selected roles, such as usability review, test review, documentation sync review, and an integrator/controller role.
  - Ask whether the learner agrees with that role split.
  - Only after approval, create or update the role plan.
- This requirement must be implemented consistently with the learner-friendly default invariant, the approval-before-advance rule, and the principle that AI-driven development is learned through dialogue rather than hidden agent execution.

Reference validation addendum:

- The developer requested that Step 12 sub-agent role lessons be informed by `/home/masahiro/projects/akane-hermes-workflow`.
- The repository was inspected directly and through multiple xhigh sub-agent reviews before synchronizing this memory item.
- The reference workflow is more advanced than the current lesson path. It uses a strict authority/control hierarchy:
  - Developer / Owner.
  - SafeFlow Validator.
  - Workflow Orchestrator.
  - Director.
  - Reviewer Gate.
  - Planner.
  - Builder.
  - Runtime / Tools.
- Important role boundaries observed in the reference:
  - Developer / Owner is the only explicit approval authority.
  - Validator may stop a workflow on safety, scope, approval, evidence, or synchronization failure, but does not replace human approval.
  - Orchestrator coordinates role order, handoff, retry, and state, but does not change scope, policy, or approval requirements.
  - Director defines purpose, priority, scope boundaries, approval need, and final judgment.
  - Planner decomposes the work, touch/no-touch scope, acceptance criteria, verification plan, and Builder sequencing, but does not implement directly.
  - Builder implements only after bounded authorization and cannot broaden scope or decide completion alone.
  - Reviewer / Reviewer Gate checks diffs, tests, risks, evidence, and completion claims.
  - Runtime / Tools are execution substrates only and have no judgment, approval, proof, delivery, or gate authority.
- The reference also uses mechanical workflow controls:
  - Task states such as `todo`, `in_progress`, `blocked`, `done`, and `reopened`.
  - Generated task tracker, board, handoff, and append-only receipts.
  - Evidence requirements before marking work done.
  - Explicit blocked reasons.
  - Machine-readable gates and decision headers.
  - Hash-bound approval receipts.
  - Fail-closed behavior when approval, source, scope, evidence, or role authority is unclear.
- For the current 14-step lesson, do not copy the full SafeFlow/Hermes workflow into the main learner path.
- Step 12 should teach the beginner-safe essence:
  - Sub-agents are for bounded coordination, not authority escalation.
  - Multiple roles reduce overlooked issues by separating viewpoints.
  - A controller/integrator decides how to classify findings, but the learner/developer remains the approval authority.
  - Evidence is required before saying work is complete.
  - The workflow should stop and ask when scope, approval, safety, or evidence is unclear.
- The main Step 12 lesson should use a simplified role set:
  - Usability or learning-experience review.
  - Test and CI review.
  - Documentation and handoff synchronization review.
  - Integrator/controller to classify findings as adopt, defer, or reject.
- Advanced or post-lesson workflow material may later introduce the full reference model:
  - Director, Planner, Builder, Reviewer, Validator, Orchestrator.
- Do not teach or operate Kanban workflows, task-state machines, approval-control systems, gate-control systems, workflow status dashboards, bounded automation control planes, source hashes, Telegram approval receipts, Kanban dispatch mechanics, route gates, machine-readable decision headers, hash-bound approvals, or receipt-driven approval systems in the main lesson or advanced lesson modes.
- Those details are not lesson extensions; they belong to designing and implementing a separate workflow framework/control-plane product.
- The lesson may mention them only as examples of complexity that exists in production-grade orchestration frameworks, without making learners implement or operate them.
- When implementing this feedback, update Step 12 lesson guidance so it first explains role candidates and practical authority boundaries, asks for learner approval, and only then creates or updates sub-agent role-plan documents.
- This addendum must not weaken existing approval rules, no-tradeoff rules, learner-friendly defaults, or the current simplified lesson flow.

Sub-agent display refinement:

- Learner-facing sub-agent output should be displayed by role name, not by internal agent path or generated agent ID.
- Avoid showing identifiers like `019e...` in ordinary lesson summaries, review reports, dashboards, or progress messages.
- Preferred learner-facing role labels include:
  - Director.
  - Planner.
  - Reviewer.
  - Builder.
  - Validator.
  - Or simplified lesson-specific labels such as `使いやすさレビュー担当`, `テスト確認担当`, `文書同期確認担当`, and `統括役`.
- When these role labels need explanation for Japanese learners, keep the English role label as the primary display name and add a short Japanese explanation in surrounding text.
- If the underlying tool emits an unavoidable raw `subagent_notification` containing an internal ID, the lesson facilitator should immediately summarize or remap the result using the learner-facing role label.
- The dashboard and future review summaries should maintain a role-to-agent mapping internally, but should present the role label as the primary name.
- Internal agent IDs may be kept only in debug logs, raw tool receipts, or developer diagnostics when technically necessary.

### 2026-06-02: Operation Test Feedback - Explain Skill Purpose Before Creating Skills

Developer feedback:

- Step 13 currently lets the agent create a skill as a workflow operation, then reports completion.
- This is not enough for learning. The learner cannot understand what a skill is, why it is being created, what it contains, or why it is useful.
- Before creating any skill, the lesson must explain:
  - What a skill is in this context.
  - What problem the skill solves.
  - Why a reusable skill is better than writing a long prompt every time.
  - What task the skill will help with.
  - What files or behaviors the skill will guide the agent to inspect.
  - What the generated skill will contain.
  - What the learner will do with the skill in the next step.
- The lesson must show a learner-facing reusable request text before implementation.
- Preferred flow for Step 13 skill creation:
  - Explain the goal: create a small review skill for the task tracker.
  - Explain the benefit: consistent review order, less repeated prompting, fewer missed checks, clearer adopt/defer/reject decisions.
  - Show the planned skill content at a plain-language level.
  - Show the exact reusable request text the learner could give an agent.
  - Ask the learner whether to create the skill.
  - Only after approval, create or update the skill files.
- The reusable request text should be short and non-intimidating. Example:

```text
タスク管理表を毎回同じ観点で見直せるように、レビュー用の小さなスキルを作ってください。
要件、画面、テスト、CI、TASK_TRACKER.md、HANDOFF.mdを確認する順番と、指摘を採用・保留・却下に分ける基準を入れてください。
```

- Skill creation should be taught as agent collaboration, not as hidden file generation.
- This requirement aligns with the broader prompt-teaching rule: start from a simple objective, let the agent inspect context, review the result, refine, verify, and repeat.
- Implementation must update Step 13 lesson guidance so skill creation does not happen before learner-facing explanation and approval.

### 2026-06-02: Operation Test Feedback - Explain MCP Purpose Before MCP Workflows

Developer feedback:

- Step 13 currently lets the agent run a minimal MCP-related workflow and then reports completion.
- This repeats the same learning problem found in the sub-agent and skill lessons: the learner sees that work was completed, but does not understand what MCP is for, why it is useful, what will be connected, what data moves through the connection, or how to ask an agent to design the connection.
- MCP lessons must not be presented as hidden workflow execution.
- Before creating, simulating, or using any MCP-related feature, the lesson must explain:
  - What MCP means in this lesson context.
  - What external tool, data source, or resource is being connected.
  - What information will be read or sent.
  - What the learner gains from that connection.
  - Why the lesson is using a minimal MCP-style exercise instead of building a full MCP server.
  - What the learner should ask the agent to do.
  - What files, UI behavior, tests, and workflow documents will be affected.
  - What checks will confirm that the connection idea worked without breaking existing features.
- Preferred flow for Step 13 MCP content:
  - Explain the goal: use MCP thinking to connect the task tracker workflow to an external resource or tool in a small, understandable way.
  - Explain the benefit: the agent can work with external context more consistently, such as calendar data, task data, documentation, or structured resources.
  - Show the planned connection at a plain-language level: input, output, and scope.
  - Clearly distinguish a real MCP server from a minimal MCP-style exercise.
  - Show short learner-facing reusable request text before implementation.
  - Ask the learner whether to proceed.
  - Only after approval, create or update product files, tests, and paired workflow documents.
- The reusable request text should be short and non-intimidating. Example:

```text
タスク管理表を外部ツールと連携しやすくしたいです。
まずは本格的なMCPサーバーではなく、タスク一覧を外部ツールへ渡しやすい形に整理してください。
既存のタスク追加機能を壊さず、確認方法も用意してください。
```

- MCP lessons should teach agent collaboration: define the connection goal, choose the smallest useful scope, let the agent inspect the current product, review the proposed input/output, implement only after approval, verify with tests, and update `TASK_TRACKER.md` and `HANDOFF.md` as a pair.
- Implementation must update Step 13 lesson guidance so MCP work does not happen before learner-facing explanation, planned connection design, reusable request text, and approval.

### 2026-06-02: Operation Test Feedback - Organize Menu Display

Developer feedback:

- Add or refine the learner-facing menu shown when the developer enters `メニュー`.
- Current candidate items are useful but need clearer organization:
  - `7日間レッスン`
  - `14日間レッスン`
  - `応用レッスン`
  - `自由開発`
  - `外部連携`
  - `成果物を改善`
  - `教材そのものを改善`
- The menu should not present all items as a flat list when their purposes differ.
- Group menu items by user intent so learners can quickly choose whether they want to learn, build, improve, connect external tools, or maintain the lesson itself.
- The menu should use short learner-facing labels and one-line descriptions.
- The menu should remain compatible with both lesson mode and post-lesson workflow use.
- Suggested organization should be reviewed before implementation, then synchronized into the menu command behavior, prompts, guide text, task tracker, and handoff if approved.

Developer refinement:

- `自由開発` and `外部連携` should be connected as a natural progression.
- `自由開発` is the entry point for choosing and building a learner-defined product with this repository's workflow.
- `外部連携` is the follow-up path for extending that product after it exists, such as connecting to Google Calendar, task services, spreadsheets, or other external tools.
- Menu design should show this relationship explicitly, for example:
  - `自由開発`: first build your own product.
  - `外部連携`: then extend the product by connecting it to external tools.
- This relationship should not prevent learners from entering external integration directly when they already have an existing product repository.

Implementation refinement:

- Menu item 3 is named `応用レッスン`.
- Menu items 1 through 6 share pre-start prerequisites: learning mode, workflow display language, product development language, relevant repository boundary, and learner approval.
- `status` remains non-blocking for discovery, while `start`, `gate`, and `check` enforce prerequisites.
- `成果物を改善` has a mechanical CLI entry through `tools/product-improvement status|start|gate`.
- Dashboard output shows readiness for menu items 1 through 6.
- `tools/test_menu_prerequisites.sh` covers the renamed label, old-label absence, missing prerequisites, start approval, and menu readiness.

### 2026-06-02: Operation Test Audit - Unfinished Developer Memory Requirements

Audit context:

- The developer asked whether implementation work had missed unfinished requirements recorded in developer memory.
- Three xhigh sub-agent reviews were used with separate perspectives:
  - Lesson progression, learner experience, display wording, and approval gates.
  - Document placement, as-built synchronization, paired workflow documents, and mechanical enforcement.
  - CLI dashboard, illustrations, free-development, external-integration, advanced paths, and test coverage.
- The audit found that previous local test passes were too weak to prove full completion.
- Existing feature tradeoffs remain prohibited. These findings must be implemented additively without weakening 7-day lessons, 14-step lessons, free development, advanced modules, existing checks, or repository boundary rules.

Unfinished or weakly enforced items:

1. Role-based Markdown document organization is unfinished.
   - `AGENTS.MD` should remain at the repository root.
   - Design documents should move under a design/as-built document directory.
   - Workflow-state documents should move under a workflow/progress directory.
   - Developer memory and related memory documents should move under a memory/decision directory.
   - Final target: root-level copies of these role-specific documents should not remain.
   - Current checks still require root-level `REQUIREMENTS.md`, `SPECIFICATION.md`, `IMPLEMENTATION_PLAN.md`, `TASK_TRACKER.md`, `HANDOFF.md`, and `DEVELOPER_MEMORY.md`.
   - The migration must update references, checks, skills, prompts, dashboard output, and tests without breaking existing lesson flows.

2. `Day` labels remain in learner-facing materials.
   - Learner-facing progress should use `Step` where practical because study time is learner-dependent.
   - Guides, roadmap, prompts, learning tracker, handoff logs, and runtime output still contain many `Day N` labels.
   - Existing checks still require some `Day` labels, so the mechanical tests must be updated instead of preserving the old wording.
   - Internal step IDs may remain for state files, automation, and command arguments when technically necessary.

3. Internal step IDs are still exposed too often.
   - Learner-facing summaries should prefer short display names such as `Step 3: メモ文書の役割`.
   - Internal IDs such as `day3.memory-docs` should appear only in copy-paste command blocks, debug logs, raw state files, or developer diagnostics.
   - Runtime status, dashboard, progress summaries, and pass/start prompts need a display-label mapping.

4. Workflow display language and product development language are not yet implemented as separate settings.
   - The workflow should ask for the learner-facing display language near lesson start.
   - Before product development starts, the workflow should ask for the product development language.
   - Dashboard output, lesson guidance, prompts, and product document drafts should use the appropriate selected language.
   - The lesson repository source files must remain English.
   - Mechanical checks should verify that the settings exist and are surfaced in lesson and dashboard status.

5. Learning-mode display names are not consistently enforced.
   - A/B/C should remain stable internal IDs.
   - Learner-facing labels should be:
     - A: `じっくり説明`.
     - B: `ほどよく説明`.
     - C: `手順だけ`.
   - Runtime output, guide text, dashboard, and tests should verify the display names, not only the raw A/B/C values.

6. Approval gates are still mechanically incomplete.
   - Tools must verify the paired workflow of start approval before start and pass approval before pass.
   - Current checks validate approval records only shallowly.
   - Tests should fail when a lesson item is started or passed without the matching approval action.
   - The implementation must preserve the existing approval-before-advance invariant.

7. Passage prompts and command explanations are not fully enforced.
   - Pass/start prompts should invite questions before continuing.
   - Copy-paste command blocks should be clearly explained in learner-friendly text.
   - Checks should validate the presence of the question-inviting wording and command-block explanation in generated or reusable lesson guidance.

8. `TASK_TRACKER.md` and `HANDOFF.md` pair synchronization is too weak.
   - The pair must be treated as one workflow-state unit.
   - Checks should verify compatible current state, next action, and restart context.
   - Checks should detect workflow-state changes that update only one of the pair without an explicit reason.
   - Dashboard should report whether the pair is synchronized, not only display both files.

9. As-built document synchronization is too shallow.
   - The five as-built documents must describe the same implemented state.
   - Current checks mainly look for topic strings and section headings.
   - Checks should verify that requirements, specification, implementation plan, task tracker, and handoff agree on current status, completed work, remaining work, test evidence, and known gaps.

10. CLI dashboard is only a skeleton compared with the recorded requirement.
    - Lesson view should show current step, progress, learning mode with display label, workflow display language, product development language where relevant, helpdesk/question records, developer-memory items, next approval, sync-gate status, and illustration availability.
    - Development view should show product repository, current objective, workflow document status, paired tracker/handoff synchronization, developer-memory items, Git status, actual CI status when available, and next recommended action.
    - Dashboard output should be backed by reusable structured data so a browser dashboard can be added later without replacing the CLI workflow.

11. Illustration request and review support is incomplete.
    - Illustration metadata should include step, topic, status, asset path, learning mode, display language, source explanation, summary, key terms, and generation timestamp.
    - A generated illustration should be updateable from requested to available.
    - Non-ASCII topics must not collapse to the same fallback asset path.
    - Review pages should list generated or requested illustrations in useful order and show related explanatory text.
    - The current review page is a placeholder and does not yet load illustration records.

12. External integration lacks a mechanical CLI path.
    - The menu and prompts mention external integration, but there is no dedicated `tools/external-integration` start/status/gate entry.
    - External integration should remain usable both as a follow-up to Free Development Mode and as a direct entry for an existing product repository.
    - The gate should check requirements/specification scope, product boundary, paired workflow docs, Git sync, and CI where appropriate.

13. Playwright has not been introduced into the lesson repository for dashboard quality.
    - Developer memory records that lesson-repository dashboard/review-page quality should eventually be checked with Playwright.
    - There is no lesson-repository `package.json`, Playwright config, or dashboard/review-page browser test yet.
    - Integration must be staged so existing CLI lesson flow and current tests are not weakened.

14. CI and pre-commit do not enforce the full updated test suite.
    - New aggregate tests and dashboard/menu/illustration checks are not fully wired into CI and pre-commit.
    - The final completion claim should be reproducible from CI, not only from local manual runs.
    - Additive integration is required; existing CI checks must not be removed or weakened.

15. Free Development and Team Development gate tests are too success-path focused.
    - Tests should cover missing product repository, dirty Git state, CI failure, Docker installed/not-installed paths, and status/start output.
    - Existing success-path tests are useful but insufficient for the recorded operational requirements.

Resolution rule for this audit:

- These findings remain open until each item is either implemented, synchronized into the as-built documents, or represented by a mechanical check that fails when the requirement is missing.
- Passing the current test suite alone is not sufficient to claim that developer-memory requirements are fully complete.
- The next implementation cycle should prioritize high-severity mechanical gaps first: document organization, `Day` to `Step`, language settings, paired tracker/handoff synchronization, as-built synchronization, dashboard completeness, illustration review completeness, and CI/pre-commit enforcement.
