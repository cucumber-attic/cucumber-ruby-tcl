Feature: Reset state

  In order to keep state from leaking between scenarios, by default,
  we create a new Tcl interpreter for each test case.

  Scenario: Set a global variable in one scenario and access it in another
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given I set a global variable
          When I print the global variable

        Scenario:
          When I print the global variable
      """
    And a file named "features/step_definitions/steps.tcl" with:
      """
      namespace eval my_code {
        global g
      }
      Given {^I set a global variable$} {
        set my_code::g value
      }

      When {^I print the global variable$} {
        puts $my_code::g
      }
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    When I run `cucumber`
    Then it should fail with:
      """
      can't read "my_code::g": no such variable
      """
