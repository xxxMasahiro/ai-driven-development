# AGENT_PLAYBOOK_14_DAYS.md

このファイルは、`STEP 1-14: 実践レッスン` を進めるエージェント向けの台本です。
`STEP 1-7: 基礎レッスン` のプレイブックは変更せず、拡張コースとして使います。

## 基本方針

```text
一問一答で進める
未来項目へのスキップは禁止する
完了済み項目の復習は許可する
必要なプロンプトは学習者がコピペできる形で提示する
各Stepの最後に同期ゲートを確認する
危険な操作、曖昧な操作、認証操作は学習者に確認する
成果物リポジトリの開発に入る前に、別画面でUbuntu/WSL CLIを起動するよう必ず促す
```

## 開始時の確認順

```text
1. index-14-days.md
2. learning/ROADMAP.md
3. lesson/LESSON_FLOW_14_DAYS.tsv
4. learning/LESSON_STATE_14_DAYS.tsv
5. lesson/SYNC_GATES_14_DAYS.tsv
6. prompts/PROMPTS_14_DAYS.md
7. learning/LEARNING_HANDOFF_14_DAYS.md
8. learning/LEARNING_TASK_TRACKER_14_DAYS.md
9. AGENTS.MD
10. 必要な skills/*/SKILL.md
```

## 最初に実行する検査

```bash
./tools/check_lesson14_structure.sh
./tools/check_lesson14_sync.sh
./tools/check_agents_skills.sh
./tools/lesson14 status
./tools/roadmap status
```

## 各ステップの進め方

```text
1. tools/lesson14 statusで現在地を確認する
2. 現在ステップのtitleとrequired_outputを読む
3. 学習者へ質問を1つだけ出す
4. 成果物リポジトリの作業に入る場合は、別画面のUbuntu/WSL CLI起動を促してから進める
5. 必要ならコピペ用プロンプトを提示する
6. 実行結果を確認する
7. 同期対象がある場合は更新案を先に提示する
8. 条件を満たしたらtools/lesson14 通過を実行する
```

## 同期ゲートで確認すること

```text
learning/ROADMAP.mdの現在地
learning/HELP_DESK.mdの未解決相談
learning/LEARNING_TASK_TRACKER_14_DAYS.md
learning/LEARNING_HANDOFF_14_DAYS.md
docs/workflow/TASK_TRACKER.md
docs/workflow/HANDOFF.md
docs/product/REQUIREMENTS.md
docs/product/SPECIFICATION.md
docs/product/IMPLEMENTATION_PLAN.md
Git status
GitHub Actions
AGENTS.MDとrepo-local skills
```

## 代替ルール

```text
サブエージェントが使えない場合は、レビュー担当、テスト担当、同期確認担当の役割プロンプトで代替する
スキル機能が使えない場合は、再利用プロンプトとして保存して代替する
MCPが使えない場合は、MCPで実現したい入出力を小さなローカルスクリプトで代替する
MCP関連の作業は、連携先、入力、出力、最小範囲、便利になる点、実装前の依頼文、確認方法を説明してから承認を取る
```

## 完了判定

```text
Step 14/14の最終同期が完了している
main CIが成功している
ローカルとリモートが同期している
3文書、docs/workflow/TASK_TRACKER.md、docs/workflow/HANDOFF.md、README.mdに矛盾がない
学習者が何を学んだか説明できる
```
