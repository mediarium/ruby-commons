module URI

  # TODO:
  def self.mp_try_parse(uri)
    begin
      return URI(uri)
    rescue
      return nil
    end
  end

end
