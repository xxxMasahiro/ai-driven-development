# AI駆動開発レッスンガイド

このファイルは、学習者が読む短縮版です。  
詳しい進行台本は `ai-driven-task-tracker-scenario.md` を使います。

## このレッスンで体験すること

```text
index.mdで全体の進み方を確認する
GitHub接続設定から始める
AIエージェントと一問一答で要件を決める
エージェントが用意したプロンプトをコピペして実行する
要件、仕様、実装計画を作る
作業履歴と設計文書を同期する
学習進捗を節目や短いコマンドで記録する
レッスンを順番どおりに通過し、未完了項目のスキップを防ぐ
簡単なタスク管理表の完成までの流れを体験する
```

## 進め方

```text
1. エージェントの質問に1つずつ答える
2. 最初にindex.mdで全体像を確認する
3. github-login-setup-guide.mdでGitHub接続を確認する
4. エージェントが出したプロンプトを確認する
5. 問題なければコピペして実行する
6. 実行結果を見て、了承または修正希望を伝える
7. 作業の節目でフォルダ構成を確認する
8. `tools/lesson` で現在位置を確認しながら順番に進む
9. 必要なら短いコマンドで学習進捗を記録する
```

## 主なファイル

```text
index.md: レッスン全体の入口
github-login-setup-guide.md: GitHub接続設定
REQUIREMENTS.md: 何を作りたいか
SPECIFICATION.md: どう動けばよいか
IMPLEMENTATION_PLAN.md: どの順番で作るか
TASK_TRACKER.md: 作業の進み具合
HANDOFF.md: 次回への引き継ぎ
LESSON_FLOW.tsv: レッスンの正しい順番
LESSON_CONFIG.tsv: リポジトリ名や主要ファイル名の設定
LESSON_STATE.tsv: 現在位置、完了済み、未解放の状態
LEARNING_TASK_TRACKER.md: 学習者の進み具合
LEARNING_HANDOFF.md: 学習の次回再開メモ
README.md: 完成品の説明書
```

## 責務別ディレクトリ

```text
guides/: 学習者向けガイド
prompts/: コピペ用プロンプト
templates/: ファイル雛形
playbooks/: エージェント用進行台本
lesson/: レッスン順番の正本
learning/: 学習進捗と学習ハンドオフ
tools/: 構成チェック、順番制御、学習記録コマンド
```

## リポジトリの置き方

```text
$HOME/projects/
├─ ai-driven-development-lesson/       教材リポジトリ
└─ task-tracker-repository/     成果物リポジトリ
```

教材リポジトリと成果物リポジトリは入れ子にしません。  
`$HOME` は学習者ごとに変わるホームディレクトリです。
リポジトリ名や配置先を変える場合は、`lesson/LESSON_CONFIG.tsv` を変更します。
成果物リポジトリの開発に入る前には、別画面でUbuntu/WSL CLIを起動し、成果物リポジトリ専用画面として使います。

## レッスン順番制御コマンド

```text
tools/lesson 現在地: 今進められる項目を確認する
tools/lesson 一覧: 全項目の状態を見る
tools/lesson 開始位置 <step_id> --confirm: 学びたい項目を現在地にする
tools/lesson 開始 <step_id>: 現在の項目を開始する
tools/lesson 通過 <step_id> "メモ": 現在の項目を完了して次へ進める
tools/lesson 復習 <step_id>: 完了済み項目を見直す
```

通常進行では、未完了の未来項目は開始も通過もできません。
学びたい項目から始める場合は、開始位置を明示的に変更できます。
完了済みの項目だけ、復習として自由に戻れます。
通過前には、エージェントがその項目の通過条件を満たしているか確認します。

## 学習記録コマンド

```text
現在地: 今どこまで進んだか確認する
記録: 今の学習状態を残す
つまずき: 分からない点を残す
中断: 次回再開できるようにする
再開: 前回の続きから始める
理解: 分かったことを残す
```

節目の学習記録は、毎回確認してから記録する方法と、レッスン中だけ自動記録する方法を選べます。  
自動記録の対象は `LESSON_STATE.tsv`、`LEARNING_TASK_TRACKER.md`、`LEARNING_HANDOFF.md` だけです。

## 短い記録コマンド

```text
tools/learn 現在地
tools/learn 記録 "今日分かったこと"
tools/learn つまずき "分からなかったこと"
tools/learn 中断 "次回はここから再開したい"
tools/learn 理解 "理解できたこと"
```

学習記録には、現在のレッスン項目も一緒に残ります。
`tools/learn` を実行した場合は、学習記録ファイルへ直接追記されます。  
それ以外のMarkdown編集は、更新案を確認してから承認します。

## 構成チェック

```text
tools/check_lesson_structure.sh
tools/check_repository_boundary.sh
```

このコマンドで、必要なファイルが責務別ディレクトリにあるか、成果物リポジトリが教材リポジトリ内に紛れ込んでいないかを確認できます。

教材リポジトリでは、コミット前にも同じ検査が自動実行されます。

## 注意

```text
分からないときは「分からない」と答えてよい
プロンプトを自分で考える必要はない
ファイル編集は、更新案を確認してから承認する
迷ったら小さい範囲に戻す
```
