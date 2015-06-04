Feature: Sourcing tcl files

  Scenario: Display stack trace when there is an error in a sourced file
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given testing file sourcing
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    And a file named "features/support/helper.tcl" with:
      """
      error "Fail sourcing"
      """
    When I run `cucumber`
    Then it should fail with:
      """
      Fail sourcing
          while executing
      "error "Fail sourcing""
          (file "features/support/helper.tcl" line 1)
          invoked from within
      "source $x" (Tcl::Error)
      """

  Scenario: Display stack trace with multiple levels
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given testing file sourcing
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    And a file named "features/support/helper.tcl" with:
      """
      proc test_proc args {
        proc_doesnt_exist
      }

      test_proc
      """
    When I run `cucumber`
    Then it should fail with:
      """
      invalid command name "proc_doesnt_exist"
          while executing
      "proc_doesnt_exist"
          (procedure "test_proc" line 2)
          invoked from within
      "test_proc"
          (file "features/support/helper.tcl" line 5)
          invoked from within
      "source $x" (Tcl::Error)
      """
