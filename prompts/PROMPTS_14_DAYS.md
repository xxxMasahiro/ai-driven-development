# PROMPTS_14_DAYS.md

このファイルは、`STEP 1-14: 実践レッスン` で使うコピペ用プロンプト集です。
既存の `prompts/PROMPTS.md` を置き換えず、拡張版として使います。

## 共通開始プロンプト

```text
このリポジトリの index-14-days.md、learning/ROADMAP.md、lesson/LESSON_FLOW_14_DAYS.tsvを確認し、
AGENTS.MDと必要なskills/*/SKILL.mdも確認したうえで、
STEP 1-14: 実践レッスンを順番どおりに進めてください。
最初に学習モードA/B/Cを確認してください。
選択後、setup.index通過前に tools/lesson14 学習モード <A|B|C> を実行してください。
学習者が希望した場合は、レッスン途中でも tools/lesson14 学習モード <A|B|C> で切り替えてください。
レッスン開始直後に、教材・ワークフロー表示用の言語を確認し、tools/lesson14 表示言語 <ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar> を実行してください。
成果物リポジトリの開発に入る前に、成果物側の開発言語を確認し、tools/lesson14 開発言語 <ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar> を実行してください。
未来の項目へスキップせず、各Stepの最後に同期ゲートを確認してください。
各レッスンは、次へ進む前に必ず私の承認を取ってください。
開始承認後は、開始前に tools/lesson14 承認 start <step_id> "承認メモ" を実行してください。
通過承認後は、通過前に tools/lesson14 承認 pass <step_id> "承認メモ" を実行してください。
成果物リポジトリの開発に入る前には、別画面でUbuntu/WSL CLIを起動するよう必ず促してください。
必要なプロンプトは、私がコピペできる形で提示してください。
```

## 壁打ち開始プロンプト

```text
これから作りたい成果物の目的を壁打ちしたいです。
私の目的、利用者、制約、優先順位を質問で引き出し、要件、仕様、実装計画、検証方法へ整理してください。
まだ実装せず、まず目的達成に必要な論点と次の一手を明確にしてください。
```

## 学習モード選択プロンプト

```text
STEP 1-14: 実践レッスンを始める前に、学習モードを選んでください。
A: 詳細解説が必要
   表示名: じっくり説明
B: 解説は補足程度
   表示名: ほどよく説明
C: 解説不要でワークフローのみ
   表示名: 手順だけ
初回1周目ならAを推奨します。
```

## 言語設定プロンプト

```text
レッスン中の説明を表示する言語と、成果物リポジトリで作る文書・画面文言の言語を分けて選びます。
まず表示言語を選んでください。例: 日本語なら ja、英語なら en、韓国語なら ko、簡体字中国語なら zh-CN、繁体字中国語なら zh-TW、スペイン語なら es、ブラジルポルトガル語なら pt-BR。
選択後に tools/lesson14 表示言語 <ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar> を実行してください。
`zh` は既存互換のため `zh-CN` として扱います。

成果物リポジトリの開発に入る前に、開発言語も選んでください。
選択後に tools/lesson14 開発言語 <ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar> を実行してください。
```

## 共通同期プロンプト

```text
現在の作業状態を確認し、LEARNING_TASK_TRACKER_14_DAYS.md、LEARNING_HANDOFF_14_DAYS.md、
docs/workflow/TASK_TRACKER.md、docs/workflow/HANDOFF.md、docs/product/REQUIREMENTS.md、docs/product/SPECIFICATION.md、docs/product/IMPLEMENTATION_PLAN.mdの整合性を確認してください。
この依頼では、まず更新案だけ提示してください。
```

## 文書マップ確認プロンプト

```text
guides/DOCUMENT_MAP.md と tools/docs-tour status を確認してください。
AGENTS.MDの不変ルール、ドキュメントルート、ルーティングテーブル、skills、
docs/as-built/、docs/workflow/、docs/memory/の役割を、初めて見る人にも分かるように短く説明してください。
AGENTS.MDは教材側のルールブック、AGENT.mdは成果物リポジトリ側の文脈メモである違いも説明してください。
FAILURE_MEMORY.mdは成果物側の失敗復旧記録として扱い、教材側のdocs/memory/FAILURE_MEMORY.mdがあるとは説明しないでください。
この依頼ではファイルを編集しないでください。
```

## 作業記録と引き継ぎの説明プロンプト

```text
docs/workflow/TASK_TRACKER.md と docs/workflow/HANDOFF.md を確認してください。
現在の進捗、完了済みの作業、次に安全に進める作業を、初心者にも分かる言葉で説明してください。
この依頼ではファイルを編集しないでください。
```

## 3文書の説明プロンプト

```text
docs/as-built/REQUIREMENTS.md、docs/as-built/SPECIFICATION.md、docs/as-built/IMPLEMENTATION_PLAN.mdを確認してください。
それぞれが何を担当する文書なのか、3つの内容が同じ状態を説明しているかを、初心者にも分かる言葉で説明してください。
この依頼ではファイルを編集しないでください。
```

## Step 1/14

```text
Step 1/14として、STEP 1-14ロードマップ、教材リポジトリと成果物リポジトリの境界、
tools/lesson14、tools/roadmap、tools/helpdesk、tools/docs-tourの使い方を確認してください。
文書が多く見える理由をguides/DOCUMENT_MAP.mdに沿って短く説明してください。
最後にStep 1/14同期ゲートを通過できるか確認してください。
```

## Step 2/14

```text
Step 2/14として、Gitのstatus、add、commit、GitHubのgh、SSH、push、pullの役割を、
非エンジニアにも分かるように短く説明してください。
実行が必要なコマンドは、私がコピペできる形で提示してください。
```

## Step 3/14

```text
Step 3/14として、成果物リポジトリを教材リポジトリの外に作る理由を確認し、
成果物リポジトリの開発に入る前に、別画面でUbuntu/WSL CLIを起動するよう促してください。
AGENT.md、docs/memory/SESSION_MEMORY.md、docs/memory/FAILURE_MEMORY.md、docs/memory/DEVELOPER_MEMORY.mdの役割を整理してください。
更新案を提示してから、承認後に作業してください。
```

## Step 4/14

```text
Step 4/14として、docs/product/REQUIREMENTS.md、docs/product/SPECIFICATION.md、docs/product/IMPLEMENTATION_PLAN.mdの初期案を作ります。
要件は私に一問一答で確認し、仕様と実装計画はエージェントが案を作ってください。
まず更新案だけ提示してください。
```

## Step 5/14

```text
Step 5/14として、3文書の初回作成をdocs/workflow/TASK_TRACKER.mdとdocs/workflow/HANDOFF.mdへ記録し、
mainブランチのCI、commit、push、GitHub上の確認まで体験します。
同期ゲートを通過する前に、文書、履歴、Git状態、CI状態を確認してください。
```

## Step 6/14

```text
Step 6/14として、index.htmlの画面構成を作成します。
docs/product/SPECIFICATION.mdを確認し、入力欄、追加ボタン、タスク一覧の構成案を提示してください。
書き込み前に更新案を確認させてください。
```

## Step 7/14

```text
Step 7/14として、app.jsでタスク追加、空欄チェック、入力リセットの基本動作を作ります。
実装後に小さな確認手順を作り、docs/workflow/TASK_TRACKER.mdとdocs/workflow/HANDOFF.mdへ反映する案を提示してください。
```

## Step 8/14

```text
Step 8/14として、docs/workflow/HANDOFF.mdを使って中断と再開を体験します。
一度中断メモを作り、そのメモだけを読んで次の作業へ戻れるか確認してください。
```

## Step 9/14

```text
Step 9/14として、作業ブランチ、PR、PR CI、merge、mainへ戻ってpull同期する流れを体験します。
各操作の前に、今どのブランチにいて、何を確認するのかを短く説明してください。
```

## Step 10/14

```text
Step 10/14として、Playwrightを導入し、タスク管理表のE2Eテストを1つ作ります。
導入前に必要なコマンドと変更ファイルの見込みを提示してください。
```

## Step 11/14

```text
Step 11/14として、Playwright E2EをCIに組み込みます。
失敗した場合はログを読み、原因、修正、再実行、成果物リポジトリ側のdocs/memory/FAILURE_MEMORY.mdへの記録案を提示してください。
教材リポジトリ側のdocs/memory/FAILURE_MEMORY.mdがあるとは説明しないでください。
```

## Step 12/14

```text
Step 12/14として、複数サブエージェントまたは役割プロンプトを使い、
レビュー担当、テスト担当、同期確認担当の3観点で成果物を精査してください。
最初に、サブエージェントを使う目的、便利になる点、3担当の役割を説明してください。
それぞれの担当が何を見て、統括役がどのように採用、保留、却下を判断するのかを説明してください。
実行前に、私が別CLIまたは同じCLIでコピペできる役割プロンプトを1つずつ提示してください。
各担当の結果を確認するたびに、次へ進んでよいか私の承認を取ってください。
指摘は重大度順に整理してください。
```

## Step 13/14

```text
Step 13/14として、小さなエージェントスキルを作成し、呼び出して使う体験をします。
最初に、スキルを使う目的、便利になる点、通常プロンプトとの違いを説明してください。
スキル作成、スキル利用、MCPの順に、一問一答で進めてください。
それぞれの作業前に、私がコピペできるプロンプトまたはコマンドを提示してください。
MCPに入る前に、何と何をつなぐのか、入力、出力、便利になること、最小範囲、変更されるファイル、確認方法を説明してください。
その後、最小MCP連携でタスク管理表を少し便利にする案を提示してください。
本物のMCPサーバーを作る場合と、MCP風の最小リソースで代替する場合の違いを説明してください。
MCP関連の実装や代替スクリプト作成は、説明、短い依頼文の提示、ユーザー承認の後にだけ行ってください。
本格化しすぎず、学習目的の最小構成にしてください。
最後にtools/check_agents_skills.shでAGENTS.MDとskillsの整合性を確認してください。
```

## Step 14/14

```text
Step 14/14として、docs/product/REQUIREMENTS.md、docs/product/SPECIFICATION.md、docs/product/IMPLEMENTATION_PLAN.md、
docs/workflow/TASK_TRACKER.md、docs/workflow/HANDOFF.md、README.md、Git状態、GitHub Actionsの状態を最終確認してください。
最後に、学習ロードマップとHELP_DESK.mdを見返してふりかえりを作ってください。
完了後に、次の改善サイクルとして、デザイン改善、機能追加、Googleカレンダー連携などの候補を提示してください。
```

## 自由開発モードプロンプト

```text
自由開発モードで進めたいです。
このリポジトリのレッスンで学んだワークフローに準拠して、任意の成果物リポジトリを設定し、要件、仕様、実装計画、TASK_TRACKER、HANDOFF、Git同期、テスト、CI確認を省略せずに進めてください。
主要な区切りごとに承認を取ってください。
```

## 外部連携プロンプト

```text
外部連携で成果物を発展させたいです。
自由開発または既存成果物の要件、仕様、現在の実装を確認し、どの外部ツールと何を連携するか、入力、出力、最小範囲、確認方法を一問一答で整理してください。
本格実装の前に、MCP風の最小連携で何を確認するかを説明し、短い依頼文を提示してから承認を取ってください。
```

## 教材改善プロンプト

```text
教材そのものを改善したいです。
docs/memory/DEVELOPER_MEMORY.md、docs/workflow/TASK_TRACKER.md、docs/workflow/HANDOFF.md、docs/as-built/REQUIREMENTS.md、docs/as-built/SPECIFICATION.md、docs/as-built/IMPLEMENTATION_PLAN.mdを確認し、開発者メモリの改善点と問題点をすべて満たすように教材側だけを安全に実装・同期してください。
完了前に必要なチェックをすべて実行し、ひとつでも失敗したら修正と再テストを繰り返してください。
```

## チーム開発とDockerプロンプト

```text
チーム開発とDockerをAI駆動開発として学びたいです。
まず、成果物の目的、チーム人数、開発環境の差、必要なサービス、DB、環境変数、ポート、CI要件を一問一答で引き出してください。
Dockerの初歩から、実際にコンテナ開発できるレベルまで段階的に進めてください。
設定やデバッグをエージェントと対話しながら進めることで、Docker導入がどれだけ楽になるか体験できるようにしてください。
実装前に計画を提示し、承認後に成果物リポジトリ側CLIで進めてください。
```
