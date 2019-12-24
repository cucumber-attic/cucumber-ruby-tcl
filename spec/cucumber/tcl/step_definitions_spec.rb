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
    path = File.dirname(__FILE__) + '/fixtures/everything_ok.tcl'
    let(:tcl_framework) { Framework.new(nil, path) }

    it "can activate a passing tcl step" do
      allow(tcl_framework).to receive(:next_scenario)
      step_definitions = StepDefinitions.new(tcl_framework)
      expect(step_definitions.attempt_to_activate(test_step).location).to eq location
    end

    it "raises a pending error when TCL returns a pending message" do
      allow(tcl_framework).to receive(:next_scenario)
      allow(tcl_framework).to receive(:execute_step_definition).and_return("pending")
      step_definitions = StepDefinitions.new(tcl_framework)
      result = step_definitions.attempt_to_activate(test_step).execute
      expect(result).to be_a Cucumber::Core::Test::Result::Pending
    end
  end
end
