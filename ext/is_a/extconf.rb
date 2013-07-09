require 'mkmf'
require 'debugger/ruby_core_source'

unless ARGV.any? {|arg| arg.include?('--with-ruby-include') }
  require 'rbconfig'
  bindir = RbConfig::CONFIG['bindir']
  if bindir =~ %r{(^.*/\.rbenv/versions)/([^/]+)/bin$}
    ruby_include = "#{$1}/#{$2}/include/ruby-1.9.1/ruby-#{$2}"
    ARGV << "--with-ruby-include=#{ruby_include}"
  elsif bindir =~ %r{(^.*/\.rvm/rubies)/([^/]+)/bin$}
    ruby_include = "#{$1}/#{$2}/include/ruby-1.9.1/#{$2}"
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
  have_func("rb_vm_get_sourceline", "vm_core.h")
  res
}

# create_makefile('is_a')
if !Debugger::RubyCoreSource::create_makefile_with_core(hdrs, "is_a")
  STDERR.print("Makefile creation failed\n")
  STDERR.print("*************************************************************\n\n")
  STDERR.print("  NOTE: If your headers were not found, try passing\n")
  STDERR.print("        --with-ruby-include=PATH_TO_HEADERS      \n\n")
  STDERR.print("*************************************************************\n\n")
  exit(1)
end