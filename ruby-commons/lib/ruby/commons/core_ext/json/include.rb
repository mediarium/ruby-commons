# How to include a YAML file inside a YAML file?
# @link http://stackoverflow.com/a/2286760

module JSON
  ##
  # TODO:
  def self.include(file_name)
    require 'erb'
    ERB.new(IO.read(file_name)).result
  end

  ##
  # TODO:
  def self.load_erb(file_name)
    JSON::load(JSON::include(file_name))
  end
end
