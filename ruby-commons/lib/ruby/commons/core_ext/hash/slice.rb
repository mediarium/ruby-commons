class Hash
  # Slice a hash to include only the given keys. Returns a hash containing 
  # the given keys.
  # 
  #   { a: 1, b: 2, c: 3, d: 4 }.mp_slice(:a, :b)
  #   # => {:a=>1, :b=>2}
  # 
  # This is useful for limiting an options hash to valid keys before 
  # passing to a method:
  #
  #   def search(criteria = {})
  #     criteria.assert_valid_keys(:mass, :velocity, :time)
  #   end
  #
  #   search(options.mp_slice(:mass, :velocity, :time))
  #
  # If you have an array of keys you want to limit to, you should splat them:
  #
  #   valid_keys = [:mass, :velocity, :time]
  #   search(options.mp_slice(*valid_keys))
  def mp_slice(*keys)
    keys.map! { |key| convert_key(key) } if respond_to?(:convert_key, true)
    keys.each_with_object(self.class.new) { |k, hash| hash[k] = self[k] if has_key?(k) }
  end

  # Replaces the hash with only the given keys.
  # Returns a hash containing the removed key/value pairs.
  #
  #   { a: 1, b: 2, c: 3, d: 4 }.mp_slice!(:a, :b)
  #   # => {:c=>3, :d=>4}
  def mp_slice!(*keys)
    keys.map! { |key| convert_key(key) } if respond_to?(:convert_key, true)
    omit = mp_slice(*self.keys - keys)
    hash = mp_slice(*keys)
    hash.default      = default
    hash.default_proc = default_proc if default_proc
    replace(hash)
    omit
  end

  # Removes and returns the key/value pairs matching the given keys.
  #
  #   { a: 1, b: 2, c: 3, d: 4 }.mp_extract!(:a, :b) # => {:a=>1, :b=>2}
  #   { a: 1, b: 2 }.mp_extract!(:a, :x)             # => {:a=>1}
  def mp_extract!(*keys)
    keys.each_with_object(self.class.new) { |key, result| result[key] = delete(key) if has_key?(key) }
  end
end
