#!/usr/bin/env bash

lesson_common_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LESSON_ROOT="${LESSON_ROOT:-$(cd "$lesson_common_dir/../.." && pwd)}"
LESSON_CONFIG="${LESSON_CONFIG:-$LESSON_ROOT/lesson/LESSON_CONFIG.tsv}"

lesson_config_get() {
  local key="$1"
  local default_value="${2:-}"

  if [[ ! -f "$LESSON_CONFIG" ]]; then
    printf '%s' "$default_value"
    return
  fi

  awk -F '\t' -v key="$key" -v default_value="$default_value" '
    $1 !~ /^#/ && $1 == key {
      print $2
      found = 1
      exit
    }
    END {
      if (!found) print default_value
    }
  ' "$LESSON_CONFIG"
}

lesson_expand_path() {
  local path="$1"
  case "$path" in
    '$HOME')
      printf '%s' "$HOME"
      ;;
    '$HOME'/*)
      printf '%s/%s' "$HOME" "${path#\$HOME/}"
      ;;
    "~")
      printf '%s' "$HOME"
      ;;
    "~"/*)
      printf '%s/%s' "$HOME" "${path#~/}"
      ;;
    *)
      printf '%s' "$path"
      ;;
  esac
}

lesson_abs_path() {
  local path="$1"
  path="$(lesson_expand_path "$path")"
  case "$path" in
    /*) printf '%s' "$path" ;;
    *) printf '%s/%s' "$LESSON_ROOT" "$path" ;;
  esac
}

lesson_project_root() {
  local configured
  configured="$(lesson_config_get project_root "")"
  if [[ -n "$configured" ]]; then
    lesson_expand_path "$configured"
  else
    dirname "$LESSON_ROOT"
  fi
}

lesson_product_repo_name() {
  lesson_config_get product_repo_name "task-tracker-repository"
}

lesson_product_repo_root() {
  printf '%s/%s' "$(lesson_project_root)" "$(lesson_product_repo_name)"
}

lesson_flow_file() {
  lesson_abs_path "$(lesson_config_get flow_file "lesson/LESSON_FLOW.tsv")"
}

lesson_flow_step_label() {
  local flow_file="$1"
  local step_id="$2"
  awk -F '\t' -v step="$step_id" '
    $1 !~ /^#/ && $2 == step {
      if ($3 != "" && $4 != "") printf "%s: %s", $3, $4
      else if ($4 != "") printf "%s", $4
      else if ($3 != "") printf "%s", $3
      else printf "%s", step
      found = 1
      exit
    }
    END {
      if (!found) exit 1
    }
  ' "$flow_file"
}

lesson_state_file() {
  lesson_abs_path "$(lesson_config_get state_file "learning/LESSON_STATE.tsv")"
}

lesson_tracker_file() {
  lesson_abs_path "$(lesson_config_get learning_tracker_file "learning/LEARNING_TASK_TRACKER.md")"
}

lesson_handoff_file() {
  lesson_abs_path "$(lesson_config_get learning_handoff_file "learning/LEARNING_HANDOFF.md")"
}

lesson_approval_file() {
  lesson_abs_path "$(lesson_config_get approval_file "learning/LESSON_APPROVALS.tsv")"
}

lesson_learning_mode_file() {
  lesson_abs_path "$(lesson_config_get learning_mode_file "learning/LESSON_MODE.tsv")"
}

lesson_workflow_language_file() {
  lesson_abs_path "$(lesson_config_get workflow_language_file "learning/WORKFLOW_DISPLAY_LANGUAGE.tsv")"
}

lesson_product_language_file() {
  lesson_abs_path "$(lesson_config_get product_language_file "learning/PRODUCT_DEVELOPMENT_LANGUAGE.tsv")"
}

lesson_normalize_learning_mode() {
  local mode="$1"
  case "$mode" in
    A|a)
      printf 'A\tじっくり説明'
      ;;
    B|b)
      printf 'B\tほどよく説明'
      ;;
    C|c)
      printf 'C\t手順だけ'
      ;;
    *)
      printf 'learning mode must be A, B, or C.\n' >&2
      exit 1
      ;;
  esac
}

lesson_current_learning_mode_file() {
  local file="$1"
  awk -F '\t' '$1 !~ /^#/ && $2 ~ /^[ABC]$/ { print $2; found=1; exit } END { exit found ? 0 : 1 }' "$file"
}

lesson_set_learning_mode_file() {
  local file="$1"
  local raw_mode="${2:-}"
  [[ -n "$raw_mode" ]] || { printf 'learning mode is required: A, B, or C.\n' >&2; exit 1; }
  local normalized mode description stamp
  normalized="$(lesson_normalize_learning_mode "$raw_mode")"
  mode="${normalized%%$'\t'*}"
  description="${normalized#*$'\t'}"
  stamp="$(date '+%Y-%m-%d %H:%M:%S')"
  printf '# selected_at\tmode\tdescription\n%s\t%s\t%s\n' "$stamp" "$mode" "$description" > "$file"
  printf 'Learning mode recorded: %s (%s)\n' "$mode" "$description"
}

lesson_show_learning_mode_file() {
  local file="$1"
  local current
  current="$(awk -F '\t' '$1 !~ /^#/ && $2 ~ /^[ABC]$/ { print $2 " (" $3 ")"; found=1; exit } END { exit found ? 0 : 1 }' "$file" || true)"
  if [[ -n "$current" ]]; then
    printf 'Current learning mode: %s\n' "$current"
  else
    printf 'Current learning mode: not selected\n'
  fi
}

lesson_supported_language_codes() {
  printf 'ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar'
}

lesson_supported_language_examples() {
  printf 'ja, en, ko, zh-CN, zh-TW, es, pt-BR, fr, de, id, vi, th, hi, ar'
}

lesson_normalize_language() {
  local raw="$1"
  case "$raw" in
    ja|JA|jp|JP|日本語|Japanese|japanese)
      printf 'ja\t日本語'
      ;;
    en|EN|英語|English|english)
      printf 'en\tEnglish'
      ;;
    ko|KO|韓国語|Korean|korean)
      printf 'ko\t한국어'
      ;;
    zh|ZH|zh-CN|zh-cn|zh_CN|中国語|簡体中文|简体中文|Chinese|chinese|Simplified\ Chinese|simplified\ chinese)
      printf 'zh-CN\t简体中文'
      ;;
    zh-TW|zh-tw|zh_TW|繁體中文|繁体中文|Traditional\ Chinese|traditional\ chinese)
      printf 'zh-TW\t繁體中文'
      ;;
    es|ES|Español|Espanol|Spanish|spanish)
      printf 'es\tEspañol'
      ;;
    pt-BR|pt-br|pt_BR|Português\ do\ Brasil|Portugues\ do\ Brasil|Brazilian\ Portuguese|brazilian\ portuguese)
      printf 'pt-BR\tPortuguês do Brasil'
      ;;
    fr|FR|Français|Francais|French|french)
      printf 'fr\tFrançais'
      ;;
    de|DE|Deutsch|German|german)
      printf 'de\tDeutsch'
      ;;
    id|ID|Bahasa\ Indonesia|Indonesian|indonesian)
      printf 'id\tBahasa Indonesia'
      ;;
    vi|VI|Tiếng\ Việt|Tieng\ Viet|Vietnamese|vietnamese)
      printf 'vi\tTiếng Việt'
      ;;
    th|TH|ไทย|Thai|thai)
      printf 'th\tไทย'
      ;;
    hi|HI|हिन्दी|Hindi|hindi)
      printf 'hi\tहिन्दी'
      ;;
    ar|AR|العربية|Arabic|arabic)
      printf 'ar\tالعربية'
      ;;
    *)
      if [[ -n "$raw" ]]; then
        printf 'custom\t%s' "$raw"
      else
        printf 'language is required. Examples: %s.\n' "$(lesson_supported_language_examples)" >&2
        exit 1
      fi
      ;;
  esac
}

lesson_language_file_has_value() {
  local file="$1"
  [[ -f "$file" ]] || return 1
  awk -F '\t' '$1 !~ /^#/ && $2 != "" && $3 != "" { found=1; exit } END { exit found ? 0 : 1 }' "$file"
}

lesson_set_language_file() {
  local file="$1"
  local label="$2"
  local raw_language="${3:-}"
  local normalized code display stamp
  normalized="$(lesson_normalize_language "$raw_language")"
  code="${normalized%%$'\t'*}"
  display="${normalized#*$'\t'}"
  stamp="$(date '+%Y-%m-%d %H:%M:%S')"
  printf '# selected_at\tcode\tlabel\n%s\t%s\t%s\n' "$stamp" "$code" "$display" > "$file"
  printf '%s recorded: %s (%s)\n' "$label" "$code" "$display"
}

lesson_show_language_file() {
  local file="$1"
  local label="$2"
  local current
  current="$(awk -F '\t' '$1 !~ /^#/ && $2 != "" { print $2 " (" $3 ")"; found=1; exit } END { exit found ? 0 : 1 }' "$file" || true)"
  if [[ -n "$current" ]]; then
    printf 'Current %s: %s\n' "$label" "$current"
  else
    printf 'Current %s: not selected\n' "$label"
  fi
}

lesson_structure_check() {
  "$LESSON_ROOT/tools/check_lesson_structure.sh" >/dev/null
}

lesson_config_get_from_file() {
  local config_file="$1"
  local key="$2"
  local default_value="${3:-}"

  if [[ ! -f "$config_file" ]]; then
    printf '%s' "$default_value"
    return
  fi

  awk -F '\t' -v key="$key" -v default_value="$default_value" '
    $1 !~ /^#/ && $1 == key {
      print $2
      found = 1
      exit
    }
    END {
      if (!found) print default_value
    }
  ' "$config_file"
}

lesson_abs_path_from_config_file() {
  local config_file="$1"
  local path="$2"
  path="$(lesson_expand_path "$path")"
  case "$path" in
    /*) printf '%s' "$path" ;;
    *) printf '%s/%s' "$LESSON_ROOT" "$path" ;;
  esac
}

lesson_setting_file_from_config() {
  local config_file="$1"
  local setting="$2"
  local key default_value
  case "$setting" in
    learning_mode)
      key="learning_mode_file"
      default_value="learning/LESSON_MODE.tsv"
      ;;
    workflow_language)
      key="workflow_language_file"
      default_value="learning/WORKFLOW_DISPLAY_LANGUAGE.tsv"
      ;;
    product_language)
      key="product_language_file"
      default_value="learning/PRODUCT_DEVELOPMENT_LANGUAGE.tsv"
      ;;
    *)
      printf 'unknown setting: %s\n' "$setting" >&2
      exit 1
      ;;
  esac
  lesson_abs_path_from_config_file "$config_file" "$(lesson_config_get_from_file "$config_file" "$key" "$default_value")"
}

lesson_learning_mode_file_has_value() {
  local file="$1"
  [[ -f "$file" ]] || return 1
  lesson_current_learning_mode_file "$file" >/dev/null 2>&1
}

lesson_setting_file_has_value() {
  local setting="$1"
  local file="$2"
  case "$setting" in
    learning_mode)
      lesson_learning_mode_file_has_value "$file"
      ;;
    workflow_language|product_language)
      lesson_language_file_has_value "$file"
      ;;
    *)
      printf 'unknown setting: %s\n' "$setting" >&2
      exit 1
      ;;
  esac
}

lesson_menu_candidate_configs() {
  local active_config="${LESSON_CONFIG:-$LESSON_ROOT/lesson/LESSON_CONFIG.tsv}"
  local config
  local -a candidates=(
    "$active_config"
  )

  if [[ "${LESSON_MENU_SETTINGS_STRICT_CONFIG:-0}" != "1" ]]; then
    candidates+=(
      "$LESSON_ROOT/lesson/LESSON_CONFIG_14_DAYS.tsv"
      "$LESSON_ROOT/lesson/LESSON_CONFIG.tsv"
    )
  fi

  local seen=""
  for config in "${candidates[@]}"; do
    [[ -n "$config" ]] || continue
    case "$seen" in
      *"|$config|"*) continue ;;
    esac
    seen="${seen}|${config}|"
    printf '%s\n' "$config"
  done
}

lesson_menu_latest_setting_file() {
  local setting="$1"
  local config file stamp best_file="" best_stamp=-1

  while IFS= read -r config; do
    file="$(lesson_setting_file_from_config "$config" "$setting")"
    if lesson_setting_file_has_value "$setting" "$file"; then
      stamp="$(stat -c '%Y' "$file" 2>/dev/null || printf '0')"
      if [[ -z "$best_file" || "$stamp" -gt "$best_stamp" ]]; then
        best_file="$file"
        best_stamp="$stamp"
      fi
    fi
  done < <(lesson_menu_candidate_configs)

  [[ -n "$best_file" ]] || return 1
  printf '%s' "$best_file"
}

lesson_setting_value_from_file() {
  local setting="$1"
  local file="$2"
  case "$setting" in
    learning_mode)
      awk -F '\t' '$1 !~ /^#/ && $2 ~ /^[ABC]$/ { printf "%s (%s)", $2, $3; found=1; exit } END { exit found ? 0 : 1 }' "$file"
      ;;
    workflow_language|product_language)
      awk -F '\t' '$1 !~ /^#/ && $2 != "" && $3 != "" { printf "%s (%s)", $2, $3; found=1; exit } END { exit found ? 0 : 1 }' "$file"
      ;;
    *)
      printf 'unknown setting: %s\n' "$setting" >&2
      exit 1
      ;;
  esac
}

lesson_menu_setting_label() {
  case "$1" in
    learning_mode) printf 'Learning mode' ;;
    workflow_language) printf 'Workflow display language' ;;
    product_language) printf 'Product development language' ;;
    *) printf '%s' "$1" ;;
  esac
}

lesson_menu_print_setting_status() {
  local setting="$1"
  local file value
  if file="$(lesson_menu_latest_setting_file "$setting")"; then
    value="$(lesson_setting_value_from_file "$setting" "$file")"
    printf '%s: ready - %s\n' "$(lesson_menu_setting_label "$setting")" "$value"
  else
    printf '%s: missing\n' "$(lesson_menu_setting_label "$setting")"
  fi
}

lesson_menu_require_settings() {
  local context="$1"
  local missing=0

  if ! lesson_menu_latest_setting_file learning_mode >/dev/null; then
    printf 'missing menu prerequisite for %s: learning mode\n' "$context" >&2
    printf 'Run: ./tools/lesson 学習モード <A|B|C>\n' >&2
    printf 'Or:  ./tools/lesson14 学習モード <A|B|C>\n' >&2
    missing=1
  fi
  if ! lesson_menu_latest_setting_file workflow_language >/dev/null; then
    printf 'missing menu prerequisite for %s: workflow display language\n' "$context" >&2
    printf 'Run: ./tools/lesson 表示言語 <%s>\n' "$(lesson_supported_language_codes)" >&2
    printf 'Or:  ./tools/lesson14 表示言語 <%s>\n' "$(lesson_supported_language_codes)" >&2
    missing=1
  fi
  if ! lesson_menu_latest_setting_file product_language >/dev/null; then
    printf 'missing menu prerequisite for %s: product development language\n' "$context" >&2
    printf 'Run: ./tools/lesson 開発言語 <%s>\n' "$(lesson_supported_language_codes)" >&2
    printf 'Or:  ./tools/lesson14 開発言語 <%s>\n' "$(lesson_supported_language_codes)" >&2
    missing=1
  fi

  [[ "$missing" -eq 0 ]] || exit 1
}

lesson_menu_require_config_settings() {
  local context="$1"
  local config_file="$2"
  local missing=0
  local mode_file workflow_file product_file
  mode_file="$(lesson_setting_file_from_config "$config_file" learning_mode)"
  workflow_file="$(lesson_setting_file_from_config "$config_file" workflow_language)"
  product_file="$(lesson_setting_file_from_config "$config_file" product_language)"

  if ! lesson_learning_mode_file_has_value "$mode_file"; then
    printf 'missing menu prerequisite for %s: learning mode\n' "$context" >&2
    missing=1
  fi
  if ! lesson_language_file_has_value "$workflow_file"; then
    printf 'missing menu prerequisite for %s: workflow display language\n' "$context" >&2
    missing=1
  fi
  if ! lesson_language_file_has_value "$product_file"; then
    printf 'missing menu prerequisite for %s: product development language\n' "$context" >&2
    missing=1
  fi

  [[ "$missing" -eq 0 ]] || exit 1
}

lesson_menu_print_readiness() {
  local context="$1"
  printf 'Menu prerequisite readiness: %s\n' "$context"
  lesson_menu_print_setting_status learning_mode
  lesson_menu_print_setting_status workflow_language
  lesson_menu_print_setting_status product_language
  printf 'Learner approval: required before start\n'
}

lesson_product_profile_policy_file() {
  printf '%s\n' "${MENU_PRODUCT_PROFILE_POLICY_FILE:-$LESSON_ROOT/docs/workflow/MENU_PRODUCT_PROFILE_POLICY.tsv}"
}

lesson_product_profile_policy_field() {
  local menu_key="$1"
  local field_number="$2"
  local policy_file
  policy_file="$(lesson_product_profile_policy_file)"
  awk -F '\t' -v key="$menu_key" -v field_number="$field_number" '
    $1 ~ /^#/ { next }
    $1 == key || $2 == key {
      print $field_number
      found = 1
      exit
    }
    END { exit found ? 0 : 1 }
  ' "$policy_file"
}

lesson_product_profile_policy_value() {
  local menu_key="$1"
  local field_number="$2"
  local value
  value="$(lesson_product_profile_policy_field "$menu_key" "$field_number" 2>/dev/null || true)"
  if [[ "$value" == "none" ]]; then
    value=""
  fi
  printf '%s' "$value"
}

lesson_product_profile_menu_id() {
  lesson_product_profile_policy_value "$1" 2
}

lesson_product_profile_scope() {
  lesson_product_profile_policy_value "$1" 3
}

lesson_product_profile_recommended_name() {
  local menu_key="$1"
  local language="${2:-ja}"
  case "$language" in
    en) lesson_product_profile_policy_value "$menu_key" 5 ;;
    *) lesson_product_profile_policy_value "$menu_key" 4 ;;
  esac
}

lesson_product_profile_description() {
  local menu_key="$1"
  local language="${2:-ja}"
  case "$language" in
    en) lesson_product_profile_policy_value "$menu_key" 7 ;;
    *) lesson_product_profile_policy_value "$menu_key" 6 ;;
  esac
}

lesson_product_profile_source_documents() {
  lesson_product_profile_policy_value "$1" 8
}

lesson_product_profile_repo_for_menu() {
  local menu_key="$1"
  local scope
  scope="$(lesson_product_profile_scope "$menu_key")"
  case "$scope" in
    lesson) printf '%s' "$LESSON_ROOT" ;;
    *) lesson_product_repo_root ;;
  esac
}

lesson_product_profile_file_for_menu() {
  local menu_key="$1"
  local menu_id scope repo
  menu_id="$(lesson_product_profile_menu_id "$menu_key")"
  scope="$(lesson_product_profile_scope "$menu_key")"
  repo="$(lesson_product_profile_repo_for_menu "$menu_key")"
  case "$scope" in
    lesson)
      printf '%s/learning/MENU_PRODUCT_PROFILES/%s.json' "$repo" "$menu_id"
      ;;
    product)
      printf '%s/ops/PRODUCT_PROFILE.json' "$repo"
      ;;
    *)
      printf 'unknown product profile scope for menu %s: %s\n' "$menu_key" "$scope" >&2
      exit 1
      ;;
  esac
}

lesson_product_profile_display_name_from_file() {
  local file="$1"
  local language="${2:-ja}"
  PRODUCT_PROFILE_FILE="$file" PRODUCT_PROFILE_LANGUAGE="$language" node <<'NODE'
const fs = require("node:fs");

const file = process.env.PRODUCT_PROFILE_FILE || "";
const language = process.env.PRODUCT_PROFILE_LANGUAGE || "ja";

function safeText(value) {
  return String(value ?? "")
    .replace(/[\u0000-\u0008\u000b\u000c\u000e-\u001f]+/g, " ")
    .replace(/\s+/g, " ")
    .trim()
    .slice(0, 240);
}

try {
  const data = JSON.parse(fs.readFileSync(file, "utf8"));
  const names = data && typeof data === "object" && !Array.isArray(data) && data.display_name && typeof data.display_name === "object"
    ? data.display_name
    : {};
  const preferred = safeText(names[language]);
  const fallbackJa = safeText(names.ja);
  const fallbackEn = safeText(names.en);
  const name = preferred || fallbackJa || fallbackEn;
  if (!name) process.exit(1);
  process.stdout.write(name);
} catch {
  process.exit(1);
}
NODE
}

lesson_product_profile_display_name_for_menu() {
  local menu_key="$1"
  local language="${2:-ja}"
  local file
  file="$(lesson_product_profile_file_for_menu "$menu_key")"
  [[ -f "$file" ]] || return 1
  lesson_product_profile_display_name_from_file "$file" "$language"
}

lesson_product_profile_has_name_for_menu() {
  lesson_product_profile_display_name_for_menu "$1" ja >/dev/null 2>&1
}

lesson_product_profile_print_readiness() {
  local menu_key="$1"
  local label="${2:-Product name}"
  local name recommended menu_id
  menu_id="$(lesson_product_profile_menu_id "$menu_key")"
  if name="$(lesson_product_profile_display_name_for_menu "$menu_key" ja 2>/dev/null)"; then
    printf '%s: ready - %s\n' "$label" "$name"
    return
  fi

  recommended="$(lesson_product_profile_recommended_name "$menu_key" ja)"
  printf '%s: missing\n' "$label"
  if [[ -n "$recommended" ]]; then
    printf 'Recommended product name: %s\n' "$recommended"
    printf 'Run: ./tools/product-profile set --menu %s --accept-recommended --confirm\n' "$menu_id"
  else
    printf 'Run: ./tools/product-profile set --menu %s --name-ja "<成果物名>" --name-en "<Product name>" --confirm\n' "$menu_id"
  fi
}

lesson_product_profile_require() {
  local menu_key="$1"
  local context="${2:-$1}"
  if lesson_product_profile_has_name_for_menu "$menu_key"; then
    return 0
  fi
  printf 'missing menu prerequisite for %s: product name\n' "$context" >&2
  lesson_product_profile_print_readiness "$menu_key" "Product name" >&2
  exit 1
}

lesson_menu_require_start_approval() {
  local context="$1"
  local confirm="${2:-}"
  if [[ "$confirm" != "--confirm" ]]; then
    printf 'learner approval is required before starting %s.\n' "$context" >&2
    printf 'Run the start command again with --confirm after the learner approves.\n' >&2
    exit 1
  fi
}
