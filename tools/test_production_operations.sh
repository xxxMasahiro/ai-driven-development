#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

production_config="$tmp/LESSON_CONFIG.tsv"
production_mode="$tmp/LESSON_MODE.tsv"
production_workflow_language="$tmp/WORKFLOW_DISPLAY_LANGUAGE.tsv"
production_product_language="$tmp/PRODUCT_DEVELOPMENT_LANGUAGE.tsv"

awk -F '\t' -v OFS='\t' \
  -v mode_file="$production_mode" \
  -v workflow_language_file="$production_workflow_language" \
  -v product_language_file="$production_product_language" '
    $1 == "learning_mode_file" { $2 = mode_file }
    $1 == "workflow_language_file" { $2 = workflow_language_file }
    $1 == "product_language_file" { $2 = product_language_file }
    { print }
  ' "$ROOT/lesson/LESSON_CONFIG.tsv" >"$production_config"

cat >"$production_mode" <<'EOF'
# selected_at	mode	description
2026-06-02 00:00:00	A	じっくり説明
EOF

cat >"$production_workflow_language" <<'EOF'
# selected_at	code	label
2026-06-02 00:00:00	ja	日本語
EOF

cat >"$production_product_language" <<'EOF'
# selected_at	code	label
2026-06-02 00:00:00	ja	日本語
EOF

./tools/check_lesson_structure.sh
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/check_developer_memory_requirements.sh
./tools/test_lesson_start_position.sh
./tools/test_lesson14.sh
LESSON_CONFIG="$production_config" ./tools/check_repository_boundary.sh --product-required >/dev/null
LESSON_CONFIG="$production_config" ./tools/check_git_sync.sh --product --required
LESSON_CONFIG="$production_config" ./tools/check_ci_status.sh --product --required
LESSON_MENU_SETTINGS_STRICT_CONFIG=1 LESSON_CONFIG="$production_config" ./tools/free-development gate
LESSON_MENU_SETTINGS_STRICT_CONFIG=1 LESSON_CONFIG="$production_config" ./tools/team-development gate

printf 'Production operations test passed.\n'
