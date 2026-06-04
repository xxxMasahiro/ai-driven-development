3件のサブエージェント xhigh レビューを実施し、完了後にすべてクローズしました。こちらでもローカル確認しました。ファイル変更はしていません。

**統括結論**

今回の件は、単なる `7日間レッスン` / `14日間レッスン` の表記ゆれではありません。
本質は、次の3層が混ざっていることです。

1. 学習者に見せる表示名
2. レッスン進行で使う機械的なキー
3. 既存互換のため残すファイル名・コマンド名・履歴

ここを分離しないまま一括置換すると、メニューは直っても `lesson14` の同期ゲート、CI、pre-commit、as-built同期、既存学習ログが壊れる可能性が高いです。

**更新後の全体整理**

**1. 表示名の方針が未確定**

今のままだと、学習者にはまだ次のように見えます。

```text
1. 7日間レッスン
2. 14日間レッスン
```

これは「その日数で終わる教材」と誤解されやすいです。
表示名は、たとえば次のように統一するのが安全です。

```text
1. STEP 1-7: 基礎レッスン
   AI駆動開発の基本を短く一周する

2. STEP 1-14: 実践レッスン
   GitHub、CI、E2E、PR、サブエージェント、スキル、MCPまで順番に体験する
```

`7ステップ版` / `14ステップ版` という案もありますが、メニュー上は `STEP 1-7` / `STEP 1-14` の方が、既存の `Step N/7`、`Step N/14` とつながりやすいです。

**2. 内部名は残す必要がある**

次は内部互換名として残すべきです。

- `tools/lesson`
- `tools/lesson14`
- `index.md`
- `index-14-days.md`
- `LESSON_FLOW_14_DAYS.tsv`
- `LEARNING_*_14_DAYS.tsv`
- `day1.mode`、`day14.complete` などの `step_id`
- `check_lesson14_*`
- 既存の学習履歴に残っている旧表記

これらを消すと、既存のチェック、同期ゲート、履歴、CIが壊れます。

**3. 最大の技術的リスク**

最大の破損リスクは [tools/check_lesson14_sync.sh](/home/masahiro/projects/ai-driven-development-lesson/tools/check_lesson14_sync.sh:51) 周辺です。

このチェックは `Step N/14` を、フロー、同期ゲート、ロードマップ、プロンプト、学習トラッカーに直接要求しています。
さらに `tools/lesson14` 側も、フローの表示ラベルを同期ゲートの検索キーとして使う構造があります。

つまり、`Step 1/14` を安易に `STEP 1-14` へ変えると、レッスン通過処理そのものが壊れる可能性があります。
表示名と機械キーを分離するまでは、`Step N/14` は機械的ラベルとして維持した方が安全です。

**4. メニューとダッシュボードが未統一**

[tools/menu](/home/masahiro/projects/ai-driven-development-lesson/tools/menu:15) は `7日間レッスン` / `14日間レッスン` を直接表示しています。

[tools/dashboard](/home/masahiro/projects/ai-driven-development-lesson/tools/dashboard:126) も `7-day lesson status`、`14-day`、`7-day` を表示しています。

メニューだけ直しても、ダッシュボードが旧表記のままだと学習者には混在して見えます。

**5. README、AGENTS、入口文書、ガイドも混在**

[README.md](/home/masahiro/projects/ai-driven-development-lesson/README.md:31)、[AGENTS.MD](/home/masahiro/projects/ai-driven-development-lesson/AGENTS.MD:13)、[index.md](/home/masahiro/projects/ai-driven-development-lesson/index.md:3)、[index-14-days.md](/home/masahiro/projects/ai-driven-development-lesson/index-14-days.md:1) にも旧表現があります。

ここは学習者が読む入口なので、表示名は新方針へ寄せる必要があります。
ただし、`index-14-days.md` というファイル名そのものは内部互換として残します。

**6. Day表記もまだ残っている**

`./tools/check_learner_display.sh` は通っていても、検出範囲が狭いです。

追加で確認された残存例:

- [learning/ROADMAP.md](/home/masahiro/projects/ai-driven-development-lesson/learning/ROADMAP.md:4) に「各日」「日程」系の表現
- [learning/ROADMAP.md](/home/masahiro/projects/ai-driven-development-lesson/learning/ROADMAP.md:26) に表見出し `Day`
- [ai-driven-task-tracker-scenario.md](/home/masahiro/projects/ai-driven-development-lesson/ai-driven-task-tracker-scenario.md:65) に `現在のDayまたはStep`
- [prompts/PROMPTS.md](/home/masahiro/projects/ai-driven-development-lesson/prompts/PROMPTS.md:71) に `現在のDayまたはStep`
- [tools/roadmap](/home/masahiro/projects/ai-driven-development-lesson/tools/roadmap:20) の usage に `day`

`Day N` だけを禁止する検査では不十分です。`Day別`、`各Day`、`DayまたはStep`、Markdown表の `| Day |` も拾う必要があります。

**7. 学習ログと履歴は一括置換しない方がよい**

`LEARNING_TASK_TRACKER*.md` や `LEARNING_HANDOFF*.md` には過去の学習記録として旧表記が残っています。

これは証跡なので、過去ログを一括で書き換えるのは危険です。
対応方針は次が安全です。

- 既存ログは原則そのまま残す
- 冒頭に「過去ログには旧表記が残る。現在の学習者向け表示はSTEP表記を正とする」と注記する
- 今後の新規出力だけSTEP表記へ統一する

**8. プロンプトとプレイブックは優先度が高い**

学習者がコピペする `prompts/PROMPTS.md`、`prompts/PROMPTS_14_DAYS.md` は優先的に直すべきです。
ここに旧表記が残ると、エージェントへの依頼文そのものが古い表記を再生産します。

また、`playbooks/AGENT_PLAYBOOK.md` 側も、エージェントの出力誘導に影響するため修正対象です。

**9. テスト・CI側も旧表記を要求している**

次のチェックは旧表記や `Step N/14` を直接要求しています。

- [tools/check_developer_memory_requirements.sh](/home/masahiro/projects/ai-driven-development-lesson/tools/check_developer_memory_requirements.sh:111)
- [tools/check_agents_skills.sh](/home/masahiro/projects/ai-driven-development-lesson/tools/check_agents_skills.sh:75)
- [tools/check_lesson14_structure.sh](/home/masahiro/projects/ai-driven-development-lesson/tools/check_lesson14_structure.sh:224)
- [tools/check_lesson14_sync.sh](/home/masahiro/projects/ai-driven-development-lesson/tools/check_lesson14_sync.sh:75)
- [tools/test_lesson14.sh](/home/masahiro/projects/ai-driven-development-lesson/tools/test_lesson14.sh:23)

したがって、表示名だけ変えるとCIが止まります。
表示名変更と同時に、チェック側も「内部互換名」と「学習者向け表示名」を分けて検査する必要があります。

**10. as-built文書は一部だけ先行している**

[docs/as-built/SPECIFICATION.md](/home/masahiro/projects/ai-driven-development-lesson/docs/as-built/SPECIFICATION.md:613) には、学習者向けStep表示の境界ルールに近い記載があります。

一方で、[docs/as-built/REQUIREMENTS.md](/home/masahiro/projects/ai-driven-development-lesson/docs/as-built/REQUIREMENTS.md:10) などには `7-day` / `14-day` が広く残っています。

つまり、文書内でも「今後の方針」と「旧互換の説明」が混在しています。
ここは用語表を追加して、役割別に整理する必要があります。

**11. 推奨する境界ルール**

今後の正本ルールはこうするのが安全です。

- 学習者向け表示:
  - `STEP 1-7: 基礎レッスン`
  - `STEP 1-14: 実践レッスン`
  - `Step N/7`
  - `Step N/14`

- 内部互換名:
  - `7-day`
  - `14-day`
  - `lesson14`
  - `index-14-days.md`
  - `_14_DAYS`
  - `dayN.*`

- 過去ログ:
  - 原則変更しない
  - 新規出力だけ新表記へ統一

- テスト:
  - ユーザー向け表示に旧ラベルが出ないことを検査
  - 内部互換名が壊れていないことも検査
  - 許容箇所は allowlist で管理

**12. 実装時の安全な順序**

1. 用語表を作る
   表示名、内部名、履歴名、コマンド名の境界を定義する。

2. 共通の表示名生成関数またはTSVを作る
   `tools/menu`、`tools/dashboard`、`tools/lesson*` が同じ表示名を使うようにする。

3. メニューとダッシュボードを更新する
   まず学習者が最初に見る場所を直す。

4. README、index、guide、prompts、playbooksを更新する
   学習者とエージェントが旧表記を再生産しないようにする。

5. `tools/learn`、`tools/helpdesk`、`tools/roadmap` の通常表示を整理する
   内部IDは必要なときだけ出す。

6. チェックとテストを更新する
   旧表記禁止チェックと内部互換維持チェックを分ける。

7. as-built 3文書と workflow 2文書を同期する
   単なる置換ではなく、要件・仕様・実装計画・作業状態・引き継ぎとして整合させる。

**最終更新版の判定**

この改善テーマは、まだ未完了です。
前回までの整理に加えて、今回の精査で特に重要なのは次の3点です。

- `Step N/14` は単なる表示ではなく、同期ゲートの機械キーにもなっているため、安易に変更できない。
- `check_learner_display.sh` は現在の残存表記を十分に検出できていない。
- `tools/menu`、`tools/dashboard`、README、AGENTS、prompts、checks、as-built の全体を、表示名と内部互換名の分離方針で同期する必要がある。

次に進めるなら、最初の実装テーマは「STEP表示名ポリシーと表示レイヤー統一」です。
グローバル置換ではなく、表示名マッピングとチェック分離から入るべきです。

## Existing Mechanical Memory Anchors

This section preserves existing mechanical developer-memory requirement checks while keeping the lesson display-label policy findings above as the active improvement context.

- Approval checkpoints now have tooling enforcement.
- `tools/lesson 学習モード <A|B|C>` is the 7-day learning-mode command.
- `tools/lesson14 学習モード <A|B|C>` is the 14-day learning-mode command.
- Learning mode can be switched at any time during either lesson.
- Standard language choices should include `ja`, `en`, `ko`, `zh-CN`, `zh-TW`, `es`, `pt-BR`, `fr`, `de`, `id`, `vi`, `th`, `hi`, and `ar`.
- Implementation must be refactorable, ecosystem-friendly, reusable, and general.
- Existing functionality must not be traded away.
- Final tests pass only when every improvement or problem recorded in this developer memory is cleared or correctly synchronized into the active plan.
- Explain MCP Purpose Before MCP Workflows.
