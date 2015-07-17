class Hash
  # Returns a hash with non +nil+ values.
  #
  #   hash = { a: true, b: false, c: nil}
  #   hash.compact # => { a: true, b: false}
  #   hash # => { a: true, b: false, c: nil}
  #   { c: nil }.compact # => {}
  def mp_compact
    self.select { |_, value| !value.nil? }
  end

  # Replaces current hash with non +nil+ values.
  #
  #   hash = { a: true, b: false, c: nil}
  #   hash.compact! # => { a: true, b: false}
  #   hash # => { a: true, b: false}
  def mp_compact!
    self.reject! { |_, value| value.nil? }
  end

  # TODO:
  def mp_deep_compact!
    proc_val = Proc.new {}
    proc_hsh = Proc.new {}

    proc_val = Proc.new do |v|
      result = false
      case v
        when Hash
          v.reject!(&proc_hsh)
        when Array
          v.each(&proc_val)
        else
          result = v.nil?
      end
      result
    end

    proc_hsh = Proc.new do |k, v|
      proc_val.call(v)
    end

    delete_if(&proc_hsh)
  end
end
