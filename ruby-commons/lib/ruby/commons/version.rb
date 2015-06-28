require "ruby/commons/gem_version"

module Ruby::Commons

  # Returns the version of the currently loaded Ruby::Commons as a string.
  def self.version
    VERSION::STRING
  end

end
