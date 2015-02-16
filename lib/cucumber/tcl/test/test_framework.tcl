package require tcltest 2
namespace import tcltest::*

source "./lib/cucumber/tcl/framework.tcl"

#
# Test Given
#
test Given-1 {calling Given with 2 parameters adds a new entry to the STEPS list with an empty parameters list} {
  -setup {
    set ::STEPS [list]
  }
  -body {
    Given {^Regular Expression$} { puts "Given RegExp" }
    expr { [llength $::STEPS] == 1 && [llength [lindex $::STEPS 0]] == 3}
  }
  -result 1
}

test Given-2 {calling Given twice adds 2 entries to the STEPS list} {
  -setup {
    set ::STEPS [list]
  }
  -body {
    Given {^Regular Expression$} { puts "Given RegExp" }
    Given {^Regular Expression 2$} { puts "Given RegExp 2" }
    expr { [llength $::STEPS] == 2 && [llength [lindex $::STEPS 0]] == 3}
  }
  -result 1
}

test Given-3 {calling Given with 3 parameters adds a new entry to the STEPS list} {
  -setup {
    set ::STEPS [list]
  }
  -body {
    Given {^Regular Expression (\d+)$} {match} { puts "Given RegExp $match" }
    expr { [llength $::STEPS] == 1 && [llength [lindex $::STEPS 0]] == 3}
  }
  -result 1
}

#
# Test _add_step
#
test _add_step-1 {calling _add_step with 2 parameters adds a new entry to the STEPS list with an empty parameters list} {
  -setup {
    set ::STEPS [list]
  }
  -body {
    _add_step {^Regular Expression$} { puts "Given RegExp" }
    expr { [llength $::STEPS] == 1 && [llength [lindex $::STEPS 0]] == 3}
  }
  -result 1
}

test _add_step-2 {calling _add_step twice adds 2 entries to the STEPS list} {
  -setup {
    set ::STEPS [list]
  }
  -body {
    _add_step {^Regular Expression$} { puts "Given RegExp" }
    _add_step {^Regular Expression 2$} { puts "Given RegExp 2" }
    expr { [llength $::STEPS] == 2 && [llength [lindex $::STEPS 0]] == 3}
  }
  -result 1
}

test _add_step-3 {calling _add_step with 3 parameters adds a new entry to the STEPS list} {
  -setup {
    set ::STEPS [list]
  }
  -body {
    _add_step {^Regular Expression (\d+)$} {match} { puts "Given RegExp $match" }
    expr { [llength $::STEPS] == 1 && [llength [lindex $::STEPS 0]] == 3}
  }
  -result 1
}

test _add_step-4 {calling _add_step with more than 3 parameters adds a new entry to the STEPS list} {
  -body {
    _add_step {^Match1 (\w+) Match2 (\d+) Match3 (\d+)$} {match1} {match2} {match3} { puts "Given RegExp $match" }
  }
  -returnCodes error
  -result {The parameters for this procedure are regular_expression ?list_of_capture_variables? body}
}



#
# Test When
#
test When-1 {calling When adds a new entry to the STEPS list} {
  -setup {
    set ::STEPS [list]
  }
  -body {
    When {^Regular Expression$} { puts "When RegExp" }
    expr { [llength $::STEPS] == 1 }
    expr { [llength $::STEPS] == 1 && [llength [lindex $::STEPS 0]] == 3}
  }
  -result 1
}



#
# Test Then
#
test Then-1 {calling Then adds a new entry to the STEPS list} {
  -setup {
    set ::STEPS [list]
  }
  -body {
    Then {^Regular Expression$} { puts "Then RegExp" }
    expr { [llength $::STEPS] == 1 && [llength [lindex $::STEPS 0]] == 3}
  }
  -result 1
}



#
# Test And
#
test And-1 {calling And adds a new entry to the STEPS list} {
  -setup {
    set ::STEPS [list]
  }
  -body {
    And {^Regular Expression$} { puts "And RegExp" }
    expr { [llength $::STEPS] == 1 && [llength [lindex $::STEPS 0]] == 3}
  }
  -result 1
}



#
# Test _search_steps procedure
#
test _search_steps-1 {_search_steps returns 0 if there are no existing steps} {
  -setup {
    set ::STEPS [list]
  }
  -body {
    _search_steps {Unknown Regexp}
  }
  -result 0
}

test _search_steps-2 {_search_steps returns 0 if there are no matching steps} {
  -setup {
    set ::STEPS [list [list {^First Step$} {} {puts "First Step"}]]
  }
  -body {
    _search_steps {Unknown Regexp}
  }
  -result 0
}

test _search_steps-3 {_search_steps returns 1 if there is a matching step} {
  -setup {
    set ::STEPS [list [list {^First Step$} {} {puts "First Step"}]]
  }
  -body {
    _search_steps {First Step}
  }
  -result 1
}

test _search_steps-4 {_search_steps returns 1 if there is a matching step with multiple values in STEPS} {
  -setup {
    set ::STEPS [list \
      [list {^First Step$} {} {puts "First Step"}] \
      [list {^Second Step$} {} {puts "Second Step"}] \
    ]
  }
  -body {
    _search_steps {Second Step}
  }
  -result 1
}

test _search_steps-5 {_search_steps returns 1 and executes body of step if there is a matching step and execute is set to 1} {
  -setup {
    set ::STEPS [list \
      [list {^First Step$} {} {puts "First Step"}] \
      [list {^Second Step$} {} {puts "Second Step"}] \
    ]
  }
  -body {
    _search_steps {Second Step} {1}
  }
  -result 1
  -match glob
  -output {Second Step*}
}

test _search_steps-6 {_search_steps returns 1 and executes body of step if there is a matching step and execute is set to 1 with a parameter in the match} {
  -setup {
    set ::STEPS [list \
      [list {^First Step$} {} {puts "First Step"}] \
      [list {^Second (\w+)$} {match} {puts "Second $match"}] \
    ]
  }
  -body {
    _search_steps {Second Step} {1}
  }
  -result 1
  -match glob
  -output {Second Step*}
}

test _search_steps-7 {_search_steps returns 1 and executes body of step if there is a matching step and execute is set to 1 with 2 parameters in the match} {
  -setup {
    set ::STEPS [list \
      [list {^First Step$} {} {puts "First Step"}] \
      [list {^(\w+) (\w+)$} {match1 match2} {puts "$match1 $match2"}] \
    ]
  }
  -body {
    _search_steps {Second Step} {1}
  }
  -result 1
  -match glob
  -output {Second Step*}
}

# Testing multiline args
test _search_steps-8 {_search_steps returns 1 and executes body of step if there is a matching step, execute is set to 1 and there is a multiline_arg passed in} {
  -setup {
    set ::STEPS [list \
      [list {^First Step$} {} {puts "First Step"}] \
      [list {^Second Step:$} {content} {puts "$content"}] \
    ]
  }
  -body {
    _search_steps {Second Step:} {1} {Multiline Content}
  }
  -result 1
  -match glob
  -output {Multiline Content*}
}

test _search_steps-9 {_search_steps returns 1 and executes body of step if there is a matching step, execute is set to 1 and there is a multiline_arg passed in and there is a parameter match in the regexp} {
  -setup {
    set ::STEPS [list \
      [list {^First Step$} {} {puts "First Step"}] \
      [list {^Second (\w+):$} {match1 content} {puts "content=$content, match=$match1"}] \
    ]
  }
  -body {
    _search_steps {Second Step:} {1} {Multiline Content}
  }
  -result 1
  -match glob
  -output {content=Multiline Content, match=Step*}
}

#
# Cleanup
#
cleanupTests

