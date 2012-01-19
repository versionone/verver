#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'ci/reporter/rake/rspec'

desc "Default: run specs."
task :default => :spec

desc "Run specs."
RSpec::Core::RakeTask.new do |t|
end

namespace :ci do

  desc "setup rspect for JUnit output & run specs"
  task :spec => ['ci:pre_spec', 'ci:setup:rspec', 'rake:spec']

  task :pre_spec do
    ENV['CI_REPORTS'] = 'spec/reports'
  end
end
