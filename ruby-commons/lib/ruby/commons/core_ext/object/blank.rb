class Object
  ##
  # An object is blank if it's false, empty, or a whitespace string.
  # For example, '', '   ', +nil+, [], and {} are all blank.
  #
  # This simplifies
  #
  #   address.nil? || address.empty?
  #
  # to
  #
  #   address.mp_blank?
  #
  # @return [true, false]
  def mp_blank?
    respond_to?(:empty?) ? !!empty? : !self
  end

  ##
  # An object is present if it's not blank.
  #
  # @return [true, false]
  def mp_present?
    !mp_blank?
  end

  ##
  # Returns the receiver if it's present otherwise returns +nil+.
  # <tt>object.mp_presence</tt> is equivalent to
  #
  #    object.mp_present? ? object : nil
  #
  # For example, something like
  #
  #   state   = params[:state]   if params[:state].mp_present?
  #   country = params[:country] if params[:country].mp_present?
  #   region  = state || country || 'US'
  #
  # becomes
  #
  #   region = params[:state].mp_presence || params[:country].mp_presence || 'US'
  #
  # @return [Object]
  def mp_presence
    self if mp_present?
  end
end

class NilClass
  ##
  # +nil+ is blank:
  #
  #   nil.mp_blank? # => true
  #
  # @return [true]
  def mp_blank?
    true
  end
end

class FalseClass
  ##
  # +false+ is blank:
  #
  #   false.mp_blank? # => true
  #
  # @return [true]
  def mp_blank?
    true
  end
end

class TrueClass
  ##
  # +true+ is not blank:
  #
  #   true.mp_blank? # => false
  #
  # @return [false]
  def mp_blank?
    false
  end
end

class Array
  ##
  # An array is blank if it's empty:
  #
  #   [].mp_blank?      # => true
  #   [1,2,3].mp_blank? # => false
  #
  # @return [true, false]
  alias_method :mp_blank?, :empty?
end

class Hash
  ##
  # A hash is blank if it's empty:
  #
  #   {}.mp_blank?                # => true
  #   { key: 'value' }.mp_blank?  # => false
  #
  # @return [true, false]
  alias_method :mp_blank?, :empty?
end

class String
  MP_BLANK_RE = /\A[[:space:]]*\z/

  ##
  # A string is blank if it's empty or contains whitespaces only:
  #
  #   ''.mp_blank?       # => true
  #   '   '.mp_blank?    # => true
  #   "\t\n\r".mp_blank? # => true
  #   ' blah '.mp_blank? # => false
  #
  # Unicode whitespace is supported:
  #
  #   "\u00a0".mp_blank? # => true
  #
  # @return [true, false]
  def mp_blank?
    MP_BLANK_RE === self
  end
end

class Numeric #:nodoc:
  ##
  # No number is blank:
  #
  #   1.mp_blank? # => false
  #   0.mp_blank? # => false
  #
  # @return [false]
  def mp_blank?
    false
  end
end
