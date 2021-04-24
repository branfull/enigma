class CipherKey
  def initialize(five_digits)
    @five_digits = five_digits
  end

  def four_cipher_keys
    a, b, c, d = @five_digits.slice(0..1),
    @five_digits.slice(1..2),
    @five_digits.slice(2..3),
    @five_digits.slice(3..4)
    [a.to_i, b.to_i, c.to_i, d.to_i]
  end

  def create_hash_keys(prefix)
    a_to_d = ('a'..'d').to_a
    a_to_d.map do |letter|
      "#{prefix}_#{letter}"
    end
  end

  def cipher_keys
    array = create_hash_keys('key').zip(four_cipher_keys)
    array.each_with_object({}) do |(key, value), hash|
      hash[key] = value
    end
  end
end
