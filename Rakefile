#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :test => :spec

task :cover do
  ENV["COVERAGE"] = 'true'
  Rake::Task["spec"].execute
end