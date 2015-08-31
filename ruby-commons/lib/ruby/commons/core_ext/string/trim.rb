class String
  ##
  # TODO:
  def mp_trim(character_set)
    mp_ltrim(character_set).mp_rtrim(character_set)
  end

  ##
  # TODO:
  def mp_ltrim(character_set)
    sub(/^[#{character_set}]+/, '')
  end

  ##
  # TODO:
  def mp_rtrim(character_set)
    sub(/[#{character_set}]+$/, '')
  end
end
