const { test, expect } = require("@playwright/test");
const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "../..");
const fixturePath = path.join(root, "tests/fixtures/dashboard-control-center.json");
const liveUpdateFixturePath = path.join(root, "tests/fixtures/dashboard-control-center-live-update.json");
const invalidFixturePath = path.join(root, "tests/fixtures/dashboard-control-center-invalid.json");
const buildRoot = path.join(root, "dist/dashboard-control-center");

test.beforeAll(() => {
  const indexPath = path.join(buildRoot, "index.html");
  if (!fs.existsSync(indexPath)) {
    throw new Error("dashboard control-center build output is missing; run npm run dashboard:build before Playwright");
  }
});

async function routeDashboardData(page, fixtures, methods = []) {
  const fixtureList = Array.isArray(fixtures) ? fixtures : [fixtures];
  let requestCount = 0;
  await page.route("**/dashboard-data.json", async (route) => {
    methods.push(route.request().method());
    const selected = fixtureList[Math.min(requestCount, fixtureList.length - 1)];
    requestCount += 1;
    await route.fulfill({
      contentType: "application/json",
      body: fs.readFileSync(selected, "utf8"),
    });
  });
}

async function routeDashboardDataPayload(page, payload, methods = []) {
  await page.route("**/dashboard-data.json", async (route) => {
    methods.push(route.request().method());
    await route.fulfill({
      contentType: "application/json",
      body: JSON.stringify(payload),
    });
  });
}

async function expectCenteredSvg(locator, tolerance = 1) {
  const deltas = await locator.evaluateAll((elements) =>
    elements.map((element) => {
      const svg = element.querySelector("svg");
      const outer = element.getBoundingClientRect();
      const inner = svg.getBoundingClientRect();
      return Math.abs(inner.top + inner.height / 2 - (outer.top + outer.height / 2));
    }),
  );
  expect(deltas.length).toBeGreaterThan(0);
  expect(Math.max(...deltas)).toBeLessThanOrEqual(tolerance);
}

async function openMobileNavLink(page, target) {
  await page.getByRole("button", { name: /^(Menu|メニュー)$/ }).click();
  await page.getByRole("navigation", { name: "Dashboard categories" }).getByRole("link", { name: new RegExp(target) }).click();
}

test.beforeEach(async ({ page }) => {
  await page.route("**/dashboard-control-center/index.html*", async (route) => {
    await route.fulfill({
      contentType: "text/html",
      body: fs.readFileSync(path.join(buildRoot, "index.html"), "utf8"),
    });
  });
  await page.route("**/dashboard-control-center/assets/**", async (route) => {
    const url = new URL(route.request().url());
    const assetName = path.basename(url.pathname);
    const assetPath = path.join(buildRoot, "assets", assetName);
    const contentType = assetName.endsWith(".css") ? "text/css" : "application/javascript";
    await route.fulfill({
      contentType,
      body: fs.readFileSync(assetPath),
    });
  });
  await routeDashboardData(page, fixturePath);
});

test.describe("English dashboard control center", () => {
  test.use({ locale: "en-US" });

  test("renders the mock-source overview and detail surfaces from producer data", async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 980 });
    await page.goto("http://lesson.local/dashboard-control-center/index.html");
    const navigation = page.getByRole("navigation", { name: "Dashboard categories" });

    await expect(page.locator(".brand strong", { hasText: "Repository Control Center" })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Dashboard/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Lessons/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Development Workflow/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Maintenance Sync/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Safety Actions/ })).toBeVisible();
    await expect(page.getByRole("navigation", { name: "Repository" }).locator(".category-nav__link")).toHaveCount(3);
    await expect(page.getByRole("navigation", { name: "Other" }).locator(".category-nav__link")).toHaveCount(2);
    await expect(page.getByText("This dashboard is read-only.")).toBeVisible();

    await expect(page.getByRole("heading", { name: "Dashboard" })).toBeVisible();
    await expect(page.getByText("Category Health")).toHaveCount(0);
    await expect(page.locator(".menu-tile")).toHaveCount(7);
    await expect(page.locator(".menu-tile.is-selected")).toContainText(/STEP 1-14\s*Practical lesson/);
    await expect(page.locator(".menu-tile[data-menu-tile='free-development']")).toContainText("Free Development");
    await expectCenteredSvg(page.locator(".menu-tile__icon"));
    await expect(page.locator(".context-strip__item")).toHaveCount(4);
    await expect(page.locator(".context-strip")).toContainText(/Step\s*12\s*\/\s*14/);
    await expect(page.locator(".context-strip")).toContainText("task-tracker-repository");
    await expectCenteredSvg(page.locator(".context-strip__icon"));
    await expect(page.locator(".overview-status-card")).toHaveCount(4);
    await expectCenteredSvg(page.locator(".overview-status-card__icon"));
    await expect(page.locator("[data-overview-status-card='lessons']")).toContainText(/11\s*\/\s*14/);
    await expect(page.locator("[data-overview-status-card='lessons']")).toContainText("79%");
    await expect(page.locator("[data-overview-status-card='git']")).toContainText("Unconfirmed");
    await expect(page.locator("[data-overview-status-card='security']")).toContainText("Blockers: 1");
    await expect(page.locator(".common-status-card--git .common-status-op")).toHaveCount(4);
    await expectCenteredSvg(page.locator(".common-status-card--git .common-status-op__label"));
    await expect(page.locator(".common-status-card--security")).toContainText("Failures / blockers");
    await expect(page.locator(".common-status-card--security")).toContainText("1");
    await expectCenteredSvg(page.locator(".common-status-card--security .common-status-card__icon"));
    await expect(page.locator(".explore-card")).toHaveCount(4);
    await expect(page.locator(".explore-card", { hasText: "Lessons" })).toContainText("Open");
    await expect(page.getByText("./tools/dashboard lesson")).toHaveCount(0);
    await expect(page.getByText("Preview merge boundary")).toHaveCount(0);

    const overviewCards = await page.locator(".overview-status-card").evaluateAll((cards) =>
      cards.map((card) => {
        const rect = card.getBoundingClientRect();
        return { top: Math.round(rect.top), height: Math.round(rect.height) };
      }),
    );
    const rowTops = [...new Set(overviewCards.map((card) => card.top))];
    expect(rowTops.length).toBeLessThanOrEqual(2);
    for (const top of rowTops) {
      const rowHeights = overviewCards.filter((card) => card.top === top).map((card) => card.height);
      expect(Math.max(...rowHeights) - Math.min(...rowHeights)).toBeLessThanOrEqual(3);
    }

    await navigation.getByRole("link", { name: /Lessons/ }).click();
    await expect(page.getByRole("heading", { name: "Lessons" })).toBeVisible();
    await expect(page.getByLabel("Detail page decision summary")).toBeVisible();
    await expectCenteredSvg(page.locator(".page-title__icon"));
    await expectCenteredSvg(page.locator(".decision-summary__icon"));
    await expect(page.locator(".context-strip")).toContainText(/Step\s*12\s*\/\s*14/);
    await expect(page.locator(".context-strip--lessons .mini-progress-ring--icon")).toHaveCount(1);
    await expect(page.getByText("What this page checks")).toBeVisible();
    await expect(page.getByText("Current judgment")).toBeVisible();
    await expect(page.getByText("Must review")).toBeVisible();
    await expect(page.getByText("Next safe check")).toBeVisible();
    await expect(page.locator(".decision-summary--lessons")).toContainText(/Check\s*Git\/CI status on the workflow page/);
    await expect(page.getByRole("heading", { name: "STEP 1-7 Basic Lesson" })).toBeVisible();
    await expect(page.locator(".lesson-progress-card")).toHaveCount(3);
    await expect(page.getByRole("heading", { name: "Applied Lesson" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Live status (current execution state)" })).toBeVisible();

    await navigation.getByRole("link", { name: /Development Workflow/ }).click();
    await expect(page.getByRole("heading", { name: "Development Workflow" })).toBeVisible();
    await expectCenteredSvg(page.locator(".page-title__icon"));
    await expectCenteredSvg(page.locator(".decision-summary__icon"));
    await expect(page.locator(".operation-chip")).toHaveCount(6);
    await expect(page.locator(".workflow-mini-card")).toHaveCount(5);
    await expectCenteredSvg(page.locator(".workflow-mini-card__icon"));
    await expect(page.getByRole("heading", { name: "Git Sync" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Product Evidence" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Recent workflow execution" })).toBeVisible();
    await expect(page.getByText(/Development\.Product Repository/)).toHaveCount(0);
    await expect(page.getByText("development.git.sync.status")).toHaveCount(0);
    await expect(page.locator(".mock-table-row--workflow")).toHaveCount(5);

    await navigation.getByRole("link", { name: /Maintenance Sync/ }).click();
    await expect(page.getByRole("heading", { name: "Maintenance Sync" })).toBeVisible();
    await expectCenteredSvg(page.locator(".page-title__icon"));
    await expectCenteredSvg(page.locator(".decision-summary__icon"));
    await expectCenteredSvg(page.locator(".maintenance-mini-card__icon"));
    await expect(page.locator(".maintenance-mini-card")).toHaveCount(6);
    await expect(page.locator(".evidence-row")).toHaveCount(6);
    await expect(page.locator(".evidence-row", { hasText: "Execution evidence" })).toContainText("docs/workflow/PRODUCT_GATE_EVIDENCE_SCHEMA.tsv");
    await expect(page.getByText("product_git_sync_live")).toHaveCount(0);
    await expect(page.getByText("git_sync.live")).toHaveCount(0);
    await expect(page.getByText("Information sources for this view")).toBeVisible();
    await expect(page.getByText("tools/dashboard-data")).toBeVisible();

    await navigation.getByRole("link", { name: /Safety Actions/ }).click();
    await expect(page.getByRole("heading", { name: "Safety Actions" })).toBeVisible();
    await expectCenteredSvg(page.locator(".page-title__icon"));
    await expectCenteredSvg(page.locator(".decision-summary__icon"));
    await expectCenteredSvg(page.locator(".security-mini-card__icon"));
    await expect(page.locator(".security-mini-card")).toHaveCount(4);
    const safetyCardIconBackgrounds = await page.locator(".security-mini-card__icon").evaluateAll((icons) => icons.map((icon) => getComputedStyle(icon).backgroundColor));
    expect(safetyCardIconBackgrounds.every((background) => background !== "rgba(0, 0, 0, 0)")).toBe(true);
    await expect(page.locator("#partial-failures-heading")).toBeVisible();
    await expect(page.locator(".failure-row")).toHaveCount(1);
    await expect(page.locator(".failure-row", { hasText: "Required product evidence has not run." })).toBeVisible();
    await expect(page.getByText("security_gate")).toHaveCount(0);
    await expect(page.getByRole("heading", { name: "Command Previews (display only)" })).toBeVisible();
    await expect(page.locator(".display-only-badge").first()).toContainText("Display only");
    await expect(page.getByText("preview_only")).toHaveCount(0);
    await expect(page.getByText("git_workflow_merge_approval")).toHaveCount(0);
    await expect(page.locator(".command-preview")).toHaveCount(4);
    await expect(page.locator(".command-preview .command-chip")).toHaveCount(4);
    await expect(page.getByRole("button", { name: /^(Run|Execute|Apply|Merge|Push|Check)$/i })).toHaveCount(0);
    await expect(page.locator("[data-state='approval_required']").first()).toBeVisible();
  });

  test("keeps unsafe text as data across desktop and mobile layout", async ({ page }) => {
    await page.setViewportSize({ width: 1100, height: 900 });
    await page.goto("http://lesson.local/dashboard-control-center/index.html");
    await expect(page.getByRole("heading", { name: "Explore Pages" })).toBeVisible();
    const hasMidWidthOverflow = await page.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth);
    expect(hasMidWidthOverflow).toBe(false);

    await page.setViewportSize({ width: 390, height: 920 });
    await page.goto("http://lesson.local/dashboard-control-center/index.html");

    await expect(page.locator(".menu-tile")).toHaveCount(7);
    await expect(page.locator(".overview-status-card")).toHaveCount(4);
    await expect(page.locator(".explore-card")).toHaveCount(4);
    const hasHorizontalOverflow = await page.locator(".app-shell").evaluate((element) => element.scrollWidth > element.clientWidth);
    expect(hasHorizontalOverflow).toBe(false);

    for (const target of ["Lessons", "Development Workflow", "Maintenance Sync", "Safety Actions"]) {
      await openMobileNavLink(page, target);
      await expect(page.getByLabel("Detail page decision summary")).toBeVisible();
      const hasDetailOverflow = await page.locator(".app-shell").evaluate((element) => element.scrollWidth > element.clientWidth);
      expect(hasDetailOverflow).toBe(false);
    }

    await page.setViewportSize({ width: 1280, height: 900 });
    await page.getByRole("navigation", { name: "Dashboard categories" }).getByRole("link", { name: /Maintenance Sync/ }).click();
    await expect(page.getByText("Information sources for this view")).toBeVisible();
    await expect(page.getByText("[redacted secret-like data]", { exact: false })).toHaveCount(0);
    await expect(page.getByText("TOKEN=abcdefghijklmnop", { exact: false })).toHaveCount(0);
  });

  test("updates changed dashboard data without reloading the page", async ({ page }) => {
    const methods = [];
    await page.unroute("**/dashboard-data.json");
    await routeDashboardData(page, [fixturePath, liveUpdateFixturePath], methods);

    await page.setViewportSize({ width: 1440, height: 980 });
    await page.goto("http://lesson.local/dashboard-control-center/index.html?refresh_ms=100");
    await expect(page.locator("[data-overview-status-card='lessons']")).toContainText(/11\s*\/\s*14/);
    await page.evaluate(() => {
      window.__dashboardReloadMarker = "kept";
    });

    await expect(page.locator("[data-overview-status-card='lessons']")).toContainText(/11\s*\/\s*14/);
    await expect(page.locator("[data-overview-status-card='security']")).toContainText("Ready");
    await expect(page.locator(".common-status-card--security")).toContainText("None");
    await expect(page.locator(".explore-card", { hasText: "Lessons" })).toContainText("Open");
    await expect.poll(() => page.evaluate(() => window.__dashboardReloadMarker)).toBe("kept");
    expect(methods.every((method) => method === "GET")).toBe(true);
  });

  test("keeps last known good data when a refresh fails validation", async ({ page }) => {
    const methods = [];
    await page.unroute("**/dashboard-data.json");
    await routeDashboardData(page, [fixturePath, invalidFixturePath, invalidFixturePath, liveUpdateFixturePath], methods);

    await page.setViewportSize({ width: 1280, height: 900 });
    await page.goto("http://lesson.local/dashboard-control-center/index.html?refresh_ms=100");
    await expect(page.locator("[data-overview-status-card='lessons']")).toContainText(/11\s*\/\s*14/);
    await expect(page.locator("[data-overview-status-card='lessons']")).toContainText(/11\s*\/\s*14/);
    await expect(page.locator("[data-overview-status-card='security']")).toContainText("Ready");
    expect(methods.every((method) => method === "GET")).toBe(true);
    expect(methods.length).toBeGreaterThanOrEqual(4);
  });

  test("does not duplicate ready workflow items in the must-review section", async ({ page }) => {
    const readyWorkflow = JSON.parse(fs.readFileSync(fixturePath, "utf8"));
    readyWorkflow.selected_context = {
      ...readyWorkflow.selected_context,
      git_status: "ready",
      ci_status: "ready",
      security_status: "ready",
      evidence_status: "ready",
      blockers: [],
    };
    readyWorkflow.contexts_by_menu = {
      ...readyWorkflow.contexts_by_menu,
      [readyWorkflow.selected_context.menu_id]: readyWorkflow.selected_context,
    };
    readyWorkflow.partial_failures = [];
    readyWorkflow.summary.category_metrics.workflow = {
      ...readyWorkflow.summary.category_metrics.workflow,
      healthy: 8,
      warning: 0,
      problem: 0,
      percent: 100,
      status: "ready",
    };
    readyWorkflow.development = {
      ...readyWorkflow.development,
      product_repository: { status: "ready", configured_name: "example-product" },
      product_authority: {
        ...readyWorkflow.development.product_authority,
        status: "ready",
        evidence_summary: {
          ...readyWorkflow.development.product_authority.evidence_summary,
          index_status: "ready",
          items: readyWorkflow.development.product_authority.evidence_summary.items.map((item) => ({
            ...item,
            status: "passed",
            freshness_state: "current",
            authority: "authoritative",
          })),
        },
        product_operation_blockers: [],
      },
      documents: { status: "ready" },
      git_sync_status: "ready",
      ci_status: "ready",
    };
    readyWorkflow.git_workflow = {
      policy_status: "ready",
      settings_status: "ready",
      gate_status: "ready",
      approval_status: "ready",
    };

    await page.unroute("**/dashboard-data.json");
    await routeDashboardDataPayload(page, readyWorkflow);
    await page.goto("http://lesson.local/dashboard-control-center/index.html#workflow");

    await expect(page.locator(".decision-summary--workflow")).toContainText("Ready");
    await expect(page.locator(".workflow-mini-card")).toHaveCount(5);
    await expect(page.locator(".mock-table-row--workflow")).toHaveCount(5);
  });
});

test.describe("Japanese dashboard control center", () => {
  test.use({ locale: "ja-JP" });

  test("uses device language for fixed UI labels while preserving producer data text", async ({ page }) => {
    await page.goto("http://lesson.local/dashboard-control-center/index.html");
    const navigation = page.getByRole("navigation", { name: "ダッシュボードカテゴリ" });

    await expect(navigation.getByRole("link", { name: /ダッシュボード/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /レッスン/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /開発ワークフロー/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /保守・同期/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /安全確認/ })).toBeVisible();
    await expect(page.getByText("このダッシュボードは読み取り専用です。")).toBeVisible();
    await expect(page.getByText("カテゴリ別の状態")).toHaveCount(0);
    await expect(page.locator(".menu-tile.is-selected")).toContainText(/STEP 1-14\s*実践レッスン/);
    await expect(page.locator("[data-overview-status-card='lessons']")).toContainText(/11\s*\/\s*14/);
    await expect(page.locator("[data-overview-status-card='security']")).toContainText("ブロッカー: 1");
    await expect(page.locator(".common-status-card--security")).toContainText("Security確認");
    await expect(page.locator(".common-status-card--git .common-status-op")).toHaveCount(4);

    await navigation.getByRole("link", { name: /レッスン/ }).click();
    await expect(page.getByLabel("詳細ページ判断サマリー")).toBeVisible();
    await expect(page.getByText("このページで確認すること")).toBeVisible();
    await expect(page.getByRole("heading", { name: "STEP 1-7 基礎レッスン" })).toBeVisible();
    await expect(page.locator(".lesson-progress-card")).toHaveCount(3);
    await expect(page.getByRole("heading", { name: "応用レッスン" })).toBeVisible();

    await navigation.getByRole("link", { name: /開発ワークフロー/ }).click();
    await expect(page.getByLabel("詳細ページ判断サマリー")).toBeVisible();
    await expect(page.locator(".workflow-mini-card")).toHaveCount(5);
    await expect(page.getByRole("heading", { name: "Product Evidence" })).toBeVisible();
    await expect(page.getByText(/Development\.Product Repository/)).toHaveCount(0);

    await navigation.getByRole("link", { name: /保守・同期/ }).click();
    await expect(page.getByRole("heading", { name: "同期と確認記録" })).toBeVisible();
    await expect(page.locator(".evidence-row")).toHaveCount(6);
    await expect(page.getByText("実行証跡", { exact: true })).toBeVisible();
    await expect(page.getByText("product_ci_live")).toHaveCount(0);

    await navigation.getByRole("link", { name: /安全確認/ }).click();
    await expect(page.getByLabel("詳細ページ判断サマリー")).toBeVisible();
    await expect(page.getByRole("heading", { name: "コマンドプレビュー（表示専用）" })).toBeVisible();
    await expect(page.locator(".display-only-badge").first()).toContainText("表示専用");
    await expect(page.locator(".command-preview")).toHaveCount(4);
    await expect(page.locator(".command-preview .command-chip")).toHaveCount(4);
  });
});
