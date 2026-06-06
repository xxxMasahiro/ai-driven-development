#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

if [[ ! -x "$ROOT/node_modules/.bin/vite" || ! -x "$ROOT/node_modules/.bin/playwright" ]]; then
  printf 'Dashboard control-center dependencies are not installed.\n' >&2
  printf 'Run npm install before running this check.\n' >&2
  exit 1
fi

SNAPSHOT="$TMP_DIR/dashboard-data.json"
DASHBOARD_DATA_GENERATED_AT="2026-06-05T00:00:00Z" "$ROOT/tools/dashboard-control-center" snapshot --output "$SNAPSHOT" >/dev/null

node - "$SNAPSHOT" <<'NODE'
const fs = require("fs");
const file = process.argv[2];
const data = JSON.parse(fs.readFileSync(file, "utf8"));

function fail(message) {
  console.error(message);
  process.exit(1);
}

if (data.generated_at !== "2026-06-05T00:00:00Z") {
  fail("dashboard-control-center snapshot did not preserve dashboard-data output");
}
if (!Array.isArray(data.source_commands) || !data.source_commands.includes("tools/dashboard-data")) {
  fail("dashboard-control-center snapshot must use tools/dashboard-data as the source command");
}
if (data.source_commands.some((command) => /^(\.\/)?tools\/dashboard(\s|$)/.test(command))) {
  fail("dashboard-control-center snapshot must not claim tools/dashboard prose as a source command");
}
if (!data.actions?.command_previews?.every((preview) => preview.execution_mode === "preview_only" && preview.non_executable === true)) {
  fail("dashboard-control-center command previews must remain preview-only and non-executable");
}
NODE

(cd "$ROOT" && node --input-type=module - "$SNAPSHOT" "$TMP_DIR/not-dashboard.json" "$TMP_DIR/unsafe-preview.json") <<'NODE'
import fs from "node:fs";
import { validateDashboardData } from "./vite.config.mjs";

const validFile = process.argv[2];
const invalidFile = process.argv[3];
const unsafePreviewFile = process.argv[4];
const validBody = fs.readFileSync(validFile, "utf8");
fs.writeFileSync(invalidFile, JSON.stringify({
  schema_version: "0.1.0",
  source_commands: ["tools/dashboard all"],
  summary: {},
  lessons: {},
  development: {},
  maintenance: {},
  git_workflow: {},
  security: {},
  actions: {},
}));
const unsafePreview = JSON.parse(validBody);
unsafePreview.actions.command_previews[0].execution_mode = "manual_after_approval";
fs.writeFileSync(unsafePreviewFile, JSON.stringify(unsafePreview));

function fail(message) {
  console.error(message);
  process.exit(1);
}

if (!validateDashboardData(validBody)) {
  fail("vite middleware rejected dashboard-data output");
}
if (validateDashboardData(fs.readFileSync(invalidFile, "utf8"))) {
  fail("vite middleware accepted tools/dashboard prose as a data source");
}
if (validateDashboardData(fs.readFileSync(unsafePreviewFile, "utf8"))) {
  fail("vite middleware accepted executable command preview data");
}
NODE

if grep -Eq 'npm run dashboard:dev|--port <port>|Data snapshot:' "$ROOT/tools/dashboard-control-center"; then
  printf 'dashboard-control-center ordinary entry leaks npm, port selection, or data snapshot details\n' >&2
  exit 1
fi

(cd "$ROOT" && npm run dashboard:build >/dev/null)
(cd "$ROOT" && PLAYWRIGHT_WORKERS=1 npm run test:dashboard-control-center)

printf 'Dashboard control-center tests passed.\n'
