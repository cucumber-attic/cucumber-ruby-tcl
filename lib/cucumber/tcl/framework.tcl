
#TODO make this a namespace to avoid globals
set STEPS [list]

#
# Define procs to match Gherkin keyworkds that put data in the STEPS array
#
proc Given {re body} {
  global STEPS
  lappend STEPS [list $re $body]
}

proc When {re body} {
  global STEPS
  lappend STEPS [list $re $body]
}

proc Then {re body} {
  global STEPS
  lappend STEPS [list $re $body]
}

proc And {re body} {
  global STEPS
  lappend STEPS [list $re $body]
}

#
# Procs needed by cucumber for checking and executing steps
proc step_definition_exists { step_name } {
  global STEPS

  set res [_search_steps $step_name 1]
  return $res
}


proc execute_step_definition { step_name } {
  # TODO: handle parameters in the regexp
  global STEPS

  set res [_search_steps $step_name 1]
  return $res

}


proc _search_steps {step_name execute} {
  global STEPS

  foreach step $STEPS {
    set existing_step_name [lindex $step 0]
    set existing_step_body [lindex $step 1]

    if {[regexp $existing_step_name $step_name matchresult]} {
      if {$execute == 1} {
        eval $existing_step_body
      }
      return 1
    }
  }
  return 0
}

#TODO let that path be configurable from cucumber-ruby
foreach x [glob features/**/*.tcl] {
    source $x
}

