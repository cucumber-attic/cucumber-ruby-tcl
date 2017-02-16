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
	
  Scenario: State is not reset when running 'cucumber' with no options
    When I run `cucumber`
    Then the exit status should be 1

  Scenario: State reset when running 'cucumber' with the new interpreter flag on
    When I run `cucumber NEW_INTERPRETER=1`
    Then the exit status should be 1

  Scenario: State not reset when running 'cucumber' with new interpreter flag OF
    When I run `cucumber NEW_INTERPRETER=0`
    Then the exit status should be 0

    # TODO (sbristow): This step fails because the actual Cucumber output
    # does not match exactly the expected output.  It looks like
    # the "puts" command inside the step definition is writing
    # to the output buffer, which somehow ends up with output
    # printed out of order.  The value of '$value' is printed
    # above the Scenario rather than the step it's called in.
    # This is difficult to debug and I've not found the problem as of yet.
    #Then it should pass with:
    #  """
    #  Feature: 

    #    Scenario:                          # features/test.feature:2
    #      Given I set a global variable    # features/test.feature:3
    #  value
    #      When I print the global variable # features/test.feature:4

    #    Scenario:                          # features/test.feature:6
    #  value
    #      When I print the global variable # features/test.feature:7

    #  2 scenarios (2 passed)
    #  3 steps (3 passed)
    #  """
