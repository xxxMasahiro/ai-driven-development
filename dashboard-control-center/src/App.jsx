import {
  AlertTriangle,
  ArrowRightCircle,
  BadgeAlert,
  BookOpen,
  BookMarked,
  Brain,
  CalendarDays,
  CheckCircle2,
  ChevronRight,
  ChevronsRight,
  CircleAlert,
  CircleDashed,
  CircleHelp,
  CircleX,
  ClipboardCheck,
  ClipboardList,
  Clock,
  Code2,
  Compass,
  Copy,
  Database,
  Eye,
  File,
  FileCheck2,
  FileJson,
  FileSearch,
  FileText,
  Flag,
  Folder,
  GitBranch,
  Globe2,
  GraduationCap,
  Home,
  Info,
  KeyRound,
  ListChecks,
  Lock,
  RefreshCw,
  Scale,
  ShieldAlert,
  ShieldCheck,
  Settings,
  User,
  UserCheck,
  TerminalSquare,
  Target,
  Waypoints,
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
  approval_required: CircleAlert,
};

const reviewStates = new Set(["failed", "blocked", "approval_required", "missing", "unknown", "optional", "cached"]);

const statePriority = {
  blocked: 0,
  failed: 1,
  approval_required: 2,
  unknown: 3,
  missing: 4,
  optional: 5,
  cached: 6,
  ready: 7,
  passed: 8,
};

function WorkflowCategoryIcon(props) {
  return <Workflow {...props} data-workflow-category-icon="true" />;
}

const navigation = [
  { id: "overview", labelKey: "nav.overview", healthKey: "health.lesson", Icon: Home },
  { id: "lessons", labelKey: "nav.lessons", healthKey: "health.lesson", Icon: BookOpen },
  { id: "workflow", labelKey: "nav.workflow", healthKey: "health.workflow", Icon: WorkflowCategoryIcon },
  { id: "maintenance", labelKey: "nav.maintenance", healthKey: "health.maintenance", Icon: RefreshCw },
  { id: "safety", labelKey: "nav.safety", healthKey: "health.security", Icon: ShieldCheck },
];

function viewFromHash() {
  const hash = window.location.hash.replace(/^#/, "");
  return navigation.some((item) => item.id === hash) ? hash : "overview";
}

function StatusPill({ value, t, label, className = "" }) {
  const state = normalizeState(value);
  const Icon = stateIcons[state] || CircleDashed;
  return (
    <span className={`status status--${state} ${className}`.trim()} data-state={state}>
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
  return data?.generated_at ? formatDateTime(data.generated_at, locale) : "";
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
      title: t("health.lesson"),
      status: metrics.lessons.status,
      detail: `${metrics.lessons.total} ${t("summary.lessonsCount")}`,
      meta: `${metrics.lessons.total} ${t("summary.items")}`,
      metric: metrics.lessons,
      Icon: BookOpen,
    },
    {
      id: "workflow",
      title: t("health.workflow"),
      status: metrics.workflow.status,
      detail: `${metrics.workflow.total} ${t("summary.workflowFields")}`,
      meta: `${metrics.workflow.total} ${t("summary.steps")}`,
      metric: metrics.workflow,
      Icon: WorkflowCategoryIcon,
    },
    {
      id: "maintenance",
      title: t("health.maintenance"),
      status: metrics.maintenance.status,
      detail: `${metrics.maintenance.total} ${t("summary.maintenanceFields")}`,
      meta: `${metrics.maintenance.total} ${t("summary.items")}`,
      metric: metrics.maintenance,
      Icon: RefreshCw,
    },
    {
      id: "safety",
      title: t("health.security"),
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
      <h3 id="explore-pages-heading">{t("summary.explorePages")}</h3>
      <div className="explore-grid">
        {categories.map(({ id, title, status, detail, metric, Icon }) => (
          <a className={id === "overview" ? `explore-card explore-card--${id} is-current` : `explore-card explore-card--${id}`} href={`#${id}`} key={id}>
            <div className="explore-card__head">
              <Icon aria-hidden="true" size={22} />
              <span className="explore-card__title">{title}</span>
            </div>
            <p>{detail}</p>
            <div className="explore-card__meta">
              <span className="explore-card__count">{metric?.total ?? 0} {metricUnitLabel(metric?.unit, t)}</span>
              <span className={`explore-card__dot explore-card__dot--${normalizeState(metric?.status || status)}`} aria-hidden="true" />
              <strong>{clampPercent(metric?.percent)}%</strong>
            </div>
          </a>
        ))}
      </div>
    </section>
  );
}

function RepositoryNotice({ t }) {
  return (
    <div className="repository-notice">
      <AlertTriangle aria-hidden="true" size={16} />
      <span>{t("summary.repositoryNotice")}</span>
    </div>
  );
}

function OverviewSection({ data, t, locale }) {
  const summary = data.summary || {};
  const blockingItems = asArray(summary.blocking_items);
  const partialFailures = asArray(data.partial_failures);
  const manualFollowups = asArray(summary.manual_followups);
  const warnings = asArray(data.warnings).map((warning, index) => ({
    source: `${t("summary.warningItem")} ${index + 1}`,
    status: "optional",
    reason: warning,
  }));
  const categorySummaries = buildCategorySummaries({
    summary,
    t,
  });
  const healthSummaries = categorySummaries.filter((category) => category.id !== "overview");

  return (
    <section className="view-surface" id="overview" aria-labelledby="overview-heading">
      <h2 id="overview-heading" className="sr-only">{t("summary.title")}</h2>
      <StatusStrip data={data} t={t} locale={locale} />
      <div className="overview-grid">
        <div className="primary-stack">
          <article className="primary-panel">
            <PrimaryActionCard action={summary.primary_action} t={t} />
            {!summary.primary_action ? <p className="next-safe-action">{displayText(summary.next_safe_action)}</p> : null}
          </article>
          <IssueSummaryCard title={t("summary.partialFailures")} items={partialFailures} t={t} Icon={AlertTriangle} href="#safety" always />
        </div>
        <section className="health-grid" aria-label={t("aria.categoryHealth")}>
          {healthSummaries.map(({ id, title, status, detail, Icon, metric }) => (
            <HealthCard id={id} Icon={Icon} title={title} status={status} detail={detail} href={`#${id}`} t={t} key={id} metric={metric} />
          ))}
        </section>
      </div>
      <div className="overview-summary-grid">
        <IssueSummaryCard title={t("summary.manualFollowups")} items={manualFollowups} t={t} Icon={Clock} href="#maintenance" always />
        <IssueSummaryCard title={t("summary.blockingItems")} items={blockingItems} t={t} Icon={Lock} href="#safety" />
        <IssueSummaryCard title={t("summary.warnings")} items={warnings} t={t} Icon={CircleDashed} href="#maintenance" />
      </div>
      <GuidanceList items={asArray(summary.guidance_items)} t={t} />
      <ExplorePages categories={categorySummaries} t={t} />
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
    ...objectEntries(development).map(([id, value]) => [`development.${id}`, value]),
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

function LessonSection({ lessons, data, locale, t }) {
  const lessonEntries = objectEntries(lessons);
  const metric = data.summary?.category_metrics?.lessons;
  const attentionCount = lessonEntries.reduce((sum, [, lesson]) => sum + lessonAttentionCount(lesson || {}), 0);
  const nextAction = attentionCount ? t("detail.lessons.nextSafe") : firstLessonNextAction(lessonEntries) || t("detail.lessons.nextSafe");
  const reviewPoints = lessonReviewPoints(lessonEntries, t);
  return (
    <section className="view-surface view-surface--lessons" id="lessons" aria-labelledby="lesson-heading">
      <DetailPageHeader tone="lessons" Icon={BookOpen} title={t("lessons.title")} subtitle={t("lessons.description")} data={data} locale={locale} t={t} headingId="lesson-heading" />
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
        {lessonEntries.map(([id, lesson]) => (
          <LessonCard id={id} lesson={lesson || {}} key={id} t={t} />
        ))}
      </div>
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
  const readyItems = workflowItems.filter((item) => !isReviewState(item.state));
  const approvalItems = workflowItems.filter((item) => normalizeState(item.state) === "approval_required").length;
  return (
    <section className="view-surface view-surface--workflow" id="workflow" aria-labelledby="workflow-heading">
      <DetailPageHeader tone="workflow" Icon={WorkflowCategoryIcon} title={t("workflow.title")} subtitle={t("workflow.description")} data={data} locale={locale} t={t} actionLabel={t("detail.refreshDisplayOnly")} headingId="workflow-heading" />
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
      <DetailSection id="workflow-review" title={t("detail.mustReviewPrioritySection")} Icon={CircleAlert} className="detail-section--priority">
        <div className="detail-table detail-table--workflow detail-table--priority">
          {reviewItems.length ? (
            reviewItems.map((item) => <DetailTableRow item={item} key={item.id} t={t} tone="workflow" />)
          ) : (
            <EmptyDetailRow title={t("detail.noRequiredReview")} detail={t("detail.workflow.noReviewDetail")} t={t} tone="workflow" />
          )}
        </div>
      </DetailSection>
      <DetailSection id="workflow-ready" title={t("detail.readyItems")} Icon={CheckCircle2}>
        <div className="detail-table detail-table--workflow">
          {readyItems.map((item) => (
            <DetailTableRow item={item} key={item.id} t={t} tone="workflow" />
          ))}
        </div>
      </DetailSection>
      <ReadOnlyBanner t={t} tone="workflow" />
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

function MaintenanceSection({ maintenance, data, locale, t }) {
  const manualFollowups = asArray(data.summary?.manual_followups);
  const warnings = asArray(data.warnings).map((warning, index) => ({
    source: `${t("summary.warningItem")} ${index + 1}`,
    status: "optional",
    reason: warning,
  }));
  const metric = data.summary?.category_metrics?.maintenance;
  const maintenanceItems = objectEntries(maintenance).map(([id, value]) => {
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
      <DetailPageHeader tone="maintenance" Icon={RefreshCw} title={t("maintenance.title")} subtitle={t("maintenance.description")} data={data} locale={locale} t={t} actionLabel={t("detail.refreshMaintenance")} headingId="maintenance-heading" />
      <DetailDecisionSummary
        tone="maintenance"
        t={t}
        items={[
          { Icon: CircleHelp, label: t("detail.checks"), value: t("detail.maintenance.checks"), detail: t("detail.maintenance.checksDetail") },
          { Icon: Scale, label: t("detail.currentJudgment"), value: reviewCount ? t("detail.judgment.usableWithFollowup") : t("detail.judgment.ready"), detail: t("detail.maintenance.reviewDetail"), badge: statusSummaryBadge(manualFollowups.length, t("summary.manualFollowups"), t), tone: reviewCount ? "warning" : "ready" },
          { Icon: Eye, label: t("detail.mustReview"), value: `${reviewCount} ${t("detail.items")}`, detail: t("detail.maintenance.mustReview"), points: itemTitles(maintenanceItems, t("summary.none")) },
          { Icon: ChevronsRight, label: t("detail.nextSafeCheck"), value: t("detail.maintenance.nextSafe"), detail: t("detail.maintenance.nextSafeDetail"), cta: { href: "#maintenance-confirmation", label: t("detail.openConfirmationFlow") } },
        ]}
      />
      <div className="detail-list detail-list--status detail-list--maintenance">
        {maintenanceItems.map((item) => (
          <DetailStatusCard
            id={item.id}
            value={item.value}
            title={item.title}
            technicalKey={item.technicalKey}
            key={item.id}
            t={t}
            Icon={item.Icon}
            tone="maintenance"
            note={item.note}
            footer={<span className="detail-card__footer-line">{sourceStatusSummary(item.value, t)}</span>}
          />
        ))}
      </div>
      <DetailSection id="maintenance-confirmation" title={t("maintenance.confirmationFlow")} Icon={FileCheck2}>
        <MaintenanceConfirmationTable manualFollowups={manualFollowups} warnings={warnings} data={data} t={t} />
      </DetailSection>
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
        <h3 id="partial-failures-heading">{t("summary.partialFailures")}</h3>
        <p>{failures.length ? t("detail.security.failuresHelp") : t("summary.none")}</p>
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
              <CheckCircle2 aria-hidden="true" size={22} />
            </div>
            <div className="failure-row__item">
              <strong>{t("summary.none")}</strong>
            </div>
            <div>{t("summary.none")}</div>
            <div>{t("detail.security.noFailures")}</div>
            <div>
              <StatusPill value="ready" t={t} />
            </div>
            <div>{technicalChip(t("summary.none"))}</div>
          </article>
        )}
      </div>
    </section>
  );
}

function SecuritySection({ security, partialFailures, data, locale, t }) {
  const securityItems = objectEntries(security).map(([id, value]) => {
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
      <DetailPageHeader tone="safety" Icon={ShieldCheck} title={t("security.title")} subtitle={t("security.description")} data={data} locale={locale} t={t} headingId="security-heading" />
      <DetailDecisionSummary
        tone="safety"
        t={t}
        items={[
          { Icon: Target, label: t("detail.checks"), value: t("detail.security.checks"), detail: t("detail.security.checksDetail") },
          { Icon: BadgeAlert, label: t("detail.currentJudgment"), value: failureCount ? t("detail.judgment.blocked") : t("detail.judgment.ready"), detail: failureCount ? t("detail.security.blockedDetail") : t("detail.noRequiredReview"), badge: statusSummaryBadge(failureCount, t("summary.partialFailures"), t), tone: failureCount ? "danger" : "ready" },
          { Icon: FileSearch, label: t("detail.mustReview"), value: approvalCount ? `${approvalCount} ${t("detail.approvals")}` : `${failureCount} ${t("detail.items")}`, detail: t("detail.security.mustReview"), points: [t("summary.partialFailures"), t("security.item.approval"), t("actions.title")] },
          { Icon: ArrowRightCircle, label: t("detail.nextSafeCheck"), value: t("detail.security.nextSafe"), detail: t("detail.security.nextSafeDetail"), cta: { href: "#partial-failures-heading", label: t("detail.openPartialFailures") } },
        ]}
      />
      <div className="detail-list detail-list--status detail-list--safety">
        {securityItems.map((item) => (
          <DetailStatusCard
            id={item.id}
            value={item.value}
            visualState={item.state}
            title={item.title}
            technicalKey={item.technicalKey}
            key={item.id}
            t={t}
            Icon={item.Icon}
            tone="safety"
            note={item.note}
            footer={<span className="detail-card__footer-line">{sourceStatusSummary(item.value, t)}</span>}
          />
        ))}
      </div>
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
    <section className="view-surface view-surface--nested" aria-labelledby="action-heading">
      <div className="view-header">
        <div>
          <TerminalSquare aria-hidden="true" size={22} />
          <h2 id="action-heading">{t("actions.title")}</h2>
          <span className="display-only-badge">{t("actions.displayOnly")}</span>
        </div>
        <p>{t("actions.description")}</p>
      </div>
      <div className="preview-list">
        {previews.map((preview, index) => (
          <article className={`command-preview command-preview--${normalizeRisk(preview.risk_level)}`} key={`${displayText(preview.intent)}-${index}`}>
            <div className="command-preview__head">
              <span className="command-preview__icon">
                {normalizeRisk(preview.risk_level) === "critical" ? <ShieldAlert aria-hidden="true" size={22} /> : <TerminalSquare aria-hidden="true" size={22} />}
              </span>
              <div>
                <h3>{commandIntentLabel(preview.intent, t)}</h3>
                <p>{commandTargetLabel(preview.target, t)}</p>
              </div>
              <span className="display-only-badge">{t("actions.displayOnly")}</span>
              <RiskPill value={preview.risk_level} t={t} />
            </div>
            <FieldGrid
              fields={[
                { label: t("field.approval"), value: preview.requires_approval ? "approval_required" : "optional", render: (value) => <StatusPill value={value} t={t} /> },
                { label: t("field.gate"), value: commandGateLabel(preview.approval_gate_id, t) },
                { label: t("field.executionMode"), value: commandExecutionModeLabel(preview.execution_mode, t) },
                { label: t("field.executable"), value: preview.non_executable === true ? t("field.no") : t("field.unknown") },
              ]}
            />
            {preview.execution_mode === "preview_only" && preview.non_executable === true ? (
              <CommandChip command={preview.command_text} />
            ) : (
              <p className="command-preview__hidden">{t("actions.hidden")}</p>
            )}
          </article>
        ))}
      </div>
      <ReadOnlyBanner t={t} tone="safety" />
    </section>
  );
}

function SafetySection({ security, actions, partialFailures, data, locale, t }) {
  return (
    <>
      <SecuritySection security={security} partialFailures={partialFailures} data={data} locale={locale} t={t} />
      <CommandPreviews actions={actions} t={t} />
    </>
  );
}

function SourceBoundary({ data, t }) {
  const files = asArray(data.source_files);
  const commands = asArray(data.source_commands);
  return (
    <section className="source-boundary" aria-label={t("aria.dataBoundary")}>
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
    </section>
  );
}

function Sidebar({ activeView, t, data, locale, loaded }) {
  const generated = loaded && data.generated_at ? formatDateTime(data.generated_at, locale) : "";
  const activeNavigation = navigation.find((item) => item.id === activeView) || navigation[0];
  const BrandIcon = activeNavigation.Icon;
  return (
    <aside className={`app-sidebar app-sidebar--${activeView}`} aria-label={t("aria.categories")}>
      <div className="brand">
        <BrandIcon aria-hidden="true" size={30} />
        <div>
          <strong>{t("app.title")}</strong>
          <span>{t("app.eyebrow")}</span>
        </div>
      </div>
      <nav className="category-nav" aria-label={t("aria.categories")}>
        {navigation.map(({ id, labelKey, Icon }) => (
          <a className={activeView === id ? "category-nav__link is-active" : "category-nav__link"} href={`#${id}`} aria-current={activeView === id ? "page" : undefined} key={id}>
            <Icon aria-hidden="true" size={18} />
            <span>{t(labelKey)}</span>
          </a>
        ))}
      </nav>
      <div className="sidebar-meta">
        <div className="sidebar-note">
          <Lock aria-hidden="true" size={16} />
          <span>{t("app.readOnly")}</span>
        </div>
        {generated ? (
          <div className="sidebar-note">
            <Clock aria-hidden="true" size={16} />
            <span>
              {t("app.lastUpdated")}: {generated}
            </span>
          </div>
        ) : null}
      </div>
    </aside>
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
