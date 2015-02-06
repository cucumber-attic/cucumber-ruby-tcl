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
    And a file named "features/support/env.tcl" with:
      """
      proc step_definition_exists {step_name} {
        return 1
      }

      proc execute_step_definition {step_name} {
        puts "Hello world"
      }
      """
    When I run `cucumber`
    Then it should pass with:
      """
      Hello world
      """
