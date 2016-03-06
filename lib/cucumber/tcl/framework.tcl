
namespace eval ::cucumber:: {
  variable STEPS [list]
  variable TEST

  # Set a variable to allow this to be more easily tested
  if {[info exists env(TEST)] && $::env(TEST) eq 1} {
    set TEST 1
  } else {
    set TEST 0
  }

  namespace export source_files
  namespace export step_definition_exists
  namespace export execute_step_definition
  namespace export Given
  namespace export When
  namespace export Then
  namespace export pending

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
        if {[catch {
          eval $existing_step_body
        } msg]} {
          if {$msg eq "pending"} {
            return "pending"
          }
          error $::errorInfo
        }
      }
      return 1
    }
  }
  return 0
}

# Sort a list of files such that: */support/env.{ext} < */support/{file} < */{file}
proc ::cucumber::_sort_by_source_priority {a b} {

  if {[string equal [lindex [file split $a] end-1] "support"]} {
    if {[string equal [file rootname [lindex [file split $a] end]] "env"]} {
      set a_order 1
    } else {
      set a_order 2
    }
  } else {
    set a_order 3
  }

  if {[string equal [lindex [file split $b] end-1] "support"]} {
    if {[string equal [file rootname [lindex [file split $b] end]] "env"]} {
      set b_order 1
    } else {
      set b_order 2
    }
  } else {
    set b_order 3
  }

  return [expr {$a_order - $b_order}]
}

proc ::cucumber::source_files {files} {
  variable TEST

  if {$TEST ne 1} {
    foreach file [lsort -unique -command _sort_by_source_priority $files] {
      if {[string equal [file extension $file] ".tcl"]} {
        if {[catch {
          uplevel #0 [list source $file]
        }]} {
          error $::errorInfo
        }
      }
    }
  }
}

proc ::cucumber::pending args {
  error "pending"
}

namespace import ::cucumber::*
