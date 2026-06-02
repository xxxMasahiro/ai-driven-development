#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

./tools/check_lesson_structure.sh
./tools/check_document_organization.sh
./tools/check_learner_display.sh
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/check_as_built_docs.sh
WORKFLOW_PAIR_SINGLE_FILE_REASON="aggregate test may run while remediation documents are being edited together" ./tools/check_workflow_pair_sync.sh
./tools/check_review_protocol.sh
./tools/check_developer_memory_requirements.sh
./tools/menu >/dev/null
./tools/dashboard all >/dev/null
./tools/illustrations list >/dev/null
./tools/external-integration status >/dev/null
./tools/test_lesson_playwright.sh
./tools/test_product_gate_tools.sh
./tools/test_lesson_start_position.sh
./tools/test_lesson14.sh

printf 'Lesson repository test passed.\n'
