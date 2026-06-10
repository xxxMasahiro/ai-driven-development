#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

project_root="$tmp/projects"
product_name="sample-product"
product_repo="$project_root/$product_name"
origin="$tmp/origin.git"
config="$tmp/LESSON_CONFIG.tsv"
fake_bin="$tmp/bin"

mkdir -p "$project_root" "$fake_bin"

cat > "$config" <<CONFIG
# key	value
lesson_repo_name	ai-driven-development-lesson
product_repo_name	$product_name
project_root	$project_root
flow_file	lesson/LESSON_FLOW.tsv
state_file	learning/LESSON_STATE.tsv
learning_tracker_file	learning/LEARNING_TASK_TRACKER.md
learning_handoff_file	learning/LEARNING_HANDOFF.md
learning_mode_file	$tmp/LESSON_MODE.tsv
workflow_language_file	$tmp/WORKFLOW_DISPLAY_LANGUAGE.tsv
product_language_file	$tmp/PRODUCT_DEVELOPMENT_LANGUAGE.tsv
CONFIG

cat > "$tmp/LESSON_MODE.tsv" <<'DOC'
# selected_at	mode	description
2026-06-02 00:00:00	A	じっくり説明
DOC
cat > "$tmp/WORKFLOW_DISPLAY_LANGUAGE.tsv" <<'DOC'
# selected_at	code	label
2026-06-02 00:00:00	ja	日本語
DOC
cat > "$tmp/PRODUCT_DEVELOPMENT_LANGUAGE.tsv" <<'DOC'
# selected_at	code	label
2026-06-02 00:00:00	ja	日本語
DOC

git -c init.defaultBranch=main init --bare "$origin" >/dev/null
git -c init.defaultBranch=main init "$product_repo" >/dev/null
git -C "$product_repo" config user.name "Lesson Test"
git -C "$product_repo" config user.email "lesson-test@example.com"
mkdir -p "$product_repo/docs/product" "$product_repo/docs/workflow" "$product_repo/docs/memory" "$product_repo/ops" "$product_repo/src" "$product_repo/tests"
mkdir -p "$product_repo/.github/workflows"
printf '# Product Agent\n' > "$product_repo/AGENT.md"
printf '# Sample Product\n' > "$product_repo/README.md"
cat > "$product_repo/docs/product/REQUIREMENTS.md" <<'DOC'
# REQUIREMENTS.md

## Purpose

Provide a sample product for gate testing.
DOC
cat > "$product_repo/docs/product/SPECIFICATION.md" <<'DOC'
# SPECIFICATION.md

## Behavior

The sample product supports gate testing.
DOC
cat > "$product_repo/docs/product/IMPLEMENTATION_PLAN.md" <<'DOC'
# IMPLEMENTATION_PLAN.md

## Plan

Use the sample product to verify lesson gates.
DOC
cat > "$product_repo/docs/workflow/TASK_TRACKER.md" <<'DOC'
# TASK_TRACKER.md

## Current Status

Sample product is ready for gate testing.

## Remaining Work

- Continue the sample workflow.

HANDOFF
DOC
cat > "$product_repo/docs/workflow/HANDOFF.md" <<'DOC'
# HANDOFF.md

## Current State

Sample product is ready for gate testing.

## Next Step

- Continue the sample workflow.

TASK_TRACKER
DOC
cat > "$product_repo/index.html" <<'DOC'
<!doctype html>
<html lang="en">
  <body>
    <main id="app"></main>
    <script src="src/app.js"></script>
  </body>
</html>
DOC
printf 'document.querySelector("#app").textContent = "Sample product";\n' > "$product_repo/src/app.js"
printf 'test("sample product", () => true);\n' > "$product_repo/tests/app.test.js"
cat > "$product_repo/.github/workflows/ci.yml" <<'DOC'
name: CI

on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm test
DOC
cat > "$product_repo/ops/STAGE_MANIFEST.tsv" <<'DOC'
# stage_id	required_mode	contexts	product_types	dashboard_group	description
build	required	all	all	workflow	Build stage.
DOC
cat > "$product_repo/ops/TEST_PLAN_MANIFEST.tsv" <<'DOC'
# test_id	required_mode	contexts	product_types	command_id	evidence_source	dashboard_group	description
unit	required	all	all	npm_test	product.gates.tests	workflow	Unit test.
DOC
cat > "$product_repo/ops/CI_MANIFEST.tsv" <<'DOC'
# ci_id	required_mode	contexts	workflow_file	workflow_name	branch_policy	evidence_source	description
main	contextual	product-improvement|external-integration	.github/workflows/ci.yml	CI	main	product.ci.main	Main CI.
DOC
cat > "$product_repo/ops/SECURITY_MANIFEST.tsv" <<'DOC'
# security_id	required_mode	contexts	policy_source	evidence_source	dashboard_group	description
secrets	required	all	docs/workflow/SECURITY.md	product.security.secrets	security	Secret scan.
DOC
cat > "$product_repo/ops/INTEGRATION_MANIFEST.tsv" <<'DOC'
# integration_id	required_mode	contexts	service_kind	approval_source	security_source	dashboard_group	description
calendar	contextual	external-integration	calendar	EXTERNAL_INTEGRATION_SECURITY.md	ops/SECURITY_MANIFEST.tsv	workflow	Calendar integration.
DOC
cat > "$product_repo/ops/DASHBOARD_MANIFEST.tsv" <<'DOC'
# surface_id	required_mode	contexts	source_id	label_key	dashboard_group	description
overview	required	all	product.overview	overview	overview	Product overview.
DOC
cat > "$product_repo/ops/PRODUCT_MANIFEST.tsv" <<'DOC'
# authority_id	required_mode	contexts	product_types	path	path_role	validation_rule	dashboard_group	description
product.entrypoint	required	all	all	index.html	entrypoint	file_exists	workflow	Browser entrypoint.
product.source	required	all	all	src/app.js	source	file_nonempty	workflow	Application source authority.
product.test	required	all	all	tests/app.test.js	test	file_nonempty	workflow	Test authority.
DOC
cat > "$product_repo/ops/PRODUCT_PROFILE.json" <<'DOC'
{
  "schema_version": "1.0.0",
  "profile_kind": "product_display_profile",
  "menu_id": "free-development",
  "profile_scope": "product",
  "display_name": {
    "ja": "サンプル成果物",
    "en": "Sample Product"
  },
  "description": {
    "ja": "検査用の成果物です。",
    "en": "A product used by product gate checks."
  },
  "source": "learner_confirmed",
  "confirmed_at": "2026-06-05T00:00:00Z",
  "source_documents": [
    "docs/product/REQUIREMENTS.md"
  ]
}
DOC
mkdir -p "$product_repo/.git/product-gate-evidence"
cat > "$product_repo/.git/product-gate-evidence/index.tsv" <<'DOC'
# source_id	context	status	freshness_state	required_in_context	authority	observed_at	max_age_seconds	product_root	product_head	source_artifacts	blocked_by	next_command
product.gates.smoke	all	passed	current	true	authoritative	2026-06-02T00:00:00Z	3600	[external-product-repository]/sample-product	none	ops/PRODUCT_MANIFEST.tsv		./tools/product-repository-authority status --json
product.gates.tests	all	passed	current	true	authoritative	2026-06-02T00:00:00Z	3600	[external-product-repository]/sample-product	none	ops/TEST_PLAN_MANIFEST.tsv		npm test
product.ci.main	all	passed	current	true	authoritative	2026-06-02T00:00:00Z	3600	[external-product-repository]/sample-product	none	ops/CI_MANIFEST.tsv		./tools/check_ci_status.sh --product --required
product.security.secrets	all	passed	current	true	authoritative	2026-06-02T00:00:00Z	3600	[external-product-repository]/sample-product	none	ops/SECURITY_MANIFEST.tsv		./tools/product-security gate
DOC
cat > "$product_repo/EXTERNAL_INTEGRATION_SECURITY.md" <<'DOC'
# EXTERNAL_INTEGRATION_SECURITY.md

- Connected service: test calendar
- Data sent: task title only
- Data received: event identifier
- Write behavior: create test event only
- OAuth scopes: calendar.events
- Token storage: local environment variable
- Redirect URI: local test redirect
- Token refresh: documented
- Token revoke: documented
- Webhook signature: not used
- Rate limits: documented
- Sandbox: test account
- Prohibited log output: tokens and private event details
- Rollback: disable integration and revoke token
DOC
git -C "$product_repo" add AGENT.md README.md .github docs ops src tests index.html EXTERNAL_INTEGRATION_SECURITY.md
git -C "$product_repo" commit -m "Initial sample product" >/dev/null
git -C "$product_repo" remote add origin "$origin"
git -C "$product_repo" push -u origin main >/dev/null

cat > "$fake_bin/gh" <<'GH'
#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  auth)
    if [[ "${2:-}" == "token" ]]; then
      printf 'fake-token\n'
      exit 0
    fi
    ;;
  api)
    printf 'completed\tsuccess\tCI\tCI\tmain\t1\t0\t1s\t2026-06-02T00:00:00Z\n'
    exit 0
    ;;
  run)
    if [[ "${2:-}" == "list" ]]; then
      printf 'completed\tsuccess\tCI\tCI\tmain\t1\t0\t1s\t2026-06-02T00:00:00Z\n'
      exit 0
    fi
    ;;
  repo)
    if [[ "${2:-}" == "view" ]]; then
      printf 'xxxMasahiro/sample-product\n'
      exit 0
    fi
    ;;
esac

printf 'unsupported fake gh command: %s\n' "$*" >&2
exit 1
GH
chmod +x "$fake_bin/gh"

PATH="$fake_bin:$PATH" LESSON_CONFIG="$config" "$ROOT/tools/free-development" gate
PATH="$fake_bin:$PATH" LESSON_CONFIG="$config" "$ROOT/tools/team-development" gate
PATH="$fake_bin:$PATH" LESSON_CONFIG="$config" "$ROOT/tools/product-improvement" gate
PATH="$fake_bin:$PATH" LESSON_CONFIG="$config" "$ROOT/tools/external-integration" gate
mv "$product_repo/docs/product/SPECIFICATION.md" "$product_repo/docs/product/SPECIFICATION.md.off"
PATH="$fake_bin:$PATH" LESSON_CONFIG="$config" "$ROOT/tools/external-integration" gate >/tmp/external-integration-missing-scope.out 2>&1 && exit 1 || true
grep 'missing external-integration scope document' /tmp/external-integration-missing-scope.out >/dev/null
PATH="$fake_bin:$PATH" LESSON_CONFIG="$config" "$ROOT/tools/product-improvement" gate >/tmp/product-improvement-missing-scope.out 2>&1 && exit 1 || true
grep 'missing product-improvement scope document' /tmp/product-improvement-missing-scope.out >/dev/null
mv "$product_repo/docs/product/SPECIFICATION.md.off" "$product_repo/docs/product/SPECIFICATION.md"
LESSON_CONFIG="$config" "$ROOT/tools/free-development" status | grep 'Free Development Mode'
LESSON_CONFIG="$config" "$ROOT/tools/free-development" start --confirm | grep 'Free Development Mode start prompt'
LESSON_CONFIG="$config" "$ROOT/tools/team-development" status | grep 'Team Development and Docker'
LESSON_CONFIG="$config" "$ROOT/tools/team-development" start --confirm | grep 'Team Development and Docker start prompt'
LESSON_CONFIG="$config" "$ROOT/tools/product-improvement" status | grep 'Product Improvement'
LESSON_CONFIG="$config" "$ROOT/tools/product-improvement" start --confirm | grep 'Product Improvement start prompt'
LESSON_CONFIG="$config" "$ROOT/tools/external-integration" status | grep 'External Integration'
LESSON_CONFIG="$config" "$ROOT/tools/external-integration" start --confirm | grep 'External Integration start prompt'

empty_config="$tmp/EMPTY_SETTINGS_CONFIG.tsv"
cat > "$empty_config" <<CONFIG
# key	value
lesson_repo_name	ai-driven-development-lesson
product_repo_name	$product_name
project_root	$project_root
flow_file	lesson/LESSON_FLOW.tsv
state_file	learning/LESSON_STATE.tsv
learning_tracker_file	learning/LEARNING_TASK_TRACKER.md
learning_handoff_file	learning/LEARNING_HANDOFF.md
learning_mode_file	$tmp/EMPTY_LESSON_MODE.tsv
workflow_language_file	$tmp/EMPTY_WORKFLOW_DISPLAY_LANGUAGE.tsv
product_language_file	$tmp/EMPTY_PRODUCT_DEVELOPMENT_LANGUAGE.tsv
CONFIG
printf '# selected_at\tmode\tdescription\n' > "$tmp/EMPTY_LESSON_MODE.tsv"
printf '# selected_at\tcode\tlabel\n' > "$tmp/EMPTY_WORKFLOW_DISPLAY_LANGUAGE.tsv"
printf '# selected_at\tcode\tlabel\n' > "$tmp/EMPTY_PRODUCT_DEVELOPMENT_LANGUAGE.tsv"
LESSON_MENU_SETTINGS_STRICT_CONFIG=1 LESSON_CONFIG="$empty_config" "$ROOT/tools/free-development" gate >/tmp/free-development-missing-prerequisite.out 2>&1 && exit 1 || true
grep 'missing menu prerequisite' /tmp/free-development-missing-prerequisite.out >/dev/null
LESSON_MENU_SETTINGS_STRICT_CONFIG=1 LESSON_CONFIG="$empty_config" "$ROOT/tools/product-improvement" start --confirm >/tmp/product-improvement-missing-prerequisite.out 2>&1 && exit 1 || true
grep 'missing menu prerequisite' /tmp/product-improvement-missing-prerequisite.out >/dev/null

missing_config="$tmp/MISSING_CONFIG.tsv"
cat > "$missing_config" <<CONFIG
# key	value
lesson_repo_name	ai-driven-development-lesson
product_repo_name	missing-product
project_root	$project_root
flow_file	lesson/LESSON_FLOW.tsv
state_file	learning/LESSON_STATE.tsv
learning_tracker_file	learning/LEARNING_TASK_TRACKER.md
learning_handoff_file	learning/LEARNING_HANDOFF.md
learning_mode_file	$tmp/LESSON_MODE.tsv
workflow_language_file	$tmp/WORKFLOW_DISPLAY_LANGUAGE.tsv
product_language_file	$tmp/PRODUCT_DEVELOPMENT_LANGUAGE.tsv
CONFIG
LESSON_CONFIG="$missing_config" "$ROOT/tools/free-development" gate >/tmp/free-development-missing.out 2>&1 && exit 1 || true
grep 'expected product repository does not exist' /tmp/free-development-missing.out >/dev/null

printf 'dirty\n' >> "$product_repo/README.md"
PATH="$fake_bin:$PATH" LESSON_CONFIG="$config" "$ROOT/tools/free-development" gate >/tmp/free-development-dirty.out 2>&1 && exit 1 || true
grep 'Working tree: dirty' /tmp/free-development-dirty.out >/dev/null
git -C "$product_repo" add README.md
git -C "$product_repo" commit -m "Record dirty-state test cleanup" >/dev/null
git -C "$product_repo" push >/dev/null

cat > "$fake_bin/gh" <<'GH'
#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  auth)
    if [[ "${2:-}" == "token" ]]; then
      printf 'fake-token\n'
      exit 0
    fi
    ;;
  api)
    printf 'completed\tfailure\tCI\tCI\tmain\t1\t0\t1s\t2026-06-02T00:00:00Z\n'
    exit 0
    ;;
  run)
    if [[ "${2:-}" == "list" ]]; then
      printf 'completed\tfailure\tCI\tCI\tmain\t1\t0\t1s\t2026-06-02T00:00:00Z\n'
      exit 0
    fi
    ;;
  repo)
    if [[ "${2:-}" == "view" ]]; then
      printf 'xxxMasahiro/sample-product\n'
      exit 0
    fi
    ;;
esac

printf 'unsupported fake gh command: %s\n' "$*" >&2
exit 1
GH
chmod +x "$fake_bin/gh"
PATH="$fake_bin:$PATH" LESSON_CONFIG="$config" "$ROOT/tools/free-development" gate >/tmp/free-development-ci-fail.out 2>&1 && exit 1 || true
grep 'CI status: latest run is not successful' /tmp/free-development-ci-fail.out >/dev/null

printf 'Product gate tool tests passed.\n'
