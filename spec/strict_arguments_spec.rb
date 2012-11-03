require 'spec_helper'

describe ValueStruct::StrictArguments do
  subject do
    ValueStruct.new_with_mixins(:x, :y, [ValueStruct::StrictArguments]).new
  end

  it 'raises argument errors if not given the right number of arguments' do
    lambda{
      subject.new
    }.should raise_error(ArgumentError, 'wrong number of arguments (0 for 2)')
  end
end