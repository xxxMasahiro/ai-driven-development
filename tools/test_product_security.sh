#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

project_root="$tmp/projects"
product_name="sample-product"
product_repo="$project_root/$product_name"
config="$tmp/LESSON_CONFIG.tsv"

mkdir -p "$project_root"
git -c init.defaultBranch=main init "$product_repo" >/dev/null
git -C "$product_repo" config user.name "Lesson Test"
git -C "$product_repo" config user.email "lesson-test@example.com"

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

cat > "$product_repo/README.md" <<'DOC'
# Sample Product
DOC
mkdir -p "$product_repo/docs/product" "$product_repo/docs/workflow"

cat > "$product_repo/docs/product/REQUIREMENTS.md" <<'DOC'
# REQUIREMENTS.md
DOC
cat > "$product_repo/docs/product/SPECIFICATION.md" <<'DOC'
# SPECIFICATION.md
DOC
cat > "$product_repo/docs/product/IMPLEMENTATION_PLAN.md" <<'DOC'
# IMPLEMENTATION_PLAN.md
DOC
cat > "$product_repo/docs/workflow/TASK_TRACKER.md" <<'DOC'
# TASK_TRACKER.md

## Current Status

Ready.
DOC
cat > "$product_repo/docs/workflow/HANDOFF.md" <<'DOC'
# HANDOFF.md

## Current State

Ready.
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

git -C "$product_repo" add .
git -C "$product_repo" commit -m "Initial sample product" >/dev/null

LESSON_CONFIG="$config" "$ROOT/tools/product-security" status --context free-development | grep 'Product Security Status'
LESSON_CONFIG="$config" "$ROOT/tools/product-security" advise --context product-improvement | grep 'Safety summary'
LESSON_CONFIG="$config" "$ROOT/tools/product-security" preflight --context free-development | grep 'Product security preflight passed'
LESSON_CONFIG="$config" "$ROOT/tools/product-security" check --context product-improvement | grep 'Product security check passed'
LESSON_CONFIG="$config" "$ROOT/tools/product-security" gate --context external-integration | grep 'Product security gate passed'

printf 'SECRET_TOKEN=supersecretvalue\n' > "$product_repo/.env"
LESSON_CONFIG="$config" "$ROOT/tools/product-security" check --context free-development >/tmp/product-security-secret.out 2>&1 && exit 1 || true
grep 'secret-like data in .env' /tmp/product-security-secret.out >/dev/null
if grep -Fq 'supersecretvalue' /tmp/product-security-secret.out; then
  printf 'product-security leaked a secret value\n' >&2
  exit 1
fi
rm "$product_repo/.env"

mv "$product_repo/EXTERNAL_INTEGRATION_SECURITY.md" "$product_repo/EXTERNAL_INTEGRATION_SECURITY.md.off"
LESSON_CONFIG="$config" "$ROOT/tools/product-security" gate --context external-integration >/tmp/product-security-approval.out 2>&1 && exit 1 || true
grep 'missing external integration security approval document' /tmp/product-security-approval.out >/dev/null
mv "$product_repo/EXTERNAL_INTEGRATION_SECURITY.md.off" "$product_repo/EXTERNAL_INTEGRATION_SECURITY.md"

LESSON_CONFIG="$config" "$ROOT/tools/product-security" check --context unknown >/tmp/product-security-context.out 2>&1 && exit 1 || true
grep 'unknown product security context: unknown' /tmp/product-security-context.out >/dev/null

printf 'Product security tests passed.\n'
