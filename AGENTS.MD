# AGENTS.MD

このファイルは、本教材リポジトリで作業するエージェント向けの入口です。
重要プロトコル、ドキュメントルート、repo-local skills の呼び出し先をここで接続します。

## 起動手順

エージェントは、ユーザーに `index.md` や `index-14-days.md` を探させません。
この `AGENTS.MD` を読んだうえで、ユーザーの意図に応じて内部的に正しい入口へ進みます。

```text
1. AGENTS.MDを読む
2. ユーザーが7日版か14日版を明示していない場合は、先にどちらで進めるか質問する
3. 選んだ版で学習モード、表示言語、成果物開発言語が未指定の場合は確認する
4. ルーティングテーブルで入口を選ぶ
5. 選んだ入口ドキュメントを読む
6. 必要なrepo-local skillを読む
7. 対応する検査コマンドで現在地を確認する
8. ユーザーには現在地、次の一問、必要なコピペ用プロンプトだけを提示し、承認を待つ
```

既定の入口:

```text
公開導入や教材全体の案内: README.md
7日版レッスン: index.md
14日版レッスン: index-14-days.md
```

## 不変ルール

1. 学習用リポジトリと成果物リポジトリは、2つのUbuntu/WSL CLI画面で分けて扱う。
   学習用は `$HOME/projects/ai-driven-development-lesson/`、成果物は `$HOME/projects/task-tracker-repository/` です。両方を同時並行で使うため、エージェントは作業前にどちらのCLI画面、どちらのGitリポジトリにいるか確認し、Git管理を混線させません。
   成果物リポジトリの開発に入る前には、必ず学習者へ別画面でUbuntu/WSL CLIを起動し、成果物リポジトリ専用画面として使うよう促します。

2. 既存機能とのトレードオフは一切禁止する。
   7日版、14日版、既存CI、既存チェック、既存ドキュメント導線を壊して新機能を入れることはできません。追加は既存機能と両立する形にします。

3. 実装とテストは、リファクタリング性、エコシステム性、再利用性、汎用性を満たす。
   固定値や場当たり的な分岐を増やさず、既存の設定ファイル、共通ライブラリ、検査コマンド、repo-local skills と接続できる設計にします。新しい検査は単体でも集約テストからでも使えるようにし、特定の成果物スタックだけに依存させません。

4. `AGENTS.MD` と `AGENT.md` を混同しない。
   `AGENTS.MD` は本教材リポジトリで最初に読むエージェント入口です。`AGENT.md` は成果物リポジトリ側で作るメモリー文書です。

5. 既存の7日版レッスンは正本として残す。
   `index.md`、`lesson/LESSON_FLOW.tsv`、`learning/LESSON_STATE.tsv`、`tools/lesson` は7日版の導線です。

6. 14日版レッスンは拡張版として扱う。
   14日版は `index-14-days.md`、`lesson/LESSON_FLOW_14_DAYS.tsv`、`learning/LESSON_STATE_14_DAYS.tsv`、`tools/lesson14` を使います。

7. 通常進行での未来ステップへのスキップは禁止する。
   7日版は `tools/lesson`、14日版は `tools/lesson14` の現在地だけを進めます。完了済みステップだけ復習できます。学習者が学びたい項目から開始したい場合だけ、`開始位置 <step_id> --confirm` で現在地を変更できます。

8. 各レッスン項目は、次へ進む前に必ずユーザー承認を得る。
   `開始`、作業実行、`通過`、次項目への移動を連続実行しません。現在地、目的、これから行うこと、必要なコピペ用プロンプトを提示し、「進めてよいですか？」への明示的な返答を待ちます。

9. 教材リポジトリと成果物リポジトリを入れ子にしない。
   成果物リポジトリは標準では `$HOME/projects/task-tracker-repository` です。作業前に必要なら `tools/check_repository_boundary.sh` を実行します。

10. 14日版の学習記録は14日版専用ファイルへ書く。
   `learning/LEARNING_TASK_TRACKER_14_DAYS.md` と `learning/LEARNING_HANDOFF_14_DAYS.md` を使い、7日版の学習記録とは混ぜません。

11. 同期ゲートを省略しない。
   14日版では `lesson/SYNC_GATES_14_DAYS.tsv` を正本とし、必要な Git 同期、CI 確認、文書同期を完了してから `tools/lesson14 通過` を実行します。

12. 危険操作、認証操作、曖昧な書き込みはユーザー確認を先に行う。
   認証情報、SSH鍵、GitHub device flow、破壊的 Git 操作、成果物リポジトリの公開や削除は確認なしに進めません。

13. 書き込み前にリポジトリ文脈を確認する。
   教材側で作業しているのか、成果物側で作業しているのかを `pwd`、`git rev-parse --show-toplevel`、境界チェックで確認します。

14. repo-local skills を優先して使う。
   14日版進行、同期ゲート、成果物文書作成に該当する作業では `skills/` 配下の該当スキルを読んでから進めます。

15. テストを通してから完了する。
    既存チェック、14日版チェック、AGENTS/skillsチェック、必要な GitHub Actions を確認します。

16. 7日版と14日版の説明量は学習モードに従う。
    Aは目的、利便性、専門用語、作業内容を詳しく説明します。Bは専門用語を短く補足します。Cは説明を省き、ワークフローのみ進めます。

17. 7日版と14日版の表示言語・成果物開発言語は同じ対応言語リストを使う。
    標準対応は `ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar` です。既存互換のため、`zh` は `zh-CN` の別名として扱います。対応リスト外の言語指定も `custom` として記録できる状態を維持します。

18. エージェントとの壁打ちを教材の中核として扱う。
    学習者の目的、利用者、制約、優先順位を質問で引き出し、要件、仕様、実装計画、検証方法へ整理します。サブエージェントを使う場合は、各担当の観点を統括役が目的に照らして採用、保留、却下します。

19. メニュー1〜7はGit管理設定を共有し、メニュー1〜6は開始前提条件も共有する。
    7日版、14日版、`3. 応用レッスン`、自由開発、成果物改善、外部連携を開始する前に、学習モード、表示言語、成果物開発言語、必要なリポジトリ境界、ユーザー承認を確認します。教材そのものの改善は、学習設定ではなく教材リポジトリのGit管理設定とユーザー承認を確認します。`status` は案内用として非ブロックのまま残し、`start`、`gate`、`check` で機械的に前提条件を検査します。`./tools/dashboard all` はメニュー1〜7の準備状態とGit管理設定を表示します。

## ドキュメントルート

| 用途 | 入口 |
| --- | --- |
| 公開リポジトリの導入 | `README.md` |
| 7日版レッスン入口 | `index.md` |
| 14日版レッスン入口 | `index-14-days.md` |
| GitHub初期設定 | `github-login-setup-guide.md` |
| 7日版体験開発 | `ai-driven-task-tracker-scenario.md` |
| 14日版ロードマップ | `learning/ROADMAP.md` |
| 文書マップ | `guides/DOCUMENT_MAP.md` |
| 14日版進行台本 | `playbooks/AGENT_PLAYBOOK_14_DAYS.md` |
| 14日版プロンプト | `prompts/PROMPTS_14_DAYS.md` |
| 14日版フロー | `lesson/LESSON_FLOW_14_DAYS.tsv` |
| 14日版同期ゲート | `lesson/SYNC_GATES_14_DAYS.tsv` |
| 14日版ヘルプデスク | `learning/HELP_DESK.md` |
| Gitワークフロー設定 | `docs/workflow/GIT_WORKFLOW_POLICY.tsv`、`learning/GIT_WORKFLOW_SETTINGS.tsv` |
| Git hooks設定 | `docs/workflow/GIT_HOOKS_POLICY.tsv`、`docs/workflow/GIT_HOOK_CHECKS.tsv`、`learning/GIT_HOOK_SETTINGS.tsv` |
| 成果物文書雛形 | `templates/TEMPLATES.md` |
| repo-local skills | `skills/*/SKILL.md` |

## ルーティングテーブル

| ユーザー意図 | 最初に読む | 使うスキル | 主なコマンド |
| --- | --- | --- | --- |
| メニューを表示したい | `docs/memory/DEVELOPER_MEMORY.md` のメニュー方針、`README.md` | なし | `./tools/menu` |
| ダッシュボードを見たい | `docs/memory/DEVELOPER_MEMORY.md` のダッシュボード方針 | なし | `./tools/dashboard all` |
| 文書の役割を知りたい | `guides/DOCUMENT_MAP.md`、`AGENTS.MD` | なし | `./tools/docs-tour status`、`./tools/dashboard docs` |
| 公開リポジトリから開始したい | `README.md` | なし | `git clone`、`./tools/lesson status` |
| レッスン開始、再開、現在地確認 | 意図に応じて `index.md` または `index-14-days.md` | 14日版なら `skills/lesson14-facilitator/SKILL.md` | `./tools/lesson status` または `./tools/lesson14 status` |
| 7日版を進めたい | `index.md` | なし | `./tools/check_lesson_structure.sh`、`./tools/lesson 学習モード <A\|B\|C>`、`./tools/lesson status` |
| 14日版を進めたい | `index-14-days.md` | `skills/lesson14-facilitator/SKILL.md` | `./tools/check_lesson14_structure.sh`、`./tools/lesson14 status` |
| 7日版か14日版を選びたい | `README.md`、`index.md`、`index-14-days.md` | `skills/lesson14-facilitator/SKILL.md` | 版選択、学習モード選択、表示言語選択、成果物開発言語選択 |
| 現在地やロードマップを知りたい | `learning/ROADMAP.md` | `skills/lesson14-facilitator/SKILL.md` | `./tools/roadmap status` |
| GitHub初期設定を進めたい | `github-login-setup-guide.md` | `skills/github-login-onboarding/SKILL.md` | `gh auth status -h github.com`、`ssh -T github.com` |
| 学習進捗、再開、中断、つまずき相談 | `learning/ROADMAP.md`、`learning/HELP_DESK.md` | `skills/learning-progress-helpdesk/SKILL.md` | `./tools/roadmap status`、`./tools/helpdesk 相談 "..."` |
| 同期ゲートを通したい | `lesson/SYNC_GATES_14_DAYS.tsv` | `skills/lesson-sync-gate/SKILL.md` | `./tools/check_lesson14_sync.sh`、`./tools/lesson14 通過 ...` |
| Git/CI同期を確認したい | `lesson/SYNC_GATES_14_DAYS.tsv` | `skills/lesson-sync-gate/SKILL.md` | `./tools/check_git_sync.sh --required`、`./tools/check_ci_status.sh --required` |
| Git管理設定を確認・変更したい | `docs/workflow/GIT_WORKFLOW_POLICY.tsv`、`learning/GIT_WORKFLOW_SETTINGS.tsv` | なし | `./tools/git-workflow status`、`./tools/git-workflow configure`、`./tools/git-workflow check` |
| Git hooks/pre-commit設定を確認・変更したい | `docs/workflow/GIT_HOOKS_POLICY.tsv`、`docs/workflow/GIT_HOOK_CHECKS.tsv`、`learning/GIT_HOOK_SETTINGS.tsv` | なし | `./tools/git-hooks status`、`./tools/git-hooks mode <full\|fast\|minimal>`、`./tools/git-hooks run --mode full --no-cache` |
| 成果物文書を作りたい | `templates/TEMPLATES.md` | `skills/task-tracker-docs/SKILL.md` | 境界確認後に更新案を提示 |
| TASK_TRACKER/HANDOFFを同期したい | `ai-driven-task-tracker-scenario.md`、`lesson/SYNC_GATES_14_DAYS.tsv` | `skills/worklog-doc-sync/SKILL.md`、`skills/lesson-sync-gate/SKILL.md` | 更新案、同期チェック、通過 |
| 3文書とTASK_TRACKER/HANDOFFの同期契約を確認したい | `docs/workflow/AS_BUILT_SYNC_CONTRACT.tsv`、`docs/as-built/REQUIREMENTS.md`、`docs/as-built/SPECIFICATION.md`、`docs/as-built/IMPLEMENTATION_PLAN.md`、`docs/workflow/TASK_TRACKER.md`、`docs/workflow/HANDOFF.md` | なし | `./tools/as-built-sync status`、`./tools/check_as_built_sync_contract.sh` |
| Playwright E2Eを扱う | `prompts/PROMPTS_14_DAYS.md` Step 10/14からStep 11/14 | `skills/lesson-sync-gate/SKILL.md` | ローカルE2E、CI、失敗復旧 |
| サブエージェントで精査する | `playbooks/AGENT_PLAYBOOK_14_DAYS.md` Step 12/14 | `skills/lesson-sync-gate/SKILL.md` | レビュー、テスト、同期確認 |
| スキル/MCPを体験する | `prompts/PROMPTS_14_DAYS.md` Step 13/14 | `skills/lesson14-facilitator/SKILL.md` | 最小構成で実施 |
| 全レッスン後に自由開発したい | `free-development/FREE_DEVELOPMENT_MODE.md` | `skills/worklog-doc-sync/SKILL.md`、`skills/lesson-sync-gate/SKILL.md` | `./tools/free-development start`、`./tools/free-development gate` |
| 成果物を改善したい | 成果物リポジトリの `REQUIREMENTS.md`、`SPECIFICATION.md`、`IMPLEMENTATION_PLAN.md`、`TASK_TRACKER.md`、`HANDOFF.md` | `skills/worklog-doc-sync/SKILL.md`、`skills/lesson-sync-gate/SKILL.md` | `./tools/product-improvement start --confirm`、`./tools/product-improvement gate` |
| 成果物リポジトリを削除したい | `docs/as-built/SPECIFICATION.md` の product repository cleanup、`docs/workflow/HANDOFF.md` | なし | `./tools/product-repository-cleanup status`、`./tools/product-repository-cleanup plan`、必要時のみ `local --confirm` または `remote --confirm` |
| 外部連携へ発展させたい | `free-development/FREE_DEVELOPMENT_MODE.md`、`prompts/PROMPTS_14_DAYS.md` Step 13/14 | `skills/lesson14-facilitator/SKILL.md`、`skills/worklog-doc-sync/SKILL.md` | 自由開発または既存成果物の要件・仕様から連携設計 |
| 教材そのものを改善したい | `docs/memory/DEVELOPER_MEMORY.md`、`docs/workflow/TASK_TRACKER.md`、`docs/workflow/HANDOFF.md` | `skills/lesson-sync-gate/SKILL.md` | `./tools/dashboard all`、各種チェック |
| `3. 応用レッスン` でチーム開発とDockerを学びたい | `advanced/TEAM_DEVELOPMENT_DOCKER.md` | `skills/lesson-sync-gate/SKILL.md`、`skills/worklog-doc-sync/SKILL.md` | `./tools/team-development start --confirm`、`./tools/team-development gate` |

## repo-local skills

```text
skills/github-login-onboarding/SKILL.md
skills/learning-progress-helpdesk/SKILL.md
skills/lesson14-facilitator/SKILL.md
skills/lesson-sync-gate/SKILL.md
skills/task-tracker-docs/SKILL.md
skills/worklog-doc-sync/SKILL.md
```

これらは本リポジトリに同梱された教材運用スキルです。
自動発見されない環境では、該当 `SKILL.md` を明示的に読んでから作業します。

## 標準検査

```bash
./tools/check_lesson_structure.sh
./tools/check_repository_boundary.sh
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/check_as_built_docs.sh
./tools/check_as_built_sync_contract.sh
./tools/as-built-sync status
./tools/test_docs_tour.sh
./tools/test_as_built_sync_contract.sh
./tools/test_git_workflow_policy.sh
./tools/test_git_hooks.sh
./tools/test_menu_prerequisites.sh
./tools/test_product_repository_cleanup.sh
./tools/test_lesson14.sh
```
