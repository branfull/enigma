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

  def date_squared_as_string
    date_squared.to_s
  end

  def last_four
    date_squared_as_string.slice(-4..-1)
  end

  def create_hash_keys(prefix)
    a_to_d = ('a'..'d').to_a
    a_to_d.map do |letter|
      "#{prefix}_#{letter}"
    end
  end
end
