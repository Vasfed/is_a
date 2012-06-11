require "is_a/version"

require 'rbconfig'
require "is_a.#{RbConfig::CONFIG['DLEXT']}"

module IsA
  # checks if object is an whole Object, not just BasicObject
  def self.object? obj
    cls = self.class_of(obj)
    loop do
      return true if cls == Object
      next if cls = cls.superclass
      return false
    end
  end
end
