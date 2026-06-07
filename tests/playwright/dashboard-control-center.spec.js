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

async function expectCenteredText(locator, tolerance = 1) {
  const delta = await locator.evaluate((element) => {
    const range = document.createRange();
    range.selectNodeContents(element);
    const outer = element.getBoundingClientRect();
    const inner = range.getBoundingClientRect();
    return Math.abs(inner.top + inner.height / 2 - (outer.top + outer.height / 2));
  });
  expect(delta).toBeLessThanOrEqual(tolerance);
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

  test("renders categorized overview and isolates command previews", async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 980 });
    await page.goto("http://lesson.local/dashboard-control-center/index.html");
    const navigation = page.getByRole("navigation", { name: "Dashboard categories" });

    await expect(page.locator(".brand strong", { hasText: "Repository Control Center" })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Dashboard/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Lessons/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Development Workflow/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Maintenance Sync/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Safety Actions/ })).toBeVisible();

    await expect(page.getByLabel("Dashboard snapshot status").getByText("Read-only")).toBeVisible();
    await expect(page.getByText("This dashboard shows a read-only snapshot.")).toHaveCount(0);
    await expect(page.getByText("Next safe action")).toBeVisible();
    await expect(page.locator(".next-action-panel__head > svg[aria-hidden='true']")).toBeVisible();
    await expect(page.getByText("Review lessons and accept for workflow")).toBeVisible();
    await expect(page.locator(".primary-action-card")).toContainText("Review lessons and accept for workflow");
    await expect(page.locator(".primary-action-card").getByText("Target")).toHaveCount(0);
    await expect(page.locator(".action-meta-row > svg[aria-hidden='true']")).toHaveCount(3);
    await expect(page.locator(".action-meta")).toContainText("Target");
    await expect(page.locator(".action-meta")).toContainText("Expected Result");
    await expect(page.locator(".action-meta")).toContainText("Risk");
    const primaryActionHeight = await page.locator(".primary-action-card").evaluate((element) => element.getBoundingClientRect().height);
    expect(primaryActionHeight).toBeLessThan(330);
    await expect(page.getByText("Partial Failures")).toBeVisible();
    const partialFailures = page.locator(".issue-summary", { hasText: "Partial Failures" });
    await expect(partialFailures.locator(".issue")).toHaveCount(1);
    await expect(partialFailures.locator("code")).toHaveCount(0);
    await expect(page.getByText("security_gate")).toHaveCount(0);
    await expect(page.getByRole("button", { name: "View all issues" })).toHaveCount(0);
    await expect(page.locator(".issue-summary", { hasText: "Manual Follow-ups" })).toBeVisible();
    await expect(page.getByText("This repository control panel is read-only.")).toBeVisible();
    await expect(page.getByText("Category Health")).toHaveCount(0);
    await expect(page.getByRole("region", { name: "Category health" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Lesson Health" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Workflow Health" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Explore Pages" })).toBeVisible();
    await expect(page.getByLabel("Dashboard snapshot status").getByText("Read-only")).toBeVisible();
    await expect(page.getByText("Last updated")).toBeVisible();
    await expect(page.locator(".status-strip__item")).toHaveCount(4);
    await expect(page.locator(".status-strip__item > svg[aria-hidden='true']")).toHaveCount(4);
    await expect(navigation.locator("svg[aria-hidden='true']")).toHaveCount(5);
    await expect(navigation.getByRole("link", { name: /Development Workflow/ }).locator("[data-workflow-category-icon='true']")).toBeVisible();
    await expect(page.locator(".health-card")).toHaveCount(4);
    await expect(page.locator(".metric-ring")).toHaveCount(4);
    await expect(page.locator(".health-card__head > svg[aria-hidden='true']")).toHaveCount(4);
    const healthRingColors = await page.locator(".health-card").evaluateAll((cards) =>
      cards.map((card) => getComputedStyle(card).getPropertyValue("--metric-color").trim()),
    );
    expect(healthRingColors.every(Boolean)).toBe(true);
    expect(new Set(healthRingColors).size).toBe(4);
    await expect(page.locator(".issue-summary", { hasText: "Partial Failures" }).locator(".issue-preview__head > div > svg[aria-hidden='true']")).toBeVisible();
    await expect(page.locator(".issue-summary", { hasText: "Manual Follow-ups" }).locator(".issue-preview__head > div > svg[aria-hidden='true']")).toBeVisible();
    await expect(page.locator(".health-card", { hasText: "Lesson Health" }).locator(".metric-ring")).toContainText("66%");
    await expect(page.locator(".health-card", { hasText: "Workflow Health" }).locator(".metric-ring")).toContainText("62%");
    await expect(page.locator(".explore-card")).toHaveCount(5);
    await expect(page.locator(".explore-card", { hasText: "Lesson Health" }).locator(".explore-card__count")).toContainText("3 items");
    await expect(page.locator(".explore-card", { hasText: "Lesson Health" }).locator(".explore-card__meta strong")).toContainText("66%");
    const healthCards = await page.locator(".health-card").evaluateAll((cards) =>
      cards.map((card) => {
        const rect = card.getBoundingClientRect();
        return { top: Math.round(rect.top), left: Math.round(rect.left) };
      }),
    );
    expect(Math.abs(healthCards[0].top - healthCards[1].top)).toBeLessThanOrEqual(3);
    expect(healthCards[2].top).toBeGreaterThan(healthCards[0].top);
    expect(healthCards[1].left).toBeGreaterThan(healthCards[0].left);
    const healthCardHeights = await page.locator(".health-card").evaluateAll((cards) => cards.map((card) => Math.round(card.getBoundingClientRect().height)));
    expect(Math.abs(healthCardHeights[0] - healthCardHeights[1])).toBeLessThanOrEqual(3);
    expect(Math.abs(healthCardHeights[2] - healthCardHeights[3])).toBeLessThanOrEqual(3);
    await expect(page.getByText("./tools/dashboard lesson")).toHaveCount(0);
    await expect(page.getByText("Preview merge boundary")).toHaveCount(0);

    await navigation.getByRole("link", { name: /Lessons/ }).click();
    await expect(page.getByRole("heading", { name: "Lessons" })).toBeVisible();
    await expect(page.getByLabel("Detail page decision summary")).toBeVisible();
    await expectCenteredSvg(page.locator(".decision-summary__icon"));
    await expectCenteredSvg(page.locator(".detail-page-header__icon"));
    await expect(page.getByText("What this page checks")).toBeVisible();
    await expect(page.getByText("Current judgment")).toBeVisible();
    await expect(page.getByText("Must review")).toBeVisible();
    await expect(page.getByText("Next safe check")).toBeVisible();
    await expect(page.locator(".decision-summary__cta", { hasText: "Open workflow page" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Foundation Lesson" })).toBeVisible();
    await expect(page.locator(".lesson-panel")).toHaveCount(2);
    await expect(page.locator(".lesson-panel").first().locator(".lesson-row__label", { hasText: "Points" })).toBeVisible();
    await expect(page.locator(".lesson-panel").first().locator(".lesson-row__label", { hasText: "Warnings" })).toBeVisible();
    await expect(page.locator(".lesson-callout").first()).toBeVisible();

    await navigation.getByRole("link", { name: /Development Workflow/ }).click();
    await expect(page.getByRole("heading", { name: "Development Workflow" })).toBeVisible();
    await expect(page.getByLabel("Detail page decision summary")).toBeVisible();
    await expectCenteredSvg(page.locator(".decision-summary__icon"));
    await expectCenteredSvg(page.locator(".detail-page-header__icon"));
    await expect(page.getByRole("heading", { name: "Must Review First" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Ready Items" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Product Repository" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Approval" })).toBeVisible();
    await expect(page.getByText(/Development\.Product Repository/)).toHaveCount(0);
    await expect(page.getByText("development.git.sync.status")).toHaveCount(0);
    await expect(page.getByText("git_sync")).toBeVisible();
    await expect(page.locator("[data-workflow-category-icon='true']")).toHaveCount(5);
    await expect(page.locator(".decision-summary__cta", { hasText: "Open safety page" })).toBeVisible();
    await expect(page.locator(".detail-row")).toHaveCount(8);

    await navigation.getByRole("link", { name: /Maintenance Sync/ }).click();
    await expect(page.getByLabel("Detail page decision summary")).toBeVisible();
    await expectCenteredSvg(page.locator(".decision-summary__icon"));
    await expectCenteredSvg(page.locator(".detail-page-header__icon"));
    await expectCenteredSvg(page.locator(".detail-card__icon"));
    await expect(page.getByRole("heading", { name: "Manual Confirmation Flow" })).toBeVisible();
    await expect(page.locator(".decision-summary__cta", { hasText: "Open confirmation flow" })).toBeVisible();
    await expect(page.locator(".confirmation-row")).toHaveCount(3);
    await expect(page.getByText("product_git_sync_live")).toHaveCount(0);
    await expect(page.getByText("git_sync.live")).toBeVisible();
    await expect(page.getByText("./tools/check_ci_status.sh --product --required")).toBeVisible();

    await navigation.getByRole("link", { name: /Safety Actions/ }).click();
    await expect(page.getByRole("heading", { name: "Safety Actions" })).toBeVisible();
    await expect(page.getByLabel("Detail page decision summary")).toBeVisible();
    await expectCenteredSvg(page.locator(".decision-summary__icon"));
    await expectCenteredSvg(page.locator(".detail-page-header__icon"));
    await expectCenteredSvg(page.locator(".detail-card__icon"));
    await expect(page.getByRole("heading", { name: "Partial Failures" })).toBeVisible();
    await expect(page.locator(".decision-summary__cta", { hasText: "Open Partial Failures" })).toBeVisible();
    await expect(page.getByText("Security gate violation")).toBeVisible();
    await expect(page.getByText("security_gate")).toHaveCount(0);
    await expect(page.getByText("safety.gate.blocked")).toBeVisible();
    await expect(page.getByRole("heading", { name: "Command Previews" })).toBeVisible();
    await expect(page.locator(".display-only-badge").first()).toContainText("Display only");
    await expect(page.getByText("preview_only")).toHaveCount(0);
    await expect(page.getByText("git_workflow_merge_approval")).toHaveCount(0);
    await expect(page.locator(".command-preview")).toHaveCount(2);
    await expect(page.locator(".command-preview .command-chip")).toHaveCount(2);

    await expect(page.getByRole("button", { name: /Run|Execute|Apply|Merge|Push|Check/i })).toHaveCount(0);
    await expect(page.locator("[data-risk='critical']")).toBeVisible();
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

    await expect(page.getByText("[redacted secret-like data]", { exact: false })).toBeVisible();
    await expect(page.getByText("TOKEN=abcdefghijklmnop", { exact: false })).toHaveCount(0);
    await expect(page.locator(".explore-card")).toHaveCount(5);
    await expect(page.locator(".metric-ring").first()).toBeVisible();
    const hasHorizontalOverflow = await page.locator(".app-shell").evaluate((element) => element.scrollWidth > element.clientWidth);
    expect(hasHorizontalOverflow).toBe(false);
    for (const target of ["Lessons", "Development Workflow", "Maintenance Sync", "Safety Actions"]) {
      await page.getByRole("navigation", { name: "Dashboard categories" }).getByRole("link", { name: new RegExp(target) }).click();
      await expect(page.getByLabel("Detail page decision summary")).toBeVisible();
      const hasDetailOverflow = await page.locator(".app-shell").evaluate((element) => element.scrollWidth > element.clientWidth);
      expect(hasDetailOverflow).toBe(false);
    }

    await page.setViewportSize({ width: 1280, height: 900 });
    await page.getByRole("navigation", { name: "Dashboard categories" }).getByRole("link", { name: /Maintenance Sync/ }).click();
    await expect(page.getByRole("heading", { name: "Maintenance Sync" })).toBeVisible();
  });

  test("updates changed dashboard data without reloading the page", async ({ page }) => {
    const methods = [];
    await page.unroute("**/dashboard-data.json");
    await routeDashboardData(page, [fixturePath, liveUpdateFixturePath], methods);

    await page.setViewportSize({ width: 1440, height: 980 });
    await page.goto("http://lesson.local/dashboard-control-center/index.html?refresh_ms=100");
    await expect(page.locator(".health-card", { hasText: "Lesson Health" }).locator(".metric-ring")).toContainText("66%");
    await page.evaluate(() => {
      window.__dashboardReloadMarker = "kept";
    });

    await expect(page.locator(".health-card", { hasText: "Lesson Health" }).locator(".metric-ring")).toContainText("100%");
    await expect(page.locator(".issue-summary", { hasText: "Partial Failures" })).toContainText("None");
    await expect(page.locator(".explore-card", { hasText: "Lesson Health" }).locator(".explore-card__count")).toContainText("4 items");
    await expect.poll(() => page.evaluate(() => window.__dashboardReloadMarker)).toBe("kept");
    expect(methods.every((method) => method === "GET")).toBe(true);
  });

  test("keeps last known good data when a refresh fails validation", async ({ page }) => {
    await page.unroute("**/dashboard-data.json");
    await routeDashboardData(page, [fixturePath, invalidFixturePath, invalidFixturePath, liveUpdateFixturePath]);

    await page.setViewportSize({ width: 1280, height: 900 });
    await page.goto("http://lesson.local/dashboard-control-center/index.html?refresh_ms=100");
    await expect(page.locator(".health-card", { hasText: "Lesson Health" }).locator(".metric-ring")).toContainText("66%");
    await expect(page.getByText("Latest snapshot is unavailable")).toBeVisible();
    await expect(page.locator(".health-card", { hasText: "Lesson Health" }).locator(".metric-ring")).toContainText("66%");
    await expect(page.locator(".health-card", { hasText: "Lesson Health" }).locator(".metric-ring")).toContainText("100%");
  });

  test("does not duplicate ready workflow items in the must-review section", async ({ page }) => {
    const readyWorkflow = JSON.parse(fs.readFileSync(fixturePath, "utf8"));
    readyWorkflow.summary.category_metrics.workflow = {
      ...readyWorkflow.summary.category_metrics.workflow,
      healthy: 8,
      warning: 0,
      problem: 0,
      percent: 100,
      status: "ready",
    };
    readyWorkflow.development = {
      product_repository: { status: "ready", configured_name: "example-product" },
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

    const mustReview = page.locator("#workflow-review");
    await expect(mustReview.getByRole("heading", { name: "Must Review First" })).toBeVisible();
    await expect(mustReview.locator("[data-detail-row]")).toHaveCount(0);
    await expect(mustReview).toContainText("No required review");
    await expect(page.locator("#workflow-ready [data-detail-row]")).toHaveCount(8);
  });
});

test.describe("Japanese dashboard control center", () => {
  test.use({ locale: "ja-JP" });

  test("uses device language for fixed UI labels while preserving data text", async ({ page }) => {
    await page.goto("http://lesson.local/dashboard-control-center/index.html");
    const navigation = page.getByRole("navigation", { name: "ダッシュボードカテゴリ" });

    await expect(navigation.getByRole("link", { name: /ダッシュボード/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /レッスン/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /開発ワークフロー/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /保守・同期/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /安全確認/ })).toBeVisible();
    await expect(page.getByLabel("ダッシュボードスナップショット状態").getByText("読み取り専用")).toBeVisible();
    await expect(page.getByText("この画面は読み取り専用のスナップショットです。")).toHaveCount(0);
    await expect(page.getByText("カテゴリ別の状態")).toHaveCount(0);
    await expect(page.getByRole("region", { name: "カテゴリ別の状態" }).getByText(/ワークフロー項目/)).toBeVisible();
    await expect(page.getByRole("heading", { name: "ページを確認" })).toBeVisible();
    await expect(page.getByText("最終更新")).toBeVisible();
    await expectCenteredText(page.locator(".action-meta .risk", { hasText: "低" }).first());
    await expect(page.getByText("このリポジトリ管理パネルは読み取り専用です。", { exact: false })).toBeVisible();
    const manualFollowups = page.locator(".issue-summary", { hasText: "手動確認事項" });
    await expect(manualFollowups).toContainText("ライブCI状態");
    await expect(manualFollowups).not.toContainText("product_ci_live");
    await expect(manualFollowups).not.toContainText("product_git_sync_live");

    await navigation.getByRole("link", { name: /レッスン/ }).click();
    await expect(page.getByLabel("詳細ページ判断サマリー")).toBeVisible();
    await expect(page.getByText("このページで確認すること")).toBeVisible();
    await expect(page.getByRole("heading", { name: "Foundation Lesson" })).toBeVisible();

    await navigation.getByRole("link", { name: /開発ワークフロー/ }).click();
    await expect(page.getByLabel("詳細ページ判断サマリー")).toBeVisible();
    await expect(page.getByRole("heading", { name: "成果物リポジトリ" })).toBeVisible();
    await expect(page.getByText(/Development\.Product Repository/)).toHaveCount(0);

    await navigation.getByRole("link", { name: /安全確認/ }).click();
    await expect(page.getByLabel("詳細ページ判断サマリー")).toBeVisible();
    await expect(page.getByRole("heading", { name: "コマンドプレビュー" })).toBeVisible();
    await expect(page.locator(".display-only-badge").first()).toContainText("表示専用");
    await expect(page.locator(".command-preview .command-chip")).toHaveCount(2);
  });
});
