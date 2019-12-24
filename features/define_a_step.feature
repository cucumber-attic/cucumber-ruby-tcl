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

  Scenario: Define a feature with no steps file
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given undefined
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    When I run `cucumber`
    Then it should pass with:
      """
      Feature: 

        Scenario:         # features/test.feature:2
          Given undefined # features/test.feature:3

      1 scenario (1 undefined)
      1 step (1 undefined)
      """

  Scenario: Define a failing step
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given failing
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    And a file named "features/step_defintions/steps.tcl" with:
      """
      Given {^failing$} {
        error "Failing Step"
      }
      """
    When I run `cucumber`
    Then it should fail with:
      """
      Feature: 
      
        Scenario:       # features/test.feature:2
          Given failing # features/test.feature:3
            Failing Step
                while executing
            "error "Failing Step""
                ("eval" body line 2)
                invoked from within
            "eval $step_body" (Tcl::Error)
            features/test.feature:3:in `Given failing'
      
      Failing Scenarios:
      cucumber features/test.feature:2 # Scenario: 
      
      1 scenario (1 failed)
      1 step (1 failed)
      """

  Scenario: Define a step that calls a failing proc
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given failing
      """
    And a file named "features/support/env.rb" with:
      """
      require 'cucumber/tcl'
      """
    And a file named "features/step_defintions/steps.tcl" with:
      """
      Given {^failing$} {
        failing_proc
      }
      proc failing_proc {} {
        error "Failing Step"
      }
      """
    When I run `cucumber`
    Then it should fail with:
      """
      Feature: 
      
        Scenario:       # features/test.feature:2
          Given failing # features/test.feature:3
            Failing Step
                while executing
            "error "Failing Step""
                (procedure "failing_proc" line 2)
                invoked from within
            "failing_proc"
                ("eval" body line 2)
                invoked from within
            "eval $step_body" (Tcl::Error)
            features/test.feature:3:in `Given failing'
      
      Failing Scenarios:
      cucumber features/test.feature:2 # Scenario: 
      
      1 scenario (1 failed)
      1 step (1 failed)
      """

