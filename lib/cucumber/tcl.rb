require 'cucumber/tcl/activate_steps'
require 'cucumber/tcl/step_definitions'

if respond_to?(:AfterConfiguration)
  AfterConfiguration do |config|
    step_definitions = Cucumber::Tcl::StepDefinitions.new(File.dirname(__FILE__) + '/tcl/framework.tcl')
    config.filters << Cucumber::Tcl::ActivateSteps.new(step_definitions)
  end
end
