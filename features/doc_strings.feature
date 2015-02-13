Feature: DocStrings

  Scenario: Match a step with a DocString
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
        Given passing with a DocString:
          \"\"\"
          DocString content
          \"\"\"
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    And a file named "features/step_defintions/steps.tcl" with:
      """
      Given {^passing with a DocString$} {content} {
        puts "Hello $content"
      }
      """
    When I run `cucumber`
    Then it should pass with:
      """
      Hello DocString content
      """
