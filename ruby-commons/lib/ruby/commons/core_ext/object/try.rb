class Object
  ##
  # Invokes the public method whose name goes as first argument just like
  # +public_send+ does, except that if the receiver does not respond to it the
  # call returns +nil+ rather than raising an exception.
  #
  # This method is defined to be able to write
  #
  #   @person.mp_try(:name)
  #
  # instead of
  #
  #   @person.name if @person
  #
  # +mp_try+ calls can be chained:
  #
  #   @person.mp_try(:spouse).mp_try(:name)
  #
  # instead of
  #
  #   @person.spouse.name if @person && @person.spouse
  #
  # +mp_try+ will also return +nil+ if the receiver does not respond to the method:
  #
  #   @person.mp_try(:non_existing_method) #=> nil
  #
  # instead of
  #
  #   @person.non_existing_method if @person.respond_to?(:non_existing_method) #=> nil
  #
  # +mp_try+ returns +nil+ when called on +nil+ regardless of whether it responds
  # to the method:
  #
  #   nil.mp_try(:to_i) # => nil, rather than 0
  #
  # Arguments and blocks are forwarded to the method if invoked:
  #
  #   @posts.mp_try(:each_slice, 2) do |a, b|
  #     ...
  #   end
  #
  # The number of arguments in the signature must match. If the object responds
  # to the method the call is attempted and +ArgumentError+ is still raised
  # in case of argument mismatch.
  #
  # If +mp_try+ is called without arguments it yields the receiver to a given
  # block unless it is +nil+:
  #
  #   @person.mp_try do |p|
  #     ...
  #   end
  #
  # You can also call mp_try with a block without accepting an argument, and the block
  # will be instance_eval'ed instead:
  #
  #   @person.mp_try { upcase.truncate(50) }
  #
  # Please also note that +mp_try+ is defined on +Object+. Therefore, it won't work
  # with instances of classes that do not have +Object+ among their ancestors,
  # like direct subclasses of +BasicObject+. For example, using +mp_try+ with
  # +SimpleDelegator+ will delegate +mp_try+ to the target instead of calling it on
  # the delegator itself.
  def mp_try(*a, &b)
    mp_try!(*a, &b) if a.empty? || respond_to?(a.first)
  end

  ##
  # Same as #mp_try, but will raise a NoMethodError exception if the receiver is not +nil+ and
  # does not implement the tried method.
  def mp_try!(*a, &b)
    if a.empty? && block_given?
      if b.arity.zero?
        instance_eval(&b)
      else
        yield self
      end
    else
      public_send(*a, &b)
    end
  end
end

class NilClass
  ##
  # Calling +mp_try+ on +nil+ always returns +nil+.
  # It becomes especially helpful when navigating through associations that may return +nil+.
  #
  #   nil.mp_try(:name) # => nil
  #
  # Without +mp_try+
  #   @person && @person.children.any? && @person.children.first.name
  #
  # With +mp_try+
  #   @person.mp_try(:children).mp_try(:first).mp_try(:name)
  def mp_try(*args)
    nil
  end

  def mp_try!(*args)
    nil
  end
end
