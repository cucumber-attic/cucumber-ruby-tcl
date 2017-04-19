Feature: Sourcing tcl files

  Scenario: Source files in the appropriate order (no command line options)
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given testing file sourcing
      """
    And a file named "features/step_definitions/steps_a.tcl" with:
      """
      puts "Sourced step_definitions/steps_a.tcl"
      """
    And a file named "features/step_definitions/steps_b.tcl" with:
      """
      puts "Sourced step_definitions/steps_b.tcl"
      """
    And a file named "features/support/db.tcl" with:
      """
      puts "Sourced support/db.tcl"
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    And a file named "features/support/env.tcl" with:
      """
      puts "Sourced support/env.tcl"
      """
    When I run `cucumber`
    Then it should pass with:
      """
      Sourced support/env.tcl
      Sourced support/db.tcl
      Sourced step_definitions/steps_a.tcl
      Sourced step_definitions/steps_b.tcl
      """

  Scenario: Source files in the appropriate order (with command line options)
    Given a file named "myfeatures/group one/test.feature" with:
      """
      Feature:
        Scenario:
          Given testing file sourcing
      """
    And a file named "myfeatures/step definitions/steps.tcl" with:
      """
      puts "Sourced step definitions/steps.tcl"
      """
    And a file named "myfeatures/support/db.tcl" with:
      """
      puts "Sourced support/db.tcl"
      """
    And a file named "myfeatures/support/debug.tcl" with:
      """
      puts "Sourced support/debug.tcl"
      """
    And a file named "myfeatures/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    And a file named "myfeatures/support/env.tcl" with:
      """
      puts "Sourced support/env.tcl"
      """
    When I run `cucumber 'myfeatures/group one/test.feature' --require myfeatures --exclude 'debug.*'`
    Then it should pass with:
      """
      Sourced support/env.tcl
      Sourced support/db.tcl
      Sourced step definitions/steps.tcl
      """

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
      "source features/support/helper.tcl"
          ("uplevel" body line 1)
          invoked from within
      "uplevel #0 [list source $file]" (Tcl::Error)
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
      "source features/support/helper.tcl"
          ("uplevel" body line 1)
          invoked from within
      "uplevel #0 [list source $file]" (Tcl::Error)
      """
