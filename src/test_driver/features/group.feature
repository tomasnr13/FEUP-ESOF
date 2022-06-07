Feature: Groups
  Managing groups on the groups page

  Scenario: add a new group
    Given I am logged in
    And I open the drawer
    And I tap the "key_Grupos de Trabalho" button
    And I tap the "create_group" button
    And I fill the "key_bug_form_Nome do Grupo" field with "TEST GROUP"
#    And I swipe right by 50 pixels on the "create_group_form_slider" field with "TEST GROUP"
    And I tap the "create_group_form_send" button
#    And I tap the back button
    Then I expect the text "TEST GROUP" to be present

  Scenario: see a group info
    Given I am logged in
    And I open the drawer
    And I tap the "key_Grupos de Trabalho" button
    And I tap the "group_slot_TEST GROUP" button
    Then I expect the text "TEST GROUP" to be present

  Scenario: add a group member
     Given I am logged in
     And I open the drawer
     And I tap the "key_Grupos de Trabalho" button
     And I tap the "group_slot_TEST GROUP" button
     And I tap the "add_member" button
     And I fill the "key_bug_form_Nome" field with "TEST STUDENT"
     And I fill the "key_bug_form_Email" field with "up201912345@edu.fe.up.pt"
     And I tap the "add-member-form-add" button
     Then I expect the text "TEST STUDENT" to be present
     And I tap the "group_slot_TEST GROUP" button
     Then I expect the text "TEST STUDENT" to be present
     And I expect the text "up201912345@edu.fe.up.pt" to be present

  Scenario: remove a group
     Given I am logged in
     And I open the drawer
     And I tap the "key_Grupos de Trabalho" button
     And I tap the "group_slot_TEST GROUP" button
     And I tap the "remove_group" button
     Then I expect the text "TEST GROUP" to be absent
