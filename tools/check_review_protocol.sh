#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
file="$ROOT/reviews/SUBAGENT_REVIEW_PROTOCOL.md"
missing=0

if [[ ! -f "$file" ]]; then
  printf 'missing: reviews/SUBAGENT_REVIEW_PROTOCOL.md\n' >&2
  exit 1
fi

for pattern in \
  'Documentation consistency reviewer' \
  'Implementation and test reviewer' \
  'Learning experience reviewer' \
  'adopt, defer, or reject' \
  'check_as_built_docs\.sh' \
  'test_lesson_repository\.sh'
do
  if ! grep -Eq "$pattern" "$file"; then
    printf 'missing review protocol pattern: %s\n' "$pattern" >&2
    missing=1
  fi
done

if [[ $missing -ne 0 ]]; then
  printf '\nReview protocol check failed.\n' >&2
  exit 1
fi

printf 'Review protocol check passed.\n'
