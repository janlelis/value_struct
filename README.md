# Value Struct

A value struct is a subclass of normal [Ruby struct](http://blog.grayproductions.net/articles/all_about_struct) that behaves almost the same. However, it has a major difference:

__Value structs are immutable, i.e. they don't have setters (although, not recursively*)__

Additionally, this gem provides the following optional mixins to make life easier when using immutable structs:

* __:dup_with_changes__ Extends `#dup` to take a optional hash for setting new values in the duplicate
* __:to_h__ Provides a method for converting the struct to a hash: `#to_h` (if Ruby version below < 2.0)
* __:strict_arguments__ Value structs need to be initialized with the exact amount of arguments
* __:freeze__ Automatically freezes new instances
* __:no_clone__ Alters `#clone` to return the same object

By default, only :dup_with_changes and :to_h get included.

Without mixins, ValueStructs are almost as fast as normal structs. Some (optional) mixins add noticable overhead, e.g. strict_arguments

## Why?

See [this blog article](http://rbjl.net/65-value_struct-read-only-structs-in-ruby) for more information.

## Example

    require 'value_struct'

    Point = ValueStruct.new(:x, :y) do # methods defined in the block will be available in your new value struct class
      # ...
    end

Please refer to the "documentation of Ruby's struct":http://www.ruby-doc.org/core-1.9.3/Struct.html for more details on general struct usage.

## How to use structs with mixins

    Point = ValueStruct.new_with_mixins :x, :y, [
      :to_h,
      :freeze,
      :dup_with_changes,
      :strict_arguments,
    ]

    p = Point.new(1,2)
    p.to_h       #=> { :x => 1, :y => 2 }
    p.frozen?    #=> true
    p.dup(x: 0)  #=> #<ValueStruct Point x=0, y=2>
    Point.new(1) # ArgumentError

Alternatively, you can put a custom module in the mixin array.

## *

Because of the nature of Ruby, most things are not really immutable. So if you have an attribute `:by` and initialize it with an array, you cannot change the value struct anymore, but still the array:

    Ru = ValueStruct.new(:by)
    ruby = Ru.by([1,2,3])
    ruby.by # => [1,2,3]

    ruby.by = [1,2,3,4] # not possible
    ruby.by << 4        # possible

## Install

    $ gem install value_struct

## Influenced by / Thanks to

* Tom Crayford: [Values](https://github.com/tcrayford/Values)
* Theo Hultberg: [ImmutableStruct](https://github.com/iconara/immutable_struct)
* Ruby Rogues

## J-_-L
