require_relative 'value_struct/version'

require_relative 'value_struct/immutable'
require_relative 'value_struct/to_h'
require_relative 'value_struct/dup_with_changes'
require_relative 'value_struct/strict_arguments'
require_relative 'value_struct/no_clone'
require_relative 'value_struct/freeze'

class ValueStruct < Struct
  class << self
    alias build new

    def new_with_mixins(*args, mixins, &block)
      raise ArgumentError, 'mixin list (last paramater) must be an array' unless mixins.is_a? Array

      struct_class = build(*args, &block)
      struct_class.send(:include, ValueStruct::Immutable)

      mixins.each{ |mixin|
        if mixin.is_a?(Symbol) # convenient including bundled mixins ala :dup_with_changes
          mixin = ValueStruct.const_get(mixin.to_s.gsub(/(?:^|_)([a-z])/){ $1.upcase })
        end
        struct_class.send(:include, mixin)
      }

      struct_class
    end

    def new(*args, &block)
      mixins = [ValueStruct::DupWithChanges]
      mixins.unshift(ValueStruct::ToH) if RUBY_VERSION < "2.0"
      new_with_mixins(*args, mixins, &block)
    end
  end

  def inspect
    super.to_s.sub('struct', 'ValueStruct')
  end
end