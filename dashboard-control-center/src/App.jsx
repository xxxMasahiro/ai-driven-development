import {
  Activity,
  AlertTriangle,
  ArrowUp,
  ArrowRightCircle,
  BadgeAlert,
  BookOpen,
  BookMarked,
  Brain,
  CalendarDays,
  Check,
  CheckCircle2,
  ChevronRight,
  ChevronsRight,
  CircleAlert,
  CircleDashed,
  CircleHelp,
  CircleMinus,
  CircleX,
  ClipboardCheck,
  Clock,
  Code2,
  Compass,
  Copy,
  Database,
  Eye,
  ExternalLink,
  File,
  FileCheck2,
  FileJson,
  FileSearch,
  FileText,
  Flag,
  Folder,
  GitBranch,
  GitMerge,
  GitPullRequest,
  Globe2,
  GraduationCap,
  Home,
  Info,
  KeyRound,
  Link2,
  List,
  ListChecks,
  Lock,
  Pencil,
  RefreshCw,
  Scale,
  ShieldAlert,
  ShieldCheck,
  Settings,
  User,
  UserCheck,
  TerminalSquare,
  Target,
  TrendingUp,
  Waypoints,
  Wrench,
  Workflow,
} from "lucide-react";
import { useEffect, useMemo, useState } from "react";

import {
  asArray,
  displayKey,
  displayText,
  fetchDashboardDataSnapshot,
  normalizeRisk,
  normalizeState,
  objectEntries,
  pickFirst,
} from "./dashboardData.js";
import { createTranslator, formatDateTime, formatRelativeAge, resolveLocale } from "./i18n.js";

const stateIcons = {
  ready: CheckCircle2,
  passed: CheckCircle2,
  failed: CircleX,
  blocked: BadgeAlert,
  missing: CircleHelp,
  unknown: CircleHelp,
  optional: Info,
  cached: RefreshCw,
  not_run: CircleDashed,
  stale: Clock,
  approval_required: CircleAlert,
  manual_required: UserCheck,
};

const reviewStates = new Set(["failed", "blocked", "approval_required", "manual_required", "missing", "unknown", "optional", "cached", "not_run", "stale"]);

const statePriority = {
  blocked: 0,
  failed: 1,
  approval_required: 2,
  manual_required: 3,
  unknown: 4,
  missing: 5,
  optional: 6,
  cached: 7,
  not_run: 8,
  stale: 9,
  ready: 10,
  passed: 11,
};

function WorkflowCategoryIcon(props) {
  return <Workflow {...props} data-workflow-category-icon="true" />;
}

const navigation = [
  { id: "overview", labelKey: "nav.overview", healthKey: "health.lesson", Icon: Home, tone: "overview" },
  { id: "lessons", labelKey: "nav.lessons", healthKey: "health.lesson", Icon: BookOpen, tone: "lessons" },
  { id: "workflow", labelKey: "nav.workflow", healthKey: "health.workflow", Icon: WorkflowCategoryIcon, tone: "workflow" },
  { id: "maintenance", labelKey: "nav.maintenance", healthKey: "health.maintenance", Icon: Wrench, tone: "maintenance" },
  { id: "safety", labelKey: "nav.safety", healthKey: "health.security", Icon: ShieldCheck, tone: "safety" },
];

const repositoryNavigation = [
  { id: "repository-info", labelKey: "nav.repositoryInfo", Icon: Info, href: "#overview" },
  { id: "documents", labelKey: "nav.documents", Icon: FileText, href: "#maintenance" },
  { id: "settings", labelKey: "nav.settings", Icon: Settings, href: "#maintenance" },
];

const supportNavigation = [
  { id: "help", labelKey: "nav.help", Icon: CircleHelp, href: "#safety" },
  { id: "history", labelKey: "nav.history", Icon: Clock, href: "#maintenance" },
];

const contextMenuIcons = {
  step_1_7: BookOpen,
  step_1_14: BookOpen,
  advanced: GraduationCap,
  "free-development": Code2,
  "product-improvement": TrendingUp,
  "external-integration": Globe2,
  "lesson-repository-improvement": Pencil,
  unknown: CircleHelp,
};

const contextMenuTones = {
  step_1_7: "lesson-soft",
  step_1_14: "lesson",
  advanced: "advanced",
  "free-development": "code",
  "product-improvement": "improve",
  "external-integration": "external",
  "lesson-repository-improvement": "authoring",
  unknown: "unknown",
};

const overviewStatusConfig = {
  lessons: { Icon: BookOpen, tone: "lessons", labelKey: "overview.status.lessonProgress" },
  git: { Icon: Link2, tone: "git", labelKey: "overview.status.git" },
  ci: { Icon: CheckCircle2, tone: "ci", labelKey: "overview.status.ci" },
  security: { Icon: ShieldCheck, tone: "security", labelKey: "overview.status.security" },
};

function viewFromHash() {
  const hash = window.location.hash.replace(/^#/, "");
  return navigation.some((item) => item.id === hash) ? hash : "overview";
}

function StatusPill({ value, t, label, className = "" }) {
  const state = normalizeState(value);
  const Icon = stateIcons[state] || CircleDashed;
  const compactClass = state === "manual_required" ? "status--compact-label" : "";
  return (
    <span className={`status status--${state} ${compactClass} ${className}`.trim()} data-state={state}>
      <Icon aria-hidden="true" size={14} />
      {label || t(`state.${state}`, displayText(state))}
    </span>
  );
}

function RiskPill({ value, t }) {
  const risk = normalizeRisk(value);
  return (
    <span className={`risk risk--${risk}`} data-risk={risk}>
      {t(`risk.${risk}`, displayText(risk))}
    </span>
  );
}

function clampPercent(value) {
  const numeric = Number(value);
  if (!Number.isFinite(numeric)) {
    return 0;
  }
  return Math.min(100, Math.max(0, Math.round(numeric)));
}

function metricUnitLabel(unit, t) {
  const normalized = displayText(unit, "items");
  return t(`summary.${normalized}`, normalized);
}

function valueState(value) {
  return normalizeState(value && typeof value === "object" ? value.status : value);
}

function isReviewState(state) {
  return reviewStates.has(normalizeState(state));
}

function compareByStatePriority(left, right) {
  return (statePriority[normalizeState(left.state)] ?? 99) - (statePriority[normalizeState(right.state)] ?? 99);
}

function metricStatusText(metric, t) {
  if (!metric) {
    return t("detail.noMetric");
  }
  return `${clampPercent(metric.percent)}% / ${metric.total ?? 0} ${metricUnitLabel(metric.unit, t)}`;
}

function technicalKeyFromId(id) {
  return String(id).replace(/_/g, ".");
}

function presentationKeyFromId(id) {
  const map = {
    "development.product_repository": "product_repo",
    "development.documents": "documents",
    "development.git_sync_status": "git_sync",
    "development.ci_status": "ci",
    "git_workflow.policy_status": "policy",
    "git_workflow.settings_status": "settings",
    "git_workflow.gate_status": "gate",
    "git_workflow.approval_status": "approval",
    as_built_sync_status: "as_built_sync",
    workflow_pair_status: "workflow_pair",
    developer_memory_status: "developer_memory",
    skills_status: "repo_local_skills",
    policy_status: "policy",
    gate_status: "gate",
    dangerous_action_approval: "approval",
  };
  return map[id] || technicalKeyFromId(id);
}

function sourcePresentationKey(source) {
  const id = displayText(source);
  const map = {
    ci_required_gate: "ci.required_checks",
    workflow_pair_sync: "workflow.unknown_pair",
    security_gate: "safety.gate.blocked",
    product_ci_live: "ci.live",
    product_git_sync_live: "git_sync.live",
    as_built_sync_live: "as_built.live",
    workflow_pair_live: "workflow_pair.live",
    git_workflow_gate_live: "git_gate.live",
    product_security_gate_live: "safety_gate.live",
  };
  return map[id] || displayKey(id);
}

function contextLabel(menuId, t) {
  const id = displayText(menuId, "unknown");
  return t(`context.menu.${id}`, displayKey(id));
}

function workflowContextLabel(workflowContext, t) {
  const id = displayText(workflowContext, "unknown");
  return t(`context.workflow.${id}`, displayKey(id));
}

function securityScopeLabel(context, t) {
  const workflowContext = displayText(context.workflow_context, "unknown");
  if (workflowContext === "lesson" && displayText(context.target_repository?.path_state, "") === "configured") {
    return t("mock.context.securityScopeLessonProduct");
  }
  return workflowContextLabel(workflowContext, t);
}

function selectedContextData(data) {
  return data.selected_context && typeof data.selected_context === "object" ? data.selected_context : {};
}

function contextsByMenu(data) {
  return data.contexts_by_menu && typeof data.contexts_by_menu === "object" && !Array.isArray(data.contexts_by_menu) ? data.contexts_by_menu : {};
}

function contextDataForMenu(data, menuId) {
  const id = displayText(menuId, "");
  return contextsByMenu(data)[id] || (displayText(selectedContextData(data).menu_id, "") === id ? selectedContextData(data) : null);
}

function availableContexts(data) {
  return asArray(data.available_contexts);
}

function contextIconFor(menuId) {
  return contextMenuIcons[displayText(menuId, "unknown")] || contextMenuIcons.unknown;
}

function contextToneFor(menuId) {
  return contextMenuTones[displayText(menuId, "unknown")] || contextMenuTones.unknown;
}

function MenuTileLabel({ label }) {
  const text = displayText(label);
  const match = text.match(/^(STEP\s+\d+-\d+)\s+(.+)$/i);
  if (!match) {
    return text;
  }
  return (
    <>
      <span className="menu-tile__step-code">{match[1]}</span>
      <span className="menu-tile__step-name">{match[2]}</span>
    </>
  );
}

function PageTitleHeader({ viewId, Icon, title, subtitle, data, locale, t, actionLabel, headingId }) {
  const generated = formatGenerated(data, locale);
  return (
    <header className={`page-title page-title--${viewId}`}>
      <div className="page-title__main">
        <span className="page-title__icon">
          <Icon aria-hidden="true" size={34} />
        </span>
        <div>
          <h2 id={headingId}>{title}</h2>
          {subtitle ? <p>{subtitle}</p> : null}
        </div>
      </div>
      <div className="page-title__meta">
        {generated ? (
          <span>
            <Clock aria-hidden="true" size={15} />
            {t("app.lastUpdated")}: {generated}
          </span>
        ) : null}
        {actionLabel ? (
          <button className="refresh-button" type="button" onClick={() => window.location.reload()}>
            <RefreshCw aria-hidden="true" size={15} />
            {actionLabel}
          </button>
        ) : null}
      </div>
    </header>
  );
}

function MenuTileStrip({ data, t }) {
  const selected = displayText(selectedContextData(data).menu_id, "unknown");
  const contexts = availableContexts(data);
  if (!contexts.length) {
    return null;
  }
  return (
    <section className="menu-tile-panel" aria-labelledby="menu-tile-heading">
      <h3 id="menu-tile-heading">{t("overview.menuTitle")}</h3>
      <div className="menu-tile-grid">
        {contexts.map((context) => {
          const menuId = displayText(context.menu_id, "unknown");
          const Icon = contextIconFor(menuId);
          const isSelected = menuId === selected;
          const label = contextLabel(menuId, t);
          return (
            <article className={`menu-tile menu-tile--${contextToneFor(menuId)}${isSelected ? " is-selected" : ""}`} key={menuId} data-menu-tile={menuId}>
              <span className="menu-tile__icon">
                <Icon aria-hidden="true" size={30} />
              </span>
              <strong>
                <MenuTileLabel label={label} />
              </strong>
              {isSelected ? (
                <span className="menu-tile__check">
                  <Check aria-hidden="true" size={18} />
                </span>
              ) : null}
            </article>
          );
        })}
      </div>
    </section>
  );
}

function ContextSnapshotStrip({ data, t, locale, variant = "overview" }) {
  const context = selectedContextData(data);
  const targetRepository = context.target_repository || {};
  const generated = context.updated_at ? formatDashboardDateTime(context.updated_at) || formatDateTime(context.updated_at, locale) : formatGenerated(data, locale);
  const metric = data.summary?.category_metrics?.lessons || {};
  const selectedMenu = contextLabel(context.menu_id, t);
  const currentStep = selectedStepText(context);
  const currentStepShort = selectedStepShort(context);
  const currentStepDetail = selectedStepDetail(context);
  const nextSafeAction = context.next_safe_action || data.summary?.primary_action || {};
  const rowsByVariant = {
    overview: [
      { label: t("mock.context.now"), value: currentStep, Icon: Target, tone: "blue" },
      { label: t("mock.context.target"), value: displayText(targetRepository.name), Icon: Folder, tone: "gray" },
      { label: t("mock.context.nextOperation"), value: displayText(nextSafeAction.title, displayText(nextSafeAction.description)), Icon: ArrowRightCircle, tone: "blue" },
      { label: t("app.lastUpdated"), value: generated, Icon: Clock, tone: "purple" },
    ],
    lessons: [
      { label: t("mock.context.selected"), value: selectedMenu, Icon: BookOpen, tone: "blue" },
      { label: t("mock.context.progress"), value: `${metric.healthy ?? 0} / ${metric.total ?? 0}`, Icon: CircleDashed, tone: "blue", progress: clampPercent(metric.percent) },
      { label: t("mock.context.current"), value: currentStepShort, detail: currentStepDetail, Icon: Flag, tone: "blue" },
      { label: t("mock.context.next"), value: displayText(nextSafeAction.title, displayText(nextSafeAction.description)), Icon: ArrowRightCircle, tone: "blue" },
    ],
    workflow: [
      { label: "", value: selectedMenu, Icon: BookOpen, tone: "blue" },
      { label: t("mock.context.externalRepository"), value: displayText(targetRepository.name), Icon: Database, tone: "teal" },
      { label: currentStepShort, value: displayText(context.current_step_id), Icon: Flag, tone: "teal" },
      { label: t("mock.context.nextStep"), value: displayText(nextSafeAction.title, displayText(nextSafeAction.description)), Icon: ArrowRightCircle, tone: "teal" },
    ],
    maintenance: [
      { label: t("mock.context.selectedMenu"), value: selectedMenu, Icon: BookOpen, tone: "purple", chip: true },
      { label: t("mock.context.targetRepository"), value: displayText(targetRepository.name), Icon: Folder, tone: "purple" },
      { label: t("mock.context.activeStep"), value: currentStepShort, Icon: Flag, tone: "purple" },
      { label: t("mock.context.dataSource"), value: t("mock.context.dashboardSnapshot"), Icon: Database, tone: "purple" },
    ],
    safety: [
      { label: t("mock.context.selectedMenu"), value: selectedMenu, Icon: List, tone: "green" },
      { label: t("mock.context.targetRepository"), value: displayText(targetRepository.name), Icon: Folder, tone: "green" },
      { label: t("mock.context.currentStep"), value: currentStepShort, Icon: CheckCircle2, tone: "green" },
      { label: t("mock.context.securityScope"), value: securityScopeLabel(context, t), Icon: ShieldCheck, tone: "green" },
    ],
  };
  const rows = rowsByVariant[variant] || rowsByVariant.overview;
  return (
    <section className={`context-strip context-strip--${variant}`} aria-label={t("context.title")}>
      {rows.map(({ label, value, detail, Icon, tone, progress, chip, invert }, index) => (
        <article className={`context-strip__item context-strip__item--${tone || "default"}${invert ? " context-strip__item--invert" : ""}${chip ? " context-strip__item--chip" : ""}`} key={`${label}-${value}-${index}`}>
          <span className="context-strip__icon">
            {Number.isFinite(progress) ? (
              <span className="mini-progress-ring mini-progress-ring--icon" style={{ "--metric-percent": `${progress}%` }} aria-hidden="true" />
            ) : (
              <Icon aria-hidden="true" size={24} />
            )}
          </span>
          <div>
            {label ? <span>{label}</span> : null}
            <strong>{value}</strong>
            {detail && detail !== value ? <small>{detail}</small> : null}
          </div>
        </article>
      ))}
    </section>
  );
}

function HorizontalProgress({ percent }) {
  const value = clampPercent(percent);
  return (
    <div className="horizontal-progress" aria-label={`${value}%`}>
      <span style={{ width: `${value}%` }} />
    </div>
  );
}

function OverviewStatusCard({ id, title, status, metric, value, detail, t, chipLabel }) {
  const config = overviewStatusConfig[id] || overviewStatusConfig.lessons;
  const Icon = config.Icon;
  const state = normalizeState(metric?.status || status);
  const valueText = value || stateLabel(state, t);
  const chipCompactClass = state === "manual_required" ? "status-chip--compact-label" : "";
  return (
    <article className={`overview-status-card overview-status-card--${config.tone}`} data-overview-status-card={id}>
      <div className="overview-status-card__head">
        <span className="overview-status-card__icon">
          <Icon aria-hidden="true" size={26} />
        </span>
        <div>
          <h3>{title}</h3>
          <strong>{valueText}</strong>
        </div>
      </div>
      {metric ? (
        <div className="overview-status-card__progress-row">
          <HorizontalProgress percent={metric.percent} />
          <strong className="overview-status-card__progress-value">{detail}</strong>
        </div>
      ) : null}
      {detail && !metric ? <p>{detail}</p> : null}
      {chipLabel ? <span className={`status-chip status-chip--${config.tone} ${chipCompactClass}`.trim()}>{chipLabel}</span> : <StatusPill value={state} t={t} />}
    </article>
  );
}

function gitOperationIcon(id) {
  const map = {
    push: ArrowUp,
    pull_request: GitPullRequest,
    pr_ci: CheckCircle2,
    main_ci: RefreshCw,
    sync_check: RefreshCw,
    merge: GitMerge,
  };
  return map[displayText(id)] || GitBranch;
}

function gitOperationModeLabel(mode, t) {
  const normalized = displayText(mode, "auto");
  if (normalized === "gated") {
    return t("mock.git.gated");
  }
  return t("mock.git.auto");
}

function gitOperationDisplayLabel(id, fallback, t) {
  const key = displayText(id, "unknown");
  return t(`mock.git.operation.${key}`, displayText(fallback, displayKey(key)));
}

function GitOperationRail({ operations, t, variant = "workflow" }) {
  const visibleIds = variant === "overview" ? new Set(["push", "pull_request", "pr_ci", "merge"]) : null;
  const rows = asArray(operations).filter((row) => !visibleIds || visibleIds.has(displayText(row.id)));
  if (!rows.length) {
    return null;
  }
  return (
    <section className={`operation-rail operation-rail--${variant}`} aria-label={t("workflow.gitManagement")}>
      <div className="operation-rail__head">
        <Settings aria-hidden="true" size={20} />
        <h3>{variant === "overview" ? t("workflow.gitManagement") : t("workflow.gitManagementApplied")}</h3>
      </div>
      <div className="operation-rail__items">
        {rows.map((row) => {
          const Icon = gitOperationIcon(row.id);
          const mode = displayText(row.mode, "auto");
          return (
          <article className={`operation-chip operation-chip--${mode}`} key={displayText(row.id)}>
            <span className="operation-chip__icon">
              <Icon aria-hidden="true" size={18} />
            </span>
            <strong>{displayText(row.label)}</strong>
            <span className={`mode-pill mode-pill--${mode}`}>{gitOperationModeLabel(row.mode, t)}</span>
          </article>
        );
        })}
      </div>
    </section>
  );
}

function SecurityOverviewPanel({ security, partialFailures, t }) {
  const failures = asArray(partialFailures);
  const securityGate = security?.gate_status;
  return (
    <section className="security-overview-panel" aria-label={t("overview.securityConfirmation")}>
      <div className="security-overview-panel__icon">
        <ShieldCheck aria-hidden="true" size={28} />
      </div>
      <div className="security-overview-panel__main">
        <h3>{t("overview.securityConfirmation")}</h3>
        <div className="security-overview-panel__facts">
          <span>{t("security.item.gate")} <StatusPill value={securityGate} t={t} label={statusLabelForChip(securityGate, t)} /></span>
          <span>{t("summary.partialFailures")} <strong>{failures.length ? failures.length : t("summary.none")}</strong></span>
        </div>
      </div>
      <a className="panel-link" href="#safety">
        {t("summary.viewDetails")}
        <ArrowRightCircle aria-hidden="true" size={16} />
      </a>
    </section>
  );
}

function CommonStatusPanel({ data, partialFailures, t }) {
  const operations = asArray(data.development?.git_operations);
  const operationIds = new Set(["push", "pull_request", "pr_ci", "merge"]);
  const visibleOperations = operations.filter((operation) => operationIds.has(displayText(operation.id, "")));
  const failures = asArray(partialFailures);
  const securityGate = data.security?.gate_status;
  return (
    <section className="common-status-panel" aria-labelledby="common-status-heading">
      <h3 id="common-status-heading">{t("overview.commonStatus")}</h3>
      <div className="common-status-grid">
        <article className="common-status-card common-status-card--git">
          <span className="common-status-card__icon">
            <Settings aria-hidden="true" size={30} />
          </span>
          <div className="common-status-card__main">
            <h4>{t("workflow.gitManagement")}</h4>
            <div className="common-status-ops">
              {visibleOperations.map((operation) => {
                const Icon = gitOperationIcon(operation.id);
                const mode = displayText(operation.mode, "auto");
                return (
                  <div className="common-status-op" key={displayText(operation.id)}>
                  <span className="common-status-op__label">
                    <Icon aria-hidden="true" size={17} />
                      {gitOperationDisplayLabel(operation.id, operation.label, t)}
                  </span>
                    <span className={`common-mode-pill common-mode-pill--${mode}`}>{gitOperationModeLabel(operation.mode, t)}</span>
                  </div>
                );
              })}
            </div>
          </div>
          <div className="common-status-card__side">
            <p>{t("overview.common.gitDetail")}</p>
            <a className="common-status-link" href="#workflow">
              {t("summary.viewDetails")}
              <ArrowRightCircle aria-hidden="true" size={15} />
            </a>
          </div>
        </article>
        <article className="common-status-card common-status-card--security">
          <span className="common-status-card__icon">
            <ShieldCheck aria-hidden="true" size={30} />
          </span>
          <div className="common-status-card__main">
            <h4>{t("overview.securityConfirmation")}</h4>
            <div className="common-security-facts">
              <div>
                <strong>{t("overview.securityGate")}</strong>
                <span className="common-mode-pill common-mode-pill--security">{statusLabelForChip(securityGate, t)}</span>
              </div>
              <div>
                <strong>{t("summary.partialFailures")}</strong>
                <span className="common-mode-pill common-mode-pill--auto">{failures.length ? `${failures.length}` : t("summary.none")}</span>
              </div>
            </div>
          </div>
          <a className="common-status-link common-status-link--security" href="#safety">
            {t("summary.viewDetails")}
            <ArrowRightCircle aria-hidden="true" size={15} />
          </a>
        </article>
      </div>
    </section>
  );
}

function WorkflowStatusCards({ data, t }) {
  const context = selectedContextData(data);
  const productAuthority = data.development?.product_authority || {};
  const cards = [
    { id: "git-sync", title: t("workflow.card.gitSync"), Icon: WorkflowCategoryIcon, value: statusLabelForChip(context.git_status, t), detail: workflowContextLabel(context.workflow_context, t), button: t("summary.viewDetails") },
    { id: "ci", title: t("workflow.card.ci"), Icon: CheckCircle2, value: statusLabelForChip(context.ci_status, t), detail: displayText(context.target_repository?.name), button: t("summary.viewDetails") },
    { id: "pr-merge", title: t("workflow.card.prMerge"), Icon: GitPullRequest, value: statusLabelForChip(data.git_workflow?.approval_status, t), detail: t("workflow.card.prMergeDetail"), button: t("summary.viewDetails") },
    { id: "product-evidence", title: t("workflow.card.productEvidence"), Icon: Folder, value: statusLabelForChip(productAuthority.status, t), detail: t("workflow.card.productEvidenceDetail", `${asArray(productAuthority.evidence_summary?.items).length} ${t("summary.items")}`), button: t("workflow.card.collectEvidence") },
    { id: "next-step", title: t("workflow.card.nextStep"), Icon: Flag, value: displayText(context.current_step_id), detail: displayText(context.next_safe_action?.title || context.next_safe_action?.description), button: t("workflow.card.stepDetail") },
  ];
  return (
    <section className="workflow-card-grid" aria-label={t("workflow.currentEvidence")}>
      {cards.map(({ id, title, Icon, value, detail, button }) => (
        <article className={`workflow-mini-card workflow-mini-card--${id}`} key={id}>
          <span className="workflow-mini-card__icon">
            <Icon aria-hidden="true" size={24} />
          </span>
          <h3>{title}</h3>
          <strong>{value}</strong>
          <p>{detail}</p>
          <a className="mini-card-button" href="#workflow">
            {button}
            <ArrowRightCircle aria-hidden="true" size={15} />
          </a>
        </article>
      ))}
    </section>
  );
}

function WorkflowRecentTable({ rows: recentRows, data, t }) {
  const rows = asArray(recentRows).slice(0, 5);
  if (!rows.length) {
    return null;
  }
  return (
    <section className="mock-table-section mock-table-section--workflow" aria-labelledby="workflow-recent-heading">
      <h3 id="workflow-recent-heading">{t("workflow.recentRuns")}</h3>
      <div className="mock-table">
        <div className="mock-table__head mock-table__head--workflow">
          <span>{t("workflow.table.time")}</span>
          <span>{t("workflow.table.type")}</span>
          <span>{t("workflow.table.target")}</span>
          <span>{t("workflow.table.detail")}</span>
          <span>{t("workflow.table.status")}</span>
          <span>{t("workflow.table.reference")}</span>
        </div>
        {rows.map((row) => (
          <article className="mock-table-row mock-table-row--workflow" key={displayText(row.id)}>
            <span>{formatDashboardDateTime(row.time) || displayText(row.time)}</span>
            <strong>{displayText(row.type)}</strong>
            <span>{displayText(row.target)}</span>
            <p>{displayText(row.detail)}</p>
            <StatusPill value={row.status} t={t} label={statusLabelForChip(row.status, t)} />
            <a className="mock-table-link" href="#workflow">{displayText(row.reference, t("summary.viewDetails"))} <ExternalLink aria-hidden="true" size={13} /></a>
          </article>
        ))}
      </div>
    </section>
  );
}

function EvidenceRowsTable({ rows, t }) {
  const items = asArray(rows);
  if (!items.length) {
    return null;
  }
  return (
    <section className="evidence-table-section" aria-labelledby="evidence-table-heading">
      <h3 id="evidence-table-heading">{t("maintenance.evidenceTable")}</h3>
      <div className="evidence-table">
        <div className="evidence-table__head">
          <span>{t("detail.confirm.what")}</span>
          <span>{t("detail.confirm.why")}</span>
          <span>{t("detail.confirm.status")}</span>
          <span>{t("maintenance.reference")}</span>
        </div>
        {items.map((row) => (
          <article className="evidence-row" key={displayText(row.id)}>
            <div className="evidence-row__title">
              <FileCheck2 aria-hidden="true" size={20} />
              <strong>{displayText(row.label)}</strong>
            </div>
            <p>{maintenanceEvidenceWhy(row.id, t)}</p>
            <StatusPill value={row.status} t={t} label={statusLabelForChip(row.status, t)} />
            <div className="evidence-row__reference">
              {technicalChip(row.reference)}
              <ExternalLink aria-hidden="true" size={14} />
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}

function SecurityStatusCards({ security, partialFailures, data, t }) {
  const failures = asArray(partialFailures);
  const approvals = asArray(security?.approvals);
  const dangerous = asArray(security?.dangerous_operations);
  const lastChecked = formatDashboardTime(approvals[0]?.last_checked || dangerous[0]?.last_checked || data.generated_at);
  const cards = [
    { id: "gate", title: t("security.item.gate"), Icon: ShieldCheck, status: security?.gate_status, value: statusLabelForChip(security?.gate_status, t), detail: securityGateDetail(security, failures, t) },
    { id: "approval", title: t("security.approvals"), Icon: UserCheck, status: approvals[0]?.status || security?.dangerous_action_approval, value: approvals.length ? statusLabelForChip(approvals[0]?.status || security?.dangerous_action_approval, t) : t("security.card.noApprovalWaiting"), detail: displayText(approvals[0]?.detail, stateDetail(security?.dangerous_action_approval, t)) },
    { id: "dangerous", title: t("security.dangerousOperations"), Icon: AlertTriangle, status: dangerous[0]?.status || "ready", value: dangerous.length ? `${dangerous.length}` : t("summary.none"), detail: displayText(dangerous[0]?.detail, t("security.card.dangerousNone")) },
    { id: "partial", title: t("summary.partialFailures"), Icon: CircleMinus, status: failures.length ? failures[0].status : "ready", value: failures.length ? `${failures.length}` : t("summary.none"), detail: securityPartialDetail(failures, t) },
  ];
  return (
    <section className="security-card-grid" aria-label={t("security.title")}>
      {cards.map(({ id, title, Icon, status, value, detail }) => (
        <article className={`security-mini-card security-mini-card--${id}`} key={id}>
          <span className="security-mini-card__icon">
            <Icon aria-hidden="true" size={26} />
          </span>
          <h3>{title}</h3>
          <StatusPill value={status} t={t} label={value} />
          <p>{detail}</p>
          {lastChecked ? <small>{t("security.lastChecked")}: {lastChecked}</small> : null}
        </article>
      ))}
    </section>
  );
}

function ContextPanel({ data, t }) {
  const producerContext = data.selected_context && typeof data.selected_context === "object" ? data.selected_context : {};
  const availableContexts = asArray(data.available_contexts);
  const producerMenuId = displayText(producerContext.menu_id, availableContexts[0]?.menu_id || "unknown");
  const [selectedMenuId, setSelectedMenuId] = useState(producerMenuId);

  useEffect(() => {
    setSelectedMenuId(producerMenuId);
  }, [producerMenuId, data.snapshot_id]);

  if (!availableContexts.length && !displayText(producerContext.menu_id, "")) {
    return null;
  }

  const selectedAvailable =
    availableContexts.find((context) => displayText(context.menu_id, "") === selectedMenuId) ||
    availableContexts.find((context) => displayText(context.menu_id, "") === producerMenuId) ||
    {};
  const usesProducerContext = selectedMenuId === producerMenuId;
  const targetRepository = producerContext.target_repository || {};
  const selectedStatus = usesProducerContext ? producerContext.evidence_status : selectedAvailable.status;
  const blockers = usesProducerContext ? asArray(producerContext.blockers) : [];
  const selectorOptions = availableContexts.length ? availableContexts : [{ menu_id: producerMenuId, workflow_context: producerContext.workflow_context, status: selectedStatus }];

  return (
    <section className="context-panel" aria-label={t("context.title")}>
      <div className="context-panel__control">
        <label htmlFor="dashboard-context-select">
          <Compass aria-hidden="true" size={18} />
          <span>{t("context.selectLabel")}</span>
        </label>
        <select id="dashboard-context-select" value={selectedMenuId} onChange={(event) => setSelectedMenuId(event.target.value)}>
          {selectorOptions.map((context) => {
            const id = displayText(context.menu_id, "unknown");
            return (
              <option value={id} key={id}>
                {contextLabel(id, t)}
              </option>
            );
          })}
        </select>
      </div>
      <div className="context-panel__summary">
        <div className="context-panel__title">
          <span className="context-panel__icon">
            <WorkflowCategoryIcon aria-hidden="true" size={22} />
          </span>
          <div>
            <strong>{contextLabel(selectedMenuId, t)}</strong>
            <span>{workflowContextLabel(usesProducerContext ? producerContext.workflow_context : selectedAvailable.workflow_context, t)}</span>
          </div>
        </div>
        <StatusPill value={selectedStatus} t={t} />
      </div>
      <div className="context-panel__facts">
        <ActionMetaRow Icon={Database} label={t("context.repository")}>
          {usesProducerContext ? displayText(targetRepository.name) : displayText(selectedAvailable.target_repository_name)}
        </ActionMetaRow>
        <ActionMetaRow Icon={MapPinIcon} label={t("context.currentStep")}>
          {usesProducerContext ? displayText(producerContext.current_step_id) : t("context.availableOnly")}
        </ActionMetaRow>
        <ActionMetaRow Icon={ShieldCheck} label={t("context.security")}>
          {usesProducerContext ? stateLabel(producerContext.security_status, t) : t("context.availableOnly")}
        </ActionMetaRow>
        <ActionMetaRow Icon={GitBranch} label={t("context.gitCi")}>
          {usesProducerContext ? `${stateLabel(producerContext.git_status, t)} / ${stateLabel(producerContext.ci_status, t)}` : t("context.availableOnly")}
        </ActionMetaRow>
      </div>
      <div className="context-panel__footer">
        <span>
          <AlertTriangle aria-hidden="true" size={16} />
          {t("context.blockers")}: {blockers.length}
        </span>
        <span>
          <Lock aria-hidden="true" size={16} />
          {t("context.readOnly")}
        </span>
      </div>
    </section>
  );
}

function MapPinIcon(props) {
  return <Target {...props} />;
}

function localizedMeta(t, namespace, id, fallback = "") {
  return t(`${namespace}.${id}`, fallback || displayKey(id));
}

function sourceLabel(source, t) {
  return localizedMeta(t, "source.label", displayText(source), displayKey(source));
}

function sourceDetector(source, t) {
  return localizedMeta(t, "source.detector", displayText(source), displayKey(source));
}

function sourceReasonHint(source, t) {
  return localizedMeta(t, "source.reason", displayText(source), "");
}

function sourceWhy(source, t) {
  return localizedMeta(t, "source.why", displayText(source), "");
}

function commandIntentLabel(intent, t) {
  const key = displayText(intent).replace(/[^a-z0-9]+/gi, "_").replace(/^_+|_+$/g, "").toLowerCase();
  return t(`command.intent.${key}`, displayText(intent));
}

function commandTargetLabel(target, t) {
  const key = displayText(target).replace(/[^a-z0-9]+/gi, "_").replace(/^_+|_+$/g, "").toLowerCase();
  return t(`command.target.${key}`, displayText(target));
}

function commandGateLabel(gateId, t) {
  const key = displayText(gateId, "unknown").replace(/[^a-z0-9]+/gi, "_").replace(/^_+|_+$/g, "").toLowerCase();
  return t(`command.gate.${key}`, displayKey(gateId));
}

function commandExecutionModeLabel(mode, t) {
  const key = displayText(mode, "unknown").replace(/[^a-z0-9]+/gi, "_").replace(/^_+|_+$/g, "").toLowerCase();
  return t(`command.mode.${key}`, displayKey(mode));
}

function stateLabel(state, t) {
  const normalized = normalizeState(state);
  return t(`state.${normalized}`, displayText(normalized));
}

function technicalChip(value) {
  const text = displayText(value, "");
  return text ? <code className="technical-chip">{text}</code> : null;
}

function compactTechnicalChips(values, t, limit = 3) {
  const normalized = asArray(values).map((value) => displayText(value, "")).filter(Boolean);
  if (!normalized.length) {
    return <span>{t("summary.none")}</span>;
  }
  const visible = normalized.slice(0, limit);
  const remaining = normalized.length - visible.length;
  return (
    <div className="source-boundary__chips">
      {visible.map((value) => (
        <code className="technical-chip" key={value}>{value}</code>
      ))}
      {remaining > 0 ? <span className="small-badge small-badge--soft">{remaining} {t("summary.moreItems")}</span> : null}
    </div>
  );
}

function formatGenerated(data, locale) {
  return data?.generated_at ? formatDashboardDateTime(data.generated_at) || formatDateTime(data.generated_at, locale) : "";
}

function formatDashboardDateTime(value) {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    return value || "";
  }
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  const hour = String(date.getHours()).padStart(2, "0");
  const minute = String(date.getMinutes()).padStart(2, "0");
  return `${year}-${month}-${day} ${hour}:${minute}`;
}

function formatDashboardTime(value) {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    return "";
  }
  return `${String(date.getHours()).padStart(2, "0")}:${String(date.getMinutes()).padStart(2, "0")}`;
}

function selectedStepText(context, { includeId = false } = {}) {
  const index = Number.isInteger(context.current_step_index) ? context.current_step_index : null;
  const total = Number.isInteger(context.current_step_total) ? context.current_step_total : null;
  const prefix = index && total ? `Step ${index} / ${total}` : displayText(context.current_step_label || context.current_step_id);
  const label = displayText(context.current_step_label || "", "");
  const detail = label.includes("-") ? label.split("-").slice(1).join("-").trim() : label.replace(prefix, "").trim();
  const id = displayText(context.current_step_id, "");
  if (includeId && id) {
    return detail ? `${prefix} ${id}` : `${prefix} ${id}`;
  }
  return detail ? `${prefix} ${detail}` : prefix;
}

function selectedStepShort(context) {
  const index = Number.isInteger(context.current_step_index) ? context.current_step_index : null;
  const total = Number.isInteger(context.current_step_total) ? context.current_step_total : null;
  return index && total ? `Step ${index} / ${total}` : displayText(context.current_step_label || context.current_step_id);
}

function selectedStepDetail(context) {
  const label = displayText(context.current_step_label || "", "");
  if (label.includes("-")) {
    return label.split("-").slice(1).join("-").trim();
  }
  return displayText(context.current_step_id, "");
}

function nextActionShort(context, data) {
  const action = context.next_safe_action || data.summary?.primary_action || {};
  return displayText(action.title || action.description, "");
}

function statusLabelForChip(value, t) {
  const state = normalizeState(value);
  const mockLabels = {
    ready: "mock.status.ready",
    passed: "mock.status.passed",
    failed: "mock.status.failed",
    blocked: "mock.status.blocked",
    unknown: "mock.status.unknown",
    optional: "mock.status.optional",
    cached: "mock.status.cached",
    not_run: "mock.status.notRun",
    stale: "mock.status.stale",
    approval_required: "mock.status.approvalRequired",
    manual_required: "mock.status.manualRequired",
  };
  return t(mockLabels[state] || `state.${state}`, displayText(state));
}

function stateDetail(value, t) {
  return `${t("field.status", "Status")}: ${statusLabelForChip(value, t)}`;
}

function repositoryPathStateToStatus(value) {
  const state = displayText(value, "unknown");
  if (state === "configured") {
    return "ready";
  }
  if (state === "not_applicable") {
    return "manual_required";
  }
  if (state === "missing") {
    return "missing";
  }
  return "unknown";
}

function selectedLessonObject(data, context) {
  const menuId = displayText(context.menu_id, "");
  if (menuId === "step_1_7") {
    return data.lessons?.step_1_7 || {};
  }
  if (menuId === "advanced") {
    return data.lessons?.advanced || {};
  }
  return data.lessons?.step_1_14 || {};
}

function aggregateLessonSettingsStatus(lesson) {
  const states = ["learning_mode_status", "workflow_language_status", "product_language_status"].map((field) => normalizeState(lesson?.[field]));
  if (states.some((state) => state === "missing" || state === "failed" || state === "blocked")) {
    return states.find((state) => state === "failed" || state === "blocked") || "missing";
  }
  if (states.some((state) => state === "unknown")) {
    return "unknown";
  }
  return states.every((state) => state === "ready" || state === "passed") ? "ready" : "manual_required";
}

function lessonSettingsDetail(lesson, t) {
  return [
    `${t("field.learningMode")}: ${statusLabelForChip(lesson?.learning_mode_status, t)}`,
    `${t("field.workflowLanguage")}: ${statusLabelForChip(lesson?.workflow_language_status, t)}`,
    `${t("field.productLanguage")}: ${statusLabelForChip(lesson?.product_language_status, t)}`,
  ].join(" / ");
}

function dashboardReflectionStatus(data) {
  return displayText(data.snapshot_id, "") && displayText(data.content_hash, "") ? "passed" : "unknown";
}

function dashboardReflectionDetail(data, t) {
  const identity = displayText(data.snapshot_id || data.content_hash, "");
  return identity ? `${t("app.snapshot")}: ${identity}` : stateDetail("unknown", t);
}

function securityGateDetail(security, failures, t) {
  const firstFailure = failures[0];
  if (firstFailure?.reason) {
    return displayText(firstFailure.reason);
  }
  const state = normalizeState(security?.gate_status);
  if (isReviewState(state)) {
    return stateDetail(state, t);
  }
  return t("security.card.gateReady");
}

function securityPartialDetail(failures, t) {
  if (failures.length) {
    return displayText(failures[0].reason);
  }
  return t("security.card.partialNone");
}

function maintenanceEvidenceRow(maintenance, ids) {
  const idSet = new Set(ids);
  return asArray(maintenance?.evidence_rows).find((row) => idSet.has(displayText(row.id, ""))) || null;
}

function maintenanceCardDetail(maintenance, ids, status, t) {
  const row = maintenanceEvidenceRow(maintenance, ids);
  if (row) {
    const why = maintenanceEvidenceWhy(row.id, t);
    const reference = displayText(row.reference, "");
    return reference ? `${why} ${t("maintenance.reference")}: ${reference}` : why;
  }
  return stateDetail(status, t);
}

function MetricRing({ metric }) {
  const percent = clampPercent(metric?.percent);
  return (
    <div className="metric-ring" style={{ "--metric-percent": `${percent}%` }} aria-label={`${percent}%`}>
      <span>{percent}%</span>
    </div>
  );
}

function MetricRows({ metric, t }) {
  const rows = [
    { label: t("summary.total"), value: metric?.total ?? 0 },
    { label: t("summary.healthy"), value: metric?.healthy ?? 0 },
    { label: t("summary.warning"), value: metric?.warning ?? 0 },
    { label: t("summary.problem"), value: metric?.problem ?? 0 },
  ];
  return (
    <dl className="metric-rows">
      {rows.map((row) => (
        <div className="metric-row" key={row.label}>
          <dt>{row.label}</dt>
          <dd>{row.value}</dd>
        </div>
      ))}
    </dl>
  );
}

function ActionMetaRow({ Icon, label, children }) {
  return (
    <div className="action-meta-row">
      <Icon aria-hidden="true" size={17} />
      <div>
        <span>{label}</span>
        <strong>{children}</strong>
      </div>
    </div>
  );
}

function DetailPageHeader({ tone, Icon, title, subtitle, data, locale, t, actionLabel, headingId }) {
  const generated = formatGenerated(data, locale);
  return (
    <div className={`detail-page-header detail-page-header--${tone}`}>
      <div className="detail-page-header__title">
        <span className="detail-page-header__icon">
          <Icon aria-hidden="true" size={34} />
        </span>
        <div>
          <h2 id={headingId}>{title}</h2>
          {subtitle ? <p>{subtitle}</p> : null}
        </div>
      </div>
      <div className="detail-page-header__meta">
        {generated ? (
          <span>
            <Clock aria-hidden="true" size={15} />
            {t("app.lastUpdated")}: {generated}
          </span>
        ) : null}
        <span>
          <Lock aria-hidden="true" size={15} />
          {t("app.snapshot")} / {t("app.readOnly")}
        </span>
        {actionLabel ? (
          <span className="detail-page-header__action">
            <RefreshCw aria-hidden="true" size={15} />
            {actionLabel}
          </span>
        ) : null}
      </div>
    </div>
  );
}

function DetailDecisionSummary({ tone, items, t }) {
  return (
    <section className={`decision-summary decision-summary--${tone}`} aria-label={t("detail.summaryAria")}>
      {items.map(({ Icon, label, value, detail, points = [], badge, cta, tone: itemTone }) => (
        <article className={itemTone ? `decision-summary__item decision-summary__item--${itemTone}` : "decision-summary__item"} key={label}>
          <span className="decision-summary__icon">
            <Icon aria-hidden="true" size={24} />
          </span>
          <div>
            <span>{label}</span>
            <strong>{value}</strong>
            {badge ? <em>{badge}</em> : null}
            {detail ? <p>{detail}</p> : null}
            {points.length ? (
              <ul className="decision-summary__points">
                {points.map((point, index) => (
                  <li key={`${displayText(point)}-${index}`}>{displayText(point)}</li>
                ))}
              </ul>
            ) : null}
            {cta ? (
              <a className="decision-summary__cta" href={cta.href}>
                {cta.label}
                <ArrowRightCircle aria-hidden="true" size={16} />
              </a>
            ) : null}
          </div>
        </article>
      ))}
    </section>
  );
}

function SummaryBullets({ items }) {
  const visibleItems = asArray(items).filter((item) => displayText(item, ""));
  if (!visibleItems.length) {
    return null;
  }
  return (
    <ul className="summary-bullets">
      {visibleItems.map((item, index) => (
        <li key={`${displayText(item)}-${index}`}>{displayText(item)}</li>
      ))}
    </ul>
  );
}

function DetailSection({ id, title, Icon, children, className = "" }) {
  const headingId = `${id}-heading`;
  return (
    <section className={`detail-section ${className}`} id={id} aria-labelledby={headingId}>
      <div className="detail-section__head">
        <Icon aria-hidden="true" size={20} />
        <h3 id={headingId}>{title}</h3>
      </div>
      {children}
    </section>
  );
}

function DetailStatusCard({ id, title, technicalKey, value, t, Icon = CircleDashed, tone = "default", note, footer, visualState }) {
  const statusValue = value && typeof value === "object" ? value.status : value;
  const state = normalizeState(visualState || statusValue);
  const details = value && typeof value === "object" ? value : { status: value };
  const detailFields = objectEntries(details)
    .filter(([key]) => key !== "status")
    .map(([key, fieldValue]) => ({ label: displayKey(key), value: fieldValue }));
  return (
    <article className={`item-card detail-card detail-card--${tone} detail-card--${state}`} data-detail-card={id}>
      <div className="detail-card__head">
        <span className="detail-card__icon">
          <Icon aria-hidden="true" size={22} />
        </span>
        <div>
          <h3>{title}</h3>
          {technicalKey ? <span className="detail-card__technical">{technicalKey}</span> : null}
        </div>
        <StatusPill value={statusValue} t={t} />
      </div>
      {note ? <p className="detail-card__note">{note}</p> : null}
      <FieldGrid fields={detailFields} />
      {footer ? <div className="detail-card__footer">{footer}</div> : null}
    </article>
  );
}

function DetailTableRow({ item, t, tone = "workflow", showChevron = true }) {
  const Icon = item.Icon || CircleDashed;
  return (
    <article className={`detail-row detail-row--${tone} detail-row--${normalizeState(item.state)}`} data-detail-row={item.id}>
      <div className="detail-row__identity">
        <span className="detail-row__icon">
          <Icon aria-hidden="true" size={22} />
        </span>
        <div>
          <h3>{item.title}</h3>
          {item.technicalKey ? <span>{item.technicalKey}</span> : null}
        </div>
      </div>
      <p className="detail-row__note">{item.note}</p>
      <div className="detail-row__status">
        <StatusPill value={item.state} t={t} />
        {item.summary ? <span>{item.summary}</span> : null}
      </div>
      <div className="detail-row__meta">
        {item.updated ? <span>{item.updated}</span> : null}
        {showChevron ? <ChevronRight aria-hidden="true" size={18} /> : null}
      </div>
    </article>
  );
}

function EmptyDetailRow({ title, detail, t, tone = "workflow" }) {
  return (
    <article className={`detail-row detail-row--${tone} detail-row--empty`}>
      <div className="detail-row__identity">
        <span className="detail-row__icon">
          <CheckCircle2 aria-hidden="true" size={22} />
        </span>
        <div>
          <h3>{title}</h3>
        </div>
      </div>
      <p className="detail-row__note">{detail}</p>
      <div className="detail-row__status">
        <StatusPill value="ready" t={t} />
      </div>
      <div className="detail-row__meta" />
    </article>
  );
}

function PrimaryActionCard({ action, t }) {
  if (!action || typeof action !== "object") {
    return null;
  }
  return (
    <article className="next-action-panel">
      <div className="next-action-panel__head">
        <CheckCircle2 aria-hidden="true" size={24} />
        <div>
          <span className="eyebrow">{t("summary.nextSafeAction")}</span>
          <p>{displayText(action.description)}</p>
        </div>
      </div>
      <div className="primary-action-card">
        <div className="primary-action-card__head">
          <FileCheck2 aria-hidden="true" size={24} />
          <div>
            <h3>{displayText(action.title)}</h3>
          </div>
          <StatusPill value={action.status} t={t} />
        </div>
      </div>
      <div className="action-meta">
        <ActionMetaRow Icon={User} label={t("field.target")}>
          {displayText(action.target)}
        </ActionMetaRow>
        <ActionMetaRow Icon={Target} label={t("field.expectedResult")}>
          {displayText(action.expected_result)}
        </ActionMetaRow>
        <ActionMetaRow Icon={ShieldCheck} label={t("field.risk")}>
          <RiskPill value={action.risk_level} t={t} />
        </ActionMetaRow>
      </div>
    </article>
  );
}

function IssueSummaryCard({ title, items, t, Icon, href, always = false }) {
  if (!items.length && !always) {
    return null;
  }
  const previewItem = items[0];
  return (
    <article className={items.length ? "issue-summary" : "issue-summary issue-summary--empty"}>
      <div className="issue-preview__head">
        <div>
          <Icon aria-hidden="true" size={20} />
          <h3>{title}</h3>
        </div>
        <span>{items.length}</span>
      </div>
      {previewItem ? (
        <div className="issue-preview__list">
          <article className="issue issue--compact">
            <div className="issue__title">
              <span>{sourceLabel(previewItem.source, t)}</span>
              <StatusPill value={previewItem.status} t={t} />
            </div>
            <p>{displayText(previewItem.reason)}</p>
          </article>
        </div>
      ) : (
        <p className="issue-summary__empty">{t("summary.none")}</p>
      )}
      {items.length > 1 ? <p className="issue-summary__more">{items.length - 1} {t("summary.moreItems")}</p> : null}
      {href ? (
        <a className="card-link" href={href}>
          {t("summary.viewDetails")}
        </a>
      ) : null}
    </article>
  );
}

function FieldGrid({ fields }) {
  const visibleFields = fields.filter((field) => field.value !== undefined && field.value !== null && field.value !== "");
  if (visibleFields.length === 0) {
    return null;
  }
  return (
    <dl className="field-grid">
      {visibleFields.map((field) => (
        <div className="field" key={field.label}>
          <dt>{field.label}</dt>
          <dd>{field.render ? field.render(field.value) : displayText(field.value)}</dd>
        </div>
      ))}
    </dl>
  );
}

function CompactList({ title, items }) {
  if (!items.length) {
    return null;
  }
  return (
    <div className="compact-list">
      <h4>{title}</h4>
      <ul>
        {items.map((item, index) => (
          <li key={index}>{displayText(item)}</li>
        ))}
      </ul>
    </div>
  );
}

function IssueList({ title, items, t, Icon = AlertTriangle }) {
  if (!items.length) {
    return null;
  }
  return (
    <div className="issue-list">
      <div className="issue-list__head">
        <Icon aria-hidden="true" size={20} />
        <h3>{title}</h3>
      </div>
      {items.map((item, index) => (
        <article className={`issue issue--${normalizeState(item.status)}`} key={`${displayText(item.source)}-${index}`}>
          <div className="issue__title">
            <Icon aria-hidden="true" size={17} />
            <span>{sourceLabel(item.source, t)}</span>
            <StatusPill value={item.status} t={t} />
          </div>
          <p>{displayText(item.reason)}</p>
          {item.required_command ? <code className="reference-code">{displayText(item.required_command)}</code> : null}
        </article>
      ))}
    </div>
  );
}

function GuidanceList({ items, t }) {
  if (!items.length) {
    return null;
  }
  return (
    <div className="guidance-list" aria-label={t("aria.guidance")}>
      {items.map((item, index) => (
        <article className={`guidance guidance--${displayText(item.priority, "info")}`} key={`${item.surface}-${item.audience}-${index}`}>
          <div className="guidance__meta">
            <span>{displayText(item.surface)}</span>
            <span>{displayText(item.audience)}</span>
            <span>{displayText(item.priority)}</span>
          </div>
          <p>{displayText(item.message)}</p>
        </article>
      ))}
    </div>
  );
}

function StatusStrip({ data, t, locale }) {
  const blockers = asArray(data.summary?.blocking_items).length;
  const generated = data.generated_at ? formatDateTime(data.generated_at, locale) : "";
  const age = data.generated_at ? formatRelativeAge(data.generated_at, locale) : "";
  const items = [
    { label: t("summary.mode"), value: displayText(data.summary?.mode), Icon: Brain },
    { label: t("summary.generated"), value: generated, detail: age, Icon: CalendarDays },
    { label: t("summary.state"), value: t("app.readOnly"), detail: t("app.snapshot"), Icon: Lock },
    { label: t("summary.blockers"), value: blockers ? String(blockers) : t("summary.noBlockers"), Icon: AlertTriangle },
  ];
  return (
    <div className="status-strip" aria-label={t("aria.snapshotStatus")}>
      {items.map(({ label, value, detail, Icon }) => (
        <div className="status-strip__item" key={label}>
          <Icon aria-hidden="true" size={20} />
          <div>
            <span>{label}</span>
            <strong>{value}</strong>
            {detail ? <small>{detail}</small> : null}
          </div>
        </div>
      ))}
    </div>
  );
}

function HealthCard({ id, title, status, detail, href, t, Icon, metric }) {
  const state = normalizeState(metric?.status || status);
  return (
    <article className={`health-card health-card--${state} health-card--${id}`} data-health-card={title}>
      <div className="health-card__head">
        <Icon aria-hidden="true" size={20} />
        <h3>{title}</h3>
        <StatusPill value={metric?.status || status} t={t} />
      </div>
      <div className="health-card__body">
        <MetricRing metric={metric} />
        <div>
          <p>{detail}</p>
          <MetricRows metric={metric} t={t} />
        </div>
      </div>
      <a className="card-link" href={href}>
        {t("summary.openCategory")}
      </a>
    </article>
  );
}

function buildCategorySummaries({ summary, t }) {
  const metrics = summary.category_metrics;
  return [
    {
      id: "overview",
      title: t("nav.overview"),
      status: metrics.overview.status,
      detail: t("summary.overviewDetail"),
      meta: t("summary.currentPage"),
      metric: metrics.overview,
      Icon: Home,
    },
    {
      id: "lessons",
      title: t("nav.lessons"),
      status: metrics.lessons.status,
      detail: `${metrics.lessons.total} ${t("summary.lessonsCount")}`,
      meta: `${metrics.lessons.total} ${t("summary.items")}`,
      metric: metrics.lessons,
      Icon: BookOpen,
    },
    {
      id: "workflow",
      title: t("nav.workflow"),
      status: metrics.workflow.status,
      detail: `${metrics.workflow.total} ${t("summary.workflowFields")}`,
      meta: `${metrics.workflow.total} ${t("summary.steps")}`,
      metric: metrics.workflow,
      Icon: WorkflowCategoryIcon,
    },
    {
      id: "maintenance",
      title: t("nav.maintenance"),
      status: metrics.maintenance.status,
      detail: `${metrics.maintenance.total} ${t("summary.maintenanceFields")}`,
      meta: `${metrics.maintenance.total} ${t("summary.items")}`,
      metric: metrics.maintenance,
      Icon: Wrench,
    },
    {
      id: "safety",
      title: t("nav.safety"),
      status: metrics.security.status,
      detail: `${metrics.security.total} ${t("summary.securityFields")}`,
      meta: `${metrics.security.total} ${t("summary.checks")}`,
      metric: metrics.security,
      Icon: ShieldCheck,
    },
  ];
}

function ExplorePages({ categories, t }) {
  return (
    <section className="explore-pages" aria-labelledby="explore-pages-heading">
      <h3 id="explore-pages-heading">{t("summary.explorePages")} <span>{t("summary.explorePagesSuffix")}</span></h3>
      <div className="explore-grid">
        {categories.map(({ id, title, Icon }) => (
          <a className={id === "overview" ? `explore-card explore-card--${id} is-current` : `explore-card explore-card--${id}`} href={`#${id}`} key={id}>
            <div className="explore-card__head">
              <span className="explore-card__icon">
                <Icon aria-hidden="true" size={28} />
              </span>
              <span className="explore-card__title">{title}</span>
            </div>
            <p>{t(`summary.explore.${id}`)}</p>
            <span className="explore-card__open">{t("summary.openCategory")} <ArrowRightCircle aria-hidden="true" size={15} /></span>
          </a>
        ))}
      </div>
    </section>
  );
}

function RepositoryNotice({ t }) {
  return (
    <div className="repository-notice">
      <Info aria-hidden="true" size={16} />
      <span>{t("summary.repositoryNotice")}</span>
    </div>
  );
}

function OverviewSection({ data, t, locale }) {
  const summary = data.summary || {};
  const partialFailures = asArray(data.partial_failures);
  const categorySummaries = buildCategorySummaries({
    summary,
    t,
  });
  const exploreSummaries = categorySummaries.filter((category) => category.id !== "overview");
  const metrics = summary.category_metrics || {};
  const context = selectedContextData(data);
  const currentStep =
    Number.isInteger(context.current_step_index) && Number.isInteger(context.current_step_total) && context.current_step_total > 0
      ? `${context.current_step_index} / ${context.current_step_total}`
      : displayText(context.current_step_label || context.current_step_id);
  const lessonMetric = metrics.lessons || {};

  return (
    <section className="view-surface" id="overview" aria-labelledby="overview-heading">
      <PageTitleHeader viewId="overview" Icon={Home} title={t("nav.overview")} subtitle={t("overview.subtitle")} data={data} locale={locale} t={t} actionLabel={t("detail.refreshDisplayOnly")} headingId="overview-heading" />
      <MenuTileStrip data={data} t={t} />
      <ContextSnapshotStrip data={data} t={t} locale={locale} />
      <section className="overview-status-grid" aria-label={t("overview.currentStatus")}>
        <OverviewStatusCard
          id="lessons"
          title={t("overview.status.lessonProgress")}
          status={lessonMetric.status}
          metric={lessonMetric}
          value={`${lessonMetric.healthy ?? 0} / ${lessonMetric.total ?? 0}`}
          detail={`${clampPercent(lessonMetric.percent)}%`}
          chipLabel={selectedStepShort(context)}
          t={t}
        />
        <OverviewStatusCard id="git" title={t("overview.status.git")} status={context.git_status} value={statusLabelForChip(context.git_status, t)} detail={workflowContextLabel(context.workflow_context, t)} chipLabel={statusLabelForChip(context.git_status, t)} t={t} />
        <OverviewStatusCard id="ci" title={t("overview.status.ci")} status={context.ci_status} value={statusLabelForChip(context.ci_status, t)} detail={displayText(context.target_repository?.name)} chipLabel={statusLabelForChip(context.ci_status, t)} t={t} />
        <OverviewStatusCard id="security" title={t("overview.status.security")} status={context.security_status} value={statusLabelForChip(context.security_status, t)} detail={`${t("summary.blockers")}: ${asArray(context.blockers).length}`} chipLabel={statusLabelForChip(context.security_status, t)} t={t} />
      </section>
      <CommonStatusPanel data={data} partialFailures={partialFailures} t={t} />
      <ExplorePages categories={exploreSummaries} t={t} />
      <RepositoryNotice t={t} />
    </section>
  );
}

function lessonAttentionCount(lesson) {
  const statusFields = [
    lesson.status,
    lesson.learning_mode_status,
    lesson.workflow_language_status,
    lesson.product_language_status,
    lesson.learner_approval_status,
  ];
  const statusCount = statusFields.filter((value) => value !== undefined && value !== null && value !== "" && isReviewState(value)).length;
  const warningsKey = pickFirst(lesson, ["warnings", "lesson_warnings"]);
  return statusCount + (warningsKey ? asArray(lesson[warningsKey]).length : 0);
}

function firstLessonNextAction(lessonEntries) {
  for (const [, lesson] of lessonEntries) {
    const nextKey = pickFirst(lesson, ["next_learning_action", "next_safe_action", "next_action"]);
    if (nextKey && displayText(lesson[nextKey], "")) {
      return displayText(lesson[nextKey]);
    }
  }
  return "";
}

function workflowItemMeta(id, t) {
  const map = {
    "development.product_repository": { title: t("workflow.item.productRepository"), Icon: Database, note: t("workflow.note.productRepository") },
    "development.product_authority": { title: t("workflow.item.productAuthority"), Icon: FileSearch, note: t("workflow.note.productAuthority") },
    "development.documents": { title: t("workflow.item.documents"), Icon: FileText, note: t("workflow.note.documents") },
    "development.git_sync_status": { title: t("workflow.item.gitSync"), Icon: RefreshCw, note: t("workflow.note.gitSync") },
    "development.ci_status": { title: t("workflow.item.ci"), Icon: CheckCircle2, note: t("workflow.note.ci") },
    "git_workflow.policy_status": { title: t("workflow.item.policy"), Icon: ShieldCheck, note: t("workflow.note.policy") },
    "git_workflow.settings_status": { title: t("workflow.item.settings"), Icon: Settings, note: t("workflow.note.settings") },
    "git_workflow.gate_status": { title: t("workflow.item.gate"), Icon: Lock, note: t("workflow.note.gate") },
    "git_workflow.approval_status": { title: t("workflow.item.approval"), Icon: ShieldAlert, note: t("workflow.note.approval") },
  };
  return map[id] || { title: displayKey(id), Icon: WorkflowCategoryIcon, note: t("workflow.note.default") };
}

function collectWorkflowItems({ development, gitWorkflow, t }) {
  return [
    ...objectEntries(development)
      .filter(([id]) => !["git_operations", "recent_runs"].includes(id))
      .map(([id, value]) => [`development.${id}`, value]),
    ...objectEntries(gitWorkflow).map(([id, value]) => [`git_workflow.${id}`, value]),
  ]
    .map(([id, value]) => {
      const meta = workflowItemMeta(id, t);
      return {
        id,
        value,
        state: valueState(value),
        technicalKey: presentationKeyFromId(id),
        summary: workflowItemSummary(id, value, t),
        ...meta,
      };
    })
    .sort(compareByStatePriority);
}

function workflowItemSummary(id, value, t) {
  if (id === "development.product_authority" && value && typeof value === "object") {
    const blockers = asArray(value.product_operation_blockers).length;
    if (blockers) {
      return `${blockers} ${t("workflow.summary.productBlockers")}`;
    }
    return stateLabel(valueState(value), t);
  }
  if (value && typeof value === "object" && value.configured_name) {
    return displayText(value.configured_name);
  }
  if (id === "development.documents") {
    return t("detail.workflow.requiredDocsReady");
  }
  return stateLabel(valueState(value), t);
}

function maintenanceItemMeta(id, t) {
  const map = {
    as_built_sync_status: { title: t("maintenance.item.asBuilt"), note: t("maintenance.note.asBuilt"), Icon: RefreshCw },
    workflow_pair_status: { title: t("maintenance.item.workflowPair"), note: t("maintenance.note.workflowPair"), Icon: Waypoints },
    developer_memory_status: { title: t("maintenance.item.developerMemory"), note: t("maintenance.note.developerMemory"), Icon: Brain },
    skills_status: { title: t("maintenance.item.skills"), note: t("maintenance.note.skills"), Icon: BookMarked },
  };
  return map[id] || { title: displayKey(id), note: t("maintenance.note.default"), Icon: RefreshCw };
}

function safetyItemMeta(id, t) {
  const map = {
    policy_status: { title: t("security.item.policy"), note: t("security.note.policy"), Icon: ShieldCheck },
    gate_status: { title: t("security.item.gate"), note: t("security.note.gate"), Icon: Flag },
    dangerous_action_approval: { title: t("security.item.approval"), note: t("security.note.approval"), Icon: UserCheck },
  };
  return map[id] || { title: displayKey(id), note: t("security.note.default"), Icon: ShieldCheck };
}

function statusToneFromReview(count, fallback) {
  return count > 0 ? "approval_required" : normalizeState(fallback);
}

function lessonPrimaryAttentionText(lesson, t) {
  if (isReviewState(lesson.learning_mode_status)) {
    return t("detail.lesson.learningModeMissing");
  }
  if (isReviewState(lesson.workflow_language_status)) {
    return t("detail.lesson.workflowLanguageMissing");
  }
  if (isReviewState(lesson.product_language_status)) {
    return t("detail.lesson.productLanguageMissing");
  }
  if (isReviewState(lesson.status)) {
    return t("detail.lesson.stateMissing");
  }
  return t("detail.lesson.warningCallout");
}

function lessonReviewPoints(lessonEntries, t) {
  const points = [];
  for (const [id, lesson] of lessonEntries) {
    const title = displayText(lesson?.label, displayKey(id));
    const missing = [
      lesson?.learning_mode_status,
      lesson?.workflow_language_status,
      lesson?.product_language_status,
      lesson?.status,
    ].filter((value) => value !== undefined && value !== null && value !== "" && isReviewState(value)).length;
    const warningsKey = pickFirst(lesson || {}, ["warnings", "lesson_warnings"]);
    const warningCount = warningsKey ? asArray(lesson[warningsKey]).length : 0;
    if (missing) {
      points.push(`${title}: ${t("detail.lesson.missingSettings")}`);
    }
    if (warningCount) {
      points.push(`${title}: ${warningCount} ${t("detail.lesson.warningsUnit")}`);
    }
  }
  return points.length ? points.slice(0, 4) : [t("summary.none")];
}

function itemTitles(items, fallback, limit = 4) {
  const titles = items.map((item) => displayText(item.title, "")).filter(Boolean);
  return titles.length ? titles.slice(0, limit) : [fallback];
}

function sourceStatusSummary(value, t) {
  const details = value && typeof value === "object" ? value : { status: value };
  const nonStatus = objectEntries(details).filter(([key, fieldValue]) => key !== "status" && displayText(fieldValue, ""));
  if (nonStatus.length) {
    return nonStatus
      .slice(0, 2)
      .map(([key, fieldValue]) => `${displayKey(key)}: ${displayText(fieldValue)}`)
      .join(" / ");
  }
  return stateLabel(valueState(value), t);
}

function statusSummaryBadge(count, label, t) {
  return count ? `${label}: ${count}` : t("summary.none");
}

function countWithUnit(count, unitKey, t) {
  return `${count} ${t(unitKey)}`;
}

function CommandChip({ command }) {
  const text = displayText(command, "");
  if (!text) {
    return null;
  }
  return (
    <code className="command-chip">
      <span>{text}</span>
      <Copy aria-hidden="true" size={15} />
    </code>
  );
}

function ReadOnlyBanner({ t, tone = "default" }) {
  return (
    <div className={`read-only-banner read-only-banner--${tone}`}>
      <Info aria-hidden="true" size={18} />
      <span>{t("detail.readOnlyBanner")}</span>
    </div>
  );
}

function MockNotice({ tone = "info", Icon = Info, title, detail, cta }) {
  return (
    <div className={`mock-notice mock-notice--${tone}`}>
      <Icon aria-hidden="true" size={20} />
      <div>
        <strong>{title}</strong>
        {detail ? <span>{detail}</span> : null}
      </div>
      {cta ? (
        <a className="mock-notice__button" href={cta.href || "#overview"}>
          {cta.label}
          <ArrowRightCircle aria-hidden="true" size={15} />
        </a>
      ) : null}
    </div>
  );
}

function LessonRow({ Icon, label, children, state }) {
  return (
    <div className="lesson-row">
      <span className="lesson-row__icon">
        <Icon aria-hidden="true" size={20} />
      </span>
      <span className="lesson-row__label">{label}</span>
      <div className="lesson-row__value">
        {state ? <StatusPill value={state} t={(key, fallback) => fallback || key} label={children} /> : children}
      </div>
    </div>
  );
}

function LessonCard({ id, lesson, t }) {
  const pointsKey = pickFirst(lesson, ["points", "lesson_points", "concise_points"]);
  const warningsKey = pickFirst(lesson, ["warnings", "lesson_warnings"]);
  const nextKey = pickFirst(lesson, ["next_learning_action", "next_safe_action", "next_action"]);
  const attentionCount = lessonAttentionCount(lesson);
  const points = pointsKey ? asArray(lesson[pointsKey]) : [];
  const warnings = warningsKey ? asArray(lesson[warningsKey]) : [];
  const visualState = statusToneFromReview(attentionCount, lesson.status);
  const statusLabel = attentionCount ? t("detail.lesson.needsAttention") : stateLabel(lesson.status, t);
  const progressLabel = normalizeState(lesson.status) === "passed" ? t("detail.lesson.completed") : t("detail.lesson.inProgress");
  const sourceFile = displayText(lesson.source_state_file, "");
  const nextActionDisplay = attentionCount ? t("detail.lesson.reviewSettings") : displayText(lesson[nextKey]);
  return (
    <article className={`lesson-panel lesson-panel--${normalizeState(visualState)}`} data-lesson-card={id}>
      <div className="lesson-panel__band">
        <span>
          {attentionCount ? <AlertTriangle aria-hidden="true" size={18} /> : <CheckCircle2 aria-hidden="true" size={18} />}
          {statusLabel}
        </span>
        {attentionCount ? (
          <small>
            <CircleDashed aria-hidden="true" size={13} />
            {t("detail.lesson.someUnset")}
          </small>
        ) : null}
      </div>
      <div className="lesson-panel__hero">
        <span className="lesson-panel__icon">
          <BookOpen aria-hidden="true" size={26} />
        </span>
        <div>
          <h3>{displayText(lesson.label, displayKey(id))}</h3>
        </div>
            <StatusPill value={visualState} t={t} label={progressLabel} />
      </div>
      {warnings.length || attentionCount ? (
        <div className="lesson-callout">
          <AlertTriangle aria-hidden="true" size={17} />
          <div>
            <strong>{lessonPrimaryAttentionText(lesson, t)}</strong>
            <span>{t("detail.lesson.reviewSettings")}</span>
          </div>
          <ChevronRight aria-hidden="true" size={17} />
        </div>
      ) : null}
      <div className="lesson-rows">
        <LessonRow Icon={Compass} label={t("field.current")}>{displayText(lesson.current_step)}</LessonRow>
        <LessonRow Icon={GraduationCap} label={t("field.learningMode")}>{stateLabel(lesson.learning_mode_status, t)}</LessonRow>
        <LessonRow Icon={Globe2} label={t("field.workflowLanguage")}>{stateLabel(lesson.workflow_language_status, t)}</LessonRow>
        <LessonRow Icon={Code2} label={t("field.productLanguage")}>{stateLabel(lesson.product_language_status, t)}</LessonRow>
        {sourceFile ? <LessonRow Icon={File} label={t("field.source")}>{technicalChip(sourceFile)}</LessonRow> : null}
        <LessonRow Icon={CheckCircle2} label={t("list.points")}>{points.length ? countWithUnit(points.length, "detail.lesson.pointsUnit", t) : t("summary.none")}</LessonRow>
        <LessonRow Icon={AlertTriangle} label={t("list.warnings")}>{warnings.length ? countWithUnit(warnings.length, "detail.lesson.warningsUnit", t) : t("detail.lesson.noWarnings")}</LessonRow>
        {nextKey ? <LessonRow Icon={Target} label={t("detail.lesson.nextAction")}>{nextActionDisplay}</LessonRow> : null}
      </div>
    </article>
  );
}

function lessonProgressPercent(lesson, metric, selected) {
  if (selected && Number.isFinite(Number(metric?.percent))) {
    return clampPercent(metric.percent);
  }
  const state = normalizeState(lesson?.status);
  if (state === "passed") {
    return 100;
  }
  if (state === "ready") {
    return 0;
  }
  return 0;
}

function resolveLessonCards(lessons, data, t) {
  const entries = objectEntries(lessons);
  const foundation = entries.find(([id]) => id.includes("foundation") || id.includes("step_1_7")) || entries[0] || ["step_1_7", {}];
  const practical = entries.find(([id]) => id.includes("extended") || id.includes("14") || id.includes("practical")) || entries[1] || ["step_1_14", {}];
  const selected = displayText(selectedContextData(data).menu_id, "step_1_14");
  const metric = data.summary?.category_metrics?.lessons || {};
  return [
    { id: "step_1_7", sourceId: foundation[0], lesson: foundation[1] || {}, title: t("lesson.card.step7"), tone: "warning", selected: selected === "step_1_7" },
    { id: "step_1_14", sourceId: practical[0], lesson: practical[1] || {}, title: t("lesson.card.step14"), tone: "active", selected: selected === "step_1_14" },
  ].map((card) => ({
    ...card,
    percent: lessonProgressPercent(card.lesson, metric, card.selected),
    attentionCount: lessonAttentionCount(card.lesson),
  }));
}

function LessonProgressCard({ card, data, t }) {
  const context = selectedContextData(data);
  const cardContext = contextDataForMenu(data, card.id) || {};
  const metric = data.summary?.category_metrics?.lessons || {};
  const total = card.selected ? metric.total ?? 0 : Number.isInteger(cardContext.current_step_total) ? cardContext.current_step_total : metric.total ?? 0;
  const completed = card.selected ? metric.healthy ?? 0 : normalizeState(card.lesson.status) === "passed" ? total : Number.isInteger(cardContext.current_step_index) ? cardContext.current_step_index : 0;
  const current = card.selected ? selectedStepText(context) : displayText(card.lesson.current_step, "");
  const nextAction = card.selected ? nextActionShort(context, data) : displayText(card.lesson.next_learning_action || card.lesson.next_action, t("detail.lesson.reviewSettings"));
  return (
    <article className={`lesson-progress-card lesson-progress-card--${card.tone}`} data-lesson-card={card.id}>
      <div className="lesson-progress-card__head">
        <span className="lesson-progress-card__icon">
          <BookOpen aria-hidden="true" size={28} />
        </span>
        <div>
          <h3>{card.title}</h3>
        </div>
        <span className={`lesson-progress-card__badge lesson-progress-card__badge--${card.selected ? "selected" : "unselected"}`}>
          {card.selected ? t("lesson.card.selected") : t("lesson.card.unselected")}
        </span>
      </div>
      {card.attentionCount ? (
        <div className="lesson-progress-card__warning">
          <AlertTriangle aria-hidden="true" size={18} />
          <div>
            <strong>{t("lesson.card.warningTitle")}</strong>
            <span>{t("lesson.card.warningDetail")}</span>
          </div>
          <ChevronRight aria-hidden="true" size={16} />
        </div>
      ) : null}
      <div className="lesson-progress-card__progress">
        <span>{t("mock.context.progress")}: {completed} / {total}</span>
        <strong>{card.percent}%</strong>
        <HorizontalProgress percent={card.percent} />
      </div>
      <p><strong>{t("mock.context.current")}</strong> {current}</p>
      <p><strong>{t("lesson.nextLearningAction")}</strong> {nextAction}</p>
    </article>
  );
}

function LessonLiveStatusTable({ data, t }) {
  const context = selectedContextData(data);
  const metric = data.summary?.category_metrics?.lessons || {};
  const lesson = selectedLessonObject(data, context);
  const generated = data.generated_at ? formatDashboardDateTime(data.generated_at) : t("app.snapshot");
  const settingsStatus = aggregateLessonSettingsStatus(lesson);
  const repositoryStatus = repositoryPathStateToStatus(context.target_repository?.path_state);
  const reflectionStatus = dashboardReflectionStatus(data);
  const rows = [
    { id: "lesson-progress", Icon: FileCheck2, item: t("lesson.live.progress"), status: `${statusLabelForChip(metric.status, t)} (${t("lesson.live.live")})`, detail: `${contextLabel(context.menu_id, t)} / ${selectedStepShort(context)}` },
    { id: "settings", Icon: Settings, item: t("lesson.live.settings"), status: statusLabelForChip(settingsStatus, t), detail: lessonSettingsDetail(lesson, t) },
    { id: "repository", Icon: Database, item: t("lesson.live.repository"), status: statusLabelForChip(repositoryStatus, t), detail: `${displayText(context.target_repository?.name)} (${t("mock.context.externalRepository")})` },
    { id: "git-ci", Icon: RefreshCw, item: t("lesson.live.gitCi"), status: `${statusLabelForChip(context.git_status, t)} / ${statusLabelForChip(context.ci_status, t)}`, detail: t("lesson.live.gitCiDetail") },
    { id: "dashboard", Icon: FileJson, item: t("lesson.live.dashboard"), status: statusLabelForChip(reflectionStatus, t), detail: dashboardReflectionDetail(data, t) },
  ];
  return (
    <section className="lesson-live-table-section" aria-labelledby="lesson-live-heading">
      <h3 id="lesson-live-heading">
        <Activity aria-hidden="true" size={20} />
        {t("lesson.live.title")}
      </h3>
      <div className="lesson-live-table">
        <div className="lesson-live-table__head">
          <span>{t("lesson.live.item")}</span>
          <span>{t("lesson.live.status")}</span>
          <span>{t("lesson.live.detail")}</span>
          <span>{t("lesson.live.updated")}</span>
        </div>
        {rows.map(({ id, Icon, item, status, detail }) => (
          <article className="lesson-live-row" key={id}>
            <span className="lesson-live-row__item"><Icon aria-hidden="true" size={19} />{item}</span>
            <span>{status}</span>
            <span>{detail}</span>
            <span>{generated}</span>
          </article>
        ))}
      </div>
    </section>
  );
}

function LessonSection({ lessons, data, locale, t }) {
  const lessonEntries = objectEntries(lessons);
  const metric = data.summary?.category_metrics?.lessons;
  const attentionCount = lessonEntries.reduce((sum, [, lesson]) => sum + lessonAttentionCount(lesson || {}), 0);
  const nextAction = attentionCount ? t("detail.lessons.nextSafe") : firstLessonNextAction(lessonEntries) || t("detail.lessons.nextSafe");
  const reviewPoints = lessonReviewPoints(lessonEntries, t);
  const lessonCards = resolveLessonCards(lessons, data, t);
  return (
    <section className="view-surface view-surface--lessons" id="lessons" aria-labelledby="lesson-heading">
      <PageTitleHeader viewId="lessons" Icon={BookOpen} title={t("lessons.title")} subtitle={t("lessons.description")} data={data} locale={locale} t={t} actionLabel={t("lesson.snapshotButton")} headingId="lesson-heading" />
      <ContextSnapshotStrip data={data} t={t} locale={locale} variant="lessons" />
      <DetailDecisionSummary
        tone="lessons"
        t={t}
        items={[
          { Icon: Target, label: t("detail.checks"), value: t("detail.lessons.checks"), detail: t("detail.lessons.checksDetail") },
          { Icon: CheckCircle2, label: t("detail.currentJudgment"), value: attentionCount ? t("detail.judgment.needsReview") : t("detail.judgment.ready"), detail: attentionCount ? t("detail.lessons.notReadyDetail") : t("detail.noRequiredReview"), badge: statusSummaryBadge(attentionCount, t("detail.itemsNeedReview"), t), tone: attentionCount ? "warning" : "ready" },
          { Icon: Eye, label: t("detail.mustReview"), value: attentionCount ? t("detail.lessons.mustReview") : t("summary.none"), points: reviewPoints },
          { Icon: ArrowRightCircle, label: t("detail.nextSafeCheck"), value: nextAction, detail: t("detail.lessons.nextSafeDetail"), cta: { href: "#workflow", label: t("detail.openWorkflowPage") } },
        ]}
      />
      <div className="lesson-grid">
        {lessonCards.map((card) => (
          <LessonProgressCard card={card} data={data} key={card.id} t={t} />
        ))}
      </div>
      <LessonLiveStatusTable data={data} t={t} />
      <MockNotice
        tone="warning"
        Icon={AlertTriangle}
        title={t("lesson.healthWarning")}
        cta={{ href: "#maintenance", label: t("lesson.healthWarningCta") }}
      />
    </section>
  );
}

function StatusObjectCard({ id, value, t, Icon = CircleDashed }) {
  const statusValue = value && typeof value === "object" ? value.status : value;
  const details = value && typeof value === "object" ? value : { status: value };
  const detailFields = objectEntries(details)
    .filter(([key]) => key !== "status")
    .map(([key, fieldValue]) => ({ label: displayKey(key), value: fieldValue }));
  return (
    <article className="item-card">
      <div className="item-card__header">
        <Icon aria-hidden="true" size={20} />
        <h3>{displayKey(id)}</h3>
        <StatusPill value={statusValue} t={t} />
      </div>
      <FieldGrid fields={detailFields} />
    </article>
  );
}

function WorkflowSection({ development, gitWorkflow, data, locale, t }) {
  const workflowItems = collectWorkflowItems({ development, gitWorkflow, t });
  const reviewItems = workflowItems.filter((item) => isReviewState(item.state));
  const approvalItems = workflowItems.filter((item) => normalizeState(item.state) === "approval_required").length;
  return (
    <section className="view-surface view-surface--workflow" id="workflow" aria-labelledby="workflow-heading">
      <PageTitleHeader viewId="workflow" Icon={WorkflowCategoryIcon} title={t("workflow.title")} subtitle={t("workflow.description")} data={data} locale={locale} t={t} actionLabel={t("detail.refreshDisplayOnly")} headingId="workflow-heading" />
      <ContextSnapshotStrip data={data} t={t} locale={locale} variant="workflow" />
      <DetailDecisionSummary
        tone="workflow"
        t={t}
        items={[
          { Icon: WorkflowCategoryIcon, label: t("detail.checks"), value: t("detail.workflow.checks"), detail: t("detail.workflow.checksDetail") },
          { Icon: CheckCircle2, label: t("detail.currentJudgment"), value: reviewItems.length ? t("detail.judgment.conditional") : t("detail.judgment.ready"), detail: reviewItems.length ? t("detail.workflow.reviewDetail") : t("detail.workflow.noReviewDetail"), badge: statusSummaryBadge(reviewItems.length, t("detail.itemsNeedReview"), t), tone: reviewItems.length ? "warning" : "ready" },
          { Icon: ListChecks, label: t("detail.mustReview"), value: approvalItems ? `${approvalItems} ${t("detail.approvals")}` : `${reviewItems.length} ${t("detail.items")}`, detail: t("detail.workflow.mustReview"), points: itemTitles(reviewItems, t("detail.noRequiredReview")) },
          { Icon: WorkflowCategoryIcon, label: t("detail.nextSafeCheck"), value: t("detail.workflow.nextSafe"), detail: t("detail.workflow.nextSafeDetail"), cta: { href: "#safety", label: t("detail.openSafetyPage") } },
        ]}
      />
      <GitOperationRail operations={development.git_operations} t={t} />
      <WorkflowStatusCards data={data} t={t} />
      <WorkflowRecentTable rows={development.recent_runs} data={data} t={t} />
      <MockNotice
        tone="workflow-warning"
        Icon={AlertTriangle}
        title={t("workflow.warning.title")}
        detail={t("workflow.warning.detail")}
        cta={{ href: "#maintenance", label: t("workflow.warning.cta") }}
      />
    </section>
  );
}

function MaintenanceConfirmationTable({ manualFollowups, warnings, data, t }) {
  const followupRows = manualFollowups.map((item, index) => ({
    id: displayText(item.source, `manual-${index}`),
    Icon: ClipboardCheck,
    label: sourceLabel(item.source, t),
    required: normalizeState(item.status) === "optional" ? t("detail.optional") : t("detail.required"),
    status: item.status,
    why: sourceWhy(item.source, t) || displayText(item.reason),
    location: item.required_command,
    technicalKey: sourcePresentationKey(item.source),
  }));
  const warningRows = warnings.map((item, index) => ({
    id: `warning-${index}`,
    Icon: AlertTriangle,
    label: displayText(item.source),
    required: t("detail.optional"),
    status: item.status,
    why: displayText(item.reason),
    location: t("detail.warningLocation"),
    technicalKey: "",
  }));
  const rows = [...followupRows, ...warningRows];
  return (
    <div className="confirmation-table">
      <div className="confirmation-table__head">
        <span>{t("detail.confirm.what")}</span>
        <span>{t("detail.confirm.why")}</span>
        <span>{t("detail.confirm.status")}</span>
        <span>{t("detail.confirm.location")}</span>
      </div>
      {rows.length ? (
        rows.map((row) => {
          const Icon = row.Icon;
          return (
            <article className={`confirmation-row confirmation-row--${normalizeState(row.status)}`} key={row.id}>
              <div className="confirmation-row__name">
                <Icon aria-hidden="true" size={21} />
                <div>
                  <strong>{row.label}</strong>
                  {row.technicalKey ? <span>{row.technicalKey}</span> : null}
                </div>
                <span className="small-badge">{row.required}</span>
              </div>
              <p>{row.why}</p>
              <div>
                <StatusPill value={row.status} t={t} />
              </div>
              <div>{String(row.location).startsWith("./") ? <CommandChip command={row.location} /> : technicalChip(row.location)}</div>
            </article>
          );
        })
      ) : (
        <article className="confirmation-row confirmation-row--empty">
          <div className="confirmation-row__name">
            <CheckCircle2 aria-hidden="true" size={21} />
            <strong>{t("summary.none")}</strong>
          </div>
          <p>{t("detail.confirm.none")}</p>
          <div>
            <StatusPill value="ready" t={t} />
          </div>
          <div>{technicalChip(asArray(data.source_files)[0] || t("summary.none"))}</div>
        </article>
      )}
    </div>
  );
}

function maintenanceEvidenceWhy(id, t) {
  return t(`maintenance.evidenceWhy.${displayText(id)}`, t("maintenance.evidenceWhy.default"));
}

function MaintenanceStatusCards({ maintenance, data, t }) {
  const cards = [
    { id: "as_built_sync_status", title: t("maintenance.item.asBuilt"), Icon: RefreshCw, status: maintenance.as_built_sync_status, detail: maintenanceCardDetail(maintenance, ["dashboard_data_schema"], maintenance.as_built_sync_status, t) },
    { id: "workflow_pair_status", title: t("maintenance.item.workflowPair"), Icon: Waypoints, status: maintenance.workflow_pair_status, detail: maintenanceCardDetail(maintenance, ["workflow_pair"], maintenance.workflow_pair_status, t) },
    { id: "developer_memory_status", title: t("maintenance.item.developerMemory"), Icon: Brain, status: maintenance.developer_memory_status, detail: maintenanceCardDetail(maintenance, ["developer_memory"], maintenance.developer_memory_status, t) },
    { id: "skills_status", title: t("maintenance.item.skills"), Icon: BookOpen, status: maintenance.skills_status, detail: stateDetail(maintenance.skills_status, t) },
    { id: "git_workflow_settings", title: t("maintenance.item.gitWorkflowSettings"), Icon: GitBranch, status: data.git_workflow?.settings_status, detail: maintenanceCardDetail(maintenance, ["git_workflow_settings"], data.git_workflow?.settings_status, t) },
    { id: "security_policy", title: t("maintenance.item.securityPolicy"), Icon: ShieldCheck, status: data.security?.policy_status, detail: maintenanceCardDetail(maintenance, ["security_policy"], data.security?.policy_status, t) },
  ];
  return (
    <section className="maintenance-card-grid" aria-label={t("maintenance.statusCards")}>
      {cards.map(({ id, title, Icon, status, detail }) => (
        <article className="maintenance-mini-card" key={id}>
          <span className="maintenance-mini-card__icon">
            <Icon aria-hidden="true" size={24} />
          </span>
          <h3>{title}</h3>
          <StatusPill value={status} t={t} label={statusLabelForChip(status, t)} />
          <p>{detail}</p>
        </article>
      ))}
    </section>
  );
}

function MaintenanceSection({ maintenance, data, locale, t }) {
  const manualFollowups = asArray(data.summary?.manual_followups);
  const warnings = asArray(data.warnings).map((warning, index) => ({
    source: `${t("summary.warningItem")} ${index + 1}`,
    status: "optional",
    reason: warning,
  }));
  const metric = data.summary?.category_metrics?.maintenance;
  const maintenanceItems = objectEntries(maintenance).filter(([id]) => id !== "evidence_rows").map(([id, value]) => {
    const meta = maintenanceItemMeta(id, t);
    return {
      id,
      value,
      state: valueState(value),
      technicalKey: presentationKeyFromId(id),
      ...meta,
    };
  });
  const reviewCount = maintenanceItems.filter((item) => isReviewState(item.state)).length + manualFollowups.length + warnings.length;
  return (
    <section className="view-surface view-surface--maintenance" id="maintenance" aria-labelledby="maintenance-heading">
      <PageTitleHeader viewId="maintenance" Icon={RefreshCw} title={t("maintenance.title")} subtitle={t("maintenance.description")} data={data} locale={locale} t={t} actionLabel={t("detail.refreshMaintenance")} headingId="maintenance-heading" />
      <ContextSnapshotStrip data={data} t={t} locale={locale} variant="maintenance" />
      <DetailDecisionSummary
        tone="maintenance"
        t={t}
        items={[
          { Icon: Target, label: t("detail.checks"), value: t("detail.maintenance.checks"), detail: t("detail.maintenance.checksDetail") },
          { Icon: Scale, label: t("detail.currentJudgment"), value: reviewCount ? t("detail.judgment.usableWithFollowup") : t("detail.judgment.ready"), detail: t("detail.maintenance.reviewDetail"), badge: statusSummaryBadge(manualFollowups.length, t("summary.manualFollowups"), t), tone: reviewCount ? "warning" : "ready" },
          { Icon: Eye, label: t("detail.mustReview"), value: `${reviewCount} ${t("detail.items")}`, detail: t("detail.maintenance.mustReview"), points: itemTitles(maintenanceItems, t("summary.none")) },
          { Icon: ChevronsRight, label: t("detail.nextSafeCheck"), value: t("detail.maintenance.nextSafe"), detail: t("detail.maintenance.nextSafeDetail") },
        ]}
      />
      <MaintenanceStatusCards maintenance={maintenance} data={data} t={t} />
      <EvidenceRowsTable rows={maintenance.evidence_rows} t={t} />
      <SourceBoundary data={data} t={t} />
    </section>
  );
}

function failureSeverity(status) {
  const state = normalizeState(status);
  if (state === "blocked" || state === "failed") {
    return "critical";
  }
  if (state === "approval_required" || state === "unknown" || state === "missing") {
    return "warning";
  }
  return "info";
}

function SafetyFailuresTable({ items, t }) {
  const failures = asArray(items);
  return (
    <section className="failure-table-section" aria-labelledby="partial-failures-heading">
      <div className="failure-table-section__head">
        <h3 id="partial-failures-heading">{t("security.partialFailuresTitle")}</h3>
      </div>
      <div className="failure-table">
        <div className="failure-table__head">
          <span>{t("detail.failure.severity")}</span>
          <span>{t("detail.failure.item")}</span>
          <span>{t("detail.failure.source")}</span>
          <span>{t("detail.failure.reason")}</span>
          <span>{t("detail.failure.status")}</span>
          <span>{t("detail.failure.command")}</span>
        </div>
        {failures.length ? (
          failures.map((item, index) => {
            const severity = failureSeverity(item.status);
            const reasonHint = sourceReasonHint(item.source, t);
            const state = normalizeState(item.status);
            const SeverityIcon = state === "failed" ? CircleX : state === "blocked" ? BadgeAlert : AlertTriangle;
            return (
              <article className={`failure-row failure-row--${severity}`} key={`${displayText(item.source)}-${index}`}>
                <div className="failure-row__severity">
                  <SeverityIcon aria-hidden="true" size={22} />
                </div>
                <div className="failure-row__item">
                  <strong>{sourceLabel(item.source, t)}</strong>
                  <span>{sourcePresentationKey(item.source)}</span>
                </div>
                <div>{sourceDetector(item.source, t)}</div>
                <div>
                  <p>{displayText(item.reason)}</p>
                  {reasonHint ? <span className="small-badge small-badge--soft">{reasonHint}</span> : null}
                </div>
                <div>
                  <StatusPill value={item.status} t={t} />
                </div>
                <div>
                  <CommandChip command={item.required_command} />
                </div>
              </article>
            );
          })
        ) : (
          <article className="failure-row failure-row--empty">
            <div className="failure-row__severity">
              <Info aria-hidden="true" size={18} />
            </div>
            <div className="failure-row__item">
              <strong>{t("summary.none")}</strong>
            </div>
            <div>{t("summary.none")}</div>
            <div><p>{t("detail.security.noFailures")}</p></div>
            <div><StatusPill value="ready" t={t} label={t("summary.none")} /></div>
            <div>{t("summary.none")}</div>
          </article>
        )}
      </div>
    </section>
  );
}

function SecuritySection({ security, partialFailures, data, locale, t }) {
  const securityItems = objectEntries(security).filter(([id]) => !["approvals", "dangerous_operations"].includes(id)).map(([id, value]) => {
    const meta = safetyItemMeta(id, t);
    const hasSecurityGateFailure = id === "gate_status" && asArray(partialFailures).some((failure) => normalizeState(failure.status) === "blocked" || displayText(failure.source) === "security_gate");
    return {
      id,
      value,
      state: hasSecurityGateFailure ? "blocked" : valueState(value),
      technicalKey: presentationKeyFromId(id),
      ...meta,
    };
  });
  const approvalCount = securityItems.filter((item) => normalizeState(item.state) === "approval_required").length;
  const failureCount = asArray(partialFailures).length;
  return (
    <section className="view-surface view-surface--safety" id="safety" aria-labelledby="security-heading">
      <PageTitleHeader viewId="safety" Icon={ShieldCheck} title={t("security.title")} subtitle={t("security.description")} data={data} locale={locale} t={t} actionLabel={t("detail.refreshDisplayOnly")} headingId="security-heading" />
      <ContextSnapshotStrip data={data} t={t} locale={locale} variant="safety" />
      <DetailDecisionSummary
        tone="safety"
        t={t}
        items={[
          { Icon: Target, label: t("detail.checks"), value: t("detail.security.checks"), detail: t("detail.security.checksDetail") },
          { Icon: failureCount ? BadgeAlert : CheckCircle2, label: t("detail.currentJudgment"), value: failureCount ? t("detail.judgment.blocked") : t("detail.judgment.ready"), detail: failureCount ? t("detail.security.blockedDetail") : t("detail.noRequiredReview"), badge: statusSummaryBadge(failureCount, t("summary.partialFailures"), t), tone: failureCount ? "danger" : "ready" },
          { Icon: FileSearch, label: t("detail.mustReview"), value: approvalCount ? `${approvalCount} ${t("detail.approvals")}` : `${failureCount} ${t("detail.items")}`, detail: t("detail.security.mustReview"), points: [t("summary.partialFailures"), t("security.item.approval"), t("actions.title")] },
          { Icon: ArrowRightCircle, label: t("detail.nextSafeCheck"), value: t("detail.security.nextSafe"), detail: t("detail.security.nextSafeDetail"), cta: { href: "#partial-failures-heading", label: t("detail.openPartialFailures") } },
        ]}
      />
      <SecurityStatusCards security={security} partialFailures={partialFailures} data={data} t={t} />
      <SafetyFailuresTable items={partialFailures} t={t} />
    </section>
  );
}

function CommandPreviews({ actions, t }) {
  const previews = asArray(actions?.command_previews);
  if (!previews.length) {
    return null;
  }
  return (
    <section className="command-preview-panel" aria-labelledby="action-heading">
      <div className="command-preview-panel__head">
        <div>
          <TerminalSquare aria-hidden="true" size={22} />
          <h2 id="action-heading">{t("actions.title")}</h2>
        </div>
        <p>{t("actions.description")}</p>
      </div>
      <div className="preview-list">
        {previews.map((preview, index) => (
          <article className={`command-preview command-preview--${normalizeRisk(preview.risk_level)}`} key={`${displayText(preview.intent)}-${index}`}>
            <div className="command-preview__head">
              <span className="command-preview__icon">
                <ShieldCheck aria-hidden="true" size={18} />
              </span>
              <div>
                <h3>{commandIntentLabel(preview.intent, t)}</h3>
              </div>
            </div>
            <CommandChip command={preview.command_text} />
            <div className="command-preview__badges">
              <span className="display-only-badge">{t("actions.displayOnly")}</span>
              <span className="display-only-badge">{preview.non_executable === true ? t("actions.notExecutable") : t("field.unknown")}</span>
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}

function SecurityPolicyPanel({ security, data, t }) {
  const context = selectedContextData(data);
  const status = security?.policy_status || "unknown";
  const contexts = ["free-development", "product-improvement", "external-integration", "lesson-repository-improvement"];
  const activePolicyContext = displayText(context.workflow_context) === "lesson" ? "lesson-repository-improvement" : displayText(context.menu_id);
  return (
    <section className="security-policy-panel" aria-labelledby="security-policy-heading">
      <div className="security-policy-panel__head">
        <div>
          <h2 id="security-policy-heading">{t("security.policyPanel")}</h2>
          <p>{t("security.policyPanelDetail")}</p>
        </div>
      </div>
      <div className="security-policy-panel__chips">
        {contexts.map((id) => (
          <span className={activePolicyContext === id ? "is-active" : ""} key={id}>{contextLabel(id, t)}</span>
        ))}
      </div>
      <div className="security-policy-panel__body">
        <div>
          <FileCheck2 aria-hidden="true" size={20} />
          <p>{t("security.policyScopeDetail")}</p>
        </div>
        <StatusPill value={status} t={t} label={`${t("security.policyActive")}: ${statusLabelForChip(status, t)}`} />
      </div>
      <ul>
        <li>{t("security.policyPoint.guard")}</li>
        <li>{t("security.policyPoint.block")}</li>
        <li>{t("security.policyPoint.pass")}</li>
      </ul>
    </section>
  );
}

function SafetySection({ security, actions, partialFailures, data, locale, t }) {
  return (
    <>
      <SecuritySection security={security} partialFailures={partialFailures} data={data} locale={locale} t={t} />
      <div className="safety-lower-grid">
        <CommandPreviews actions={actions} t={t} />
        <SecurityPolicyPanel security={security} data={data} t={t} />
      </div>
      <ReadOnlyBanner t={t} tone="safety" />
    </>
  );
}

function SourceBoundary({ data, t }) {
  const files = asArray(data.source_files);
  const commands = asArray(data.source_commands);
  return (
    <section className="source-boundary" aria-label={t("aria.dataBoundary")}>
      <header className="source-boundary__head">
        <FileText aria-hidden="true" size={22} />
        <div>
          <h3>{t("maintenance.dataRoot.title")}</h3>
          <p>{t("maintenance.dataRoot.detail")}</p>
        </div>
      </header>
      <div className="source-boundary__grid">
        <div>
          <FileText aria-hidden="true" size={20} />
          <div>
            <strong>{t("app.sourceFiles")}</strong>
            {compactTechnicalChips(files, t, 3)}
          </div>
        </div>
        <div>
          <TerminalSquare aria-hidden="true" size={20} />
          <div>
            <strong>{t("app.sourceCommands")}</strong>
            {compactTechnicalChips(commands, t, 2)}
          </div>
        </div>
        <div>
          <Lock aria-hidden="true" size={20} />
          <div>
            <strong>{t("detail.readOnlyShort")}</strong>
            <p>{t("detail.readOnlySourceBoundary")}</p>
          </div>
        </div>
      </div>
    </section>
  );
}

function Sidebar({ activeView, t, data, locale, loaded }) {
  const generated = loaded && data.generated_at ? formatDateTime(data.generated_at, locale) : "";
  const showRepositoryGroup = activeView === "overview" || activeView === "maintenance";
  const showReadOnlyGroup = activeView === "safety";
  const showSimpleSupport = activeView === "lessons" || activeView === "workflow";
  return (
    <aside className={`app-sidebar app-sidebar--${activeView}`} aria-label={t("aria.categories")}>
      <div className="brand">
        <BrandMark />
        <div>
          <strong>{t("app.title")}</strong>
          <span>{t("app.eyebrow")}</span>
        </div>
      </div>
      <nav className="category-nav" aria-label={t("aria.categories")}>
        {navigation.map(({ id, labelKey, Icon }) => (
          <a className={activeView === id ? "category-nav__link is-active" : "category-nav__link"} href={`#${id}`} aria-current={activeView === id ? "page" : undefined} key={id}>
            <Icon aria-hidden="true" size={18} />
            <span>{activeView !== "overview" && id === "overview" ? t("nav.overviewDetail") : t(labelKey)}</span>
          </a>
        ))}
      </nav>
      {showRepositoryGroup ? (
        <nav className="support-nav" aria-label={t("nav.repositoryGroup")}>
          <h3>{t("nav.repositoryGroup")}</h3>
          {repositoryNavigation.map(({ id, labelKey, Icon }) => (
            <span className="category-nav__link category-nav__link--subtle" aria-disabled="true" key={id}>
              <Icon aria-hidden="true" size={18} />
              <span>{t(labelKey)}</span>
            </span>
          ))}
        </nav>
      ) : null}
      {showSimpleSupport ? (
        <nav className="support-nav support-nav--plain" aria-label={t("nav.otherGroup")}>
          {[repositoryNavigation[2], supportNavigation[0]].map(({ id, labelKey, Icon }) => (
            <span className="category-nav__link category-nav__link--subtle" aria-disabled="true" key={id}>
              <Icon aria-hidden="true" size={18} />
              <span>{t(labelKey)}</span>
            </span>
          ))}
        </nav>
      ) : null}
      {showReadOnlyGroup ? (
        <>
          <nav className="support-nav support-nav--plain" aria-label={t("nav.settings")}>
            <span className="category-nav__link category-nav__link--subtle" aria-disabled="true">
              <Settings aria-hidden="true" size={18} />
              <span>{t("nav.settings")}</span>
            </span>
          </nav>
          <nav className="support-nav" aria-label={t("nav.readOnlyGroup")}>
            <h3>{t("nav.readOnlyGroup")}</h3>
            {supportNavigation.map(({ id, labelKey, Icon }) => (
              <span className="category-nav__link category-nav__link--subtle" aria-disabled="true" key={id}>
                <Icon aria-hidden="true" size={18} />
                <span>{t(labelKey)}</span>
              </span>
            ))}
          </nav>
        </>
      ) : null}
      {showRepositoryGroup ? (
        <nav className="support-nav" aria-label={t("nav.otherGroup")}>
          <h3>{t("nav.otherGroup")}</h3>
          {supportNavigation.map(({ id, labelKey, Icon }) => (
            <span className="category-nav__link category-nav__link--subtle" aria-disabled="true" key={id}>
              <Icon aria-hidden="true" size={18} />
              <span>{t(labelKey)}</span>
            </span>
          ))}
        </nav>
      ) : null}
      <div className="sidebar-meta">
        <div className="sidebar-note">
          <Info aria-hidden="true" size={16} />
          <span>{t("sidebar.readOnlyNotice")}</span>
        </div>
      </div>
    </aside>
  );
}

function BrandMark() {
  return (
    <svg className="brand-mark" aria-hidden="true" viewBox="0 0 32 36" width="32" height="36" fill="none">
      <path d="M16 2.5 29 8v9.5c0 8.2-5.2 13.1-13 16-7.8-2.9-13-7.8-13-16V8l13-5.5Z" stroke="currentColor" strokeWidth="2.6" />
      <path d="M16 9.5v12M10 15.5h12" stroke="currentColor" strokeWidth="2.3" strokeLinecap="round" />
      <path d="M22.5 8.5 24 11l2.5 1.5L24 14l-1.5 2.5L21 14l-2.5-1.5L21 11l1.5-2.5Z" fill="currentColor" />
    </svg>
  );
}

function resolveRefreshIntervalMs() {
  const defaultRefreshMs = 3000;
  const params = new URLSearchParams(window.location.search);
  // Test-only override for deterministic Playwright refresh assertions.
  const requested = Number(params.get("refresh_ms"));
  if (Number.isFinite(requested) && requested >= 100) {
    return Math.min(requested, 60000);
  }
  return defaultRefreshMs;
}

function SyncBanner({ error, t }) {
  if (!error) {
    return null;
  }
  return (
    <div className="sync-banner" role="status">
      <AlertTriangle aria-hidden="true" size={18} />
      <span>{t("app.refreshIssue")}</span>
      <small>{displayText(error.message)}</small>
    </div>
  );
}

export default function App() {
  const [state, setState] = useState({ status: "loading", data: null, error: null, refreshError: null, signature: "" });
  const [activeView, setActiveView] = useState(viewFromHash);
  const locale = useMemo(() => {
    const summary = state.data?.summary || {};
    return resolveLocale([
      summary.display_locale,
      summary.ui_locale,
      summary.environment_locale,
      ...(Array.isArray(navigator.languages) ? navigator.languages : [navigator.language]),
    ]);
  }, [state.data]);
  const t = useMemo(() => createTranslator(locale), [locale]);
  const refreshIntervalMs = useMemo(() => resolveRefreshIntervalMs(), []);

  useEffect(() => {
    function handleHashChange() {
      setActiveView(viewFromHash());
    }
    window.addEventListener("hashchange", handleHashChange);
    return () => {
      window.removeEventListener("hashchange", handleHashChange);
    };
  }, []);

  useEffect(() => {
    let active = true;
    let inFlight = false;
    let timerId = 0;

    async function loadSnapshot() {
      if (inFlight) {
        return;
      }
      inFlight = true;
      try {
        const snapshot = await fetchDashboardDataSnapshot();
        if (!active) {
          return;
        }
        setState((previous) => {
          if (previous.signature === snapshot.signature && previous.data) {
            return { ...previous, status: "ready", error: null, refreshError: null };
          }
          return { status: "ready", data: snapshot.data, error: null, refreshError: null, signature: snapshot.signature };
        });
      } catch (error) {
        if (!active) {
          return;
        }
        setState((previous) => {
          if (previous.data) {
            return { ...previous, status: "stale", error: null, refreshError: error };
          }
          return { status: "failed", data: null, error, refreshError: null, signature: "" };
        });
      } finally {
        inFlight = false;
      }
    }

    loadSnapshot();
    timerId = window.setInterval(loadSnapshot, refreshIntervalMs);
    return () => {
      active = false;
      window.clearInterval(timerId);
    };
  }, [refreshIntervalMs]);

  const data = state.data || {};
  const loaded = Boolean(state.data) && (state.status === "ready" || state.status === "stale");

  return (
    <main className="app-shell">
      <Sidebar activeView={activeView} t={t} data={data} locale={locale} loaded={loaded} />
      <section className="app-main">
        <h1 className="sr-only">{t("app.title")}</h1>
        <SyncBanner error={loaded ? state.refreshError : null} t={t} />

        {state.status === "loading" ? (
          <section className="view-surface" aria-label="Loading">
            <p>{t("app.loading")}</p>
          </section>
        ) : null}

        {state.status === "failed" ? (
          <section className="view-surface" aria-label="Data unavailable">
            <div className="view-header">
              <div>
                <AlertTriangle aria-hidden="true" size={22} />
                <h2>{t("app.dataUnavailable")}</h2>
              </div>
              <p>{displayText(state.error?.message)}</p>
            </div>
          </section>
        ) : null}

        {loaded && activeView === "overview" ? <OverviewSection data={data} t={t} locale={locale} /> : null}
        {loaded && activeView === "lessons" ? <LessonSection lessons={data.lessons || {}} data={data} locale={locale} t={t} /> : null}
        {loaded && activeView === "workflow" ? <WorkflowSection development={data.development || {}} gitWorkflow={data.git_workflow || {}} data={data} locale={locale} t={t} /> : null}
        {loaded && activeView === "maintenance" ? <MaintenanceSection maintenance={data.maintenance || {}} data={data} locale={locale} t={t} /> : null}
        {loaded && activeView === "safety" ? <SafetySection security={data.security || {}} actions={data.actions || {}} partialFailures={data.partial_failures || []} data={data} locale={locale} t={t} /> : null}
      </section>
    </main>
  );
}
