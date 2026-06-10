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

function stableStringify(value) {
  if (Array.isArray(value)) {
    return `[${value.map((item) => stableStringify(item)).join(',')}]`;
  }
  if (value && typeof value === 'object') {
    return `{${Object.keys(value).sort().map((key) => `${JSON.stringify(key)}:${stableStringify(value[key])}`).join(',')}}`;
  }
  return JSON.stringify(value);
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
  'not_run',
  'stale',
  'manual_required',
]);

if (!/^[0-9]+\.[0-9]+\.[0-9]+$/.test(requireField('schema_version'))) {
  fail('schema_version is not semver-like');
}
if (requireField('generated_at') !== '2026-06-05T00:00:00Z') {
  fail('generated_at override was not honored');
}
const snapshotId = requireField('snapshot_id');
const contentHash = requireField('content_hash');
if (typeof snapshotId !== 'string' || !snapshotId.startsWith('2026-06-05T00:00:00Z-')) {
  fail(`snapshot_id must be generated from producer-owned snapshot identity, got ${snapshotId}`);
}
if (!/^[a-f0-9]{64}$/.test(contentHash)) {
  fail(`content_hash must be a sha256 hex value, got ${contentHash}`);
}
if (!snapshotId.endsWith(contentHash.slice(0, 12))) {
  fail('snapshot_id must include the content_hash prefix');
}

for (const path of ['source_files', 'source_commands', 'partial_failures']) {
  if (!Array.isArray(requireField(path))) {
    fail(`${path} must be an array`);
  }
}
if (!Array.isArray(requireField('summary.manual_followups'))) {
  fail('summary.manual_followups must be an array');
}

for (const sourceFile of data.source_files) {
  if (sourceFile.startsWith('/') || /^https?:\/\//.test(sourceFile)) {
    fail(`source_files must stay repository-relative: ${sourceFile}`);
  }
}
if (!data.source_files.includes('docs/workflow/DASHBOARD_DATA_SCHEMA.tsv')) {
  fail('source_files does not include dashboard schema');
}
if (!data.source_files.includes('docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv')) {
  fail('source_files does not include product repository structure policy');
}
if (!data.source_files.includes('docs/workflow/MENU_PRODUCT_PROFILE_POLICY.tsv')) {
  fail('source_files does not include menu product profile policy');
}
if (!data.source_files.includes('docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv')) {
  fail('source_files does not include product gate evidence schema');
}
if (!data.source_commands.includes('tools/dashboard-data')) {
  fail('source_commands does not include dashboard-data');
}
if (!data.source_commands.includes('tools/product-repository-authority status --json')) {
  fail('source_commands does not include product repository authority status');
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
  'selected_context.git_status',
  'selected_context.ci_status',
  'selected_context.security_status',
  'selected_context.evidence_status',
  'summary.mode',
  'development.product_repository.status',
  'development.documents.status',
  'development.git_sync_status',
  'development.ci_status',
  'development.product_authority.status',
  'development.product_authority.repository.status',
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

const selectedContext = requireField('selected_context');
if (![
  'step_1_7',
  'step_1_14',
  'advanced',
  'free-development',
  'product-improvement',
  'external-integration',
  'lesson-repository-improvement',
  'unknown',
].includes(selectedContext.menu_id)) {
  fail(`invalid selected context menu id: ${selectedContext.menu_id}`);
}
if (![
  'none',
  'lesson',
  'free-development',
  'product-improvement',
  'external-integration',
  'lesson-maintenance',
  'custom',
  'unknown',
].includes(selectedContext.workflow_context)) {
  fail(`invalid selected workflow context: ${selectedContext.workflow_context}`);
}
const targetRepository = requireField('selected_context.target_repository');
if (typeof targetRepository.name !== 'string' || targetRepository.name.length === 0) {
  fail('selected context target repository name is required');
}
if (!['configured', 'missing', 'not_applicable', 'unknown'].includes(targetRepository.path_state)) {
  fail(`invalid selected target repository path state: ${targetRepository.path_state}`);
}
if (!['all', 'web', 'api', 'cli', 'library', 'integration', 'custom', 'unknown'].includes(selectedContext.product_type)) {
  fail(`invalid selected product type: ${selectedContext.product_type}`);
}
if (typeof selectedContext.current_step_id !== 'string' || selectedContext.current_step_id.length === 0) {
  fail('selected context current_step_id is required');
}
if (typeof selectedContext.current_step_label !== 'string' || selectedContext.current_step_label.length === 0) {
  fail('selected context current_step_label is required');
}
if (!Number.isInteger(selectedContext.current_step_index) || selectedContext.current_step_index < 0) {
  fail('selected context current_step_index must be a non-negative integer');
}
if (!Number.isInteger(selectedContext.current_step_total) || selectedContext.current_step_total < 0) {
  fail('selected context current_step_total must be a non-negative integer');
}
if (typeof selectedContext.updated_at !== 'string' || selectedContext.updated_at.length === 0) {
  fail('selected context updated_at is required');
}
if (!selectedContext.next_safe_action || typeof selectedContext.next_safe_action !== 'object' || Array.isArray(selectedContext.next_safe_action)) {
  fail('selected context next_safe_action must be an object');
}
if (!Array.isArray(selectedContext.blockers)) {
  fail('selected context blockers must be an array');
}
for (const blocker of selectedContext.blockers) {
  if (!blocker || typeof blocker !== 'object' || Array.isArray(blocker)) {
    fail('selected context blocker must be an object');
  }
  if (!['missing', 'failed', 'blocked', 'unknown', 'stale', 'not_run'].includes(blocker.status)) {
    fail(`invalid selected context blocker status: ${blocker.status}`);
  }
}
const availableContexts = requireField('available_contexts');
if (!Array.isArray(availableContexts) || availableContexts.length < 7) {
  fail('available_contexts must include the seven dashboard menu contexts');
}
const contextsByMenu = requireField('contexts_by_menu');
if (!contextsByMenu || typeof contextsByMenu !== 'object' || Array.isArray(contextsByMenu)) {
  fail('contexts_by_menu must be a producer-owned object map');
}
const availableMenuIds = new Set(availableContexts.map((context) => context.menu_id));
const contextMapKeys = new Set(Object.keys(contextsByMenu));
for (const menuId of [
  'step_1_7',
  'step_1_14',
  'advanced',
  'free-development',
  'product-improvement',
  'external-integration',
  'lesson-repository-improvement',
]) {
  if (!availableMenuIds.has(menuId)) {
    fail(`available_contexts is missing ${menuId}`);
  }
  if (!contextsByMenu[menuId]) {
    fail(`contexts_by_menu is missing ${menuId}`);
  }
}
for (const menuId of contextMapKeys) {
  if (!availableMenuIds.has(menuId)) {
    fail(`contexts_by_menu has an entry that is not available: ${menuId}`);
  }
}
for (const context of availableContexts) {
  if (!allowedStates.has(context.status)) {
    fail(`invalid available context status: ${context.status}`);
  }
  if (typeof context.target_repository_name !== 'string' || context.target_repository_name.length === 0) {
    fail('available context target_repository_name is required');
  }
  const fullContext = contextsByMenu[context.menu_id];
  if (!fullContext || typeof fullContext !== 'object' || Array.isArray(fullContext)) {
    fail(`contexts_by_menu.${context.menu_id} must be an object`);
  }
  if (fullContext.menu_id !== context.menu_id) {
    fail(`contexts_by_menu.${context.menu_id}.menu_id must match its key`);
  }
  for (const field of ['workflow_context', 'target_repository', 'product_type', 'current_step_id', 'current_step_label', 'updated_at', 'next_safe_action', 'blockers']) {
    if (!(field in fullContext)) {
      fail(`contexts_by_menu.${context.menu_id} missing ${field}`);
    }
  }
  for (const field of ['git_status', 'ci_status', 'security_status', 'evidence_status']) {
    if (!allowedStates.has(fullContext[field])) {
      fail(`invalid contexts_by_menu.${context.menu_id}.${field}: ${fullContext[field]}`);
    }
  }
  if (!['configured', 'missing', 'not_applicable', 'unknown'].includes(fullContext.target_repository.path_state)) {
    fail(`invalid contexts_by_menu.${context.menu_id}.target_repository.path_state`);
  }
  if (!Array.isArray(fullContext.blockers)) {
    fail(`contexts_by_menu.${context.menu_id}.blockers must be an array`);
  }
  if (['step_1_7', 'advanced', 'lesson-repository-improvement'].includes(context.menu_id) && fullContext.blockers.some((blocker) => /^product\.|^repositories\.product/.test(blocker.source))) {
    fail(`${context.menu_id} must not inherit product-operation blockers`);
  }
}
if (!contextsByMenu[selectedContext.menu_id]) {
  fail('selected_context must have a contexts_by_menu entry');
}
if (stableStringify(selectedContext) !== stableStringify(contextsByMenu[selectedContext.menu_id])) {
  fail('selected_context must match contexts_by_menu selected entry');
}

if (!['learning', 'development', 'maintenance', 'unknown'].includes(data.summary.mode)) {
  fail(`invalid summary mode: ${data.summary.mode}`);
}
if (!Array.isArray(data.summary.blocking_items)) {
  fail('summary.blocking_items must be an array');
}
const primaryAction = requireField('summary.primary_action');
for (const field of ['title', 'description', 'target', 'expected_result', 'risk_level', 'status', 'source']) {
  if (!(field in primaryAction)) {
    fail(`summary.primary_action missing ${field}`);
  }
}
if (!['low', 'medium', 'high', 'critical'].includes(primaryAction.risk_level)) {
  fail(`invalid primary action risk level: ${primaryAction.risk_level}`);
}
if (!allowedStates.has(primaryAction.status)) {
  fail(`invalid primary action status: ${primaryAction.status}`);
}

const categoryMetrics = requireField('summary.category_metrics');
for (const metricKey of ['overview', 'lessons', 'workflow', 'maintenance', 'security']) {
  const metric = categoryMetrics[metricKey];
  if (!metric || typeof metric !== 'object' || Array.isArray(metric)) {
    fail(`missing category metric: ${metricKey}`);
  }
  for (const field of ['total', 'healthy', 'warning', 'problem', 'percent']) {
    if (!Number.isInteger(metric[field]) || metric[field] < 0) {
      fail(`invalid ${metricKey} metric ${field}: ${metric[field]}`);
    }
  }
  if (metric.percent > 100) {
    fail(`invalid ${metricKey} percent: ${metric.percent}`);
  }
  if (metric.total !== metric.healthy + metric.warning + metric.problem) {
    fail(`category metric counts do not add up for ${metricKey}`);
  }
  if (typeof metric.unit !== 'string' || metric.unit.length === 0) {
    fail(`missing metric unit for ${metricKey}`);
  }
  if (!allowedStates.has(metric.status)) {
    fail(`invalid category metric status for ${metricKey}: ${metric.status}`);
  }
}

const lessonStatuses = Object.values(data.lessons).map((lesson) => lesson.status);
const expectedLessonHealthy = lessonStatuses.filter((state) => state === 'ready' || state === 'passed').length;
if (categoryMetrics.lessons.total !== lessonStatuses.length || categoryMetrics.lessons.healthy !== expectedLessonHealthy) {
  fail('lesson category metric must be derived from structured lesson statuses');
}
const expectedLessonPercent = lessonStatuses.length ? Math.floor((expectedLessonHealthy * 100) / lessonStatuses.length) : 0;
if (categoryMetrics.lessons.percent !== expectedLessonPercent) {
  fail('lesson category metric percent must be data-derived');
}

const gitOperations = requireField('development.git_operations');
if (!Array.isArray(gitOperations) || gitOperations.length < 6) {
  fail('development.git_operations must include the configured Git operation rows');
}

const recentRuns = requireField('development.recent_runs');
if (!Array.isArray(recentRuns) || recentRuns.length < 5) {
  fail('development.recent_runs must include producer-owned recent workflow rows');
}
for (const row of recentRuns) {
  for (const field of ['id', 'time', 'type', 'target', 'detail', 'status', 'reference']) {
    if (!(field in row) || row[field] === '') {
      fail(`recent workflow row missing ${field}`);
    }
  }
  if (!allowedStates.has(row.status)) {
    fail(`invalid recent workflow status: ${row.status}`);
  }
}
for (const row of gitOperations) {
  for (const field of ['id', 'label', 'status', 'mode', 'detail']) {
    if (!(field in row) || row[field] === '') {
      fail(`git operation row missing ${field}`);
    }
  }
  if (!allowedStates.has(row.status)) {
    fail(`invalid git operation status: ${row.status}`);
  }
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

const maintenanceEvidenceRows = requireField('maintenance.evidence_rows');
if (!Array.isArray(maintenanceEvidenceRows) || maintenanceEvidenceRows.length < 4) {
  fail('maintenance.evidence_rows must expose dashboard maintenance evidence');
}
for (const row of maintenanceEvidenceRows) {
  for (const field of ['id', 'label', 'importance', 'status', 'reference']) {
    if (!(field in row) || row[field] === '') {
      fail(`maintenance evidence row missing ${field}`);
    }
  }
  if (!allowedStates.has(row.status)) {
    fail(`invalid maintenance evidence status: ${row.status}`);
  }
}

for (const [collectionName, minCount] of [['approvals', 1], ['dangerous_operations', 1]]) {
  const rows = requireField(`security.${collectionName}`);
  if (!Array.isArray(rows) || rows.length < minCount) {
    fail(`security.${collectionName} must expose structured rows`);
  }
  for (const row of rows) {
    for (const field of ['id', 'label', 'status', 'detail', 'last_checked']) {
      if (!(field in row) || row[field] === '') {
        fail(`security ${collectionName} row missing ${field}`);
      }
    }
    if (!allowedStates.has(row.status)) {
      fail(`invalid security ${collectionName} status: ${row.status}`);
    }
  }
}

for (const failure of data.partial_failures) {
  for (const field of ['source', 'status', 'reason', 'required_command']) {
    if (!(field in failure)) {
      fail(`partial failure missing ${field}`);
    }
  }
  if (!['failed', 'blocked', 'unknown'].includes(failure.status)) {
    fail(`invalid partial failure status: ${failure.status}`);
  }
}
if (data.partial_failures.some((failure) => failure.status === 'optional')) {
  fail('partial_failures must not include optional manual follow-ups');
}
for (const blocker of selectedContext.blockers) {
  const expectedStatus = blocker.status === 'failed' ? 'failed' : blocker.status === 'blocked' ? 'blocked' : 'unknown';
  const match = data.partial_failures.find((failure) => failure.source === blocker.source);
  if (!match) {
    fail(`selected context blocker ${blocker.source} must appear in partial_failures`);
  }
  if (match.status !== expectedStatus) {
    fail(`selected context blocker ${blocker.source} partial status ${match.status} did not normalize from ${blocker.status}`);
  }
}
for (const failure of data.partial_failures) {
  if (!selectedContext.blockers.some((blocker) => blocker.source === failure.source)) {
    fail(`partial failure ${failure.source} is not scoped to selected_context.blockers`);
  }
}
for (const followup of data.summary.manual_followups) {
  for (const field of ['source', 'status', 'reason', 'required_command']) {
    if (!(field in followup)) {
      fail(`manual follow-up missing ${field}`);
    }
  }
  if (!['optional', 'cached', 'unknown'].includes(followup.status)) {
    fail(`invalid manual follow-up status: ${followup.status}`);
  }
}
if (!data.summary.manual_followups.some((followup) => followup.source === 'product_ci_live')) {
  fail('manual follow-ups must include optional product CI lookup');
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

const productAuthority = requireField('development.product_authority');
if (!productAuthority || typeof productAuthority !== 'object' || Array.isArray(productAuthority)) {
  fail('development.product_authority must be an object');
}
if (!allowedStates.has(productAuthority.status)) {
  fail(`invalid product authority status: ${productAuthority.status}`);
}
if (!['product_operations', 'none'].includes(productAuthority.repository.blocker_scope)) {
  fail(`invalid product authority blocker scope: ${productAuthority.repository.blocker_scope}`);
}
if (!productAuthority.product_summary || typeof productAuthority.product_summary !== 'object' || Array.isArray(productAuthority.product_summary)) {
  fail('product authority product_summary must be an object');
}
if (!['missing', 'ready', 'failed', 'unknown'].includes(productAuthority.product_summary.status)) {
  fail(`invalid product summary status: ${productAuthority.product_summary.status}`);
}
if (productAuthority.product_summary.source_path !== 'ops/PRODUCT_PROFILE.json') {
  fail(`product summary source_path must be ops/PRODUCT_PROFILE.json, got ${productAuthority.product_summary.source_path}`);
}
if (JSON.stringify(productAuthority.product_summary).includes('/tmp/')) {
  fail('product summary must not leak temporary absolute paths');
}
if (!Array.isArray(productAuthority.product_summary.source_documents)) {
  fail('product summary source_documents must be an array');
}
if (!Array.isArray(productAuthority.document_paths)) {
  fail('product authority document_paths must be an array');
}
for (const pathItem of productAuthority.document_paths) {
  for (const field of ['source_id', 'status', 'required_in_context', 'canonical_path', 'resolved_path', 'resolved_source']) {
    if (!(field in pathItem)) {
      fail(`product authority document path missing ${field}`);
    }
  }
  if (!allowedStates.has(pathItem.status)) {
    fail(`invalid product authority document path status: ${pathItem.status}`);
  }
}
if (!Array.isArray(productAuthority.manifest_summary.required_missing)) {
  fail('product authority required_missing must be an array');
}
if (!Array.isArray(productAuthority.manifest_summary.optional_missing)) {
  fail('product authority optional_missing must be an array');
}
if (!Array.isArray(productAuthority.evidence_summary.items)) {
  fail('product authority evidence items must be an array');
}
for (const item of productAuthority.evidence_summary.items) {
  for (const field of ['source_id', 'status', 'freshness_state', 'authority', 'product_root']) {
    if (!(field in item)) {
      fail(`product authority evidence item missing ${field}`);
    }
  }
  if (!allowedStates.has(item.status)) {
    fail(`invalid product evidence status: ${item.status}`);
  }
  if (!['current', 'stale', 'not_collected', 'unknown'].includes(item.freshness_state)) {
    fail(`invalid product evidence freshness: ${item.freshness_state}`);
  }
  if (!['authoritative', 'manual_required', 'advisory', 'not_collected'].includes(item.authority)) {
    fail(`invalid product evidence authority: ${item.authority}`);
  }
}
if (!Array.isArray(productAuthority.product_operation_blockers)) {
  fail('product authority product_operation_blockers must be an array');
}
for (const blocker of productAuthority.product_operation_blockers) {
  for (const field of ['source', 'status', 'reason', 'required_command']) {
    if (!(field in blocker)) {
      fail(`product authority blocker missing ${field}`);
    }
  }
  if (!['missing', 'failed', 'blocked', 'unknown', 'stale', 'not_run'].includes(blocker.status)) {
    fail(`invalid product operation blocker status: ${blocker.status}`);
  }
}
if (data.development.product_repository.status === 'missing') {
  if (!productAuthority.product_operation_blockers.some((blocker) => blocker.source === 'repositories.product')) {
    fail('missing product repository must be scoped as a product-operation blocker');
  }
  if (data.summary.blocking_items.some((blocker) => blocker.source === 'repositories.product')) {
    fail('missing product repository must not be mixed into lesson-only summary blockers');
  }
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
if (!Array.isArray(previews) || previews.length !== 4) {
  fail('command previews must expose the four display-only mock preview cards');
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
  if (preview.requires_approval !== false) {
    fail('Safety command preview cards must stay review-only; dangerous operations are reported under security.dangerous_operations');
  }
}
const commandPreviewGroups = requireField('actions.command_preview_groups');
if (!Array.isArray(commandPreviewGroups) || commandPreviewGroups.length < 1) {
  fail('actions.command_preview_groups must expose preview grouping data');
}
const previewGroupTotal = commandPreviewGroups.reduce((sum, group) => sum + (Number.isInteger(group.preview_count) ? group.preview_count : 0), 0);
if (previewGroupTotal !== previews.length) {
  fail('command preview group counts must match the producer-owned preview card total');
}
for (const group of commandPreviewGroups) {
  for (const field of ['id', 'label', 'risk_level', 'preview_count']) {
    if (!(field in group)) {
      fail(`command preview group missing ${field}`);
    }
  }
  if (!['low', 'medium', 'high', 'critical'].includes(group.risk_level)) {
    fail(`invalid command preview group risk level: ${group.risk_level}`);
  }
  if (!Number.isInteger(group.preview_count) || group.preview_count < 0) {
    fail('command preview group preview_count must be non-negative integer');
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

output="$(cat "$JSON_FILE")"
assert_contains "$output" '"schema_version"'
assert_contains "$output" '"command_previews"'
assert_contains "$output" '"command_preview_groups"'
assert_contains "$output" '"git_operations"'
assert_contains "$output" '"recent_runs"'
assert_contains "$output" '"contexts_by_menu"'
assert_contains "$output" '"evidence_rows"'

for menu_id in step_1_7 free-development lesson-repository-improvement; do
  menu_json="$TMP_DIR/dashboard-data-$menu_id.json"
  DASHBOARD_DATA_GENERATED_AT="2026-06-05T00:00:00Z" DASHBOARD_SELECTED_MENU_ID="$menu_id" "$ROOT/tools/dashboard-data" >"$menu_json"
  node - "$menu_json" "$menu_id" <<'NODE'
const fs = require('fs');
const data = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const menuId = process.argv[3];
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.selected_context.menu_id !== menuId) {
  fail(`selected context did not honor ${menuId}`);
}
if (!data.contexts_by_menu[menuId]) {
  fail(`contexts_by_menu missing selected ${menuId}`);
}
if (data.selected_context.workflow_context !== data.contexts_by_menu[menuId].workflow_context) {
  fail(`selected context workflow_context does not match contexts_by_menu for ${menuId}`);
}
if (['step_1_7', 'advanced', 'lesson-repository-improvement'].includes(menuId)) {
  const leaked = data.selected_context.blockers.some((blocker) => /^product\.|^repositories\.product/.test(blocker.source));
  if (leaked) {
    fail(`${menuId} selected context leaked product-operation blockers`);
  }
}
NODE
done

product_project_root="$TMP_DIR/projects"
product_repo="$product_project_root/dashboard-product"
mkdir -p "$product_repo/docs/product" "$product_repo/docs/workflow" "$product_repo/docs/memory" "$product_repo/ops" "$product_repo/src" "$product_repo/tests" "$product_repo/.github/workflows" "$product_repo/.git/product-gate-evidence"
git -C "$product_repo" init -q
printf '# Product Agent\n' >"$product_repo/AGENT.md"
printf '# Product\n' >"$product_repo/README.md"
printf '# Requirements\n' >"$product_repo/docs/product/REQUIREMENTS.md"
printf '# Specification\n' >"$product_repo/docs/product/SPECIFICATION.md"
printf '# Implementation Plan\n' >"$product_repo/docs/product/IMPLEMENTATION_PLAN.md"
printf '# Task Tracker\n' >"$product_repo/docs/workflow/TASK_TRACKER.md"
printf '# Handoff\n' >"$product_repo/docs/workflow/HANDOFF.md"
printf 'source\n' >"$product_repo/src/index.txt"
printf 'test\n' >"$product_repo/tests/test.txt"
cat >"$product_repo/ops/STAGE_MANIFEST.tsv" <<'DOC'
# stage_id	required_mode	contexts	product_types	dashboard_group	description
build	required	all	all	workflow	Build stage.
DOC
cat >"$product_repo/ops/TEST_PLAN_MANIFEST.tsv" <<'DOC'
# test_id	required_mode	contexts	product_types	command_id	evidence_source	dashboard_group	description
unit	required	all	all	npm_test	product.gates.tests	workflow	Unit test.
DOC
cat >"$product_repo/ops/CI_MANIFEST.tsv" <<'DOC'
# ci_id	required_mode	contexts	workflow_file	workflow_name	branch_policy	evidence_source	description
main	contextual	product-improvement|external-integration	.github/workflows/ci.yml	CI	main	product.ci.main	Main CI.
DOC
cat >"$product_repo/ops/SECURITY_MANIFEST.tsv" <<'DOC'
# security_id	required_mode	contexts	policy_source	evidence_source	dashboard_group	description
secrets	required	all	docs/workflow/SECURITY.md	product.security.secrets	security	Secret scan.
DOC
cat >"$product_repo/ops/DASHBOARD_MANIFEST.tsv" <<'DOC'
# surface_id	required_mode	contexts	source_id	label_key	dashboard_group	description
overview	required	all	product.overview	overview	overview	Product overview.
DOC
cat >"$product_repo/ops/PRODUCT_MANIFEST.tsv" <<'DOC'
# authority_id	required_mode	contexts	product_types	path	path_role	validation_rule	dashboard_group	description
product.entrypoint	required	all	all	README.md	entrypoint	file_exists	workflow	Product entrypoint.
product.source	required	all	all	src/index.txt	source	file_nonempty	workflow	Product source authority.
product.test	required	all	all	tests/test.txt	test	file_nonempty	workflow	Product test authority.
DOC
cat >"$product_repo/ops/PRODUCT_PROFILE.json" <<'DOC'
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
    "prompts/PROMPTS_14_DAYS.md",
    "lesson/LESSON_FLOW_14_DAYS.tsv"
  ]
}
DOC
cat >"$product_repo/.git/product-gate-evidence/index.tsv" <<'DOC'
# source_id	context	status	freshness_state	required_in_context	authority	observed_at	max_age_seconds	product_root	product_head	source_artifacts	blocked_by	next_command
product.git.sync	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/dashboard-product	none	ops/CI_MANIFEST.tsv		./tools/check_git_sync.sh --product --required
product.gates.tests	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/dashboard-product	none	ops/TEST_PLAN_MANIFEST.tsv		npm test
product.ci.main	product-improvement	failed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/dashboard-product	none	ops/CI_MANIFEST.tsv	product.git.sync	./tools/check_ci_status.sh --product --required
product.security.secrets	product-improvement	passed	current	true	authoritative	2026-06-07T00:00:00Z	3600	[external-product-repository]/dashboard-product	none	ops/SECURITY_MANIFEST.tsv		./tools/product-security gate
DOC
dashboard_config="$TMP_DIR/dashboard-lesson-config.tsv"
cat >"$dashboard_config" <<DOC
# key	value
lesson_repo_name	ai-driven-development-lesson
product_repo_name	dashboard-product
project_root	$product_project_root
flow_file	lesson/LESSON_FLOW_14_DAYS.tsv
state_file	learning/LESSON_STATE_14_DAYS.tsv
learning_tracker_file	learning/LEARNING_TASK_TRACKER_14_DAYS.md
learning_handoff_file	learning/LEARNING_HANDOFF_14_DAYS.md
approval_file	learning/LESSON_APPROVALS_14_DAYS.tsv
learning_mode_file	learning/LESSON_MODE_14_DAYS.tsv
workflow_language_file	learning/WORKFLOW_DISPLAY_LANGUAGE_14_DAYS.tsv
product_language_file	learning/PRODUCT_DEVELOPMENT_LANGUAGE_14_DAYS.tsv
roadmap_file	learning/ROADMAP.md
helpdesk_file	learning/HELP_DESK.md
sync_gates_file	lesson/SYNC_GATES_14_DAYS.tsv
prompt_file	prompts/PROMPTS_14_DAYS.md
DOC
evidence_backed_context_json="$TMP_DIR/dashboard-data-product-improvement.json"
DASHBOARD_DATA_GENERATED_AT="2026-06-05T00:00:00Z" DASHBOARD_SELECTED_MENU_ID="product-improvement" DASHBOARD_LESSON14_CONFIG="$dashboard_config" "$ROOT/tools/dashboard-data" >"$evidence_backed_context_json"
node - "$evidence_backed_context_json" <<'NODE'
const fs = require('fs');
const data = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
function fail(message) {
  console.error(message);
  process.exit(1);
}
if (data.selected_context.menu_id !== 'product-improvement') {
  fail(`expected product-improvement selected context, got ${data.selected_context.menu_id}`);
}
if (data.selected_context.git_status !== 'passed') {
  fail(`expected selected_context.git_status to propagate product.git evidence, got ${data.selected_context.git_status}`);
}
if (data.selected_context.ci_status !== 'failed') {
  fail(`expected selected_context.ci_status to propagate product.ci evidence, got ${data.selected_context.ci_status}`);
}
if (data.selected_context.security_status !== 'passed') {
  fail(`expected selected_context.security_status to propagate product.security evidence, got ${data.selected_context.security_status}`);
}
if (data.development.product_authority.product_summary.status !== 'ready') {
  fail(`expected product summary ready, got ${data.development.product_authority.product_summary.status}`);
}
if (data.development.product_authority.product_summary.display_name.ja !== 'タスク管理表') {
  fail('product summary did not preserve the learner-confirmed Japanese product name');
}
if (data.development.product_authority.product_summary.source_path !== 'ops/PRODUCT_PROFILE.json') {
  fail('product summary did not use PRODUCT_PROFILE.json as the canonical source');
}
if (!data.selected_context.blockers.some((blocker) => blocker.source === 'product.ci.main' && blocker.status === 'failed')) {
  fail('failed product CI evidence must remain in selected_context.blockers');
}
const matchingFailure = data.partial_failures.find((failure) => failure.source === 'product.ci.main');
if (!matchingFailure || matchingFailure.status !== 'failed') {
  fail('failed product CI evidence must appear as a current-context partial failure');
}
NODE

invalid_menu_json="$TMP_DIR/dashboard-data-invalid-menu.json"
DASHBOARD_DATA_GENERATED_AT="2026-06-05T00:00:00Z" DASHBOARD_SELECTED_MENU_ID="invalid-menu" "$ROOT/tools/dashboard-data" >"$invalid_menu_json"
node - "$invalid_menu_json" <<'NODE'
const fs = require('fs');
const data = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
if (data.selected_context.menu_id !== 'unknown') {
  console.error(`invalid menu id should fall back to unknown, got ${data.selected_context.menu_id}`);
  process.exit(1);
}
NODE

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
