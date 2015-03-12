module Cucumber
  module Tcl
    class Framework
      TCL_FRAMEWORK_PATH = File.dirname(__FILE__) + '/framework.tcl'

      def initialize(path = TCL_FRAMEWORK_PATH)
        @tcl = ::Tcl::Interp.load_from_file(path)
      end

      def step_definition_exists?(step_name)
        @tcl.proc('step_definition_exists').call(step_name) == "1"
      end

      def execute_step_definition(*args)
        @tcl.proc('execute_step_definition').call(*args)
      end
    end
  end
end
