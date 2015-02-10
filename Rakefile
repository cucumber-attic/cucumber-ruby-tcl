# encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks

task default: [:rspec, :cucumber, :tcltest]

task :rspec do
  sh "rspec"
end

task :cucumber do
  sh "cucumber -f pretty"
end

task :tcltest do
  sh "export TEST=1 && tclsh8.5 lib/cucumber/tcl/test/test_framework.tcl"
end
