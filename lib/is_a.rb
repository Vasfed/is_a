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

  def self._ref2id obj
    self.id_of(obj)
  end
end

unless ObjectSpace.respond_to? :_ref2id
  module ObjectSpace
    def self._ref2id(obj)
      IsA._ref2id(obj)
    end
  end
end