# Require all Errors at once
Dir[File.join(File.dirname(__FILE__), 'error', '*.rb')].each { |path| require path }
