import {
  AlertTriangle,
  BookOpen,
  CheckCircle2,
  CircleDashed,
  Clock,
  FileJson,
  GitBranch,
  Home,
  Lock,
  ShieldCheck,
  TerminalSquare,
  Wrench,
} from "lucide-react";
import { useEffect, useMemo, useState } from "react";

import {
  asArray,
  displayKey,
  displayText,
  fetchDashboardData,
  normalizeRisk,
  normalizeState,
  objectEntries,
  pickFirst,
} from "./dashboardData.js";
import { createTranslator, formatDateTime, formatRelativeAge, resolveLocale } from "./i18n.js";

const stateIcons = {
  ready: CheckCircle2,
  passed: CheckCircle2,
  failed: AlertTriangle,
  blocked: AlertTriangle,
  missing: CircleDashed,
  unknown: CircleDashed,
  optional: CircleDashed,
  cached: CircleDashed,
  approval_required: Lock,
};

const navigation = [
  { id: "overview", labelKey: "nav.overview", healthKey: "health.lesson", Icon: Home },
  { id: "lessons", labelKey: "nav.lessons", healthKey: "health.lesson", Icon: BookOpen },
  { id: "workflow", labelKey: "nav.workflow", healthKey: "health.workflow", Icon: GitBranch },
  { id: "maintenance", labelKey: "nav.maintenance", healthKey: "health.maintenance", Icon: Wrench },
  { id: "safety", labelKey: "nav.safety", healthKey: "health.security", Icon: ShieldCheck },
];

function viewFromHash() {
  const hash = window.location.hash.replace(/^#/, "");
  return navigation.some((item) => item.id === hash) ? hash : "overview";
}

function StatusPill({ value, t }) {
  const state = normalizeState(value);
  const Icon = stateIcons[state] || CircleDashed;
  return (
    <span className={`status status--${state}`} data-state={state}>
      <Icon aria-hidden="true" size={14} />
      {t(`state.${state}`, displayText(state))}
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

function IssueList({ title, items, t }) {
  if (!items.length) {
    return null;
  }
  return (
    <div className="issue-list">
      <h3>{title}</h3>
      {items.map((item, index) => (
        <article className="issue" key={`${displayText(item.source)}-${index}`}>
          <div className="issue__title">
            <span>{displayText(item.source)}</span>
            <StatusPill value={item.status} t={t} />
          </div>
          <p>{displayText(item.reason)}</p>
          {item.required_command ? <code>{displayText(item.required_command)}</code> : null}
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

function summarizeStates(values) {
  const states = values.map((value) => normalizeState(value));
  if (states.some((state) => state === "failed" || state === "blocked")) {
    return "blocked";
  }
  if (states.some((state) => state === "approval_required")) {
    return "approval_required";
  }
  if (states.length > 0 && states.every((state) => state === "ready" || state === "passed")) {
    return "ready";
  }
  if (states.some((state) => state === "missing")) {
    return "missing";
  }
  if (states.some((state) => state === "unknown")) {
    return "unknown";
  }
  if (states.some((state) => state === "optional")) {
    return "optional";
  }
  if (states.some((state) => state === "cached")) {
    return "cached";
  }
  return "unknown";
}

function objectStatusValues(object) {
  return objectEntries(object).map(([, value]) => {
    if (value && typeof value === "object" && !Array.isArray(value)) {
      return value.status;
    }
    return value;
  });
}

function lessonStatusValues(lessons) {
  return objectEntries(lessons).map(([, lesson]) => lesson?.status);
}

function StatusStrip({ data, t, locale }) {
  const blockers = asArray(data.summary?.blocking_items).length;
  const generated = data.generated_at ? formatDateTime(data.generated_at, locale) : "";
  const age = data.generated_at ? formatRelativeAge(data.generated_at, locale) : "";
  const items = [
    { label: t("summary.mode"), value: displayText(data.summary?.mode), Icon: FileJson },
    { label: t("summary.generated"), value: generated, detail: age, Icon: Clock },
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

function HealthCard({ title, status, detail, href, t, Icon }) {
  const state = normalizeState(status);
  return (
    <article className={`health-card health-card--${state}`} data-health-card={title}>
      <div className="health-card__head">
        <Icon aria-hidden="true" size={20} />
        <h3>{title}</h3>
        <StatusPill value={status} t={t} />
      </div>
      <div className="health-card__body">
        <div className="health-card__meter" data-state={state}>
          <Icon aria-hidden="true" size={28} />
        </div>
        <p>{detail}</p>
      </div>
      <a className="card-link" href={href}>
        {t("summary.openCategory")}
      </a>
    </article>
  );
}

function buildCategorySummaries({ lessons, workflowValues, maintenanceValues, securityValues, blockingItems, t }) {
  const lessonCount = objectEntries(lessons).length;
  const workflowCount = workflowValues.length;
  const maintenanceCount = maintenanceValues.length;
  const securityCount = securityValues.length;
  return [
    {
      id: "overview",
      title: t("nav.overview"),
      status: blockingItems.length ? "blocked" : "ready",
      detail: t("summary.overviewDetail"),
      meta: t("summary.currentPage"),
      Icon: Home,
    },
    {
      id: "lessons",
      title: t("health.lesson"),
      status: summarizeStates(lessonStatusValues(lessons)),
      detail: `${lessonCount} ${t("summary.lessonsCount")}`,
      meta: `${lessonCount} ${t("summary.items")}`,
      Icon: BookOpen,
    },
    {
      id: "workflow",
      title: t("health.workflow"),
      status: summarizeStates(workflowValues),
      detail: `${workflowCount} ${t("summary.workflowFields")}`,
      meta: `${workflowCount} ${t("summary.steps")}`,
      Icon: GitBranch,
    },
    {
      id: "maintenance",
      title: t("health.maintenance"),
      status: summarizeStates(maintenanceValues),
      detail: `${maintenanceCount} ${t("summary.maintenanceFields")}`,
      meta: `${maintenanceCount} ${t("summary.items")}`,
      Icon: Wrench,
    },
    {
      id: "safety",
      title: t("health.security"),
      status: summarizeStates(securityValues),
      detail: `${securityCount} ${t("summary.securityFields")}`,
      meta: `${securityCount} ${t("summary.checks")}`,
      Icon: ShieldCheck,
    },
  ];
}

function ExplorePages({ categories, t }) {
  return (
    <section className="explore-pages" aria-labelledby="explore-pages-heading">
      <h3 id="explore-pages-heading">{t("summary.explorePages")}</h3>
      <div className="explore-grid">
        {categories.map(({ id, title, status, detail, meta, Icon }) => (
          <a className={id === "overview" ? "explore-card is-current" : "explore-card"} href={`#${id}`} key={id}>
            <div className="explore-card__head">
              <Icon aria-hidden="true" size={22} />
              <span className="explore-card__title">{title}</span>
            </div>
            <p>{detail}</p>
            <div className="explore-card__meta">
              <span>{meta}</span>
              <StatusPill value={status} t={t} />
            </div>
          </a>
        ))}
      </div>
    </section>
  );
}

function OverviewSection({ data, t, locale }) {
  const summary = data.summary || {};
  const lessons = data.lessons || {};
  const workflowValues = [...objectStatusValues(data.development || {}), ...objectStatusValues(data.git_workflow || {})];
  const maintenanceValues = objectStatusValues(data.maintenance || {});
  const securityValues = objectStatusValues(data.security || {});
  const blockingItems = asArray(summary.blocking_items);
  const partialFailures = asArray(data.partial_failures);
  const warnings = asArray(data.warnings).map((warning, index) => ({
    source: `warning ${index + 1}`,
    status: "optional",
    reason: warning,
  }));
  const categorySummaries = buildCategorySummaries({
    lessons,
    workflowValues,
    maintenanceValues,
    securityValues,
    blockingItems,
    t,
  });
  const healthSummaries = categorySummaries.filter((category) => category.id !== "overview");

  return (
    <section className="view-surface" id="overview" aria-labelledby="overview-heading">
      <StatusStrip data={data} t={t} locale={locale} />
      <div className="view-header">
        <div>
          <p className="eyebrow">{t("app.snapshot")}</p>
          <h2 id="overview-heading">{t("summary.title")}</h2>
        </div>
        <p>{t("summary.snapshotNotice")}</p>
      </div>
      <div className="overview-grid">
        <article className="primary-panel">
          <div className="panel-title">
            <CheckCircle2 aria-hidden="true" size={20} />
            <h3>{t("summary.nextSafeAction")}</h3>
          </div>
          <p className="next-safe-action">{displayText(summary.next_safe_action)}</p>
          <GuidanceList items={asArray(summary.guidance_items)} t={t} />
          <IssueList title={t("summary.blockingItems")} items={blockingItems} t={t} />
          <IssueList title={t("summary.partialFailures")} items={partialFailures} t={t} />
          <IssueList title={t("summary.warnings")} items={warnings} t={t} />
        </article>
        <div className="health-grid" aria-label={t("aria.categoryHealth")}>
          <h3 className="section-subhead">{t("summary.health")}</h3>
          {healthSummaries.map(({ id, title, status, detail, Icon }) => (
            <HealthCard Icon={Icon} title={title} status={status} detail={detail} href={`#${id}`} t={t} key={id} />
          ))}
        </div>
      </div>
      <ExplorePages categories={categorySummaries} t={t} />
    </section>
  );
}

function LessonCard({ id, lesson, t }) {
  const pointsKey = pickFirst(lesson, ["points", "lesson_points", "concise_points"]);
  const warningsKey = pickFirst(lesson, ["warnings", "lesson_warnings"]);
  const nextKey = pickFirst(lesson, ["next_learning_action", "next_safe_action", "next_action"]);
  return (
    <article className="item-card item-card--lesson">
      <div className="item-card__header">
        <div>
          <span className="item-card__kicker">{displayKey(id)}</span>
          <h3>{displayText(lesson.label, displayKey(id))}</h3>
        </div>
        <StatusPill value={lesson.status} t={t} />
      </div>
      <FieldGrid
        fields={[
          { label: t("field.current"), value: lesson.current_step },
          { label: t("field.learningMode"), value: lesson.learning_mode_status, render: (value) => <StatusPill value={value} t={t} /> },
          { label: t("field.workflowLanguage"), value: lesson.workflow_language_status, render: (value) => <StatusPill value={value} t={t} /> },
          { label: t("field.productLanguage"), value: lesson.product_language_status, render: (value) => <StatusPill value={value} t={t} /> },
          { label: t("field.learnerApproval"), value: lesson.learner_approval_status, render: (value) => <StatusPill value={value} t={t} /> },
          { label: t("field.source"), value: lesson.source_state_file },
        ]}
      />
      {pointsKey ? <CompactList title={t("list.points")} items={asArray(lesson[pointsKey])} /> : null}
      {warningsKey ? <CompactList title={t("list.warnings")} items={asArray(lesson[warningsKey])} /> : null}
      {nextKey ? <p className="next-line">{displayText(lesson[nextKey])}</p> : null}
    </article>
  );
}

function LessonSection({ lessons, t }) {
  return (
    <section className="view-surface" id="lessons" aria-labelledby="lesson-heading">
      <div className="view-header">
        <div>
          <BookOpen aria-hidden="true" size={22} />
          <h2 id="lesson-heading">{t("lessons.title")}</h2>
        </div>
        <p>{t("lessons.description")}</p>
      </div>
      <div className="card-grid">
        {objectEntries(lessons).map(([id, lesson]) => (
          <LessonCard id={id} lesson={lesson || {}} key={id} t={t} />
        ))}
      </div>
    </section>
  );
}

function StatusObjectCard({ id, value, t }) {
  const statusValue = value && typeof value === "object" ? value.status : value;
  const details = value && typeof value === "object" ? value : { status: value };
  const detailFields = objectEntries(details)
    .filter(([key]) => key !== "status")
    .map(([key, fieldValue]) => ({ label: displayKey(key), value: fieldValue }));
  return (
    <article className="item-card">
      <div className="item-card__header">
        <h3>{displayKey(id)}</h3>
        <StatusPill value={statusValue} t={t} />
      </div>
      <FieldGrid fields={detailFields} />
    </article>
  );
}

function WorkflowSection({ development, gitWorkflow, t }) {
  const workflowItems = [
    ...objectEntries(development).map(([id, value]) => [`development.${id}`, value]),
    ...objectEntries(gitWorkflow).map(([id, value]) => [`git_workflow.${id}`, value]),
  ];
  return (
    <section className="view-surface" id="workflow" aria-labelledby="workflow-heading">
      <div className="view-header">
        <div>
          <GitBranch aria-hidden="true" size={22} />
          <h2 id="workflow-heading">{t("workflow.title")}</h2>
        </div>
        <p>{t("workflow.description")}</p>
      </div>
      <div className="card-grid card-grid--dense">
        {workflowItems.map(([id, value]) => (
          <StatusObjectCard id={id} value={value} key={id} t={t} />
        ))}
      </div>
    </section>
  );
}

function MaintenanceSection({ maintenance, data, t }) {
  return (
    <section className="view-surface" id="maintenance" aria-labelledby="maintenance-heading">
      <div className="view-header">
        <div>
          <Wrench aria-hidden="true" size={22} />
          <h2 id="maintenance-heading">{t("maintenance.title")}</h2>
        </div>
        <p>{t("maintenance.description")}</p>
      </div>
      <div className="card-grid card-grid--dense">
        {objectEntries(maintenance).map(([id, value]) => (
          <StatusObjectCard id={id} value={value} key={id} t={t} />
        ))}
      </div>
      <SourceBoundary data={data} t={t} />
    </section>
  );
}

function SecuritySection({ security, t }) {
  return (
    <section className="view-surface" id="safety" aria-labelledby="security-heading">
      <div className="view-header">
        <div>
          <ShieldCheck aria-hidden="true" size={22} />
          <h2 id="security-heading">{t("security.title")}</h2>
        </div>
        <p>{t("security.description")}</p>
      </div>
      <div className="card-grid card-grid--dense">
        {objectEntries(security).map(([id, value]) => (
          <StatusObjectCard id={id} value={value} key={id} t={t} />
        ))}
      </div>
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
        </div>
        <p>{t("actions.description")}</p>
      </div>
      <div className="preview-list">
        {previews.map((preview, index) => (
          <article className="command-preview" key={`${displayText(preview.intent)}-${index}`}>
            <div className="command-preview__head">
              <div>
                <h3>{displayText(preview.intent)}</h3>
                <p>{displayText(preview.target)}</p>
              </div>
              <RiskPill value={preview.risk_level} t={t} />
            </div>
            <FieldGrid
              fields={[
                { label: t("field.approval"), value: preview.requires_approval ? "approval_required" : "optional", render: (value) => <StatusPill value={value} t={t} /> },
                { label: t("field.gate"), value: preview.approval_gate_id },
                { label: t("field.executionMode"), value: preview.execution_mode },
                { label: t("field.executable"), value: preview.non_executable === true ? t("field.no") : t("field.unknown") },
              ]}
            />
            {preview.execution_mode === "preview_only" && preview.non_executable === true ? (
              <code className="command-preview__command">{displayText(preview.command_text)}</code>
            ) : (
              <p className="command-preview__hidden">{t("actions.hidden")}</p>
            )}
          </article>
        ))}
      </div>
    </section>
  );
}

function SafetySection({ security, actions, t }) {
  return (
    <>
      <SecuritySection security={security} t={t} />
      <CommandPreviews actions={actions} t={t} />
    </>
  );
}

function SourceBoundary({ data, t }) {
  return (
    <section className="source-boundary" aria-label={t("aria.dataBoundary")}>
      <span>{t("app.sourceFiles")} {asArray(data.source_files).length}</span>
      <span>{t("app.sourceCommands")} {asArray(data.source_commands).length}</span>
      <span>{t("app.readOnly")}</span>
    </section>
  );
}

function Sidebar({ activeView, t, data, locale, loaded }) {
  const generated = loaded && data.generated_at ? formatDateTime(data.generated_at, locale) : "";
  return (
    <aside className="app-sidebar" aria-label={t("aria.categories")}>
      <div className="brand">
        <FileJson aria-hidden="true" size={28} />
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

export default function App() {
  const [state, setState] = useState({ status: "loading", data: null, error: null });
  const [activeView, setActiveView] = useState(viewFromHash);
  const locale = useMemo(() => resolveLocale(navigator.languages), []);
  const t = useMemo(() => createTranslator(locale), [locale]);

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
    fetchDashboardData()
      .then((data) => {
        if (active) {
          setState({ status: "ready", data, error: null });
        }
      })
      .catch((error) => {
        if (active) {
          setState({ status: "failed", data: null, error });
        }
      });
    return () => {
      active = false;
    };
  }, []);

  const data = state.data || {};
  const loaded = state.status === "ready";
  const mode = useMemo(() => displayText(data.summary?.mode, "unknown"), [data.summary?.mode]);

  return (
    <main className="app-shell">
      <Sidebar activeView={activeView} t={t} data={data} locale={locale} loaded={loaded} />
      <section className="app-main">
        <header className="app-header">
          <div>
            <p className="eyebrow">{t("app.eyebrow")}</p>
            <h1>{t("app.title")}</h1>
          </div>
          <div className="app-header__status">
            <StatusPill value={loaded ? "ready" : state.status} t={t} />
            <span>{displayText(mode)}</span>
          </div>
        </header>

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
        {loaded && activeView === "lessons" ? <LessonSection lessons={data.lessons || {}} t={t} /> : null}
        {loaded && activeView === "workflow" ? <WorkflowSection development={data.development || {}} gitWorkflow={data.git_workflow || {}} t={t} /> : null}
        {loaded && activeView === "maintenance" ? <MaintenanceSection maintenance={data.maintenance || {}} data={data} t={t} /> : null}
        {loaded && activeView === "safety" ? <SafetySection security={data.security || {}} actions={data.actions || {}} t={t} /> : null}
      </section>
    </main>
  );
}
