require 'spec_helper'

describe ValueStruct::DupWithChanges do
  subject do
    ValueStruct.new_with_mixins(:x, :y, [ValueStruct::DupWithChanges]).new(1,2)
  end

  context 'no arguments' do
    it 'is equal' do
      subject.should == subject.dup
    end

    it 'is another object' do
      subject.object_id.should_not == subject.dup.object_id
    end
  end

  context 'with arguments' do
    let(:modified){ subject.dup(y: 5) }
    it 'is equal, except for the changed field' do
      subject.x.should == modified.x
      subject.y.should_not == modified.y
    end
  end
end