module ValueStruct::Core
  def inspect
    super.to_s.sub('struct', 'ValueStruct')
  end

  def self.included(struct)
    struct.send(:undef_method, "[]=".to_sym)
    struct.members.each do |member|
      struct.send(:undef_method, "#{member}=".to_sym)
    end
  end
end