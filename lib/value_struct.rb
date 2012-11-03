require_relative 'value_struct/version'
require_relative 'value_struct/core'
require_relative 'value_struct/to_h'
require_relative 'value_struct/dup_with_changes'
require_relative 'value_struct/strict_arguments'
require_relative 'value_struct/clone'
require_relative 'value_struct/freeze'

class ValueStruct < Struct
  def self.build(*args, &block)
    struct_class = Struct.new(*args, &block)
    struct_class.send(:include, ValueStruct::Core)
    struct_class
  end

  def self.new_with_mixins(*args, mixins, &block)
    raise ArgumentError, 'mixin list (last paramater) must be an array' unless mixins.is_a? Array
    struct_class = build(*args, &block)
    mixins.each{ |mixin| struct_class.send(:include, mixin) }
    struct_class
  end

  def self.new(*args, &block)
    mixins = [ValueStruct::DupWithChanges]
    mixins.unshift(ValueStruct::ToH) if RUBY_VERSION < "2.0"
    new_with_mixins(*args, mixins, &block)
  end
end