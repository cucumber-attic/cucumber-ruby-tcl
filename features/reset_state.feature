Feature: Reset state

  In order to keep state from leaking between scenarios, by default,
  we create a new Tcl interpreter for each test case.

  In order to prevent long setup time before each scenario
  we can optionally avoid starting a new TCL interpreter

  Rules:
    -- The state is maintained between scenarios if an environment variable is passed into Cucumber
    -- Otherwise a new TCL interpreter is started and state is reset on each scenario

  Background:
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
      global g
       
      Given {^I set a global variable$} {
        set ::g value
      }

      When {^I print the global variable$} {
        puts $::g
      }
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
	
  Scenario: State reset when running 'cucumber' with no options
    When I run `cucumber`
    Then it should fail with:
       """
       can't read "::g": no such variable
       """

  Scenario: State reset when running 'cucumber' with a new framework object for each scenario
    When I run `cucumber SHARE_FRAMEWORK=0`
    Then it should fail with:
       """
       can't read "::g": no such variable
       """

  Scenario: State not reset when running 'cucumber' and sharing framework object
    When I run `cucumber SHARE_FRAMEWORK=1`
    Then it should pass with:
      """
      2 scenarios (2 passed)
      3 steps (3 passed)
      """
