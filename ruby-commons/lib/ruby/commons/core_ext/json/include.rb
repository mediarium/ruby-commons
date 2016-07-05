# How to include a YAML file inside a YAML file?
# @link http://stackoverflow.com/a/2286760

module JSON
  ##
  # TODO
  def self.mp_include(file_name)
    require 'erb'
    ERB.new(IO.read(file_name)).result
  end

  ##
  # TODO
  def self.mp_load_erb(file_name)
    JSON::load(JSON::mp_include(file_name))
  end
end
