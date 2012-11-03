require 'spec_helper'

describe ValueStruct::Freeze do
  subject do
    ValueStruct.new_with_mixins(:x, :y, [ValueStruct::Freeze]).new
  end

  it 'freezes new instances' do
    should be_frozen
  end
end