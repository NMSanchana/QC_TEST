Feature: Instrument Master Management
  As a user of the GoodBooks ERP system,
  I want to manage Instrument Master entries
  So that I can efficiently handle instrument configurations.

  Background:

    And I navigate through the following path "Financial" -> "InstrumentMaster"


  Scenario Outline: Save Validate form fields with different Invalid condition "<Conditions>"
    And I enter "<Name>" in the "InstrumentName" name field
    And I select "<AccountType>" from the "InstrumentType" ComboBox field
    And I select "<AccountName>" in the "AccountName" picklist field
    And I select "<Posting>" for "InstrumentAccountPostType" radioBox field
    And I select "<PostDated>" for "InstrumentPostDatedType" radioBox field
    And I enter "<ValidityPeriod>" in the "InstrumentValidityPeriodInDays" input field
    And I select "<Status>" for "InstrumentStatusOfInstrument" radioBox field
    And I select checkbox "<OU>" in the "InstrumentOuNames" picklist field
    And I select checkbox "<OU Group>" in the "InstrumentOuGroupNames" picklist field
    And I click the "Save" button
    Then I should see the validation message "<Message>"

    Examples:
      | Conditions                    | Name | AccountType | AccountName              | Posting   | PostDated | ValidityPeriod | Status  | OU                                    | OU Group | Message                                                  |
      | With All Fields Empty         |      |             |                          |           |           |                |         |                                       |          | Name* Should not be Empty , Account* Should not be Empty |
      | With Name  Fields Empty       |      | Cash        | Customer Control Account | OnDeposit | Immediate | 30             | Pending | GoodBooks Technologies Pvt Ltd.(Demo) | GROUP01  | Name* Should not be Empty                                |
      | With AccountName Fields Empty | Cash | Cash        |                          | OnDeposit | Immediate | 30             | Pending | GoodBooks Technologies Pvt Ltd.(Demo) | GROUP01  | Account* Should not be Empty                             |


  Scenario Outline: Save Validate form fields with different valid condition "<Conditions>"
    And I enter "<Name>" in the "InstrumentName" name field
    And I select "<AccountType>" from the "InstrumentType" ComboBox field
    And I select "<AccountName>" in the "AccountName" picklist field
    And I select "<Posting>" for "InstrumentAccountPostType" radioBox field
    And I select "<PostDated>" for "InstrumentPostDatedType" radioBox field
    And I enter "<ValidityPeriod>" in the "InstrumentValidityPeriodInDays" input field
    And I select "<Status>" for "InstrumentStatusOfInstrument" radioBox field
    And I select checkbox "<OU>" in the "InstrumentOuNames" picklist field
    And I select checkbox "<OU Group>" in the "InstrumentOuGroupNames" picklist field
    And I click the "Save" button
    Then I should see the validation message "<Message>"

    Examples:
      | Conditions                              | Name         | AccountType  | AccountName              | Posting   | PostDated | ValidityPeriod | Status  | OU                                    | OU Group | Message                    |
      | Create A  Instrument With  Cash Type    | Cash         | Cash         | Supplier Control Account | OnDeposit | Immediate | 30             | Pending | GoodBooks Technologies Pvt Ltd.(Demo) | GROUP01  | Details Saved Successfully |
      | Create A  Instrument With  Demand Draft | Demand Draft | Demand Draft | Supplier Control Account | OnDeposit | Immediate | 15             | Pending | GoodBooks Technologies Pvt Ltd.(Demo) | GROUP01  | Details Saved Successfully |


  Scenario Outline: Update Validate form fields with different condition "<Conditions>"
    And I retrieve the saved form value "<Name>" from the name field "InstrumentName"
    And I update the "InstrumentValidityPeriodInDays" input field with "<New ValidityPeriod>"
    And I click the "Update" button
    Then I should see a confirmation message "Details Saved Successfully"

    Examples:
      | Conditions                   | Name | New AccountName          | New ValidityPeriod | Expected Message           |
      | Update  Cash Type Instrument | Cash | Customer Control Account | 30                 | Details Saved Successfully |

  Scenario Outline: Delete Validate form fields with different condition "<Conditions>"
    And I retrieve the saved form value "<Name>" from the name field "InstrumentName"
    And I click the "Delete" button
    Then I should see a confirmation message "Detail Deleted Successfully"
    And I verify that the existing "<Name>" is successfully deleted, and the "InstrumentName" picklist does not contain the deleted value

    Examples:
      | CheckCondition | Name         | Expected Message             |
      | Valid data     | Cash         | Details Deleted Successfully |
      | Valid data     | Demand Draft | Details Deleted Successfully |
