# AI Driven Development Lesson

AIエージェントと一問一答で進めながら、GitHub設定から小さなタスク管理表の体験開発まで学ぶための教材です。

この教材は、非エンジニアでもAI駆動開発の流れを体験できるように、エージェントが順番を案内し、必要なプロンプトを提示する前提で作られています。

## インストール

WSL/Ubuntuで次を実行してください。GitHubログインは不要です。公開リポジトリなので、読む・取得するだけなら誰でも使えます。

```bash
mkdir -p ~/projects
cd ~/projects
git clone https://github.com/xxxMasahiro/ai-driven-development.git
cd ai-driven-development
./tools/lesson status
```

すでに取得済みの教材を更新する場合は、次を実行します。

```bash
cd ~/projects/ai-driven-development
git pull
```

## 最初にAIエージェントへ渡すプロンプト

教材ディレクトリを開いた状態で、AIエージェントに次を入力してください。

```text
このリポジトリの index.md を読み、順番を守ってレッスンを進めてください。
レッスン中に必要なプロンプトは、私がコピペできる形で提示してください。
```

最初に読む入口は `index.md` です。`index.md` が、GitHub設定レッスンから体験開発レッスンまでの進み方を統括します。

## フォルダ構成

標準では、教材リポジトリと体験開発で作る成果物リポジトリを、同じ `~/projects` 配下の別ディレクトリとして扱います。

```text
$HOME/projects/
├─ ai-driven-development/       この教材リポジトリ
└─ task-tracker-repository/     レッスン中に作る成果物リポジトリ
```

成果物リポジトリを教材の中に作らないことで、教材の管理と学習中に作るアプリの管理が混ざらなくなります。

プロジェクトルートや成果物リポジトリ名は、必要に応じて `lesson/LESSON_CONFIG.tsv` で変更できます。

## 主なファイル

```text
index.md                         レッスン全体の入口
github-login-setup-guide.md      GitHub設定レッスン
ai-driven-task-tracker-scenario.md  AI駆動開発の体験レッスン
lesson/LESSON_CONFIG.tsv         パスやリポジトリ名の設定
lesson/LESSON_FLOW.tsv           レッスンの正しい進行順
learning/LESSON_STATE.tsv        現在の学習状態
learning/LEARNING_TASK_TRACKER.md 学習進捗の記録
learning/LEARNING_HANDOFF.md     直近の学習内容と次の作業
tools/lesson                     レッスン順序の制御
tools/learn                      学習進捗の記録
tools/check_lesson_structure.sh  教材構成と進捗状態の検査
tools/check_repository_boundary.sh 教材と成果物の境界検査
```

## よく使うコマンド

```bash
./tools/lesson status
./tools/lesson 開始 <step-id>
./tools/lesson 通過 <step-id> "完了メモ"
./tools/lesson 復習 <completed-step-id>
./tools/learn 現在地
./tools/learn 記録 "学習メモ"
./tools/learn 中断 "次回のためのメモ"
./tools/check_lesson_structure.sh
./tools/check_repository_boundary.sh
```

`tools/lesson` は、レッスンを順番通りに進めるための補助コマンドです。未完了の未来の項目へスキップすることを防ぎ、完了済みの項目は自由に見返せるようにします。`status`、`start`、`pass`、`revisit` の英語エイリアスも使えます。

## ライセンス

MIT
