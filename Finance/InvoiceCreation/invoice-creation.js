import { Given, When, Then } from "@badeball/cypress-cucumber-preprocessor";
import { common } from "../../pageObject/Common";
import '../../support/hooks.js';
const Common = new common();

// Feature: Invoice Create / Update

Given('I am on the "Invoice Create / Update" page', () => {
  Common.navigateToPage('Invoice Create / Update');
});

Given('the form is in create mode', () => {
  Common.ensureCreateMode();
});

Then('I should see the field {string}', (selector) => {
  Common.assertFieldVisible(selector);
});

Then('I should see the action {string}', (action) => {
  Common.assertActionVisible(action);
});

Then('I should not see the action {string}', (action) => {
  Common.assertActionNotVisible(action);
});

Then('the {string} action should be disabled', (action) => {
  Common.assertActionDisabled(action);
});

When('I set {string} to {string}', (field, value) => {
  Common.setField(field, value);
});

When('I click {string}', (action) => {
  Common.clickAction(action);
});

Then('I should see required validation on {string}', (selector) => {
  Common.assertRequiredValidationOn(selector);
});

Then('I should see date validation on {string}', (selector) => {
  Common.assertDateValidationOn(selector);
});

Then('I should see number validation on {string}', (selector) => {
  Common.assertNumberValidationOn(selector);
});

When('I set a string of length {int} into {string}', (length, selector) => {
  Common.setStringOfLengthIntoField(length, selector);
});

Then('the {string} action should be {string}', (action, state) => {
  if (state.toLowerCase() === 'enabled') {
    Common.assertActionEnabled(action);
  } else {
    Common.assertActionDisabled(action);
  }
});

Then('{string} max length validation on {string}', (expected, selector) => {
  if (expected.toLowerCase() === 'yes') {
    Common.assertMaxLengthValidationOn(selector);
  } else {
    Common.assertNoMaxLengthValidationOn(selector);
  }
});

When('I search {string} in {string} and select option {string} using {string}', (searchTerm, selector, option, serviceName) => {
  Common.searchAndSelectOptionUsingService(searchTerm, selector, option, serviceName);
});

Then('the {string} API should be called with payload containing:', (apiName, dataTable) => {
  Common.assertApiCalledWithPayloadContaining(apiName, dataTable);
});

Given('the form is in edit mode for invoice {string}', (invoiceNumber) => {
  Common.ensureEditModeForInvoice(invoiceNumber);
});

When('the {string} API is called for {string}', (apiName, id) => {
  Common.waitForApiCallFor(apiName, id);
});

Then('I should see {string} has value {string} and is readonly', (selector, value) => {
  Common.assertFieldValueAndReadonly(selector, value);
});

Then('I should see {string} is populated', (selector) => {
  Common.assertFieldPopulated(selector);
});

Then('I verify {string} is readonly', (selector) => {
  Common.assertFieldReadonly(selector);
});

Then('the {string} action should be enabled', (action) => {
  Common.assertActionEnabled(action);
});

When('I clear the field {string}', (selector) => {
  Common.clearField(selector);
});

Then('the {string} API should be called for {string}', (apiName, id) => {
  Common.assertApiCalledFor(apiName, id);
});

When('the form is switched to edit mode for invoice {string}', (invoiceNumber) => {
  Common.switchToEditModeForInvoice(invoiceNumber);
});

When('I search {string} in {string} using {string}', (searchTerm, selector, serviceName) => {
  Common.searchInFieldUsingService(searchTerm, selector, serviceName);
});

Then('I should see options containing {string}', (expectedOption) => {
  Common.assertOptionsContain(expectedOption);
});

When('I select {string} from {string}', (option, selector) => {
  Common.selectOptionFromField(option, selector);
});

Then('{string} should have value {string}', (selector, value) => {
  Common.assertFieldValue(selector, value);
});

Then('I should see {int} options in {string}', (count, selector) => {
  Common.assertOptionsCountInField(selector, count);
});


// --- NEW PAGE OBJECT METHODS REQUIRED ---
// Implement the following methods in ../../pageObject/Common:
// - navigateToPage(pageTitle)
// - ensureCreateMode()
// - assertFieldVisible(selector)
// - assertActionVisible(actionText)
// - assertActionNotVisible(actionText)
// - assertActionDisabled(actionText)
// - setField(selector, value)
// - clickAction(actionText)
// - assertRequiredValidationOn(selector)
// - assertDateValidationOn(selector)
// - assertNumberValidationOn(selector)
// - setStringOfLengthIntoField(length, selector)
// - assertActionEnabled(actionText)
// - assertMaxLengthValidationOn(selector)
// - assertNoMaxLengthValidationOn(selector)
// - searchAndSelectOptionUsingService(searchTerm, selector, optionText, serviceName)
// - assertApiCalledWithPayloadContaining(apiName, dataTable)
// - ensureEditModeForInvoice(invoiceNumber)
// - waitForApiCallFor(apiName, id)
// - assertFieldValueAndReadonly(selector, value)
// - assertFieldPopulated(selector)
// - assertFieldReadonly(selector)
// - clearField(selector)
// - assertApiCalledFor(apiName, id)
// - switchToEditModeForInvoice(invoiceNumber)
// - searchInFieldUsingService(searchTerm, selector, serviceName)
// - assertOptionsContain(optionText)
// - selectOptionFromField(optionText, selector)
// - assertFieldValue(selector, expectedValue)
// - assertOptionsCountInField(selector, expectedCount)