const messages = {
  en: {
    "app.eyebrow": "AI-driven development",
    "app.title": "Dashboard Control Center",
    "app.loading": "Loading dashboard data.",
    "app.dataUnavailable": "Dashboard Data Unavailable",
    "app.readOnly": "Read-only",
    "app.snapshot": "Snapshot",
    "app.sourceFiles": "source files",
    "app.sourceCommands": "source commands",
    "app.lastUpdated": "Last updated",
    "aria.categories": "Dashboard categories",
    "aria.categoryHealth": "Category health",
    "aria.dataBoundary": "Data boundary",
    "aria.guidance": "Guidance",
    "aria.snapshotStatus": "Dashboard snapshot status",
    "nav.overview": "Overview",
    "nav.lessons": "Lessons",
    "nav.workflow": "Development Workflow",
    "nav.maintenance": "Maintenance Sync",
    "nav.safety": "Safety Actions",
    "summary.title": "Overview",
    "summary.nextSafeAction": "Next safe action",
    "summary.mode": "Mode",
    "summary.schema": "Schema",
    "summary.generated": "Generated",
    "summary.age": "Age",
    "summary.state": "State",
    "summary.blockers": "Blockers",
    "summary.noBlockers": "No blockers",
    "summary.blockingItems": "Blocking Items",
    "summary.partialFailures": "Partial Failures",
    "summary.warnings": "Warnings",
    "summary.health": "Category Health",
    "summary.explorePages": "Explore Pages",
    "summary.overviewDetail": "Snapshot summary and safe next action",
    "summary.currentPage": "Current page",
    "summary.openCategory": "Open category",
    "summary.snapshotNotice": "This dashboard shows a read-only snapshot. Refresh the data through maintained tooling before treating optional or live status as current.",
    "summary.lessonsCount": "Lessons",
    "summary.workflowFields": "workflow fields",
    "summary.maintenanceFields": "maintenance fields",
    "summary.securityFields": "security fields",
    "summary.items": "items",
    "summary.steps": "steps",
    "summary.checks": "checks",
    "lessons.title": "Lesson Surface",
    "lessons.description": "Learning progress, lesson settings, warnings, and next learning actions stay separate from workflow gates.",
    "workflow.title": "Workflow Surface",
    "workflow.description": "Product repository, documents, Git policy, Git sync, CI, approvals, and gate status remain visible without becoming browser-owned truth.",
    "maintenance.title": "Maintenance Surface",
    "maintenance.description": "As-built sync, workflow-pair sync, developer memory, and repo-local skill state are grouped here.",
    "security.title": "Security Surface",
    "security.description": "Security policy and approval state stay distinct from command previews.",
    "actions.title": "Command Previews",
    "actions.description": "These command previews are data only. The dashboard does not execute them.",
    "field.current": "Current",
    "field.learningMode": "Learning Mode",
    "field.workflowLanguage": "Workflow Language",
    "field.productLanguage": "Product Language",
    "field.learnerApproval": "Learner Approval",
    "field.source": "Source",
    "field.approval": "Approval",
    "field.gate": "Gate",
    "field.executionMode": "Mode",
    "field.executable": "Executable",
    "field.no": "no",
    "field.unknown": "unknown",
    "list.points": "Points",
    "list.warnings": "Warnings",
    "actions.hidden": "Command text hidden until preview-only safety is explicit.",
    "state.ready": "ready",
    "state.passed": "passed",
    "state.failed": "failed",
    "state.blocked": "blocked",
    "state.missing": "missing",
    "state.unknown": "unknown",
    "state.optional": "optional",
    "state.cached": "cached",
    "state.approval_required": "approval required",
    "risk.low": "low",
    "risk.medium": "medium",
    "risk.high": "high",
    "risk.critical": "critical",
    "health.lesson": "Lesson Health",
    "health.workflow": "Workflow Health",
    "health.maintenance": "Maintenance Health",
    "health.security": "Security Health",
  },
  ja: {
    "app.eyebrow": "AI-driven development",
    "app.title": "Dashboard Control Center",
    "app.loading": "ダッシュボードデータを読み込んでいます。",
    "app.dataUnavailable": "ダッシュボードデータを利用できません",
    "app.readOnly": "読み取り専用",
    "app.snapshot": "スナップショット",
    "app.sourceFiles": "参照ファイル",
    "app.sourceCommands": "参照コマンド",
    "app.lastUpdated": "最終更新",
    "aria.categories": "ダッシュボードカテゴリ",
    "aria.categoryHealth": "カテゴリ別の状態",
    "aria.dataBoundary": "データ境界",
    "aria.guidance": "ガイダンス",
    "aria.snapshotStatus": "ダッシュボードスナップショット状態",
    "nav.overview": "概要",
    "nav.lessons": "レッスン",
    "nav.workflow": "開発ワークフロー",
    "nav.maintenance": "保守・同期",
    "nav.safety": "安全確認",
    "summary.title": "概要",
    "summary.nextSafeAction": "次に安全に確認すること",
    "summary.mode": "モード",
    "summary.schema": "Schema",
    "summary.generated": "生成日時",
    "summary.age": "経過",
    "summary.state": "状態",
    "summary.blockers": "ブロッカー",
    "summary.noBlockers": "ブロッカーなし",
    "summary.blockingItems": "ブロッカー",
    "summary.partialFailures": "部分的な未確認",
    "summary.warnings": "警告",
    "summary.health": "カテゴリ別の状態",
    "summary.explorePages": "ページを確認",
    "summary.overviewDetail": "全体サマリーと次の安全な確認",
    "summary.currentPage": "現在のページ",
    "summary.openCategory": "カテゴリを開く",
    "summary.snapshotNotice": "このダッシュボードは読み取り専用のスナップショットです。任意確認やライブ状態を現在値として扱う前に、保守用ツールでデータを更新してください。",
    "summary.lessonsCount": "レッスン",
    "summary.workflowFields": "ワークフロー項目",
    "summary.maintenanceFields": "保守項目",
    "summary.securityFields": "安全項目",
    "summary.items": "項目",
    "summary.steps": "ステップ",
    "summary.checks": "チェック",
    "lessons.title": "レッスン",
    "lessons.description": "学習進捗、設定、警告、次の学習アクションをワークフローゲートと分けて表示します。",
    "workflow.title": "開発ワークフロー",
    "workflow.description": "成果物リポジトリ、文書、Git policy、Git sync、CI、承認、ゲート状態をブラウザ側の真実にせず表示します。",
    "maintenance.title": "保守・同期",
    "maintenance.description": "as-built sync、workflow pair、developer memory、repo-local skill の状態をまとめます。",
    "security.title": "安全確認",
    "security.description": "Security policy と承認状態を command preview から分けて表示します。",
    "actions.title": "Command Previews",
    "actions.description": "ここにあるコマンド候補は表示専用です。ダッシュボードからは実行しません。",
    "field.current": "現在地",
    "field.learningMode": "学習モード",
    "field.workflowLanguage": "表示言語",
    "field.productLanguage": "開発言語",
    "field.learnerApproval": "学習者承認",
    "field.source": "Source",
    "field.approval": "承認",
    "field.gate": "Gate",
    "field.executionMode": "Mode",
    "field.executable": "実行可否",
    "field.no": "いいえ",
    "field.unknown": "不明",
    "list.points": "ポイント",
    "list.warnings": "警告",
    "actions.hidden": "preview-only の安全条件が明示されるまで、コマンド文字列は非表示です。",
    "state.ready": "準備完了",
    "state.passed": "通過済み",
    "state.failed": "失敗",
    "state.blocked": "ブロック中",
    "state.missing": "未設定",
    "state.unknown": "未確認",
    "state.optional": "任意確認",
    "state.cached": "キャッシュ",
    "state.approval_required": "承認が必要",
    "risk.low": "低",
    "risk.medium": "中",
    "risk.high": "高",
    "risk.critical": "重大",
    "health.lesson": "レッスン状態",
    "health.workflow": "ワークフロー状態",
    "health.maintenance": "保守状態",
    "health.security": "安全状態",
  },
};

export function resolveLocale(languages = []) {
  const requested = Array.isArray(languages) && languages.length ? languages : ["en"];
  return requested.some((language) => String(language).toLowerCase().startsWith("ja")) ? "ja" : "en";
}

export function createTranslator(locale) {
  const selected = messages[locale] ? locale : "en";
  return function translate(key, fallback = key) {
    return messages[selected][key] ?? messages.en[key] ?? fallback;
  };
}

export function formatDateTime(value, locale) {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    return value || "";
  }
  return new Intl.DateTimeFormat(locale, {
    dateStyle: "medium",
    timeStyle: "short",
  }).format(date);
}

export function formatRelativeAge(value, locale, now = new Date()) {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    return "";
  }
  const deltaSeconds = Math.round((date.getTime() - now.getTime()) / 1000);
  const absSeconds = Math.abs(deltaSeconds);
  const formatter = new Intl.RelativeTimeFormat(locale, { numeric: "auto" });
  if (absSeconds < 60) {
    return formatter.format(deltaSeconds, "second");
  }
  const deltaMinutes = Math.round(deltaSeconds / 60);
  if (Math.abs(deltaMinutes) < 60) {
    return formatter.format(deltaMinutes, "minute");
  }
  const deltaHours = Math.round(deltaMinutes / 60);
  if (Math.abs(deltaHours) < 24) {
    return formatter.format(deltaHours, "hour");
  }
  return formatter.format(Math.round(deltaHours / 24), "day");
}
