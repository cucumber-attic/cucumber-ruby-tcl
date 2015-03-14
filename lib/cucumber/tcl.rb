require 'cucumber/tcl/activate_steps'
require 'cucumber/tcl/framework'
require 'cucumber/tcl/step_definitions'

# Use Cucumber's configuration hook to install the plugin
if respond_to?(:AfterConfiguration)
  AfterConfiguration do |config|
    Cucumber::Tcl.install config
  end
end

module Cucumber
  module Tcl

    def self.install(cucumber_config)
      create_step_definitions = lambda {
        StepDefinitions.new(Framework.new)
      }
      cucumber_config.filters << ActivateSteps.new(create_step_definitions)
    end

  end
end
