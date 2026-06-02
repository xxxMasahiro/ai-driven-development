#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

./tools/check_lesson_structure.sh
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/check_developer_memory_requirements.sh
./tools/check_repository_boundary.sh --product-required >/dev/null
./tools/check_git_sync.sh --product --required
./tools/check_ci_status.sh --product --required
./tools/free-development gate
./tools/team-development gate
./tools/test_lesson_start_position.sh
./tools/test_lesson14.sh

printf 'Production operations test passed.\n'
