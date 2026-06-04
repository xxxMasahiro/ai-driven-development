# AI駆動開発 STEP 1-14: 実践レッスン入口

このファイルは、`STEP 1-14: 実践レッスン` の入口です。
`STEP 1-7: 基礎レッスン` の入口である `index.md` は変更せず、より実践的な拡張コースとして使います。

## STEP 1-14で重視すること

```text
AI駆動開発の目的、本質、開発方法を体験で理解する
Git管理とGitHub連携を実際に使う
CI、PR、main同期を体験する
TASK_TRACKER.mdとHANDOFF.mdで中断再開を体験する
PlaywrightによるE2Eテストを導入する
複数サブエージェントまたは役割プロンプトで多角的に精査する
小さなスキルと最小MCP連携を体験する
各Stepの最後に文書、履歴、Git、CIを同期する
```

## 学習モード

`STEP 1-14: 実践レッスン` を始める前に、説明量を選びます。

```text
A: 詳細解説が必要
   じっくり説明。各レッスンの目的、便利になる点、専門用語、技術用語を詳しく説明する。
B: 解説は補足程度
   ほどよく説明。作業前に専門用語や技術用語を短く補足する。
C: 解説不要でワークフローのみ
   手順だけ。解説を省き、必要な作業と確認だけを提示する。
```

初回1周目はA、復習の2周目以降はBまたはCを推奨します。
STEP 1-14では、選んだモードをファイルにも記録します。`setup.index` を通過する前に必ず次を実行します。
学習モードはレッスン中いつでも同じコマンドで切り替えられます。

```bash
./tools/lesson14 学習モード <A|B|C>
./tools/lesson14 学習モード
```

## 言語設定

レッスン本文やリポジトリ内の実装・ドキュメントは英語を維持します。
一方で、レッスン中に表示する説明文と、成果物リポジトリで作成する文書・画面文言は別々に選択できます。

```bash
./tools/lesson14 表示言語 ja
./tools/lesson14 表示言語
./tools/lesson14 開発言語 ja
./tools/lesson14 開発言語
```

`表示言語` は教材・ワークフローの説明表示に使います。
`開発言語` は成果物リポジトリ側の要件、仕様、実装計画、README、UI文言などに使います。
対応言語コードは `ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar` です。
`zh` は既存互換のため `zh-CN` として扱います。

## 承認ルール

各レッスン項目は、次へ進む前に必ずユーザーの承認を取ります。
エージェントは、現在地、目的、これから行うこと、必要なコピペ用プロンプトを提示し、ユーザーの「はい」「進めてください」などの明示的な返答を待ってから進みます。
STEP 1-14では、承認はファイルにも記録します。`開始` または `通過` の前に、必ず次の承認コマンドを実行します。

```bash
./tools/lesson14 承認 start <step_id> "ユーザーがこの項目の開始を承認した"
./tools/lesson14 承認 pass <step_id> "ユーザーがこの項目の通過を承認した"
```

## 最初に読むファイル

```text
1. index-14-days.md
2. learning/ROADMAP.md
3. guides/LESSON_14_DAYS.md
4. playbooks/AGENT_PLAYBOOK_14_DAYS.md
5. prompts/PROMPTS_14_DAYS.md
6. guides/DOCUMENT_MAP.md
7. lesson/LESSON_FLOW_14_DAYS.tsv
8. lesson/SYNC_GATES_14_DAYS.tsv
9. AGENTS.MD
10. skills/lesson14-facilitator/SKILL.md
```

## 最初に実行するコマンド

```bash
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/check_developer_memory_requirements.sh
./tools/docs-tour status
./tools/test_lesson_repository.sh
./tools/lesson14 status
./tools/roadmap status
```

`tools/test_production_operations.sh` は、成果物リポジトリを実際に用意して本番運用テストを行うときだけ実行します。

新しいSTEP 1-14運用テストや再受講を始める場合だけ、明示確認つきで実行状態を初期化します。

```bash
./tools/lesson14 初期化 --confirm
```

## レッスン制御

```bash
./tools/lesson14 status
./tools/lesson14 list
./tools/lesson14 初期化 --confirm
./tools/lesson14 開始位置 <step_id> --confirm
./tools/lesson14 学習モード <A|B|C>
./tools/lesson14 表示言語 <ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar>
./tools/lesson14 開発言語 <ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar>
./tools/lesson14 開始 <step_id>
./tools/lesson14 承認 start <step_id> "承認メモ"
./tools/lesson14 承認 pass <step_id> "承認メモ"
./tools/lesson14 通過 <step_id> "メモ"
./tools/lesson14 復習 <completed_step_id>
```

通常進行では、未来項目へのスキップは禁止です。
完了済み項目だけ、復習として自由に戻れます。
学びたい項目から始める場合は、明示確認つきで開始位置を変更できます。

## CLI画面の分離

成果物リポジトリの開発に入る前に、学習者は別画面でUbuntu/WSL CLIを起動します。
学習用リポジトリ `$HOME/projects/ai-driven-development-lesson/` と、成果物リポジトリ `$HOME/projects/task-tracker-repository/` を別々のCLI画面で扱うことで、Git管理の混線を防ぎます。

## 文書マップ

STEP 1-14では、要件、仕様、実装計画、タスクトラッカー、ハンドオフ、開発者メモリー、skills、AGENTS.MDを繰り返し使います。
文書が多く見える場合は、先に文書の役割を確認します。

```bash
./tools/docs-tour status
./tools/docs-tour all
./tools/dashboard docs
```

詳しい説明は `guides/DOCUMENT_MAP.md` にあります。

## ロードマップとヘルプデスク

```bash
./tools/roadmap status
./tools/roadmap show
./tools/roadmap "Step 10/14"
./tools/helpdesk 相談 "分からないこと"
./tools/helpdesk 解決 "分かったこと"
./tools/helpdesk 一覧
```

ロードマップは現在地確認に使います。
ヘルプデスクは、学習者のつまずきや解決内容を短く残すために使います。

## 同期ゲート

各Stepの最後に、次を確認します。

```text
LEARNING_TASK_TRACKER_14_DAYS.mdとLEARNING_HANDOFF_14_DAYS.mdが更新されている
TASK_TRACKER.mdとHANDOFF.mdが現状と一致している
必要に応じて3文書へ反映されている
Gitの作業状態が整理されている
必要に応じてcommit、push、CI確認が済んでいる
setup.index通過前に tools/lesson14 学習モード <A|B|C> が記録されている
tools/lesson14 承認 start <step_id> "承認メモ" が記録されている
tools/lesson14 承認 pass <step_id> "承認メモ" が記録されている
tools/lesson14 通過 <step_id> "メモ" が通る
```

同期ゲートの正本は `lesson/SYNC_GATES_14_DAYS.tsv` です。
スキルやAGENTS.MDの整合性は `tools/check_agents_skills.sh` で確認します。

## エージェントへの開始プロンプト

```text
このリポジトリの index-14-days.md を読み、STEP 1-14: 実践レッスンを順番どおりに進めてください。
最初に学習モードA/B/Cを確認してください。
未来の項目へスキップせず、各Stepの最後に同期ゲートを確認してください。
各レッスンは、次へ進む前に必ず私の承認を取ってください。
必要なプロンプトは、私がコピペできる形で提示してください。
```
