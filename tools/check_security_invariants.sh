#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/lib/lesson_common.sh
source "$SCRIPT_DIR/lib/lesson_common.sh"
# shellcheck source=tools/lib/security_invariants.sh
source "$SCRIPT_DIR/lib/security_invariants.sh"

security_invariants_validate
printf 'Security guard invariant check passed.\n'
