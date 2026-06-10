#!/usr/bin/env bash

if [[ -z "${LESSON_ROOT:-}" ]]; then
  PRODUCT_REPOSITORY_AUTHORITY_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # shellcheck source=lesson_common.sh
  source "$PRODUCT_REPOSITORY_AUTHORITY_LIB_DIR/lesson_common.sh"
fi

product_repository_authority_structure_file() {
  printf '%s\n' "${PRODUCT_REPOSITORY_STRUCTURE_FILE:-$LESSON_ROOT/docs/workflow/PRODUCT_REPOSITORY_STRUCTURE.tsv}"
}

product_repository_authority_forbidden_root_paths_file() {
  printf '%s\n' "${PRODUCT_REPOSITORY_FORBIDDEN_ROOT_PATHS_FILE:-$LESSON_ROOT/docs/workflow/PRODUCT_REPOSITORY_FORBIDDEN_ROOT_PATHS.tsv}"
}

product_repository_authority_evidence_schema_file() {
  printf '%s\n' "${PRODUCT_GATE_EVIDENCE_SCHEMA_FILE:-$LESSON_ROOT/docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv}"
}

product_repository_authority_trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

product_repository_authority_json_escape() {
  local value="$1"
  value="${value//$'\r'/ }"
  value="${value//$'\n'/ }"
  value="${value//$'\t'/ }"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  printf '%s' "$value"
}

product_repository_authority_json_string() {
  printf '"%s"' "$(product_repository_authority_json_escape "$1")"
}

product_repository_authority_json_array() {
  local first=1
  local item
  printf '['
  for item in "$@"; do
    if [[ "$first" -eq 0 ]]; then
      printf ','
    fi
    first=0
    product_repository_authority_json_string "$item"
  done
  printf ']'
}

product_repository_authority_json_raw_array() {
  local first=1
  local item
  printf '['
  for item in "$@"; do
    if [[ "$first" -eq 0 ]]; then
      printf ','
    fi
    first=0
    printf '%s' "$item"
  done
  printf ']'
}

product_repository_authority_json_field() {
  local json="$1"
  local key="$2"
  printf '%s\n' "$json" | sed -nE "s/.*\"$key\":\"([^\"]*)\".*/\\1/p" | head -n 1
}

product_repository_authority_json_bool_field() {
  local json="$1"
  local key="$2"
  printf '%s\n' "$json" | sed -nE "s/.*\"$key\":(true|false).*/\\1/p" | head -n 1
}

product_repository_authority_tsv_field() {
  local row="$1"
  local field_number="$2"
  printf '%s\n' "$row" | awk -F '\t' -v field_number="$field_number" '{ print $field_number; exit }'
}

product_repository_authority_safe_repo_label() {
  local repo="$1"
  if [[ -z "$repo" ]]; then
    printf 'configured product repository'
    return
  fi
  printf '[external-product-repository]/%s' "$(basename "$repo")"
}

product_repository_authority_list_has() {
  local list="$1"
  local expected="$2"
  local item expected_item
  IFS='|' read -r -a items <<<"$list"
  for item in "${items[@]}"; do
    item="$(product_repository_authority_trim "$item")"
    if [[ "$item" == "all" ]]; then
      return 0
    fi
    IFS='|' read -r -a expected_items <<<"$expected"
    for expected_item in "${expected_items[@]}"; do
      expected_item="$(product_repository_authority_trim "$expected_item")"
      if [[ -n "$expected_item" && "$item" == "$expected_item" ]]; then
        return 0
      fi
    done
  done
  return 1
}

product_repository_authority_required_for_context() {
  local required_mode="$1"
  local contexts="$2"
  local product_types="$3"
  local context="$4"
  local product_type="$5"

  case "$required_mode" in
    required) return 0 ;;
    optional) return 1 ;;
    contextual)
      product_repository_authority_list_has "$contexts" "$context" || return 1
      product_repository_authority_list_has "$product_types" "$product_type" || return 1
      return 0
      ;;
  esac
  return 1
}

product_repository_authority_structure_rows() {
  local file
  file="$(product_repository_authority_structure_file)"
  awk -F '\t' '
    /^[[:space:]]*$/ { next }
    $1 ~ /^#/ { next }
    {
      if (NF != 11) {
        printf "invalid product repository structure row: %s\n", $0 > "/dev/stderr"
        invalid = 1
        next
      }
      print
    }
    END { exit invalid ? 1 : 0 }
  ' "$file"
}

product_repository_authority_forbidden_root_path_rows() {
  local file
  file="$(product_repository_authority_forbidden_root_paths_file)"
  awk -F '\t' '
    /^[[:space:]]*$/ { next }
    $1 ~ /^#/ { next }
    {
      if (NF != 4) {
        printf "invalid product forbidden root path row: %s\n", $0 > "/dev/stderr"
        invalid = 1
        next
      }
      print
    }
    END { exit invalid ? 1 : 0 }
  ' "$file"
}

product_repository_authority_validate_policy_files() {
  local structure_file forbidden_root_paths_file evidence_schema_file
  structure_file="$(product_repository_authority_structure_file)"
  forbidden_root_paths_file="$(product_repository_authority_forbidden_root_paths_file)"
  evidence_schema_file="$(product_repository_authority_evidence_schema_file)"
  [[ -f "$structure_file" ]] || { printf 'missing product repository structure policy: %s\n' "$structure_file" >&2; return 1; }
  [[ -f "$forbidden_root_paths_file" ]] || { printf 'missing product forbidden root path policy: %s\n' "$forbidden_root_paths_file" >&2; return 1; }
  [[ -f "$evidence_schema_file" ]] || { printf 'missing product gate evidence schema: %s\n' "$evidence_schema_file" >&2; return 1; }
  product_repository_authority_structure_rows >/dev/null || return 1
  product_repository_authority_forbidden_root_path_rows >/dev/null || return 1
  awk -F '\t' '
    /^[[:space:]]*$/ { next }
    $1 ~ /^#/ { next }
    NF != 6 {
      printf "invalid product gate evidence schema row: %s\n", $0 > "/dev/stderr"
      invalid = 1
      next
    }
    END { exit invalid ? 1 : 0 }
  ' "$evidence_schema_file"
}

product_repository_authority_tsv_valid() {
  local file="$1"
  [[ -f "$file" && -s "$file" ]] || return 1
  awk -F '\t' '
    /^[[:space:]]*$/ { next }
    {
      if (!seen) {
        columns = NF
        seen = 1
        next
      }
      if (NF != columns) {
        invalid = 1
      }
    }
    END { exit (seen && !invalid) ? 0 : 1 }
  ' "$file"
}

product_repository_authority_product_profile_valid() {
  local file="$1"
  [[ -f "$file" && -s "$file" ]] || return 1
  PRODUCT_PROFILE_FILE="$file" node <<'NODE' >/dev/null
const fs = require("node:fs");

const file = process.env.PRODUCT_PROFILE_FILE || "";

function fail() {
  process.exit(1);
}

function isObject(value) {
  return value && typeof value === "object" && !Array.isArray(value);
}

function hasControl(value) {
  return /[\u0000-\u0008\u000b\u000c\u000e-\u001f]/.test(String(value ?? ""));
}

function safeText(value, max = 240) {
  if (typeof value !== "string" || hasControl(value)) return "";
  return value.replace(/\s+/g, " ").trim().slice(0, max);
}

function safeRelativePath(value) {
  if (typeof value !== "string" || !value || hasControl(value)) return false;
  if (value.startsWith("/") || value.includes("\\") || value.includes("\0")) return false;
  return !value.split("/").some((part) => part === ".." || part === "");
}

let data;
try {
  data = JSON.parse(fs.readFileSync(file, "utf8"));
} catch {
  fail();
}

if (!isObject(data)) fail();
if (safeText(data.schema_version, 40) !== "1.0.0") fail();
if (data.profile_kind && safeText(data.profile_kind, 80) !== "product_display_profile") fail();
if (!isObject(data.display_name)) fail();

const nameJa = safeText(data.display_name.ja);
const nameEn = safeText(data.display_name.en);
if (!nameJa && !nameEn) fail();

if (data.description !== undefined) {
  if (!isObject(data.description)) fail();
  if (data.description.ja !== undefined && hasControl(data.description.ja)) fail();
  if (data.description.en !== undefined && hasControl(data.description.en)) fail();
}

if (data.source_documents !== undefined) {
  if (!Array.isArray(data.source_documents)) fail();
  for (const item of data.source_documents) {
    if (!safeRelativePath(item)) fail();
  }
}

process.exit(0);
NODE
}

product_repository_authority_path_valid() {
  local repo="$1"
  local relpath="$2"
  local validation_rule="$3"
  local path="$repo/$relpath"

  case "$validation_rule" in
    file_exists) [[ -f "$path" ]] ;;
    file_nonempty) [[ -s "$path" ]] ;;
    path_exists) [[ -e "$path" ]] ;;
    tsv_valid) product_repository_authority_tsv_valid "$path" ;;
    product_profile_valid) product_repository_authority_product_profile_valid "$path" ;;
    *) return 1 ;;
  esac
}

product_repository_authority_forbidden_root_duplicate_path() {
  local canonical_path="$1"
  local row root_path mapped_path source_id requirement
  while IFS=$'\t' read -r root_path mapped_path source_id requirement; do
    if [[ "$mapped_path" == "$canonical_path" ]]; then
      printf '%s' "$root_path"
      return 0
    fi
  done < <(product_repository_authority_forbidden_root_path_rows)
  return 1
}

product_repository_authority_path_safe_relative() {
  local relpath="$1"
  [[ -n "$relpath" ]] || return 1
  case "$relpath" in
    /*|../*|*/../*|*/..|*\\*) return 1 ;;
  esac
  return 0
}

product_repository_authority_manifest_rows() {
  local manifest="$1"
  awk -F '\t' '
    /^[[:space:]]*$/ { next }
    $1 ~ /^#/ { next }
    {
      if (NF != 9) {
        printf "invalid product manifest row: %s\n", $0 > "/dev/stderr"
        invalid = 1
        next
      }
      print
    }
    END { exit invalid ? 1 : 0 }
  ' "$manifest"
}

product_repository_authority_manifest_rows_with_columns() {
  local manifest="$1"
  local expected_columns="$2"
  local label="$3"
  [[ -s "$manifest" ]] || return 0
  awk -F '\t' -v expected_columns="$expected_columns" -v label="$label" '
    /^[[:space:]]*$/ { next }
    $1 ~ /^#/ { next }
    {
      if (NF != expected_columns) {
        printf "invalid %s row: %s\n", label, $0 > "/dev/stderr"
        invalid = 1
        next
      }
      print
    }
    END { exit invalid ? 1 : 0 }
  ' "$manifest"
}

product_repository_authority_product_manifest_semantic_blockers() {
  local repo="$1"
  local context="$2"
  local product_type="$3"
  local manifest="$repo/ops/PRODUCT_MANIFEST.tsv"
  local row authority_id required_mode contexts product_types path path_role validation_rule dashboard_group description
  local entrypoint_ready=0
  local source_ready=0
  local test_ready=0

  [[ -s "$manifest" ]] || return 0
  if ! product_repository_authority_manifest_rows "$manifest" >/dev/null; then
    printf 'product_ops.product_manifest\tblocked\tops/PRODUCT_MANIFEST.tsv must use the declared 9-column TSV format.\t./tools/product-scaffold-check check\n'
    return 0
  fi

  while IFS= read -r row; do
    authority_id="$(product_repository_authority_tsv_field "$row" 1)"
    required_mode="$(product_repository_authority_tsv_field "$row" 2)"
    contexts="$(product_repository_authority_tsv_field "$row" 3)"
    product_types="$(product_repository_authority_tsv_field "$row" 4)"
    path="$(product_repository_authority_tsv_field "$row" 5)"
    path_role="$(product_repository_authority_tsv_field "$row" 6)"
    validation_rule="$(product_repository_authority_tsv_field "$row" 7)"
    dashboard_group="$(product_repository_authority_tsv_field "$row" 8)"
    description="$(product_repository_authority_tsv_field "$row" 9)"

    case "$path_role" in
      entrypoint|source|test|doc|workflow|ops|ci|security|integration|custom) ;;
      *)
        printf '%s\tblocked\tProduct manifest row has unsupported path_role: %s\t./tools/product-scaffold-check check\n' "$authority_id" "$path_role"
        continue
        ;;
    esac
    case "$validation_rule" in
      file_exists|file_nonempty|path_exists|tsv_valid) ;;
      *)
        printf '%s\tblocked\tProduct manifest row has unsupported validation_rule: %s\t./tools/product-scaffold-check check\n' "$authority_id" "$validation_rule"
        continue
        ;;
    esac
    if ! product_repository_authority_path_safe_relative "$path"; then
      printf '%s\tblocked\tProduct manifest row must use a safe relative path.\t./tools/product-scaffold-check check\n' "$authority_id"
      continue
    fi
    if [[ -z "$dashboard_group" || -z "$description" ]]; then
      printf '%s\tblocked\tProduct manifest row must include dashboard_group and description.\t./tools/product-scaffold-check check\n' "$authority_id"
      continue
    fi

    product_repository_authority_required_for_context "$required_mode" "$contexts" "$product_types" "$context" "$product_type" || continue
    if ! product_repository_authority_path_valid "$repo" "$path" "$validation_rule"; then
      printf '%s\tblocked\tProduct manifest required path is not valid: %s\t./tools/product-scaffold-check check\n' "$authority_id" "$path"
      continue
    fi
    case "$path_role" in
      entrypoint) entrypoint_ready=$((entrypoint_ready + 1)) ;;
      source) source_ready=$((source_ready + 1)) ;;
      test) test_ready=$((test_ready + 1)) ;;
    esac
  done < <(product_repository_authority_manifest_rows "$manifest")

  [[ "$entrypoint_ready" -eq 1 ]] || printf 'product_ops.product_manifest\tblocked\tProduct manifest must declare exactly one required entrypoint authority.\t./tools/product-scaffold-check check\n'
  [[ "$source_ready" -eq 1 ]] || printf 'product_ops.product_manifest\tblocked\tProduct manifest must declare exactly one required source authority.\t./tools/product-scaffold-check check\n'
  [[ "$test_ready" -eq 1 ]] || printf 'product_ops.product_manifest\tblocked\tProduct manifest must declare exactly one required test authority.\t./tools/product-scaffold-check check\n'
}

product_repository_authority_resolve_structure_path() {
  local repo="$1"
  local validation_rule="$2"
  local canonical_path="$3"
  local legacy_paths="$4"
  local legacy_path
  local root_duplicate_path=""
  local canonical_valid=0
  local legacy_valid=0
  local first_legacy=""

  if [[ "$validation_rule" == file_* ]]; then
    root_duplicate_path="$(product_repository_authority_forbidden_root_duplicate_path "$canonical_path" || true)"
    if [[ -n "$root_duplicate_path" && -e "$repo/$root_duplicate_path" ]]; then
      printf 'blocked\t%s\troot_duplicate\n' "$canonical_path"
      return 0
    fi
  fi

  if product_repository_authority_path_valid "$repo" "$canonical_path" "$validation_rule"; then
    canonical_valid=1
  fi

  if [[ "$legacy_paths" != "none" ]]; then
    IFS=',' read -r -a legacy_items <<<"$legacy_paths"
    for legacy_path in "${legacy_items[@]}"; do
      legacy_path="$(product_repository_authority_trim "$legacy_path")"
      [[ -n "$legacy_path" ]] || continue
      if product_repository_authority_path_valid "$repo" "$legacy_path" "$validation_rule"; then
        legacy_valid=1
        [[ -n "$first_legacy" ]] || first_legacy="$legacy_path"
        if [[ "$validation_rule" == file_* && "$canonical_valid" -eq 1 && -f "$repo/$canonical_path" && -f "$repo/$legacy_path" ]]; then
          if ! cmp -s "$repo/$canonical_path" "$repo/$legacy_path"; then
            printf 'blocked\t%s\tlegacy_conflict\n' "$canonical_path"
            return 0
          fi
        fi
      fi
    done
  fi

  if [[ "$canonical_valid" -eq 1 ]]; then
    printf 'ready\t%s\tcanonical\n' "$canonical_path"
  elif [[ "$legacy_valid" -eq 1 ]]; then
    printf 'ready\t%s\tlegacy\n' "$first_legacy"
  else
    printf 'missing\t%s\tnone\n' "$canonical_path"
  fi
}

product_repository_authority_evidence_index() {
  local repo="$1"
  printf '%s/.git/product-gate-evidence/index.tsv\n' "$repo"
}

product_repository_authority_repository_index_json() {
  local repo="$1"
  local index_file="$repo/ops/REPOSITORY_INDEX.json"
  if [[ ! -f "$index_file" ]]; then
    printf '{"status":"not_run","path":"ops/REPOSITORY_INDEX.json","schema_version":"unknown","root_name":"","source":"external_product_repository","default_expand_depth":0,"excludes":[],"roles":{},"files":[]}'
    return
  fi

  PRODUCT_REPOSITORY_INDEX_FILE="$index_file" node <<'NODE'
const fs = require("node:fs");
const path = require("node:path");

const file = process.env.PRODUCT_REPOSITORY_INDEX_FILE;
const raw = fs.readFileSync(file, "utf8");
const data = JSON.parse(raw);

function fail(message) {
  console.error(message);
  process.exit(1);
}

function safeText(value, fallback = "") {
  const text = String(value ?? fallback)
    .replace(/[\u0000-\u0008\u000b\u000c\u000e-\u001f]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
  return text.slice(0, 240);
}

function safeRelativePath(value) {
  const text = safeText(value);
  if (!text || path.isAbsolute(text) || text.includes("\\") || text.split("/").includes("..")) {
    return "";
  }
  return text;
}

function safeRoleId(value) {
  const text = safeText(value);
  return /^[a-z0-9_.-]+$/.test(text) ? text : "";
}

if (!data || typeof data !== "object" || Array.isArray(data)) {
  fail("repository index must be an object");
}
if (!/^1\.[0-9]+\.[0-9]+$/.test(String(data.schema_version ?? ""))) {
  fail("repository index schema_version must be 1.x.y");
}

const roles = {};
const inputRoles = data.roles && typeof data.roles === "object" && !Array.isArray(data.roles) ? data.roles : {};
for (const [roleId, role] of Object.entries(inputRoles)) {
  const id = safeRoleId(roleId);
  if (!id || !role || typeof role !== "object" || Array.isArray(role)) continue;
  roles[id] = {
    label: safeText(role.label, id),
    description: safeText(role.description, ""),
  };
}

const files = [];
const seen = new Set();
for (const item of Array.isArray(data.files) ? data.files : []) {
  if (!item || typeof item !== "object" || Array.isArray(item)) continue;
  const filePath = safeRelativePath(item.path);
  if (!filePath || seen.has(filePath)) continue;
  const roleIds = Array.isArray(item.role_ids)
    ? item.role_ids.map(safeRoleId).filter((roleId) => roleId && roles[roleId])
    : [];
  files.push({
    path: filePath,
    type: item.type === "directory" ? "directory" : "file",
    tracked: item.tracked !== false,
    description: safeText(item.description, ""),
    role_ids: roleIds.length ? [...new Set(roleIds)] : ["repository_file"].filter((roleId) => roles[roleId]),
  });
  seen.add(filePath);
}

files.sort((left, right) => left.path.localeCompare(right.path));

const summary = {
  directories: files.filter((item) => item.type === "directory").length,
  files: files.filter((item) => item.type === "file").length,
  total: files.length,
};

const excludes = [];
for (const item of Array.isArray(data.excludes) ? data.excludes : []) {
  if (!item || typeof item !== "object" || Array.isArray(item)) continue;
  const pattern = safeText(item.pattern, "");
  if (!pattern) continue;
  excludes.push({
    pattern,
    reason: safeText(item.reason, ""),
  });
}

const defaultExpandDepth = Number.isInteger(data.default_expand_depth)
  ? Math.max(0, Math.min(3, data.default_expand_depth))
  : 0;

process.stdout.write(JSON.stringify({
  status: "ready",
  path: "ops/REPOSITORY_INDEX.json",
  schema_version: data.schema_version,
  root_name: safeText(data.root_name, ""),
  source: safeText(data.source, "external_product_repository"),
  default_expand_depth: defaultExpandDepth,
  summary,
  excludes,
  roles,
  files,
}));
NODE
}

product_repository_authority_product_summary_json() {
  local repo="$1"
  PRODUCT_REPOSITORY_ROOT="$repo" node <<'NODE'
const fs = require("node:fs");
const path = require("node:path");

const repo = process.env.PRODUCT_REPOSITORY_ROOT || "";
const profileRelativePath = "ops/PRODUCT_PROFILE.json";
const profilePath = path.join(repo, profileRelativePath);

function safeText(value, fallback = "") {
  const text = String(value ?? fallback)
    .replace(/[\u0000-\u0008\u000b\u000c\u000e-\u001f]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
  return text.slice(0, 240);
}

function isObject(value) {
  return value && typeof value === "object" && !Array.isArray(value);
}

function safeRelativePath(value) {
  const text = safeText(value, "");
  if (!text || text.startsWith("/") || text.includes("\\") || text.includes("\0")) return "";
  if (text.split("/").some((part) => part === ".." || part === "")) return "";
  return text;
}

if (!fs.existsSync(profilePath)) {
  process.stdout.write(JSON.stringify({
    status: "missing",
    name: "",
    display_name: { ja: "", en: "" },
    description: { ja: "", en: "" },
    source_documents: [],
    source_path: profileRelativePath,
    source_field: "",
  }));
  process.exit(0);
}

let profile;
try {
  profile = JSON.parse(fs.readFileSync(profilePath, "utf8"));
} catch {
  process.stdout.write(JSON.stringify({
    status: "failed",
    name: "",
    display_name: { ja: "", en: "" },
    description: { ja: "", en: "" },
    source_documents: [],
    source_path: profileRelativePath,
    source_field: "invalid_json",
  }));
  process.exit(0);
}

const displayName = isObject(profile.display_name) ? profile.display_name : {};
const description = isObject(profile.description) ? profile.description : {};
const nameJa = safeText(displayName.ja, "");
const nameEn = safeText(displayName.en, "");
const sourceDocuments = Array.isArray(profile.source_documents)
  ? profile.source_documents.map(safeRelativePath).filter(Boolean).slice(0, 20)
  : [];

if (!nameJa && !nameEn) {
  process.stdout.write(JSON.stringify({
    status: "failed",
    name: "",
    display_name: { ja: "", en: "" },
    description: { ja: safeText(description.ja, ""), en: safeText(description.en, "") },
    source_documents: sourceDocuments,
    source_path: profileRelativePath,
    source_field: "display_name",
  }));
  process.exit(0);
}

process.stdout.write(JSON.stringify({
  status: "ready",
  name: nameJa || nameEn,
  display_name: { ja: nameJa, en: nameEn },
  description: { ja: safeText(description.ja, ""), en: safeText(description.en, "") },
  source_documents: sourceDocuments,
  source_path: profileRelativePath,
  source_field: "display_name",
}));
NODE
}

product_repository_authority_validate_evidence_status() {
  case "$1" in
    not_run|passed|failed|blocked|unknown|optional|cached|stale) return 0 ;;
  esac
  return 1
}

product_repository_authority_validate_freshness() {
  case "$1" in
    current|stale|not_collected|unknown) return 0 ;;
  esac
  return 1
}

product_repository_authority_validate_authority() {
  case "$1" in
    authoritative|manual_required|advisory|not_collected) return 0 ;;
  esac
  return 1
}

product_repository_authority_validate_source_namespace() {
  case "$1" in
    repositories.product|product.docs|product.workflow|product.git|product.ci|product.security|product.approvals|product.gates|repositories.product.*|product.docs.*|product.workflow.*|product.git.*|product.ci.*|product.security.*|product.approvals.*|product.gates.*) return 0 ;;
  esac
  return 1
}

product_repository_authority_validate_context() {
  case "$1" in
    all|free-development|product-improvement|external-integration|lesson-maintenance|custom) return 0 ;;
  esac
  return 1
}

product_repository_authority_validate_product_root_label() {
  local value="$1"
  case "$value" in
    '[external-product-repository]'/*|none|not_collected) return 0 ;;
    /*|*'/tmp/'*) return 1 ;;
  esac
  [[ -n "$value" ]]
}

product_repository_authority_validate_product_head() {
  case "$1" in
    none|not_collected) return 0 ;;
  esac
  [[ "$1" =~ ^[a-fA-F0-9]{7,64}$ ]]
}

product_repository_authority_validate_observed_at() {
  case "$1" in
    not_collected) return 0 ;;
  esac
  [[ "$1" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]
}

product_repository_authority_validate_nonnegative_integer() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

product_repository_authority_evidence_item_json() {
  local source_id="$1"
  local context="$2"
  local status="$3"
  local freshness_state="$4"
  local required_in_context="$5"
  local authority="$6"
  local observed_at="$7"
  local max_age_seconds="$8"
  local product_root="$9"
  local product_head="${10}"
  local source_artifacts="${11}"
  local blocked_by="${12}"
  local next_command="${13}"

  product_repository_authority_validate_evidence_status "$status" || status="unknown"
  product_repository_authority_validate_freshness "$freshness_state" || freshness_state="unknown"
  product_repository_authority_validate_authority "$authority" || authority="not_collected"
  case "$required_in_context" in true|false) ;; *) required_in_context="false" ;; esac

  printf '{"source_id":'
  product_repository_authority_json_string "$source_id"
  printf ',"context":'
  product_repository_authority_json_string "$context"
  printf ',"status":'
  product_repository_authority_json_string "$status"
  printf ',"freshness_state":'
  product_repository_authority_json_string "$freshness_state"
  printf ',"required_in_context":%s' "$required_in_context"
  printf ',"authority":'
  product_repository_authority_json_string "$authority"
  printf ',"observed_at":'
  product_repository_authority_json_string "$observed_at"
  printf ',"max_age_seconds":'
  product_repository_authority_json_string "$max_age_seconds"
  printf ',"product_root":'
  product_repository_authority_json_string "$product_root"
  printf ',"product_head":'
  product_repository_authority_json_string "$product_head"
  printf ',"source_artifacts":'
  product_repository_authority_json_string "$source_artifacts"
  printf ',"blocked_by":'
  product_repository_authority_json_string "$blocked_by"
  printf ',"next_command":'
  product_repository_authority_json_string "$next_command"
  printf '}'
}

product_repository_authority_evidence_items() {
  local repo="$1"
  local context="$2"
  local product_root_label="$3"
  local index_file
  local rows
  index_file="$(product_repository_authority_evidence_index "$repo")"

  if [[ ! -f "$index_file" ]]; then
    product_repository_authority_evidence_item_json \
      "product.gates.evidence_index" "$context" "not_run" "not_collected" "true" "not_collected" \
      "not_collected" "0" "$product_root_label" "none" \
      "docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv" "" \
      "./tools/product-repository-authority status --json"
    printf '\n'
    return
  fi

  rows="$(awk -F '\t' '
    /^[[:space:]]*$/ { next }
    $1 ~ /^#/ { next }
    NF != 13 {
      printf "invalid product gate evidence row: %s\n", $0 > "/dev/stderr"
      invalid = 1
      next
    }
    { print }
    END { exit invalid ? 1 : 0 }
  ' "$index_file")" || return 1

  while IFS= read -r row; do
    [[ -n "$row" ]] || continue
    source_id="$(product_repository_authority_tsv_field "$row" 1)"
    evidence_context="$(product_repository_authority_tsv_field "$row" 2)"
    status="$(product_repository_authority_tsv_field "$row" 3)"
    freshness_state="$(product_repository_authority_tsv_field "$row" 4)"
    required_in_context="$(product_repository_authority_tsv_field "$row" 5)"
    authority="$(product_repository_authority_tsv_field "$row" 6)"
    observed_at="$(product_repository_authority_tsv_field "$row" 7)"
    max_age_seconds="$(product_repository_authority_tsv_field "$row" 8)"
    product_root="$(product_repository_authority_tsv_field "$row" 9)"
    product_head="$(product_repository_authority_tsv_field "$row" 10)"
    source_artifacts="$(product_repository_authority_tsv_field "$row" 11)"
    blocked_by="$(product_repository_authority_tsv_field "$row" 12)"
    next_command="$(product_repository_authority_tsv_field "$row" 13)"
    if ! product_repository_authority_validate_source_namespace "$source_id"; then
      printf 'invalid product gate evidence source namespace: %s\n' "$source_id" >&2
      return 1
    fi
    if ! product_repository_authority_validate_context "$evidence_context"; then
      printf 'invalid product gate evidence context: %s\n' "$evidence_context" >&2
      return 1
    fi
    if ! product_repository_authority_validate_evidence_status "$status"; then
      printf 'invalid product gate evidence status: %s\n' "$status" >&2
      return 1
    fi
    if ! product_repository_authority_validate_freshness "$freshness_state"; then
      printf 'invalid product gate evidence freshness: %s\n' "$freshness_state" >&2
      return 1
    fi
    case "$required_in_context" in
      true|false) ;;
      *) printf 'invalid product gate evidence required_in_context: %s\n' "$required_in_context" >&2; return 1 ;;
    esac
    if ! product_repository_authority_validate_authority "$authority"; then
      printf 'invalid product gate evidence authority: %s\n' "$authority" >&2
      return 1
    fi
    if ! product_repository_authority_validate_observed_at "$observed_at"; then
      printf 'invalid product gate evidence observed_at: %s\n' "$observed_at" >&2
      return 1
    fi
    if ! product_repository_authority_validate_nonnegative_integer "$max_age_seconds"; then
      printf 'invalid product gate evidence max_age_seconds: %s\n' "$max_age_seconds" >&2
      return 1
    fi
    if ! product_repository_authority_validate_product_root_label "${product_root:-$product_root_label}"; then
      printf 'invalid product gate evidence product_root: %s\n' "${product_root:-$product_root_label}" >&2
      return 1
    fi
    if ! product_repository_authority_validate_product_head "$product_head"; then
      printf 'invalid product gate evidence product_head: %s\n' "$product_head" >&2
      return 1
    fi
    if [[ "$evidence_context" != "$context" && "$evidence_context" != "all" ]]; then
      continue
    fi
    product_repository_authority_evidence_item_json \
      "$source_id" "$evidence_context" "$status" "$freshness_state" "$required_in_context" "$authority" \
      "$observed_at" "$max_age_seconds" "${product_root:-$product_root_label}" "$product_head" \
      "$source_artifacts" "$blocked_by" "$next_command"
    printf '\n'
  done <<<"$rows"
}

product_repository_authority_evidence_source_satisfies_required() {
  local expected_source="$1"
  shift || true
  local evidence_item evidence_status evidence_freshness evidence_authority
  for evidence_item in "$@"; do
    [[ "$(product_repository_authority_json_field "$evidence_item" "source_id")" == "$expected_source" ]] || continue
    [[ "$(product_repository_authority_json_bool_field "$evidence_item" "required_in_context")" == "true" ]] || continue
    evidence_status="$(product_repository_authority_json_field "$evidence_item" "status")"
    evidence_freshness="$(product_repository_authority_json_field "$evidence_item" "freshness_state")"
    evidence_authority="$(product_repository_authority_json_field "$evidence_item" "authority")"
    case "$evidence_status" in
      optional|cached) continue ;;
      passed)
        [[ "$evidence_freshness" == "current" && "$evidence_authority" == "authoritative" ]] || continue
        ;;
    esac
    if product_repository_authority_validate_source_namespace "$expected_source"; then
      return 0
    fi
  done
  return 1
}

product_repository_authority_missing_expected_evidence_items() {
  local repo="$1"
  local context="$2"
  local product_type="$3"
  local product_root_label="$4"
  shift 4 || true
  local evidence_items=("$@")
  local manifest rows row source_id required_mode contexts product_types source_artifacts next_command
  local emitted_expected_sources=""

  product_repository_authority_expected_evidence_already_emitted() {
    local expected_source="$1"
    [[ "|$emitted_expected_sources|" == *"|$expected_source|"* ]]
  }

  product_repository_authority_mark_expected_evidence_emitted() {
    local expected_source="$1"
    emitted_expected_sources="${emitted_expected_sources}|${expected_source}"
  }

  manifest="$repo/ops/TEST_PLAN_MANIFEST.tsv"
  if [[ -s "$manifest" ]]; then
    if rows="$(product_repository_authority_manifest_rows_with_columns "$manifest" 8 "product test plan manifest")"; then
      while IFS= read -r row; do
        [[ -n "$row" ]] || continue
        required_mode="$(product_repository_authority_tsv_field "$row" 2)"
        contexts="$(product_repository_authority_tsv_field "$row" 3)"
        product_types="$(product_repository_authority_tsv_field "$row" 4)"
        source_id="$(product_repository_authority_tsv_field "$row" 6)"
        product_repository_authority_required_for_context "$required_mode" "$contexts" "$product_types" "$context" "$product_type" || continue
        if [[ -z "$source_id" ]] || ! product_repository_authority_validate_source_namespace "$source_id"; then
          product_repository_authority_evidence_item_json \
            "product.gates.evidence_manifest" "$context" "blocked" "unknown" "true" "manual_required" \
            "not_collected" "0" "$product_root_label" "none" \
            "ops/TEST_PLAN_MANIFEST.tsv" "" \
            "./tools/product-scaffold-check check"
          printf '\n'
          continue
        fi
        product_repository_authority_evidence_source_satisfies_required "$source_id" "${evidence_items[@]}" && continue
        product_repository_authority_expected_evidence_already_emitted "$source_id" && continue
        product_repository_authority_mark_expected_evidence_emitted "$source_id"
        product_repository_authority_evidence_item_json \
          "$source_id" "$context" "not_run" "not_collected" "true" "not_collected" \
          "not_collected" "0" "$product_root_label" "none" \
          "ops/TEST_PLAN_MANIFEST.tsv" "" \
          "./tools/product-repository-authority status --json --context $context"
        printf '\n'
      done <<<"$rows"
    else
      product_repository_authority_evidence_item_json \
        "product.gates.evidence_manifest" "$context" "blocked" "unknown" "true" "manual_required" \
        "not_collected" "0" "$product_root_label" "none" \
        "ops/TEST_PLAN_MANIFEST.tsv" "" \
        "./tools/product-scaffold-check check"
      printf '\n'
    fi
  fi

  manifest="$repo/ops/CI_MANIFEST.tsv"
  if [[ -s "$manifest" ]]; then
    if rows="$(product_repository_authority_manifest_rows_with_columns "$manifest" 8 "product CI manifest")"; then
      while IFS= read -r row; do
        [[ -n "$row" ]] || continue
        required_mode="$(product_repository_authority_tsv_field "$row" 2)"
        contexts="$(product_repository_authority_tsv_field "$row" 3)"
        source_id="$(product_repository_authority_tsv_field "$row" 7)"
        product_repository_authority_required_for_context "$required_mode" "$contexts" "all" "$context" "$product_type" || continue
        if [[ -z "$source_id" ]] || ! product_repository_authority_validate_source_namespace "$source_id"; then
          product_repository_authority_evidence_item_json \
            "product.ci.evidence_manifest" "$context" "blocked" "unknown" "true" "manual_required" \
            "not_collected" "0" "$product_root_label" "none" \
            "ops/CI_MANIFEST.tsv" "" \
            "./tools/product-scaffold-check check"
          printf '\n'
          continue
        fi
        product_repository_authority_evidence_source_satisfies_required "$source_id" "${evidence_items[@]}" && continue
        product_repository_authority_expected_evidence_already_emitted "$source_id" && continue
        product_repository_authority_mark_expected_evidence_emitted "$source_id"
        product_repository_authority_evidence_item_json \
          "$source_id" "$context" "not_run" "not_collected" "true" "not_collected" \
          "not_collected" "0" "$product_root_label" "none" \
          "ops/CI_MANIFEST.tsv" "" \
          "./tools/check_ci_status.sh --product --required"
        printf '\n'
      done <<<"$rows"
    else
      product_repository_authority_evidence_item_json \
        "product.ci.evidence_manifest" "$context" "blocked" "unknown" "true" "manual_required" \
        "not_collected" "0" "$product_root_label" "none" \
        "ops/CI_MANIFEST.tsv" "" \
        "./tools/product-scaffold-check check"
      printf '\n'
    fi
  fi

  manifest="$repo/ops/SECURITY_MANIFEST.tsv"
  if [[ -s "$manifest" ]]; then
    if rows="$(product_repository_authority_manifest_rows_with_columns "$manifest" 7 "product security manifest")"; then
      while IFS= read -r row; do
        [[ -n "$row" ]] || continue
        required_mode="$(product_repository_authority_tsv_field "$row" 2)"
        contexts="$(product_repository_authority_tsv_field "$row" 3)"
        source_id="$(product_repository_authority_tsv_field "$row" 5)"
        product_repository_authority_required_for_context "$required_mode" "$contexts" "all" "$context" "$product_type" || continue
        if [[ -z "$source_id" ]] || ! product_repository_authority_validate_source_namespace "$source_id"; then
          product_repository_authority_evidence_item_json \
            "product.security.evidence_manifest" "$context" "blocked" "unknown" "true" "manual_required" \
            "not_collected" "0" "$product_root_label" "none" \
            "ops/SECURITY_MANIFEST.tsv" "" \
            "./tools/product-scaffold-check check"
          printf '\n'
          continue
        fi
        product_repository_authority_evidence_source_satisfies_required "$source_id" "${evidence_items[@]}" && continue
        product_repository_authority_expected_evidence_already_emitted "$source_id" && continue
        product_repository_authority_mark_expected_evidence_emitted "$source_id"
        product_repository_authority_evidence_item_json \
          "$source_id" "$context" "not_run" "not_collected" "true" "not_collected" \
          "not_collected" "0" "$product_root_label" "none" \
          "ops/SECURITY_MANIFEST.tsv" "" \
          "./tools/product-security gate"
        printf '\n'
      done <<<"$rows"
    else
      product_repository_authority_evidence_item_json \
        "product.security.evidence_manifest" "$context" "blocked" "unknown" "true" "manual_required" \
        "not_collected" "0" "$product_root_label" "none" \
        "ops/SECURITY_MANIFEST.tsv" "" \
        "./tools/product-scaffold-check check"
      printf '\n'
    fi
  fi
}

product_repository_authority_blocker_json() {
  local source="$1"
  local status="$2"
  local reason="$3"
  local required_command="$4"
  printf '{"source":'
  product_repository_authority_json_string "$source"
  printf ',"status":'
  product_repository_authority_json_string "$status"
  printf ',"reason":'
  product_repository_authority_json_string "$reason"
  printf ',"required_command":'
  product_repository_authority_json_string "$required_command"
  printf '}'
}

product_repository_authority_evidence_blocker_reason() {
  local status="$1"
  local freshness_state="$2"
  if [[ "$freshness_state" == "stale" && "$status" == "passed" ]]; then
    printf 'Required product evidence is stale.'
    return
  fi
  case "$status" in
    failed) printf 'Required product evidence failed.' ;;
    blocked) printf 'Required product evidence is blocked.' ;;
    stale) printf 'Required product evidence is stale.' ;;
    not_run) printf 'Required product evidence has not run.' ;;
    unknown) printf 'Required product evidence is unknown.' ;;
    *) printf 'Required product evidence is not ready.' ;;
  esac
}

product_repository_authority_json() {
  local repo="${1:-$(lesson_product_repo_root)}"
  local context="${2:-product-improvement}"
  local product_type="${3:-all}"
  local product_name
  local repo_status="ready"
  local authority_status="ready"
  local blocker_scope="none"
  local product_root_label
  local repository_index_json
  local product_summary_json
  local required_total=0
  local required_ready=0
  local optional_missing=()
  local required_missing=()
  local conflicts=()
  local blockers=()
  local document_path_items=()
  local evidence_items=()
  local row scope item lifecycle_status required_mode contexts product_types validation_rule dashboard_visibility canonical_path legacy_paths requirement
  local resolved resolved_status resolved_path resolved_source source_id required_in_context

  product_name="$(basename "$repo")"
  product_root_label="$(product_repository_authority_safe_repo_label "$repo")"
  repository_index_json="$(product_repository_authority_repository_index_json "$repo" 2>/dev/null || printf '{"status":"unknown","path":"ops/REPOSITORY_INDEX.json","schema_version":"unknown","root_name":"","source":"external_product_repository","default_expand_depth":0,"excludes":[],"roles":{},"files":[]}')"
  product_summary_json="$(product_repository_authority_product_summary_json "$repo" 2>/dev/null || printf '{"status":"unknown","name":"","display_name":{"ja":"","en":""},"description":{"ja":"","en":""},"source_documents":[],"source_path":"ops/PRODUCT_PROFILE.json","source_field":""}')"

  if ! product_repository_authority_validate_policy_files >/dev/null 2>&1; then
    repo_status="unknown"
    authority_status="unknown"
    blocker_scope="product_operations"
    blockers+=("$(product_repository_authority_blocker_json "product.policy" "unknown" "Product repository authority policy files could not be validated." "./tools/product-repository-authority status --json")")
  elif [[ ! -d "$repo" ]]; then
    repo_status="missing"
    authority_status="missing"
    blocker_scope="product_operations"
    blockers+=("$(product_repository_authority_blocker_json "repositories.product" "missing" "Configured product repository is missing." "./tools/product-repository-authority status --json")")
  elif [[ ! -d "$repo/.git" ]]; then
    repo_status="failed"
    authority_status="blocked"
    blocker_scope="product_operations"
    blockers+=("$(product_repository_authority_blocker_json "repositories.product" "failed" "Configured product path is not a Git repository." "./tools/product-repository-authority status --json")")
  else
    while IFS=$'\t' read -r scope item lifecycle_status required_mode contexts product_types validation_rule dashboard_visibility canonical_path legacy_paths requirement; do
      required_in_context="false"
      if product_repository_authority_required_for_context "$required_mode" "$contexts" "$product_types" "$context" "$product_type"; then
        required_in_context="true"
        required_total=$((required_total + 1))
      fi

      resolved="$(product_repository_authority_resolve_structure_path "$repo" "$validation_rule" "$canonical_path" "$legacy_paths")"
      IFS=$'\t' read -r resolved_status resolved_path resolved_source <<<"$resolved"
      source_id="${scope}.${item}"

      if [[ "$dashboard_visibility" == "visible" || "$scope" == product_docs || "$scope" == product_workflow ]]; then
        document_path_items+=("$(
          printf '{"source_id":'
          product_repository_authority_json_string "$source_id"
          printf ',"status":'
          product_repository_authority_json_string "$resolved_status"
          printf ',"required_in_context":%s' "$required_in_context"
          printf ',"canonical_path":'
          product_repository_authority_json_string "$canonical_path"
          printf ',"resolved_path":'
          product_repository_authority_json_string "$resolved_path"
          printf ',"resolved_source":'
          product_repository_authority_json_string "$resolved_source"
          printf '}'
        )")
      fi

      if [[ "$resolved_status" == "ready" && "$required_in_context" == "true" ]]; then
        required_ready=$((required_ready + 1))
      elif [[ "$resolved_status" == "blocked" ]]; then
        authority_status="blocked"
        conflicts+=("$source_id")
        case "$resolved_source" in
          root_duplicate)
            blockers+=("$(product_repository_authority_blocker_json "$source_id" "blocked" "Root-level duplicate product repository document is not allowed; keep the canonical docs path only." "./tools/product-scaffold-check check")")
            ;;
          *)
            blockers+=("$(product_repository_authority_blocker_json "$source_id" "blocked" "Canonical and legacy product document paths conflict." "./tools/product-repository-authority status --json")")
            ;;
        esac
      elif [[ "$resolved_status" == "missing" && "$required_in_context" == "true" ]]; then
        [[ "$authority_status" == "blocked" ]] || authority_status="blocked"
        required_missing+=("$source_id")
        blockers+=("$(product_repository_authority_blocker_json "$source_id" "missing" "Required product repository structure item is missing." "./tools/product-repository-authority status --json")")
      elif [[ "$resolved_status" == "missing" ]]; then
        optional_missing+=("$source_id")
      fi
    done < <(product_repository_authority_structure_rows)

    local semantic_blocker semantic_source semantic_status semantic_reason semantic_command
    while IFS=$'\t' read -r semantic_source semantic_status semantic_reason semantic_command; do
      [[ -n "${semantic_source:-}" ]] || continue
      authority_status="blocked"
      blocker_scope="product_operations"
      blockers+=("$(product_repository_authority_blocker_json "$semantic_source" "$semantic_status" "$semantic_reason" "$semantic_command")")
      conflicts+=("$semantic_source")
    done < <(product_repository_authority_product_manifest_semantic_blockers "$repo" "$context" "$product_type")

    local evidence_output evidence_line
    if evidence_output="$(product_repository_authority_evidence_items "$repo" "$context" "$product_root_label")"; then
      evidence_items=()
      while IFS= read -r evidence_line; do
        [[ -n "$evidence_line" ]] || continue
        evidence_items+=("$evidence_line")
      done <<<"$evidence_output"
    else
      evidence_items=()
      authority_status="blocked"
      blocker_scope="product_operations"
      blockers+=("$(product_repository_authority_blocker_json "product.gates.evidence_index" "blocked" "Product gate evidence index could not be parsed or validated." "./tools/product-repository-authority status --json")")
    fi
    if [[ "${#evidence_items[@]}" -eq 0 ]]; then
      evidence_items+=("$(product_repository_authority_evidence_item_json \
        "product.gates.evidence_context" "$context" "not_run" "not_collected" "true" "not_collected" \
        "not_collected" "0" "$product_root_label" "none" \
        "docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv" "" \
        "./tools/product-repository-authority status --json --context $context")")
    fi

    local expected_evidence_line
    while IFS= read -r expected_evidence_line; do
      [[ -n "$expected_evidence_line" ]] || continue
      evidence_items+=("$expected_evidence_line")
    done < <(product_repository_authority_missing_expected_evidence_items "$repo" "$context" "$product_type" "$product_root_label" "${evidence_items[@]}")

    local evidence_item evidence_source evidence_status evidence_freshness evidence_required evidence_command evidence_reason blocker_status
    for evidence_item in "${evidence_items[@]}"; do
      evidence_required="$(product_repository_authority_json_bool_field "$evidence_item" "required_in_context")"
      [[ "$evidence_required" == "true" ]] || continue
      evidence_source="$(product_repository_authority_json_field "$evidence_item" "source_id")"
      evidence_status="$(product_repository_authority_json_field "$evidence_item" "status")"
      evidence_freshness="$(product_repository_authority_json_field "$evidence_item" "freshness_state")"
      evidence_command="$(product_repository_authority_json_field "$evidence_item" "next_command")"
      [[ -n "$evidence_command" ]] || evidence_command="./tools/product-repository-authority status --json"

      blocker_status=""
      case "$evidence_status" in
        failed|blocked|stale|not_run|unknown) blocker_status="$evidence_status" ;;
      esac
      if [[ -z "$blocker_status" && "$evidence_freshness" == "stale" ]]; then
        blocker_status="stale"
      fi
      [[ -n "$blocker_status" ]] || continue

      evidence_reason="$(product_repository_authority_evidence_blocker_reason "$evidence_status" "$evidence_freshness")"
      blockers+=("$(product_repository_authority_blocker_json "$evidence_source" "$blocker_status" "$evidence_reason" "$evidence_command")")
      blocker_scope="product_operations"

      case "$blocker_status" in
        failed|blocked|unknown)
          [[ "$authority_status" == "blocked" ]] || authority_status="blocked"
          ;;
        stale)
          if [[ "$authority_status" == "ready" || "$authority_status" == "not_run" ]]; then
            authority_status="stale"
          fi
          ;;
        not_run)
          if [[ "$authority_status" == "ready" ]]; then
            authority_status="not_run"
          fi
          ;;
      esac
    done
  fi

  printf '{"status":'
  product_repository_authority_json_string "$authority_status"
  printf ',"repository":{"status":'
  product_repository_authority_json_string "$repo_status"
  printf ',"configured_name":'
  product_repository_authority_json_string "$product_name"
  printf ',"product_root":'
  product_repository_authority_json_string "$product_root_label"
  printf ',"blocker_scope":'
  product_repository_authority_json_string "$blocker_scope"
  printf '},"product_summary":'
  printf '%s' "$product_summary_json"
  printf ',"repository_index":'
  printf '%s' "$repository_index_json"
  printf ',"document_paths":'
  product_repository_authority_json_raw_array "${document_path_items[@]}"
  printf ',"manifest_summary":{"required_total":%d,"required_ready":%d,"required_missing":' "$required_total" "$required_ready"
  product_repository_authority_json_array "${required_missing[@]}"
  printf ',"optional_missing":'
  product_repository_authority_json_array "${optional_missing[@]}"
  printf ',"conflicts":'
  product_repository_authority_json_array "${conflicts[@]}"
  printf '},"evidence_summary":{"index_status":'
  if [[ -d "$repo/.git" && -f "$(product_repository_authority_evidence_index "$repo")" ]]; then
    product_repository_authority_json_string "ready"
  else
    product_repository_authority_json_string "not_run"
  fi
  printf ',"items":'
  product_repository_authority_json_raw_array "${evidence_items[@]}"
  printf '},"product_operation_blockers":'
  product_repository_authority_json_raw_array "${blockers[@]}"
  printf '}'
}

product_repository_authority_status_text() {
  local repo="${1:-$(lesson_product_repo_root)}"
  local context="${2:-product-improvement}"
  local product_type="${3:-all}"
  local json
  json="$(product_repository_authority_json "$repo" "$context" "$product_type")"
  printf 'Product Repository Authority\n'
  printf 'Context: %s\n' "$context"
  printf 'Product type: %s\n' "$product_type"
  printf 'Product repository: %s\n' "$(product_repository_authority_safe_repo_label "$repo")"
  printf 'Read-only: existing manifests and evidence are inspected; no checks, fetches, GitHub calls, or mutations run.\n'
  printf '%s\n' "$json"
}

product_repository_authority_gate() {
  local repo="${1:-$(lesson_product_repo_root)}"
  local context="${2:-product-improvement}"
  local product_type="${3:-all}"
  local json
  json="$(product_repository_authority_json "$repo" "$context" "$product_type")"
  PRODUCT_REPOSITORY_AUTHORITY_GATE_JSON="$json" node <<'NODE'
const data = JSON.parse(process.env.PRODUCT_REPOSITORY_AUTHORITY_GATE_JSON);
const blockingStatuses = new Set(["missing", "failed", "blocked", "unknown", "stale", "not_run"]);
const status = data.status || "unknown";
const blockers = Array.isArray(data.product_operation_blockers) ? data.product_operation_blockers : [];
if (blockingStatuses.has(status) || blockers.length > 0) {
  console.error(`Product authority gate failed: ${status}`);
  for (const blocker of blockers) {
    console.error(`- ${blocker.source}: ${blocker.status} - ${blocker.reason}`);
  }
  process.exit(1);
}
NODE
}
