# AI駆動開発レッスン入口

このファイルは、7日版レッスンの入口です。
14日版で進める場合は `index-14-days.md` を使います。
学習者もエージェントも、学習開始前に7日版か14日版を選んでから進めます。

## 全体の進む順番

```text
1. index.mdで全体像と順番を確認する
2. github-login-setup-guide.mdでGitHub接続設定を確認する
3. tools/check_lesson_structure.shで教材構成を確認する
4. tools/lesson 現在地で今進める項目を確認する
5. ai-driven-task-tracker-scenario.mdで体験開発を進める
```

## 使うファイル

| ファイル | 目的 |
| --- | --- |
| `index.md` | レッスン全体の入口と進行順を示す |
| `github-login-setup-guide.md` | GitHub接続設定を行う |
| `ai-driven-task-tracker-scenario.md` | タスク管理表を題材にAI駆動開発を体験する |
| `README.md` | 公開リポジトリ向けの概要と導入手順 |
| `LICENSE` | MITライセンス |
| `guides/LESSON_GUIDE.md` | 学習者向けの短い案内 |
| `playbooks/AGENT_PLAYBOOK.md` | エージェント向けの進行台本 |
| `prompts/PROMPTS.md` | コピペ用プロンプト集 |
| `templates/TEMPLATES.md` | 作成するMarkdownの雛形 |
| `lesson/LESSON_CONFIG.tsv` | リポジトリ名、配置、主要ファイル名の設定 |
| `lesson/LESSON_FLOW.tsv` | レッスンの正しい通過順 |
| `learning/LESSON_STATE.tsv` | 現在位置、完了済み、未解放の状態 |
| `learning/LEARNING_TASK_TRACKER.md` | 学習者の進捗記録 |
| `learning/LEARNING_HANDOFF.md` | 次回再開用の学習引き継ぎ |
| `tools/lesson` | 順番どおりの開始、通過、復習を制御する |
| `tools/learn` | 学習進捗を短いコマンドで記録する |
| `tools/check_lesson_structure.sh` | 教材構成と状態ファイルを検査する |
| `tools/check_repository_boundary.sh` | 教材リポジトリと成果物リポジトリの境界を確認する |
| `.githooks/pre-commit` | コミット前に教材構成と境界を自動検査する |

## エージェントの開始手順

```text
1. このindex.mdを読む
2. tools/check_lesson_structure.shを実行する
3. tools/check_repository_boundary.shを実行する
4. tools/lesson 現在地を実行する
5. 現在項目がsetup.indexなら、このindex.mdの内容を短く説明して通過確認する
6. 現在項目がsetup.github-loginなら、github-login-setup-guide.mdを使ってGitHub接続を確認する
7. setup.github-loginを通過したら、ai-driven-task-tracker-scenario.mdへ進む
8. 以降はtools/lessonが示す現在項目だけを進める
```

## リポジトリ境界

教材リポジトリと、レッスンで作る成果物リポジトリは入れ子にしません。  
どちらも `$HOME/projects/` 直下に並列で置きます。  
`$HOME` は学習者のホームディレクトリを表すため、ユーザーごとに実際のパスは変わります。
リポジトリ名や配置先を変えたい場合は、`lesson/LESSON_CONFIG.tsv` を変更します。
成果物リポジトリの開発に入る前には、別画面でUbuntu/WSL CLIを起動し、成果物リポジトリ専用画面として使います。

```text
$HOME/projects/
├─ ai-driven-development-lesson/       教材リポジトリ
└─ task-tracker-repository/     成果物リポジトリ
```

教材リポジトリで扱うもの:

```text
index.md
github-login-setup-guide.md
ai-driven-task-tracker-scenario.md
guides/
prompts/
templates/
playbooks/
lesson/
  LESSON_CONFIG.tsv
learning/
tools/
```

成果物リポジトリで扱うもの:

```text
AGENT.md
REQUIREMENTS.md
SPECIFICATION.md
IMPLEMENTATION_PLAN.md
TASK_TRACKER.md
HANDOFF.md
SESSION_MEMORY.md
FAILURE_MEMORY.md
DEVELOPER_MEMORY.md
index.html
style.css
app.js
README.md
```

作業前には、必要に応じて次で現在地を確認します。

```bash
pwd
git rev-parse --show-toplevel
./tools/check_repository_boundary.sh
```

`task-tracker-repository/` が `ai-driven-development-lesson/` の中にある場合は誤配置です。

## Git管理

この教材ディレクトリ自体は、教材リポジトリとしてGit管理します。  
成果物リポジトリは教材リポジトリの中には作らず、`$HOME/projects/` 直下に並列で作ります。

教材リポジトリでは、コミット前に次の検査が自動で走ります。

```text
tools/check_lesson_structure.sh
tools/check_repository_boundary.sh
tools/check_agents_skills.sh
```

Git hooksは `.githooks/pre-commit` に置き、`core.hooksPath` で有効化します。

## スキップ禁止ルール

通常進行では、未完了の未来項目には進めません。
完了済みの項目だけ、復習として自由に戻れます。
学びたい項目から始める場合は、明示確認つきで開始位置を変更できます。

```bash
./tools/lesson 現在地
./tools/lesson 開始位置 <step_id> --confirm
./tools/lesson 開始 <step_id>
./tools/lesson 通過 <step_id> "通過条件を満たした内容"
./tools/lesson 復習 <completed_step_id>
```

`tools/lesson` が失敗した場合は、表示された現在項目に戻ります。

## GitHub設定から体験開発への切り替え

GitHub設定は、次が確認できたら完了扱いにします。

```text
github-login を実行し、GitHubへSSH接続できる
```

GitHub接続が確認できたら、次の順番で体験開発へ進みます。

```bash
./tools/lesson 通過 setup.github-login "github-loginでGitHub接続を確認した"
./tools/lesson 現在地
```

次の現在項目が `day1.mode` になったら、`ai-driven-task-tracker-scenario.md` を使います。

## 注意

`tools/lesson` と `tools/learn` を明示実行した場合は、`learning/` 配下へ直接機械記録します。  
それ以外のMarkdown編集や、体験開発で作るファイルの作成、更新は、エージェントが更新案を提示し、開発者の承認後に行います。
