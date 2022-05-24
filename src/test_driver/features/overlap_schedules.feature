Feature: Create Group
  Choosing students to overlap

  Scenario: input students up codes
    Given I am logged in
    And I open the drawer
    And I tap the "key_Sobreposição de Horários" button
    And I fill the "overlap_input_up" field with "up201904517"
    And I tap the "overlap_input_add" button
    And I fill the "overlap_input_up" field with "up201904515"
    And I tap the "overlap_input_add" button
    Then I expect the text "up201904517" to be present
