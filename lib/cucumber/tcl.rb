require 'cucumber/tcl/activate_steps'
require 'cucumber/tcl/step_definitions'

if respond_to?(:AfterConfiguration)
  AfterConfiguration do |config|
    create_step_definitions = lambda {
      Cucumber::Tcl::StepDefinitions.new(File.dirname(__FILE__) + '/tcl/framework.tcl')
    }
    config.filters << Cucumber::Tcl::ActivateSteps.new(create_step_definitions)
  end
end
