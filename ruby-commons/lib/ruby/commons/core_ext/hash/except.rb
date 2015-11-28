class Hash
  # Returns a hash that includes everything but the given keys.
  #   hash = { a: true, b: false, c: nil}
  #   hash.mp_except(:c) # => { a: true, b: false}
  #   hash # => { a: true, b: false, c: nil}
  #
  # This is useful for limiting a set of parameters to everything but a few known toggles:
  #   @person.update(params[:person].mp_except(:admin))
  def mp_except(*keys)
    dup.mp_except!(*keys)
  end

  # Replaces the hash without the given keys.
  #   hash = { a: true, b: false, c: nil}
  #   hash.mp_except!(:c) # => { a: true, b: false}
  #   hash # => { a: true, b: false }
  def mp_except!(*keys)
    keys.each { |key| delete(key) }
    self
  end
end
