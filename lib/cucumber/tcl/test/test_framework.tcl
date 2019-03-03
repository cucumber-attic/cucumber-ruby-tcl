package require tcltest 2
namespace import tcltest::*

source "./lib/cucumber/tcl/framework.tcl"
namespace import cucumber::*

#
# Test Given
#

variable SETUP {
  set ::cucumber::STEPS [list]
  ::cucumber::next_scenario
}

test Given-1 {calling Given with 2 parameters adds a new entry to the STEPS list with an empty parameters list} {
  -setup $SETUP
  -body {
    Given {^Regular Expression$} { puts "Given RegExp" }
    expr { [llength $::cucumber::STEPS] == 1 && [llength [lindex $::cucumber::STEPS 0]] == 3}
  }
  -result 1
}

test Given-2 {calling Given twice adds 2 entries to the STEPS list} {
  -setup $SETUP
  -body {
    Given {^Regular Expression$} { puts "Given RegExp" }
    Given {^Regular Expression 2$} { puts "Given RegExp 2" }
    expr { [llength $::cucumber::STEPS] == 2 && [llength [lindex $::cucumber::STEPS 0]] == 3}
  }
  -result 1
}

test Given-3 {calling Given with 3 parameters adds a new entry to the STEPS list} {
  -setup $SETUP
  -body {
    Given {^Regular Expression (\d+)$} {match} { puts "Given RegExp $match" }
    expr { [llength $::cucumber::STEPS] == 1 && [llength [lindex $::cucumber::STEPS 0]] == 3}
  }
  -result 1
}

#
# Test _add_step
#
test _add_step-1 {calling _add_step with 2 parameters adds a new entry to the STEPS list with an empty parameters list} {
  -setup $SETUP
  -body {
    ::cucumber::_add_step {^Regular Expression$} { puts "Given RegExp" }
    expr { [llength $::cucumber::STEPS] == 1 && [llength [lindex $::cucumber::STEPS 0]] == 3}
  }
  -result 1
}

test _add_step-2 {calling _add_step twice adds 2 entries to the STEPS list} {
  -setup $SETUP
  -body {
    ::cucumber::_add_step {^Regular Expression$} { puts "Given RegExp" }
    ::cucumber::_add_step {^Regular Expression 2$} { puts "Given RegExp 2" }
    expr { [llength $::cucumber::STEPS] == 2 && [llength [lindex $::cucumber::STEPS 0]] == 3}
  }
  -result 1
}

test _add_step-3 {calling _add_step with 3 parameters adds a new entry to the STEPS list} {
  -setup $SETUP
  -body {
    ::cucumber::_add_step {^Regular Expression (\d+)$} {match} { puts "Given RegExp $match" }
    expr { [llength $::cucumber::STEPS] == 1 && [llength [lindex $::cucumber::STEPS 0]] == 3}
  }
  -result 1
}

test _add_step-4 {calling _add_step with more than 3 parameters adds a new entry to the STEPS list} {
  -body {
    ::cucumber::_add_step {^Match1 (\w+) Match2 (\d+) Match3 (\d+)$} {match1} {match2} {match3} { puts "Given RegExp $match" }
  }
  -returnCodes error
  -result {The parameters for this procedure are regular_expression ?list_of_capture_variables? body}
}



#
# Test When
#
test When-1 {calling When adds a new entry to the STEPS list} {
  -setup $SETUP
  -body {
    When {^Regular Expression$} { puts "When RegExp" }
    expr { [llength $::cucumber::STEPS] == 1 }
    expr { [llength $::cucumber::STEPS] == 1 && [llength [lindex $::cucumber::STEPS 0]] == 3}
  }
  -result 1
}



#
# Test Then
#
test Then-1 {calling Then adds a new entry to the STEPS list} {
  -setup $SETUP
  -body {
    Then {^Regular Expression$} { puts "Then RegExp" }
    expr { [llength $::cucumber::STEPS] == 1 && [llength [lindex $::cucumber::STEPS 0]] == 3}
  }
  -result 1
}



#
# Test _sort_by_source_priority procedure
#
test _sort_by_source_priority-1 {_sort_by_source_priority prioritises support/env.{ext} over other support/ files} {
  -body {
    set sort [::cucumber::_sort_by_source_priority "test/support/abc.ext" "test/support/env.ext"]
    # only interested if sort is +ve, 0 or -ve; convert to 1, 0 or -1
    expr { $sort == 0 ? 0 : $sort / abs($sort) }
  }
  -result 1
}

test _sort_by_source_priority-2 {_sort_by_source_priority prioritises support/env.{ext} over other support/ files} {
  -body {
    set sort [::cucumber::_sort_by_source_priority "test/support/env.ext" "test/support/abc.ext"]
    # only interested if sort is +ve, 0 or -ve; convert to 1, 0 or -1
    expr { $sort == 0 ? 0 : $sort / abs($sort) }
  }
  -result -1
}

test _sort_by_source_priority-3 {_sort_by_source_priority prioritises support/ files over other files} {
  -body {
    set sort [::cucumber::_sort_by_source_priority "test/features/abc.ext" "test/support/abc.ext"]
    # only interested if sort is +ve, 0 or -ve; convert to 1, 0 or -1
    expr { $sort == 0 ? 0 : $sort / abs($sort) }
  }
  -result 1
}

test _sort_by_source_priority-4 {_sort_by_source_priority prioritises support/ files over other files} {
  -body {
    set sort [::cucumber::_sort_by_source_priority "test/support/abc.ext" "test/features/abc.ext"]
    # only interested if sort is +ve, 0 or -ve; convert to 1, 0 or -1
    expr { $sort == 0 ? 0 : $sort / abs($sort) }
  }
  -result -1
}

test _sort_by_source_priority-5 {_sort_by_source_priority prioritises non support/ files equally} {
  -body {
    set sort [::cucumber::_sort_by_source_priority "test/lib/abc.ext" "test/etc/abc.ext"]
    # only interested if sort is +ve, 0 or -ve; convert to 1, 0 or -1
    expr { $sort == 0 ? 0 : $sort / abs($sort) }
  }
  -result 0
}



#
# Test _search_steps procedure
#
test _search_steps-1 {_search_steps returns 0 if there are no existing steps} {
  -setup $SETUP
  -body {
    ::cucumber::_search_steps {Unknown Regexp}
  }
  -result 0
}

test _search_steps-2 {_search_steps returns 0 if there are no matching steps} {
  -setup $SETUP
  -body {
    ::cucumber::_search_steps {Unknown Regexp}
  }
  -result 0
}

test _search_steps-3 {_search_steps returns 1 if there is a matching step} {
  -setup {
    eval $SETUP
    set ::cucumber::STEPS [list [list {^First Step$} {} {puts "First Step"}]]
  }
  -body {
    ::cucumber::_search_steps {First Step}
  }
  -result 1
}

test _search_steps-4 {_search_steps returns 1 if there is a matching step with multiple values in STEPS} {
  -setup {
    eval $SETUP
    set ::cucumber::STEPS [list \
      [list {^First Step$} {} {puts "First Step"}] \
      [list {^Second Step$} {} {puts "Second Step"}] \
    ]
  }
  -body {
    ::cucumber::_search_steps {Second Step}
  }
  -result 1
}

test _search_steps-5 {_search_steps returns 1 and executes body of step if there is a matching step and execute is set to 1} {
  -setup {
    set ::cucumber::STEPS [list \
      [list {^First Step$} {} {puts "First Step"}] \
      [list {^Second Step$} {} {puts "Second Step"}] \
    ]
    ::cucumber::next_scenario
    }
  -body {
    ::cucumber::_search_steps {Second Step} {1}
  }
  -result 1
  -match glob
  -output {Second Step*}
}

test _search_steps-6 {_search_steps returns 1 and executes body of step if there is a matching step and execute is set to 1 with a parameter in the match} {
  -setup {
    set ::cucumber::STEPS [list \
      [list {^First Step$} {} {puts "First Step"}] \
      [list {^Second (\w+)$} {match} {puts "Second $match"}] \
    ]
    ::cucumber::next_scenario
  }
  -body {
    ::cucumber::_search_steps {Second Step} {1}
  }
  -result 1
  -match glob
  -output {Second Step*}
}

test _search_steps-7 {_search_steps returns 1 and executes body of step if there is a matching step and execute is set to 1 with 2 parameters in the match} {
  -setup {
    set ::cucumber::STEPS [list \
      [list {^First Step$} {} {puts "First Step"}] \
      [list {^(\w+) (\w+)$} {match1 match2} {puts "$match1 $match2"}] \
    ]
    ::cucumber::next_scenario
  }
  -body {
    ::cucumber::_search_steps {Second Step} {1}
  }
  -result 1
  -match glob
  -output {Second Step*}
}

# Testing multiline args
test _search_steps-8 {_search_steps returns 1 and executes body of step if there is a matching step, execute is set to 1 and there is a multiline_arg passed in} {
  -setup {
    set ::cucumber::STEPS [list \
      [list {^First Step$} {} {puts "First Step"}] \
      [list {^Second Step:$} {content} {puts "$content"}] \
    ]
    ::cucumber::next_scenario
  }
  -body {
    ::cucumber::_search_steps {Second Step:} {1} {Multiline Content}
  }
  -result 1
  -match glob
  -output {Multiline Content*}
}

test _search_steps-9 {_search_steps returns 1 and executes body of step if there is a matching step, execute is set to 1 and there is a multiline_arg passed in and there is a parameter match in the regexp} {
  -setup {
    set ::cucumber::STEPS [list \
      [list {^First Step$} {} {puts "First Step"}] \
      [list {^Second (\w+):$} {match1 content} {puts "content=$content, match=$match1"}] \
    ]
    ::cucumber::next_scenario
  }
  -body {
    ::cucumber::_search_steps {Second Step:} {1} {Multiline Content}
  }
  -result 1
  -match glob
  -output {content=Multiline Content, match=Step*}
}

test _search_steps-10 {_search_steps returns "pending" if there is a matching step, execute is set to 1 and the proc to be executed is pending} {
  -setup {
    set ::cucumber::STEPS [list \
      [list {^Pending$} {} {pending}] \
    ]
  }
  -body {
    ::cucumber::_search_steps {Pending} {1} {}
  }
  -result "pending"
}

test _next_scenario_namespace {_next_scenario causes step to be executed in a new namespace} {
  -setup {
    set ::cucumber::STEPS [list \
      [list {^First Step$} {} {set ::ns1 [namespace current]}] \
      [list {^Second Step$} {} {puts [string equal $::ns1 [namespace current]]}] \
    ]
    ::cucumber::next_scenario
  }
  -body {
    ::cucumber::_search_steps {First Step} {1}
    ::cucumber::next_scenario
    ::cucumber::_search_steps {Second Step} {1}
  }
  -result 1
  -match glob
  -output {0*}
}
#
# Test Pending
#
test pending-1 {pending returns an error with the text "pending"} {
  -setup {}
  -body {pending}
  -returnCodes error
  -result {pending}
}

#
# Cleanup
#
cleanupTests

