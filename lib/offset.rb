class Offset
  def initialize(date_str)
    @date_str = date_str
  end

  def date_as_integer
    @date_str.to_i
  end
end
