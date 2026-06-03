**実装提案**

目的は、メモリ管理を「見える化」するだけでなく、ローカルとGitHub Actions CIの両方で安全に並列化を活用し、検証時間を短縮することです。ローカルは resource guard の実行時判定に従い、リモートCIは GitHub Actions runner 向けに最適化した job 分割で並列化します。

**解決したい課題**

- `status` は詳細すぎて、ユーザーが全体像を把握しにくい。
- `70%` 設定で `git-hooks-full` は4並列、`playwright` は2並列など、profile差が分かりにくい。
- 現状は推奨並列数を算出できるが、Git hooks full の各チェックはまだ基本的に直列。
- GitHub Actions も step が直列中心で、CI時間短縮の余地がある。
- ローカルPC向けのメモリ設定と、GitHub Actions runner 向けの並列設計を混同しやすい。

**対象範囲**

- `./tools/resource-guard summary`
- `./tools/resource-guard summary --short`
- ローカル Git hooks runner の限定並列化
- GitHub Actions workflow の job 分割
- resource guard によるローカル推奨並列数の利用
- CI専用の安全な並列構成の明文化
- 既存テスト・チェックを省略しないまま高速化する導線

**非対象範囲**

- `target_parallel_jobs` の追加
- 全profileを一律4並列にする変更
- Playwright や aggregate を無理に4並列へ上げる変更
- メモリ計算ロジックそのものの変更
- cleanup の削除仕様変更
- 既存チェックや既存CIの削除
- ローカルPCのメモリ設定をGitHub Actionsへそのまま反映すること

**実装方針**

ローカル並列化:

```text
1. resource guard が profile 別に推奨並列数を算出する。
2. git-hooks-full 実行時は git-hooks-full profile の推奨並列数を使う。
3. 現在の70%設定なら git-hooks-full は最大4 worker。
4. 並列可能なチェックだけを並列実行する。
5. Playwright や aggregate など重いチェックは専用profileの推奨値に従う。
6. resource guard が serial / serial-fallback / safe-stop を返した場合は直列または停止する。
7. ログはチェックごとに分離し、最終的に定義順で表示する。
```

GitHub Actions CI並列化:

```text
1. ローカルの memory_budget_percent はCIへそのまま適用しない。
2. GitHub Actions runner 向けにworkflow jobを分割する。
3. 独立して実行できるjobを並列化する。
4. 最後に aggregate / full hooks 系の最終ゲートを置く。
5. 既存チェックは省略しない。
```

CI job 分割案:

```text
並列フェーズ:
- syntax-checks
- structure-docs-checks
- policy-regression-tests
- lesson-cli-tests
- playwright-tests

最終ゲート:
- aggregate-and-full-hooks
```

`summary` 表示案:

```text
Resource guard summary

メモリ使用上限設定: 70%
最大並列上限: auto

ローカル profile別の推奨並列数:
- default: 4
- git-hooks-full: 4
- playwright: 2
- aggregate: 2

CI並列:
- GitHub Actions はローカルPCのメモリ設定ではなく、CI用に分割されたjob構成で並列実行します。
- ローカルの4並列とCIのjob並列は別の仕組みです。

補足:
並列数は作業の重さごとに変わります。
Git hooks full の4並列は、Playwright も4並列になるという意味ではありません。
```

**既存機能への影響**

- `status`、`monitor`、`recommend-jobs`、`check`、`cleanup` は維持する。
- `git-hooks run --mode full --no-cache` の意味は維持する。
- 7日版、14日版、メニュー、Git管理設定、docs/as-built、docs/workflow、docs/memory、pre-commit 導線は維持する。
- CIは既存チェックを削除せず、job分割で同じ検証を高速化する。
- 並列化できない状態では直列へ戻すため、安全側の挙動を維持する。

**必要な文書更新**

- `docs/as-built/REQUIREMENTS.md`
  - summary表示、ローカル並列化、CI並列化の要件を追加。
- `docs/as-built/SPECIFICATION.md`
  - `summary` / `summary --short`、ローカルworker、CI job分割仕様を追加。
- `docs/as-built/IMPLEMENTATION_PLAN.md`
  - 実装順序、検証方法、復旧方針を追加。
- `docs/workflow/TASK_TRACKER.md`
  - 作業項目として追加。
- `docs/workflow/HANDOFF.md`
  - 次回引き継ぎとして方針・注意点・未実装範囲を記録。
- `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv`
  - 実装時に sync ID を追加。
- 必要に応じて `docs/workflow/GIT_HOOK_CHECKS.tsv`
  - 並列可否または実行グループを管理する列/別ファイルを追加。

**必要なテスト**

- `./tools/resource-guard summary`
- `./tools/resource-guard summary --short`
- `./tools/resource-guard status --profile git-hooks-full`
- `./tools/resource-guard recommend-jobs --profile git-hooks-full`
- Git hooks 並列実行の単体テスト
- 並列不可時に直列へ戻るテスト
- 失敗時に正しく失敗扱いになるテスト
- ログが定義順に表示されるテスト
- `.githooks/pre-commit`
- `./tools/git-hooks run --mode minimal --no-cache`
- `./tools/git-hooks run --mode full --no-cache`
- `./tools/test_lesson_repository.sh`
- CI workflow 構造チェック
- GitHub Actions 実行確認

**想定リスク**

- 並列実行で同じ状態ファイルや一時ファイルを触るチェックが競合する。
  - 対策: 並列可能チェックを明示し、状態変更があるチェックは直列または専用グループにする。
- ログが混ざって読みにくくなる。
  - 対策: checkごとにログを分離し、最後に定義順で表示する。
- CI job分割で重複実行が増える。
  - 対策: 共通スクリプト化し、既存チェックの意味を保ったまま整理する。
- 「70%なら全部4並列」と誤解される。
  - 対策: `summary` に profile別推奨並列数とCI並列の違いを明示する。
- 高速化を優先して検査を省略したくなる。
  - 対策: 既存チェック削除は禁止。並列化は実行順序とjob分割の最適化に限定する。

この方針なら、既存機能とのトレードオフなしで、ユーザーに分かりやすいメモリ管理表示と、実際に効くローカル・CI並列化を両立できます。

**実装プラン**

方針は問題ありません。`summary`、ローカル Git hooks 並列化、GitHub Actions CI job 分割を、同じ resource guard 改善として実装します。

**変更対象**

- `tools/resource-guard`
  - `summary`
  - `summary --short`
  - 必要なら `summary --profile <profile>` は追加せず、まずは全profile表示に限定。

- `tools/lib/resource_guard.sh`
  - summary 表示用の共通関数を追加。
  - profile一覧取得関数を追加。
  - profile別推奨並列数の表示は既存 `resource_guard_recommended_jobs` を再利用。

- `tools/lib/git_hooks_policy.sh`
  - Git hooks 並列実行関数を追加。
  - 既存 `git_hooks_run_one` は再利用。
  - 並列実行時のログ分離、失敗集約、定義順出力を追加。
  - resource guard の推奨並列数を worker 数として使う。
  - safe-stop / serial-fallback 時は直列へ戻す、または既存 `check` の判定に従う。

- `tools/git-hooks`
  - `run` 実行時に、full/fast では resource guard 推奨値を受け取り、並列対応 runner を呼ぶ。
  - minimal は原則そのまま直列で維持。

- `docs/workflow/GIT_HOOK_CHECKS.tsv`
  - 既存列を壊さず、並列可否を追加する場合は別ファイルにする方が安全。
  - 推奨: `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv` を新設。
  - check_id、parallel_group、execution_kind を管理する。
  - 既存 `GIT_HOOK_CHECKS.tsv` は互換性維持のため変更最小。

- `.github/workflows/ci.yml`
  - job 分割。
  - syntax / structure-docs / policy-resource / lesson-cli / playwright / final-gate に分ける。

- `.github/workflows/lesson14-ci.yml`
  - 同様に job 分割。
  - lesson14 固有チェックと共通チェックを整理。

- 新規テスト
  - `tools/test_resource_guard_summary.sh`
  - `tools/test_git_hooks_parallel.sh`
  - 必要なら `tools/check_ci_workflow_structure.sh`

- 既存テスト接続
  - `tools/test_resource_guard.sh`
  - `tools/test_git_hooks.sh`
  - `tools/test_lesson_repository.sh`
  - `.githooks/pre-commit`
  - CI workflow

**実装順序**

1. 文書同期
   - 3文書と2文書へ、今回の実装プランを役割ごとに同期。
   - `AS_BUILT_SYNC_CONTRACT.tsv` に新 sync ID を追加。
   - 例: `resource_guard_summary_parallel_ci`
   - この段階では実装未完なら `planned`、実装後に `implemented` へ更新。

2. `summary` 実装
   - `tools/lib/resource_guard.sh` に profile一覧取得関数を追加。
   - `summary` と `summary --short` の表示関数を追加。
   - `tools/resource-guard` にサブコマンドを追加。
   - `status` など既存コマンドは変更しない。

3. `summary` テスト
   - `tools/test_resource_guard_summary.sh` を追加。
   - 実設定に依存しすぎないよう、テスト用 policy/settings を一時ファイルで渡す。
   - profile追加に追従できるか確認。
   - `summary --short` も確認。

4. Git hooks 並列化の設定追加
   - `docs/workflow/GIT_HOOK_PARALLEL_GROUPS.tsv` を追加。
   - 直列必須、並列可能、重いチェック、最終ゲートを分類。
   - 既存 `GIT_HOOK_CHECKS.tsv` は正本として残す。
   - 未定義 check は安全側で直列扱い。

5. ローカル Git hooks 並列 runner 実装
   - `git_hooks_run_checks_parallel` を追加。
   - worker数は `resource_guard_recommended_jobs git-hooks-full` から取得。
   - `serial` / `safe-stop` では直列または停止。
   - 並列対象だけ最大 worker 数で実行。
   - ログは一時ディレクトリへ分離し、定義順で表示。
   - 失敗時は全体失敗にする。

6. Git hooks 並列テスト
   - `tools/test_git_hooks_parallel.sh` を追加。
   - 並列可能checkが複数workerで走ること。
   - 直列checkは順序維持されること。
   - 失敗時に失敗checkが分かること。
   - worker数が resource guard 推奨値を超えないこと。
   - safe-stop時に並列化しないこと。

7. CI workflow job 分割
   - `.github/workflows/ci.yml` を job 分割。
   - `.github/workflows/lesson14-ci.yml` も job 分割。
   - 最終ゲート job は `needs` で並列フェーズ完了後に実行。
   - ローカル resource guard 設定はCIへそのまま流用しない。
   - CIでは GitHub Actions runner 向けの固定job分割にする。

8. CI構造テスト
   - `tools/check_ci_workflow_structure.sh` を追加する場合は、job名、needs、必須コマンド存在を検査。
   - 既存CIの意味が失われていないことを確認。

9. 集約接続
   - 新規テストを `tools/test_lesson_repository.sh` に接続。
   - `docs/workflow/GIT_HOOK_CHECKS.tsv` または既存 hook policy に接続。
   - pre-commit からも必要範囲が実行されるようにする。

10. 最終文書同期
   - `TASK_TRACKER.md` と `HANDOFF.md` を最終状態に更新。
   - `AS_BUILT_SYNC_CONTRACT.tsv` を `implemented` に更新。
   - as-built 3文書の sync block と実装内容を一致させる。

**文書同期方針**

- `REQUIREMENTS.md`
  - 何が必要か。
  - summary表示、ローカル並列化、CI並列化、安全制約を要件として記載。

- `SPECIFICATION.md`
  - どう動くか。
  - コマンド仕様、表示仕様、worker決定仕様、parallel group仕様、CI job分割仕様を記載。

- `IMPLEMENTATION_PLAN.md`
  - どの順番で作ったか/作るか。
  - 実装ステップ、テスト、復旧方針を記載。

- `TASK_TRACKER.md`
  - 現在の作業状態。
  - チェックリストで進捗管理。

- `HANDOFF.md`
  - 次回再開に必要な注意点。
  - 既存機能を壊さない条件、未完了があれば明記。

同じ文章を複製せず、各文書の役割に合わせて同期します。

**検証方法**

最低限:

```bash
bash -n tools/resource-guard tools/lib/resource_guard.sh tools/lib/git_hooks_policy.sh tools/git-hooks
./tools/test_resource_guard_summary.sh
./tools/test_resource_guard.sh
./tools/test_git_hooks_parallel.sh
./tools/test_git_hooks.sh
./tools/as-built-sync status
./tools/check_as_built_sync_contract.sh
./tools/check_as_built_docs.sh
./tools/check_workflow_pair_sync.sh
./tools/git-hooks run --mode minimal --no-cache
./tools/git-hooks run --mode full --no-cache
.githooks/pre-commit
./tools/test_lesson_repository.sh
```

必要に応じて:

```bash
./tools/check_ci_workflow_structure.sh
./tools/test_lesson_playwright.sh
```

リモート確認:

```bash
gh pr checks
# または GitHub Actions の該当run確認
```

**失敗時の復旧方針**

- `summary` 失敗:
  - 既存 `status` には触れず、summary関数だけ修正。
- Git hooks 並列化失敗:
  - 並列 runner を無効化し、既存直列 runnerへ戻せる設計にする。
  - ただし既存機能を削除しない。
- CI job 分割失敗:
  - job分割の `needs` と必須コマンドを確認。
  - 既存チェックを落とした場合は即修正。
- ログ混線:
  - checkごとのログファイル分離を強化。
- リソース不足:
  - resource guard 判定に従い、worker数を1へ落とす。
- 同じ失敗が3回続く場合:
  - 実装を止め、原因と承認が必要な判断を報告。

**開発者承認が必要な判断点**

- CI job 分割で、実行時間短縮のために既存チェックの重複を減らしたくなった場合。
- Playwright や aggregate を今より強く並列化したい場合。
- `GIT_HOOK_CHECKS.tsv` の列構造を直接変更したい場合。
- CI用の専用設定ファイルを追加したい場合。
- 既存の `full` / `fast` / `minimal` の意味を変える必要が出た場合。
- 並列化により一部チェックを直列専用に分類する必要が出た場合。

この実装プランなら、固定値や場当たり的な分岐を増やさず、既存の設定ファイル、共通ライブラリ、Git hooks、pre-commit、CI、集約テストと接続できます。

## Required Invariant Memory Records

Approval checkpoints now have tooling enforcement.

The 7-day lesson learning mode command is `tools/lesson 学習モード <A|B|C>`.
The 14-day lesson learning mode command is `tools/lesson14 学習モード <A|B|C>`.
Learning mode can be switched at any time during either lesson.

Standard language choices should include `ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar`, while preserving custom language recording where supported.

Implementation work must remain refactorable, ecosystem-friendly, reusable, and general.
Existing functionality must not be traded away.
Final tests pass only when every improvement or problem recorded in this developer memory is resolved, synchronized, and mechanically verified.

Explain MCP Purpose Before MCP Workflows.

## Subagent Verification Corrections For Resource Guard Summary And Parallel CI

The planned `resource_guard_summary_parallel_ci` implementation must include these corrections before runtime work is considered complete:

- CI workflow structure verification is required, not optional. The implementation must add a mechanical check that verifies required job names, `needs` relationships, and required commands so job splitting cannot accidentally remove existing coverage.
- The final GitHub Actions `aggregate-and-full-hooks` job must install npm dependencies and Playwright dependencies before running aggregate repository tests or full hooks, because GitHub Actions jobs do not share setup state from earlier jobs.
- CI and local resource behavior must stay explicitly separated. Local Playwright and Git hooks can use resource guard recommendations, while CI full hooks must keep the existing CI-safe local-resource bypass behavior such as `RESOURCE_GUARD_SKIP_LOCAL_CHECK=1` or an equivalent documented mechanism.
- Before `resource_guard_summary_parallel_ci` is moved from `planned` to `implemented`, `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv` must be updated from planning-only artifacts and tests to the actual runtime artifacts, runtime tests, and runtime evidence.
