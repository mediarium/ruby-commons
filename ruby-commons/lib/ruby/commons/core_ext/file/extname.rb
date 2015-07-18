class File

  ##
  # TODO:
  def self.mp_extension(path)
    extension = File.extname(path || '')
    extension[1..-1] if extension.mp_present?
  end

end
