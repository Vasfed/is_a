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

desc "Make simple benchmark for caller_line"
task :bench_caller_line do
  require 'bundler/setup'
  require 'is_a'
  require 'benchmark'
  n = 50000
  class UtilClassWithCallerline
    class << self
      define_method :caller_line, method(:caller_line)
    end
  end
  Benchmark.bm(19) do |x|
    x.report("caller[1]") { n.times { caller[1] } }
    x.report("caller_line") { n.times { caller_line(1) } }
    x.report("caller_line in ctx") { n.times { UtilClassWithCallerline.caller_line(1) } }
  end
end