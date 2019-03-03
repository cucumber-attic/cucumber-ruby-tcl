module Cucumber
  module Tcl
    class Framework
      TCL_FRAMEWORK_PATH = File.dirname(__FILE__) + '/framework.tcl'

      def initialize(cucumber_config = nil, path = TCL_FRAMEWORK_PATH)
        @tcl = ::Tcl::Interp.load_from_file(path)

        all_files_to_load = cucumber_config.nil? ? [] : cucumber_config.all_files_to_load
        all_files_to_load.collect! {|f| f.gsub(/([\\\s{}])/, '\\\\\1')}
        @tcl.proc('source_files').call(all_files_to_load.join(' '))
      end

      def step_definition_exists?(step_name)
        @tcl.proc('step_definition_exists').call(step_name) == "1"
      end

      def execute_step_definition(*args)
        @tcl.proc('execute_step_definition').call(*args)
      end

      def next_scenario()
        @tcl.proc('next_scenario').call()
      end
    end
  end
end
