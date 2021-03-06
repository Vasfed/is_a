require 'mkmf'
require 'debugger/ruby_core_source'

#TODO: get ruby_include from args
unless ARGV.any? {|arg| arg.include?('--with-ruby-include') }
  require 'rbconfig'
  bindir = RbConfig::CONFIG['bindir']
  ruby_libversion = RUBY_VERSION
  ruby_libversion = "1.9.1" if RUBY_VERSION == "1.9.2"
  if bindir =~ %r{(^.*/\.rbenv/versions)/([^/]+)/bin$}
    ruby_include = "#{$1}/#{$2}/include/ruby-#{ruby_libversion}/ruby-#{$2}"
    ARGV << "--with-ruby-include=#{ruby_include}"
  elsif bindir =~ %r{(^.*/\.rvm/rubies)/([^/]+)/bin$}
    ruby_include = "#{$1}/#{$2}/include/ruby-#{ruby_libversion}/#{$2}"
    ruby_include = "#{ENV['rvm_path']}/src/#{$2}" unless File.exist?(ruby_include)
    ARGV << "--with-ruby-include=#{ruby_include}"
  end
  puts "Using ruby source from #{ruby_include}"
end

hdrs = ->{
  res = %w{
    vm_core.h
  }.all?{|hdr| have_header(hdr)}
  have_struct_member("rb_iseq_t", "location", "vm_core.h")
  # 2.0.0+ has inaccessible rb_vm_get_sourceline (cannot link in runtime), but has rb_iseq_line_no
  res = res && (have_func("rb_iseq_line_no", ["vm_core.h", "method.h", "iseq.h"]) || have_func("rb_vm_get_sourceline", "vm_core.h"))
  res
}

module Debugger::RubyCoreSource
  class NoSourceException < RuntimeError; end
  # instead of aborting - throw an error
  def self.no_source_abort *args
    raise NoSourceException
  end
end

begin
  exit if Debugger::RubyCoreSource::create_makefile_with_core(hdrs, "is_a")
rescue Debugger::RubyCoreSource::NoSourceException
  STDERR.print("RubyCoreSource does not have support for your ruby revision\n")
end

if ruby_include
  puts "trying a workaround..."
  with_cppflags("-I" + ruby_include) {
    if hdrs.call
      create_makefile('is_a')
      exit
    end
  }
end


STDERR.print("Makefile creation failed\n")
STDERR.print("*************************************************************\n\n")
STDERR.print("  NOTE: If your headers were not found, try passing\n")
STDERR.print("        --with-ruby-include=PATH_TO_HEADERS      \n\n")
STDERR.print("*************************************************************\n\n")
exit(1)
