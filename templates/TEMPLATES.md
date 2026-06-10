# テンプレート集

このファイルは、エージェントがファイル案を作るときの雛形です。

## docs/product/REQUIREMENTS.md

```text
# REQUIREMENTS.md

## 目的

## ユーザー

## 必須要件

## 余裕があれば追加する要件

## 今回やらないこと

## 完成条件

## 未決定事項
```

## docs/product/SPECIFICATION.md

```text
# SPECIFICATION.md

## 画面構成

## 入力項目

## 表示項目

## 操作の流れ

## 入力チェック

## 保存方法

## 対象外の仕様
```

## docs/product/IMPLEMENTATION_PLAN.md

```text
# IMPLEMENTATION_PLAN.md

## 前提

## 作業順

## Day別計画

## 確認方法

## 完了条件

## 保留事項
```

## README.md

```text
# タスク管理表

## これは何か

## 使い方

## できること

## 今回やらないこと

## 次に改善したいこと
```

## LEARNING_TASK_TRACKER.md

```text
# LEARNING_TASK_TRACKER.md

## 現在の学習位置

## Day別進捗

## 理解できたこと

## まだ不安なこと

## 実行したプロンプト

## つまずきと対応

## 次に確認すること
```

## LESSON_CONFIG.tsv

```text
# key	value
lesson_repo_name	ai-driven-development-lesson
product_repo_name	task-tracker-repository
project_root	$HOME/projects
flow_file	lesson/LESSON_FLOW.tsv
state_file	learning/LESSON_STATE.tsv
learning_tracker_file	learning/LEARNING_TASK_TRACKER.md
learning_handoff_file	learning/LEARNING_HANDOFF.md
```

設定の意味:

```text
lesson_repo_name: 教材リポジトリ名
product_repo_name: 成果物リポジトリ名
project_root: 2つのリポジトリを並列に置く場所
flow_file: レッスン順番の正本
state_file: 現在位置の状態ファイル
learning_tracker_file: 学習進捗の記録先
learning_handoff_file: 学習引き継ぎの記録先
```

## LESSON_FLOW.tsv

```text
# order	step_id	day	title	required_output
001	setup.index	Setup	index.mdでレッスン全体の順番を確認する	設定から体験開発へ進む順番の了承
002	setup.github-login	Setup	github-login-setup-guide.mdでGitHub接続を確認する	github-loginでGitHub接続確認
```

列の意味:

```text
order: 通過順
step_id: コマンドで指定するID
day: レッスン上のDay
title: 学習者に見せる項目名
required_output: 通過前に確認する回答または成果物
```

## LESSON_STATE.tsv

```text
# order	step_id	status	started_at	completed_at
001	setup.index	current		
002	setup.github-login	locked		
```

状態の意味:

```text
current: 今だけ開始、通過できる項目
locked: まだ開始、通過できない項目
completed: 通過済みで復習できる項目
```

## LEARNING_HANDOFF.md

```text
# LEARNING_HANDOFF.md

## 現在地

## 直近で学んだこと

## 直近で実行したこと

## 未解決の疑問

## 次にやること

## 次回の最初の一問

## 注意点
```
