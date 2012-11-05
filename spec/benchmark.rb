require_relative '../lib/value_struct'
require 'benchmark'
require 'immutable_struct'
require 'values'

COUNT = 1_000_000

def benchmark_for(struct_class)
  puts "%20s: %s" % [
    struct_class,
    Benchmark.measure do
      struct = struct_class.new(:a, :b, :c, :d)
       COUNT.times{
        n = struct.new(nil, nil, nil, nil)
        s = struct.new([1,2,3,4], "value", 23432421412, n)
        s.a == s.b
        s.c == s.d
        s == n
      }
    end
  ]
end

def benchmark_for_hash
  puts "%20s: %s" % [
    "[Hash]",
    Benchmark.measure do
      COUNT.times{
        n = { a: nil, b: nil, c: nil, d: nil }
        s = { a: [1,2,3,4], b: "value", c: 23432421412, d: nil }
        s[:a] == s[:b]
        s[:c] == s[:d]
        s == n
      }
    end
  ]
end


benchmark_for(Struct)
benchmark_for(Value)
benchmark_for(ImmutableStruct)
benchmark_for(ValueStruct)
benchmark_for_hash
