Feature: Invoice Create / Update
  As a Finance user
  I want to create, read, update, and delete Invoices
  So that customer billing is managed accurately.

  Background:
    Given I am on the "Invoice Create / Update" page

  Scenario: Smoke - Verify form fields and actions in create mode
    Given the form is in create mode
    Then I should see the field "data-cy=InvoiceNumber"
    And I should see the field "data-cy=InvoiceDate"
    And I should see the field "data-cy=CustomerName"
    And I should see the field "data-cy=InvoiceAmount"
    And I should see the field "data-cy=InvoiceStatus"
    And I should see the field "data-cy=InvoiceNotes"
    And I should see the action "Save"
    And I should not see the action "Update"
    And I should not see the action "Delete"
    And the "Save" action should be disabled

  Scenario Outline: Validate required fields block Save and show inline validations
    Given the form is in create mode
    When I set "data-cy=InvoiceNumber" to "<InvoiceNumber>"
    And I set "data-cy=InvoiceDate" to "<InvoiceDate>"
    And I set "data-cy=CustomerName" to "<CustomerName>"
    And I set "data-cy=InvoiceAmount" to "<Amount>"
    And I set "data-cy=InvoiceStatus" to "<Status>"
    And I set "data-cy=InvoiceNotes" to "<Notes>"
    And I click "Save"
    Then I should see required validation on "<ExpectedRequiredField>"
    And the "Save" action should be disabled

    Examples:
      | InvoiceNumber | InvoiceDate | CustomerName | Amount | Status | Notes            | ExpectedRequiredField      |
      |               | 2024-01-31  | Acme Corp    | 1000   | Draft  | Initial invoice  | data-cy=InvoiceNumber      |
      | INV-1001      |             | Acme Corp    | 1000   | Draft  | Initial invoice  | data-cy=InvoiceDate        |
      | INV-1001      | 2024-01-31  |              | 1000   | Draft  | Initial invoice  | data-cy=CustomerName       |
      | INV-1001      | 2024-01-31  | Acme Corp    |        | Draft  | Initial invoice  | data-cy=InvoiceAmount      |
      | INV-1001      | 2024-01-31  | Acme Corp    | 1000   |        | Initial invoice  | data-cy=InvoiceStatus      |

  Scenario Outline: Validate data type for Invoice Date
    Given the form is in create mode
    When I set "data-cy=InvoiceNumber" to "INV-2001"
    And I set "data-cy=InvoiceDate" to "<InvalidDate>"
    And I set "data-cy=CustomerName" to "Acme Corp"
    And I set "data-cy=InvoiceAmount" to "2500"
    And I set "data-cy=InvoiceStatus" to "Draft"
    And I click "Save"
    Then I should see date validation on "data-cy=InvoiceDate"
    And the "Save" action should be disabled

    Examples:
      | InvalidDate  |
      | invalid-date |
      | 2024-02-30   |
      | 13/31/2024   |

  Scenario Outline: Validate data type for Amount
    Given the form is in create mode
    When I set "data-cy=InvoiceNumber" to "INV-2002"
    And I set "data-cy=InvoiceDate" to "2024-02-01"
    And I set "data-cy=CustomerName" to "Acme Corp"
    And I set "data-cy=InvoiceAmount" to "<InvalidAmount>"
    And I set "data-cy=InvoiceStatus" to "Draft"
    And I click "Save"
    Then I should see number validation on "data-cy=InvoiceAmount"
    And the "Save" action should be disabled

    Examples:
      | InvalidAmount |
      | abc           |
      | 123.45.67     |
      | --100         |

  Scenario Outline: Validate Notes max length (500)
    Given the form is in create mode
    When I set "data-cy=InvoiceNumber" to "INV-2003"
    And I set "data-cy=InvoiceDate" to "2024-03-15"
    And I set "data-cy=CustomerName" to "Acme Corp"
    And I set "data-cy=InvoiceAmount" to "500"
    And I set "data-cy=InvoiceStatus" to "Draft"
    And I set a string of length "<NotesLength>" into "data-cy=InvoiceNotes"
    And I click "Save"
    Then the "Save" action should be "<SaveEnabled>"
    And "<ValidationExpected>" max length validation on "data-cy=InvoiceNotes"

    Examples:
      | NotesLength | SaveEnabled | ValidationExpected |
      | 500         | enabled     | no                 |
      | 501         | disabled    | yes                |

  Scenario Outline: Create Invoice successfully calls create API
    Given the form is in create mode
    When I set "data-cy=InvoiceNumber" to "<InvoiceNumber>"
    And I set "data-cy=InvoiceDate" to "<InvoiceDate>"
    And I search "<CustomerSearch>" in "data-cy=CustomerName" and select option "<CustomerName>" using "InvoiceService.getCustomerOptions"
    And I set "data-cy=InvoiceAmount" to "<Amount>"
    And I set "data-cy=InvoiceStatus" to "<Status>"
    And I set "data-cy=InvoiceNotes" to "<Notes>"
    And the "Save" action should be enabled
    And I click "Save"
    Then the "InvoiceService.create" API should be called with payload containing:
      | invoiceNumber | <InvoiceNumber> |
      | invoiceDate   | <InvoiceDate>   |
      | customerName  | <CustomerName>  |
      | amount        | <Amount>        |
      | status        | <Status>        |
      | notes         | <Notes>         |

    Examples:
      | InvoiceNumber | InvoiceDate | CustomerSearch | CustomerName | Amount | Status | Notes               |
      | INV-3001      | 2024-04-01  | Acm            | Acme Corp    | 1200   | Draft  | April billing       |
      | INV-3002      | 2024-04-15  | Glob           | Global LLC   | 999.99 | Open   | Mid-month services  |

  Scenario Outline: Read - Load existing Invoice populates form and enforces readonly on Invoice Number
    Given the form is in edit mode for invoice "<ExistingInvoiceNumber>"
    When the "InvoiceService.getById" API is called for "<ExistingInvoiceNumber>"
    Then I should see "data-cy=InvoiceNumber" has value "<ExistingInvoiceNumber>" and is readonly
    And I should see "data-cy=InvoiceDate" is populated
    And I should see "data-cy=CustomerName" is populated
    And I should see "data-cy=InvoiceAmount" is populated
    And I should see "data-cy=InvoiceStatus" is populated
    And I should see the action "Update"
    And I should see the action "Delete"

    Examples:
      | ExistingInvoiceNumber |
      | INV-1001              |
      | INV-1002              |

  Scenario Outline: Update - Modify allowed fields and call update API
    Given the form is in edit mode for invoice "<ExistingInvoiceNumber>"
    And I verify "data-cy=InvoiceNumber" is readonly
    When I set "data-cy=InvoiceDate" to "<NewInvoiceDate>"
    And I set "data-cy=CustomerName" to "<NewCustomerName>"
    And I set "data-cy=InvoiceAmount" to "<NewAmount>"
    And I set "data-cy=InvoiceStatus" to "<NewStatus>"
    And I set "data-cy=InvoiceNotes" to "<NewNotes>"
    And the "Update" action should be enabled
    And I click "Update"
    Then the "InvoiceService.update" API should be called with payload containing:
      | invoiceNumber | <ExistingInvoiceNumber> |
      | invoiceDate   | <NewInvoiceDate>        |
      | customerName  | <NewCustomerName>       |
      | amount        | <NewAmount>             |
      | status        | <NewStatus>             |
      | notes         | <NewNotes>              |

    Examples:
      | ExistingInvoiceNumber | NewInvoiceDate | NewCustomerName | NewAmount | NewStatus | NewNotes                |
      | INV-1001              | 2024-05-10     | Acme Corp       | 1500      | Open      | Adjusted after review   |
      | INV-1002              | 2024-06-01     | Global LLC      | 2000.50   | Closed    | Finalized               |

  Scenario Outline: Update - Required field clearing in edit mode shows validation and blocks Update
    Given the form is in edit mode for invoice "<ExistingInvoiceNumber>"
    When I clear the field "<FieldToClear>"
    And I click "Update"
    Then I should see required validation on "<FieldToClear>"
    And the "Update" action should be disabled

    Examples:
      | ExistingInvoiceNumber | FieldToClear            |
      | INV-1001              | data-cy=InvoiceDate     |
      | INV-1001              | data-cy=CustomerName    |
      | INV-1001              | data-cy=InvoiceAmount   |
      | INV-1001              | data-cy=InvoiceStatus   |

  Scenario Outline: Delete - Remove an existing invoice calls delete API
    Given the form is in edit mode for invoice "<ExistingInvoiceNumber>"
    When I click "Delete"
    Then the "InvoiceService.delete" API should be called for "<ExistingInvoiceNumber>"

    Examples:
      | ExistingInvoiceNumber |
      | INV-1001              |
      | INV-1002              |

  Scenario: Action visibility - Update and Delete only in edit mode
    Given the form is in create mode
    Then I should not see the action "Update"
    And I should not see the action "Delete"
    When the form is switched to edit mode for invoice "INV-1001"
    Then I should see the action "Update"
    And I should see the action "Delete"

  Scenario Outline: Customer lookup - Search and select option via InvoiceService.getCustomerOptions
    Given the form is in create mode
    When I search "<SearchTerm>" in "data-cy=CustomerName" using "InvoiceService.getCustomerOptions"
    Then I should see options containing "<ExpectedOption>"
    When I select "<ExpectedOption>" from "data-cy=CustomerName"
    Then "data-cy=CustomerName" should have value "<ExpectedOption>"

    Examples:
      | SearchTerm | ExpectedOption |
      | Acm        | Acme Corp      |
      | Glob       | Global LLC     |

  Scenario Outline: Customer lookup - No results returned
    Given the form is in create mode
    When I search "<SearchTerm>" in "data-cy=CustomerName" using "InvoiceService.getCustomerOptions"
    Then I should see 0 options in "data-cy=CustomerName"

    Examples:
      | SearchTerm |
      | ZZZUnknown |
      | 123NoMatch |

  Scenario: Save action remains disabled until form is valid
    Given the form is in create mode
    When I set "data-cy=InvoiceNumber" to "INV-4001"
    And I set "data-cy=InvoiceDate" to "2024-07-01"
    And I set "data-cy=CustomerName" to ""
    And I set "data-cy=InvoiceAmount" to "100"
    And I set "data-cy=InvoiceStatus" to "Draft"
    Then the "Save" action should be disabled
    When I set "data-cy=CustomerName" to "Acme Corp"
    Then the "Save" action should be enabled