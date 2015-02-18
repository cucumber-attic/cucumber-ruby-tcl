require 'cucumber/tcl'
require 'cucumber/core/ast'

module Cucumber::Tcl
  describe StepDefinitions do
    it "can query for a step definition" do
      step_definitions = StepDefinitions.new(File.dirname(__FILE__) + '/fixtures/everything_is_defined.tcl')
      expect(step_definitions.match?(double(name: 'passing'))).to be_truthy
    end

    it "can activate a passing tcl step" do
      step_definitions = StepDefinitions.new(File.dirname(__FILE__) + '/fixtures/everything_passes.tcl')
      ast_step = double(multiline_arg: Cucumber::Core::Ast::EmptyMultilineArgument.new)
      test_step = double(name: "a step", source: [ ast_step ])
      expect { step_definitions.action_for(test_step).call }.not_to raise_error
    end
  end
end
