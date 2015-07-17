class Object
	# Gets a value from an Object using a dot separated path.
	#
  #  { a: 1, b: { c: 3, d: [1, 2, 3] } }.mp_path('b.d')   # => [1, 2, 3]
  #  { a: 1, b: { c: 3, d: [1, 2, 3] } }.mp_path('b.d.1') # => 2
  def mp_path(path = '', default = nil, delimiter = '.')
    value = self

    path.to_s.split(delimiter).each do |key|
      index = key.to_i

      unless value.respond_to?(:[])
        value = nil
        break
      end

      if key == index.to_s
        value = value[index]
      elsif value.respond_to?(:key?)
        value = value.key?(key) ? value[key] : value[key.to_sym]
      else
        value = nil
      end

      break if value.nil?
    end

    value || default
  end
end
