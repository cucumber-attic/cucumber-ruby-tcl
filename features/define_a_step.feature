Feature: Define a step

  Scenario: Define a passing step
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given passing
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    And a file named "features/step_defintions/steps.tcl" with:
      """
      Given {^passing$} {
        puts "Hello world"
      }
      """
    When I run `cucumber`
    Then it should pass with:
      """
      Hello world
      """

  Scenario: Define a passing step with a parameter
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given passing 123
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    And a file named "features/step_defintions/steps.tcl" with:
      """
      Given {^passing (\d+)$} {num} {
        puts "Hello $num"
      }
      """
    When I run `cucumber`
    Then it should pass with:
      """
      Hello 123
      """

