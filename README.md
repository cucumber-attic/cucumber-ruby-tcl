Cucumber TCL Bindings
=====================

Define Cucumber steps using TCL code.

How to use
----------

First, add the project to your Gemfile:

    gem 'cucumber-tcl'

Install it:

    bundle install

Add a file to Cucumber's load path, like `features/support/env.rb` that has the following line:

    require 'cucumber/tcl'

Finally, add a TCL entry point, at `features/support/env.tcl`.

Your TCL program must implement two procs: `step_definition_exists` and `execute_step_definition`. For example:

    proc step_definition_exists {step_name} {
      return 1
    }

    proc execute_step_definition {step_name} {
      puts "Hello world"
    }
