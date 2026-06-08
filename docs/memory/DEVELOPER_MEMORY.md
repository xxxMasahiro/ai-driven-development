## Required baseline memory for lesson checks

Approval checkpoints now have tooling enforcement.
The 7-day lesson command is `tools/lesson 学習モード <A|B|C>`.
The STEP 1-14 lesson command is `tools/lesson14 学習モード <A|B|C>`.
Learning mode can be changed at any time during either lesson.
Standard language choices should include `ja`, `en`, `ko`, `zh-CN`, `zh-TW`, `es`, `pt-BR`, `fr`, `de`, `id`, `vi`, `th`, `hi`, and `ar`, while `zh` remains a `zh-CN` alias and custom values remain available.
Implementation must remain refactorable, ecosystem-friendly, reusable, and general.
Existing functionality must not be traded away.
Final tests pass only when every improvement or problem recorded in this developer memory is implemented, explicitly deferred, or covered by an accepted follow-up.
Explain MCP Purpose Before MCP Workflows.

**結論**
シームレス連携は「部分的には反映されるが、完全ではない」です。
CLI操作後に `tools/dashboard-data` の snapshot が更新されればダッシュボードへ反映されます。ただし、レッスン・自由開発・外部リポジトリ・Git/CI/security gate の結果が自動で一貫した証跡に変換される仕組みは未完成です。

**実施内容**
- STEP 1-14 を本リポジトリで実操作
  - 学習モード: `A`
  - 表示言語: `ja`
  - 成果物開発言語: `en`
  - `setup.index` を承認、開始、通過
  - 現在地は `setup.github-login` に更新され、dashboard JSON に反映済み
- 外部リポジトリを作成
  - `/home/masahiro/projects/task-tracker-repository`
  - 簡単な静的チャットシステムを作成
  - `docs/product/`, `docs/workflow/`, `ops/`, `src/`, `tests/`, `.github/workflows/` を作成
  - 外部 repo は clean、コミット2件作成済み
- サブエージェント3体で、lesson / free-development / dashboard UI の観点を分担して精査済み

**現在の反映状態**
最新 snapshot では次の状態です。

- `summary.mode`: `development`
- STEP 1-14: `ready`
- STEP 1-14 current step: `setup.github-login`
- product repository: `ready`
- product documents: `ready`
- product authority: `not_run`
- product authority required missing: `[]`
- evidence: `not_run`
- manual followups: Git sync、CI、as-built sync、workflow pair、security gate など

**重大な問題**
1. **完全なシームレス連携ではない**
   `tools/dashboard-control-center` は約3秒ごとに snapshot を再生成する polling 方式です。CLI操作がイベントとして dashboard に直接流れる仕組みではありません。
   参照: [tools/dashboard-control-center](/home/masahiro/projects/ai-driven-development-lesson/tools/dashboard-control-center:61)

2. **Lesson Health の 66% はまだ誤解を招く**
   STEP 1-14 は反映されていますが、上部の Lesson Health は `STEP 1-7` と `advanced` も同じ分母に入るため、STEP 1-14だけを見たいユーザーには不自然です。アクティブなレッスン単位の集計が必要です。

3. **自由開発なのに dashboard-data が `product-improvement` 固定**
   外部 repo authority の context が `free-development` ではなく固定で `product-improvement` になっています。自由開発のチャットシステムを正確に表現できません。
   参照: [tools/dashboard-data](/home/masahiro/projects/ai-driven-development-lesson/tools/dashboard-data:335)

4. **canonical docs と root docs の二重基準**
   新 authority は `docs/product/*` と `docs/workflow/*` を見ますが、既存 gate と一部 dashboard 判定は root の `REQUIREMENTS.md`, `TASK_TRACKER.md`, `HANDOFF.md` を見ます。実地で `authority は読めるが documents/gate は落ちる` 状態を再現しました。

5. **evidence 複数行で不正 JSON**
   `.git/product-gate-evidence/index.tsv` に複数 evidence 行があると、`product-repository-authority status --json` が不正 JSON を出しました。その結果 `dashboard-data` も不正 JSON になり、control-center snapshot 更新が失敗します。これは高優先度です。

6. **failed evidence でも authority が ready**
   単一行の `failed` evidence で確認したところ、`product_authority.status` が `ready` のままで、blocker も空でした。`failed|blocked` を authority に反映できていません。
   参照: [tools/lib/product_repository_authority.sh](/home/masahiro/projects/ai-driven-development-lesson/tools/lib/product_repository_authority.sh:429)

7. **自由開発 gate は未通過**
   `free-development gate` は product security は通りましたが、root `TASK_TRACKER.md` の内容規約で停止しました。さらに Git sync は upstream なしで停止、CI は GitHub repo 未解決で停止します。これらは dashboard では manual followup のままで、自動証跡化されません。

**次回修正対象**
優先順位はこの順です。

1. product authority の JSON 生成バグ修正
2. `failed|blocked|stale|not_run` evidence を authority status/blockers に正しく反映
3. `free-development|product-improvement|external-integration` context を dashboard-data に渡す
4. root docs 判定を canonical resolver に統合
5. 外部 repo scaffold コマンド追加
6. Git/CI/security/workflow-pair 結果を `.git/product-gate-evidence/index.tsv` に安全に書く evidence writer 追加
7. dashboard に stale snapshot / last valid snapshot 表示を追加
8. Lesson Health を「全レッスン混在」ではなく、現在アクティブなレッスン中心に再設計

長いテストは、指示どおり今回は回していません。

はい。正確には、そこは**本リポジトリ本体ではなく、STEP 1-14 で使う標準の外部成果物リポジトリ**です。

今回そこにチャットシステムを作ったのは私の判断ミスです。理由は `lesson/LESSON_CONFIG_14_DAYS.tsv` が dashboard の外部リポジトリとして `task-tracker-repository` を見ていたため、実地検証を優先してそこを使いました。ただし、ユーザー意図としては「自由開発用の別外部リポジトリ」を作るべきでした。

現状:
- `/home/masahiro/projects/task-tracker-repository` にチャットシステムを作成済み
- これは STEP 1-14 用の標準成果物 repo 名
- 自由開発検証用としては不適切
- この事実自体が「dashboard が外部 repo を `task-tracker-repository` 固定で見てしまう」問題の再現にもなっています

次の修正対象にすべきです:
1. チャットシステムは別 repo、例 `chat-system-repository` へ分離
2. `task-tracker-repository` は STEP 1-14 用として初期化または削除
3. dashboard 側は外部 repo を固定名ではなく、自由開発・レッスン・改善ワークフロー別に選べるようにする

この時点では、こちらで勝手に削除や移動はしません。

## 次回イシュー: 正常に自動マージまで通す仕組み

Git管理の検証用自動化モードでは、`automation_level=sync`、`push_automation=auto`、`pr_creation=auto`、`pr_ci_monitoring=auto`、`main_ci_monitoring=auto`、`sync_monitoring=auto` まで設定できる。
ただし、現状では `merge_execution` の許容値が `manual|after_approval` であり、`developer_auto_merge_allowed=true` にしても、developer auto merge gates を機械的に満たす証跡ファイルと更新フローが未整備のため、正常系でも自動マージ完了まで通せない。

次回修正では、正常に自動マージまで通す仕組みを追加する。

必要な観点:
- `learning/GIT_WORKFLOW_DEVELOPER_AUTO_MERGE_GATES.tsv` または同等のゲート証跡を整備する。
- `pr_ci_success`、`target_pr_clear`、`target_branch_clear`、`merge_base_verified`、`local_remote_checked`、`failure_stop_enabled` を、手作業メモではなく既存チェック、CI、Git状態、PR状態から安全に更新できるようにする。
- 自動 push、PR 作成、CI 監視、main CI 監視、ローカル/リモート同期監視、自動マージ判定を、既存の `tools/git-workflow`、`tools/check_git_sync.sh`、`tools/check_ci_status.sh`、Git hooks、CI、pre-commit と接続する。
- 既存機能とのトレードオフは一切禁止し、STEP 1-7、STEP 1-14、自由開発、成果物改善、外部連携、既存CI、既存チェック、既存ドキュメント導線を壊さない。
- 危険操作、認証、remote削除、secret操作は自動化対象に含めず、必要な承認境界を維持する。
- 正常系ではサブエージェントが Git 管理設定に従い、push、PR、CI確認、同期確認、merge判定まで進められるようにする。
- ゲート不足、CI失敗、PR未解決、同期不一致、権限不足、認証不足、設定不足は blocker として dashboard と evidence に反映できるようにする。

このイシューは、今回の dashboard / lesson / free-development 検証で、自動化設定だけでは自動マージ完了まで到達できないことが分かったため追加する。

## 次回イシュー: ダッシュボード円グラフ進捗率の分母をユーザー目線へ直す

はい、不自然です。原因は実装上の分母がユーザー目線と合っていないためです。

現状の算出はこうです。

```text
Lesson Health = STEP 1-7 + STEP 1-14 + advanced
Workflow Health = product repo + authority + docs + git sync + CI + git gate + approval
Maintenance Health = as-built sync + workflow pair
Security Health = security gate + dangerous action approval
```

問題は、現在見たい対象が STEP 1-14 とその成果物なのに、未使用の STEP 1-7、advanced、optional、unknown、manual follow-up、未収集 evidence まで同じ進捗率の分母に入っていることです。

なので、現在の表示は「実際の進捗率」ではなく「静的な健康度カウント」になっています。たとえば今は:

```text
STEP 1-14: ready / current day5.main-ci
task-tracker repo: ready
product docs/ops/tests: ready
product authority: not_run
CI: optional
git sync: unknown
```

この状態でも、`not_run` や `optional` や `unknown` が warning 扱いで分母に残るため、ワークフロー状態が 28% のように低く見えます。

次回修正では、円グラフを少なくとも次のように分けるべきです。

```text
レッスン状態: 現在選択中のレッスンだけの進行率
ワークフロー状態: 現在選択中の product repo / workflow context だけの完了率
保守状態: 実行済みチェックと未確認フォローアップを分離
安全状態: 必須security gateと承認待ちを分離
```

特に `optional`、`not_run`、`unknown`、`approval_required` は、進捗率を下げる要素ではなく「未確認」「別枠の確認事項」として表示する方が自然です。

## 次回イシュー: 開発ワークフロー要確認をライブ状況カードへ変える

はい、その方が正しいです。

今の「開発ワークフローの要確認（先に確認してください）」は、実態としては固定の command preview / manual followup 寄りで、現在進行中のワークフロー状態をリアルタイムに説明できていません。だから、`day5.main-ci` で止まっているのに、表示上は初期値っぽく見えます。

本来ここに出すべきなのは、たとえば今ならこうです。

```text
現在進行中: STEP 1-14 / Step 5/14 / main CI
対象 repo: task-tracker-repository
状態: remote/upstream 未設定のため CI 実行確認待ち
次に必要: GitHub remote を作成・設定し、push 後に GitHub Actions を確認
自動化設定: push/PR/CI/sync は auto、merge は gate不足なら停止
```

つまり「先に確認してください」ではなく、次のようなライブ状況カードにするべきです。

```text
開発ワークフロー
現在の作業: mainブランチのCIを作成して実行する
対象: task-tracker-repository
進行状況: remote 未設定で停止
次の安全な操作: remote 設定の承認
ブロッカー: GitHub repository could not be resolved
最終更新: dashboard-data generated_at
```

改善方針としては、固定文言ではなく `lesson current step`、`product repo`、`git sync`、`CI status`、`product authority`、`free-development context`、`blockers` から組み立てる必要があります。これは次回修正対象に入れるべきです。

## 次回イシュー: 承認、Git同期、ゲート、CI、成果物の根拠をリアルタイム根拠表示にする

項目としてはそのままでよいです。ただし、見せ方と役割を変えるべきです。

現在の問題は、これらが「固定の確認リスト」に見えることです。本来は「いまのワークフロー状態を説明する根拠」として表示するべきです。

残してよい項目:

```text
承認
Git同期
ゲート
CI
成果物の根拠
```

ただし、それぞれはこう見せるのが自然です。

```text
承認: 次に必要な承認があるか
Git同期: local / remote / upstream が一致しているか
ゲート: 現在ステップに必要な gate が通っているか
CI: CIが未設定・実行中・成功・失敗のどれか
成果物の根拠: docs / tests / ops / evidence が揃っているか
```

今の `day5.main-ci` なら、表示例はこうです。

```text
承認: remote 設定が必要なら承認待ち
Git同期: upstream 未設定
ゲート: Step 5/14 gate は未完了
CI: GitHub repository 未解決
成果物の根拠: product authority は 15/15 ready、evidence は未収集
```

なので、項目名は残して、各項目の中身をリアルタイムな状態値に差し替えるのが良いです。固定文言や初期値ではなく、`dashboard-data` の実データから組み立てる形が必要です。

## 次回イシュー: 保守・同期も根拠付きライブ同期状態にする

はい、その方がよいです。

今の `As-built同期`、`Workflow Pair`、`Developer Memory`、`Repo-local Skills` は、実態としては「存在確認」や「手動フォローアップ」寄りで、現在の同期状態を説明できていません。

本来はこう見せるべきです。

```text
As-built同期:
現在の3文書と実装計画・タスク・ハンドオフが同期しているか
最後に確認したコマンド
同期済み / 未確認 / 失敗 / 修正待ち

Workflow Pair:
TASK_TRACKER と HANDOFF が同じ現在地・次アクションを指しているか
lesson側とproduct側を分けて表示
同期済み / 片側だけ更新 / 未確認

Developer Memory:
次回修正対象が記録済みか
今回の判断・問題点がメモリーに反映されたか
未同期の判断があるか

Repo-local Skills:
必要な skills が存在するか
今回のワークフローで参照した skill が最新ルートにあるか
未使用 / 使用済み / 不足 / 要更新
```

つまり、これらも単なる項目ラベルではなく「現状の根拠付きライブ同期状態」にするべきです。

表示例としては:

```text
保守・同期
As-built同期: 未確認
Workflow Pair: product側は同期済み、lesson側は更新中
Developer Memory: 今回の次回イシューを追記済み
Repo-local Skills: lesson14-facilitator / lesson-sync-gate を使用中
```

この方が、非エンジニアでも「今どこが揃っていて、どこが未確認か」が分かります。次回修正対象に入れる価値があります。

## 次回イシュー: 「手動確認フロー」を非エンジニア向け表示へ置き換える

「手動確認フロー」は、今のダッシュボード文脈ではかなり分かりにくい表現です。

意味としてはだいたいこれです。

```text
ダッシュボードが自動では判断できないので、
人またはエージェントがコマンドを実行して確認する必要がある項目
```

たとえば:

```text
./tools/check_ci_status.sh --product --required
./tools/check_git_sync.sh --product --required
./tools/check_as_built_sync_contract.sh
./tools/check_workflow_pair_sync.sh
```

ただ、非エンジニア向けには「手動確認フロー」ではなく、こう表示した方が自然です。

```text
まだ自動確認できていない項目
```

または

```text
次に確認が必要な項目
```

今の状況なら例はこうです。

```text
次に確認が必要な項目
- GitHub remote が未設定
- CI結果がまだ確認できない
- product authority の evidence が未収集
```

つまり「手動確認フロー」は機械側の都合が出ている言葉です。ダッシュボード上では別の言い方に変えた方がよいです。

## 次回イシュー: 保守・同期や開発ワークフローの一段目を現状報告にする

はい。そこも直すべきです。

今の「保守・同期」や「開発ワークフロー」の一段目は、項目名と固定説明が先に出ていて、現在何が起きているかが見えません。非エンジニア目線では、何を判断すればよいのか分からない表示です。

本来は、最初の一段目でこう出すべきです。

```text
開発ワークフロー
現在: STEP 1-14 / Step 5/14 / main CI 作成
対象: task-tracker-repository
状態: GitHub remote が未設定のため CI 確認待ち
次に必要: remote 設定と push
根拠: product docs/ops/tests は揃っている。evidence は未収集。
```

```text
保守・同期
現在: 文書同期と引き継ぎ確認
状態: Developer Memory は追記済み。As-built同期とWorkflow Pairは未確認。
次に必要: 同期チェックを実行して、結果をdashboard evidenceへ反映
根拠: docs/memory/DEVELOPER_MEMORY.md は更新済み。snapshotはまだ確認結果を持っていない。
```

つまり、一段目は「説明」ではなく「現状報告」にするべきです。

項目名は残してよいですが、表示順を変えるのが良いです。

```text
1. いま何が進行中か
2. どこで止まっているか
3. 次に何が必要か
4. その判断の根拠
5. 詳細項目: 承認 / Git同期 / ゲート / CI / 成果物根拠
```

これも次回修正対象に入れるべきです。現在の表記は、実データとつながっていない固定案内に見えてしまいます。

## 次回イシュー: 安全確認とPartial Failuresもリアルタイム状態へ同期する

はい、その通りです。

安全確認も、他ページと同じくリアルタイムの現状同期が必要です。今の安全確認は「危険操作の承認が必要」や「security gate 未確認」のような抽象表示に寄っていて、現在のワークフローで何が安全上の停止理由なのかが見えにくいです。

特に `Partial Failures` は、ワークフロー中にブロッカーが出たら表示するのが自然です。

今なら例として:

```text
Partial Failures
- CI確認: GitHub repository could not be resolved
- Git同期: upstream 未設定
- Product evidence: gate結果が未収集
```

ただし `Partial Failures` に入れる対象は整理した方がよいです。

入れるべきもの:

```text
実行済みの確認で失敗したもの
現在の進行を止めているもの
次の安全な操作が必要なもの
```

入れない方がよいもの:

```text
まだ未来ステップで使う予定のもの
optional な未設定
単なる未確認
現在の操作に関係ない warning
```

なので、`Partial Failures` は常時項目として表示しつつ、空なら:

```text
Partial Failures: なし
```

ブロッカーがあるなら:

```text
Partial Failures
CI: GitHub repository could not be resolved
Git同期: upstream 未設定
次に必要: remote 設定を確認
```

という形が良いです。

安全確認ページも、固定の説明ではなく次の実データから組み立てるべきです。

```text
現在のステップ
対象 repo
承認状態
Git同期
CI状態
security gate
product authority
blockers
partial_failures
manual_followups
```

この方針で次回修正対象に入れるべきです。

## 次回イシュー: コマンドプレビューを現在の設定と状態に合わせて動的化する

はい。コマンドプレビューも現状に合っていません。

今のプレビューは固定で並んでいるだけで、現在の設定や状態を十分に反映していません。たとえば今は Git workflow を最大自動化寄りに変えています。

```text
automation_level: sync
push_automation: auto
pr_creation: auto
pr_ci_monitoring: auto
main_ci_monitoring: auto
sync_monitoring: auto
developer_auto_merge_allowed: true
merge_execution: after_approval
```

それなのに、プレビューが「手動で確認してください」「preview only」中心のままだと、実際の運用と矛盾して見えます。

本来はこう出すべきです。

```text
現在の設定に基づく次の操作
- Git同期: 自動監視対象
- Push: 自動実行対象
- PR作成: 自動実行対象
- PR CI: 自動監視対象
- Main CI: 自動監視対象
- Merge: 自動マージゲート未整備のため停止
```

今の状況なら、プレビューはこうなるべきです。

```text
次に実行される可能性がある操作
- remote 設定: 承認が必要
- push: remote 設定後は自動
- PR作成: 自動
- CI監視: 自動
- merge: developer auto merge gate 未整備のため blocker
```

つまり、コマンドプレビューは固定リストではなく、少なくとも次を見て動的に変える必要があります。

```text
Git workflow settings
現在の lesson step
対象 repo
remote/upstream 状態
CI状態
承認状態
dangerous action boundary
blockers
```

これも次回修正対象です。今の表示だと、設定を変えてもダッシュボードがその変化を説明できていません。

## 原文追記: 未記録の重要指摘

ダッシュボードに今回削除したのにデータが反映されてないようです。CLIで進めたレッスンやワークフローとダッシュボードのデータ共有をリアルタイムでシームレスに連携したいです。

ダッシュボードと内部デートの共有・連携がリアルタイムでシームレスにできているのか、多角的に精査・検証する必要がありそうです。

また、レッスンは内部リポジトリで完結するので良いですが、ワークフローは外部リポジトリの状態を読み込まなければならないはずです。今の実装では外部リポジトリ運用が弱いと思います。

外部リポジトリは、本リポジトリである内部リポジトリのファイル構成を踏襲して外部リポジトリ内にファイル構成を作成することが必用だと考えます。たとえば、.git,gitihub,githooks,docs,AGENY.MD,playwriteなどなど、本リポジトリで外部リポジトリを完全に運用し、ダッシュボードへ必用データを共有・連携してリアルタイムでシームレスに表示するまでの一連の仕組みが未だないと思います。そもそも外部リポジトリのワークフローさえ正確に回せないのではないです。

まずは、整合性が取れる形で正確に内部および外部リポジトリを同じように運用できることが重要で、そのうえでそれら運用データをダッシュボードへ完全に間違いなく正確にリアルタイムでシームレスに同期実行される必要があります。

docs\に整理できるものはルートから外した方が良くないですか。ファイルが多すぎて見通しが悪いです。

外部リポジトリのファイル構成です。

docs\へ整理したいのは外部ですよ。ルート直下が多すぎます。

task-tracker-repository/は教材で作成される外部リポジトリですが、本リポジトリにはユーザーが自由に開発できるメニューがあります。 task-tracker-repository/以外の開発者が自由に作成する外部リポジトリのファイル構成も基本は task-tracker-repository/と同じで状況の応じてテスト・CIなど追加する感じですか。

それなら、用途別に追加に追加してもダッシュボードで完全に管理できないとだめです。そのあたりは徹底できていますか。

今、レッスンは初期化したはずなのにレッスン状態66%とかおかしくないですか。ワークフローや保守状態、安全状態も何かおかしいです。リポジトリのレッスンとワークフローのデータはシームレスに連携されているのでしょうか。

シームレス連携はされてますか。

あなたの方でサブエージェントを活用し本リポジトリ直接操作し、レッスンと自由開発ワークフローを回しながらダッシュボードにデータが正しく反映されるか精査・検証し、結果を統合的して体系的に整理して報告してください。レッスンはSTEP 1-14: 実践レッスン、ワークフローは自由開発で簡単なチャットシステムを作成します。この際の外部リポジトリを自由に作成して構いません。原則、自律的に進めてすべてが完了した後に開発者へ報告してください。なお、報告に関しては、ダッシュボート以外にも改善点や問題点があればそれらも全て報告して欲しいです。次回の修正対象とします。

\\wsl.localhost\Ubuntu\home\masahiro\projects\task-tracker-repositoryの中にチャットシステムが生成されています。ここはレッスン用のレポジトリですよね。

レッスンはタスク管理表を作る仕様で、きちんとレッスンを最後まで踏襲してください。チャットは自由開発のメニューを実行してワークフローが正常に動くかまで確認します。とあえず、今回発見された問題を開発者メモリーへ記録します。開発者メモリーを削除して初期化したうえで原文のまま記録してください。記録が終わったら、今作成した外部リポジトリを削除してレッスンを初期化しリモート側にもあれば同様に削除します。その後、サブエージェント（xhigh）を複数立ち上げ1名はSTEP 1-14: 実践レッスンを最初から最後まで進めさせ問題点や改善点を抽出させます。もう1名は自由開発ワークフローで簡単な勤怠管理システムを作成させ、その中で見つかった改善点や問題点を抽出させます。最後にこれらの結果をあなたが統括して体系的に整理して開発者へ報告してください。ここまで危険操作や変段に悩むとき以外は開発者承認を求めないで自律的に進めなければなりません。サンドボックス承認が出るような処理は出来るだけ回避して同様の実行ができないかよく検討し、それでもダメなら開発者承認をとるようにしてください。

今回の作業に無関係な他の既存内容は一切変更禁止です。

自由開発も再度サブエージェント（xhigh）を起動しproject\配下にリポジトリと成果物をきちんと開発者が確認できる形で作成してください。ただし、作るだけではダメで、メニューの自由開発ワークフローに準拠して作成することが重要です。そうでないと検証になりません。

自由開発はただ作るだけじゃダメですよ。メニューの自由開発ワークフローに準拠して作成することが重要です。そうしないと自由開発ワークフローの検証ができません。

ダッシュボードにデータが反映されるか見るのも目的ですよ。

それいがいにも改善点、問題点があればあとで整理して報告してください。

レッスンも自由開発ワークフローもダッシュボートの検証のために自律的にサブエージェントを起動して運用させてます。

ダッシュボードが更新されてないようにみえます。レッスンも自由開発ワークフローもです。

task-tracker-repositoryの成果物がないですね。

なぜ、最後までレッスンを進めて完了してとお願いしたのにレッスン3でやめたんですか。

それはサブエージェントにやらせください。あなたには僕と会話してもらいます。

Git管理はマージ、CI、ローカルとリモート同期まで自動化するモードがありましたよね。どの設定になっていますか。

今は検証なのですべて自動化するモードでサブエージェント側は設定してください。

実際の merge は
  ゲート不足なら blocker として報告とは、正常ならマージも自動で通るということですか

正常に自動マージまで通す仕組みを次のイシューとして開発者メモリーに追記してください。

ダッシュボードのレッスン状態、ワークフロー状態、保守状態、安全状態もレッスン、ワークフローともに完了しているのに進捗率が不自然。

これも開発者メモリーに原文のまま追記

開発ワークフローの要確認（先に確認してください）は、現在何が進行しているかをリアルタイムでシームレスに見せる方がよくないですか。現在は、初期値のまま全く更新されていないです。

承認、Git同期、ゲート、CI、成果物の根拠などはそのままの項目でよいですか

保守・同期のAs-built同期、Workflow Pair、Developer Memory、Repo-local Skillsも現状とリアルタイムでシームレスに同期した内容をその都度表示するほうがよくないですか。

手動確認フローとはなんでしょう。よくわかりません。

保守・同期や開発ワークフローの一段目もリアルタイムでシームレスに現状を同期して報告して欲しいで鵜。今の表記は何がなんだかわかりません。

安全確認も全体的に他のページと同様にリアルタイムでシームレスな同期が必要ではないですか。とくに、Partial Failuresはワークフロー中にブロッカー項目がでたら表示すべきだと思いますがいかがでしょうか。

コマンドプレビューも現在の設定に合ってないです。

保守・同期の再下段の参照ファイル、参照コマンド、読み取り専用ページは何ですか。

保守・同期ページの最下段にある3つは、実装上は `SourceBoundary` という「この画面のデータ境界」を示す欄です。

意味はこうです。

- `参照ファイル`
  - ダッシュボードJSONを作るときに参照した設定・契約・状態ファイルです。
  - 例: `DASHBOARD_DATA_SCHEMA.tsv`, `AS_BUILT_SYNC_CONTRACT.tsv`, `LESSON_STATE_14_DAYS.tsv`, `DEVELOPER_MEMORY.md` など。
  - 実体は `tools/dashboard-data` の `source_files` です。

- `参照コマンド`
  - このスナップショット生成の根拠になった読み取り系コマンドです。
  - 現在は `tools/dashboard-data` と `tools/product-repository-authority status --json` です。
  - 実体は `tools/dashboard-data` の `source_commands` です。

- `読み取り専用ページ`
  - このページから Git、CI、shell、保守コマンドを実行しないという安全境界です。
  - 表示文言は「データ更新やコマンド実行は保守用ツールで行ってください。」です。

ただし、これはかなり開発者向けの説明です。一般ユーザー目線では「何を確認すればよいか」ではなく「内部的に何を参照したか」が出ているので、今の表示位置・文言は分かりにくいです。改善するなら、通常表示では「データの根拠」として折りたたみ、保守・同期の主表示は「現在の同期状態」「未確認項目」「次に必要な確認」に寄せるべきです。

## 具体例: Step 10まで進んでもダッシュボードの見た目が変わらない

Step 10まで進んでいるのにダッシュボードは何も変化がない。

実測例:

```text
lesson14 progress: Step 10/14 付近まで進行
dashboard-data current_step: day10.e2e-test
Lesson Health: 66%
git_sync_status: unknown
ci_status: optional
product_authority.status: blocked または not_run
```

この状態では、内部データ上は `lessons.step_1_14.current_step` が `day10.e2e-test` へ進んでいるが、トップページや各詳細ページの主要表示はほとんど変化して見えない。

問題点:

- CLI上のレッスン進行と、ダッシュボード上の見た目の進行が一致して見えない。
- `current_step` は更新されても、円グラフや主要カードが固定的な健康度表示のままで、ユーザーには進んだことが分からない。
- Step 5で GitHub remote、push、PR、CI、merge、main同期まで実行しても、dashboard snapshot 上では `git_sync_status: unknown`、`ci_status: optional` が残る。
- product repo に Playwright E2E を追加して Step 10 まで進めても、ダッシュボードは「現在何を確認済みか」「どこまで完了したか」「次に何をするか」を直感的に示せていない。
- 非エンジニア目線では、実際に作業が進んでいるのか、dashboardが更新に失敗しているのか、単に表示設計が悪いのか判断できない。

改善方針:

- トップページと詳細ページの最上段に、現在のレッスン step、対象 product repo、直近で通過した gate、次の操作を大きく表示する。
- `Lesson Health` は全レッスン混在の静的健康度ではなく、現在選択中の STEP 1-14 の実進行率を主表示にする。
- Git sync、CI、authority、evidence は `unknown` や `optional` のまま固定表示せず、直近の実行結果、未確認理由、確認コマンド、最終確認時刻を表示する。
- dashboard-data が live Git/CI を実行しない設計なら、その制約をユーザーに分かる形で「未同期」「未確認」「別ツールで確認済みだが snapshot 未反映」などに分ける。
- レッスンやワークフローが進んだタイミングで、dashboard-data / dashboard-control-center がどの状態まで追従したかを確認できる検査を追加する。

## 原文追記: メニュー全体のダッシュボード連携とトップページ選択

ダッシュボートはこれらメニューの内容すべてとリアルタイムでシームレスに連携できないといけませんよね。

トップページのどこかに下記を選択できる機能を導入してユーザーに選択させれば、あとは共通コンポーネントのはずなのでユーザ選択内容に合わせてリアルタイムでシームレスにデータ連携・同期ができれば良い感じがします。

  - STEP 1-7: 基礎レッスン
  - STEP 1-14: 実践レッスン
  - 応用レッスン
  - 自由開発
  - 成果物を改善
  - 外部連携
  - 教材そのものを改善

## 原文追記: サブエージェント完了報告のダッシュボード問題点

**現在地**
- lesson14: `46/58 completed`
- current step: `day12.subagents-plan` / Step 12「複数サブエージェントの役割分担を設計する」
- product repo: `main...origin/main`, clean

**通過した step**
- `day10.e2e-test`
- `day10.e2e-local-run`
- `day10.sync-gate`
- `day11.e2e-ci`
- `day11.failure-learning`
  最新 CI が成功していたため、失敗ログなし・修正不要として run/job を確認して通過。
- `day11.docs-sync`
- `day11.sync-gate`

**変更/commit/push**
- product repo:
  - `4da5aae Run Playwright E2E in CI`
    - `.github/workflows/ci.yml` に `npm ci`, Playwright Chromium install, `npm test`, `npm run test:e2e` を追加
  - `3997895 Sync docs for CI E2E`
    - product 3文書、workflow履歴、ops manifest を CI E2E 実態に同期
- 両方 push 済み。`origin/main` は `3997895`。

**実行チェック**
- `npm test` PASS: 4 tests
- `npm run test:e2e` PASS: 1 Playwright test
- GitHub Actions:
  - `27102632264` success
  - `27102785913` success、CI 内で `npm run test:e2e` まで PASS
- `./tools/check_git_sync.sh --product --required` PASS
- `./tools/check_ci_status.sh --product --required` PASS
- `./tools/check_lesson14_sync.sh` PASS

**dashboard 反映状況**
- `dashboard-data` current step: `day12.subagents-plan`
- lesson metric: `healthy 2 / warning 1 / problem 0`, `66%`, status `unknown`
- product authority: `not_run` だが required `15/15 ready`
- product authority conflicts/blockers: 解消済み、`conflicts: []`, `product_operation_blockers: []`
- live git/CI は dashboard snapshot 上では `unknown` / `optional` のまま。手動チェックでは両方 PASS。

**dashboard 問題点・改善点**
- read-only snapshot は live product Git/CI を実行しないため、実態 PASS でも `git_sync_status: unknown`, `ci_status: optional`。
- `step_1_7` が missing のため overview/lesson が warning。
- product authority evidence は `not_collected` / `not_run` のまま。
- GitHub Actions に Node.js 20 actions deprecation warning あり。現時点では非 blocking。

**blocker / 次操作**
- blocker なし。
- 次操作は Step 12 `day12.subagents-plan` の開始・通過判断。

## 原文追記: Git管理設定とSecurity確認の扱い

ただし、次の2項目をどうすればよいでしょうか。
    - Git管理設定
    - Security確認

この2つは、開発ワークフロー、保守・同期、安全確認に表示されているデータとは異なるのですか。

Git管理設定 と Security確認は、トップページのみ表示となる感じですか。

整理方針:

- `Git管理設定` と `Security確認` は、主メニュー selector の一項目として扱うより、選択中メニューに常時紐づく横断ステータスとして扱う。
- トップページでは概要表示する。
- `Git管理設定` の詳細は `開発ワークフロー` に表示する。
- `Security確認` の詳細は `安全確認` に表示する。
- `Git workflow settings`、`Security policy`、証跡、同期状態は `保守・同期` に表示する。
- 同じデータを重複実装するのではなく、共通データ源を `開発ワークフロー`、`保守・同期`、`安全確認` で目的別に見せ分ける。

```text
トップページ:
横断ステータスとして概要表示する

開発ワークフロー:
Git管理設定を詳しく表示する

安全確認:
Security確認を詳しく表示する

保守・同期:
Git/Security の設定ファイル、証跡、同期状態を表示する
```

## 原文追記: 新機能入りモックを先に作る方針

あたらしくデザインが変わるのですでに存在するモックを参考にこれら新機能を搭載したモックを各ページ用に用意してから進めたほうがよいですか。

\\wsl.localhost\Ubuntu\home\masahiro\projects\ai-driven-development-lesson\dashboard-control-centerへモック画像で配置すればよいですよね。

その方針でモックを作成し、かつこれまでの話を振り返り、改善点や問題点として未だに開発者メモリーへ追記されていな内容があれば追記してください。

作成したモックは必ず\\wsl.localhost\Ubuntu\home\masahiro\projects\ai-driven-development-lesson\dashboard-control-center配下へ配置してください。

今回作成した新モック:

```text
dashboard-control-center/mocks/mock-context-overview.png
dashboard-control-center/mocks/mock-context-lessons.png
dashboard-control-center/mocks/mock-context-workflow.png
dashboard-control-center/mocks/mock-context-maintenance.png
dashboard-control-center/mocks/mock-context-safety.png
```

モック方針:

- 既存モックを参考にする。
- トップページにメニュー selector を追加する。
- 選択中メニューに応じて共通コンポーネントがデータ連携する設計にする。
- `Git管理設定` と `Security確認` は横断ステータスとしてトップページに概要表示し、詳細は各詳細ページへ分散する。
- `Partial Failures` は空でも常時表示し、空なら「なし」と表示する。
- `参照ファイル`、`参照コマンド`、`読み取り専用ページ` は通常表示の主役にせず、「データの根拠」として下段または折りたたみ扱いにする。
- 実装前にこれらの新モックをUI/UX正本として確認する。

## 原文追記: 新モック方針の確認結果

確認しました。全体的にかなり直感的にわかりやすくなります。ユーザーからも好評なのでこの方針で進めたいです。まだ、実装はしませんが方針を開発者メモリーへ追記してください。

方針:

- 新しく作成した `mock-context-*` の5枚を、次回実装前のUI/UX方針として扱う。
- トップページでは、ユーザーが進めるメニューを選択できる selector を表示する。
- 選択中メニューに応じて、レッスン進行、対象リポジトリ、現在ステップ、次の操作、Git状態、CI状態、Security状態を直感的に表示する。
- `Git管理設定` と `Security確認` は、主メニューではなく横断ステータスとして扱う。
- `Git管理設定` はトップページで概要表示し、詳細は `開発ワークフロー` に表示する。
- `Security確認` はトップページで概要表示し、詳細は `安全確認` に表示する。
- `保守・同期` では Git/Security の設定ファイル、証跡、同期状態を表示する。
- `Partial Failures` は安全確認ページで常時表示し、空なら `なし` と表示する。
- `参照ファイル`、`参照コマンド`、`読み取り専用ページ` は、通常利用の主表示から外し、「データの根拠」として下段または折りたたみ扱いにする。
- この方針はまだ実装しない。次回の実装提案、実装プラン、文書同期、実装の順で進める。

## 原文追記: ダッシュボードUI/UX細部とモック準拠の未記録事項

上部のカテゴリ別の状態という表示はいりません。

また、4つのカード？で区分されている各項目は、隣の項目の高さと合わせてください。

次に安全に確認すること
Review lessons and accept for workflow
Review lesson readiness, blockers, and manual follow-ups before treating workflow status as ready.

承認が必要
対象
Lessons and workflow readiness
期待結果
Required approvals and checks are clear before operational actions.
リスク
低

----

このカードの項目だけモックデザインと合っていません。次に安全に確認することはネクストアクションに該当する項目ですが、モックでは枠外に出して左側に目印となる小さなアイコンを付けて見やすく表示されています。また、対象、期待結果、リスクの項目は背景色はなく白色で見やすく表示しています。背景色あるのは、Review lessons and accept for workflowの項目だけです。

あと、全体的に項目名の左にある小さなアイコンがモックとは異なります。これもモックと同じアイコンにしてください。

それと、レッスン状態、ワークフロー状態、保守状態、安全状態の円グラフは全部で４つありますが、モックと同じ4種類の色に分けて表示するようにしてください。色をわえることで毎日使うユーザーには色でどの項目かすぐ判断できて便利です。

先ほど指摘したこの個所に関しては全体にいえることです。

開発ワークフロー項目のアイコンはモックと同じものがしてくだあい。今のアイコンだとメガネにみえてしまいます。

それと、

対象
Lessons and workflow readiness
期待結果
Required approvals and checks are clear before operational actions.
リスク
低

の低の表示を円の中心に来るように微調整してください。

全体としてかなりデザイン面はよくなりました。あとは、トップページからリンクされている各詳細ページのデザインをサブエージェント（xhigh）を複数活用して精査・検証し、その結果をあなたが統括して改善点や問題点をまとめて表示してください。

本リポジトリを使う一般ユーザー目線からいうと、詳細ページでいろいろ表示されているが、何を確認しているのか、何が判断できるのか、まったくわかりません。このあたりも改善できないでしょうか。

これらの基本概念をまずはimagegenで各詳細ページのモックを作成してから始めた方が良くないですか。

現時点までのダッシュボードの詳細ページを確認しましたが、まだまだわかりにくいです。このままだと非エンジニアには何がなんだかまったくわからない。モックをデザインの正本としていまはとくかく細かいアイコンに至るまで100%そこに近づける感じで作業を進めてください。

UI/UXとしてモックのデザインが正解です。これなら非エンジニアがわかります。アイコンん、細かな表示面、内容に至るまでモックに100%近づける感じで進めてください。どうしても整合性が取れない点があれば報告してください。

デザイン面で一番大事なのは説明など効かなくても直感的に内容や操作がわかることです。

全体的にアイコンの背景色と実際のアイコンがずれている箇所が多いです。アイコンが背景色の中心に来るように調整してください。ページ上部1段目のアイコンに多発しています。

あと、トップページの僕が最初に言ったリスクの低の文字も背景色の中心にしてください。

詳細ページの各ページの1段目の円形の中にあるアイコンがすべて上に寄っています。中心に来るようによく確認して直してください。

それと、最初に言ったトップーエージの下記の低とうもじも円形の上に寄っています。中心に来るように直してください。

対象
Lessons and workflow readiness
期待結果
Required approvals and checks are clear before operational actions.
リスク
低　←　これです。

最上部：
AI-driven development

Dashboard Control Center
準備完了
development

----------------------------

上部：
スナップショット

概要
このダッシュボードは読み取り専用のスナップショットです。任意確認やライブ状態を現在値として扱う前に、保守用ツールでデータを更新してください。

----------------------------

それと再下段にビックリマークアイコンで「このダッシュボードは読み取り専用です。コマンド実行は「Safety Action」ページで安全にプレビューできます」、と小さく表示されていますが、文言は本リポジトリのコントロールパネル用にあわせて重要な注意書きをこのように簡潔に記載して欲しいです。

## 原文追記: 手動フォローアップと詳細表示の扱い

Partial Failuresが空でも項目だけは常に表示し、空ならなしとだけ表示するのがわかりやすいとお思います。また、手動フォローアップは同じ項目で表示せず上から3段目のコンテンツとして必要最小限だけ表示し、それ以外は別ページへ飛ぶのが良くないですか。コントロールパネルは折りたたみ表示の展開によって動的にページを崩さず、詳細は別ページで具体的に表示するほうがわかりやすく感じます。いかがでしょうか。

## 追記: selected context を共通データ概念として扱う

トップページのメニュー selector で選ばれた対象は `selected context` として扱う。
`selected context` には、選択中メニュー、対象外部リポジトリ、workflow context、lesson step、Git/CI/Security状態を紐づける。
各ページの共通コンポーネントは、この `selected context` を基準にリアルタイム同期表示する。
