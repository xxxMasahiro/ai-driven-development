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
]);

export const RISK_LEVELS = new Set(["low", "medium", "high", "critical"]);

const SECRET_PATTERN =
  /(SECRET|TOKEN|API_KEY|PASSWORD|PRIVATE_KEY)\s*[:=]\s*[^\s#]{8,}|gh[pousr]_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY/i;

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

export function objectEntries(value) {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    return [];
  }
  return Object.entries(value);
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

export function validateDashboardData(data) {
  if (!data || typeof data !== "object" || Array.isArray(data)) {
    throw new Error("dashboard data must be an object");
  }
  if (!/^[0-9]+\.[0-9]+\.[0-9]+$/.test(displayText(data.schema_version, ""))) {
    throw new Error("dashboard data schema version is invalid");
  }
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
  validateCommandPreviews(data.actions);
  return data;
}

export async function fetchDashboardData() {
  const response = await fetch("./dashboard-data.json", {
    cache: "no-store",
    credentials: "same-origin",
  });
  if (!response.ok) {
    throw new Error(`dashboard data request failed with ${response.status}`);
  }
  return validateDashboardData(await response.json());
}
