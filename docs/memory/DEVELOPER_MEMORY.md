## Required baseline memory for lesson checks

Approval checkpoints now have tooling enforcement.

The 7-day lesson command is `tools/lesson 学習モード <A|B|C>`.
The STEP 1-14 lesson command is `tools/lesson14 学習モード <A|B|C>`.
Learning mode can be changed at any time during either lesson.

Standard language choices should include `ja`, `en`, `ko`, `zh-CN`, `zh-TW`, `es`, `pt-BR`, `fr`, `de`, `id`, `vi`, `th`, `hi`, and `ar`, while `zh` remains a `zh-CN` alias and custom values remain available.

Implementation must remain refactorable, ecosystem-friendly, reusable, and general.
Existing functionality must not be traded away.
Final tests pass only when every improvement or problem recorded in this developer memory is implemented, explicitly deferred, or covered by an accepted follow-up.

Explain MCP Purpose Before MCP Workflows.

## Initialized state

Developer-approved reset completed on 2026-06-12 for active developer-memory follow-ups.
The required baseline memory above is preserved because repository checks enforce it.
Previous dashboard and maintenance follow-ups have been cleared from this memory.
Active follow-up items must be recorded only in structured sections below.

## Active follow-up: lesson-repository-development workflow skill

STATUS: implementation-plan-recorded.

Purpose: create a repo-local skill and mechanical workflow support for lesson-repository development so agents can move from wall discussion to planning, document sync, implementation, focused verification, PR CI, merge/main CI, local/remote sync, and cleanup without weakening safety. This is not a replacement for AGENTS.MD; AGENTS.MD invariants remain higher priority.

Scope: lesson-repository development workflows only. Product repository document sync remains routed through `worklog-doc-sync`. Final lesson/gate closure remains integrated with `lesson-sync-gate`. The workflow must distinguish repo-dev phases from course names such as STEP 1-7 and STEP 1-14.

Subagent review summary:
- Ptolemy: add a policy-backed skill, not skill text alone; use TSV policy, shared helper, CLI, checks, aggregate tests, hooks, CI, and docs sync.
- Newton: use stable machine-readable step IDs; keep fast loops separate from full release gates; PR/main CI and cleanup must be explicit phases.
- Euclid: preserve Developer Memory baseline records, avoid contradictory active follow-up state, and keep worklog-doc-sync / lesson-sync-gate ownership boundaries intact.

Implementation targets:
- `skills/lesson-repository-development/SKILL.md`
- `skills/lesson-repository-development/references/repository-development.md`
- `skills/lesson-repository-development/agents/openai.yaml`
- `docs/workflow/REPOSITORY_DEVELOPMENT_WORKFLOW.tsv`
- `learning/REPOSITORY_DEVELOPMENT_APPROVALS.tsv`
- `tools/lib/repository_development_workflow.sh`
- `tools/repository-development-workflow`
- `tools/check_repository_development_workflow.sh`
- `tools/test_repository_development_workflow.sh`
- `AGENTS.MD`
- `tools/check_agents_skills.sh`
- `docs/workflow/GIT_HOOK_CHECKS.tsv`
- `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv`
- `docs/workflow/TEST_PLAN_MANIFEST.tsv`
- `docs/workflow/FINAL_GATE_COVERAGE.tsv`
- `tools/test_lesson_repository.sh`
- `tools/check_ci_workflow_structure.sh`
- `.github/workflows/ci.yml`
- `.github/workflows/lesson14-ci.yml`
- `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv`
- `docs/as-built/REQUIREMENTS.md`
- `docs/as-built/SPECIFICATION.md`
- `docs/as-built/IMPLEMENTATION_PLAN.md`
- `docs/workflow/TASK_TRACKER.md`
- `docs/workflow/HANDOFF.md`

Repo-dev phase plan:
1. `context_triage`: read AGENTS.MD, routing, current branch/worktree state, relevant docs, and active memory before proposing changes.
2. `proposal`: produce the structured implementation proposal without changing canonical as-built docs or code.
3. `implementation_plan`: after approval, record the concrete plan, required document sync, verification path, failure recovery, and approval points.
4. `fast_loop`: during implementation, run path-scoped and standalone checks from `tools/test-plan` and `tools/git-hooks recommend` instead of heavy aggregate tests by default.
5. `mid_tests`: run medium scoped tests and `tools/git-hooks run --mode fast` when the implementation slice is ready for broader local confidence.
6. `release_gate`: before push/merge, run required sync checks, structure checks, aggregate tests, pre-commit/full gate, and PR CI status as required by the policy.
7. `main_sync_cleanup`: after merge, verify main CI, local/remote sync, handoff/task tracker closure, and generate a non-destructive cleanup plan for branches, worktrees, and product repositories.

Implementation order:
1. Add `REPOSITORY_DEVELOPMENT_WORKFLOW.tsv` as the source of truth and validate its stable phase IDs, ordering, required checks, Git/CI requirements, approval requirements, and cleanup requirements.
2. Add the `lesson-repository-development` skill with a concise `SKILL.md`, one reference file, and `agents/openai.yaml`.
3. Add `tools/lib/repository_development_workflow.sh` and `tools/repository-development-workflow status|plan|check|gate|guidance|list`.
4. Add standalone check and regression test scripts for malformed policy rows, missing wiring, weakened AGENTS invariants, missing PR/main CI requirements, and destructive cleanup attempts.
5. Wire the new check/test into existing hook, manifest, aggregate, and CI surfaces without replacing existing checks.
6. Sync requirements, specification, implementation plan, task tracker, handoff, and sync contract only after the approved plan is ready for documentation promotion.
7. Run the focused verification set first, then the required aggregate and CI gates only at the appropriate closure phase.

Document sync policy:
- Requirements record the capability and non-negotiable safety constraints.
- Specification records the policy TSV, CLI behavior, validation semantics, and approval behavior.
- Implementation plan records file order, check wiring, and verification sequence.
- Task tracker records current status and remaining closure tasks.
- Handoff records restart instructions, dirty-worktree considerations, and required next checks.
- Avoid duplicating the same prose mechanically across all documents.

Verification plan:
- `bash -n` for new shell scripts.
- `./tools/check_repository_development_workflow.sh`.
- `./tools/test_repository_development_workflow.sh`.
- `./tools/check_agents_skills.sh`.
- `./tools/check_test_plan_coverage.sh`.
- `./tools/test_test_plan.sh`.
- `./tools/test_git_hooks.sh`.
- `./tools/test_git_hooks_parallel.sh`.
- `./tools/check_ci_workflow_structure.sh`.
- `./tools/check_as_built_sync_contract.sh`.
- `./tools/check_as_built_docs.sh`.
- `./tools/check_workflow_pair_sync.sh`.
- `./tools/test_lesson_repository.sh` at final closure.
- PR CI, merge, main CI, local/remote sync, and cleanup only when the developer approves that gate.

Failure recovery policy:
- If the workflow policy conflicts with AGENTS.MD, STEP 1-7, STEP 1-14, existing CI, existing checks, or document routing, stop and request developer approval.
- If the same failure repeats three times, stop and report the blocker.
- If GitHub authentication, network, or CI availability prevents verification, stop and report the environment blocker.
- Cleanup commands that delete branches, worktrees, or product repositories require explicit developer approval and must not run from guidance alone.

Developer approval points:
- Starting implementation of the new skill and mechanical workflow tooling.
- Editing AGENTS.MD, hooks, pre-commit wiring, CI, or final-gate coverage.
- Promoting planned workflow content into canonical as-built documents.
- Running heavy full gates, push, merge, main CI wait, branch/worktree deletion, or product repository cleanup.

Stop-before-work note: after recording this plan, stop before committing or pushing the previous CI repair, stashing dirty work, or starting the new skill implementation.
