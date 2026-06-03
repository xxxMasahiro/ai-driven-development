#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ ! -x "$ROOT/node_modules/.bin/playwright" ]]; then
  printf 'Playwright dependencies are not installed.\n' >&2
  printf 'Run npm install, then run: npm run test:dashboard\n' >&2
  exit 1
fi

workers="$("$ROOT/tools/resource-guard" recommend-jobs --profile playwright --value-only)"
(cd "$ROOT" && PLAYWRIGHT_WORKERS="$workers" npm run test:dashboard)

printf 'Lesson Playwright checks passed.\n'
