Feature: A step that is still pending implementation

  @wip
  Scenario: A un-implemented step returns pending
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given pending
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    And a file named "features/step_defintions/steps.tcl" with:
      """
      Given {^pending$} {
        pending {Step not yet implemented}
      }
      """
    When I run `cucumber`
    Then it should pass with:
      """
      Feature:
        Scenario:
          Given pending
            TODO: Step not yet implemented
            features/step_definitions/steps.tcl:2
            features/test.feature:3:in `Given pending'

      1 scenario (1 pending)
      1 step (1 pending)
      """

