require 'spec_helper'

describe ValueStruct::DupWithChanges do
  subject do
    ValueStruct.new_with_mixins(:x, :y, [ValueStruct::DupWithChanges])
  end

  context 'no arguments' do
    it 'is equal' do
      a = subject.new(1,2)
      a.should == a.dup
    end

    it 'is another object' do
      a = subject.new(1,2)
      a.object_id.should == a.dup.object_id
    end
  end
end