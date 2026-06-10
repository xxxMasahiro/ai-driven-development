# コピペ用プロンプト集

このファイルは、学習者がコピペして使うプロンプト集です。  
エージェントは、その場面に合うプロンプトだけを提示します。

## 構成チェック

```text
index.mdを入口として確認したうえで、tools/check_lesson_structure.sh と tools/check_repository_boundary.sh を実行し、必要なファイル配置とリポジトリ境界を確認してください。
結果が失敗の場合は、足りないファイルまたは誤配置のファイルを短く報告してください。
```

## レッスン順番確認

```text
tools/lesson 現在地 を実行し、現在進められる項目を確認してください。
未完了の未来項目を進めようとしている場合は作業を止め、
表示された現在項目に戻って一問だけ提示してください。
```

## 学習モードと言語選択

```text
STEP 1-7: 基礎レッスンを始める前に、学習モードを選んでください。
Aは「じっくり説明」、Bは「ほどよく説明」、Cは「手順だけ」です。
選択後に tools/lesson 学習モード <A|B|C> を実行してください。

次に、教材・ワークフロー表示用の言語を確認し、tools/lesson 表示言語 <ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar> を実行してください。
成果物リポジトリの開発に入る前に、成果物側の開発言語を確認し、tools/lesson 開発言語 <ja|en|ko|zh-CN|zh-TW|es|pt-BR|fr|de|id|vi|th|hi|ar> を実行してください。
`zh` は既存互換のため `zh-CN` として扱います。
```

## レッスン項目の通過

```text
現在の項目を完了します。
tools/lesson 通過 <step_id> "<通過理由>" を実行し、
次に進める項目を確認してください。
未完了の未来項目を通過しようとして失敗した場合は、
表示された現在項目に戻ってください。
```

## 学習記録コマンド例

```text
tools/lesson 現在地
tools/learn 現在地
tools/learn 記録 "今日分かったこと"
tools/learn つまずき "分からなかったこと"
tools/learn 中断 "次回はここから再開したい"
tools/learn 理解 "理解できたこと"
```

## 途中再開

```text
前回の続きから再開します。
全体のフォルダ構成とindex.mdを確認し、tools/check_lesson_structure.sh、tools/check_repository_boundary.sh、tools/lesson 現在地 を実行してください。
その後、LEARNING_HANDOFF.md、LEARNING_TASK_TRACKER.md、
docs/workflow/HANDOFF.md、docs/workflow/TASK_TRACKER.md、
docs/product/REQUIREMENTS.md、docs/product/SPECIFICATION.md、docs/product/IMPLEMENTATION_PLAN.mdを確認し、
現在位置と次にやることを1つだけ提案してください。
すぐに編集せず、必要な更新案だけ提示してください。
```

## 学習進捗の節目記録

```text
レッスンの節目なので、学習進捗を記録します。
tools/lesson 現在地で現在項目を確認してください。
現在のStep、理解できたこと、まだ不安なこと、
実行したプロンプト、確認したファイル、次にやることを整理し、
自動記録が許可されている場合は tools/learn 記録 "<内容>" を提示してください。
自動記録が許可されていない場合は、実行するコマンド案だけ提示してください。
```

## 学習進捗の自動記録設定

```text
学習進捗の記録方法を確認してください。
節目ごとに確認してから記録する方法と、
このレッスン中だけLESSON_STATE.tsv、LEARNING_TASK_TRACKER.md、LEARNING_HANDOFF.mdへ自動記録する方法のどちらにするか、
一問だけで確認してください。
```

## 学習記録コマンド処理

```text
学習者から短い記録コマンドを受け取りました。
コマンドの意味を判定し、tools/learn で実行するコマンド案を作ってください。
コマンドは「現在地」「記録」「つまずき」「中断」「再開」「理解」のいずれかとして扱ってください。
学習者または開発者が tools/learn を明示実行した場合だけ、learning/配下へ直接記録されます。
エージェントがMarkdownを直接編集しないでください。
```

## 文書マップ確認

```text
guides/DOCUMENT_MAP.md と tools/docs-tour status を確認してください。
AGENTS.MD、docs/as-built/、docs/workflow/、docs/memory/、skills/ の役割を、初めて見る人にも分かるように短く説明してください。
AGENTS.MDは教材側のルールブック、AGENT.mdは成果物リポジトリ側の文脈メモである違いも説明してください。
docs/memory/FAILURE_MEMORY.mdは成果物側の失敗復旧記録として扱い、教材リポジトリ側のdocs/memory/FAILURE_MEMORY.mdがあるとは説明しないでください。
この依頼ではファイルを編集しないでください。
```

## 作業記録と引き継ぎの説明

```text
docs/workflow/TASK_TRACKER.md と docs/workflow/HANDOFF.md を確認してください。
現在の進捗、完了済みの作業、次に安全に進める作業を、初心者にも分かる言葉で説明してください。
この依頼ではファイルを編集しないでください。
```

## 3文書の説明

```text
docs/as-built/REQUIREMENTS.md、docs/as-built/SPECIFICATION.md、docs/as-built/IMPLEMENTATION_PLAN.mdを確認してください。
それぞれが何を担当する文書なのか、3つの内容が同じ状態を説明しているかを、初心者にも分かる言葉で説明してください。
この依頼ではファイルを編集しないでください。
```

## 初回同期

```text
docs/product/REQUIREMENTS.md、docs/product/SPECIFICATION.md、docs/product/IMPLEMENTATION_PLAN.mdの内容を確認し、
初回作成が完了した作業としてdocs/workflow/TASK_TRACKER.mdとdocs/workflow/HANDOFF.mdへ記録する案を作ってください。
開発者が承認するまでファイルを編集しないでください。
```

## 変更開始

```text
これから新機能の追加、または不要な機能の削除を行います。
まずdocs/workflow/TASK_TRACKER.mdに変更タスクを追加し、docs/workflow/HANDOFF.mdに現在の作業状況を残す案を作ってください。
docs/product/REQUIREMENTS.md、docs/product/SPECIFICATION.md、docs/product/IMPLEMENTATION_PLAN.mdはまだ更新しないでください。
```

## 変更完了後の同期

```text
変更作業が完了しました。
docs/workflow/TASK_TRACKER.mdとdocs/workflow/HANDOFF.mdの作業履歴を確認し、
完了した内容に合わせてdocs/product/REQUIREMENTS.md、docs/product/SPECIFICATION.md、docs/product/IMPLEMENTATION_PLAN.mdを同期する案を作ってください。
実際に完了していない内容は3文書へ書かないでください。
```

## 整合性チェック

```text
docs/product/REQUIREMENTS.md、docs/product/SPECIFICATION.md、docs/product/IMPLEMENTATION_PLAN.md、
docs/workflow/TASK_TRACKER.md、docs/workflow/HANDOFF.mdの整合性を確認してください。
この依頼ではファイルを編集しないでください。
矛盾があれば、ファイル名と理由を短く示してください。
```

## 失敗復旧

```text
進行中に問題がありました。
作業を止めて、問題点、原因、再発防止策、次の一問を短く提示してください。
この依頼ではファイルを編集しないでください。
成果物リポジトリ側のdocs/memory/FAILURE_MEMORY.mdへ書く必要がある場合も、まず記録案だけ出してください。
教材リポジトリ側のdocs/memory/FAILURE_MEMORY.mdがあるとは説明しないでください。
```

## Step 1/7

```text
Step 1/7として、AI駆動開発の土台を作ります。
成果物リポジトリの開発に入る前には、別画面でUbuntu/WSL CLIを起動するよう必ず促してください。
フォルダ構成、メモリー用Markdown、設計用Markdownの役割を確認し、
docs/product/REQUIREMENTS.md、docs/product/SPECIFICATION.md、docs/product/IMPLEMENTATION_PLAN.md、
docs/workflow/TASK_TRACKER.md、docs/workflow/HANDOFF.mdの初期案を作ってください。
あわせてLEARNING_TASK_TRACKER.mdとLEARNING_HANDOFF.mdの初期案も作ってください。
まず更新案だけ提示してください。
```

## Step 2/7

```text
Step 2/7として、index.htmlの画面構成案を作ります。
docs/product/REQUIREMENTS.mdとdocs/product/SPECIFICATION.mdを確認し、
タスク追加フォームと一覧表に必要な項目を整理してください。
index.htmlへ書き込む前に画面構成案を提示してください。
```

## Step 3/7

```text
Step 3/7として、style.cssの見た目方針を作ります。
docs/product/SPECIFICATION.mdを確認し、見やすいタスク表の色、余白、状態表示の案を作ってください。
style.cssへ書き込む前に見た目の方針を提示してください。
```

## Step 4/7

```text
Step 4/7として、app.jsの動作案を作ります。
docs/product/SPECIFICATION.mdを確認し、タスク追加、空欄チェック、追加後の入力リセットの流れを整理してください。
app.jsへ書き込む前に処理の流れを提示してください。
```

## Step 5/7

```text
Step 5/7として、追加機能や削除する機能を検討します。
docs/workflow/TASK_TRACKER.mdとdocs/workflow/HANDOFF.mdを先に確認し、
編集、削除、保存のうち入れるものと入れないものを整理してください。
3文書はまだ更新しないでください。
```

## Step 6/7

```text
Step 6/7として、操作確認とREADME.md案を作ります。
index.html、style.css、app.jsの想定内容とdocs/product/SPECIFICATION.mdを確認し、
操作確認リストとREADME.mdの案を作ってください。
```

## Step 7/7

```text
Step 7/7として、完成確認、ふりかえり、GitHubに残す準備をします。
docs/product/REQUIREMENTS.md、docs/product/SPECIFICATION.md、docs/product/IMPLEMENTATION_PLAN.md、
docs/workflow/TASK_TRACKER.md、docs/workflow/HANDOFF.md、README.mdの整合性を確認し、
完成、未完成、要確認のどれかで判定してください。
```
