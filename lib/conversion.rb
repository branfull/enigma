class Conversion
  def initialize
  end

  def four_cipher_keys(cipher_key)
    first, second, third, fourth = cipher_key.slice(0..1),
    cipher_key.slice(1..2),
    cipher_key.slice(2..3),
    cipher_key.slice(3..4)
    [first.to_i, second.to_i, third.to_i, fourth.to_i]
  end

  def offset_from_date(date)
    date_squared = date.to_i**2
    date_squared_as_string = date_squared.to_s
    last_four_integer = date_squared_as_string.slice(-4..-1)
    last_four_digits = last_four_integer.split('')
    last_four_digits.map do |digit|
      digit.to_i
    end
  end

  def offset_and_key(key, date)
    key_offset_pairs = four_cipher_keys(key).zip(offset_from_date(date))
    key_offset_pairs.flat_map do |(zipped_key, zipped_offset)|
      zipped_key + zipped_offset
    end
  end

  def self.today_ddmmyy
    today = Date.today
    date_components = today.to_s.split('-')
    date_components.map do |element|
      element[-2..-1]
    end.reverse.join
  end

  def self.random_key
    numbers = ('0'..'9').to_a
    key = ''
    5.times do
      key += numbers.sample
    end
    key
  end
end
