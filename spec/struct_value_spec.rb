require 'spec_helper'

describe ValueStruct do
  it "should have a VERSION constant" do
    ValueStruct.const_get('VERSION').should_not be_empty
  end

  describe 'initialization' do
    subject do
      ValueStruct.new(:x, :y)
    end

    it 'creates Class instances' do
      should be_instance_of Class
    end
  end

  describe 'instance' do
    subject do
      Point = ValueStruct.new(:x, :y)
      Point.new(1,2)
    end

    it { should be_a Struct }
    it { should be_a ValueStruct::Core }

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

    it 'raises argument errors if not given the right number of arguments' do
      lambda{
        Point.new
      }.should raise_error(ArgumentError, 'wrong number of arguments (0 for 2)')
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
      debugger
    end
  end

  # describe '#clone and #dup return the same object' do
  #   it{ subject.object_id.should == subject.clone.object_id }
  #   it{ subject.object_id.should == subject.dup.object_id }
  # end
end
