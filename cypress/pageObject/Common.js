// This is your team's real Page Object class, copied in as-is for
// reference. It is NOT used by the simplified demo step definitions
// (cypress/e2e/Finance/InstrumentMaster/instrument-master.js) — those
// use plain selectors against the local mock page instead, since the
// mock doesn't replicate the real ag-grid/PicklistSearchBar/Material
// dialog UI these methods assume. When this points at the real app,
// swap the simplified steps for calls into this class instead.

export class common {
    clickModulesAndScreens(dataTable) {
        cy.get('.checkbox-container').click()
        cy.get('.mat-mdc-dialog-actions > button').click()
        const navigatePath = dataTable.hashes()[0];
        cy.wait(5000)
        cy.get('[data-cy="ModuleList"] > .mat-icon').should('be.visible').and('not.be.disabled').should('be.visible').dblclick()
        if (navigatePath.Module) {
            cy.get(`[data-cy="${navigatePath.Module}-Module"]`).click()
        }
        if (navigatePath.Folder) {
            cy.get(`[data-cy="${navigatePath.Folder}-MenuFolder0"]`).click()
        }
        if (navigatePath.Screen) {
            cy.get(`[data-cy="${navigatePath.Screen}-MenuData0"]`).click()
        }
        if (navigatePath.SubFolder) {
            cy.get(`[data-cy="${navigatePath.SubFolder}-MenuFolder1"]`).click()
        }
        if (navigatePath.SubScreen) {
            cy.get(`[data-cy="${navigatePath.SubScreen}-MenuData1"]`).click()
        }
        cy.get('.navbtn > .mat-icon').click()
    }

    RetrieveTheForm(pickList, value) {
        cy.clickPickListDrop(pickList)
        cy.get(`@${value}`).then((data) => {
            cy.log(data)
            cy.get("[data-cy='PicklistSearchBar']").should('be.visible')
                .clear()
                .type(data, { delay: 100 })
                .type("{enter}")
            cy.wait(1000)
            cy.get('.ag-row-odd > .ag-cell-value').eq(1).click()
        })
        cy.wait(1000)
        cy.updateForm()
    }

    DeleteTheForm(pickList, value) {
        cy.clickPickListDrop(pickList)
        cy.get(`@${value}`).then((data) => {
            cy.get("[data-cy='PicklistSearchBar']").should('be.visible')
                .clear()
                .type(data, { delay: 100 })
                .type("{enter}")
            cy.wait(1000)
            cy.get('.ag-row-odd > .ag-cell-value').eq(1).click()
        })
        cy.wait(1000)
        cy.deleteForm()
    }

    VerifyFormValidationMessage(Page) {
        cy.wait(1000);
        cy.fixture('validation-error-message.json').then((errorMessageJson) => {
            const key = `${Page.replace(/\s+/g, '')}ErrorMessages`;
            const expectedErrorMessages = errorMessageJson[key] && errorMessageJson[key].ErrorMessages;
            cy.get('body').then($body => {
                if ($body.find('.mat-mdc-dialog-component-host').length > 0) {
                    cy.get('.mat-mdc-dialog-component-host').should('be.visible').then($dialog => {
                        const actualText = $dialog.text();
                        const errorExists = expectedErrorMessages && expectedErrorMessages.some(message => actualText.includes(message));
                        expect(errorExists, `Expected one of ${expectedErrorMessages}, but found: "${actualText}"`).to.be.true;
                    });
                }
            });
        });
    }

    enterCodeValue(value, field) {
        if (!value) return;
        cy.get(`[data-cy="${field}-PickListDrop"]`).scrollIntoView().should('be.visible').click();
        cy.get('[data-cy="PicklistSearchBar"]').should('be.visible').clear().type(value);
        cy.wait(6000)
        cy.get('.ag-center-cols-viewport').invoke('text').then((text) => {
            const newValue = `${value}(NEW)`;
            if (text.includes(newValue)) {
                cy.get('.ag-center-cols-viewport').contains(newValue).should('be.visible').click();
            } else {
                cy.get('.ag-center-cols-viewport').contains(value).should('be.visible').click();
            }
            cy.setData(field, value);
        });
    }

    enterNameValue(value, field) {
        if (!value) return;
        cy.get(`[data-cy="${field}-PickListDrop"]`).click()
        cy.get('[data-cy="PicklistSearchBar"]').should('be.visible').clear().type(value);
        cy.wait(1000);
        cy.get('.ag-center-cols-viewport').contains(`${value}(NEW)`).click();
        cy.setData(`${field}`, value)
    }
}
