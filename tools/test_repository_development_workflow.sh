#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

POLICY_FILE="$TMP_DIR/repository-development-workflow.tsv"
APPROVALS_FILE="$TMP_DIR/repository-development-approvals.tsv"
CHECKS_FILE="$TMP_DIR/git-hook-checks.tsv"

cat >"$CHECKS_FILE" <<'DOC'
# check_id	modes	command	description
check_lesson_structure	full|fast|minimal	./tools/check_lesson_structure.sh	Test check.
check_lesson14_structure	full|fast|minimal	./tools/check_lesson14_structure.sh	Test check.
check_agents_skills	full|fast|minimal	./tools/check_agents_skills.sh	Test check.
check_test_plan_coverage	full|fast|minimal	./tools/check_test_plan_coverage.sh	Test check.
check_as_built_sync_contract	full|fast|minimal	./tools/check_as_built_sync_contract.sh	Test check.
check_as_built_docs	full|fast|minimal	./tools/check_as_built_docs.sh	Test check.
check_workflow_pair_sync	full|fast|minimal	./tools/check_workflow_pair_sync.sh	Test check.
check_repository_development_workflow	full|fast|minimal	./tools/check_repository_development_workflow.sh	Test check.
test_repository_development_workflow	full|fast	./tools/test_repository_development_workflow.sh	Test check.
test_test_plan	full|fast	./tools/test_test_plan.sh	Test check.
test_git_hooks	full|fast	./tools/test_git_hooks.sh	Test check.
test_git_hooks_parallel	full|fast	./tools/test_git_hooks_parallel.sh	Test check.
check_ci_workflow_structure	full|fast	./tools/check_ci_workflow_structure.sh	Test check.
test_lesson_repository	full|fast	./tools/ci-final-gate	Test check.
DOC

cat >"$APPROVALS_FILE" <<'DOC'
# phase_id	approval_scope	required	default_state	description
context_triage	read_repository_context	false	not_required	Test approval.
proposal	present_structured_proposal	false	not_required	Test approval.
implementation_plan	synchronize_planned_documents	true	not_granted	Test approval.
fast_loop	implement_runtime_changes	true	not_granted	Test approval.
mid_tests	run_medium_verification	false	not_required	Test approval.
release_gate	run_release_proof_and_pr_ci	true	not_granted	Test approval.
main_sync_cleanup	merge_main_sync_and_cleanup	true	not_granted	Test approval.
DOC

write_valid_approvals() {
  cat >"$APPROVALS_FILE" <<'DOC'
# phase_id	approval_scope	required	default_state	description
context_triage	read_repository_context	false	not_required	Test approval.
proposal	present_structured_proposal	false	not_required	Test approval.
implementation_plan	synchronize_planned_documents	true	not_granted	Test approval.
fast_loop	implement_runtime_changes	true	not_granted	Test approval.
mid_tests	run_medium_verification	false	not_required	Test approval.
release_gate	run_release_proof_and_pr_ci	true	not_granted	Test approval.
main_sync_cleanup	merge_main_sync_and_cleanup	true	not_granted	Test approval.
DOC
}

write_valid_policy() {
  write_valid_approvals
  cat >"$POLICY_FILE" <<'DOC'
# phase_id	order	purpose	required_inputs	allowed_writes	recommended_checks	required_checks	git_ci_expectations	approval_requirements	cleanup_behavior	stop_conditions
context_triage	1	Read context.	AGENTS.MD	none	check_lesson_structure|check_lesson14_structure|check_agents_skills	check_agents_skills	inspect_branch_only	none	plan_only	repository_mismatch
proposal	2	Prepare proposal.	context_summary	none	check_test_plan_coverage	none	not_required	developer_review_before_docs_sync	plan_only	existing_feature_tradeoff
implementation_plan	3	Prepare plan.	approved_proposal	docs_planned_sync	check_as_built_sync_contract|check_as_built_docs|check_workflow_pair_sync	check_as_built_sync_contract|check_as_built_docs|check_workflow_pair_sync	not_required	developer_approval_before_runtime_implementation	plan_only	missing_sync_id
fast_loop	4	Implement focused scope.	approved_plan	scoped_runtime_files	check_repository_development_workflow|test_repository_development_workflow|check_agents_skills	check_repository_development_workflow|test_repository_development_workflow	local_only	approval_before_AGENTS_hooks_ci_or_destructive_changes	plan_only	security_regression
mid_tests	5	Run medium checks.	implemented_scope	test_outputs_only	check_test_plan_coverage|test_test_plan|test_git_hooks|test_git_hooks_parallel|check_ci_workflow_structure	check_repository_development_workflow|test_repository_development_workflow|check_test_plan_coverage|test_test_plan|test_git_hooks|test_git_hooks_parallel|check_ci_workflow_structure	local_required_ci_not_yet	approval_before_heavy_gate_if_not_requested	plan_only	repeated_failure_3
release_gate	6	Release proof.	docs_synced	evidence_only	test_lesson_repository	check_as_built_sync_contract|check_as_built_docs|check_workflow_pair_sync|check_lesson_structure|check_lesson14_structure|check_agents_skills|test_lesson_repository	pr_ci_required|full_hooks_required|pre_commit_required	developer_approval_before_push_merge	plan_only	ci_failure
main_sync_cleanup	7	Main sync cleanup.	pr_ci_passed	git_state_and_cleanup_only_after_approval	check_as_built_sync_contract|check_as_built_docs|test_lesson_repository	check_as_built_sync_contract|check_as_built_docs|test_lesson_repository	merge_required|main_ci_required|local_remote_sync_required	explicit_approval_required_for_merge_sync_cleanup	approval_bound_plan_only_until_confirmed	main_ci_failure
DOC
}

run_workflow() {
  REPOSITORY_DEVELOPMENT_WORKFLOW_FILE="$POLICY_FILE" \
  REPOSITORY_DEVELOPMENT_APPROVALS_FILE="$APPROVALS_FILE" \
  GIT_HOOKS_CHECKS_FILE="$CHECKS_FILE" \
  "$ROOT/tools/repository-development-workflow" "$@"
}

expect_failure() {
  local label="$1"
  shift
  if "$@" >"$TMP_DIR/$label.out" 2>&1; then
    printf 'expected failure did not occur: %s\n' "$label" >&2
    exit 1
  fi
}

write_valid_policy
run_workflow check | grep 'Repository development workflow check passed.' >/dev/null
run_workflow list | grep 'main_sync_cleanup' >/dev/null
run_workflow guidance --phase fast_loop | grep 'Fast loop: do not treat focused checks as release proof.' >/dev/null
run_workflow gate --phase release_gate | grep 'Policy gate status: policy-valid only' >/dev/null
run_workflow gate --phase release_gate | grep 'does not prove listed checks passed' >/dev/null

write_valid_policy
awk 'BEGIN { FS = OFS = "\t" } $1 == "release_gate" { $8 = "full_hooks_required|pre_commit_required" } { print }' "$POLICY_FILE" >"$TMP_DIR/no-pr-ci.tsv"
mv "$TMP_DIR/no-pr-ci.tsv" "$POLICY_FILE"
expect_failure no_pr_ci run_workflow check
grep 'release_gate must require PR CI evidence.' "$TMP_DIR/no_pr_ci.out" >/dev/null

write_valid_policy
awk 'BEGIN { FS = OFS = "\t" } $1 == "release_gate" { $8 = "pr_ci_required|full_hooks_required" } { print }' "$POLICY_FILE" >"$TMP_DIR/no-pre-commit.tsv"
mv "$TMP_DIR/no-pre-commit.tsv" "$POLICY_FILE"
expect_failure no_pre_commit run_workflow check
grep 'release_gate must require pre-commit evidence.' "$TMP_DIR/no_pre_commit.out" >/dev/null

write_valid_policy
awk 'BEGIN { FS = OFS = "\t" } $1 == "release_gate" { $7 = "check_as_built_docs" } { print }' "$POLICY_FILE" >"$TMP_DIR/no-aggregate.tsv"
mv "$TMP_DIR/no-aggregate.tsv" "$POLICY_FILE"
expect_failure no_aggregate run_workflow check
grep 'release_gate must require aggregate repository verification.' "$TMP_DIR/no_aggregate.out" >/dev/null

write_valid_policy
awk 'BEGIN { FS = OFS = "\t" } $1 == "main_sync_cleanup" { $8 = "merge_required|main_ci_required" } { print }' "$POLICY_FILE" >"$TMP_DIR/no-sync.tsv"
mv "$TMP_DIR/no-sync.tsv" "$POLICY_FILE"
expect_failure no_local_remote_sync run_workflow check
grep 'main_sync_cleanup must require local/remote sync.' "$TMP_DIR/no_local_remote_sync.out" >/dev/null

write_valid_policy
awk 'BEGIN { FS = OFS = "\t" } $1 == "main_sync_cleanup" { $10 = "plan_only" } { print }' "$POLICY_FILE" >"$TMP_DIR/no-cleanup-approval.tsv"
mv "$TMP_DIR/no-cleanup-approval.tsv" "$POLICY_FILE"
expect_failure no_cleanup_approval run_workflow check
grep 'main_sync_cleanup cleanup behavior must remain approval-bound' "$TMP_DIR/no_cleanup_approval.out" >/dev/null

write_valid_policy
awk 'BEGIN { FS = OFS = "\t" } $1 == "fast_loop" { $7 = "missing_check" } { print }' "$POLICY_FILE" >"$TMP_DIR/unknown-check.tsv"
mv "$TMP_DIR/unknown-check.tsv" "$POLICY_FILE"
expect_failure unknown_check run_workflow check
grep 'unknown required_checks check id for phase fast_loop: missing_check' "$TMP_DIR/unknown_check.out" >/dev/null

write_valid_policy
awk 'BEGIN { FS = OFS = "\t" } $1 == "fast_loop" { $10 = "git worktree remove ../old" } { print }' "$POLICY_FILE" >"$TMP_DIR/destructive.tsv"
mv "$TMP_DIR/destructive.tsv" "$POLICY_FILE"
expect_failure destructive_cleanup run_workflow check
grep 'destructive executable guidance is not allowed' "$TMP_DIR/destructive_cleanup.out" >/dev/null

write_valid_policy
awk 'BEGIN { FS = OFS = "\t" } $1 == "proposal" { $2 = "7" } { print }' "$POLICY_FILE" >"$TMP_DIR/order.tsv"
mv "$TMP_DIR/order.tsv" "$POLICY_FILE"
expect_failure invalid_order run_workflow check
grep 'invalid order for phase proposal: expected 2, got 7' "$TMP_DIR/invalid_order.out" >/dev/null

write_valid_policy
awk 'BEGIN { FS = OFS = "\t" } $1 == "proposal" { next } { print }' "$POLICY_FILE" >"$TMP_DIR/missing-phase.tsv"
mv "$TMP_DIR/missing-phase.tsv" "$POLICY_FILE"
expect_failure missing_phase run_workflow check
grep 'missing repository development phase: proposal' "$TMP_DIR/missing_phase.out" >/dev/null

write_valid_policy
awk 'BEGIN { FS = OFS = "\t" } $1 == "proposal" { print $1, $2, $3; next } { print }' "$POLICY_FILE" >"$TMP_DIR/malformed.tsv"
mv "$TMP_DIR/malformed.tsv" "$POLICY_FILE"
expect_failure malformed_row run_workflow check
grep 'expected 11 tab-separated fields' "$TMP_DIR/malformed_row.out" >/dev/null

write_valid_policy
awk 'BEGIN { FS = OFS = "\t" } $1 == "main_sync_cleanup" { next } { print }' "$APPROVALS_FILE" >"$TMP_DIR/missing-approval.tsv"
mv "$TMP_DIR/missing-approval.tsv" "$APPROVALS_FILE"
expect_failure missing_approval run_workflow check
grep 'missing repository development approval phase: main_sync_cleanup' "$TMP_DIR/missing_approval.out" >/dev/null

write_valid_policy
cat >>"$APPROVALS_FILE" <<'DOC'
context_triage	read_repository_context	false	not_required	Duplicate test approval.
DOC
expect_failure duplicate_approval run_workflow check
grep 'duplicate repository development approval phase: context_triage' "$TMP_DIR/duplicate_approval.out" >/dev/null

write_valid_policy
awk 'BEGIN { FS = OFS = "\t" } $1 == "main_sync_cleanup" { $3 = "false"; $4 = "not_required" } { print }' "$APPROVALS_FILE" >"$TMP_DIR/weakened-approval.tsv"
mv "$TMP_DIR/weakened-approval.tsv" "$APPROVALS_FILE"
expect_failure weakened_approval run_workflow check
grep 'invalid approval required value for main_sync_cleanup: expected true, got false' "$TMP_DIR/weakened_approval.out" >/dev/null

write_valid_policy
awk 'BEGIN { FS = OFS = "\t" } $1 == "fast_loop" { $4 = "not_required" } { print }' "$APPROVALS_FILE" >"$TMP_DIR/unsafe-approval-default.tsv"
mv "$TMP_DIR/unsafe-approval-default.tsv" "$APPROVALS_FILE"
expect_failure unsafe_approval_default run_workflow check
grep 'invalid approval default state for fast_loop: expected not_granted, got not_required' "$TMP_DIR/unsafe_approval_default.out" >/dev/null

"$ROOT/tools/check_repository_development_workflow.sh" >/dev/null

printf 'Repository development workflow tests passed.\n'
