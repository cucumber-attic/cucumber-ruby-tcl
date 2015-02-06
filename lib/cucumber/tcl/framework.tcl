#TODO load step defs from features/**/*.tcl
#TODO let that path be configurable from cucumber-ruby

proc step_definition_exists { step_name } {
  # TODO: search repository of registered steps
  return 1
}

proc execute_step_definition { step_name } {
  # TODO: execute from repository of registered steps
  puts "FIXME"
}
