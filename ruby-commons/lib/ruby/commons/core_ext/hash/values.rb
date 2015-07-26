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
end
