#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/extensiontask'
Rake::ExtensionTask.new('is_a')

desc "Simple dump test,just to check if extension compiles and does not segfault on simple dump"
task :test => :compile do
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


  require 'heap_dump'
  HeapDump.dump
end

task :default => :test