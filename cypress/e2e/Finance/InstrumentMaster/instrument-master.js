const { Given, When, Then } = require("@badeball/cypress-cucumber-preprocessor");

// NOTE: this is a SIMPLIFIED page-object approach for the local demo mock
// page (plain <select>/<input>/checkbox controls) — it does not use the
// real production Common.js's ag-grid/PicklistSearchBar/Material-dialog
// methods, since the mock page doesn't replicate that UI. The step text
// below matches the real feature file exactly; only the underlying
// selector logic is simplified. See cypress/pageObject/Common.js for
// where the real methods would plug back in against the live app.

Given('I navigate through the following path {string} -> {string}', (module, screen) => {
  cy.visit("/instrument-master.html");
});

Given('I enter {string} in the {string} name field', (value, field) => {
  if (!value) return;
  cy.get(`[data-cy="${field}"]`).clear().type(value);
});

Given('I select {string} from the {string} ComboBox field', (value, field) => {
  if (!value) return;
  cy.get(`[data-cy="${field}"]`).select(value);
});

Given('I select {string} in the {string} picklist field', (value, field) => {
  if (!value) return;
  cy.get(`[data-cy="${field}"]`).select(value);
});

Given('I select {string} for {string} radioBox field', (value, field) => {
  if (!value) return;
  cy.get(`[data-cy="${field}"] input[value="${value}"]`).click({ force: true });
});

Given('I enter {string} in the {string} input field', (value, field) => {
  if (!value) return;
  cy.get(`[data-cy="${field}"]`).clear().type(value);
});

Given('I select checkbox {string} in the {string} picklist field', (value, field) => {
  if (!value) return;
  cy.get(`[data-cy="${field}"] input[value="${value}"]`).click({ force: true });
});

Given('I click the {string} button', (label) => {
  cy.get(`[data-cy="${label}"]`).click();
});

Then('I should see the validation message {string}', (message) => {
  cy.get('[data-cy="ValidationDialog"]').should("be.visible").and("contain.text", message);
});

Then('I should see a confirmation message {string}', (message) => {
  cy.get('[data-cy="ValidationDialog"]').should("be.visible").and("contain.text", message);
});

Given('I retrieve the saved form value {string} from the name field {string}', (name, field) => {
  cy.get(`[data-cy="SavedRecord-${name}"]`).click();
});

Given('I update the {string} input field with {string}', (field, value) => {
  cy.get(`[data-cy="${field}"]`).clear().type(value);
});

Then(
  'I verify that the existing {string} is successfully deleted, and the {string} picklist does not contain the deleted value',
  (name, field) => {
    cy.get(`[data-cy="SavedRecord-${name}"]`).should("not.exist");
  }
);
