module ValueStruct::Immutable
  def self.included(struct)
    struct.send(:undef_method, :"[]=")
    struct.members.each{ |member|
      struct.send(:undef_method, :"#{member}=")
    }
  end
end