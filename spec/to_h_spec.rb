require 'spec_helper'

describe ValueStruct::ToH do
  subject do
    ValueStruct.new_with_mixins(:x, :y, [ValueStruct::ToH]).new(1,2)
  end

  its(:to_h) do
    { x: 1, y: 2 }
  end
end