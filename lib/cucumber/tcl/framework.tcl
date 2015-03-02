
namespace eval ::cucumber:: {
  variable STEPS [list]
  variable TEST

  # Set a variable to allow this to be more easily tested
  if {[info exists env(TEST)] && $::env(TEST) eq 1} {
    set TEST 1
  } else {
    set TEST 0
  }

  namespace export step_definition_exists
  namespace export execute_step_definition

}

#
# Define procs to match Gherkin keyworkds that put data in the STEPS array
#
proc ::cucumber::Given args {
  _add_step {*}$args
}

proc ::cucumber::When args {
  _add_step {*}$args
}

proc ::cucumber::Then args {
  _add_step {*}$args
}

proc ::cucumber::And args {
  _add_step {*}$args
}

proc ::cucumber::_add_step args {

  variable STEPS

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
proc ::cucumber::step_definition_exists { step_name } {
  set res [_search_steps $step_name 0]
  return $res
}


proc ::cucumber::execute_step_definition { step_name {multiline_args {}} } {
  set res [_search_steps $step_name 1 $multiline_args]
  return $res

}


proc ::cucumber::_search_steps {step_name {execute 0} {multiline_args {}}} {
  variable STEPS

  foreach step $STEPS {
    set existing_step_name   [lindex $step 0]
    set existing_step_params [lindex $step 1]
    set existing_step_body   [lindex $step 2]

    if {[regexp $existing_step_name $step_name matchresult {*}[join $existing_step_params]]} {

      # Now we've found a match, handle multiline args. The name of the var
      # should be the last value of the $existing_step_params.
      if {$multiline_args ne {}} {
        set multiline_var_name [lindex $existing_step_params end]
        set $multiline_var_name $multiline_args
      }
      
      if {$execute == 1} {
        eval $existing_step_body
      }
      return 1
    }
  }
  return 0
}

proc ::cucumber::source_steps args {
  variable TEST

  if {$TEST ne 1} {
    #TODO let that path be configurable from cucumber-ruby
    foreach x [glob features/**/*.tcl] {
        source $x
    }
  }
}

namespace import ::cucumber::*
::cucumber::source_steps
