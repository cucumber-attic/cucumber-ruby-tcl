require 'cucumber/tcl'
require 'cucumber/core/ast'
require 'cucumber/core/test/step'

module Cucumber::Tcl
  describe StepDefinitions do
    let(:location) { double }
    let(:test_step) {
      ast_step = double(name: double, location: location, multiline_arg: Cucumber::Core::Ast::EmptyMultilineArgument.new)
      Cucumber::Core::Test::Step.new([ ast_step ])
    }

    it "can activate a passing tcl step" do
      path = File.dirname(__FILE__) + '/fixtures/everything_ok.tcl'
      tcl_framework = Framework.new(path)
      step_definitions = StepDefinitions.new(tcl_framework)
      expect(step_definitions.attempt_to_activate(test_step).location).to eq location
    end

    it "raises a pending error when TCL returns a pending message" do
      tcl_framework = double(
        step_definition_exists?: true,
        execute_step_definition: "pending"
      )
      step_definitions = StepDefinitions.new(tcl_framework)
      result = step_definitions.attempt_to_activate(test_step).execute
      expect(result).to be_a Cucumber::Core::Test::Result::Pending
    end
  end
end
