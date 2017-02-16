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
      # Unless configured off, we should start up a new
      # framework for each scenarion, which results
      # in a new TCL interpreter.  This can be used
      # to check that there is no data leakage between
      # scenarios when testing poorly understood code
      if ENV["NEW_INTERPRETER"].nil?
          new_interpreter = 1
      else 
          new_interpreter = ENV['NEW_INTERPRETER'].to_i
      end

      if new_interpreter == 1
          create_step_definitions = lambda {
            StepDefinitions.new(Framework.new(cucumber_config))
          }
      else
          framework = Framework.new(cucumber_config)
          create_step_definitions = lambda {
            StepDefinitions.new(framework)
          }
      end
      cucumber_config.filters << ActivateSteps.new(create_step_definitions)
    end

  end
end
