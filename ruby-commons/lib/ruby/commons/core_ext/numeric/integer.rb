class Numeric
  ##
  # TODO:
  def self.mp_is_int?(obj)
    value = obj.to_s
    value.to_i.to_s == value
  end

  ##
  # TODO:
  def self.mp_to_i(value, default = nil)
    mp_is_int?(value) ? value.to_i : default
  end
end
