require 'tcl'
require 'cucumber/tcl/data_table'

module Cucumber
  module Tcl

    class StepDefinitions
      def initialize(tcl_framework)
        @tcl_framework = tcl_framework
      end

      def attempt_to_activate(test_step)
        return test_step unless match?(test_step)
        test_step.with_action &action_for(test_step)
      end

      private

      def match?(test_step)
        @tcl_framework.step_definition_exists?(test_step.name)
      end

      def action_for(test_step)
        arguments = ArgumentList.new(test_step)
        proc { 
          response = ExecuteResponse.new(@tcl_framework.execute_step_definition(*arguments))
          response.raise_any_pending_error
        }
      end

      class ExecuteResponse
        def initialize(raw)
          @raw = raw
        end

        def raise_any_pending_error
          if @raw == "pending"
            raise Cucumber::Core::Test::Result::Pending.new("TODO: Step not yet implemented")
          end
        end
      end

      class ArgumentList
        def initialize(test_step)
          @arguments = [test_step.name]
          test_step.source.last.multiline_arg.describe_to self
        end

        def doc_string(arg)
          @arguments << arg.content
        end

        def data_table(arg)
          @arguments << DataTable.new(arg)
        end

        def to_a
          @arguments
        end
      end
    end

  end
end
