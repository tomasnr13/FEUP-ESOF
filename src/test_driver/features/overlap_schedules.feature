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

  Scenario: get students compatibility
      Given I am logged in
      And I open the drawer
      And I tap the "key_Sobreposição de Horários" button
      And I fill the "overlap_input_up" field with "up201904517"
      And I tap the "overlap_input_add" button
      And I fill the "overlap_input_up" field with "up201904515"
      And I tap the "overlap_input_add" button
      And I tap the "overlap_input_send" button
      And I pause for 5 seconds
      Then I expect the text "Tempos livres comuns" to be present
