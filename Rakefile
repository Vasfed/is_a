#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/extensiontask'
Rake::ExtensionTask.new('is_a')

desc "Simple dump test,just to check if extension compiles and does not segfault on simple dump"
task :test => :compile do

  #TODO: use some testing framework like minitest...

  require "bundler/setup"
  require 'is_a'

  class SomeDSL < BasicObject
    def initialize
      @search_me = 12345
    end
    def lala
    end
  end

  obj = SomeDSL.new

  def cls obj
    cls = IsA.class_of(obj)
    cls1 = cls
    classes = []
    while cls = cls.superclass
      classes << cls
    end

    puts "Cls is #{cls1.inspect}, #{classes.inspect}"
    cls1
  end

  c = cls obj
  cls c
  cls nil

  id = IsA.id_of(obj)
  puts "Id is #{id}"
  if ObjectSpace._id2ref(id) == obj
    puts "Getref ok"
  else
    puts "Getref FAIL"
  end

  unless IsA.object?(obj)
    puts "object? ok"
  else
    puts "object? FAIL"
  end

  if IsA.object?(c)
    puts "object? ok"
  else
    puts "object? FAIL"
  end

  def test_caller
    puts "Real caller: #{caller[0]}"
    puts "Caller at 0: #{IsA.caller_line(0)}"
    puts caller_line
  end

  test_caller

  require 'benchmark'
  n = 10000
  Benchmark.bm(11) do |x|
    x.report("caller[1]") { n.times { caller[1] } }
    x.report("caller_line") { n.times { caller_line(1) } }
  end

  #require 'heap_dump'
  #HeapDump.dump
end

task :default => :test