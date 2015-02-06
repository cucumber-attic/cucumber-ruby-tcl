require 'cucumber/core/filter'

module Cucumber
  module Tcl
    ActivateSteps = Cucumber::Core::Filter.new(:step_definitions) do
      def test_case(test_case)
        activated_steps = test_case.test_steps.map do |test_step|
          attempt_to_activate(test_step)
        end
        test_case.with_steps(activated_steps).describe_to receiver
      end

      private

      def attempt_to_activate(test_step)
        return test_step unless step_definitions.match?(test_step.name)
        test_step.with_action &step_definitions.action_for(test_step.name)
      end
    end

    require 'tcl'
    class StepDefinitions
      def initialize(path)
        raise ArgumentError, "cucumber-tcl entry point #{path} does not exist." unless File.exists?(path)
        @tcl = ::Tcl::Interp.load_from_file(path)
      end

      def match?(step_name)
        @tcl.proc('step_definition_exists').call(step_name) == "1"
      end

      def action_for(step_name)
        proc { @tcl.proc('execute_step_definition').call(step_name) }
      end
    end
  end
end

if respond_to?(:AfterConfiguration)
  AfterConfiguration do |config|
    step_definitions = Cucumber::Tcl::StepDefinitions.new(File.dirname(__FILE__) + '/tcl/framework.tcl')
    config.filters << Cucumber::Tcl::ActivateSteps.new(step_definitions)
  end
end
