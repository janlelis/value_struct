require 'spec_helper'

describe ValueStruct do
  it "should have a VERSION constant" do
    ValueStruct.const_get('VERSION').should_not be_empty
  end

  describe 'struct class initialization and mixins' do
    subject do
      ValueStruct
    end

    describe '.new' do
      it 'calls .new_with_mixins and adds default mixins' do
        subject.should_receive(:new_with_mixins).with(
          :x, :y,  [ValueStruct::ToH, ValueStruct::DupWithChanges]
        )
        subject.new(:x, :y)
      end

      it 'adds the ValueStruct::DupWithChanges mixin' do
        subject.new(:x, :y).new(1,2).should be_a ValueStruct::DupWithChanges
      end

      it 'adds ValueStruct::ToH if ruby version is below 2.0' do
        if RUBY_VERSION < "2.0"
          subject.new(:x, :y).new(1,2).should be_a ValueStruct::ToH
        end
      end
    end

    describe '.new_with_mixins' do
      it 'must be initialized with an array as last parameter' do
        expect{
          subject.new_with_mixins(:x, :y)
        }.to raise_error(ArgumentError)

      end

      it 'calls .build without last argument' do
        mock = subject.build(:x, :y)
        subject.should_receive(:build).with(
          :x, :y
        ).and_return(mock)
        subject.new_with_mixins(:x, :y, [])
      end

      it 'always includes ValueStruct::Immutable in a new struct' do
        subject.new_with_mixins(:x, :y, []).new(1,2).should be_a ValueStruct::Immutable
      end

      it 'includes all mixins that are given in the last paramater array' do
        mixins = [
          ValueStruct::DupWithChanges,
          ValueStruct::ToH,
          ValueStruct::StrictArguments,
          ValueStruct::Freeze,
        ]
        res = subject.new_with_mixins(:x, :y, mixins).new(1,2)
        mixins.each{ |mixin|
          res.should be_a mixin
        }
      end

      it 'converts mixins given as symbols to sub-modules of ValueStruct' do
        subject.new_with_mixins(
          :x, :y, [:dup_with_changes]
        ).should include(ValueStruct::DupWithChanges)
      end
    end

    describe '.build' do
      it 'creates a class that creates value structs' do
        subject.build(:x, :y).new(1,2).should be_a ValueStruct
      end
    end
  end

  describe 'instance (value) struct behavior' do
    subject do
      Point = ValueStruct.new(:x, :y)
      Point.new(1,2)
    end

    it { should be_a Struct }
    it { should be_a ValueStruct::Immutable }

    it 'stores values accessible by readers' do
      subject.x.should == 1
      subject.y.should == 2
    end

    it 'does not define setters' do
      expect{ subject.x = 5 }.to raise_error(NoMethodError)
    end

    it 'does not allow mutatation using []= syntax' do
      expect{ subject[:x] = 5 }.to raise_error(NoMethodError)
    end

    it 'can be inherited from to add methods' do
      class GraphPoint < ValueStruct.new(:x, :y)
        def inspect
          "GraphPoint at #{x},#{y}"
        end
      end

      c = GraphPoint.new(0,0)
      c.inspect.should == 'GraphPoint at 0,0'
    end

    describe '#hash and equality' do
      Y = ValueStruct.new(:x, :y)

      it 'is equal to another value with the same fields' do
        Point.new(0,0).should == Point.new(0,0)
      end

      it 'is not equal to an object with a different class' do
        Point.new(0,0).should_not == Y.new(0,0)
      end

      it 'is not equal to another value with different fields' do
        Point.new(0,0).should_not == Point.new(0,1)
        Point.new(0,0).should_not == Point.new(1,0)
      end

      it 'has an equal hash if the fields are equal' do
        p = Point.new(0,0)
        p.hash.should == Point.new(0,0).hash
      end

      it 'has a non-equal hash if the fields are different' do
        p = Point.new(0,0)
        p.hash.should_not == Point.new(1,0).hash
      end

      it 'does not have an equal hash if the class is different' do
        Point.new(0,0).hash.should_not == Y.new(0,0).hash
      end
    end
  end
end
