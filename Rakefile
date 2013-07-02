#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/extensiontask'
Rake::ExtensionTask.new('is_a')

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.libs.push 'spec'
end


desc "Simple dump test,just to check if extension compiles and does not segfault on simple dump"
task :test => :compile

task :default => :test