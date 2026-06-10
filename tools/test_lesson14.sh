#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=tools/lib/fixture_copy.sh
source "$ROOT/tools/lib/fixture_copy.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
export HOME="$work/home"
mkdir -p "$HOME/projects"

fixture_copy_repo "$ROOT" "$work/lesson"
cd "$work/lesson"

./tools/lesson14 初期化 --confirm | grep 'STEP 1-14: 実践レッスンの実行状態を最初のセットアップ項目へ戻しました'

./tools/check_lesson_structure.sh
./tools/check_repository_boundary.sh >/dev/null
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_developer_memory_requirements.sh
./tools/lesson14 現在地 | grep './tools/lesson14 開始 setup.index'
./tools/lesson14 一覧 | grep 'Step 14/14.*STEP 1-14: 実践レッスンを完了する'
./tools/roadmap 現在地 | grep './tools/lesson14 開始 setup.index'
./tools/roadmap Step 14/14 | grep 'Step 14/14.*STEP 1-14: 実践レッスンを完了する'

bad_duplicate="$work/bad-duplicate"
fixture_copy_repo "$work/lesson" "$bad_duplicate"
awk -F '\t' '$1 !~ /^#/ && $2 == "setup.index" { print; exit }' "$bad_duplicate/lesson/LESSON_FLOW_14_DAYS.tsv" >> "$bad_duplicate/lesson/LESSON_FLOW_14_DAYS.tsv"
(cd "$bad_duplicate" && ./tools/check_lesson14_structure.sh >/tmp/lesson14-duplicate.out 2>&1 && exit 1 || true)
grep 'duplicate flow' /tmp/lesson14-duplicate.out >/dev/null

bad_empty="$work/bad-empty-required-output"
fixture_copy_repo "$work/lesson" "$bad_empty"
tmp_flow="$(mktemp)"
awk -F '\t' -v OFS='\t' '$1 !~ /^#/ && $2 == "day1.roadmap" { $5 = "" } { print }' "$bad_empty/lesson/LESSON_FLOW_14_DAYS.tsv" > "$tmp_flow"
mv "$tmp_flow" "$bad_empty/lesson/LESSON_FLOW_14_DAYS.tsv"
(cd "$bad_empty" && ./tools/check_lesson14_structure.sh >/tmp/lesson14-empty-required.out 2>&1 && exit 1 || true)
grep 'empty flow field' /tmp/lesson14-empty-required.out >/dev/null

bad_entry="$work/bad-entry"
fixture_copy_repo "$work/lesson" "$bad_entry"
tmp_flow="$(mktemp)"
awk -F '\t' -v OFS='\t' '$1 !~ /^#/ && $2 == "setup.index" { $4 = "index.mdでレッスン全体とSTEP 1-14の入口を確認する" } { print }' "$bad_entry/lesson/LESSON_FLOW_14_DAYS.tsv" > "$tmp_flow"
mv "$tmp_flow" "$bad_entry/lesson/LESSON_FLOW_14_DAYS.tsv"
(cd "$bad_entry" && ./tools/check_lesson14_sync.sh >/tmp/lesson14-bad-entry.out 2>&1 && exit 1 || true)
grep '14-day setup index entry' /tmp/lesson14-bad-entry.out >/dev/null

bad_learning_files="$work/bad-learning-files"
fixture_copy_repo "$work/lesson" "$bad_learning_files"
tmp_gates="$(mktemp)"
awk -F '\t' -v OFS='\t' '$1 !~ /^#/ && $1 == "Step 1/14" { $2 = "LEARNING_TASK_TRACKER.md,LEARNING_HANDOFF.md" } { print }' "$bad_learning_files/lesson/SYNC_GATES_14_DAYS.tsv" > "$tmp_gates"
mv "$tmp_gates" "$bad_learning_files/lesson/SYNC_GATES_14_DAYS.tsv"
(cd "$bad_learning_files" && ./tools/check_lesson14_sync.sh >/tmp/lesson14-bad-learning-files.out 2>&1 && exit 1 || true)
grep 'sync gates must use 14-day learning files only' /tmp/lesson14-bad-learning-files.out >/dev/null

bad_day14_gate="$work/bad-day14-gate"
fixture_copy_repo "$work/lesson" "$bad_day14_gate"
tmp_gates="$(mktemp)"
awk -F '\t' -v OFS='\t' '$1 !~ /^#/ && $1 == "Step 14/14" { $6 = "tools/check_ci_status.sh --required" } { print }' "$bad_day14_gate/lesson/SYNC_GATES_14_DAYS.tsv" > "$tmp_gates"
mv "$tmp_gates" "$bad_day14_gate/lesson/SYNC_GATES_14_DAYS.tsv"
(cd "$bad_day14_gate" && ./tools/check_lesson14_sync.sh >/tmp/lesson14-bad-day14-gate.out 2>&1 && exit 1 || true)
grep 'Step 14/14 must use required git sync check' /tmp/lesson14-bad-day14-gate.out >/dev/null

bad_day14_launch_gate="$work/bad-day14-launch-gate"
fixture_copy_repo "$work/lesson" "$bad_day14_launch_gate"
tmp_gates="$(mktemp)"
awk -F '\t' -v OFS='\t' '$1 !~ /^#/ && $1 == "Step 14/14" { $6 = "tools/check_git_sync.sh --product --required && tools/check_ci_status.sh --product --required" } { print }' "$bad_day14_launch_gate/lesson/SYNC_GATES_14_DAYS.tsv" > "$tmp_gates"
mv "$tmp_gates" "$bad_day14_launch_gate/lesson/SYNC_GATES_14_DAYS.tsv"
(cd "$bad_day14_launch_gate" && ./tools/check_lesson14_sync.sh >/tmp/lesson14-bad-day14-launch-gate.out 2>&1 && exit 1 || true)
grep 'Step 14/14 must use product launch check' /tmp/lesson14-bad-day14-launch-gate.out >/dev/null

./tools/lesson14 通過 day2.git-basics "future step" >/tmp/lesson14-future.out 2>&1 && exit 1 || true
grep 'locked' /tmp/lesson14-future.out >/dev/null

./tools/lesson14 通過 setup.index >/tmp/lesson14-empty-pass.out 2>&1 && exit 1 || true
grep 'pass memo is required' /tmp/lesson14-empty-pass.out >/dev/null

./tools/lesson14 復習 setup.index >/tmp/lesson14-revisit-current.out 2>&1 && exit 1 || true
grep 'only completed steps' /tmp/lesson14-revisit-current.out >/dev/null

./tools/lesson14 開始 setup.index >/tmp/lesson14-start-approval-required.out 2>&1 && exit 1 || true
grep 'Approval required' /tmp/lesson14-start-approval-required.out >/dev/null
grep '質問や気になる点' /tmp/lesson14-start-approval-required.out >/dev/null
./tools/lesson14 承認 start setup.index "ユーザーがsetup.indexの開始を承認した"
./tools/lesson14 開始 setup.index | grep 'Started current step'

./tools/lesson14 通過 setup.index "STEP 1-14の目的と順番を確認した" >/tmp/lesson14-approval-required.out 2>&1 && exit 1 || true
grep 'Approval required' /tmp/lesson14-approval-required.out >/dev/null

./tools/lesson14 承認 pass setup.index "ユーザーがsetup.indexの通過を承認した"
./tools/lesson14 通過 setup.index "STEP 1-14の目的と順番を確認した" >/tmp/lesson14-mode-required.out 2>&1 && exit 1 || true
grep 'Learning mode is required' /tmp/lesson14-mode-required.out >/dev/null
./tools/lesson14 学習モード A | grep 'Learning mode recorded: A'
./tools/lesson14 通過 setup.index "STEP 1-14の目的と順番を確認した" >/tmp/lesson14-language-required.out 2>&1 && exit 1 || true
grep 'Workflow display language is required' /tmp/lesson14-language-required.out >/dev/null
grep 'Product development language is required' /tmp/lesson14-language-required.out >/dev/null
./tools/lesson14 表示言語 ja | grep 'Workflow display language recorded: ja'
./tools/lesson14 開発言語 ja | grep 'Product development language recorded: ja'
product_repo="$HOME/projects/task-tracker-repository"
git -c init.defaultBranch=main init "$product_repo" >/dev/null
git -C "$product_repo" config user.name "Lesson14 Test"
git -C "$product_repo" config user.email "lesson14-test@example.com"
./tools/product-profile set --menu 2 --accept-recommended --confirm >/dev/null
./tools/lesson14 通過 setup.index "STEP 1-14の目的と順番を確認した"
./tools/lesson14 現在地 | grep './tools/lesson14 開始 setup.github-login'
./tools/lesson14 復習 setup.index | grep 'Revisit allowed'
./tools/lesson14 現在地 | grep './tools/lesson14 開始 setup.github-login'
./tools/lesson14 承認 pass setup.github-login "ユーザーがsetup.github-loginの通過を承認した"
./tools/lesson14 通過 setup.github-login "GitHub接続を確認した"
./tools/lesson14 現在地 | grep './tools/lesson14 開始 day1.roadmap'
./tools/lesson14 学習モード C | grep 'Learning mode recorded: C'
./tools/lesson14 学習モード | grep 'Current learning mode: C'
./tools/lesson14 表示言語 zh | grep 'Workflow display language recorded: zh-CN'
./tools/lesson14 開発言語 es | grep 'Product development language recorded: es'
./tools/lesson14 表示言語 | grep 'Current workflow display language: zh-CN'
./tools/lesson14 開発言語 | grep 'Current product development language: es'

./tools/helpdesk 相談 "テスト用の相談"
./tools/helpdesk 解決 "テスト用の解決"
./tools/helpdesk 一覧 | grep 'テスト用の相談'
./tools/helpdesk 一覧 | grep 'テスト用の解決'

./tools/check_lesson14_structure.sh

rm -rf "$product_repo"
gate_product_missing="$work/gate-product-missing"
fixture_copy_repo "$work/lesson" "$gate_product_missing"
rm -rf "$gate_product_missing/.git"
cd "$gate_product_missing"
git init -b main >/dev/null
tmp_state="$(mktemp)"
awk -F '\t' -v OFS='\t' '
  /^#/ { print; next }
  $2 == "day3.sync-gate" { $3 = "current"; $4 = ""; $5 = ""; print; next }
  $1 + 0 < 14 { $3 = "completed"; if ($4 == "") $4 = "2026-06-01 00:00:00"; if ($5 == "") $5 = "2026-06-01 00:00:00"; print; next }
  { $3 = "locked"; $4 = ""; $5 = ""; print }
' learning/LESSON_STATE_14_DAYS.tsv > "$tmp_state"
mv "$tmp_state" learning/LESSON_STATE_14_DAYS.tsv
git add .
git -c user.name=Test -c user.email=test@example.com commit -m gate >/dev/null
./tools/lesson14 承認 pass day3.sync-gate "ユーザーがStep 3/14同期ゲートの通過試行を承認した"
./tools/lesson14 通過 day3.sync-gate "should fail without product repository" >/tmp/lesson14-gate-product-missing.out 2>&1 && exit 1 || true
grep 'expected product repository does not exist' /tmp/lesson14-gate-product-missing.out >/dev/null

git_check="$work/git-check"
mkdir "$git_check"
cd "$git_check"
git init -b main >/dev/null
printf 'x\n' > file.txt
git add file.txt
git -c user.name=Test -c user.email=test@example.com commit -m initial >/dev/null
"$work/lesson/tools/check_git_sync.sh" --required >/tmp/lesson14-git-no-upstream.out 2>&1 && exit 1 || true
grep 'Upstream: none' /tmp/lesson14-git-no-upstream.out >/dev/null
git init --bare --initial-branch=main "$work/origin.git" >/dev/null
git remote add origin "$work/origin.git"
git push -u origin main >/dev/null
"$work/lesson/tools/check_git_sync.sh" --required | grep 'Git sync: local and upstream match'
printf 'dirty\n' >> file.txt
"$work/lesson/tools/check_git_sync.sh" >/tmp/lesson14-git-dirty-optional.out 2>&1
grep 'Working tree: dirty' /tmp/lesson14-git-dirty-optional.out >/dev/null
"$work/lesson/tools/check_git_sync.sh" --clean-required >/tmp/lesson14-git-dirty-clean-required.out 2>&1 && exit 1 || true
grep 'Working tree: dirty' /tmp/lesson14-git-dirty-clean-required.out >/dev/null
"$work/lesson/tools/check_git_sync.sh" --required >/tmp/lesson14-git-dirty.out 2>&1 && exit 1 || true
grep 'Working tree: dirty' /tmp/lesson14-git-dirty.out >/dev/null

fake_bin="$work/fake-bin"
mkdir "$fake_bin"
cat > "$fake_bin/gh" <<'GH'
#!/usr/bin/env bash
if [[ "$1 $2 $3 $4" == "auth status -h github.com" ]]; then
  exit 0
fi

if [[ "$1 $2" == "auth token" ]]; then
  printf 'fake-token\n'
  exit 0
fi

if [[ "$1 $2 $3 $4 $5" == "repo view --json nameWithOwner --jq" ]]; then
  printf 'owner/repo\n'
  exit 0
fi

if [[ "$1" == "api" ]]; then
  if printf '%s\n' "$*" | grep -q '/jobs'; then
    if printf '%s\n' "$*" | grep -q '/runs/2/jobs'; then
      printf 'aggregate-and-full-hooks\tcompleted\tfailure\n'
    else
      printf 'syntax-checks\tcompleted\tsuccess\n'
      printf 'aggregate-and-full-hooks\tcompleted\tsuccess\n'
    fi
    exit 0
  fi
  if printf '%s\n' "$*" | grep -q '/actions/runs/42'; then
    printf 'completed\tsuccess\tCI\told-branch\told-sha\t42\t2026-05-01T00:00:00Z\n'
    exit 0
  fi
  if printf '%s\n' "$*" | grep -q 'branch=api-empty'; then
    exit 0
  fi
  if printf '%s\n' "$*" | grep -q 'branch=fail'; then
    printf 'completed\tfailure\tCI\tfail\t\t2\t2026-06-01T00:00:00Z\n'
    printf 'completed\tsuccess\tLesson14 CI\tfail\t\t3\t2026-06-01T00:00:00Z\n'
  else
    printf 'completed\tsuccess\tCI\tmain\t\t1\t2026-06-01T00:00:00Z\n'
    printf 'completed\tsuccess\tLesson14 CI\tmain\t\t3\t2026-06-01T00:00:00Z\n'
  fi
  exit 0
fi

if [[ "$1 $2" == "run list" ]]; then
  branch="main"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --branch)
        branch="$2"
        shift 2
        ;;
      *)
        shift
        ;;
    esac
  done
  if [[ "$branch" == "fail" ]]; then
    printf 'completed\tfailure\tCI\tCI\tfail\tpush\t2\t1s\t2026-06-01T00:00:00Z\n'
  else
    printf 'completed\tsuccess\tCI\tCI\t%s\tpush\t1\t1s\t2026-06-01T00:00:00Z\n' "$branch"
  fi
  exit 0
fi

printf 'unexpected gh args: %s\n' "$*" >&2
exit 1
GH
chmod +x "$fake_bin/gh"
PATH="$fake_bin:$PATH" "$work/lesson/tools/check_ci_status.sh" --required --branch main | grep 'CI status: latest run succeeded'
PATH="$fake_bin:$PATH" "$work/lesson/tools/check_ci_status.sh" --workflow CI --branch main | grep 'CI status: latest run succeeded'
PATH="$fake_bin:$PATH" "$work/lesson/tools/check_ci_status.sh" --branch api-empty | grep 'CI status: latest run succeeded'
PATH="$fake_bin:$PATH" "$work/lesson/tools/check_ci_status.sh" --required --branch api-empty --commit missing-sha >/tmp/lesson14-ci-api-empty-commit.out 2>&1 && exit 1 || true
grep 'No GitHub Actions runs found' /tmp/lesson14-ci-api-empty-commit.out >/dev/null
PATH="$fake_bin:$PATH" "$work/lesson/tools/check_ci_status.sh" --run-id 42 --branch old-branch --commit old-sha | grep 'CI status: latest run succeeded'
PATH="$fake_bin:$PATH" "$work/lesson/tools/check_ci_status.sh" --required --run-id 42 --branch main --commit different-sha >/tmp/lesson14-ci-run-id-mismatch.out 2>&1 && exit 1 || true
grep 'No GitHub Actions runs matched the requested target' /tmp/lesson14-ci-run-id-mismatch.out >/dev/null
PATH="$fake_bin:$PATH" "$work/lesson/tools/check_ci_status.sh" --required --branch fail >/tmp/lesson14-ci-fail.out 2>&1 && exit 1 || true
grep 'CI status: latest run is not successful' /tmp/lesson14-ci-fail.out >/dev/null
cd "$work/lesson"
PATH="$fake_bin:$PATH" ./tools/check_ci_status.sh --required --branch main | grep 'CI status: required workflows succeeded'
PATH="$fake_bin:$PATH" ./tools/check_ci_status.sh --required --branch fail >/tmp/lesson14-required-ci-fail.out 2>&1 && exit 1 || true
grep 'CI status: one or more required workflows are not successful' /tmp/lesson14-required-ci-fail.out >/dev/null
custom_ci_repo="$work/custom-ci-repo"
mkdir -p "$custom_ci_repo/.github/workflows"
cd "$custom_ci_repo"
git init -b main >/dev/null
printf 'name: CI\n' > .github/workflows/ci.yml
printf 'name: Lesson14 CI\n' > .github/workflows/lesson14-ci.yml
printf 'custom\n' > README.md
git add .
git -c user.name=Test -c user.email=test@example.com commit -m custom-ci >/dev/null
git remote add origin https://github.com/owner/repo.git
PATH="$fake_bin:$PATH" "$work/lesson/tools/check_ci_status.sh" --repo "$custom_ci_repo" --required --branch main | grep 'CI status: latest run succeeded'

product_repo="$HOME/projects/task-tracker-repository"
mkdir -p "$product_repo"
cd "$product_repo"
git init -b main >/dev/null
cat > README.md <<'DOC'
# Task Tracker

Open `index.html` directly to use the completed product.
DOC
cat > index.html <<'HTML'
<!doctype html>
<html lang="en">
  <body>
    <form id="task-form">
      <input id="task-title" name="title" />
      <button type="submit">Add Task</button>
    </form>
    <ul id="task-list"></ul>
    <script src="app.js"></script>
  </body>
</html>
HTML
cat > app.js <<'JS'
const form = document.querySelector("#task-form");
const list = document.querySelector("#task-list");
form.addEventListener("submit", (event) => {
  event.preventDefault();
  const item = document.createElement("li");
  item.textContent = document.querySelector("#task-title").value;
  list.appendChild(item);
});
JS
git add README.md index.html app.js
git -c user.name=Test -c user.email=test@example.com commit -m initial-product >/dev/null

gate_required="$work/gate-required"
fixture_copy_repo "$work/lesson" "$gate_required"
rm -rf "$gate_required/.git"
cd "$gate_required"
git init -b main >/dev/null
tmp_state="$(mktemp)"
awk -F '\t' -v OFS='\t' '
  /^#/ { print; next }
  $2 == "day14.release-readiness" { $3 = "current"; $4 = ""; $5 = ""; print; next }
  $1 + 0 < 56 { $3 = "completed"; if ($4 == "") $4 = "2026-06-01 00:00:00"; if ($5 == "") $5 = "2026-06-01 00:00:00"; print; next }
  { $3 = "locked"; $4 = ""; $5 = ""; print }
' learning/LESSON_STATE_14_DAYS.tsv > "$tmp_state"
mv "$tmp_state" learning/LESSON_STATE_14_DAYS.tsv
git add .
git -c user.name=Test -c user.email=test@example.com commit -m gate >/dev/null
./tools/lesson14 承認 pass day14.release-readiness "ユーザーがStep 14/14 release readinessの通過試行を承認した"
./tools/lesson14 通過 day14.release-readiness "should fail without upstream" >/tmp/lesson14-gate-required.out 2>&1 && exit 1 || true
grep 'Upstream: none' /tmp/lesson14-gate-required.out >/dev/null
git -C "$product_repo" init --bare --initial-branch=main "$work/product-origin.git" >/dev/null
git -C "$product_repo" remote add origin "$work/product-origin.git"
git -C "$product_repo" push -u origin main >/dev/null
PATH="$fake_bin:$PATH" ./tools/lesson14 通過 day14.release-readiness "main同期とCIを確認した" | grep 'Passed step'
./tools/lesson14 status | grep './tools/lesson14 開始 day14.retrospective'

cd "$work/lesson"

printf 'Lesson14 CLI tests passed.\n'
