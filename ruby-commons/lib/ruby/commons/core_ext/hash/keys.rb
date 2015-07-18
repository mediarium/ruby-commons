class Hash
  ##
  # Returns a new hash with all keys converted using the block operation.
  #
  #  hash = { name: 'Rob', age: '28' }
  #
  #  hash.mp_transform_keys { |key| key.to_s.upcase }
  #  # => {"NAME"=>"Rob", "AGE"=>"28"}
  def mp_transform_keys
    return enum_for(:mp_transform_keys) unless block_given?
    result = self.class.new
    each_key do |key|
      result[yield(key)] = self[key]
    end
    result
  end

  ##
  # Destructively converts all keys using the block operations.
  # Same as +mp_transform_keys+ but modifies +self+.
  def mp_transform_keys!
    return enum_for(:mp_transform_keys!) unless block_given?
    keys.each do |key|
      self[yield(key)] = delete(key)
    end
    self
  end

  ##
  # Returns a new hash with all keys converted to strings.
  #
  #   hash = { name: 'Rob', age: '28' }
  #
  #   hash.mp_stringify_keys
  #   # => {"name"=>"Rob", "age"=>"28"}
  def mp_stringify_keys
    mp_transform_keys(&:to_s)
  end

  ##
  # Destructively converts all keys to strings. Same as
  # +mp_stringify_keys+, but modifies +self+.
  def mp_stringify_keys!
    mp_transform_keys!(&:to_s)
  end

  ##
  # Returns a new hash with all keys converted to symbols, as long as
  # they respond to +to_sym+.
  #
  #   hash = { 'name' => 'Rob', 'age' => '28' }
  #
  #   hash.mp_symbolize_keys
  #   # => {:name=>"Rob", :age=>"28"}
  def mp_symbolize_keys
    mp_transform_keys { |key| key.to_sym rescue key }
  end
  alias_method :mp_to_options,  :mp_symbolize_keys

  ##
  # Destructively converts all keys to symbols, as long as they respond
  # to +to_sym+. Same as +mp_symbolize_keys+, but modifies +self+.
  def mp_symbolize_keys!
    mp_transform_keys! { |key| key.to_sym rescue key }
  end
  alias_method :mp_to_options!, :mp_symbolize_keys!

  ##
  # Returns a new hash with all keys converted by the block operation.
  # This includes the keys from the root hash and from all
  # nested hashes and arrays.
  #
  #  hash = { person: { name: 'Rob', age: '28' } }
  #
  #  hash.mp_deep_transform_keys { |key| key.to_s.upcase }
  #  # => {"PERSON"=>{"NAME"=>"Rob", "AGE"=>"28"}}
  def mp_deep_transform_keys(&block)
    __mp_deep_transform_keys_in_object(self, &block)
  end

  ##
  # Destructively converts all keys by using the block operation.
  # This includes the keys from the root hash and from all
  # nested hashes and arrays.
  def mp_deep_transform_keys!(&block)
    __mp_deep_transform_keys_in_object!(self, &block)
  end

  ##
  # Returns a new hash with all keys converted to strings.
  # This includes the keys from the root hash and from all
  # nested hashes and arrays.
  #
  #   hash = { person: { name: 'Rob', age: '28' } }
  #
  #   hash.mp_deep_stringify_keys
  #   # => {"person"=>{"name"=>"Rob", "age"=>"28"}}
  def mp_deep_stringify_keys
    mp_deep_transform_keys(&:to_s)
  end

  ##
  # Destructively converts all keys to strings.
  # This includes the keys from the root hash and from all
  # nested hashes and arrays.
  def mp_deep_stringify_keys!
    mp_deep_transform_keys!(&:to_s)
  end

  ##
  # Returns a new hash with all keys converted to symbols, as long as
  # they respond to +to_sym+. This includes the keys from the root hash
  # and from all nested hashes and arrays.
  #
  #   hash = { 'person' => { 'name' => 'Rob', 'age' => '28' } }
  #
  #   hash.mp_deep_symbolize_keys
  #   # => {:person=>{:name=>"Rob", :age=>"28"}}
  def mp_deep_symbolize_keys
    mp_deep_transform_keys { |key| key.to_sym rescue key }
  end

  ##
  # Destructively converts all keys to symbols, as long as they respond
  # to +to_sym+. This includes the keys from the root hash and from all
  # nested hashes and arrays.
  def mp_deep_symbolize_keys!
    mp_deep_transform_keys! { |key| key.to_sym rescue key }
  end

  ##
  # Support methods for deep transforming nested hashes and arrays
  private
  def __mp_deep_transform_keys_in_object(object, &block)
    case object
    when Hash
      object.each_with_object({}) do |(key, value), result|
        result[yield(key)] = __mp_deep_transform_keys_in_object(value, &block)
      end
    when Array
      object.map { |e| __mp_deep_transform_keys_in_object(e, &block) }
    else
      object
    end
  end

  ##
  # Support methods for deep transforming nested hashes and arrays
  private
  def __mp_deep_transform_keys_in_object!(object, &block)
    case object
    when Hash
      object.keys.each do |key|
        value = object.delete(key)
        object[yield(key)] = __mp_deep_transform_keys_in_object!(value, &block)
      end
      object
    when Array
      object.map! { |e| __mp_deep_transform_keys_in_object!(e, &block) }
    else
      object
    end
  end
end
