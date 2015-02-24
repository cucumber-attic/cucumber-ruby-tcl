require 'tcl'
require 'cucumber/tcl/data_table'

module Cucumber
  module Tcl

    class StepDefinitions
      def initialize(path)
        raise ArgumentError, "cucumber-tcl entry point #{path} does not exist." unless File.exists?(path)
        @tcl = ::Tcl::Interp.load_from_file(path)
      end

      def attempt_to_activate(test_step)
        return test_step unless match?(test_step)
        test_step.with_action &action_for(test_step)
      end

      private

      def match?(test_step)
        step_name = test_step.name
        @tcl.proc('step_definition_exists').call(step_name) == "1"
      end

      def action_for(test_step)
        step_name = test_step.name
        arguments = ArgumentList.new(step_name)
        test_step.source.last.multiline_arg.describe_to(arguments)
        proc { @tcl.proc('execute_step_definition').call(*arguments) }
      end

      class ArgumentList
        def initialize(*args)
          @arguments = args
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
