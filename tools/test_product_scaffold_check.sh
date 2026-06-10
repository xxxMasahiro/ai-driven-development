#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

make_repo() {
  local repo="$1"
  mkdir -p "$repo"
  git -C "$repo" init -q
  git -C "$repo" config user.name "Product Scaffold Test"
  git -C "$repo" config user.email "product-scaffold@example.com"
}

write_common_manifests() {
  local repo="$1"
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
}

write_good_repo() {
  local repo="$1"
  make_repo "$repo"
  mkdir -p "$repo/docs/product" "$repo/docs/workflow" "$repo/docs/memory" "$repo/ops" "$repo/src" "$repo/tests"
  printf '# Agent\n' >"$repo/AGENT.md"
  printf '# Product\n' >"$repo/README.md"
  printf '# Requirements\n' >"$repo/docs/product/REQUIREMENTS.md"
  printf '# Specification\n' >"$repo/docs/product/SPECIFICATION.md"
  printf '# Implementation Plan\n' >"$repo/docs/product/IMPLEMENTATION_PLAN.md"
  printf '# Task Tracker\n\n## Current Status\nReady.\n\n## Remaining Work\n- Continue.\n\nHANDOFF\n' >"$repo/docs/workflow/TASK_TRACKER.md"
  printf '# Handoff\n\n## Current State\nReady.\n\n## Next Step\n- Continue.\n\nTASK_TRACKER\n' >"$repo/docs/workflow/HANDOFF.md"
  printf '<!doctype html>\n<script src="src/app.js"></script>\n' >"$repo/index.html"
  printf 'console.log("product");\n' >"$repo/src/app.js"
  printf 'test("product", () => true);\n' >"$repo/tests/app.test.js"
  write_common_manifests "$repo"
  cat >"$repo/ops/PRODUCT_MANIFEST.tsv" <<'DOC'
# authority_id	required_mode	contexts	product_types	path	path_role	validation_rule	dashboard_group	description
product.entrypoint	required	all	all	index.html	entrypoint	file_exists	workflow	Browser entrypoint.
product.source	required	all	all	src/app.js	source	file_nonempty	workflow	Application source authority.
product.test	required	all	all	tests/app.test.js	test	file_nonempty	workflow	Test authority.
DOC
  cat >"$repo/ops/PRODUCT_PROFILE.json" <<'DOC'
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
    "en": "A product used by scaffold checks."
  },
  "source": "learner_confirmed",
  "confirmed_at": "2026-06-05T00:00:00Z",
  "source_documents": [
    "docs/product/REQUIREMENTS.md"
  ]
}
DOC
}

good_repo="$TMP_DIR/good"
write_good_repo "$good_repo"
"$ROOT/tools/product-scaffold-check" check --repo "$good_repo" --context free-development --product-type web \
  | grep 'Product scaffold check passed'

missing_manifest="$TMP_DIR/missing-manifest"
write_good_repo "$missing_manifest"
rm "$missing_manifest/ops/PRODUCT_MANIFEST.tsv"
"$ROOT/tools/product-scaffold-check" check --repo "$missing_manifest" --context free-development \
  >/tmp/product-scaffold-missing-manifest.out 2>&1 && exit 1 || true
grep 'ops/PRODUCT_MANIFEST.tsv' /tmp/product-scaffold-missing-manifest.out >/dev/null

missing_role="$TMP_DIR/missing-role"
write_good_repo "$missing_role"
awk -F '\t' '$1 ~ /^#/ || $6 != "test"' "$missing_role/ops/PRODUCT_MANIFEST.tsv" >"$missing_role/ops/PRODUCT_MANIFEST.tsv.next"
mv "$missing_role/ops/PRODUCT_MANIFEST.tsv.next" "$missing_role/ops/PRODUCT_MANIFEST.tsv"
"$ROOT/tools/product-scaffold-check" check --repo "$missing_role" --context free-development \
  >/tmp/product-scaffold-missing-role.out 2>&1 && exit 1 || true
grep 'required test authority' /tmp/product-scaffold-missing-role.out >/dev/null

missing_source="$TMP_DIR/missing-source"
write_good_repo "$missing_source"
rm "$missing_source/src/app.js"
"$ROOT/tools/product-scaffold-check" check --repo "$missing_source" --context free-development \
  >/tmp/product-scaffold-missing-source.out 2>&1 && exit 1 || true
grep 'product.source' /tmp/product-scaffold-missing-source.out >/dev/null

root_only="$TMP_DIR/root-only"
make_repo "$root_only"
mkdir -p "$root_only/ops" "$root_only/src" "$root_only/tests"
printf '# Agent\n' >"$root_only/AGENT.md"
printf '# Product\n' >"$root_only/README.md"
printf '# Requirements\n' >"$root_only/REQUIREMENTS.md"
printf '# Specification\n' >"$root_only/SPECIFICATION.md"
printf '# Implementation Plan\n' >"$root_only/IMPLEMENTATION_PLAN.md"
printf '# Task Tracker\n\n## Current Status\nReady.\n\n## Remaining Work\n- Continue.\n\nHANDOFF\n' >"$root_only/TASK_TRACKER.md"
printf '# Handoff\n\n## Current State\nReady.\n\n## Next Step\n- Continue.\n\nTASK_TRACKER\n' >"$root_only/HANDOFF.md"
printf 'source\n' >"$root_only/src/app.js"
printf 'test\n' >"$root_only/tests/app.test.js"
printf 'entry\n' >"$root_only/index.html"
write_common_manifests "$root_only"
cat >"$root_only/ops/PRODUCT_MANIFEST.tsv" <<'DOC'
# authority_id	required_mode	contexts	product_types	path	path_role	validation_rule	dashboard_group	description
product.entrypoint	required	all	all	index.html	entrypoint	file_exists	workflow	Browser entrypoint.
product.source	required	all	all	src/app.js	source	file_nonempty	workflow	Application source authority.
product.test	required	all	all	tests/app.test.js	test	file_nonempty	workflow	Test authority.
DOC
cat >"$root_only/ops/PRODUCT_PROFILE.json" <<'DOC'
{
  "schema_version": "1.0.0",
  "profile_kind": "product_display_profile",
  "menu_id": "free-development",
  "profile_scope": "product",
  "display_name": {
    "ja": "レガシー成果物",
    "en": "Legacy Product"
  },
  "description": {
    "ja": "レガシー配置検査用の成果物です。",
    "en": "A product used by legacy layout checks."
  },
  "source": "learner_confirmed",
  "confirmed_at": "2026-06-05T00:00:00Z",
  "source_documents": [
    "docs/product/REQUIREMENTS.md"
  ]
}
DOC
"$ROOT/tools/product-scaffold-check" check --repo "$root_only" --context free-development \
  >/tmp/product-scaffold-root-only.out 2>&1 && exit 1 || true
grep 'root-level duplicate for product_docs.requirements' /tmp/product-scaffold-root-only.out >/dev/null

root_memory_duplicate="$TMP_DIR/root-memory-duplicate"
write_good_repo "$root_memory_duplicate"
printf '# Session Memory\n' >"$root_memory_duplicate/SESSION_MEMORY.md"
"$ROOT/tools/product-scaffold-check" check --repo "$root_memory_duplicate" --context free-development \
  >/tmp/product-scaffold-root-memory.out 2>&1 && exit 1 || true
grep 'root-level duplicate for product_memory.session_memory' /tmp/product-scaffold-root-memory.out >/dev/null

printf 'Product scaffold check tests passed.\n'
