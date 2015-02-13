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
        return test_step unless step_definitions.match?(test_step)
        test_step.with_action &step_definitions.action_for(test_step)
      end
    end

  end
end

