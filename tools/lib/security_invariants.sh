#!/usr/bin/env bash

if [[ -z "${LESSON_ROOT:-}" ]]; then
  SECURITY_INVARIANTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # shellcheck source=lesson_common.sh
  source "$SECURITY_INVARIANTS_DIR/lesson_common.sh"
fi

security_invariants_policy_file() {
  printf '%s\n' "${SAFEFLOW_SECURITY_POLICY_FILE:-$LESSON_ROOT/docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv}"
}

security_invariants_required_ids() {
  cat <<'IDS'
untrusted_text_as_data
prompt_injection_defense
secret_protection
least_privilege_external_api
owner_layer_security
destructive_operation_approval
dependency_change_review
git_ci_safety
no_prompt_only_security
IDS
}

security_invariants_rows() {
  local policy_file
  policy_file="$(security_invariants_policy_file)"
  awk -F '\t' '
    /^[[:space:]]*$/ { next }
    $1 ~ /^#/ { next }
    {
      if (NF != 6) {
        printf "invalid Security guard policy row: %s\n", $0 > "/dev/stderr"
        invalid = 1
        next
      }
      print
    }
    END { exit invalid ? 1 : 0 }
  ' "$policy_file"
}

security_invariants_validate() {
  local policy_file
  local missing=0
  local required_id
  local row_count
  local id surface status evidence_file pattern description evidence_path
  declare -A seen_ids=()
  policy_file="$(security_invariants_policy_file)"

  if [[ ! -f "$policy_file" ]]; then
    printf 'missing Security guard policy: %s\n' "$policy_file" >&2
    return 1
  fi

  row_count="$(security_invariants_rows | wc -l | awk '{ print $1 }')" || return 1
  if [[ "$row_count" -eq 0 ]]; then
    printf 'Security guard policy has no rows: %s\n' "$policy_file" >&2
    return 1
  fi

  while IFS= read -r required_id; do
    if ! security_invariants_rows | awk -F '\t' -v id="$required_id" '$1 == id { found = 1 } END { exit found ? 0 : 1 }'; then
      printf 'missing Security guard invariant: %s\n' "$required_id" >&2
      missing=1
    fi
  done < <(security_invariants_required_ids)

  while IFS=$'\t' read -r id surface status evidence_file pattern description; do
    if [[ -n "${seen_ids[$id]:-}" ]]; then
      printf 'duplicate Security guard invariant: %s\n' "$id" >&2
      missing=1
    fi
    seen_ids[$id]=1

    if [[ "$status" != "implemented" ]]; then
      printf 'Security guard invariant is not implemented: %s\n' "$id" >&2
      missing=1
    fi
    if [[ -z "$surface" || -z "$evidence_file" || -z "$pattern" || -z "$description" ]]; then
      printf 'invalid empty Security guard invariant field: %s\n' "$id" >&2
      missing=1
      continue
    fi
    if [[ "$evidence_file" == /* || "$evidence_file" == *"/../"* || "$evidence_file" == "../"* || "$evidence_file" == *"/.." || "$evidence_file" == ".." ]]; then
      printf 'unsafe Security guard evidence path for %s: %s\n' "$id" "$evidence_file" >&2
      missing=1
      continue
    fi

    evidence_path="$LESSON_ROOT/$evidence_file"
    if [[ ! -f "$evidence_path" ]]; then
      printf 'missing Security guard evidence file for %s: %s\n' "$id" "$evidence_file" >&2
      missing=1
      continue
    fi
    if ! grep -F -- "$pattern" "$evidence_path" >/dev/null; then
      printf 'missing Security guard evidence pattern for %s in %s: %s\n' "$id" "$evidence_file" "$pattern" >&2
      missing=1
    fi
  done < <(security_invariants_rows)

  [[ "$missing" -eq 0 ]]
}
