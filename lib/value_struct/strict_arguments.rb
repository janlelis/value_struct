module ValueStruct::StrictArguments
  def initialize(*args, &block)
    super *args, &block
    unless size == args.size + (args[0].is_a?(String) ? 1 : 0)
      raise ArgumentError, "wrong number of arguments (#{args.size} for #{members.size})"
    end
  end
end