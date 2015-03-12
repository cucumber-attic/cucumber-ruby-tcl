require 'cucumber/tcl/activate_steps'
require 'cucumber/tcl/step_definitions'

# Use Cucumber's configuration hook to install the plugin
if respond_to?(:AfterConfiguration)
  AfterConfiguration do |config|
    Cucumber::Tcl.install config
  end
end

module Cucumber
  module Tcl
    TCL_FRAMEWORK_PATH = File.dirname(__FILE__) + '/tcl/framework.tcl'

    def self.install(cucumber_config)
      create_step_definitions = lambda {
        tcl = ::Tcl::Interp.load_from_file(TCL_FRAMEWORK_PATH)
        StepDefinitions.new(tcl)
      }
      cucumber_config.filters << ActivateSteps.new(create_step_definitions)
    end

  end
end
