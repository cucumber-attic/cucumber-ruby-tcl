require 'cucumber/core/filter'

module Cucumber
  module Tcl

    ActivateSteps = Cucumber::Core::Filter.new(:create_step_definitions) do
      def test_case(test_case)
        activated_steps = test_case.test_steps.map do |test_step|
          step_definitions.attempt_to_activate(test_step)
        end
        test_case.with_steps(activated_steps).describe_to receiver
        reset_step_definitons
      end

      private

      def reset_step_definitons
        @step_definitions = nil
      end

      def step_definitions
        @step_definitions ||= create_step_definitions.call
      end
    end

  end
end

