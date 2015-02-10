package require tcltest 2
namespace import tcltest::*

source "./lib/cucumber/tcl/framework.tcl"

#
# Test Given
#
test Given-1 {calling Given adds a new entry to the STEPS list} {
  -setup {
    set ::STEPS [list]
  }
  -body {
    Given {^Regular Expression$} { puts "Given RegExp" }
    expr { [llength $::STEPS] == 1 }
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
    expr { [llength $::STEPS] == 2 }
  }
  -result 1
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
    expr { [llength $::STEPS] == 1 }
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
    expr { [llength $::STEPS] == 1 }
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
    set ::STEPS [list [list {^First Step$} {puts "First Step"}]]
  }
  -body {
    _search_steps {Unknown Regexp}
  }
  -result 0
}

test _search_steps-3 {_search_steps returns 1 if there is a matching step} {
  -setup {
    set ::STEPS [list [list {^First Step$} {puts "First Step"}]]
  }
  -body {
    _search_steps {First Step}
  }
  -result 1
}

test _search_steps-4 {_search_steps returns 1 if there is a matching step with multiple values in STEPS} {
  -setup {
    set ::STEPS [list \
      [list {^First Step$} {puts "First Step"}] \
      [list {^Second Step$} {puts "Second Step"}] \
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
      [list {^First Step$} {puts "First Step"}] \
      [list {^Second Step$} {puts "Second Step"}] \
    ]
  }
  -body {
    _search_steps {Second Step} {1}
  }
  -result 1
  -match glob
  -output {Second Step*}
}


#
# Cleanup
#
cleanupTests

