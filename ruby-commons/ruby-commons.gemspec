# coding: utf-8
version = File.read(File.expand_path('../../RUBY_COMMONS_VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.platform      = Gem::Platform::RUBY
  s.name          = 'ruby-commons'
  s.version       = version
  s.summary       = 'A toolkit of support libraries and Ruby core extensions.'
  s.description   = 'A toolkit of support libraries and Ruby core extensions.'

  s.license       = 'BSD-4-Clause'

  s.author        = 'Alexander Bragin'
  s.email         = 'alexander.bragin@gmail.com'
  s.homepage      = 'http://www.mediarium.com'

  s.files         = Dir['{config,lib}/**/*.rb', 'LICENSE.txt', 'README.rdoc']
  s.require_paths = %w(config lib)

  s.rdoc_options << '--exclude' << '.'

  # Requirements
  s.required_ruby_version     = '>= 2.3.0'
  s.required_rubygems_version = '>= 2.4.0'

  # TODO: External dependencies
end
