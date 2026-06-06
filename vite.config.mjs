import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

const repoRoot = path.dirname(fileURLToPath(import.meta.url));
const appRoot = path.join(repoRoot, "dashboard-control-center");
const runtimeRoot = path.join(repoRoot, ".dashboard-control-center");

function realpathInside(child, parent) {
  const realChild = fs.realpathSync.native(child);
  const realParent = fs.realpathSync.native(parent);
  return realChild === realParent || realChild.startsWith(`${realParent}${path.sep}`);
}

export function dashboardDataFile() {
  const configuredFile = process.env.DASHBOARD_CONTROL_CENTER_DATA_FILE;
  if (!configuredFile) {
    return null;
  }
  const resolvedFile = path.resolve(repoRoot, configuredFile);
  try {
    if (!fs.statSync(resolvedFile).isFile()) {
      return null;
    }
    if (!fs.existsSync(runtimeRoot) || !realpathInside(resolvedFile, runtimeRoot)) {
      return null;
    }
  } catch {
    return null;
  }
  return resolvedFile;
}

export function validateDashboardData(body) {
  let data;
  try {
    data = JSON.parse(body);
  } catch {
    return false;
  }
  if (!data || typeof data !== "object" || !/^[0-9]+\.[0-9]+\.[0-9]+$/.test(String(data.schema_version || ""))) {
    return false;
  }
  if (!Array.isArray(data.source_commands) || !data.source_commands.includes("tools/dashboard-data")) {
    return false;
  }
  if (data.source_commands.some((command) => /^(\.\/)?tools\/dashboard(\s|$)/.test(String(command)))) {
    return false;
  }
  if (!data.summary || typeof data.summary !== "object" || !data.lessons || typeof data.lessons !== "object") {
    return false;
  }
  const previews = Array.isArray(data.actions?.command_previews) ? data.actions.command_previews : [];
  for (const preview of previews) {
    if (
      !preview ||
      typeof preview !== "object" ||
      preview.execution_mode !== "preview_only" ||
      preview.non_executable !== true ||
      !["low", "medium", "high", "critical"].includes(String(preview.risk_level || "")) ||
      typeof preview.requires_approval !== "boolean"
    ) {
      return false;
    }
  }
  return true;
}

function dashboardDataFilePlugin() {
  return {
    name: "dashboard-control-center-data-file",
    configureServer(server) {
      server.middlewares.use("/dashboard-data.json", (request, response, next) => {
        const dataFile = dashboardDataFile();
        if (!dataFile) {
          response.statusCode = 503;
          response.setHeader("content-type", "application/json; charset=utf-8");
          response.end(JSON.stringify({ error: "dashboard data is unavailable" }));
          return;
        }
        if (request.method !== "GET" && request.method !== "HEAD") {
          response.statusCode = 405;
          response.end("method not allowed");
          return;
        }
        fs.readFile(dataFile, "utf8", (error, body) => {
          if (error) {
            response.statusCode = 503;
            response.setHeader("content-type", "application/json; charset=utf-8");
            response.end(JSON.stringify({ error: "dashboard data is unavailable" }));
            return;
          }
          if (!validateDashboardData(body)) {
            response.statusCode = 422;
            response.setHeader("content-type", "application/json; charset=utf-8");
            response.end(JSON.stringify({ error: "dashboard data failed validation" }));
            return;
          }
          response.statusCode = 200;
          response.setHeader("cache-control", "no-store");
          response.setHeader("content-type", "application/json; charset=utf-8");
          response.end(request.method === "HEAD" ? "" : body);
        });
      });
    },
  };
}

export default defineConfig({
  root: appRoot,
  base: "./",
  plugins: [react(), dashboardDataFilePlugin()],
  build: {
    outDir: path.join(repoRoot, "dist/dashboard-control-center"),
    emptyOutDir: true,
  },
  server: {
    host: "127.0.0.1",
  },
});
