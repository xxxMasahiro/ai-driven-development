#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

assert_contains() {
  local haystack="$1"
  local needle="$2"
  if [[ "$haystack" != *"$needle"* ]]; then
    printf 'missing expected text: %s\n' "$needle" >&2
    exit 1
  fi
}

JSON_FILE="$TMP_DIR/dashboard-data.json"
DASHBOARD_DATA_GENERATED_AT="2026-06-05T00:00:00Z" "$ROOT/tools/dashboard-data" >"$JSON_FILE"

node - "$JSON_FILE" <<'NODE'
const fs = require('fs');
const file = process.argv[2];
const raw = fs.readFileSync(file, 'utf8');
let data;
try {
  data = JSON.parse(raw);
} catch (error) {
  console.error(`dashboard-data output is not valid JSON: ${error.message}`);
  process.exit(1);
}

function fail(message) {
  console.error(message);
  process.exit(1);
}

function requireField(path) {
  const parts = path.split('.');
  let current = data;
  for (const part of parts) {
    if (current === null || typeof current !== 'object' || !(part in current)) {
      fail(`missing JSON field: ${path}`);
    }
    current = current[part];
  }
  return current;
}

const allowedStates = new Set([
  'missing',
  'ready',
  'passed',
  'failed',
  'blocked',
  'unknown',
  'approval_required',
  'optional',
  'cached',
]);

if (!/^[0-9]+\.[0-9]+\.[0-9]+$/.test(requireField('schema_version'))) {
  fail('schema_version is not semver-like');
}
if (requireField('generated_at') !== '2026-06-05T00:00:00Z') {
  fail('generated_at override was not honored');
}

for (const path of ['source_files', 'source_commands', 'partial_failures']) {
  if (!Array.isArray(requireField(path))) {
    fail(`${path} must be an array`);
  }
}

for (const sourceFile of data.source_files) {
  if (sourceFile.startsWith('/') || /^https?:\/\//.test(sourceFile)) {
    fail(`source_files must stay repository-relative: ${sourceFile}`);
  }
}
if (!data.source_files.includes('docs/workflow/DASHBOARD_DATA_SCHEMA.tsv')) {
  fail('source_files does not include dashboard schema');
}
if (!data.source_commands.includes('tools/dashboard-data')) {
  fail('source_commands does not include dashboard-data');
}
for (const optionalCommand of [
  'tools/check_as_built_sync_contract.sh',
  'tools/check_workflow_pair_sync.sh',
  'tools/check_git_sync.sh',
  'tools/check_ci_status.sh',
  'tools/git-workflow status',
  'tools/product-security status',
]) {
  if (data.source_commands.includes(optionalCommand)) {
    fail(`source_commands must not claim unexecuted optional command as a source: ${optionalCommand}`);
  }
}

for (const path of [
  'summary.mode',
  'development.product_repository.status',
  'development.documents.status',
  'development.git_sync_status',
  'development.ci_status',
  'maintenance.as_built_sync_status',
  'maintenance.workflow_pair_status',
  'maintenance.developer_memory_status',
  'maintenance.skills_status',
  'git_workflow.policy_status',
  'git_workflow.settings_status',
  'git_workflow.gate_status',
  'git_workflow.approval_status',
  'security.policy_status',
  'security.gate_status',
  'security.dangerous_action_approval',
]) {
  const value = requireField(path);
  if (!allowedStates.has(value) && path !== 'summary.mode') {
    fail(`invalid state at ${path}: ${value}`);
  }
}

if (!['learning', 'development', 'maintenance', 'unknown'].includes(data.summary.mode)) {
  fail(`invalid summary mode: ${data.summary.mode}`);
}
if (!Array.isArray(data.summary.blocking_items)) {
  fail('summary.blocking_items must be an array');
}
if (!Array.isArray(data.summary.guidance_items) || data.summary.guidance_items.length < 2) {
  fail('summary.guidance_items must be a non-empty array for lesson and workflow guidance');
}
const guidanceSurfaces = new Set();
const guidanceAudiences = new Set();
for (const item of data.summary.guidance_items) {
  for (const field of ['surface', 'audience', 'priority', 'message', 'related_command']) {
    if (!(field in item)) {
      fail(`guidance item missing ${field}`);
    }
  }
  if (!['lesson', 'workflow'].includes(item.surface)) {
    fail(`invalid guidance surface: ${item.surface}`);
  }
  if (!['non_engineer', 'engineer', 'all'].includes(item.audience)) {
    fail(`invalid guidance audience: ${item.audience}`);
  }
  if (!['info', 'attention', 'action'].includes(item.priority)) {
    fail(`invalid guidance priority: ${item.priority}`);
  }
  if (typeof item.message !== 'string' || item.message.length === 0 || item.message.length > 180) {
    fail('guidance messages must be concise non-empty strings');
  }
  guidanceSurfaces.add(item.surface);
  guidanceAudiences.add(item.audience);
}
if (!guidanceSurfaces.has('lesson') || !guidanceSurfaces.has('workflow')) {
  fail('guidance items must cover both lesson and workflow surfaces');
}
if (!guidanceAudiences.has('non_engineer') || !guidanceAudiences.has('engineer')) {
  fail('guidance items must cover non-engineer and engineer audiences');
}

for (const failure of data.partial_failures) {
  for (const field of ['source', 'status', 'reason', 'required_command']) {
    if (!(field in failure)) {
      fail(`partial failure missing ${field}`);
    }
  }
  if (!['optional', 'failed', 'unknown'].includes(failure.status)) {
    fail(`invalid partial failure status: ${failure.status}`);
  }
}
if (!data.partial_failures.some((failure) => failure.source === 'product_ci_live')) {
  fail('partial failures must include optional product CI lookup');
}

if ('status' in data.git_workflow || 'status' in data.security) {
  fail('git_workflow/security must not collapse separate policy and gate statuses');
}
if (data.git_workflow.policy_status !== 'ready') {
  fail(`expected git workflow policy ready, got ${data.git_workflow.policy_status}`);
}
if (data.git_workflow.settings_status !== 'ready') {
  fail(`expected git workflow settings ready, got ${data.git_workflow.settings_status}`);
}
if (data.git_workflow.gate_status === data.git_workflow.policy_status) {
  fail('git workflow gate status must not be inferred from policy readiness');
}
if (data.security.policy_status !== 'ready') {
  fail(`expected security policy ready, got ${data.security.policy_status}`);
}
if (data.security.gate_status === data.security.policy_status) {
  fail('security gate status must not be inferred from policy readiness');
}

if (data.lessons.step_1_14.status === 'unknown' && data.lessons.step_1_14.current_step === 'unknown') {
  fail('completed or inactive STEP 1-14 state must not collapse to unknown without checking completion');
}
for (const lessonPath of ['lessons.step_1_7', 'lessons.step_1_14', 'lessons.advanced']) {
  const lesson = requireField(lessonPath);
  if (!Array.isArray(lesson.points) || !Array.isArray(lesson.warnings)) {
    fail(`${lessonPath} must expose structured points and warnings arrays`);
  }
  if (typeof lesson.next_learning_action !== 'string' || lesson.next_learning_action.length === 0) {
    fail(`${lessonPath} must expose a structured next learning action`);
  }
  for (const item of [...lesson.points, ...lesson.warnings, lesson.next_learning_action]) {
    if (/\/home\/|\/tmp\/|gh[pousr]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}/.test(item)) {
      fail(`${lessonPath} leaked unsafe lesson guidance text`);
    }
  }
}

const previews = requireField('actions.command_previews');
if (!Array.isArray(previews) || previews.length === 0) {
  fail('command previews must be a non-empty array');
}
for (const preview of previews) {
  for (const field of ['intent', 'target', 'risk_level', 'requires_approval', 'approval_gate_id', 'argv', 'command_text', 'execution_mode', 'non_executable']) {
    if (!(field in preview)) {
      fail(`command preview missing ${field}`);
    }
  }
  if (!['low', 'medium', 'high', 'critical'].includes(preview.risk_level)) {
    fail(`invalid command preview risk: ${preview.risk_level}`);
  }
  if (!Array.isArray(preview.argv)) {
    fail('command preview argv must be an array');
  }
  if (preview.execution_mode !== 'preview_only' || preview.non_executable !== true) {
    fail('command previews must remain preview_only and non_executable');
  }
}
for (const risk of ['high', 'critical']) {
  if (!previews.some((preview) => preview.risk_level === risk && preview.requires_approval === true)) {
    fail(`missing approval-required ${risk} command preview`);
  }
}

if (/\/home\/|\/tmp\/|gh[pousr]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}/.test(raw)) {
  fail('dashboard-data JSON leaked absolute paths or secret-like data');
}
NODE

redacted="$(
  # shellcheck source=tools/lib/dashboard_data.sh
  source "$ROOT/tools/lib/dashboard_data.sh"
  dashboard_data_safe_text 'TOKEN=abcdefghijklmnop'
)"
if [[ "$redacted" != "[redacted secret-like data]" ]]; then
  printf 'dashboard_data_safe_text did not redact secret-like text\n' >&2
  exit 1
fi

escaped_control="$(
  # shellcheck source=tools/lib/dashboard_data.sh
  source "$ROOT/tools/lib/dashboard_data.sh"
  dashboard_json_string $'bad\001text\033done'
)"
node - "$escaped_control" <<'NODE'
let decoded;
try {
  decoded = JSON.parse(process.argv[2]);
} catch (error) {
  console.error(`dashboard_json_string did not escape control characters: ${error.message}`);
  process.exit(1);
}
if (decoded !== 'badtextdone') {
  console.error(`dashboard_json_string did not strip unsafe control characters: ${decoded}`);
  process.exit(1);
}
NODE

output="$("$ROOT/tools/dashboard-data")"
assert_contains "$output" '"schema_version"'
assert_contains "$output" '"command_previews"'

MISSING_POLICY_JSON="$TMP_DIR/dashboard-data-missing-policy.json"
MISSING_POLICY_ERR="$TMP_DIR/dashboard-data-missing-policy.err"
if ! DASHBOARD_DATA_GENERATED_AT="2026-06-05T00:00:00Z" GIT_WORKFLOW_POLICY_FILE="$TMP_DIR/missing-policy.tsv" "$ROOT/tools/dashboard-data" >"$MISSING_POLICY_JSON" 2>"$MISSING_POLICY_ERR"; then
  printf 'dashboard-data failed when Git workflow policy file was missing\n' >&2
  exit 1
fi
if [[ -s "$MISSING_POLICY_ERR" ]]; then
  printf 'dashboard-data leaked stderr for missing Git workflow policy file:\n' >&2
  cat "$MISSING_POLICY_ERR" >&2
  exit 1
fi
node - "$MISSING_POLICY_JSON" <<'NODE'
const fs = require('fs');
const file = process.argv[2];
const raw = fs.readFileSync(file, 'utf8');
const data = JSON.parse(raw);
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.git_workflow.policy_status !== 'missing') {
  fail(`expected missing policy_status for missing policy file, got ${data.git_workflow.policy_status}`);
}
if (data.git_workflow.settings_status !== 'missing') {
  fail(`expected missing settings_status for missing policy file, got ${data.git_workflow.settings_status}`);
}
if (/\/tmp\/|awk:|fatal/.test(raw)) {
  fail('missing policy JSON leaked raw path or tool error text');
}
NODE

EMPTY_POLICY="$TMP_DIR/empty-policy.tsv"
EMPTY_POLICY_JSON="$TMP_DIR/dashboard-data-empty-policy.json"
EMPTY_POLICY_ERR="$TMP_DIR/dashboard-data-empty-policy.err"
: >"$EMPTY_POLICY"
if ! DASHBOARD_DATA_GENERATED_AT="2026-06-05T00:00:00Z" GIT_WORKFLOW_POLICY_FILE="$EMPTY_POLICY" "$ROOT/tools/dashboard-data" >"$EMPTY_POLICY_JSON" 2>"$EMPTY_POLICY_ERR"; then
  printf 'dashboard-data failed when Git workflow policy rows were empty\n' >&2
  exit 1
fi
if [[ -s "$EMPTY_POLICY_ERR" ]]; then
  printf 'dashboard-data leaked stderr for empty Git workflow policy rows:\n' >&2
  cat "$EMPTY_POLICY_ERR" >&2
  exit 1
fi
node - "$EMPTY_POLICY_JSON" <<'NODE'
const fs = require('fs');
const file = process.argv[2];
const data = JSON.parse(fs.readFileSync(file, 'utf8'));
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.git_workflow.policy_status !== 'failed') {
  fail(`expected failed policy_status for empty policy rows, got ${data.git_workflow.policy_status}`);
}
if (data.git_workflow.settings_status !== 'failed') {
  fail(`expected failed settings_status for empty policy rows, got ${data.git_workflow.settings_status}`);
}
NODE

COMPLETED_STATE="$TMP_DIR/completed-lesson-state.tsv"
COMPLETED_CONFIG="$TMP_DIR/completed-lesson-config.tsv"
COMPLETED_JSON="$TMP_DIR/dashboard-data-completed-lesson.json"
cat >"$COMPLETED_STATE" <<'EOF_STATE'
# order	step_id	status	started_at	completed_at
001	setup.index	completed	2026-06-05 00:00:00	2026-06-05 00:01:00
002	day1.example	completed	2026-06-05 00:01:00	2026-06-05 00:02:00
EOF_STATE
{
  printf '# key\tvalue\n'
  printf 'state_file\t%s\n' "$COMPLETED_STATE"
} >"$COMPLETED_CONFIG"
DASHBOARD_DATA_GENERATED_AT="2026-06-05T00:00:00Z" DASHBOARD_LESSON14_CONFIG="$COMPLETED_CONFIG" "$ROOT/tools/dashboard-data" >"$COMPLETED_JSON"
node - "$COMPLETED_JSON" <<'NODE'
const fs = require('fs');
const data = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.lessons.step_1_14.status !== 'passed') {
  fail(`expected completed STEP 1-14 fixture to report passed, got ${data.lessons.step_1_14.status}`);
}
if (data.lessons.step_1_14.current_step !== 'all steps completed') {
  fail(`expected completed STEP 1-14 fixture current_step to say all steps completed, got ${data.lessons.step_1_14.current_step}`);
}
NODE

printf 'Dashboard data test passed.\n'
