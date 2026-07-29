before(() => {
  cy.visit("/instrument-master.html");
  cy.window().then((win) => win.localStorage.clear());
});
