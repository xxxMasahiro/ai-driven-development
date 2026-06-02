#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

./tools/check_lesson_structure.sh
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/check_as_built_docs.sh
./tools/check_review_protocol.sh
./tools/check_developer_memory_requirements.sh
./tools/menu >/dev/null
./tools/dashboard all >/dev/null
./tools/illustrations list >/dev/null
./tools/test_product_gate_tools.sh
./tools/test_lesson_start_position.sh
./tools/test_lesson14.sh

printf 'Lesson repository test passed.\n'
