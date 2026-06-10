# エージェント進行台本

このファイルは、エージェントが迷わずレッスンを誘導するための短縮版です。

## 最優先ルール

```text
開発者の承認なしに書き込まない
一問一答を守る
最初にindex.mdを読み、設定から体験開発への順番を確認する
tools/lesson 現在地で現在項目を確認してから質問する
未完了の未来項目を開始、通過しない
完了済み項目だけ復習として自由に戻る
ユーザーにプロンプトを一から考えさせない
作業の節目でフォルダ構成を見せる
節目で学習進捗の記録案を作る
節目でtools/check_lesson_structure.shを実行する
成果物リポジトリの開発に入る前に、別画面でUbuntu/WSL CLIを起動するよう必ず促す
迷ったら小さい範囲に戻す
```

## 1ターンの基本形

```text
1. 現在のStepを確認する
2. tools/lesson 現在地で現在項目を確認する
3. 必要に応じてtools/check_lesson_structure.shで構成を確認する
4. 今扱うファイルの位置を必要に応じて示す
5. 成果物リポジトリの開発に入る場合は、別画面のUbuntu/WSL CLI起動を促す
6. 今やることを短く説明する
7. 質問を1つだけ出す
8. 必要ならコピペ用プロンプトを提示する
9. ユーザーの回答または実行結果を待つ
10. 承認が必要な操作か確認する
```

## 初回の順番

```text
1. setup.index: index.mdで全体順序を確認する
2. setup.github-login: github-login-setup-guide.mdでGitHub接続を確認する
3. day1.mode: デモモードか実作業モードか、承認ルールを確認する
4. day1.project-directory: 教材リポジトリと成果物リポジトリを$HOME/projects直下に並列配置する前提を確認する
5. day1.folder-overview: フォルダ構成を見ながら進めることを確認する
6. day1.memory-files: メモリー用Markdownの役割を確認する
7. day1.requirements: 個人用か小さなチーム用か、最小入力項目を確認する
8. day1.specification: 要件から仕様案を作る進め方を確認する
9. day1.implementation-plan: 仕様から実装計画案を作る進め方を確認する
10. day1.initial-tracker-handoff: 初回作成をTASK_TRACKER.mdとHANDOFF.mdへ記録する流れを確認する
11. day1.learning-controls: 学習進捗と順番制御コマンドを確認する
```

## 再開時の順番

```text
1. 全体のフォルダ構成
2. index.md
3. tools/check_lesson_structure.sh
4. tools/lesson 現在地
5. lesson/LESSON_CONFIG.tsv
6. learning/LESSON_STATE.tsv
7. learning/LEARNING_HANDOFF.md
8. learning/LEARNING_TASK_TRACKER.md
9. docs/workflow/HANDOFF.md
10. docs/workflow/TASK_TRACKER.md
11. docs/product/REQUIREMENTS.md
12. docs/product/SPECIFICATION.md
13. docs/product/IMPLEMENTATION_PLAN.md
14. 今日進めるStep
```

## 回答分岐

```text
はい: 次へ進む
変更したい: 何を変更したいか1つだけ聞く
分からない: 推奨案を1つ提示する
後で決めたい: 保留としてHANDOFF.md向けに記録案を出す
実行結果が違う: 作業を止めて失敗復旧へ移る
未来項目を進めたい: tools/lessonが示す現在項目へ戻す
完了済み項目を見直したい: tools/lesson 復習 <step_id> を案内する
```

## レッスン順番制御

```text
現在地: tools/lesson 現在地 を実行する
一覧: tools/lesson 一覧 を実行する
開始: tools/lesson 開始 <step_id> を実行する
通過: tools/lesson 通過 <step_id> "メモ" を実行する
復習: tools/lesson 復習 <step_id> を実行する
```

通過前に、`lesson/LESSON_FLOW.tsv` の `required_output` を満たす回答または成果物があるか確認します。  
条件を満たさない場合は `tools/lesson 通過` を実行せず、次の一問で不足分を確認します。

`tools/lesson` が失敗した場合は、表示された現在項目へ戻ります。  
エージェントは、失敗した未来項目の作業を続けません。

## 学習記録コマンド

```text
現在地: tools/learn 現在地 を案内する
記録: tools/learn 記録 "内容" を案内する
つまずき: 不明点と次の一問を整理する
中断: tools/learn 中断 "内容" を案内する
再開: tools/learn 再開 を案内する
理解: tools/learn 理解 "内容" を案内する
```
