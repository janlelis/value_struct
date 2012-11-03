# Value Struct

A value struct is a subclass of normal [Ruby struct](http://blog.grayproductions.net/articles/all_about_struct) that behaves almost the same. However, it has a major difference:

__Value structs are immutable, i.e. they don't have setters (although, not recursively*)__

This gem also provides the following mixins, to make life easier when using immutable structs:

2) Value structs need to be initialized with the exact amount of arguments
4) #dup takes a optional hash for setting new values
5) #to_h for converting into a hash (if Ruby version below < 2.0)

## Why?

Sometimes you want to eliminate state. See [this blog article] for more information.

## Example

    require 'value_struct'

    Point = ValueStruct.new(:x, :y) do # methods defined in the block will be available in your new value struct class
      def <=>
    end

Please refer to the [documentation of Ruby's struct] for more details on usage.

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

* Ruby Rogues #123
* Tom Crayford: [Values](https://github.com/tcrayford/Values)

## J-_-L