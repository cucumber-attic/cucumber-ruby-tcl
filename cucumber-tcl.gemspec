# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'cucumber-tcl'
  s.version     = File.read('lib/cucumber/tcl/version')
  s.authors     = ["Matt Wynne", "Jon Overs", "Barney Fisher"]
  s.description = "TCL plugin for Cucumber"
  s.summary     = "cucumber-tcl-#{s.version}"
  s.email       = 'cukes@googlegroups.com'
  s.license     = 'MIT'
  s.homepage    = "https://github.com/cucumber/cucumber-ruby-tcl"
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.9.3"

  s.add_dependency 'ruby-tcl'
  s.add_dependency 'cucumber-core'

  s.add_development_dependency 'cucumber', '~> 2.0.0.rc.4'
  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency 'aruba', '~> 0.6'
  s.add_development_dependency 'yard', '~> 0.8'
  s.add_development_dependency 'rake', '~> 10.0'

  s.rubygems_version = ">= 1.6.1"
  s.files            = `git ls-files`.split("\n").reject {|path| path =~ /\.gitignore$/ }
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
