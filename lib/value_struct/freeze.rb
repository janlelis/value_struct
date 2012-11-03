module ValueStruct::Freeze
  def initialize(*args, &block)
    super *args, &block
    freeze
  end
end