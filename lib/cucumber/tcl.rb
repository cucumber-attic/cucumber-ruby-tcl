require 'cucumber/tcl/activate_steps'
require 'cucumber/tcl/step_definitions'

if respond_to?(:AfterConfiguration)
  AfterConfiguration do |config|
    step_definitions = Cucumber::Tcl::StepDefinitions.new('features/support/env.tcl')
    config.filters << Cucumber::Tcl::ActivateSteps.new(step_definitions)
  end
end
