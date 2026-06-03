// @ts-check
const { defineConfig } = require("@playwright/test");

const rawWorkers = Number.parseInt(process.env.PLAYWRIGHT_WORKERS || "1", 10);
const workers = Number.isFinite(rawWorkers) && rawWorkers > 0 ? rawWorkers : 1;

module.exports = defineConfig({
  testDir: "./tests/playwright",
  workers,
  use: {
    browserName: "chromium",
  },
});
