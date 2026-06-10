export const ALLOWED_STATES = new Set([
  "missing",
  "ready",
  "passed",
  "failed",
  "blocked",
  "unknown",
  "approval_required",
  "optional",
  "cached",
  "not_run",
  "stale",
  "manual_required",
]);

export const RISK_LEVELS = new Set(["low", "medium", "high", "critical"]);
export const MANUAL_FOLLOWUP_STATES = new Set(["optional", "cached", "unknown"]);
export const PARTIAL_FAILURE_STATES = new Set(["failed", "blocked", "unknown"]);
export const PRODUCT_OPERATION_BLOCKER_STATES = new Set(["missing", "failed", "blocked", "unknown", "stale", "not_run"]);

const SECRET_PATTERN =
  /(SECRET|TOKEN|API_KEY|PASSWORD|PRIVATE_KEY)\s*[:=]\s*[^\s#]{8,}|gh[pousr]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY/i;

const MENU_IDS = new Set([
  "step_1_7",
  "step_1_14",
  "advanced",
  "free-development",
  "product-improvement",
  "external-integration",
  "lesson-repository-improvement",
  "unknown",
]);

const WORKFLOW_CONTEXTS = new Set([
  "none",
  "lesson",
  "free-development",
  "product-improvement",
  "external-integration",
  "lesson-maintenance",
  "custom",
  "unknown",
]);

const REPOSITORY_PATH_STATES = new Set(["configured", "missing", "not_applicable", "unknown"]);
const PRODUCT_TYPES = new Set(["all", "web", "api", "cli", "library", "integration", "custom", "unknown"]);
const DOCUMENT_AUDIENCES = new Set(["non_engineer", "engineer", "all"]);
const DOCUMENT_RELATED_PAGES = new Set(["#documents", "#maintenance", "#workflow", "#safety", "#repository-info", "#history"]);

function safeRelativePath(value) {
  if (typeof value !== "string") {
    return "";
  }
  const normalized = value.replace(/[\u0000-\u001f]/g, "").trim();
  if (
    !normalized ||
    normalized.startsWith("/") ||
    normalized.startsWith("\\") ||
    /^[A-Za-z]:[\\/]/.test(normalized) ||
    normalized.split(/[\\/]+/).some((part) => part === "..")
  ) {
    return "";
  }
  return normalized;
}

function safeScopedRelativePath(value) {
  if (typeof value !== "string") {
    return "";
  }
  if (value.startsWith("product:")) {
    return safeRelativePath(value.slice("product:".length));
  }
  return safeRelativePath(value);
}

function safeDisplayCommand(value) {
  if (typeof value !== "string") {
    return "";
  }
  const normalized = value.replace(/[\u0000-\u001f]/g, "").replace(/\s+/g, " ").trim();
  if (!normalized || /[;&|`$<>\\]/.test(normalized)) {
    return "";
  }
  return /^tools\/[A-Za-z0-9._-]+(?: [A-Za-z0-9._:@/%+=,-]+)*$/.test(normalized) ? normalized : "";
}

export function displayText(value, fallback = "unknown") {
  if (value === null || value === undefined || value === "") {
    return fallback;
  }
  const text = Array.isArray(value) ? value.join(", ") : String(value);
  const normalized = text.replace(/[\u0000-\u0008\u000b\u000c\u000e-\u001f]/g, "").replace(/\s+/g, " ").trim();
  if (!normalized) {
    return fallback;
  }
  if (SECRET_PATTERN.test(normalized)) {
    return "[redacted secret-like data]";
  }
  return normalized.replace(/(^|\s)\/[^\s]+/g, "$1[absolute-path]");
}

export function displayKey(value) {
  return displayText(value)
    .replace(/[_-]+/g, " ")
    .replace(/\b\w/g, (character) => character.toUpperCase());
}

function validateLocalizedTextObject(value, label) {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    throw new Error(`${label} must be a localized object`);
  }
  assertAllowedKeys(value, new Set(["ja", "en", "key"]), label);
  if (!displayText(value.ja, "") && !displayText(value.en, "") && !displayText(value.key, "")) {
    throw new Error(`${label} is missing localized text`);
  }
}

export function normalizeState(value) {
  const state = displayText(value, "unknown");
  return ALLOWED_STATES.has(state) ? state : "unknown";
}

export function normalizeRisk(value) {
  const risk = displayText(value, "low");
  return RISK_LEVELS.has(risk) ? risk : "low";
}

export function asArray(value) {
  if (Array.isArray(value)) {
    return value;
  }
  if (value === null || value === undefined || value === "") {
    return [];
  }
  return [value];
}

export function asObject(value, name = "value") {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    throw new Error(`${name} must be an object`);
  }
  return value;
}

export function objectEntries(value) {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    return [];
  }
  return Object.entries(value);
}

function stableStringify(value) {
  if (Array.isArray(value)) {
    return `[${value.map((item) => stableStringify(item)).join(",")}]`;
  }
  if (value && typeof value === "object") {
    return `{${Object.keys(value)
      .sort()
      .map((key) => `${JSON.stringify(key)}:${stableStringify(value[key])}`)
      .join(",")}}`;
  }
  return JSON.stringify(value);
}

function assertAllowedKeys(object, allowedKeys, label) {
  for (const key of Object.keys(object)) {
    if (!allowedKeys.has(key)) {
      throw new Error(`${label} has unsupported key ${key}`);
    }
  }
}

export function pickFirst(object, keys) {
  if (!object || typeof object !== "object") {
    return undefined;
  }
  return keys.find((key) => object[key] !== undefined);
}

export function validateCommandPreviews(actions) {
  const previews = asArray(actions?.command_previews);
  for (const preview of previews) {
    if (!preview || typeof preview !== "object" || Array.isArray(preview)) {
      throw new Error("dashboard command preview must be an object");
    }
    if (displayText(preview.execution_mode, "") !== "preview_only") {
      throw new Error("dashboard command preview execution mode must be preview_only");
    }
    if (preview.non_executable !== true) {
      throw new Error("dashboard command preview must be non-executable");
    }
    if (!RISK_LEVELS.has(displayText(preview.risk_level, ""))) {
      throw new Error("dashboard command preview risk level is invalid");
    }
    if (typeof preview.requires_approval !== "boolean") {
      throw new Error("dashboard command preview approval flag is invalid");
    }
  }
}

function validateIdentity(data) {
  if (!displayText(data.snapshot_id, "").startsWith(`${displayText(data.generated_at, "")}-`)) {
    throw new Error("dashboard snapshot_id is invalid");
  }
  if (!/^[a-f0-9]{64}$/.test(displayText(data.content_hash, ""))) {
    throw new Error("dashboard content_hash is invalid");
  }
  if (!displayText(data.snapshot_id, "").endsWith(displayText(data.content_hash, "").slice(0, 12))) {
    throw new Error("dashboard snapshot_id and content_hash do not match");
  }
}

function validatePrimaryAction(summary) {
  const primaryAction = asObject(summary.primary_action, "dashboard primary action");
  for (const key of ["title", "description", "target", "expected_result", "source"]) {
    if (!displayText(primaryAction[key], "")) {
      throw new Error(`dashboard primary action is missing ${key}`);
    }
  }
  if (!RISK_LEVELS.has(displayText(primaryAction.risk_level, ""))) {
    throw new Error("dashboard primary action risk level is invalid");
  }
  if (!ALLOWED_STATES.has(displayText(primaryAction.status, ""))) {
    throw new Error("dashboard primary action status is invalid");
  }
}

function validateCategoryMetrics(summary) {
  const metrics = asObject(summary.category_metrics, "dashboard category metrics");
  for (const key of ["overview", "lessons", "workflow", "maintenance", "security"]) {
    const metric = asObject(metrics[key], `dashboard category metric ${key}`);
    for (const field of ["total", "healthy", "warning", "problem", "percent"]) {
      if (!Number.isInteger(metric[field]) || metric[field] < 0) {
        throw new Error(`dashboard category metric ${key}.${field} is invalid`);
      }
    }
    if (metric.percent > 100 || metric.total !== metric.healthy + metric.warning + metric.problem) {
      throw new Error(`dashboard category metric ${key} counts are invalid`);
    }
    if (!displayText(metric.unit, "")) {
      throw new Error(`dashboard category metric ${key}.unit is invalid`);
    }
    if (!ALLOWED_STATES.has(displayText(metric.status, ""))) {
      throw new Error(`dashboard category metric ${key}.status is invalid`);
    }
  }
}

function validateIssues(data) {
  for (const failure of asArray(data.partial_failures)) {
    if (!failure || typeof failure !== "object" || Array.isArray(failure)) {
      throw new Error("dashboard partial failure must be an object");
    }
    if (!PARTIAL_FAILURE_STATES.has(displayText(failure.status, ""))) {
      throw new Error("dashboard partial failure status is invalid");
    }
  }
  for (const followup of asArray(data.summary?.manual_followups)) {
    if (!followup || typeof followup !== "object" || Array.isArray(followup)) {
      throw new Error("dashboard manual follow-up must be an object");
    }
    if (!MANUAL_FOLLOWUP_STATES.has(displayText(followup.status, ""))) {
      throw new Error("dashboard manual follow-up status is invalid");
    }
  }
}

function normalizePartialFailureState(status) {
  const state = displayText(status, "unknown");
  if (state === "failed") {
    return "failed";
  }
  if (state === "blocked") {
    return "blocked";
  }
  return "unknown";
}

function validatePartialFailureScope(data) {
  const blockers = asArray(data.selected_context?.blockers);
  const failures = asArray(data.partial_failures);
  for (const blocker of blockers) {
    const source = displayText(blocker.source, "");
    const failure = failures.find((item) => displayText(item.source, "") === source);
    if (!failure) {
      throw new Error(`dashboard partial failures missing selected-context blocker ${source}`);
    }
    if (displayText(failure.status, "") !== normalizePartialFailureState(blocker.status)) {
      throw new Error(`dashboard partial failure status does not match selected-context blocker ${source}`);
    }
  }
  for (const failure of failures) {
    const source = displayText(failure.source, "");
    if (!blockers.some((blocker) => displayText(blocker.source, "") === source)) {
      throw new Error(`dashboard partial failure is outside selected context: ${source}`);
    }
  }
}

function validateProductAuthority(development) {
  const authority = asObject(development.product_authority, "dashboard product authority");
  if (!ALLOWED_STATES.has(displayText(authority.status, ""))) {
    throw new Error("dashboard product authority status is invalid");
  }
  const repository = asObject(authority.repository, "dashboard product authority repository");
  if (!ALLOWED_STATES.has(displayText(repository.status, ""))) {
    throw new Error("dashboard product authority repository status is invalid");
  }
  if (!["product_operations", "none"].includes(displayText(repository.blocker_scope, ""))) {
    throw new Error("dashboard product authority blocker scope is invalid");
  }
  const manifestSummary = asObject(authority.manifest_summary, "dashboard product manifest summary");
  for (const key of ["required_missing", "optional_missing"]) {
    if (!Array.isArray(manifestSummary[key])) {
      throw new Error(`dashboard product manifest summary ${key} must be an array`);
    }
  }
  const evidenceSummary = asObject(authority.evidence_summary, "dashboard product evidence summary");
  for (const item of asArray(evidenceSummary.items)) {
    if (!item || typeof item !== "object" || Array.isArray(item)) {
      throw new Error("dashboard product evidence item must be an object");
    }
    if (!displayText(item.source_id, "")) {
      throw new Error("dashboard product evidence item source_id is missing");
    }
    if (!ALLOWED_STATES.has(displayText(item.status, ""))) {
      throw new Error("dashboard product evidence item status is invalid");
    }
    if (!["current", "stale", "not_collected", "unknown"].includes(displayText(item.freshness_state, ""))) {
      throw new Error("dashboard product evidence item freshness state is invalid");
    }
    if (!["authoritative", "manual_required", "advisory", "not_collected"].includes(displayText(item.authority, ""))) {
      throw new Error("dashboard product evidence item authority is invalid");
    }
  }
  for (const blocker of asArray(authority.product_operation_blockers)) {
    if (!blocker || typeof blocker !== "object" || Array.isArray(blocker)) {
      throw new Error("dashboard product operation blocker must be an object");
    }
    if (!displayText(blocker.source, "")) {
      throw new Error("dashboard product operation blocker source is missing");
    }
    if (!PRODUCT_OPERATION_BLOCKER_STATES.has(displayText(blocker.status, ""))) {
      throw new Error("dashboard product operation blocker status is invalid");
    }
  }
}

function validateNonNegativeInteger(value, label) {
  if (!Number.isInteger(value) || value < 0) {
    throw new Error(`${label} must be a non-negative integer`);
  }
}

function validateContextObject(contextValue, label) {
  const context = asObject(contextValue, label);
  assertAllowedKeys(
    context,
    new Set([
      "menu_id",
      "workflow_context",
      "target_repository",
      "product_type",
      "current_step_id",
      "current_step_label",
      "current_step_index",
      "current_step_total",
      "updated_at",
      "git_status",
      "ci_status",
      "security_status",
      "evidence_status",
      "next_safe_action",
      "blockers",
    ]),
    label,
  );
  if (!MENU_IDS.has(displayText(context.menu_id, ""))) {
    throw new Error(`${label} menu_id is invalid`);
  }
  if (!WORKFLOW_CONTEXTS.has(displayText(context.workflow_context, ""))) {
    throw new Error(`${label} workflow_context is invalid`);
  }
  const targetRepository = asObject(context.target_repository, `${label} target_repository`);
  assertAllowedKeys(targetRepository, new Set(["name", "path_state"]), `${label} target_repository`);
  if (!displayText(targetRepository.name, "")) {
    throw new Error(`${label} target_repository.name is missing`);
  }
  if (!REPOSITORY_PATH_STATES.has(displayText(targetRepository.path_state, ""))) {
    throw new Error(`${label} target_repository.path_state is invalid`);
  }
  if (!PRODUCT_TYPES.has(displayText(context.product_type, ""))) {
    throw new Error(`${label} product_type is invalid`);
  }
  for (const key of ["current_step_id", "current_step_label", "updated_at"]) {
    if (!displayText(context[key], "")) {
      throw new Error(`${label} ${key} is missing`);
    }
  }
  validateNonNegativeInteger(context.current_step_index, `${label} current_step_index`);
  validateNonNegativeInteger(context.current_step_total, `${label} current_step_total`);
  for (const key of ["git_status", "ci_status", "security_status", "evidence_status"]) {
    if (!ALLOWED_STATES.has(displayText(context[key], ""))) {
      throw new Error(`${label} ${key} is invalid`);
    }
  }
  const nextSafeAction = asObject(context.next_safe_action, `${label} next_safe_action`);
  assertAllowedKeys(nextSafeAction, new Set(["title", "description", "target", "expected_result", "risk_level", "status", "source"]), `${label} next_safe_action`);
  for (const key of ["title", "description", "target", "expected_result", "source"]) {
    if (!displayText(nextSafeAction[key], "")) {
      throw new Error(`${label} next_safe_action.${key} is missing`);
    }
  }
  if (!RISK_LEVELS.has(displayText(nextSafeAction.risk_level, ""))) {
    throw new Error(`${label} next_safe_action.risk_level is invalid`);
  }
  if (!ALLOWED_STATES.has(displayText(nextSafeAction.status, ""))) {
    throw new Error(`${label} next_safe_action.status is invalid`);
  }
  for (const blocker of asArray(context.blockers)) {
    if (!blocker || typeof blocker !== "object" || Array.isArray(blocker)) {
      throw new Error(`${label} blocker must be an object`);
    }
    assertAllowedKeys(blocker, new Set(["source", "status", "reason", "required_command"]), `${label} blocker`);
    for (const key of ["source", "reason", "required_command"]) {
      if (!displayText(blocker[key], "")) {
        throw new Error(`${label} blocker ${key} is missing`);
      }
    }
    if (!PRODUCT_OPERATION_BLOCKER_STATES.has(displayText(blocker.status, ""))) {
      throw new Error(`${label} blocker status is invalid`);
    }
  }
}

function validateSelectedContext(data) {
  validateContextObject(data.selected_context, "dashboard selected context");
  const contextsByMenu = asObject(data.contexts_by_menu, "dashboard contexts_by_menu");
  const available = asArray(data.available_contexts);
  const availableMenuIds = new Set();
  for (const menuId of Object.keys(contextsByMenu)) {
    if (!MENU_IDS.has(menuId) || menuId === "unknown") {
      throw new Error(`dashboard contexts_by_menu has invalid key ${menuId}`);
    }
  }
  for (const context of available) {
    if (!context || typeof context !== "object" || Array.isArray(context)) {
      throw new Error("dashboard available context must be an object");
    }
    assertAllowedKeys(context, new Set(["menu_id", "workflow_context", "target_repository_name", "status"]), "dashboard available context");
    const menuId = displayText(context.menu_id, "");
    availableMenuIds.add(menuId);
    if (!MENU_IDS.has(menuId) || menuId === "unknown") {
      throw new Error("dashboard available context menu_id is invalid");
    }
    if (!WORKFLOW_CONTEXTS.has(displayText(context.workflow_context, ""))) {
      throw new Error("dashboard available context workflow_context is invalid");
    }
    if (!displayText(context.target_repository_name, "")) {
      throw new Error("dashboard available context target_repository_name is missing");
    }
    if (!ALLOWED_STATES.has(displayText(context.status, ""))) {
      throw new Error("dashboard available context status is invalid");
    }
    if (!contextsByMenu[menuId]) {
      throw new Error(`dashboard contexts_by_menu is missing ${menuId}`);
    }
    validateContextObject(contextsByMenu[menuId], `dashboard contexts_by_menu.${menuId}`);
    if (displayText(contextsByMenu[menuId].menu_id, "") !== menuId) {
      throw new Error(`dashboard contexts_by_menu.${menuId} menu_id must match its key`);
    }
  }
  for (const menuId of Object.keys(contextsByMenu)) {
    if (!availableMenuIds.has(menuId)) {
      throw new Error(`dashboard contexts_by_menu has no available_contexts entry for ${menuId}`);
    }
  }
  const selectedMenuId = displayText(data.selected_context.menu_id, "");
  if (!contextsByMenu[selectedMenuId]) {
    throw new Error("dashboard selected context has no contexts_by_menu entry");
  }
  if (stableStringify(data.selected_context) !== stableStringify(contextsByMenu[selectedMenuId])) {
    throw new Error("dashboard selected context must match contexts_by_menu selected entry");
  }
}

function validateOperationRows(development) {
  for (const row of asArray(development.git_operations)) {
    if (!row || typeof row !== "object" || Array.isArray(row)) {
      throw new Error("dashboard Git operation row must be an object");
    }
    for (const key of ["id", "label", "mode", "detail"]) {
      if (!displayText(row[key], "")) {
        throw new Error(`dashboard Git operation row ${key} is missing`);
      }
    }
    if (!ALLOWED_STATES.has(displayText(row.status, ""))) {
      throw new Error("dashboard Git operation row status is invalid");
    }
  }
}

function validateDocuments(data) {
  if (data.documents === undefined || data.documents === null) {
    return;
  }
  const documents = asObject(data.documents, "dashboard documents");
  assertAllowedKeys(documents, new Set(["status", "groups", "catalog", "related_commands", "brief_cards", "next_actions"]), "dashboard documents");
  if (documents.status !== undefined && !ALLOWED_STATES.has(displayText(documents.status, ""))) {
    throw new Error("dashboard documents status is invalid");
  }
  const groupIds = new Set();
  for (const group of asArray(documents.groups)) {
    if (!group || typeof group !== "object" || Array.isArray(group)) {
      throw new Error("dashboard document group must be an object");
    }
    assertAllowedKeys(group, new Set(["id", "label_key", "description_key", "order"]), "dashboard document group");
    for (const key of ["id", "label_key", "description_key"]) {
      if (!displayText(group[key], "")) {
        throw new Error(`dashboard document group ${key} is missing`);
      }
    }
    if (!Number.isInteger(group.order) || group.order <= 0) {
      throw new Error("dashboard document group order is invalid");
    }
    const groupId = displayText(group.id, "");
    if (groupIds.has(groupId)) {
      throw new Error("dashboard document group id is duplicated");
    }
    groupIds.add(groupId);
  }
  const catalogIds = new Set();
  for (const item of asArray(documents.catalog)) {
    if (!item || typeof item !== "object" || Array.isArray(item)) {
      throw new Error("dashboard document catalog item must be an object");
    }
    assertAllowedKeys(item, new Set(["id", "group_id", "role_id", "path", "status", "status_source", "audience", "order", "related_page"]), "dashboard document catalog item");
    for (const key of ["id", "group_id", "role_id", "path", "status_source"]) {
      if (!displayText(item[key], "")) {
        throw new Error(`dashboard document catalog item ${key} is missing`);
      }
    }
    if (groupIds.size && !groupIds.has(displayText(item.group_id, ""))) {
      throw new Error("dashboard document catalog item references an unknown group");
    }
    const itemId = displayText(item.id, "");
    if (catalogIds.has(itemId)) {
      throw new Error("dashboard document catalog item id is duplicated");
    }
    catalogIds.add(itemId);
    if (!safeScopedRelativePath(item.path)) {
      throw new Error("dashboard document catalog item path must be a safe relative path");
    }
    if (!ALLOWED_STATES.has(displayText(item.status, ""))) {
      throw new Error("dashboard document catalog item status is invalid");
    }
    if (!DOCUMENT_AUDIENCES.has(displayText(item.audience, ""))) {
      throw new Error("dashboard document catalog item audience is invalid");
    }
    if (!Number.isInteger(item.order) || item.order <= 0) {
      throw new Error("dashboard document catalog item order is invalid");
    }
    if (!DOCUMENT_RELATED_PAGES.has(displayText(item.related_page, ""))) {
      throw new Error("dashboard document catalog item related_page is invalid");
    }
  }
  const commandIds = new Set();
  for (const command of asArray(documents.related_commands)) {
    if (!command || typeof command !== "object" || Array.isArray(command)) {
      throw new Error("dashboard document related command must be an object");
    }
    assertAllowedKeys(command, new Set(["id", "label_key", "description_key", "command", "order"]), "dashboard document related command");
    for (const key of ["id", "label_key", "description_key", "command"]) {
      if (!displayText(command[key], "")) {
        throw new Error(`dashboard document related command ${key} is missing`);
      }
    }
    const commandId = displayText(command.id, "");
    if (commandIds.has(commandId)) {
      throw new Error("dashboard document related command id is duplicated");
    }
    commandIds.add(commandId);
    if (!safeDisplayCommand(command.command)) {
      throw new Error("dashboard document related command is invalid");
    }
    if (!Number.isInteger(command.order) || command.order <= 0) {
      throw new Error("dashboard document related command order is invalid");
    }
  }
  const briefIds = new Set();
  for (const card of asArray(documents.brief_cards)) {
    if (!card || typeof card !== "object" || Array.isArray(card)) {
      throw new Error("dashboard document brief card must be an object");
    }
    assertAllowedKeys(card, new Set(["id", "source_label_key", "title", "title_key", "detail", "detail_key", "summary", "summary_key", "action", "action_key", "status", "metric_label_key", "metric_value", "source_paths", "source_hash", "stored_source_hash", "brief_updated_at", "freshness_state", "related_page", "order"]), "dashboard document brief card");
    for (const key of ["id", "source_label_key", "title_key", "detail_key", "summary_key", "action_key", "metric_label_key", "metric_value"]) {
      if (!displayText(card[key], "")) {
        throw new Error(`dashboard document brief card ${key} is missing`);
      }
    }
    for (const key of ["title", "detail", "summary", "action"]) {
      validateLocalizedTextObject(card[key], `dashboard document brief card ${key}`);
    }
    const briefId = displayText(card.id, "");
    if (briefIds.has(briefId)) {
      throw new Error("dashboard document brief card id is duplicated");
    }
    briefIds.add(briefId);
    if (!ALLOWED_STATES.has(displayText(card.status, ""))) {
      throw new Error("dashboard document brief card status is invalid");
    }
    if (!ALLOWED_STATES.has(displayText(card.freshness_state, "unknown"))) {
      throw new Error("dashboard document brief card freshness_state is invalid");
    }
    for (const sourcePath of asArray(card.source_paths)) {
      if (!safeScopedRelativePath(sourcePath)) {
        throw new Error("dashboard document brief card source_paths is invalid");
      }
    }
    if (!DOCUMENT_RELATED_PAGES.has(displayText(card.related_page, ""))) {
      throw new Error("dashboard document brief card related_page is invalid");
    }
    if (!Number.isInteger(card.order) || card.order <= 0) {
      throw new Error("dashboard document brief card order is invalid");
    }
  }
  const actionIds = new Set();
  for (const action of asArray(documents.next_actions)) {
    if (!action || typeof action !== "object" || Array.isArray(action)) {
      throw new Error("dashboard document next action must be an object");
    }
    assertAllowedKeys(action, new Set(["id", "title_key", "detail_key", "status", "related_page", "order"]), "dashboard document next action");
    for (const key of ["id", "title_key", "detail_key"]) {
      if (!displayText(action[key], "")) {
        throw new Error(`dashboard document next action ${key} is missing`);
      }
    }
    const actionId = displayText(action.id, "");
    if (actionIds.has(actionId)) {
      throw new Error("dashboard document next action id is duplicated");
    }
    actionIds.add(actionId);
    if (!ALLOWED_STATES.has(displayText(action.status, ""))) {
      throw new Error("dashboard document next action status is invalid");
    }
    if (!DOCUMENT_RELATED_PAGES.has(displayText(action.related_page, ""))) {
      throw new Error("dashboard document next action related_page is invalid");
    }
    if (!Number.isInteger(action.order) || action.order <= 0) {
      throw new Error("dashboard document next action order is invalid");
    }
  }
}

function validateMaintenanceEvidence(maintenance) {
  for (const row of asArray(maintenance.evidence_rows)) {
    if (!row || typeof row !== "object" || Array.isArray(row)) {
      throw new Error("dashboard maintenance evidence row must be an object");
    }
    for (const key of ["id", "label", "importance", "reference"]) {
      if (!displayText(row[key], "")) {
        throw new Error(`dashboard maintenance evidence row ${key} is missing`);
      }
    }
    if (!ALLOWED_STATES.has(displayText(row.status, ""))) {
      throw new Error("dashboard maintenance evidence row status is invalid");
    }
  }
}

function validateSecurityRows(security) {
  for (const collectionName of ["approvals", "dangerous_operations"]) {
    for (const row of asArray(security[collectionName])) {
      if (!row || typeof row !== "object" || Array.isArray(row)) {
        throw new Error(`dashboard security ${collectionName} row must be an object`);
      }
      for (const key of ["id", "label", "detail", "last_checked"]) {
        if (!displayText(row[key], "")) {
          throw new Error(`dashboard security ${collectionName} row ${key} is missing`);
        }
      }
      if (!ALLOWED_STATES.has(displayText(row.status, ""))) {
        throw new Error(`dashboard security ${collectionName} row status is invalid`);
      }
    }
  }
}

function validateCommandPreviewGroups(actions) {
  for (const group of asArray(actions?.command_preview_groups)) {
    if (!group || typeof group !== "object" || Array.isArray(group)) {
      throw new Error("dashboard command preview group must be an object");
    }
    for (const key of ["id", "label"]) {
      if (!displayText(group[key], "")) {
        throw new Error(`dashboard command preview group ${key} is missing`);
      }
    }
    if (!RISK_LEVELS.has(displayText(group.risk_level, ""))) {
      throw new Error("dashboard command preview group risk level is invalid");
    }
    validateNonNegativeInteger(group.preview_count, "dashboard command preview group preview_count");
  }
}

export function validateDashboardData(data) {
  if (!data || typeof data !== "object" || Array.isArray(data)) {
    throw new Error("dashboard data must be an object");
  }
  if (!/^[0-9]+\.[0-9]+\.[0-9]+$/.test(displayText(data.schema_version, ""))) {
    throw new Error("dashboard data schema version is invalid");
  }
  validateIdentity(data);
  const sourceCommands = asArray(data.source_commands).map((command) => displayText(command, ""));
  if (!sourceCommands.includes("tools/dashboard-data")) {
    throw new Error("dashboard data source command is missing");
  }
  if (sourceCommands.some((command) => /^(\.\/)?tools\/dashboard(\s|$)/.test(command))) {
    throw new Error("dashboard prose is not an allowed data source");
  }
  for (const key of ["summary", "lessons", "development", "maintenance", "git_workflow", "security", "actions"]) {
    if (!data[key] || typeof data[key] !== "object" || Array.isArray(data[key])) {
      throw new Error(`dashboard data section is missing: ${key}`);
    }
  }
  if (!["learning", "development", "maintenance", "unknown"].includes(displayText(data.summary.mode, "unknown"))) {
    throw new Error("dashboard mode is invalid");
  }
  validatePrimaryAction(data.summary);
  validateCategoryMetrics(data.summary);
  validateIssues(data);
  validateSelectedContext(data);
  validatePartialFailureScope(data);
  validateOperationRows(data.development);
  validateProductAuthority(data.development);
  validateDocuments(data);
  validateMaintenanceEvidence(data.maintenance);
  validateSecurityRows(data.security);
  validateCommandPreviews(data.actions);
  validateCommandPreviewGroups(data.actions);
  return data;
}

export async function fetchDashboardDataSnapshot() {
  const response = await fetch("./dashboard-data.json", {
    cache: "no-store",
    credentials: "same-origin",
    method: "GET",
  });
  if (!response.ok) {
    throw new Error(`dashboard data request failed with ${response.status}`);
  }
  const raw = await response.text();
  const data = validateDashboardData(JSON.parse(raw));
  return {
    data,
    signature: `${data.snapshot_id}:${data.content_hash}`,
  };
}

export async function fetchDashboardData() {
  const snapshot = await fetchDashboardDataSnapshot();
  return snapshot.data;
}
