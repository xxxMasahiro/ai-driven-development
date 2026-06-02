#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

project_root="$tmp/projects"
product_name="sample-product"
product_repo="$project_root/$product_name"
origin="$tmp/origin.git"
config="$tmp/LESSON_CONFIG.tsv"
fake_bin="$tmp/bin"

mkdir -p "$project_root" "$fake_bin"

cat > "$config" <<CONFIG
# key	value
lesson_repo_name	ai-driven-development-lesson
product_repo_name	$product_name
project_root	$project_root
flow_file	lesson/LESSON_FLOW.tsv
state_file	learning/LESSON_STATE.tsv
learning_tracker_file	learning/LEARNING_TASK_TRACKER.md
learning_handoff_file	learning/LEARNING_HANDOFF.md
CONFIG

git -c init.defaultBranch=main init --bare "$origin" >/dev/null
git -c init.defaultBranch=main init "$product_repo" >/dev/null
git -C "$product_repo" config user.name "Lesson Test"
git -C "$product_repo" config user.email "lesson-test@example.com"
printf '# Sample Product\n' > "$product_repo/README.md"
git -C "$product_repo" add README.md
git -C "$product_repo" commit -m "Initial sample product" >/dev/null
git -C "$product_repo" remote add origin "$origin"
git -C "$product_repo" push -u origin main >/dev/null

cat > "$fake_bin/gh" <<'GH'
#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  auth)
    if [[ "${2:-}" == "token" ]]; then
      printf 'fake-token\n'
      exit 0
    fi
    ;;
  api)
    printf 'completed\tsuccess\tCI\tCI\tmain\t1\t0\t1s\t2026-06-02T00:00:00Z\n'
    exit 0
    ;;
  run)
    if [[ "${2:-}" == "list" ]]; then
      printf 'completed\tsuccess\tCI\tCI\tmain\t1\t0\t1s\t2026-06-02T00:00:00Z\n'
      exit 0
    fi
    ;;
  repo)
    if [[ "${2:-}" == "view" ]]; then
      printf 'xxxMasahiro/sample-product\n'
      exit 0
    fi
    ;;
esac

printf 'unsupported fake gh command: %s\n' "$*" >&2
exit 1
GH
chmod +x "$fake_bin/gh"

PATH="$fake_bin:$PATH" LESSON_CONFIG="$config" "$ROOT/tools/free-development" gate
PATH="$fake_bin:$PATH" LESSON_CONFIG="$config" "$ROOT/tools/team-development" gate

printf 'Product gate tool tests passed.\n'
