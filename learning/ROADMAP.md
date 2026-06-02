# ROADMAP.md

このファイルは、14日版レッスンの学習ロードマップです。
学習者が現在地を見失わないように、各日の目的、主な成果、同期ゲートをまとめます。

## 14日版の目的

```text
AI駆動開発の本質を、小さなタスク管理表を作りながら体験する。
開発者が目的を与え、エージェントとの壁打ちで要件、仕様、実装計画、検証方法を引き出す技術を学ぶ。
作業履歴、引き継ぎ、Git、GitHub、CI、E2E、レビュー、サブエージェント、スキル、MCPを、ばらばらではなく一連の開発ワークフローとして理解する。
```

## 進め方

```text
1日3時間を目安に進める。
各日の最後に同期ゲートを通過する。
分からない点はHELP_DESK.mdへ残す。
未来の日程へのスキップは禁止する。
完了済みの日程は復習として自由に戻れる。
```

## ロードマップ

| Day | テーマ | 体験すること | 同期ゲート |
| --- | --- | --- | --- |
| Day 1 | 全体像と学習制御 | index-14-days.md、14日ロードマップ、教材/成果物リポジトリ境界 | 学習記録と現在地 |
| Day 2 | GitHub接続とGit基礎 | gh、SSH、status、commit、push/pullの意味 | GitHub接続とGit状態 |
| Day 3 | 成果物リポジトリ準備 | 別画面のUbuntu/WSL CLI起動、教材外の成果物リポジトリ、メモリー文書、初回commit | リポジトリ境界 |
| Day 4 | 設計文書 | REQUIREMENTS.md、SPECIFICATION.md、IMPLEMENTATION_PLAN.md | 3文書作成 |
| Day 5 | 履歴とCI | TASK_TRACKER.md、HANDOFF.md、main CI、push | 文書、履歴、CI |
| Day 6 | 画面構成 | index.html、入力項目、表示構造 | 画面構成と仕様 |
| Day 7 | 基本動作 | app.js、タスク追加、入力チェック、単体確認 | 動作と履歴 |
| Day 8 | 中断と再開 | HANDOFF.mdを使った作業再開、TASK_TRACKER.md更新 | 引き継ぎ体験 |
| Day 9 | ブランチとPR | 作業ブランチ、PR、PR CI、merge、pull同期 | PRとmain同期 |
| Day 10 | Playwright E2E | Playwright導入、E2E作成、ローカル実行 | E2Eローカル確認 |
| Day 11 | CI E2Eと失敗復旧 | E2EをCIへ追加、失敗ログ、修正、再実行 | CI E2E確認 |
| Day 12 | 複数サブエージェント | レビュー担当、テスト担当、同期確認担当で多角的検証し、統括役が目的に照らして判断する | 指摘と修正判断 |
| Day 13 | スキルとMCP | 小さなエージェントスキル、最小MCP連携 | スキル/MCP体験 |
| Day 14 | 最終同期とふりかえり | 全文書同期、main CI、リモート同期、学習ふりかえり | 完了判定 |

## 毎日の終了条件

```text
LEARNING_TASK_TRACKER_14_DAYS.mdを更新した
LEARNING_HANDOFF_14_DAYS.mdを更新した
必要に応じてTASK_TRACKER.mdとHANDOFF.mdを更新した
必要に応じてREQUIREMENTS.md、SPECIFICATION.md、IMPLEMENTATION_PLAN.mdへ同期した
Git状態を確認した
必要に応じてcommit、push、CI確認を行った
tools/lesson14 通過 <step_id> "メモ" が通った
```

## ヘルプデスクの使い方

```bash
tools/helpdesk 相談 "分からないこと"
tools/helpdesk 解決 "分かったこと"
tools/helpdesk 一覧
```

相談内容は `learning/HELP_DESK.md` に残します。
レッスンの進行を止めるほどではない疑問も、あとで見返せるように短く記録します。
