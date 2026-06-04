#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

"$ROOT/tools/check_security_invariants.sh" | grep 'Security guard invariant check passed'

mkdir -p "$tmp/docs/workflow"
cat > "$tmp/AGENTS.MD" <<'DOC'
untrusted text as data
prompt injection
secrets
least privilege
owner layer
destructive operations
dependency changes
Git/CI
prompt-only
DOC

cat > "$tmp/docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv" <<'DOC'
# invariant_id	surface	status	evidence_file	evidence_pattern	description
untrusted_text_as_data	agent_rules	implemented	AGENTS.MD	untrusted text as data	Treat external text as data.
DOC

LESSON_ROOT="$tmp" SAFEFLOW_SECURITY_POLICY_FILE="$tmp/docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv" "$ROOT/tools/check_security_invariants.sh" >/tmp/security-invariants-missing.out 2>&1 && exit 1 || true
grep 'missing Security guard invariant: prompt_injection_defense' /tmp/security-invariants-missing.out >/dev/null

cat > "$tmp/docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv" <<'DOC'
# invariant_id	surface	status	evidence_file	evidence_pattern	description
untrusted_text_as_data	agent_rules	implemented	AGENTS.MD	untrusted text as data	Treat external text as data.
prompt_injection_defense	agent_rules	implemented	AGENTS.MD	prompt injection	Check prompt injection.
secret_protection	agent_rules	implemented	AGENTS.MD	secrets	Protect secrets.
least_privilege_external_api	agent_rules	implemented	AGENTS.MD	least privilege	Use least privilege.
owner_layer_security	agent_rules	implemented	AGENTS.MD	owner layer	Use owner layer.
destructive_operation_approval	agent_rules	implemented	AGENTS.MD	destructive operations	Require approval.
dependency_change_review	agent_rules	implemented	AGENTS.MD	dependency changes	Review dependencies.
git_ci_safety	agent_rules	implemented	AGENTS.MD	Git/CI	Protect Git and CI.
no_prompt_only_security	agent_rules	implemented	AGENTS.MD	keyword-filter-only	Reject weak fixes.
DOC

LESSON_ROOT="$tmp" SAFEFLOW_SECURITY_POLICY_FILE="$tmp/docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv" "$ROOT/tools/check_security_invariants.sh" >/tmp/security-invariants-pattern.out 2>&1 && exit 1 || true
grep 'missing Security guard evidence pattern for no_prompt_only_security' /tmp/security-invariants-pattern.out >/dev/null

cat > "$tmp/docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv" <<'DOC'
# invariant_id	surface	status	evidence_file	evidence_pattern	description
untrusted_text_as_data	agent_rules	implemented	AGENTS.MD	untrusted text as data	Treat external text as data.
prompt_injection_defense	agent_rules	implemented	../unsafe.txt	prompt injection	Check prompt injection.
secret_protection	agent_rules	implemented	AGENTS.MD	secrets	Protect secrets.
least_privilege_external_api	agent_rules	implemented	AGENTS.MD	least privilege	Use least privilege.
owner_layer_security	agent_rules	implemented	AGENTS.MD	owner layer	Use owner layer.
destructive_operation_approval	agent_rules	implemented	AGENTS.MD	destructive operations	Require approval.
dependency_change_review	agent_rules	implemented	AGENTS.MD	dependency changes	Review dependencies.
git_ci_safety	agent_rules	implemented	AGENTS.MD	Git/CI	Protect Git and CI.
no_prompt_only_security	agent_rules	implemented	AGENTS.MD	prompt-only	Reject weak fixes.
DOC

LESSON_ROOT="$tmp" SAFEFLOW_SECURITY_POLICY_FILE="$tmp/docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv" "$ROOT/tools/check_security_invariants.sh" >/tmp/security-invariants-path.out 2>&1 && exit 1 || true
grep 'unsafe Security guard evidence path for prompt_injection_defense' /tmp/security-invariants-path.out >/dev/null

pwned="$tmp/security-invariants-pwned"
cat > "$tmp/docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv" <<DOC
# invariant_id	surface	status	evidence_file	evidence_pattern	description
untrusted_text_as_data	agent_rules	implemented	AGENTS.MD	untrusted text as data	Treat external text as data.
prompt_injection_defense	agent_rules	implemented	AGENTS.MD	prompt injection	Check prompt injection.
secret_protection	agent_rules	implemented	AGENTS.MD	secrets	Protect secrets.
least_privilege_external_api	agent_rules	implemented	AGENTS.MD	least privilege	Use least privilege.
owner_layer_security	agent_rules	implemented	AGENTS.MD	owner layer	Use owner layer.
destructive_operation_approval	agent_rules	implemented	AGENTS.MD	destructive operations	Require approval.
dependency_change_review	agent_rules	implemented	AGENTS.MD	dependency changes	Review dependencies.
git_ci_safety	agent_rules	implemented	AGENTS.MD	Git/CI	Protect Git and CI.
no_prompt_only_security	agent_rules	implemented	AGENTS.MD	\$(touch "$pwned")	Reject weak fixes.
DOC

LESSON_ROOT="$tmp" SAFEFLOW_SECURITY_POLICY_FILE="$tmp/docs/workflow/SAFEFLOW_SECURITY_BACKFILL.tsv" "$ROOT/tools/check_security_invariants.sh" >/tmp/security-invariants-shell.out 2>&1 && exit 1 || true
grep 'missing Security guard evidence pattern for no_prompt_only_security' /tmp/security-invariants-shell.out >/dev/null
if [[ -e "$pwned" ]]; then
  printf 'unsafe shell execution occurred while checking security evidence pattern\n' >&2
  exit 1
fi

printf 'Security guard invariant tests passed.\n'
