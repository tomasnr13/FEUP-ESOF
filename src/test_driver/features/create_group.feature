Feature: Create Group
  Creating a new group should show it on the groups page

  Scenario: add a new group
    Given I am logged in
    And I open the drawer
    And I tap the "key_Grupos de Trabalho" button
    And I tap the "create_group" button
    And I fill the "key_bug_form_Nome do Grupo" field with "TEST GROUP"
#    And I swipe right by 50 pixels on the "create_group_form_slider" field with "TEST GROUP"
    And I tap the "create_group_form_send" button
    And I tap the back button
    Then I expect the text "TEST GROUP" to be present
