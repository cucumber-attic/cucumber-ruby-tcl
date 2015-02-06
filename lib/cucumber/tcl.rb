require 'cucumber/core/filter'

module Cucumber
  module Tcl
    ActivateSteps = Cucumber::Core::Filter.new(:step_definitions) do
      def test_case(test_case)
        activated_steps = test_case.test_steps.map do |test_step|
          step_definitions.attempt_to_activate(test_step)
        end
        test_case.with_steps(activated_steps).describe_to receiver
      end

      private

      def attempt_to_activate(test_step)
        test_step.with_action { puts "Hello world" }
      end
    end

    require 'tcl'
    class StepDefinitions
      def initialize(path)
        raise ArgumentError, "cucumber-tcl entry point #{path} does not exist." unless File.exists?(path)
        @tcl = ::Tcl::Interp.load_from_file(path)
      end

      def attempt_to_activate(test_step)
        if @tcl.proc('step_definition_exists').call(test_step.name) == "1"
          test_step.with_action { @tcl.proc('execute_step_definition').call(test_step.name) }
        else
          test_step
        end
      end

      def load
        self
      end
    end
  end
end

if respond_to?(:AfterConfiguration)
  AfterConfiguration do |config|
    step_definitions = Cucumber::Tcl::StepDefinitions.new('features/support/env.tcl')
    config.filters << Cucumber::Tcl::ActivateSteps.new(step_definitions)
  end
end
