# encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks

task default: [:cucumber]

task :cucumber do
  sh "cucumber -f pretty"
end
