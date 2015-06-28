# encoding: utf-8
version = File.read(File.expand_path("../../RUBY_COMMONS_VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.platform      = Gem::Platform::RUBY
  s.name          = "ruby-commons"
  s.version       = version
  # TODO: description!
  s.summary       = "Ruby::Commons"
  s.description   = "Ruby::Commons"

  s.required_ruby_version     = ">= 2.2.2"
  s.required_rubygems_version = ">= 1.9.0"

  s.license       = "BSD-3"

  s.author        = "Alexander Bragin"
  s.email         = "alexander.bragin@gmail.com"
  s.homepage      = "http://www.mediarium.com"

  s.files         = Dir["{config,lib}/**/*", "LICENSE.txt", "README.rdoc"]
  s.require_paths = ["lib"]

  s.rdoc_options << "--exclude" << "."
end
