const { test, expect } = require("@playwright/test");
const path = require("path");
const fs = require("fs");
const { execFileSync } = require("child_process");

const root = path.resolve(__dirname, "../..");

test("CLI dashboard exposes the main learner views", () => {
  const output = execFileSync(path.join(root, "tools/dashboard"), ["all"], {
    cwd: root,
    encoding: "utf8",
  });

  expect(output).toContain("Lesson Dashboard");
  expect(output).toContain("Menu Readiness");
  expect(output).toContain("Menu prerequisite readiness: 自由開発");
  expect(output).toContain("Workflow display language");
  expect(output).toContain("Product development language");
  expect(output).toContain("Next approval");
  expect(output).toContain("Documentation Map Dashboard");
  expect(output).toContain("Documentation Map Status");
  expect(output).toContain("Illustration Review Dashboard");
});

test("illustration review page renders review shell", async ({ page }) => {
  await page.route("**/illustration-review/index.html", async (route) => {
    await route.fulfill({
      contentType: "text/html",
      body: fs.readFileSync(path.join(root, "illustration-review/index.html"), "utf8"),
    });
  });
  await page.route("**/illustrations/lesson14/index.tsv", async (route) => {
    await route.fulfill({
      contentType: "text/tab-separated-values",
      body: [
        "# step_id\ttopic\tstatus\tasset_path\tlearning_mode\tdisplay_language\tsource_explanation\tsummary\tkey_terms\tgenerated_at\tnote",
        "day2.github-connection\tGitHub connection\trequested\t-\tA\tja\tSSH and gh checks\tShows why GitHub connection matters\tGitHub,SSH,CI\t-\tTest record",
      ].join("\n"),
    });
  });

  await page.goto("http://lesson.local/illustration-review/index.html");
  await expect(page.getByRole("heading", { name: "Lesson Illustration Review" })).toBeVisible();
  await expect(page.locator("#status")).toContainText("1 illustration record");
  await expect(page.getByText("GitHub connection", { exact: true })).toBeVisible();
  await expect(page.getByText("Shows why GitHub connection matters")).toBeVisible();
});
