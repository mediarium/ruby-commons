class Hash
  ##
  # Returns a new hash with the results of running +block+ once for every value.
  # The keys are unchanged.
  #
  #   { a: 1, b: 2, c: 3 }.mp_transform_values { |k,v| v * 2 }
  #   # => { a: 2, b: 4, c: 6 }
  def mp_transform_values
    return enum_for(:mp_transform_values) unless block_given?
    result = self.class.new
    each do |key, value|
      result[key] = yield(key, value)
    end
    result
  end

  ##
  # Destructive +mp_transform_values+
  def mp_transform_values!
    return enum_for(:mp_transform_values!) unless block_given?
    each do |key, value|
      self[key] = yield(key, value)
    end
  end

  ##
  # Returns a new hash with all values converted by the block operation.
  # This includes the values from the root hash and from all
  # nested hashes and arrays.
  #
  #  hash = { person: { name: 'Rob', gender: 'Male' } }
  #
  #  hash.mp_deep_transform_values { |value| value.to_s.upcase }
  #  # => {:person=>{:name=>"ROB", :gender=>"MALE"}}
  def mp_deep_transform_values(&block)
    __mp_deep_transform_values_in_object(self, &block)
  end

  ##
  # Destructively converts all values by using the block operation.
  # This includes the values from the root hash and from all
  # nested hashes and arrays.
  def mp_deep_transform_values!(&block)
    __mp_deep_transform_values_in_object!(self, &block)
  end

# MARK: - Private Methods

  ##
  # Support methods for deep transforming nested hashes and arrays
  private
  def __mp_deep_transform_values_in_object(object, &block)
    case object
    when Hash
      object.each_with_object({}) do |(key, value), result|
        result[key] = __mp_deep_transform_values_in_object(yield(key, value), &block)
      end
    when Array
      object.map { |e| __mp_deep_transform_values_in_object(e, &block) }
    else
      object
    end
  end

  ##
  # Support methods for deep transforming nested hashes and arrays
  private
  def __mp_deep_transform_values_in_object!(object, &block)
    case object
    when Hash
      object.keys.each do |key|
        value = object.delete(key)
        object[key] = __mp_deep_transform_values_in_object!(yield(key, value), &block)
      end
      object
    when Array
      object.map! { |e| __mp_deep_transform_values_in_object!(e, &block) }
    else
      object
    end
  end
end
