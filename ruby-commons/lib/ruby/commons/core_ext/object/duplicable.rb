#--
# Most objects are cloneable, but not all. For example you can't dup +nil+:
#
#   nil.dup # => TypeError: can't dup NilClass
#
# Classes may signal their instances are not duplicable removing +dup+/+clone+
# or raising exceptions from them. So, to dup an arbitrary object you normally
# use an optimistic approach and are ready to catch an exception, say:
#
#   arbitrary_object.dup rescue object
#
# Rails dups objects in a few critical spots where they are not that arbitrary.
# That rescue is very expensive (like 40 times slower than a predicate), and it
# is often triggered.
#
# That's why we hardcode the following cases and check +mp_duplicable?+ instead
# of using that rescue idiom.
#++
class Object
  ##
  # Can you safely dup this object?
  #
  # False for +nil+, +false+, +true+, symbol, number objects;
  # true otherwise.
  def mp_duplicable?
    true
  end
end

class NilClass
  ##
  # +nil+ is not duplicable:
  #
  #   nil.mp_duplicable? # => false
  #   nil.dup            # => TypeError: can't dup NilClass
  def mp_duplicable?
    false
  end
end

class FalseClass
  ##
  # +false+ is not duplicable:
  #
  #   false.mp_duplicable? # => false
  #   false.dup            # => TypeError: can't dup FalseClass
  def mp_duplicable?
    false
  end
end

class TrueClass
  ##
  # +true+ is not duplicable:
  #
  #   true.mp_duplicable? # => false
  #   true.dup            # => TypeError: can't dup TrueClass
  def mp_duplicable?
    false
  end
end

class Symbol
  ##
  # Symbols are not duplicable:
  #
  #   :my_symbol.mp_duplicable? # => false
  #   :my_symbol.dup            # => TypeError: can't dup Symbol
  def mp_duplicable?
    false
  end
end

class Numeric
  ##
  # Numbers are not duplicable:
  #
  #  3.mp_duplicable? # => false
  #  3.dup            # => TypeError: can't dup Fixnum
  def mp_duplicable?
    false
  end
end

require 'bigdecimal'
class BigDecimal
  def mp_duplicable?
    true
  end
end

class Method
  ##
  # Methods are not duplicable:
  #
  #  method(:puts).mp_duplicable? # => false
  #  method(:puts).dup            # => TypeError: allocator undefined for Method
  def mp_duplicable?
    false
  end
end
