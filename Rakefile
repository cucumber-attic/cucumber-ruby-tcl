# encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks

task default: [:rspec, :cucumber]

task :rspec do
  sh "rspec"
end

task :cucumber do
  sh "cucumber -f pretty"
end
