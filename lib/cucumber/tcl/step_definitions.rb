require 'tcl'

module Cucumber
  module Tcl

    class StepDefinitions
      def initialize(path)
        raise ArgumentError, "cucumber-tcl entry point #{path} does not exist." unless File.exists?(path)
        @tcl = ::Tcl::Interp.load_from_file(path)
      end

      def match?(test_step)
        step_name = test_step.name
        @tcl.proc('step_definition_exists').call(step_name) == "1"
      end

      def action_for(test_step)
        step_name = test_step.name
        multiline_arg = test_step.source.last.multiline_arg
        # multiline_arg will either be:
        # http://www.rubydoc.info/github/cucumber/cucumber-ruby-core/master/Cucumber/Core/Ast/EmptyMultilineArgument
        # http://www.rubydoc.info/github/cucumber/cucumber-ruby-core/master/Cucumber/Core/Ast/DocString
        # http://www.rubydoc.info/github/cucumber/cucumber-ruby-core/master/Cucumber/Core/Ast/DataTable
        #
        # I suppose we need to pass it to the Tcl now, but maybe not if it's the null object (EmptyMultilineArgument)
        # You can call describe_to on these objects to find out what they are.

        if multiline_arg.respond_to?('content')
          proc { @tcl.proc('execute_step_definition').call(step_name, multiline_arg.content) }
        else
          proc { @tcl.proc('execute_step_definition').call(step_name) }
        end
      end
    end

  end
end
