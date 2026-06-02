# AI Driven Development Lesson

AIエージェントと一問一答で進めながら、GitHub設定から小さなタスク管理表の体験開発まで学ぶための教材です。

この教材は、非エンジニアでもAI駆動開発の流れを体験できるように、エージェントが順番を案内し、必要なプロンプトを提示する前提で作られています。

## インストール

WSL/Ubuntuで次を実行してください。GitHubログインは不要です。公開リポジトリなので、読む・取得するだけなら誰でも使えます。

```bash
mkdir -p ~/projects
cd ~/projects
git clone https://github.com/xxxMasahiro/ai-driven-development-lesson.git
cd ai-driven-development-lesson
./tools/lesson status
```

すでに取得済みの教材を更新する場合は、次を実行します。

```bash
cd ~/projects/ai-driven-development-lesson
git pull
```

## レッスン版を選ぶ

この教材には2つの進め方があります。

```text
7日版: まず全体像を短く体験したい人向け
14日版: GitHub、CI、E2E、PR、サブエージェント、スキル、MCPまで順番に体験したい人向け
```

最初に、どちらで進めるかをAIエージェントに伝えてください。
迷う場合は、初回は14日版の「詳細解説が必要」モードを推奨します。
取得直後の状態確認だけなら `./tools/lesson status` と `./tools/lesson14 status` の両方を使えますが、学習開始前に必ず7日版か14日版を選びます。

## 学習モードと言語を選ぶ

7日版と14日版では、説明量を3段階から選びます。

```text
A: じっくり説明
   Git、CI、MCPなどの目的、利便性、専門用語を詳しく説明しながら進める
B: ほどよく説明
   専門用語や技術用語を短く補足しながら進める
C: 手順だけ
   解説を省き、作業手順だけで進める
```

レッスン開始時には、教材やワークフローを表示する言語と、成果物リポジトリ側の開発言語も選びます。
7日版は `./tools/lesson`、14日版は `./tools/lesson14` で記録します。

AIエージェントは、各レッスンを次へ進める前に必ずユーザーの承認を取ります。

## 最初にAIエージェントへ渡すプロンプト

教材ディレクトリを開いた状態で、AIエージェントに次を入力してください。

14日版:

```text
このリポジトリの index-14-days.md を読み、14日版レッスンを順番どおりに進めてください。
学習モードは A: じっくり説明 で進めてください。
表示言語と成果物開発言語は日本語で進めてください。
各レッスンは、次へ進む前に必ず私の承認を取ってください。
レッスン中に必要なプロンプトは、私がコピペできる形で提示してください。
```

7日版:

```text
このリポジトリの index.md を読み、順番を守ってレッスンを進めてください。
学習モードは A: じっくり説明 で進めてください。
表示言語と成果物開発言語は日本語で進めてください。
各レッスンは、次へ進む前に必ず私の承認を取ってください。
レッスン中に必要なプロンプトは、私がコピペできる形で提示してください。
```

7日版の入口は `index.md`、14日版の入口は `index-14-days.md` です。

## フォルダ構成

標準では、教材リポジトリと体験開発で作る成果物リポジトリを、同じ `~/projects` 配下の別ディレクトリとして扱います。
`task-tracker-repository` はレッスン中に作る成果物リポジトリ名の標準例です。教材側の検証だけを行う場合、このリポジトリは存在しなくても構いません。

```text
$HOME/projects/
├─ ai-driven-development-lesson/       この教材リポジトリ
└─ task-tracker-repository/     レッスン中に作る成果物リポジトリ
```

成果物リポジトリを教材の中に作らないことで、教材の管理と学習中に作るアプリの管理が混ざらなくなります。

プロジェクトルートや成果物リポジトリ名は、必要に応じて `lesson/LESSON_CONFIG.tsv` で変更できます。

## 主なファイル

```text
index.md                         7日版レッスンの入口
index-14-days.md                 14日版レッスンの入口
github-login-setup-guide.md      GitHub設定レッスン
ai-driven-task-tracker-scenario.md  AI駆動開発の体験レッスン
lesson/LESSON_CONFIG.tsv         パスやリポジトリ名の設定
lesson/LESSON_FLOW.tsv           レッスンの正しい進行順
learning/LESSON_STATE.tsv        現在の学習状態
learning/LEARNING_TASK_TRACKER.md 学習進捗の記録
learning/LEARNING_HANDOFF.md     直近の学習内容と次の作業
docs/as-built/REQUIREMENTS.md    教材側の要件
docs/as-built/SPECIFICATION.md   教材側の仕様
docs/as-built/IMPLEMENTATION_PLAN.md 教材側の実装計画
docs/workflow/TASK_TRACKER.md    教材側の作業進捗
docs/workflow/HANDOFF.md         教材側の引き継ぎ
docs/memory/DEVELOPER_MEMORY.md  教材側の開発者メモリー
tools/lesson                     レッスン順序の制御
tools/learn                      学習進捗の記録
tools/check_lesson_structure.sh  教材構成と進捗状態の検査
tools/check_repository_boundary.sh 教材と成果物の境界検査
tools/test_lesson_repository.sh  教材側だけの集約テスト
tools/test_product_gate_tools.sh 一時成果物リポジトリでFree/Teamゲートを検査
```

## よく使うコマンド

```bash
./tools/menu
./tools/dashboard all
./tools/lesson status
./tools/lesson14 status
./tools/lesson 学習モード <A|B|C>
./tools/lesson 表示言語 <ja|en|ko|zh>
./tools/lesson 開発言語 <ja|en|ko|zh>
./tools/lesson14 学習モード <A|B|C>
./tools/lesson14 表示言語 <ja|en|ko|zh>
./tools/lesson14 開発言語 <ja|en|ko|zh>
./tools/lesson 開始位置 <step-id> --confirm
./tools/lesson 開始 <step-id>
./tools/lesson 通過 <step-id> "完了メモ"
./tools/lesson 復習 <completed-step-id>
./tools/learn 現在地
./tools/learn 記録 "学習メモ"
./tools/learn 中断 "次回のためのメモ"
./tools/check_lesson_structure.sh
./tools/test_lesson_repository.sh
./tools/check_repository_boundary.sh
./tools/free-development status
./tools/free-development gate
./tools/team-development status
./tools/team-development gate
```

`./tools/menu` は、学ぶ、作る・発展させる、整える、という目的別に次の入口を表示します。
自由開発で成果物を作り、成果物を改善し、外部連携で発展させる流れを確認できます。

`tools/lesson` は、レッスンを順番通りに進めるための補助コマンドです。通常進行では未完了の未来の項目へスキップすることを防ぎ、完了済みの項目は自由に見返せるようにします。学びたい項目から始める場合は、明示確認つきの `開始位置` を使います。`status`、`start`、`start-at`、`pass`、`revisit` の英語エイリアスも使えます。

全レッスン完了後は、任意の成果物を選んで `free-development/FREE_DEVELOPMENT_MODE.md` のワークフローで自由開発できます。自由開発モードは既存レッスンを置き換えず、学んだ開発手順を実案件に適用するための追加モードです。

発展的要素として、`advanced/TEAM_DEVELOPMENT_DOCKER.md` でチーム開発とDockerを扱います。AI駆動開発を前提に、エージェントとの対話でチームの開発環境、Docker導入、デバッグ、CI、ドキュメント化を進めます。

## ライセンス

MIT
