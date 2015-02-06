require 'cucumber/tcl'

module Cucumber::Tcl
  describe StepDefinitions do
    it "can query for a step definition" do
      step_definitions = StepDefinitions.new(File.dirname(__FILE__) + '/steps.tcl')
      expect(step_definitions.match?('passing')).to be_truthy
    end
  end
end
