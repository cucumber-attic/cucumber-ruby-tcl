
# Set a variable to allow this to be more easily tested
if {[info exists env(TEST)] && $env(TEST) eq 1} {
  set TEST 1
} else {
  set TEST 0
}

#TODO make this a namespace to avoid globals
set STEPS [list]

#
# Define procs to match Gherkin keyworkds that put data in the STEPS array
#
proc Given args {
  _add_step {*}$args
}

proc When args {
  _add_step {*}$args
}

proc Then args {
  _add_step {*}$args
}

proc And args {
  _add_step {*}$args
}

proc _add_step args {

  global STEPS

  if {[llength $args] == 2} {
    set re [lindex $args 0]
    set params {}
    set body [lindex $args 1]
  } elseif {[llength $args] == 3} {
    set re [lindex $args 0]
    set params [lindex $args 1]
    set body [lindex $args 2]
  } else {
    error "The parameters for this procedure are regular_expression ?list_of_capture_variables? body"
    return 0
  }
    
  lappend STEPS [list $re $params $body]
}

#
# Procs needed by cucumber for checking and executing steps
proc step_definition_exists { step_name } {
  set res [_search_steps $step_name 1]
  return $res
}


proc execute_step_definition { step_name } {
  # TODO: handle parameters in the regexp
  set res [_search_steps $step_name 1]
  return $res

}


proc _search_steps {step_name {execute 0}} {
  global STEPS

  foreach step $STEPS {
    set existing_step_name   [lindex $step 0]
    set existing_step_params [lindex $step 1]
    set existing_step_body   [lindex $step 2]


    if {[regexp $existing_step_name $step_name matchresult {*}[join $existing_step_params]]} {
      if {$execute == 1} {
        eval $existing_step_body
      }
      return 1
    }
  }
  return 0
}

if {$TEST ne 1} {
  #TODO let that path be configurable from cucumber-ruby
  foreach x [glob features/**/*.tcl] {
      source $x
  }
}
