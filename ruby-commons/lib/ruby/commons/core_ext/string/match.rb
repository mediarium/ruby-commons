class String
  ##
  # TODO
  def mp_match?(*several_variants)
    !match(*several_variants).nil?
  end
end
