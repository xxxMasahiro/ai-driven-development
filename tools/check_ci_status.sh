#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/lib/lesson_common.sh
source "$SCRIPT_DIR/lib/lesson_common.sh"

required=0
branch=""
workflow=""
commit=""
target_dir=""
target_label="current"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --required)
      required=1
      shift
      ;;
    --lesson)
      target_dir="$LESSON_ROOT"
      target_label="lesson"
      shift
      ;;
    --product)
      target_dir="$(lesson_product_repo_root)"
      target_label="product"
      shift
      ;;
    --repo)
      target_dir="$(lesson_expand_path "${2:-}")"
      [[ -n "$target_dir" ]] || { printf '%s\n' '--repo requires a value' >&2; exit 1; }
      target_label="custom"
      shift 2
      ;;
    --branch)
      branch="${2:-}"
      [[ -n "$branch" ]] || { printf '%s\n' '--branch requires a value' >&2; exit 1; }
      shift 2
      ;;
    --commit)
      commit="${2:-}"
      [[ -n "$commit" ]] || { printf '%s\n' '--commit requires a value' >&2; exit 1; }
      shift 2
      ;;
    --workflow)
      workflow="${2:-}"
      [[ -n "$workflow" ]] || { printf '%s\n' '--workflow requires a value' >&2; exit 1; }
      shift 2
      ;;
    *)
      printf 'unknown option: %s\n' "$1" >&2
      exit 1
      ;;
  esac
done

if [[ -n "$target_dir" ]]; then
  if [[ ! -d "$target_dir" ]]; then
    printf 'CI target does not exist: %s\n' "$target_dir" >&2
    [[ "$required" -eq 1 ]] && exit 1 || exit 0
  fi
  cd "$target_dir"
fi

printf 'CI target: %s\n' "$target_label"

gh_retry() {
  local attempt
  for attempt in 1 2 3 4 5; do
    if timeout 20 gh "$@"; then
      return 0
    fi
    sleep 5
  done
  return 1
}

if ! command -v gh >/dev/null 2>&1; then
  printf 'gh is not installed; CI status check skipped.\n'
  [[ "$required" -eq 1 ]] && exit 1 || exit 0
fi

if ! gh_retry auth token >/dev/null 2>&1; then
  printf 'gh is not authenticated; CI status check skipped.\n'
  [[ "$required" -eq 1 ]] && exit 1 || exit 0
fi

repo=""
remote_url="$(git remote get-url origin 2>/dev/null || true)"
case "$remote_url" in
  https://github.com/*/*.git)
    repo="${remote_url#https://github.com/}"
    repo="${repo%.git}"
    ;;
  https://github.com/*/*)
    repo="${remote_url#https://github.com/}"
    ;;
  git@github.com:*.git)
    repo="${remote_url#git@github.com:}"
    repo="${repo%.git}"
    ;;
  git@github.com:*)
    repo="${remote_url#git@github.com:}"
    ;;
esac

if [[ -z "$repo" ]]; then
  if ! repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null)"; then
    printf 'GitHub repository could not be resolved; CI status check skipped.\n'
    [[ "$required" -eq 1 ]] && exit 1 || exit 0
  fi
fi

if [[ -z "$branch" ]]; then
  branch="$(git branch --show-current 2>/dev/null || true)"
fi

if [[ -z "$commit" ]]; then
  commit="$(git rev-parse HEAD 2>/dev/null || true)"
fi

latest=""
if [[ -n "$branch" ]]; then
  latest="$(
    gh_retry api -X GET "repos/$repo/actions/runs" \
      -f per_page=10 \
      -f branch="$branch" \
      --jq '.workflow_runs[] | "\(.status)\t\(.conclusion // "")\t\(.name)\t\(.name)\t\(.head_branch)\t\(.id)\t0\t0s\t\(.created_at)"' \
      2>/dev/null | head -n 1 || true
  )"
fi

args=(run list --repo "$repo" --limit 1)
[[ -n "$branch" ]] && args+=(--branch "$branch")
[[ -n "$commit" ]] && args+=(--commit "$commit")
[[ -n "$workflow" ]] && args+=(--workflow "$workflow")
if [[ -z "$latest" ]]; then
  latest="$(gh_retry "${args[@]}" 2>/dev/null || true)"
fi
if [[ -z "$latest" && -n "$commit" ]]; then
  fallback_args=(run list --repo "$repo" --limit 1)
  [[ -n "$branch" ]] && fallback_args+=(--branch "$branch")
  [[ -n "$workflow" ]] && fallback_args+=(--workflow "$workflow")
  latest="$(gh_retry "${fallback_args[@]}" 2>/dev/null || true)"
  if [[ -z "$latest" ]]; then
    json_args=(run list --repo "$repo" --limit 1 --json status,conclusion,name,headBranch,databaseId,createdAt)
    [[ -n "$branch" ]] && json_args+=(--branch "$branch")
    [[ -n "$workflow" ]] && json_args+=(--workflow "$workflow")
    latest="$(gh_retry "${json_args[@]}" --jq '.[] | "\(.status)\t\(.conclusion)\t\(.name)\t\(.name)\t\(.headBranch)\t\(.databaseId)\t0\t0s\t\(.createdAt)"' 2>/dev/null || true)"
  fi
  if [[ -n "$latest" ]]; then
    printf 'Commit-specific CI lookup returned no runs; using latest branch run.\n'
  fi
fi
if [[ -z "$latest" ]]; then
  for _attempt in 1 2 3; do
    sleep 5
    retry_args=(run list --repo "$repo" --limit 1)
    [[ -n "$branch" ]] && retry_args+=(--branch "$branch")
    [[ -n "$workflow" ]] && retry_args+=(--workflow "$workflow")
    latest="$(gh_retry "${retry_args[@]}" 2>/dev/null || true)"
    if [[ -z "$latest" ]]; then
      retry_json_args=(run list --repo "$repo" --limit 1 --json status,conclusion,name,headBranch,databaseId,createdAt)
      [[ -n "$branch" ]] && retry_json_args+=(--branch "$branch")
      [[ -n "$workflow" ]] && retry_json_args+=(--workflow "$workflow")
      latest="$(gh_retry "${retry_json_args[@]}" --jq '.[] | "\(.status)\t\(.conclusion)\t\(.name)\t\(.name)\t\(.headBranch)\t\(.databaseId)\t0\t0s\t\(.createdAt)"' 2>/dev/null || true)"
    fi
    [[ -n "$latest" ]] && break
  done
fi
if [[ -z "$latest" ]]; then
  latest="$(
    gh_retry api -X GET "repos/$repo/actions/runs" \
      -f per_page=10 \
      -f branch="$branch" \
      --jq '.workflow_runs[] | "\(.status)\t\(.conclusion // "")\t\(.name)\t\(.name)\t\(.head_branch)\t\(.id)\t0\t0s\t\(.created_at)"' \
      2>/dev/null | head -n 1 || true
  )"
fi
if [[ -z "$latest" ]]; then
  printf 'No GitHub Actions runs found for %s.\n' "$repo"
  [[ -n "$commit" ]] && printf 'Commit: %s\n' "$commit"
  [[ "$required" -eq 1 ]] && exit 1 || exit 0
fi

printf '%s\n' "$latest"
if printf '%s\n' "$latest" | grep -q '^completed[[:space:]]\+success'; then
  printf 'CI status: latest run succeeded.\n'
else
  printf 'CI status: latest run is not successful.\n' >&2
  exit 1
fi
