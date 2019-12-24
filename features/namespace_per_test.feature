Feature: Namespace per test

  A new namespace is created for each test run, to prevent leakage of local variables between tests
  when the option to share the TCL interpreter between tests is passed to Cucucmber

  Rules:
    -- The state is maintained between scenarios if an environment variable is passed into Cucumber
    -- Locally defined variables are not accessible between test scenarios

  Background:
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given I set a global and a local variable
          When I print the global variable
          And I print the local variable

        Scenario:
          When I print the global variable
          And I print the local variable
      """
    And a file named "features/step_definitions/steps.tcl" with:
      """
      global g
      variable l

      Given {^I set a global and a local variable$} {
        set ::g value
        set l value
      }

      When {^I print the global variable$} {
        puts $l
      }

      When {^I print the local variable$} {
        puts $l
      }
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """

  Scenario: Local variable not persisted between tests when running 'cucumber' and sharing framework object
    When I run `cucumber SHARE_FRAMEWORK=1`
    Then it should fail with:
      """
      can't read "l": no such variable
      """
