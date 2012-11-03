module ValueStruct::ToH
  def to_h
    Hash[members.zip(values)]
  end
end