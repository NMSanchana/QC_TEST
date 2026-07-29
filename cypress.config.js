const { defineConfig } = require("cypress");
const { addCucumberPreprocessorPlugin } = require("@badeball/cypress-cucumber-preprocessor");
const createBundler = require("@bahmutov/cypress-esbuild-preprocessor");
const { createEsbuildPlugin } = require("@badeball/cypress-cucumber-preprocessor/esbuild");

async function setupNodeEvents(on, config) {
  await addCucumberPreprocessorPlugin(on, config);

  on(
    "file:preprocessor",
    createBundler({
      plugins: [createEsbuildPlugin(config)],
    })
  );

  return config;
}

module.exports = defineConfig({
  e2e: {
    baseUrl: "http://localhost:4173",
    specPattern: "cypress/e2e/**/*.feature",
    supportFile: "cypress/support/e2e.js",
    // The real feature file's Update/Delete scenarios depend on records
    // created by an earlier Create scenario in the same run (e.g. "Cash",
    // "Demand Draft" must already exist). Cypress 12+ wipes localStorage
    // between tests by default (testIsolation: true) — turning that off
    // is what makes that dependency actually work here, same as it would
    // need to in the real suite.
    testIsolation: false,
    setupNodeEvents,
    video: false,
  },
});
