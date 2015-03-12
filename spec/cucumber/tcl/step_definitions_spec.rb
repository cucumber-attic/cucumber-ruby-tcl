require 'cucumber/tcl'
require 'cucumber/core/ast'
require 'cucumber/core/test/step'

module Cucumber::Tcl
  describe StepDefinitions do

    it "can activate a passing tcl step" do
      tcl = Tcl::Interp.load_from_file File.dirname(__FILE__) + '/fixtures/everything_ok.tcl'
      step_definitions = StepDefinitions.new(tcl)
      location = double
      ast_step = double(name: double, location: location, multiline_arg: Cucumber::Core::Ast::EmptyMultilineArgument.new)
      test_step = Cucumber::Core::Test::Step.new([ ast_step ])
      expect(step_definitions.attempt_to_activate(test_step).location).to eq location
    end
  end
end
