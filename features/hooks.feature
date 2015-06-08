Feature: Hooks

  @wip
  Scenario: Run code in a Before hook before a scenario is run
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given testing before hook
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    And a file named "features/support/hooks.tcl" with:
      """
      Before {
        puts "In Before Hook"
      }
      """
    And a file named "features/step_definitions/steps.tcl" with:
      """
      Given {^testing before hook$} {
        puts "Testing before hook"
      }
      """
    When I run `cucumber`
    Then it should pass with:
      """
      In Before Hook
      Testing before hook
      """

  @wip
  Scenario: Run code in as After hook after a scenario is run
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given testing after hook
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    And a file named "features/support/hooks.tcl" with:
      """
      After {
        puts "In After Hook"
      }
      """
    And a file named "features/step_definitions/steps.tcl" with:
      """
      Given {^testing after hook$} {
        puts "Testing after hook"
      }
      """
    When I run `cucumber`
    Then it should pass with:
      """
      Testing before hook
      In After Hook
      """

