Feature: DataTables

  @wip
  Scenario: Match a step with a DataTable
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
        Given passing with a DataTable:
          | first_column | second_column |
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    And a file named "features/step_defintions/steps.tcl" with:
      """
      Given {^passing with a DataTable:$} {content} {
        puts "raw data = [get_raw $content]"
      }
      """
    When I run `cucumber`
    Then it should pass with:
      """
      raw data = {"first_column" "second_column"}
      """
