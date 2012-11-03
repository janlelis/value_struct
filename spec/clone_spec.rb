require 'spec_helper'

describe ValueStruct::Clone do
  subject do
    ValueStruct.new_with_mixins(:x, :y, [ValueStruct::Clone]).new(1,2)
  end

  it{ subject.object_id.should == subject.clone.object_id }
  it{ subject.object_id.should_not == subject.dup.object_id }
end
