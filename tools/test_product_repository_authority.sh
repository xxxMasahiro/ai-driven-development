#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

repo="$TMP_DIR/product"
fake_bin="$TMP_DIR/bin"
mkdir -p "$repo" "$fake_bin"
git -C "$repo" init -q
git -C "$repo" config user.name "Product Authority Test"
git -C "$repo" config user.email "product-authority@example.com"

cat >"$fake_bin/gh" <<'GH'
#!/usr/bin/env bash
printf 'product-repository-authority must not call gh\n' >&2
exit 99
GH
chmod +x "$fake_bin/gh"

write_product_manifest() {
  local path="$1"
  mkdir -p "$(dirname "$path")"
  cat >"$path" <<'DOC'
# authority_id	required_mode	contexts	product_types	path	path_role	validation_rule	dashboard_group	description
product.entrypoint	required	all	all	README.md	entrypoint	file_exists	workflow	Product entrypoint.
product.source	required	all	all	src/index.txt	source	file_nonempty	workflow	Product source authority.
product.test	required	all	all	tests/test.txt	test	file_nonempty	workflow	Product test authority.
DOC
}

write_valid_product() {
  mkdir -p "$repo/docs/product" "$repo/docs/workflow" "$repo/docs/memory" "$repo/ops" "$repo/src" "$repo/tests" "$repo/.github/workflows"
  printf '# Product Agent\n' >"$repo/AGENT.md"
  printf '# Product\n' >"$repo/README.md"
  printf '# Requirements\n' >"$repo/docs/product/REQUIREMENTS.md"
  printf '# Specification\n' >"$repo/docs/product/SPECIFICATION.md"
  printf '# Implementation Plan\n' >"$repo/docs/product/IMPLEMENTATION_PLAN.md"
  printf '# Task Tracker\n' >"$repo/docs/workflow/TASK_TRACKER.md"
  printf '# Handoff\n' >"$repo/docs/workflow/HANDOFF.md"
  printf 'source\n' >"$repo/src/index.txt"
  printf 'test\n' >"$repo/tests/test.txt"
  cat >"$repo/ops/STAGE_MANIFEST.tsv" <<'DOC'
# stage_id	required_mode	contexts	product_types	dashboard_group	description
build	required	all	all	workflow	Build stage.
DOC
  cat >"$repo/ops/TEST_PLAN_MANIFEST.tsv" <<'DOC'
# test_id	required_mode	contexts	product_types	command_id	evidence_source	dashboard_group	description
unit	required	all	all	npm_test	product.gates.tests	workflow	Unit test.
DOC
  cat >"$repo/ops/CI_MANIFEST.tsv" <<'DOC'
# ci_id	required_mode	contexts	workflow_file	workflow_name	branch_policy	evidence_source	description
main	contextual	product-improvement|external-integration	.github/workflows/ci.yml	CI	main	product.ci.main	Main CI.
DOC
  cat >"$repo/ops/SECURITY_MANIFEST.tsv" <<'DOC'
# security_id	required_mode	contexts	policy_source	evidence_source	dashboard_group	description
secrets	required	all	docs/workflow/SECURITY.md	product.security.secrets	security	Secret scan.
DOC
  cat >"$repo/ops/DASHBOARD_MANIFEST.tsv" <<'DOC'
# surface_id	required_mode	contexts	source_id	label_key	dashboard_group	description
overview	required	all	product.overview	overview	overview	Product overview.
DOC
  write_product_manifest "$repo/ops/PRODUCT_MANIFEST.tsv"
  cat >"$repo/ops/PRODUCT_PROFILE.json" <<'DOC'
{
  "schema_version": "1.0.0",
  "profile_kind": "product_display_profile",
  "menu_id": "step_1_14",
  "profile_scope": "product",
  "display_name": {
    "ja": "タスク管理表",
    "en": "Task Management Table"
  },
  "description": {
    "ja": "STEP 1-14 実践レッスンで作成する成果物です。",
    "en": "The product built in the STEP 1-14 practical lesson."
  },
  "source": "learner_confirmed",
  "confirmed_at": "2026-06-05T00:00:00Z",
  "source_documents": [
    "prompts/PROMPTS_14_DAYS.md"
  ]
}
DOC
}

missing_json="$(PATH="$fake_bin:$PATH" "$ROOT/tools/product-repository-authority" status --repo "$TMP_DIR/missing" --json)"
node - "$missing_json" <<'NODE'
const data = JSON.parse(process.argv[2]);
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.status !== "missing") fail(`expected missing status, got ${data.status}`);
if (data.repository.blocker_scope !== "product_operations") fail("missing repository must block product operations");
if (!data.product_operation_blockers.some((item) => item.source === "repositories.product")) {
  fail("missing repository blocker source is absent");
}
if (/\/tmp\//.test(JSON.stringify(data))) fail("JSON leaked a temporary absolute path");
NODE

write_valid_product
ready_json="$(PATH="$fake_bin:$PATH" "$ROOT/tools/product-repository-authority" status --repo "$repo" --context product-improvement --json)"
node - "$ready_json" <<'NODE'
const data = JSON.parse(process.argv[2]);
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.repository.status !== "ready") fail(`expected ready repository, got ${data.repository.status}`);
if (data.status !== "not_run") fail(`expected not_run authority before evidence, got ${data.status}`);
if (data.manifest_summary.required_missing.length !== 0) fail("valid product should not miss required structure");
if (data.product_summary.status !== "ready") fail(`expected ready product summary, got ${data.product_summary.status}`);
if (data.product_summary.display_name.ja !== "タスク管理表") fail("product summary did not preserve Japanese display name");
if (data.product_summary.source_path !== "ops/PRODUCT_PROFILE.json") fail("product summary did not use PRODUCT_PROFILE.json");
if (!data.evidence_summary.items.some((item) => item.source_id === "product.gates.evidence_index" && item.status === "not_run")) {
  fail("missing evidence index should be represented as not_run evidence");
}
for (const source of ["product.gates.tests", "product.ci.main", "product.security.secrets"]) {
  if (!data.evidence_summary.items.some((item) => item.source_id === source && item.status === "not_run" && item.required_in_context)) {
    fail(`missing required evidence ${source} was not represented as not_run`);
  }
}
if (!data.document_paths.some((item) => item.source_id === "product_docs.requirements" && item.resolved_source === "canonical")) {
  fail("canonical product requirements path was not resolved");
}
NODE

rm -rf "$repo/docs/product" "$repo/docs/workflow" "$repo/docs/memory"
printf '# Requirements\n' >"$repo/REQUIREMENTS.md"
printf '# Specification\n' >"$repo/SPECIFICATION.md"
printf '# Implementation Plan\n' >"$repo/IMPLEMENTATION_PLAN.md"
printf '# Task Tracker\n' >"$repo/TASK_TRACKER.md"
printf '# Handoff\n' >"$repo/HANDOFF.md"
root_only_json="$(PATH="$fake_bin:$PATH" "$ROOT/tools/product-repository-authority" status --repo "$repo" --context product-improvement --json)"
node - "$root_only_json" <<'NODE'
const data = JSON.parse(process.argv[2]);
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.status !== "blocked") fail(`expected blocked status for root-only product docs, got ${data.status}`);
const requirementPath = data.document_paths.find((item) => item.source_id === "product_docs.requirements");
if (!requirementPath || requirementPath.status !== "blocked" || requirementPath.resolved_source !== "root_duplicate") {
  fail("root-only product requirements path was not blocked as a root duplicate");
}
NODE

mkdir -p "$repo/docs/product" "$repo/docs/memory"
printf '# Canonical Requirements\n' >"$repo/docs/product/REQUIREMENTS.md"
conflict_json="$(PATH="$fake_bin:$PATH" "$ROOT/tools/product-repository-authority" status --repo "$repo" --context product-improvement --json)"
node - "$conflict_json" <<'NODE'
const data = JSON.parse(process.argv[2]);
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.status !== "blocked") fail(`expected blocked status for canonical/root duplicate conflict, got ${data.status}`);
if (!data.manifest_summary.conflicts.includes("product_docs.requirements")) {
  fail("requirements root duplicate was not reported");
}
NODE

rm -f "$repo/REQUIREMENTS.md" "$repo/SPECIFICATION.md" "$repo/IMPLEMENTATION_PLAN.md" "$repo/TASK_TRACKER.md" "$repo/HANDOFF.md"
mkdir -p "$repo/docs/product" "$repo/docs/workflow" "$repo/docs/memory" "$repo/.git/product-gate-evidence"
printf '# Requirements\n' >"$repo/docs/product/REQUIREMENTS.md"
printf '# Specification\n' >"$repo/docs/product/SPECIFICATION.md"
printf '# Implementation Plan\n' >"$repo/docs/product/IMPLEMENTATION_PLAN.md"
printf '# Task Tracker\n' >"$repo/docs/workflow/TASK_TRACKER.md"
printf '# Handoff\n' >"$repo/docs/workflow/HANDOFF.md"
cat >"$repo/.git/product-gate-evidence/index.tsv" <<'DOC'
# source_id	context	status	freshness_state	required_in_context	authority	observed_at	max_age_seconds	product_root	product_head	source_artifacts	blocked_by	next_command
product.git.sync	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/CI_MANIFEST.tsv		./tools/check_git_sync.sh --product --required
DOC
evidence_json="$(PATH="$fake_bin:$PATH" "$ROOT/tools/product-repository-authority" status --repo "$repo" --context product-improvement --json)"
node - "$evidence_json" <<'NODE'
const data = JSON.parse(process.argv[2]);
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.status !== "not_run") fail(`expected not_run authority when required evidence is missing, got ${data.status}`);
const item = data.evidence_summary.items.find((entry) => entry.source_id === "product.git.sync");
if (!item) fail("evidence item was not parsed");
if (item.product_root !== "[external-product-repository]/product") fail("evidence product_root was not preserved");
if (item.status !== "passed" || item.freshness_state !== "current") fail("evidence status/freshness was not preserved");
for (const source of ["product.gates.tests", "product.ci.main", "product.security.secrets"]) {
  const missing = data.product_operation_blockers.find((entry) => entry.source === source);
  if (!missing || missing.status !== "not_run") fail(`missing required evidence ${source} did not block as not_run`);
}
NODE

cat >"$repo/.git/product-gate-evidence/index.tsv" <<'DOC'
# source_id	context	status	freshness_state	required_in_context	authority	observed_at	max_age_seconds	product_root	product_head	source_artifacts	blocked_by	next_command
product.gates.tests	product-improvement	passed	current	false	advisory	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/TEST_PLAN_MANIFEST.tsv		npm test
product.ci.main	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/CI_MANIFEST.tsv		./tools/check_ci_status.sh --product --required
product.security.secrets	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/SECURITY_MANIFEST.tsv		./tools/product-security gate
DOC
non_required_source_json="$(PATH="$fake_bin:$PATH" "$ROOT/tools/product-repository-authority" status --repo "$repo" --context product-improvement --json)"
node - "$non_required_source_json" <<'NODE'
const data = JSON.parse(process.argv[2]);
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.status !== "not_run") fail(`expected not_run when matching source is not required_in_context, got ${data.status}`);
const blocker = data.product_operation_blockers.find((item) => item.source === "product.gates.tests");
if (!blocker || blocker.status !== "not_run") fail("non-required matching source must not satisfy required test evidence");
NODE

cat >"$repo/.git/product-gate-evidence/index.tsv" <<'DOC'
# source_id	context	status	freshness_state	required_in_context	authority	observed_at	max_age_seconds	product_root	product_head	source_artifacts	blocked_by	next_command
product.gates.tests	product-improvement	cached	current	true	advisory	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/TEST_PLAN_MANIFEST.tsv		npm test
product.ci.main	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/CI_MANIFEST.tsv		./tools/check_ci_status.sh --product --required
product.security.secrets	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/SECURITY_MANIFEST.tsv		./tools/product-security gate
DOC
cached_source_json="$(PATH="$fake_bin:$PATH" "$ROOT/tools/product-repository-authority" status --repo "$repo" --context product-improvement --json)"
node - "$cached_source_json" <<'NODE'
const data = JSON.parse(process.argv[2]);
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.status !== "not_run") fail(`expected not_run when matching required source is cached, got ${data.status}`);
const blocker = data.product_operation_blockers.find((item) => item.source === "product.gates.tests");
if (!blocker || blocker.status !== "not_run") fail("cached matching source must not satisfy required test evidence");
NODE

cat >"$repo/.git/product-gate-evidence/index.tsv" <<'DOC'
# source_id	context	status	freshness_state	required_in_context	authority	observed_at	max_age_seconds	product_root	product_head	source_artifacts	blocked_by	next_command
product.gates.tests	product-improvement	passed	current	true	advisory	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/TEST_PLAN_MANIFEST.tsv		npm test
product.ci.main	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/CI_MANIFEST.tsv		./tools/check_ci_status.sh --product --required
product.security.secrets	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/SECURITY_MANIFEST.tsv		./tools/product-security gate
DOC
advisory_source_json="$(PATH="$fake_bin:$PATH" "$ROOT/tools/product-repository-authority" status --repo "$repo" --context product-improvement --json)"
node - "$advisory_source_json" <<'NODE'
const data = JSON.parse(process.argv[2]);
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.status !== "not_run") fail(`expected not_run when matching required source is advisory, got ${data.status}`);
const blocker = data.product_operation_blockers.find((item) => item.source === "product.gates.tests");
if (!blocker || blocker.status !== "not_run") fail("advisory matching source must not satisfy required test evidence");
NODE

cat >"$repo/.git/product-gate-evidence/index.tsv" <<'DOC'
# source_id	context	status	freshness_state	required_in_context	authority	observed_at	max_age_seconds	product_root	product_head	source_artifacts	blocked_by	next_command
product.gates.tests	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/TEST_PLAN_MANIFEST.tsv		npm test
product.ci.main	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/CI_MANIFEST.tsv		./tools/check_ci_status.sh --product --required
product.security.secrets	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/SECURITY_MANIFEST.tsv		./tools/product-security gate
DOC
complete_evidence_json="$(PATH="$fake_bin:$PATH" "$ROOT/tools/product-repository-authority" status --repo "$repo" --context product-improvement --json)"
node - "$complete_evidence_json" <<'NODE'
const data = JSON.parse(process.argv[2]);
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.status !== "ready") fail(`expected ready authority with all required evidence, got ${data.status}`);
for (const source of ["product.gates.tests", "product.ci.main", "product.security.secrets"]) {
  if (!data.evidence_summary.items.some((item) => item.source_id === source && item.status === "passed" && item.freshness_state === "current")) {
    fail(`complete required evidence ${source} was not preserved`);
  }
  if (data.product_operation_blockers.some((item) => item.source === source)) {
    fail(`complete required evidence ${source} must not block product operations`);
  }
}
NODE

cat >"$repo/.git/product-gate-evidence/index.tsv" <<'DOC'
# source_id	context	status	freshness_state	required_in_context	authority	observed_at	max_age_seconds	product_root	product_head	source_artifacts	blocked_by	next_command
product.git.sync	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/CI_MANIFEST.tsv		./tools/check_git_sync.sh --product --required
product.ci.main	product-improvement	failed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/CI_MANIFEST.tsv	product.git.sync	./tools/check_ci_status.sh --product --required
product.security.review	product-improvement	stale	stale	true	manual_required	2026-06-01T00:00:00Z	3600	[external-product-repository]/product	none	ops/SECURITY_MANIFEST.tsv		./tools/product-security gate
product.docs.optional	product-improvement	not_run	not_collected	false	advisory	not_collected	0	[external-product-repository]/product	none	docs/product/REQUIREMENTS.md		./tools/product-repository-authority status --json
DOC
failed_evidence_json="$(PATH="$fake_bin:$PATH" "$ROOT/tools/product-repository-authority" status --repo "$repo" --context product-improvement --json)"
node - "$failed_evidence_json" <<'NODE'
const data = JSON.parse(process.argv[2]);
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.status !== "blocked") fail(`expected blocked authority with failed evidence, got ${data.status}`);
if (data.repository.blocker_scope !== "product_operations") fail(`expected product_operations blocker scope, got ${data.repository.blocker_scope}`);
const failed = data.product_operation_blockers.find((item) => item.source === "product.ci.main");
if (!failed || failed.status !== "failed") fail("failed required evidence was not promoted to a product-operation blocker");
const stale = data.product_operation_blockers.find((item) => item.source === "product.security.review");
if (!stale || stale.status !== "stale") fail("stale required evidence was not promoted to a product-operation blocker");
if (data.product_operation_blockers.some((item) => item.source === "product.docs.optional")) {
  fail("optional not_run evidence must not block product operations");
}
NODE

cat >"$repo/.git/product-gate-evidence/index.tsv" <<'DOC'
# source_id	context	status	freshness_state	required_in_context	authority	observed_at	max_age_seconds	product_root	product_head	source_artifacts	blocked_by	next_command
product.git.sync	free-development	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/STAGE_MANIFEST.tsv		./tools/check_git_sync.sh --product --required
DOC
context_gap_json="$(PATH="$fake_bin:$PATH" "$ROOT/tools/product-repository-authority" status --repo "$repo" --context product-improvement --json)"
node - "$context_gap_json" <<'NODE'
const data = JSON.parse(process.argv[2]);
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.status !== "not_run") fail(`expected not_run authority when no evidence matches context, got ${data.status}`);
if (!data.evidence_summary.items.some((item) => item.source_id === "product.gates.evidence_context" && item.required_in_context)) {
  fail("missing context evidence fallback was not emitted");
}
if (!data.product_operation_blockers.some((item) => item.source === "product.gates.evidence_context" && item.status === "not_run")) {
  fail("missing context evidence did not become a not_run blocker");
}
NODE

cat >"$repo/ops/TEST_PLAN_MANIFEST.tsv" <<'DOC'
# test_id	required_mode	contexts	product_types	command_id	evidence_source	dashboard_group	description
unit	required	all	all	npm_test	product.gates.tests	workflow	Unit test.
integration	required	all	all	npm_integration	product.gates.tests	workflow	Integration test.
DOC
cat >"$repo/.git/product-gate-evidence/index.tsv" <<'DOC'
# source_id	context	status	freshness_state	required_in_context	authority	observed_at	max_age_seconds	product_root	product_head	source_artifacts	blocked_by	next_command
product.ci.main	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/CI_MANIFEST.tsv		./tools/check_ci_status.sh --product --required
product.security.secrets	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/SECURITY_MANIFEST.tsv		./tools/product-security gate
DOC
duplicate_evidence_source_json="$(PATH="$fake_bin:$PATH" "$ROOT/tools/product-repository-authority" status --repo "$repo" --context product-improvement --json)"
node - "$duplicate_evidence_source_json" <<'NODE'
const data = JSON.parse(process.argv[2]);
function fail(message) {
  console.error(message);
  process.exit(1);
}
const blockers = data.product_operation_blockers.filter((item) => item.source === "product.gates.tests");
if (blockers.length !== 1) fail(`duplicate required evidence source must produce one blocker, got ${blockers.length}`);
if (blockers[0].status !== "not_run") fail(`duplicate required evidence blocker must stay not_run, got ${blockers[0].status}`);
NODE

cat >"$repo/ops/TEST_PLAN_MANIFEST.tsv" <<'DOC'
# test_id	required_mode	contexts	product_types	command_id	evidence_source	dashboard_group	description
unit	required	all	all	npm_test	invalid.gates.tests	workflow	Unit test.
DOC
cat >"$repo/.git/product-gate-evidence/index.tsv" <<'DOC'
# source_id	context	status	freshness_state	required_in_context	authority	observed_at	max_age_seconds	product_root	product_head	source_artifacts	blocked_by	next_command
product.ci.main	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/CI_MANIFEST.tsv		./tools/check_ci_status.sh --product --required
product.security.secrets	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/product	none	ops/SECURITY_MANIFEST.tsv		./tools/product-security gate
DOC
invalid_manifest_source_json="$(PATH="$fake_bin:$PATH" "$ROOT/tools/product-repository-authority" status --repo "$repo" --context product-improvement --json)"
node - "$invalid_manifest_source_json" <<'NODE'
const data = JSON.parse(process.argv[2]);
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.status !== "blocked") fail(`expected blocked for invalid required evidence source, got ${data.status}`);
const blocker = data.product_operation_blockers.find((item) => item.source === "product.gates.evidence_manifest");
if (!blocker || blocker.status !== "blocked") fail("invalid required evidence source must become a manifest blocker");
NODE

printf 'Product repository authority tests passed.\n'
