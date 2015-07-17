# Load all Core Extensions (monkey patches) at once
Dir[File.join(File.dirname(__FILE__), 'core_ext', '*.rb')].each { |path| require path }
