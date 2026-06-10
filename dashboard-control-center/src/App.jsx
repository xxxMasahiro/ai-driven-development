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
import { useEffect, useMemo, useRef, useState } from "react";

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
  { id: "maintenance", labelKey: "nav.maintenance", healthKey: "health.maintenance", Icon: RefreshCw, tone: "maintenance" },
  { id: "safety", labelKey: "nav.safety", healthKey: "health.security", Icon: ShieldCheck, tone: "safety" },
];

const repositoryNavigation = [
  { id: "repository-info", labelKey: "nav.repositoryInfo", Icon: Info, href: "#repository-info" },
  { id: "documents", labelKey: "nav.documents", Icon: FileText, href: "#documents" },
  { id: "settings", labelKey: "nav.settings", Icon: Settings, href: "#settings" },
];

const supportNavigation = [
  { id: "help", labelKey: "nav.help", Icon: CircleHelp, href: "#help" },
  { id: "history", labelKey: "nav.history", Icon: Clock, href: "#history" },
];

const allNavigation = [...navigation, ...repositoryNavigation, ...supportNavigation];

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
  return allNavigation.some((item) => item.id === hash) ? hash : "overview";
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

function ContextStripValue({ value, format, animateNumerator = false }) {
  const text = displayText(value, "");
  const fraction = text.match(/^(?:(Step)\s+)?(\d+)\s*\/\s*(\d+)$/i);
  if ((format === "fraction" || format === "step-fraction") && fraction) {
    const [, prefix, numerator, denominator] = fraction;
    return (
      <strong className="context-strip__value context-strip__value--fraction" aria-label={text}>
        {prefix ? <span className="context-strip__value-prefix">{prefix}</span> : null}
        {animateNumerator ? (
          <AnimatedNumber value={numerator} className="context-strip__value-numerator" />
        ) : (
          <span>{numerator}</span>
        )}
        <span className="context-strip__value-separator">/</span>
        <span className="context-strip__value-denominator">{denominator}</span>
      </strong>
    );
  }
  return <strong>{value}</strong>;
}

function AnimatedNumber({ value, duration = 720, className = "" }) {
  const target = Number(value);
  const isNumeric = Number.isFinite(target);
  const [displayValue, setDisplayValue] = useState(isNumeric ? 0 : value);
  const [running, setRunning] = useState(isNumeric);

  useEffect(() => {
    if (!isNumeric) {
      setDisplayValue(value);
      setRunning(false);
      return undefined;
    }
    if (window.matchMedia?.("(prefers-reduced-motion: reduce)")?.matches) {
      setDisplayValue(target);
      setRunning(false);
      return undefined;
    }

    setDisplayValue(0);
    setRunning(true);
    let frame = 0;
    const start = performance.now();
    const easeOut = (progress) => 1 - Math.pow(1 - progress, 3);
    const tick = (now) => {
      const progress = Math.min((now - start) / duration, 1);
      setDisplayValue(Math.round(target * easeOut(progress)));
      if (progress < 1) {
        frame = requestAnimationFrame(tick);
        return;
      }
      setDisplayValue(target);
      setRunning(false);
    };

    frame = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(frame);
  }, [duration, isNumeric, target, value]);

  const classes = `animated-number${running ? " animated-number--running" : ""}${className ? ` ${className}` : ""}`;
  return <span className={classes}>{displayValue}</span>;
}

function AnimatedProgressRing({ percent, className = "", duration = 900 }) {
  const target = clampPercent(percent);
  const [displayPercent, setDisplayPercent] = useState(0);

  useEffect(() => {
    if (window.matchMedia?.("(prefers-reduced-motion: reduce)")?.matches) {
      setDisplayPercent(target);
      return undefined;
    }

    setDisplayPercent(0);
    let frame = 0;
    const start = performance.now();
    const easeOut = (progress) => 1 - Math.pow(1 - progress, 3);
    const tick = (now) => {
      const progress = Math.min((now - start) / duration, 1);
      setDisplayPercent(Math.round(target * easeOut(progress)));
      if (progress < 1) {
        frame = requestAnimationFrame(tick);
        return;
      }
      setDisplayPercent(target);
    };

    frame = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(frame);
  }, [duration, target]);

  return (
    <span
      className={`mini-progress-ring${className ? ` ${className}` : ""}`}
      style={{ "--metric-percent": `${displayPercent}%` }}
      aria-hidden="true"
    />
  );
}

function OverviewLessonProgressValue({ value }) {
  const text = displayText(value, "");
  const fraction = text.match(/^(\d+)\s*\/\s*(\d+)$/);
  if (!fraction) {
    return <ContextStripValue value={value} format="fraction" />;
  }
  const [, numerator, denominator] = fraction;
  return (
    <strong className="context-strip__value context-strip__value--fraction overview-status-card__lesson-count" aria-label={text}>
      <AnimatedNumber value={numerator} className="context-strip__value-numerator" />
      <span className="context-strip__value-separator">/</span>
      <span className="context-strip__value-denominator">{denominator}</span>
    </strong>
  );
}

function contextStripLabel(label, variant) {
  const text = displayText(label, "");
  if (variant !== "lessons" || !text || /[:：]$/.test(text)) {
    return text;
  }
  return `${text}:`;
}

function ContextSnapshotStrip({ data, t, locale, variant = "overview" }) {
  const context = selectedContextData(data);
  const targetRepository = context.target_repository || {};
  const generated = context.updated_at ? formatDashboardDateTime(context.updated_at) || formatDateTime(context.updated_at, locale) : formatGenerated(data, locale);
  const metric = data.summary?.category_metrics?.lessons || {};
  const progress = contextProgress(context, metric);
  const selectedMenu = contextLabel(context.menu_id, t);
  const currentStep = selectedStepText(context);
  const currentStepShort = selectedStepShort(context);
  const currentStepDetail = localizedStepDetail(context, t);
  const nextSafeAction = context.next_safe_action || data.summary?.primary_action || {};
  const nextAction = nextActionShort(context, data, t);
  const rowsByVariant = {
    overview: [
      { label: t("mock.context.now"), value: currentStep, Icon: Target, tone: "blue" },
      { label: t("mock.context.target"), value: displayText(targetRepository.name), Icon: Folder, tone: "gray" },
      { label: t("mock.context.nextOperation"), value: nextAction || displayText(nextSafeAction.title, displayText(nextSafeAction.description)), Icon: ArrowRightCircle, tone: "blue" },
      { label: t("app.lastUpdated"), value: generated, Icon: Clock, tone: "purple" },
    ],
    lessons: [
      { label: t("mock.context.selected"), value: selectedMenu, Icon: BookOpen, tone: "blue" },
      { label: t("mock.context.progress"), value: `${progress.completed} / ${progress.total}`, Icon: CircleDashed, tone: "blue", progress: progress.percent, valueFormat: "fraction" },
      { label: t("mock.context.current"), value: currentStepShort, detail: currentStepDetail, Icon: Flag, tone: "blue", valueFormat: "step-fraction" },
      { label: t("mock.context.next"), value: nextAction || displayText(nextSafeAction.title, displayText(nextSafeAction.description)), Icon: ArrowRightCircle, tone: "blue" },
    ],
    workflow: [
      { label: "", value: selectedMenu, Icon: BookOpen, tone: "blue" },
      { label: t("mock.context.externalRepository"), value: displayText(targetRepository.name), Icon: Database, tone: "teal" },
      { label: currentStepShort, value: displayText(context.current_step_id), Icon: Flag, tone: "teal" },
      { label: t("mock.context.nextStep"), value: nextAction || displayText(nextSafeAction.title, displayText(nextSafeAction.description)), Icon: ArrowRightCircle, tone: "teal" },
    ],
    maintenance: [
      { label: t("mock.context.maintenance.selectedMenu"), value: selectedMenu, Icon: BookOpen, tone: "purple", chip: true },
      { label: t("mock.context.maintenance.targetRepository"), value: displayText(targetRepository.name), Icon: Folder, tone: "purple" },
      { label: t("mock.context.maintenance.activeStep"), value: currentStepShort, Icon: Flag, tone: "purple" },
      { label: t("mock.context.maintenance.dataSource"), value: t("mock.context.dashboardSnapshot"), Icon: Database, tone: "purple" },
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
      {rows.map(({ label, value, valueFormat, detail, Icon, tone, progress, chip, invert }, index) => (
        <article className={`context-strip__item context-strip__item--${tone || "default"}${invert ? " context-strip__item--invert" : ""}${chip ? " context-strip__item--chip" : ""}`} key={`${label}-${value}-${index}`}>
          <span className="context-strip__icon">
            {Number.isFinite(progress) ? (
              <AnimatedProgressRing percent={progress} className="mini-progress-ring--icon" />
            ) : (
              <Icon aria-hidden="true" size={24} />
            )}
          </span>
          <div>
            {label ? <span>{contextStripLabel(label, variant)}</span> : null}
            <ContextStripValue
              value={value}
              format={valueFormat}
              animateNumerator={variant === "lessons" && (Number.isFinite(progress) || valueFormat === "step-fraction")}
            />
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
  const percentValue = id === "lessons" ? displayText(detail, "").match(/^(\d+)%$/) : null;
  return (
    <article className={`overview-status-card overview-status-card--${config.tone}`} data-overview-status-card={id}>
      <div className="overview-status-card__head">
        <span className="overview-status-card__icon">
          <Icon aria-hidden="true" size={26} />
        </span>
        <div>
          <h3>{title}</h3>
          {id === "lessons" ? <OverviewLessonProgressValue value={valueText} /> : <strong>{valueText}</strong>}
        </div>
      </div>
      {metric ? (
        <div className="overview-status-card__progress-row">
          <HorizontalProgress percent={metric.percent} />
          <strong className="overview-status-card__progress-value">
            {percentValue ? (
              <>
                <AnimatedNumber value={percentValue[1]} className="overview-status-card__progress-number" />
                %
              </>
            ) : detail}
          </strong>
        </div>
      ) : null}
      {detail && !metric ? <p>{detail}</p> : null}
      {chipLabel ? <span className={`status-chip status-chip--${config.tone} ${chipCompactClass}`.trim()}>{chipLabel}</span> : <StatusPill value={state} t={t} />}
    </article>
  );
}

function gitOperationIcon(id) {
  const map = {
    commit: GitBranch,
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
  if (normalized === "manual") {
    return t("mock.git.manual");
  }
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
            <strong>{gitOperationDisplayLabel(row.id, row.label, t)}</strong>
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
  const nextAction = nextActionShort(context, data, t);
  const cards = [
    { id: "git-sync", title: t("workflow.card.gitSync"), Icon: RefreshCw, value: workflowStatusLabel(context.git_status, t), detail: normalizeState(context.git_status) === "passed" || normalizeState(context.git_status) === "ready" ? t("workflow.card.gitSyncDetail") : t("workflow.card.gitSyncReviewDetail"), button: t("summary.viewDetails") },
    { id: "ci", title: t("workflow.card.ci"), Icon: CheckCircle2, value: workflowStatusLabel(context.ci_status, t), detail: normalizeState(context.ci_status) === "passed" || normalizeState(context.ci_status) === "ready" ? displayText(context.target_repository?.name) : t("workflow.card.ciReviewDetail"), button: t("summary.viewDetails") },
    { id: "pr-merge", title: t("workflow.card.prMerge"), Icon: GitPullRequest, value: workflowStatusLabel(data.git_workflow?.approval_status, t), detail: t("workflow.card.prMergeDetail"), button: t("summary.viewDetails") },
    { id: "product-evidence", title: t("workflow.card.productEvidence"), Icon: Folder, value: productEvidenceStatusLabel(productAuthority, t), detail: productEvidenceDetail(productAuthority, t), button: t("workflow.card.collectEvidence") },
    { id: "next-step", title: t("workflow.card.nextStep"), Icon: Flag, value: displayText(context.current_step_id), detail: nextAction || localizedStepDetail(context, t), button: workflowStepDetailLabel(context, t) },
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
  const context = selectedContextData(data);
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
            <span data-label={t("workflow.table.time")}>{formatDashboardDateTime(row.time) || displayText(row.time)}</span>
            <strong data-label={t("workflow.table.type")}>{workflowRunTypeLabel(row.type, t)}</strong>
            <span data-label={t("workflow.table.target")}>{displayText(row.target)}</span>
            <p data-label={t("workflow.table.detail")}>{workflowRunDetail(row, context, t)}</p>
            <span className="mock-table-row__status" data-label={t("workflow.table.status")}>
              <StatusPill value={row.status} t={t} label={workflowStatusLabel(row.status, t)} />
            </span>
            <a className="mock-table-link" href="#workflow" data-label={t("workflow.table.reference")}>{workflowRunReferenceLabel(row.reference, t)} <ExternalLink aria-hidden="true" size={13} /></a>
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
              {(() => {
                const Icon = maintenanceEvidenceIcon(row.id);
                return <Icon aria-hidden="true" size={20} />;
              })()}
              <strong>{maintenanceEvidenceLabel(row, t)}</strong>
            </div>
            <p>{maintenanceEvidenceWhy(row.id, t)}</p>
            <StatusPill value={row.status} t={t} label={maintenanceStatusLabel(row.id, row.status, t)} />
            <div className="evidence-row__reference">
              {maintenanceReferenceValues(row).map((reference) => (
                <span className="evidence-row__reference-chip" key={reference} tabIndex={0} data-tooltip={reference}>
                  {technicalChip(reference)}
                  <button className="evidence-row__reference-copy" type="button" aria-label={`${t("maintenance.copyReference")}: ${reference}`} title={t("maintenance.copyReference")} onClick={() => copyTextToClipboard(reference)}>
                    <Copy aria-hidden="true" size={14} />
                  </button>
                </span>
              ))}
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}

function maintenanceEvidenceIcon(id) {
  const map = {
    dashboard_data_schema: FileJson,
    product_authority_evidence: FileSearch,
    git_workflow_settings: GitBranch,
    security_policy: ShieldCheck,
    developer_memory: Brain,
    workflow_pair: Waypoints,
  };
  return map[displayText(id, "")] || FileCheck2;
}

function SecurityStatusCards({ security, partialFailures, data, t }) {
  const failures = asArray(partialFailures);
  const approvals = asArray(security?.approvals);
  const dangerous = asArray(security?.dangerous_operations);
  const lastChecked = formatDashboardTime(approvals[0]?.last_checked || dangerous[0]?.last_checked || data.generated_at);
  const cards = [
    { id: "gate", title: t("security.item.gate"), Icon: ShieldCheck, status: security?.gate_status, value: statusLabelForChip(security?.gate_status, t), detail: securityGateDetail(security, failures, t) },
    { id: "approval", title: t("security.approvals"), Icon: UserCheck, status: approvals[0]?.status || security?.dangerous_action_approval, value: approvals.length ? statusLabelForChip(approvals[0]?.status || security?.dangerous_action_approval, t) : t("security.card.noApprovalWaiting"), detail: securityApprovalDetail(approvals[0], security?.dangerous_action_approval, t) },
    { id: "dangerous", title: t("security.dangerousOperations"), Icon: AlertTriangle, status: dangerous[0]?.status || "ready", value: dangerous.length ? `${dangerous.length}` : t("summary.none"), detail: securityDangerousOperationDetail(dangerous[0], t) },
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

function copyTextToClipboard(value) {
  const text = displayText(value, "");
  if (!text) {
    return;
  }
  if (navigator.clipboard?.writeText) {
    void navigator.clipboard.writeText(text);
    return;
  }
  const textarea = document.createElement("textarea");
  textarea.value = text;
  textarea.setAttribute("readonly", "");
  textarea.style.position = "fixed";
  textarea.style.opacity = "0";
  document.body.appendChild(textarea);
  textarea.select();
  document.execCommand("copy");
  document.body.removeChild(textarea);
}

function showMoreItemsLabel(remaining, t) {
  const prefix = t("app.showMoreItemsPrefix", "");
  const suffix = t("app.showMoreItemsSuffix", "");
  return `${prefix ? `${prefix} ` : ""}${remaining} ${t("summary.moreItems")}${suffix}`;
}

function SourceBoundaryChips({ values, t, limit = 3, variant = "default" }) {
  const [expanded, setExpanded] = useState(false);
  const normalized = asArray(values).map((value) => displayText(value, "")).filter(Boolean);
  if (!normalized.length) {
    return <span>{t("summary.none")}</span>;
  }
  const visible = expanded ? normalized : normalized.slice(0, limit);
  const remaining = Math.max(0, normalized.length - limit);
  return (
    <div className={`source-boundary__chips source-boundary__chips--${variant}${expanded ? " source-boundary__chips--expanded" : ""}`}>
      {visible.map((value, index) => (
        <span className="source-boundary__chip" key={`${value}-${index}`} tabIndex={0} data-tooltip={value}>
          {technicalChip(value)}
          <button className="source-boundary__chip-copy" type="button" aria-label={`${t("app.copyItem")}: ${value}`} title={t("app.copyItem")} onClick={() => copyTextToClipboard(value)}>
            <Copy aria-hidden="true" size={14} />
          </button>
        </span>
      ))}
      {remaining > 0 ? (
        <button className="source-boundary__expand" type="button" aria-expanded={expanded} onClick={() => setExpanded((current) => !current)}>
          {expanded ? t("app.hideExtraItems") : showMoreItemsLabel(remaining, t)}
        </button>
      ) : null}
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

function normalizedStepCountLabel(value) {
  const text = displayText(value, "");
  const match = text.match(/step\s*(\d+)\s*\/\s*(\d+)/i);
  return match ? `Step ${match[1]} / ${match[2]}` : "";
}

function stepTitleFromSlug(value) {
  return displayText(value, "")
    .split(".")
    .slice(1)
    .join(".")
    .replace(/[-_.]+/g, " ")
    .replace(/\b\w/g, (character) => character.toUpperCase());
}

function selectedStepParts(context) {
  const label = displayText(context.current_step_label || "", "");
  const id = displayText(context.current_step_id, "");
  const explicitStep = normalizedStepCountLabel(label);
  if (explicitStep) {
    const detail = label
      .replace(/step\s*\d+\s*\/\s*\d+/i, "")
      .replace(/^(\s*[-:]\s*)+/, "")
      .trim();
    return { short: explicitStep, detail: detail || (label === id ? stepTitleFromSlug(id) : displayText(id, "")), id };
  }

  const dayMatch = id.match(/^day(\d+)\./i);
  if (dayMatch) {
    const menuId = displayText(context.menu_id, "");
    const total = menuId === "step_1_7" ? 7 : 14;
    return { short: `Step ${dayMatch[1]} / ${total}`, detail: label && label !== id ? label : stepTitleFromSlug(id), id };
  }

  const index = Number.isInteger(context.current_step_index) ? context.current_step_index : null;
  const total = Number.isInteger(context.current_step_total) ? context.current_step_total : null;
  const short = index && total ? `Step ${index} / ${total}` : displayText(label || id);
  const detail = label && label !== short && label !== id ? label : stepTitleFromSlug(id);
  return { short, detail, id };
}

function selectedStepText(context, { includeId = false } = {}) {
  const { short, detail, id } = selectedStepParts(context);
  if (includeId && id) {
    return `${short} ${id}`;
  }
  return detail ? `${short} ${detail}` : short;
}

function selectedStepShort(context) {
  return selectedStepParts(context).short;
}

function selectedStepDetail(context) {
  return selectedStepParts(context).detail;
}

function localizedStepDetail(context, t) {
  const id = displayText(context.current_step_id, "");
  const translated = id ? t(`lesson.step.${id}`, "") : "";
  return translated || selectedStepDetail(context);
}

function localizedLessonAction(value, context, t) {
  const text = displayText(value, "");
  if (!text) {
    return "";
  }
  const currentStepId = displayText(context?.current_step_id, "");
  if (text === "Review selected context" && currentStepId === "day12.subagents-plan") {
    return t("lesson.nextAction.reviewSubagentsPlan");
  }
  const knownActions = {
    "Review selected context": "lesson.nextAction.reviewSelectedContext",
    "Restore the lesson state source before continuing.": "lesson.nextAction.reviewLearningSettings",
    "Select missing lesson settings before passing the next lesson step.": "lesson.nextAction.reviewLearningSettings",
    "Review the current step and obtain the required approval before passing it.": "lesson.nextAction.reviewCurrentStep",
    "Request learner approval before starting the applied lesson workflow.": "lesson.nextAction.requestAppliedApproval",
  };
  return knownActions[text] ? t(knownActions[text]) : text;
}

function contextProgress(context, fallbackMetric = {}) {
  const total = Number(context?.current_step_total);
  const index = Number(context?.current_step_index);
  if (Number.isInteger(total) && total > 0 && Number.isInteger(index) && index >= 0) {
    const completed = Math.min(total, Math.max(0, index > 0 ? index - 1 : 0));
    return {
      completed,
      total,
      percent: clampPercent((completed / total) * 100),
      source: "context",
    };
  }
  return {
    completed: Number.isInteger(fallbackMetric?.healthy) ? fallbackMetric.healthy : 0,
    total: Number.isInteger(fallbackMetric?.total) ? fallbackMetric.total : 0,
    percent: clampPercent(fallbackMetric?.percent),
    source: "metric",
  };
}

function nextActionShort(context, data, t) {
  const action = context.next_safe_action || data.summary?.primary_action || {};
  const text = displayText(action.title || action.description, "");
  return t ? localizedLessonAction(text, context, t) : text;
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

function workflowStatusLabel(value, t) {
  const state = normalizeState(value);
  const labels = {
    ready: "workflow.status.ready",
    passed: "workflow.status.passed",
    failed: "workflow.status.failed",
    blocked: "workflow.status.needsConfirmation",
    unknown: "workflow.status.needsConfirmation",
    optional: "workflow.status.needsConfirmation",
    cached: "workflow.status.needsConfirmation",
    not_run: "workflow.status.notCollected",
    stale: "workflow.status.stale",
    missing: "workflow.status.notCollected",
    approval_required: "workflow.status.needsApproval",
    manual_required: "workflow.status.needsConfirmation",
  };
  return t(labels[state] || `state.${state}`, displayText(state));
}

function productEvidenceStatusLabel(productAuthority, t) {
  const state = normalizeState(productAuthority?.status);
  if (state === "blocked" || state === "missing" || state === "not_run" || state === "unknown") {
    return t("workflow.status.evidenceMissing");
  }
  return workflowStatusLabel(state, t);
}

function productEvidenceDetail(productAuthority, t) {
  const summary = productAuthority?.manifest_summary || {};
  const ready = Number(summary.required_ready);
  const total = Number(summary.required_total);
  if (Number.isInteger(ready) && Number.isInteger(total) && total > 0) {
    return `${t("workflow.card.requiredDocs")}: ${ready} / ${total} ${t("workflow.card.readyUnit")}`;
  }
  const evidenceItems = asArray(productAuthority?.evidence_summary?.items);
  if (evidenceItems.length) {
    const collected = evidenceItems.filter((item) => ["ready", "passed"].includes(normalizeState(item.status))).length;
    return `${t("workflow.card.evidence")}: ${collected} / ${evidenceItems.length} ${t("workflow.card.collectedUnit")}`;
  }
  return t("workflow.card.productEvidenceDetail");
}

function currentStepNumber(context) {
  const short = selectedStepShort(context);
  const match = displayText(short, "").match(/Step\s+(\d+)/i);
  return match ? match[1] : "";
}

function workflowStepDetailLabel(context, t) {
  const step = currentStepNumber(context);
  return step ? `${t("workflow.card.stepLabel")} ${step} ${t("workflow.card.stepDetailSuffix")}` : t("workflow.card.stepDetail");
}

function workflowRunTypeLabel(value, t) {
  const key = displayText(value, "");
  const map = {
    "CI run": "workflow.run.ci",
    "Git sync": "workflow.run.gitSync",
    "Product evidence": "workflow.run.productEvidence",
    "Security gate": "workflow.run.securityGate",
    "Next step": "workflow.run.nextStep",
  };
  return map[key] ? t(map[key]) : displayText(value);
}

function workflowRunDetail(row, context, t) {
  const detail = displayText(row.detail, "");
  const map = {
    "Current snapshot CI evidence": "workflow.runDetail.ci",
    "Current snapshot Git synchronization evidence": "workflow.runDetail.gitSync",
    "Product authority and manifest evidence": "workflow.runDetail.productEvidence",
    "Product security gate snapshot": "workflow.runDetail.securityGate",
  };
  if (detail === displayText(context.current_step_id, "")) {
    return localizedStepDetail(context, t);
  }
  return map[detail] ? t(map[detail]) : detail;
}

function workflowRunReferenceLabel(value, t) {
  const key = displayText(value, "");
  const map = {
    "CI evidence": "workflow.reference.ci",
    "Git sync evidence": "workflow.reference.gitSync",
    "Product authority": "workflow.reference.productAuthority",
    "Security gate": "workflow.reference.securityGate",
    "Selected context": "workflow.reference.selectedContext",
  };
  return map[key] ? t(map[key]) : displayText(value, t("summary.viewDetails"));
}

function workflowDecisionValueLines(context, t) {
  const workflowText = t("detail.workflow.checks");
  if (workflowText === "開発を進めてよい Git/CI 状態かを判断します。") {
    return ["開発を進めてよい", "Git/CI 状態かを判断します。"];
  }
  if (workflowText === "Whether Git/CI is ready to continue") {
    return ["Whether Git/CI is ready", "to continue"];
  }
  return [workflowText || workflowContextLabel(context.workflow_context, t)];
}

function workflowMustReviewPoints(t) {
  return [
    t("detail.workflow.mustReview.gitSync"),
    t("detail.workflow.mustReview.ci"),
    t("detail.workflow.mustReview.prMerge"),
    t("detail.workflow.mustReview.evidence"),
  ];
}

function maintenanceStatusLabel(id, status, t) {
  const state = normalizeState(status);
  if (state === "unknown" || state === "manual_required" || state === "optional" || state === "cached") {
    return t("maintenance.status.unconfirmed");
  }
  if (state === "blocked" || state === "missing" || state === "not_run") {
    return t("maintenance.status.notCollected");
  }
  if (state === "failed" || state === "stale") {
    return statusLabelForChip(status, t);
  }
  const labels = {
    as_built_sync_status: "maintenance.status.synced",
    workflow_pair_status: "maintenance.status.synced",
    developer_memory_status: "maintenance.status.recorded",
    skills_status: "maintenance.status.normal",
    git_workflow_settings: "maintenance.status.enabled",
    security_policy: "maintenance.status.compliant",
    dashboard_data_schema: "maintenance.status.normal",
    product_authority_evidence: "maintenance.status.notCollected",
  };
  return t(labels[id] || "maintenance.status.ready", statusLabelForChip(status, t));
}

function maintenanceCardCopy(id, t) {
  const map = {
    as_built_sync_status: "maintenance.card.asBuilt",
    workflow_pair_status: "maintenance.card.workflowPair",
    developer_memory_status: "maintenance.card.developerMemory",
    skills_status: "maintenance.card.skills",
    git_workflow_settings: "maintenance.card.gitWorkflowSettings",
    security_policy: "maintenance.card.securityPolicy",
  };
  return t(map[id] || "maintenance.note.default");
}

function maintenanceEvidenceLabel(row, t) {
  const id = displayText(row?.id, "");
  return t(`maintenance.evidenceLabel.${id}`, displayText(row?.label));
}

function maintenanceReferenceValues(row) {
  const id = displayText(row?.id, "");
  if (id === "workflow_pair") {
    return ["docs/workflow/TASK_TRACKER.md", "docs/workflow/HANDOFF.md"];
  }
  return [displayText(row?.reference, "")].filter(Boolean);
}

function maintenanceReviewPoints(t) {
  return [
    t("maintenance.review.asBuilt"),
    t("maintenance.review.workflowPair"),
    t("maintenance.review.developerMemory"),
    t("maintenance.review.evidence"),
  ];
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
  if (aggregateLessonSettingsStatus(lesson) === "ready") {
    return t("lesson.live.settingsDetail");
  }
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
  return identity ? t("lesson.live.dashboardDisplayDetail") : stateDetail("unknown", t);
}

function gitCiLiveStatus(context, t) {
  const gitState = normalizeState(context.git_status);
  const ciState = normalizeState(context.ci_status);
  if (gitState === "manual_required" && ciState === "manual_required") {
    return {
      status: t("lesson.live.gitCiNeedsReview"),
      detail: t("lesson.live.gitCiNeedsReviewDetail"),
    };
  }
  if (gitState === ciState) {
    return {
      status: statusLabelForChip(gitState, t),
      detail: t("lesson.live.gitCiDetail"),
    };
  }
  return {
    status: `${t("lesson.live.gitLabel")}: ${statusLabelForChip(gitState, t)} / ${t("lesson.live.ciLabel")}: ${statusLabelForChip(ciState, t)}`,
    detail: t("lesson.live.gitCiDetail"),
  };
}

function securityGateDetail(security, failures, t) {
  const firstFailure = failures[0];
  if (firstFailure?.reason) {
    return localizedSecurityDetail(firstFailure.reason, t);
  }
  const state = normalizeState(security?.gate_status);
  if (isReviewState(state)) {
    return stateDetail(state, t);
  }
  return t("security.card.gateReady");
}

function localizedSecurityDetail(detail, t) {
  const text = displayText(detail, "");
  const detailKeys = {
    "Dangerous operations require explicit approval before execution.": "security.detail.dangerousApprovalRequired",
    "Push, PR, and merge approval states are tracked separately.": "security.detail.gitWorkflowApprovalTracked",
    "Merge is gated and must stay outside the dashboard UI.": "security.detail.mergeGated",
    "Cleanup is preview-only until an explicit external approval path is used.": "security.detail.cleanupApprovalRequired",
  };
  return detailKeys[text] ? t(detailKeys[text]) : text;
}

function securityApprovalDetail(approval, fallbackState, t) {
  const id = displayText(approval?.id, "");
  const idKeys = {
    dangerous_action_approval: "security.detail.dangerousApprovalRequired",
    git_workflow_approval: "security.detail.gitWorkflowApprovalTracked",
  };
  if (idKeys[id]) {
    return t(idKeys[id]);
  }
  if (approval?.detail) {
    return localizedSecurityDetail(approval.detail, t);
  }
  return stateDetail(fallbackState, t);
}

function securityDangerousOperationDetail(operation, t) {
  const id = displayText(operation?.id, "");
  const idKeys = {
    merge: "security.detail.mergeGated",
    cleanup: "security.detail.cleanupApprovalRequired",
  };
  if (idKeys[id]) {
    return t(idKeys[id]);
  }
  if (operation?.detail) {
    return localizedSecurityDetail(operation.detail, t);
  }
  return t("security.card.dangerousNone");
}

function securityPartialDetail(failures, t) {
  if (failures.length) {
    return localizedSecurityDetail(failures[0].reason, t);
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

function lessonSummaryLines(text) {
  const value = displayText(text, "");
  if (!value) {
    return [];
  }
  if (value.includes("、")) {
    const [first, ...rest] = value.split("、");
    return [`${first}、`, rest.join("、")].filter(Boolean);
  }
  if (value.includes(" Git/CI ")) {
    return value.replace(" Git/CI ", "\nGit/CI ").split("\n");
  }
  if (value.includes(" and what ")) {
    return value.replace(" and what ", "\nand what ").split("\n");
  }
  return [value];
}

function DetailDecisionSummary({ tone, items, t }) {
  return (
    <section className={`decision-summary decision-summary--${tone}`} aria-label={t("detail.summaryAria")}>
      {items.map(({ Icon, label, value, valueLines, detail, points = [], badge, cta, tone: itemTone }) => (
        <article className={itemTone ? `decision-summary__item decision-summary__item--${itemTone}` : "decision-summary__item"} key={label}>
          <span className="decision-summary__icon">
            <Icon aria-hidden="true" size={24} />
          </span>
          <div>
            <span>{label}</span>
            {valueLines?.length ? (
              <p className="decision-summary__value-lines">
                {valueLines.map((line, index) => (
                  <span key={`${displayText(line)}-${index}`}>{line}</span>
                ))}
              </p>
            ) : displayText(value, "") ? (
              <strong>{value}</strong>
            ) : null}
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
  const selectedLessonProgress = contextProgress(context, lessonMetric);

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
          metric={{ percent: selectedLessonProgress.percent, status: lessonMetric.status }}
          value={`${selectedLessonProgress.completed} / ${selectedLessonProgress.total}`}
          detail={`${selectedLessonProgress.percent}%`}
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

function hasReviewState(value) {
  return value !== undefined && value !== null && value !== "" && isReviewState(value);
}

function lessonPrimaryAttentionText(lesson, t) {
  if (hasReviewState(lesson.learning_mode_status)) {
    return t("detail.lesson.learningModeMissing");
  }
  if (hasReviewState(lesson.workflow_language_status)) {
    return t("detail.lesson.workflowLanguageMissing");
  }
  if (hasReviewState(lesson.product_language_status)) {
    return t("detail.lesson.productLanguageMissing");
  }
  if (hasReviewState(lesson.learner_approval_status)) {
    return t("detail.lesson.learnerApprovalRequired");
  }
  if (hasReviewState(lesson.status)) {
    return t("detail.lesson.stateMissing");
  }
  return t("detail.lesson.warningCallout");
}

function lessonAttentionDetailText(lesson, t) {
  if (hasReviewState(lesson.learner_approval_status)) {
    return t("detail.lesson.reviewApproval");
  }
  return t("detail.lesson.reviewSettings");
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

function CommandPreviewCommand({ command, t }) {
  const text = displayText(command, "");
  if (!text) {
    return null;
  }
  return (
    <span className="command-preview__command-chip" tabIndex={0} data-tooltip={text}>
      <code className="command-chip command-chip--preview">
        <span>{text}</span>
      </code>
      <button className="command-preview__command-copy" type="button" aria-label={`${t("app.copyItem")}: ${text}`} title={t("app.copyItem")} onClick={() => copyTextToClipboard(text)}>
        <Copy aria-hidden="true" size={14} />
      </button>
    </span>
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

function LessonHealthNotice({ t }) {
  return (
    <div className="mock-notice mock-notice--lessons-warning lesson-health-notice">
      <AlertTriangle aria-hidden="true" size={18} />
      <div>
        <strong>{t("lesson.healthWarning")}</strong>
      </div>
      <a className="mock-notice__button lesson-health-notice__button" href="#maintenance">
        {t("lesson.healthWarningCta")}
        <ChevronRight aria-hidden="true" size={16} />
      </a>
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
            <span>{lessonAttentionDetailText(lesson, t)}</span>
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
  const applied = entries.find(([id]) => id.includes("advanced") || id.includes("applied")) || ["advanced", lessons?.advanced || {}];
  const selected = displayText(selectedContextData(data).menu_id, "step_1_14");
  const metric = data.summary?.category_metrics?.lessons || {};
  return [
    { id: "step_1_7", sourceId: foundation[0], lesson: foundation[1] || {}, title: t("lesson.card.step7"), tone: "warning", selected: selected === "step_1_7" },
    { id: "step_1_14", sourceId: practical[0], lesson: practical[1] || {}, title: t("lesson.card.step14"), tone: "active", selected: selected === "step_1_14" },
    { id: "advanced", sourceId: applied[0], lesson: applied[1] || {}, title: t("lesson.card.advanced"), tone: "advanced", selected: selected === "advanced" },
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
  const progress = contextProgress(card.selected ? context : cardContext, card.selected ? metric : {});
  const total = progress.total || (normalizeState(card.lesson.status) === "passed" ? progress.total : 0);
  const completed = progress.total ? progress.completed : normalizeState(card.lesson.status) === "passed" ? total : 0;
  const percent = progress.total ? progress.percent : card.percent;
  const currentParts = card.selected ? selectedStepParts(context) : selectedStepParts(cardContext);
  const current = card.selected ? selectedStepText(context) : displayText(card.lesson.current_step || currentParts.id || currentParts.short, "");
  const currentId = displayText(card.selected ? context.current_step_id : cardContext.current_step_id, "");
  const currentDetail = card.selected ? localizedStepDetail(context, t) : displayText(cardContext.current_step_label || card.lesson.current_step, "");
  const nextAction = card.selected
    ? nextActionShort(context, data, t)
    : localizedLessonAction(card.lesson.next_learning_action || card.lesson.next_action || t("detail.lesson.reviewSettings"), cardContext, t);
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
            <strong>{lessonPrimaryAttentionText(card.lesson, t)}</strong>
            <span>{lessonAttentionDetailText(card.lesson, t)}</span>
          </div>
          <ChevronRight aria-hidden="true" size={16} />
        </div>
      ) : null}
      <div className="lesson-progress-card__progress">
        <span>{t("mock.context.progress")}: <AnimatedNumber value={completed} className="lesson-progress-card__progress-number" /> / {total}</span>
        <strong><AnimatedNumber value={percent} className="lesson-progress-card__percent-number" />%</strong>
        <HorizontalProgress percent={percent} />
      </div>
      {card.selected && currentId ? (
        <p className="lesson-progress-card__step">
          <strong>{t("lesson.card.currentStep")}</strong>
          <code>{currentId}</code>
          {currentDetail ? <span>{currentDetail}</span> : null}
        </p>
      ) : (
        <p><strong>{t("mock.context.current")}</strong> {current}</p>
      )}
      <p><strong>{t("lesson.nextLearningAction")}</strong> {nextAction}</p>
    </article>
  );
}

function LessonLiveStatusTable({ data, t }) {
  const context = selectedContextData(data);
  const metric = data.summary?.category_metrics?.lessons || {};
  const progress = contextProgress(context, metric);
  const lesson = selectedLessonObject(data, context);
  const generated = data.generated_at ? formatDashboardDateTime(data.generated_at) : t("app.snapshot");
  const settingsStatus = aggregateLessonSettingsStatus(lesson);
  const repositoryStatus = repositoryPathStateToStatus(context.target_repository?.path_state);
  const reflectionStatus = dashboardReflectionStatus(data);
  const progressStatus = progress.total && progress.completed >= progress.total ? t("detail.lesson.completed") : t("detail.lesson.inProgress");
  const gitCiStatus = gitCiLiveStatus(context, t);
  const rows = [
    { id: "lesson-progress", Icon: FileCheck2, item: t("lesson.live.progress"), status: `${progressStatus} (${t("lesson.live.live")})`, statusTone: "blue", detail: `${contextLabel(context.menu_id, t)} / ${selectedStepShort(context)}` },
    { id: "settings", Icon: Settings, item: t("lesson.live.settings"), status: statusLabelForChip(settingsStatus, t), detail: lessonSettingsDetail(lesson, t) },
    { id: "repository", Icon: Database, item: t("lesson.live.repository"), status: statusLabelForChip(repositoryStatus, t), detail: `${displayText(context.target_repository?.name)} (${t("lesson.live.productRepositoryLabel")})` },
    { id: "git-ci", Icon: RefreshCw, item: t("lesson.live.gitCi"), status: gitCiStatus.status, detail: gitCiStatus.detail },
    { id: "dashboard", Icon: FileJson, item: t("lesson.live.dashboard"), status: reflectionStatus === "passed" ? t("lesson.live.dashboardShowing") : statusLabelForChip(reflectionStatus, t), statusTone: reflectionStatus === "passed" ? "" : "orange", detail: dashboardReflectionDetail(data, t) },
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
        {rows.map(({ id, Icon, item, status, statusTone = "green", detail }) => (
          <article className="lesson-live-row" key={id}>
            <span className="lesson-live-row__item"><Icon aria-hidden="true" size={19} />{item}</span>
            <span className={`lesson-live-row__status lesson-live-row__status--${statusTone}`}>{status}</span>
            <span>{detail}</span>
            <span>{generated}</span>
          </article>
        ))}
      </div>
    </section>
  );
}

function LessonSection({ lessons, data, locale, t }) {
  const context = selectedContextData(data);
  const metric = data.summary?.category_metrics?.lessons || {};
  const progress = contextProgress(context, metric);
  const isComplete = progress.total > 0 && progress.completed >= progress.total;
  const lessonCards = resolveLessonCards(lessons, data, t);
  return (
    <section className="view-surface view-surface--lessons" id="lessons" aria-labelledby="lesson-heading">
      <PageTitleHeader viewId="lessons" Icon={BookOpen} title={t("lessons.title")} subtitle={t("lessons.description")} data={data} locale={locale} t={t} actionLabel={t("lesson.snapshotButton")} headingId="lesson-heading" />
      <ContextSnapshotStrip data={data} t={t} locale={locale} variant="lessons" />
      <DetailDecisionSummary
        tone="lessons"
        t={t}
        items={[
          { Icon: Target, label: t("detail.checks"), valueLines: lessonSummaryLines(t("detail.lessons.checks")) },
          { Icon: CheckCircle2, label: t("detail.currentJudgment"), value: isComplete ? t("detail.lesson.completed") : t("detail.lesson.inProgress"), detail: progress.total ? `${progress.completed} of ${progress.total} completed` : metricStatusText(metric, t), tone: "progress" },
          { Icon: Eye, label: t("detail.mustReview"), points: [t("detail.lessons.review.currentStep"), t("detail.lessons.review.nextAction"), t("detail.lessons.review.unsyncedWarnings")] },
          { Icon: ArrowRightCircle, label: t("detail.nextSafeCheck"), valueLines: lessonSummaryLines(t("detail.lessons.nextWorkflowCheck")) },
        ]}
      />
      <div className="lesson-grid">
        {lessonCards.map((card) => (
          <LessonProgressCard card={card} data={data} key={card.id} t={t} />
        ))}
      </div>
      <LessonLiveStatusTable data={data} t={t} />
      <LessonHealthNotice t={t} />
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
  const context = selectedContextData(data);
  const step = currentStepNumber(context);
  return (
    <section className="view-surface view-surface--workflow" id="workflow" aria-labelledby="workflow-heading">
      <PageTitleHeader viewId="workflow" Icon={WorkflowCategoryIcon} title={t("workflow.title")} subtitle={t("workflow.description")} data={data} locale={locale} t={t} actionLabel={t("detail.refreshDisplayOnly")} headingId="workflow-heading" />
      <ContextSnapshotStrip data={data} t={t} locale={locale} variant="workflow" />
      <DetailDecisionSummary
        tone="workflow"
        t={t}
        items={[
          { Icon: Target, label: t("detail.checks"), valueLines: workflowDecisionValueLines(context, t), points: [t("detail.workflow.checksPoint.gitCi"), t("detail.workflow.checksPoint.prMerge"), t("detail.workflow.checksPoint.evidence")] },
          { Icon: CheckCircle2, label: t("detail.currentJudgment"), value: reviewItems.length ? t("detail.judgment.needsReviewShort") : t("detail.judgment.readyShort"), detail: reviewItems.length ? t("detail.workflow.reviewDetail") : t("detail.workflow.noReviewDetail"), badge: statusSummaryBadge(reviewItems.length, t("detail.itemsNeedReview"), t), tone: reviewItems.length ? "warning" : "ready" },
          { Icon: Eye, label: t("detail.mustReview"), value: t("detail.workflow.mustReview"), points: reviewItems.length ? workflowMustReviewPoints(t) : [t("detail.noRequiredReview")] },
          { Icon: ArrowRightCircle, label: t("detail.nextSafeCheck"), value: step ? `${t("workflow.card.stepLabel")} ${step} ${t("detail.workflow.nextSafe")}` : t("detail.workflow.nextSafe"), detail: nextActionShort(context, data, t), cta: { href: "#lessons", label: workflowStepDetailLabel(context, t) } },
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
    { id: "as_built_sync_status", title: t("maintenance.item.asBuilt"), Icon: RefreshCw, status: maintenance.as_built_sync_status, detail: maintenanceCardCopy("as_built_sync_status", t) },
    { id: "workflow_pair_status", title: t("maintenance.item.workflowPair"), Icon: Waypoints, status: maintenance.workflow_pair_status, detail: maintenanceCardCopy("workflow_pair_status", t) },
    { id: "developer_memory_status", title: t("maintenance.item.developerMemory"), Icon: Brain, status: maintenance.developer_memory_status, detail: maintenanceCardCopy("developer_memory_status", t) },
    { id: "skills_status", title: t("maintenance.item.skills"), Icon: BookOpen, status: maintenance.skills_status, detail: maintenanceCardCopy("skills_status", t) },
    { id: "git_workflow_settings", title: t("maintenance.item.gitWorkflowSettings"), Icon: GitBranch, status: data.git_workflow?.settings_status, detail: maintenanceCardCopy("git_workflow_settings", t) },
    { id: "security_policy", title: t("maintenance.item.securityPolicy"), Icon: ShieldCheck, status: data.security?.policy_status, detail: maintenanceCardCopy("security_policy", t) },
  ];
  return (
    <section className="maintenance-card-grid" aria-label={t("maintenance.statusCards")}>
      {cards.map(({ id, title, Icon, status, detail }) => (
        <article className="maintenance-mini-card" key={id}>
          <span className="maintenance-mini-card__icon">
            <Icon aria-hidden="true" size={24} />
          </span>
          <h3>{title}</h3>
          <StatusPill value={status} t={t} label={maintenanceStatusLabel(id, status, t)} />
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
          { Icon: Scale, label: t("detail.currentJudgment"), value: reviewCount ? t("detail.maintenance.usableWithFollowup") : t("detail.judgment.readyShort"), detail: t("detail.maintenance.reviewDetail"), tone: reviewCount ? "warning" : "ready" },
          { Icon: Eye, label: t("detail.mustReview"), points: maintenanceReviewPoints(t) },
          { Icon: ArrowRightCircle, label: t("detail.nextSafeCheck"), value: t("detail.maintenance.nextSafe"), detail: t("detail.maintenance.nextSafeDetail") },
        ]}
      />
      <MaintenanceStatusCards maintenance={maintenance} data={data} t={t} />
      <EvidenceRowsTable rows={maintenance.evidence_rows} t={t} />
      <SourceBoundary data={data} t={t} />
      <MockNotice
        tone="maintenance-warning"
        Icon={Info}
        title={t("maintenance.warning.title")}
        detail={t("maintenance.warning.detail")}
        cta={{ href: "#evidence-table-heading", label: t("maintenance.warning.cta") }}
      />
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
            <div className="failure-row__empty-message">
              <strong>{t("summary.none")}</strong>
              <span>{t("detail.security.noFailures")}</span>
            </div>
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
          { Icon: FileSearch, label: t("detail.mustReview"), points: [t("summary.partialFailures"), t("security.item.approval"), t("actions.title")] },
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
            <CommandPreviewCommand command={preview.command_text} t={t} />
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
      <MockNotice
        tone="safety-warning"
        Icon={ShieldAlert}
        title={t("security.warning.title")}
        detail={t("security.warning.detail")}
        cta={{ href: "#action-heading", label: t("security.warning.cta") }}
      />
    </>
  );
}

function SidebarReferenceChip({ value, t }) {
  const text = displayText(value, "");
  if (!text) {
    return null;
  }
  return (
    <span className="sidebar-reference-chip" tabIndex={0} data-tooltip={text}>
      {technicalChip(text)}
      <button className="sidebar-reference-chip__copy" type="button" aria-label={`${t("app.copyItem")}: ${text}`} title={t("app.copyItem")} onClick={() => copyTextToClipboard(text)}>
        <Copy aria-hidden="true" size={14} />
      </button>
    </span>
  );
}

function SidebarPageCard({ Icon, title, detail, status, t, children, className = "" }) {
  return (
    <article className={`sidebar-page-card ${className}`.trim()}>
      <div className="sidebar-page-card__head">
        <span className="sidebar-page-card__icon">
          <Icon aria-hidden="true" size={22} />
        </span>
        <div>
          <h3>{title}</h3>
          {detail ? <p>{detail}</p> : null}
        </div>
        {status ? <StatusPill value={status} t={t} label={statusLabelForChip(status, t)} /> : null}
      </div>
      {children ? <div className="sidebar-page-card__body">{children}</div> : null}
    </article>
  );
}

function SidebarPageLinkCard({ Icon, title, detail, href }) {
  return (
    <a className="sidebar-page-link-card" href={href}>
      <span className="sidebar-page-link-card__icon">
        <Icon aria-hidden="true" size={22} />
      </span>
      <span>
        <strong>{title}</strong>
        <small>{detail}</small>
      </span>
      <ArrowRightCircle aria-hidden="true" size={17} />
    </a>
  );
}

function documentStatusFor(documentId, data) {
  const maintenance = data.maintenance || {};
  const developmentDocumentsStatus = valueState(data.development?.documents || "manual_required");
  if (documentId === "taskTracker" || documentId === "handoff") {
    return valueState(maintenanceEvidenceRow(maintenance, ["workflow_pair"]) || maintenance.workflow_pair_status || "manual_required");
  }
  if (documentId === "developerMemory") {
    return valueState(maintenanceEvidenceRow(maintenance, ["developer_memory"]) || maintenance.developer_memory_status || "manual_required");
  }
  if (documentId === "dashboardDataSchema") {
    return valueState(maintenanceEvidenceRow(maintenance, ["dashboard_data_schema"]) || "manual_required");
  }
  if (documentId === "securityPolicy") {
    return valueState(maintenanceEvidenceRow(maintenance, ["security_policy"]) || data.security?.policy_status || "manual_required");
  }
  return developmentDocumentsStatus;
}

function repositoryFileRoleKey(value) {
  return displayText(value, "generic").replace(/[^A-Za-z0-9]+/g, "_").replace(/^_+|_+$/g, "") || "generic";
}

function repositoryFileRoleLabel(row, t) {
  const pathDescription = t(`repositoryInfo.pathDescription.${repositoryFileRoleKey(row.path)}`, "");
  if (pathDescription) {
    return pathDescription;
  }
  const description = displayText(row.description, "");
  if (description) {
    return description;
  }
  const roles = row.roles && typeof row.roles === "object" && !Array.isArray(row.roles) ? row.roles : {};
  for (const roleId of asArray(row.role_ids)) {
    const normalizedRoleId = displayText(roleId, "");
    if (!normalizedRoleId) {
      continue;
    }
    const translatedRole = t(`repositoryInfo.fileRoleId.${normalizedRoleId}`, "");
    if (translatedRole) {
      return translatedRole;
    }
    const role = roles[normalizedRoleId];
    if (!role || typeof role !== "object" || Array.isArray(role)) {
      continue;
    }
    const description = displayText(role.description, "");
    if (description) {
      return description;
    }
    const label = displayText(role.label, "");
    if (label) {
      return label;
    }
  }
  const sourceId = displayText(row.source_id || row.id, "");
  const path = displayText(row.path, "");
  const key = repositoryFileRoleKey(sourceId || path);
  if (path.includes("DASHBOARD_DATA_SCHEMA")) {
    return t("repositoryInfo.fileRole.dashboardDataSchema");
  }
  if (path.includes("LESSON_STATE")) {
    return t("repositoryInfo.fileRole.lessonState");
  }
  if (path.includes("PRODUCT_GATE_EVIDENCE_SCHEMA")) {
    return t("repositoryInfo.fileRole.productEvidence");
  }
  if (path.includes("docs/product/REQUIREMENTS")) {
    return t("repositoryInfo.fileRole.productRequirements");
  }
  if (path.includes("TASK_TRACKER")) {
    return t("repositoryInfo.fileRole.taskTracker");
  }
  if (path.includes("HANDOFF")) {
    return t("repositoryInfo.fileRole.handoff");
  }
  return t(`repositoryInfo.fileRole.${key}`, t("repositoryInfo.fileRole.generic"));
}

function repositoryNodeTooltip(node, t) {
  const item = node.file || {
    path: node.path,
    type: node.type,
    source_id: node.type === "directory" ? "repository_directory" : "repository_file",
    role_ids: [node.type === "directory" ? "repository_directory" : "repository_file"],
  };
  return repositoryFileRoleLabel(item, t);
}

function repositoryFileRows(data, authority) {
  const repositoryIndex = authority?.repository_index || {};
  const indexedRows = asArray(repositoryIndex.files)
    .map((item) => {
      const path = displayText(item?.path, "");
      if (!path) {
        return null;
      }
      const roleIds = asArray(item.role_ids).map((roleId) => displayText(roleId, "")).filter(Boolean);
      return {
        id: `repository-index:${path}`,
        path,
        source_id: roleIds[0] || "repository_file",
        status: normalizeState(repositoryIndex.status || "unknown"),
        required: item.tracked !== false,
        type: item.type === "directory" ? "directory" : "file",
        description: displayText(item.description, ""),
        role_ids: roleIds,
        roles: repositoryIndex.roles || {},
      };
    })
    .filter(Boolean);
  if (indexedRows.length) {
    return indexedRows;
  }

  const rows = [];
  for (const item of asArray(authority?.document_paths)) {
    const path = displayText(item.resolved_path || item.canonical_path, "");
    if (!path) {
      continue;
    }
    rows.push({
      id: displayText(item.source_id || path),
      path,
      source_id: item.source_id,
      status: item.status || "unknown",
      required: item.required_in_context,
    });
  }
  for (const row of asArray(data.maintenance?.evidence_rows)) {
    const path = displayText(row.reference, "");
    if (!path) {
      continue;
    }
    rows.push({
      id: displayText(row.id || path),
      path,
      source_id: row.id,
      status: row.status || "unknown",
      required: displayText(row.importance, "") === "required",
    });
  }
  for (const path of asArray(data.source_files)) {
    rows.push({
      id: `source:${displayText(path)}`,
      path: displayText(path),
      status: "ready",
      required: true,
    });
  }
  const seen = new Set();
  return rows.filter((row) => {
    const path = displayText(row.path, "");
    if (!path || seen.has(path)) {
      return false;
    }
    seen.add(path);
    return true;
  });
}

function repositoryBuildFileTree(rows) {
  const root = { id: "", name: "", path: "", type: "directory", children: [], childMap: new Map(), file: null };
  for (const row of rows) {
    const segments = displayText(row.path, "").split(/[\\/]/).filter(Boolean);
    const rowType = row.type === "directory" ? "directory" : "file";
    let node = root;
    let currentPath = "";
    for (const [index, segment] of segments.entries()) {
      currentPath = currentPath ? `${currentPath}/${segment}` : segment;
      if (!node.childMap.has(segment)) {
        const isLast = index === segments.length - 1;
        const child = { id: currentPath, name: segment, path: currentPath, type: isLast ? rowType : "directory", children: [], childMap: new Map(), file: null };
        node.childMap.set(segment, child);
        node.children.push(child);
      }
      node = node.childMap.get(segment);
      if (index < segments.length - 1 || rowType === "directory") {
        node.type = "directory";
      }
    }
    node.file = row;
    node.type = rowType;
  }

  function finalize(node) {
    node.children = node.children
      .map(finalize)
      .sort((left, right) => {
        const leftIsDirectory = left.type === "directory" || left.children.length > 0;
        const rightIsDirectory = right.type === "directory" || right.children.length > 0;
        if (leftIsDirectory !== rightIsDirectory) {
          return leftIsDirectory ? -1 : 1;
        }
        return left.name.localeCompare(right.name);
      });
    delete node.childMap;
    return node;
  }

  return finalize(root).children;
}

function repositoryCollectDirectoryIds(nodes) {
  const ids = [];
  for (const node of nodes) {
    if (node.type === "directory" || node.children.length) {
      ids.push(node.id, ...repositoryCollectDirectoryIds(node.children));
    }
  }
  return ids;
}

function repositoryCollectDirectoryIdsByDepth(nodes, maxDepth, level = 0) {
  if (maxDepth <= 0) {
    return [];
  }
  const ids = [];
  for (const node of nodes) {
    const isDirectory = node.type === "directory" || node.children.length > 0;
    if (!isDirectory) {
      continue;
    }
    if (level < maxDepth) {
      ids.push(node.id);
      ids.push(...repositoryCollectDirectoryIdsByDepth(node.children, maxDepth, level + 1));
    }
  }
  return ids;
}

function RepositoryFileTreeNode({ node, level, expandedIds, onToggle, t }) {
  const isDirectory = node.type === "directory" || node.children.length > 0;
  const isExpanded = expandedIds.has(node.id);
  const tooltip = repositoryNodeTooltip(node, t);
  if (isDirectory) {
    return (
      <li className="repository-file-tree__item">
        <button className="repository-file-tree__node repository-file-tree__node--directory" type="button" aria-expanded={isExpanded} data-tooltip={tooltip} onClick={() => onToggle(node.id)} style={{ "--tree-level": level }}>
          <ChevronRight aria-hidden="true" size={16} />
          <Folder aria-hidden="true" size={18} />
          <strong>{node.name}</strong>
          <small>{node.children.length}</small>
        </button>
        {isExpanded ? (
          <ul className="repository-file-tree__children">
            {node.children.map((child) => (
              <RepositoryFileTreeNode node={child} level={level + 1} expandedIds={expandedIds} onToggle={onToggle} t={t} key={child.id} />
            ))}
          </ul>
        ) : null}
      </li>
    );
  }

  const file = node.file || {};
  return (
    <li className="repository-file-tree__item">
      <div className="repository-file-tree__node repository-file-tree__node--file" tabIndex={0} data-tooltip={tooltip} style={{ "--tree-level": level }}>
        <FileText aria-hidden="true" size={18} />
        <div>
          <strong title={displayText(file.path || node.path)}>{node.name}</strong>
        </div>
        <StatusPill value={file.status || "unknown"} t={t} label={statusLabelForChip(file.status || "unknown", t)} />
      </div>
    </li>
  );
}

function RepositoryFileTree({ rows, t, defaultExpandDepth = 0 }) {
  const tree = useMemo(() => repositoryBuildFileTree(rows), [rows]);
  const directoryIds = useMemo(() => repositoryCollectDirectoryIds(tree), [tree]);
  const rowsKey = useMemo(() => rows.map((row) => `${displayText(row.type, "file")}:${displayText(row.path, "")}`).join("\n"), [rows]);
  const [expandedIds, setExpandedIds] = useState(() => new Set());

  useEffect(() => {
    const defaultExpandedIds = repositoryCollectDirectoryIdsByDepth(tree, defaultExpandDepth);
    setExpandedIds(new Set(defaultExpandedIds));
  }, [rowsKey, defaultExpandDepth]);

  if (!rows.length) {
    return <p className="repository-empty-note">{t("repositoryInfo.fileMapEmpty")}</p>;
  }

  const toggle = (id) => {
    setExpandedIds((current) => {
      const next = new Set(current);
      if (next.has(id)) {
        next.delete(id);
      } else {
        next.add(id);
      }
      return next;
    });
  };

  return (
    <div className="repository-file-tree-panel">
      <div className="repository-file-tree-panel__toolbar">
        <span>{t("repositoryInfo.fileMapDetail")}</span>
        <div>
          <button type="button" onClick={() => setExpandedIds(new Set(directoryIds))}>{t("repositoryInfo.expandAll")}</button>
          <button type="button" onClick={() => setExpandedIds(new Set())}>{t("repositoryInfo.collapseAll")}</button>
        </div>
      </div>
      <p className="repository-file-tree-panel__note">
        <Info aria-hidden="true" size={14} />
        <span>{t("repositoryInfo.fileMapFilteredNote")}</span>
      </p>
      <ul className="repository-file-tree" aria-label={t("repositoryInfo.fileMapTitle")}>
        {tree.map((node) => (
          <RepositoryFileTreeNode node={node} level={0} expandedIds={expandedIds} onToggle={toggle} t={t} key={node.id} />
        ))}
      </ul>
    </div>
  );
}

function repositoryOperationDetail(row, t) {
  const detail = displayText(row.detail, "");
  const map = {
    "Push policy is configured.": "repositoryInfo.gitDetail.pushConfigured",
    "Pull request creation follows the configured workflow.": "repositoryInfo.gitDetail.prConfigured",
    "Pull request creation follows the configured Git workflow.": "repositoryInfo.gitDetail.prConfigured",
    "CI evidence is optional in this fixture.": "repositoryInfo.gitDetail.ciOptional",
    "PR CI status is evidence-backed or manual-required.": "repositoryInfo.gitDetail.prCiEvidence",
    "Main CI is display-only evidence.": "repositoryInfo.gitDetail.mainCiEvidence",
    "Main CI status is evidence-backed or manual-required.": "repositoryInfo.gitDetail.mainCiEvidence",
    "Git sync has not been refreshed by a live check.": "repositoryInfo.gitDetail.syncNotRefreshed",
    "Merge remains approval-gated.": "repositoryInfo.gitDetail.mergeGated",
    "Merge remains gated by approval policy.": "repositoryInfo.gitDetail.mergeGated",
  };
  return map[detail] ? t(map[detail]) : detail;
}

function repositoryOperationRows(operations, t) {
  const rows = asArray(operations);
  const hasCommit = rows.some((row) => displayText(row.id) === "commit");
  const commitRow = {
    id: "commit",
    label: t("repositoryInfo.git.commit"),
    status: "manual_required",
    mode: "manual",
    detail: t("repositoryInfo.gitDetail.commitNotCollected"),
  };
  return hasCommit ? rows : [commitRow, ...rows];
}

function RepositoryGitFlow({ operations, t }) {
  const rows = repositoryOperationRows(operations, t);
  if (!rows.length) {
    return <p className="repository-empty-note">{t("repositoryInfo.gitFlowEmpty")}</p>;
  }
  return (
    <div className="repository-operation-grid">
      {rows.map((row) => {
        const Icon = gitOperationIcon(row.id);
        const mode = displayText(row.mode, "auto");
        return (
          <article className="repository-operation-card" key={displayText(row.id)}>
            <span className="repository-operation-card__icon">
              <Icon aria-hidden="true" size={20} />
            </span>
            <div>
              <strong>{gitOperationDisplayLabel(row.id, row.label, t)}</strong>
              <p>{repositoryOperationDetail(row, t)}</p>
            </div>
            <div className="repository-operation-card__meta">
              <StatusPill value={row.status} t={t} label={workflowStatusLabel(row.status, t)} />
              <span className={`mode-pill mode-pill--${mode}`}>{gitOperationModeLabel(row.mode, t)}</span>
            </div>
          </article>
        );
      })}
    </div>
  );
}

function RepositoryRunEvidence({ rows, data, t }) {
  const context = selectedContextData(data);
  const visibleRows = asArray(rows).slice(0, 6);
  if (!visibleRows.length) {
    return <p className="repository-empty-note">{t("repositoryInfo.runEvidenceEmpty")}</p>;
  }
  return (
    <div className="repository-run-list">
      {visibleRows.map((row) => (
        <article className="repository-run-row" key={displayText(row.id)}>
          <span>{formatDashboardDateTime(row.time) || displayText(row.time)}</span>
          <strong>{workflowRunTypeLabel(row.type, t)}</strong>
          <p>{workflowRunDetail(row, context, t)}</p>
          <small>{displayText(row.target)}</small>
          <StatusPill value={row.status} t={t} label={workflowStatusLabel(row.status, t)} />
        </article>
      ))}
    </div>
  );
}

function RepositoryWorkspaceSnapshot({ t }) {
  const items = [
    { id: "branch", Icon: GitBranch, title: t("repositoryInfo.workspace.branch"), detail: t("repositoryInfo.workspace.branchDetail") },
    { id: "worktree", Icon: Folder, title: t("repositoryInfo.workspace.worktree"), detail: t("repositoryInfo.workspace.worktreeDetail") },
    { id: "cleanup", Icon: Wrench, title: t("repositoryInfo.workspace.cleanup"), detail: t("repositoryInfo.workspace.cleanupDetail") },
  ];
  return (
    <div className="repository-workspace-grid">
      {items.map(({ id, Icon, title, detail }) => (
        <article className="repository-workspace-card" key={id}>
          <span className="repository-workspace-card__icon">
            <Icon aria-hidden="true" size={20} />
          </span>
          <div>
            <strong>{title}</strong>
            <p>{detail}</p>
          </div>
          <StatusPill value="manual_required" t={t} label={t("repositoryInfo.notCollected")} />
        </article>
      ))}
    </div>
  );
}

function RepositoryRelatedLinks({ t }) {
  const links = [
    { Icon: WorkflowCategoryIcon, title: t("repositoryInfo.related.workflow"), detail: t("repositoryInfo.related.workflowDetail"), href: "#workflow" },
    { Icon: RefreshCw, title: t("repositoryInfo.related.maintenance"), detail: t("repositoryInfo.related.maintenanceDetail"), href: "#maintenance" },
    { Icon: ShieldCheck, title: t("repositoryInfo.related.safety"), detail: t("repositoryInfo.related.safetyDetail"), href: "#safety" },
  ];
  return (
    <div className="sidebar-page-link-grid">
      {links.map((link) => (
        <SidebarPageLinkCard {...link} key={link.title} />
      ))}
    </div>
  );
}

function repositoryProductContentLabel(authority, t, locale) {
  const localizedName = displayText(authority?.product_summary?.display_name?.[locale], "");
  const jaName = displayText(authority?.product_summary?.display_name?.ja, "");
  const enName = displayText(authority?.product_summary?.display_name?.en, "");
  const summaryName = localizedName || jaName || enName || displayText(authority?.product_summary?.name, "");
  return summaryName || t("repositoryInfo.summary.productContent.general");
}

function RepositoryInfoPage({ data, locale, t }) {
  const context = selectedContextData(data);
  const authority = data.development?.product_authority || {};
  const repositoryIndex = authority.repository_index || {};
  const repository = authority.repository || {};
  const repositoryIndexSummary = repositoryIndex.summary || {};
  const selectedRepository = displayText(context.target_repository?.name || repository.configured_name || repository.name, t("summary.none"));
  const fileRows = repositoryFileRows(data, authority);
  const repositoryStructureValue = Number(repositoryIndexSummary.total)
    ? `${Number(repositoryIndexSummary.directories) || 0} ${t("repositoryInfo.summary.directories")} / ${Number(repositoryIndexSummary.files) || 0} ${t("repositoryInfo.summary.files")}`
    : t("repositoryInfo.notCollected");

  return (
    <section className="view-surface view-surface--repository-info sidebar-page" id="repository-info" aria-labelledby="repository-info-heading">
      <DetailPageHeader tone="repository-info" Icon={Info} title={t("repositoryInfo.title")} subtitle={t("repositoryInfo.description")} data={data} locale={locale} t={t} actionLabel={t("detail.refreshDisplayOnly")} headingId="repository-info-heading" />
      <DetailDecisionSummary
        tone="sidebar"
        t={t}
        items={[
          { Icon: Database, label: t("repositoryInfo.summary.target"), value: selectedRepository, detail: contextLabel(context.menu_id, t) },
          { Icon: Compass, label: t("repositoryInfo.summary.context"), value: contextLabel(context.menu_id, t), detail: workflowContextLabel(context.workflow_context, t) },
          { Icon: FileSearch, label: t("repositoryInfo.summary.structure"), value: repositoryStructureValue, detail: t("repositoryInfo.summary.structureDetail"), tone: repositoryIndex.status === "ready" ? "ready" : "warning" },
          { Icon: ClipboardCheck, label: t("repositoryInfo.summary.productContent"), value: repositoryProductContentLabel(authority, t, locale), detail: t("repositoryInfo.summary.productContentDetail") },
        ]}
      />
      <DetailSection id="repository-context" title={t("repositoryInfo.contextTitle")} Icon={Compass}>
        <FieldGrid
          fields={[
            { label: t("repositoryInfo.field.menu"), value: context.menu_id, render: () => contextLabel(context.menu_id, t) },
            { label: t("repositoryInfo.field.workflow"), value: context.workflow_context, render: () => workflowContextLabel(context.workflow_context, t) },
            { label: t("repositoryInfo.field.repository"), value: selectedRepository },
            { label: t("repositoryInfo.field.productType"), value: context.product_type },
            { label: t("repositoryInfo.field.currentStep"), value: selectedStepText(context) },
            { label: t("repositoryInfo.field.updated"), value: context.updated_at, render: (value) => formatDashboardDateTime(value) || displayText(value) },
            { label: t("repositoryInfo.field.pathState"), value: context.target_repository?.path_state, render: (value) => <StatusPill value={repositoryPathStateToStatus(value)} t={t} label={t(`repositoryInfo.pathState.${displayText(value, "unknown")}`, displayKey(value))} /> },
          ]}
        />
      </DetailSection>
      <DetailSection id="repository-file-map" title={t("repositoryInfo.fileMapTitle")} Icon={FileSearch}>
        <RepositoryFileTree rows={fileRows} t={t} defaultExpandDepth={Number(repositoryIndex.default_expand_depth) || 0} />
      </DetailSection>
      <DetailSection id="repository-related" title={t("repositoryInfo.relatedTitle")} Icon={ArrowRightCircle}>
        <RepositoryRelatedLinks t={t} />
      </DetailSection>
      <SourceBoundary data={data} t={t} />
    </section>
  );
}

function DocumentsPage({ data, locale, t }) {
  const maintenance = data.maintenance || {};
  const workflowPairStatus = valueState(maintenanceEvidenceRow(maintenance, ["workflow_pair"]) || maintenance.workflow_pair_status || "manual_required");
  const developerMemoryStatus = valueState(maintenanceEvidenceRow(maintenance, ["developer_memory"]) || maintenance.developer_memory_status || "manual_required");
  const documents = [
    { id: "agents", title: t("documentsPage.item.agents"), path: "AGENTS.MD", detail: t("documentsPage.detail.agents"), Icon: FileText },
    { id: "documentMap", title: t("documentsPage.item.documentMap"), path: "guides/DOCUMENT_MAP.md", detail: t("documentsPage.detail.documentMap"), Icon: Folder },
    { id: "requirements", title: t("documentsPage.item.requirements"), path: "docs/as-built/REQUIREMENTS.md", detail: t("documentsPage.detail.requirements"), Icon: FileCheck2 },
    { id: "specification", title: t("documentsPage.item.specification"), path: "docs/as-built/SPECIFICATION.md", detail: t("documentsPage.detail.specification"), Icon: FileJson },
    { id: "implementationPlan", title: t("documentsPage.item.implementationPlan"), path: "docs/as-built/IMPLEMENTATION_PLAN.md", detail: t("documentsPage.detail.implementationPlan"), Icon: ListChecks },
    { id: "taskTracker", title: t("documentsPage.item.taskTracker"), path: "docs/workflow/TASK_TRACKER.md", detail: t("documentsPage.detail.taskTracker"), Icon: ClipboardCheck },
    { id: "handoff", title: t("documentsPage.item.handoff"), path: "docs/workflow/HANDOFF.md", detail: t("documentsPage.detail.handoff"), Icon: Waypoints },
    { id: "developerMemory", title: t("documentsPage.item.developerMemory"), path: "docs/memory/DEVELOPER_MEMORY.md", detail: t("documentsPage.detail.developerMemory"), Icon: Brain },
    { id: "dashboardDataSchema", title: t("documentsPage.item.dashboardDataSchema"), path: "docs/workflow/DASHBOARD_DATA_SCHEMA.tsv", detail: t("documentsPage.detail.dashboardDataSchema"), Icon: Database },
    { id: "securityPolicy", title: t("documentsPage.item.securityPolicy"), path: "docs/workflow/PRODUCT_SECURITY_POLICY.tsv", detail: t("documentsPage.detail.securityPolicy"), Icon: ShieldCheck },
  ];

  return (
    <section className="view-surface view-surface--documents sidebar-page" id="documents" aria-labelledby="documents-heading">
      <DetailPageHeader tone="documents" Icon={FileText} title={t("documentsPage.title")} subtitle={t("documentsPage.description")} data={data} locale={locale} t={t} actionLabel={t("detail.refreshDisplayOnly")} headingId="documents-heading" />
      <DetailDecisionSummary
        tone="sidebar"
        t={t}
        items={[
          { Icon: Folder, label: t("documentsPage.summary.start"), value: t("documentsPage.summary.startValue"), detail: t("documentsPage.summary.startDetail") },
          { Icon: Waypoints, label: t("documentsPage.summary.workflowPair"), value: statusLabelForChip(workflowPairStatus, t), detail: t("documentsPage.summary.workflowPairDetail"), tone: isReviewState(workflowPairStatus) ? "warning" : "ready" },
          { Icon: Brain, label: t("documentsPage.summary.memory"), value: statusLabelForChip(developerMemoryStatus, t), detail: t("documentsPage.summary.memoryDetail"), tone: isReviewState(developerMemoryStatus) ? "warning" : "ready" },
          { Icon: ArrowRightCircle, label: t("detail.nextSafeCheck"), value: t("documentsPage.summary.next"), detail: t("documentsPage.summary.nextDetail"), cta: { href: "#maintenance", label: t("summary.viewDetails") } },
        ]}
      />
      <DetailSection id="documents-catalog" title={t("documentsPage.catalogTitle")} Icon={FileText}>
        <div className="sidebar-document-grid">
          {documents.map(({ id, title, path, detail, Icon }) => (
            <SidebarPageCard Icon={Icon} title={title} detail={detail} status={documentStatusFor(id, data)} t={t} key={id}>
              <SidebarReferenceChip value={path} t={t} />
            </SidebarPageCard>
          ))}
        </div>
      </DetailSection>
      <EvidenceRowsTable rows={maintenance.evidence_rows} t={t} />
      <SourceBoundary data={data} t={t} />
    </section>
  );
}

function SettingsPage({ data, locale, t }) {
  const context = selectedContextData(data);
  const lesson = selectedLessonObject(data, context);
  const settingsGroups = [
    {
      id: "lesson",
      title: t("settingsPage.group.lesson"),
      Icon: GraduationCap,
      items: [
        { title: t("field.learningMode"), detail: t("settingsPage.detail.learningMode"), status: lesson.learning_mode_status },
        { title: t("field.workflowLanguage"), detail: t("settingsPage.detail.workflowLanguage"), status: lesson.workflow_language_status },
        { title: t("field.productLanguage"), detail: t("settingsPage.detail.productLanguage"), status: lesson.product_language_status },
        { title: t("field.learnerApproval"), detail: t("settingsPage.detail.learnerApproval"), status: lesson.learner_approval_status },
      ],
    },
    {
      id: "workflow",
      title: t("settingsPage.group.workflow"),
      Icon: GitBranch,
      items: [
        { title: t("workflow.item.policy"), detail: t("settingsPage.detail.gitPolicy"), status: data.git_workflow?.policy_status },
        { title: t("workflow.item.settings"), detail: t("settingsPage.detail.gitSettings"), status: data.git_workflow?.settings_status },
        { title: t("workflow.item.gate"), detail: t("settingsPage.detail.gitGate"), status: data.git_workflow?.gate_status },
        { title: t("workflow.item.approval"), detail: t("settingsPage.detail.gitApproval"), status: data.git_workflow?.approval_status },
      ],
    },
    {
      id: "security",
      title: t("settingsPage.group.security"),
      Icon: ShieldCheck,
      items: [
        { title: t("security.item.policy"), detail: t("settingsPage.detail.securityPolicy"), status: data.security?.policy_status },
        { title: t("security.item.gate"), detail: t("settingsPage.detail.securityGate"), status: data.security?.gate_status },
        { title: t("security.item.approval"), detail: t("settingsPage.detail.securityApproval"), status: data.security?.dangerous_action_approval },
      ],
    },
  ];
  const reviewItems = settingsGroups.flatMap((group) => group.items).filter((item) => isReviewState(item.status));

  return (
    <section className="view-surface view-surface--settings sidebar-page" id="settings" aria-labelledby="settings-heading">
      <DetailPageHeader tone="settings" Icon={Settings} title={t("settingsPage.title")} subtitle={t("settingsPage.description")} data={data} locale={locale} t={t} actionLabel={t("detail.refreshDisplayOnly")} headingId="settings-heading" />
      <DetailDecisionSummary
        tone="sidebar"
        t={t}
        items={[
          { Icon: Lock, label: t("settingsPage.summary.readOnly"), value: t("app.readOnly"), detail: t("settingsPage.summary.readOnlyDetail") },
          { Icon: Scale, label: t("detail.currentJudgment"), value: reviewItems.length ? t("detail.judgment.needsReviewShort") : t("detail.judgment.readyShort"), detail: reviewItems.length ? t("settingsPage.summary.reviewDetail") : t("settingsPage.summary.readyDetail"), tone: reviewItems.length ? "warning" : "ready" },
          { Icon: Eye, label: t("detail.mustReview"), points: reviewItems.length ? reviewItems.slice(0, 4).map((item) => item.title) : [t("detail.noRequiredReview")] },
          { Icon: ArrowRightCircle, label: t("detail.nextSafeCheck"), value: t("settingsPage.summary.next"), detail: t("settingsPage.summary.nextDetail"), cta: { href: "#maintenance", label: t("summary.viewDetails") } },
        ]}
      />
      {settingsGroups.map(({ id, title, Icon, items }) => (
        <DetailSection id={`settings-${id}`} title={title} Icon={Icon} key={id}>
          <div className="sidebar-page-card-grid">
            {items.map((item) => (
              <SidebarPageCard Icon={Settings} title={item.title} detail={item.detail} status={item.status || "unknown"} t={t} key={item.title} />
            ))}
          </div>
        </DetailSection>
      ))}
      <MockNotice tone="settings-warning" Icon={Lock} title={t("settingsPage.notice.title")} detail={t("settingsPage.notice.detail")} />
    </section>
  );
}

function HelpPage({ data, locale, t }) {
  const topics = [
    { Icon: BookOpen, title: t("helpPage.topic.lessons.title"), detail: t("helpPage.topic.lessons.detail"), href: "#lessons" },
    { Icon: Info, title: t("helpPage.topic.repository.title"), detail: t("helpPage.topic.repository.detail"), href: "#repository-info" },
    { Icon: WorkflowCategoryIcon, title: t("helpPage.topic.workflow.title"), detail: t("helpPage.topic.workflow.detail"), href: "#workflow" },
    { Icon: RefreshCw, title: t("helpPage.topic.maintenance.title"), detail: t("helpPage.topic.maintenance.detail"), href: "#maintenance" },
    { Icon: ShieldCheck, title: t("helpPage.topic.safety.title"), detail: t("helpPage.topic.safety.detail"), href: "#safety" },
    { Icon: Settings, title: t("helpPage.topic.settings.title"), detail: t("helpPage.topic.settings.detail"), href: "#settings" },
  ];
  const glossary = ["git", "ci", "pr", "merge", "snapshot", "evidence", "securityGate"].map((id) => ({
    id,
    title: t(`helpPage.glossary.${id}.title`),
    detail: t(`helpPage.glossary.${id}.detail`),
  }));

  return (
    <section className="view-surface view-surface--help sidebar-page" id="help" aria-labelledby="help-heading">
      <DetailPageHeader tone="help" Icon={CircleHelp} title={t("helpPage.title")} subtitle={t("helpPage.description")} data={data} locale={locale} t={t} actionLabel={t("detail.refreshDisplayOnly")} headingId="help-heading" />
      <DetailDecisionSummary
        tone="sidebar"
        t={t}
        items={[
          { Icon: Compass, label: t("helpPage.summary.where"), value: contextLabel(selectedContextData(data).menu_id, t), detail: t("helpPage.summary.whereDetail") },
          { Icon: BookOpen, label: t("helpPage.summary.learn"), value: t("helpPage.summary.learnValue"), detail: t("helpPage.summary.learnDetail") },
          { Icon: ShieldCheck, label: t("helpPage.summary.safety"), value: t("helpPage.summary.safetyValue"), detail: t("helpPage.summary.safetyDetail") },
          { Icon: ArrowRightCircle, label: t("detail.nextSafeCheck"), value: t("helpPage.summary.next"), detail: t("helpPage.summary.nextDetail"), cta: { href: "#overview", label: t("nav.overview") } },
        ]}
      />
      <DetailSection id="help-topics" title={t("helpPage.topicsTitle")} Icon={CircleHelp}>
        <div className="sidebar-page-link-grid">
          {topics.map((topic) => (
            <SidebarPageLinkCard {...topic} key={topic.title} />
          ))}
        </div>
      </DetailSection>
      <DetailSection id="help-glossary" title={t("helpPage.glossaryTitle")} Icon={BookMarked}>
        <div className="sidebar-glossary-grid">
          {glossary.map((item) => (
            <article className="sidebar-glossary-card" key={item.id}>
              <strong>{item.title}</strong>
              <p>{item.detail}</p>
            </article>
          ))}
        </div>
      </DetailSection>
    </section>
  );
}

function HistoryPage({ data, locale, t }) {
  const warnings = asArray(data.warnings);
  const sourceFiles = asArray(data.source_files);
  const sourceCommands = asArray(data.source_commands);
  return (
    <section className="view-surface view-surface--history sidebar-page" id="history" aria-labelledby="history-heading">
      <DetailPageHeader tone="history" Icon={Clock} title={t("historyPage.title")} subtitle={t("historyPage.description")} data={data} locale={locale} t={t} actionLabel={t("detail.refreshDisplayOnly")} headingId="history-heading" />
      <DetailDecisionSummary
        tone="sidebar"
        t={t}
        items={[
          { Icon: CalendarDays, label: t("historyPage.summary.generated"), value: formatGenerated(data, locale), detail: t("historyPage.summary.generatedDetail") },
          { Icon: FileJson, label: t("historyPage.summary.snapshot"), value: displayText(data.snapshot_id), detail: t("historyPage.summary.snapshotDetail") },
          { Icon: FileText, label: t("historyPage.summary.sources"), value: `${sourceFiles.length} / ${sourceCommands.length}`, detail: t("historyPage.summary.sourcesDetail") },
          { Icon: AlertTriangle, label: t("summary.warnings"), value: warnings.length ? `${warnings.length}` : t("summary.none"), detail: warnings.length ? t("historyPage.summary.warningDetail") : t("historyPage.summary.noWarningDetail"), tone: warnings.length ? "warning" : "ready" },
        ]}
      />
      <DetailSection id="history-snapshot" title={t("historyPage.snapshotTitle")} Icon={FileJson}>
        <div className="sidebar-page-card-grid">
          <SidebarPageCard Icon={CalendarDays} title={t("summary.generated")} detail={formatGenerated(data, locale)} status="ready" t={t} />
          <SidebarPageCard Icon={Database} title={t("summary.schema")} detail={displayText(data.schema_version)} status="ready" t={t} />
          <SidebarPageCard Icon={FileJson} title={t("historyPage.contentHash")} detail={displayText(data.content_hash)} status={data.content_hash ? "ready" : "unknown"} t={t} />
          <SidebarPageCard Icon={Lock} title={t("app.readOnly")} detail={t("historyPage.readOnlyDetail")} status="ready" t={t} />
        </div>
      </DetailSection>
      <WorkflowRecentTable rows={data.development?.recent_runs} data={data} t={t} />
      <DetailSection id="history-warnings" title={t("summary.warnings")} Icon={AlertTriangle}>
        {warnings.length ? (
          <div className="sidebar-warning-list">
            {warnings.map((warning, index) => (
              <article className="sidebar-warning-item" key={`${displayText(warning)}-${index}`}>
                <AlertTriangle aria-hidden="true" size={18} />
                <p>{displayText(warning)}</p>
              </article>
            ))}
          </div>
        ) : (
          <SidebarPageCard Icon={CheckCircle2} title={t("summary.none")} detail={t("historyPage.noWarnings")} status="ready" t={t} />
        )}
      </DetailSection>
      <SourceBoundary data={data} t={t} />
    </section>
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
            <SourceBoundaryChips values={files} t={t} limit={3} variant="files" />
          </div>
        </div>
        <div>
          <Copy aria-hidden="true" size={20} />
          <div>
            <strong>{t("app.sourceCommands")}</strong>
            <SourceBoundaryChips values={commands} t={t} limit={2} variant="commands" />
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
  const sidebarRef = useRef(null);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const activeItem = allNavigation.find((item) => item.id === activeView) || navigation[0];
  const ActiveIcon = activeItem.Icon || Home;

  useEffect(() => {
    const activeLink = sidebarRef.current?.querySelector(".category-nav__link.is-active");
    if (!activeLink) {
      return;
    }
    activeLink.scrollIntoView({ block: "nearest", inline: "center" });
  }, [activeView]);

  useEffect(() => {
    setIsMobileMenuOpen(false);
  }, [activeView]);

  return (
    <aside className={`app-sidebar app-sidebar--${activeView}${isMobileMenuOpen ? " is-mobile-open" : ""}`} aria-label={t("aria.categories")} ref={sidebarRef}>
      <div className="sidebar-topline">
        <div className="brand">
          <BrandMark />
          <div>
            <strong>{t("app.title")}</strong>
            <span>{t("app.eyebrow")}</span>
          </div>
        </div>
        <button className="mobile-menu-toggle" type="button" aria-expanded={isMobileMenuOpen} aria-controls="sidebar-menu-panel" onClick={() => setIsMobileMenuOpen((current) => !current)}>
          {isMobileMenuOpen ? <CircleX aria-hidden="true" size={17} /> : <List aria-hidden="true" size={17} />}
          <span>{isMobileMenuOpen ? t("nav.closeMenu") : t("nav.openMenu")}</span>
        </button>
      </div>
      <div className="mobile-current-page" aria-label={t("nav.currentPage")}>
        <ActiveIcon aria-hidden="true" size={17} />
        <span>{activeView === "overview" ? t("nav.overviewDetail") : t(activeItem.labelKey)}</span>
      </div>
      <div className="sidebar-menu-panel" id="sidebar-menu-panel">
        <nav className="category-nav" aria-label={t("aria.categories")}>
          {navigation.map(({ id, labelKey, Icon }) => (
            <a className={activeView === id ? "category-nav__link is-active" : "category-nav__link"} href={`#${id}`} aria-current={activeView === id ? "page" : undefined} key={id}>
              <Icon aria-hidden="true" size={18} />
              <span>{id === "overview" ? t("nav.overviewDetail") : t(labelKey)}</span>
            </a>
          ))}
        </nav>
        <nav className="support-nav" aria-label={t("nav.repositoryGroup")}>
          <h3>{t("nav.repositoryGroup")}</h3>
          {repositoryNavigation.map(({ id, labelKey, Icon, href }) => (
            <a className={activeView === id ? "category-nav__link category-nav__link--subtle is-active" : "category-nav__link category-nav__link--subtle"} href={href} aria-current={activeView === id ? "page" : undefined} key={id}>
              <Icon aria-hidden="true" size={18} />
              <span>{t(labelKey)}</span>
            </a>
          ))}
        </nav>
        <nav className="support-nav" aria-label={t("nav.otherGroup")}>
          <h3>{t("nav.otherGroup")}</h3>
          {supportNavigation.map(({ id, labelKey, Icon, href }) => (
            <a className={activeView === id ? "category-nav__link category-nav__link--subtle is-active" : "category-nav__link category-nav__link--subtle"} href={href} aria-current={activeView === id ? "page" : undefined} key={id}>
              <Icon aria-hidden="true" size={18} />
              <span>{t(labelKey)}</span>
            </a>
          ))}
        </nav>
        <div className="sidebar-meta">
          <div className="sidebar-note">
            <Info aria-hidden="true" size={16} />
            <span>{t("sidebar.readOnlyNotice")}</span>
          </div>
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
        {loaded && activeView === "repository-info" ? <RepositoryInfoPage data={data} locale={locale} t={t} /> : null}
        {loaded && activeView === "documents" ? <DocumentsPage data={data} locale={locale} t={t} /> : null}
        {loaded && activeView === "settings" ? <SettingsPage data={data} locale={locale} t={t} /> : null}
        {loaded && activeView === "help" ? <HelpPage data={data} locale={locale} t={t} /> : null}
        {loaded && activeView === "history" ? <HistoryPage data={data} locale={locale} t={t} /> : null}
      </section>
    </main>
  );
}
