require 'tcl'

module Cucumber
  module Tcl

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
