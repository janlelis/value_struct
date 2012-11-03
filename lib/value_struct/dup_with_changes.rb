module ValueStruct::DupWithChanges
  def dup(changes = {})
    case changes
    when {}
      self.class.new(*values)
    when Hash
      self.class.new(
        *members.zip(values).map{ |member, value|
          if changes.has_key?(member)
            changes[member]
          else
            value
          end
        }
      )
    else
      raise ArgumentError, 'dup must be given a Hash or nothing'
    end
  end
end