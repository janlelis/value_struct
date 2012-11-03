module ValueStruct::DupWithChanges
  def dup(changes = {})
    case changes
    when {}
      new(values)
    when Hash
      new(
        members.zip(values).map{ |member, value|
          if changes.has_key?(m)
            changes[m]
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