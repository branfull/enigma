class Offset
  def initialize(date_str)
    @date_str = date_str
  end

  def date_as_integer
    @date_str.to_i
  end

  def date_squared
    date_as_integer**2
  end
end
