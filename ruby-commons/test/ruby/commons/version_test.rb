require 'test_helper'

module Ruby::Commons
  class VersionTest < Minitest::Test

    def test_version_returns_a_string
      assert Ruby::Commons.version.is_a? String
    end

    def test_gem_version_returns_a_correct_gem_version_object
      assert Ruby::Commons.gem_version.is_a? Gem::Version
      assert_equal Ruby::Commons.version, Ruby::Commons.gem_version.to_s
    end

  end
end
