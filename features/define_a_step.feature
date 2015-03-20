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

  Scenario: Define a step with a parameter
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

  @wip
  Scenario: Define a feature with no steps file
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
    When I run `cucumber`
    Then it should pass with:
      """
      Feature: 

        Scenario: 
          Given pending
            TODO: Step not yet implemented (Cucumber::Core::Test::Result::Pending)
            features/test.feature:3:in `Given pending'

      1 scenario (1 pending)
      1 step (1 pending)
      """
