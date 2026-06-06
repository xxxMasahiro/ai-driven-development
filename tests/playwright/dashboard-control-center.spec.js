const { test, expect } = require("@playwright/test");
const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "../..");
const fixturePath = path.join(root, "tests/fixtures/dashboard-control-center.json");
const buildRoot = path.join(root, "dist/dashboard-control-center");

test.beforeAll(() => {
  const indexPath = path.join(buildRoot, "index.html");
  if (!fs.existsSync(indexPath)) {
    throw new Error("dashboard control-center build output is missing; run npm run dashboard:build before Playwright");
  }
});

test.beforeEach(async ({ page }) => {
  await page.route("**/dashboard-control-center/index.html", async (route) => {
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
  await page.route("**/dashboard-data.json", async (route) => {
    await route.fulfill({
      contentType: "application/json",
      body: fs.readFileSync(fixturePath, "utf8"),
    });
  });
});

test.describe("English dashboard control center", () => {
  test.use({ locale: "en-US" });

  test("renders categorized overview and isolates command previews", async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 980 });
    await page.goto("http://lesson.local/dashboard-control-center/index.html");
    const navigation = page.getByRole("navigation", { name: "Dashboard categories" });

    await expect(page.getByRole("heading", { name: "Dashboard Control Center" })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Overview/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Lessons/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Development Workflow/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Maintenance Sync/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /Safety Actions/ })).toBeVisible();

    await expect(page.getByRole("heading", { name: "Overview" })).toBeVisible();
    await expect(page.getByText("Next safe action")).toBeVisible();
    await expect(page.getByText("Category Health")).toBeVisible();
    await expect(page.getByRole("heading", { name: "Lesson Health" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Workflow Health" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Explore Pages" })).toBeVisible();
    await expect(page.getByLabel("Dashboard snapshot status").getByText("Read-only")).toBeVisible();
    await expect(page.getByText("Last updated")).toBeVisible();
    await expect(page.locator(".status-strip__item")).toHaveCount(4);
    await expect(page.locator(".health-card")).toHaveCount(4);
    await expect(page.locator(".explore-card")).toHaveCount(5);
    const healthCards = await page.locator(".health-card").evaluateAll((cards) =>
      cards.map((card) => {
        const rect = card.getBoundingClientRect();
        return { top: Math.round(rect.top), left: Math.round(rect.left) };
      }),
    );
    expect(Math.abs(healthCards[0].top - healthCards[1].top)).toBeLessThanOrEqual(3);
    expect(healthCards[2].top).toBeGreaterThan(healthCards[0].top);
    expect(healthCards[1].left).toBeGreaterThan(healthCards[0].left);
    await expect(page.getByText("./tools/dashboard lesson")).toHaveCount(0);
    await expect(page.getByText("Preview merge boundary")).toHaveCount(0);

    await navigation.getByRole("link", { name: /Lessons/ }).click();
    await expect(page.getByRole("heading", { name: "Lesson Surface" })).toBeVisible();
    await expect(page.getByText("Foundation Lesson")).toBeVisible();
    await expect(page.locator(".item-card--lesson")).toHaveCount(2);
    await expect(page.locator(".item-card--lesson").first().getByText("Points")).toBeVisible();
    await expect(page.locator(".item-card--lesson").first().getByText("Warnings")).toBeVisible();

    await navigation.getByRole("link", { name: /Development Workflow/ }).click();
    await expect(page.getByRole("heading", { name: "Workflow Surface" })).toBeVisible();
    await expect(page.getByText(/Development\.Product Repository/)).toBeVisible();
    await expect(page.getByText(/Git Workflow\.Approval Status/)).toBeVisible();

    await navigation.getByRole("link", { name: /Safety Actions/ }).click();
    await expect(page.getByRole("heading", { name: "Security Surface" })).toBeVisible();
    await expect(page.getByRole("heading", { name: "Command Previews" })).toBeVisible();
    await expect(page.locator(".command-preview")).toHaveCount(2);
    await expect(page.locator(".command-preview__command")).toHaveCount(2);

    await expect(page.getByRole("button")).toHaveCount(0);
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
    const hasHorizontalOverflow = await page.locator(".app-shell").evaluate((element) => element.scrollWidth > element.clientWidth);
    expect(hasHorizontalOverflow).toBe(false);

    await page.setViewportSize({ width: 1280, height: 900 });
    await page.getByRole("navigation", { name: "Dashboard categories" }).getByRole("link", { name: /Maintenance Sync/ }).click();
    await expect(page.getByRole("heading", { name: "Maintenance Surface" })).toBeVisible();
  });
});

test.describe("Japanese dashboard control center", () => {
  test.use({ locale: "ja-JP" });

  test("uses device language for fixed UI labels while preserving data text", async ({ page }) => {
    await page.goto("http://lesson.local/dashboard-control-center/index.html");
    const navigation = page.getByRole("navigation", { name: "ダッシュボードカテゴリ" });

    await expect(navigation.getByRole("link", { name: /概要/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /レッスン/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /開発ワークフロー/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /保守・同期/ })).toBeVisible();
    await expect(navigation.getByRole("link", { name: /安全確認/ })).toBeVisible();
    await expect(page.getByLabel("ダッシュボードスナップショット状態").getByText("読み取り専用")).toBeVisible();
    await expect(page.getByLabel("カテゴリ別の状態").getByText(/ワークフロー項目/)).toBeVisible();
    await expect(page.getByRole("heading", { name: "ページを確認" })).toBeVisible();
    await expect(page.getByText("最終更新")).toBeVisible();

    await navigation.getByRole("link", { name: /レッスン/ }).click();
    await expect(page.getByText("Foundation Lesson")).toBeVisible();

    await navigation.getByRole("link", { name: /安全確認/ }).click();
    await expect(page.getByRole("heading", { name: "Command Previews" })).toBeVisible();
    await expect(page.locator(".command-preview__command")).toHaveCount(2);
  });
});
