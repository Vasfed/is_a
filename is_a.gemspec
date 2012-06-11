# -*- encoding: utf-8 -*-
require File.expand_path('../lib/is_a/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Vasily Fedoseyev"]
  gem.email         = ["vasilyfedoseyev@gmail.com"]
  gem.description   = %q{Fear weak references to BasicObject no more}
  gem.summary       = %q{Defines methods to introspect any ruby object more deeply}
  gem.homepage      = "http://github.com/Vasfed/is_a"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "is_a"
  gem.require_paths = ["lib"]
  gem.version       = IsA::VERSION

  gem.extensions = "ext/is_a/extconf.rb"

  gem.add_development_dependency "rake-compiler"
end
