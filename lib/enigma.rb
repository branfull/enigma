require 'date'
require_relative 'offset'
require_relative 'cipher_key'
require 'pry'

class Enigma
  def initialize
  end

  def characters
    ('a'..'z').to_a.push(' ')
  end

  def offset_and_key(key, date)
    cipher_key = CipherKey.new(key)
    a_d_keys = cipher_key.four_cipher_keys
    offset = Offset.new(date)
    a_d_offsets = offset.last_four
    zipped = a_d_keys.zip(a_d_offsets)
    zipped.flat_map do |(zipped_key, zipped_offset)|
      zipped_key + zipped_offset
    end
  end

  def today_ddmmyy
    today = Date.today
    today.to_s.split('-').rotate(1).map do |element|
      element[-2..-1]
    end.join
  end

  def random_key
    numbers = ('0'..'9').to_a
    key = ''
    5.times do
      key += numbers.sample
    end
    key
  end

  def encrypt(message, key = random_key, date = today_ddmmyy)
    # generate a-d keys
    downcased_message = message.downcase
    modify = offset_and_key(key, date)
    individual_chars = downcased_message.split('')
    message_index = 0
    encrypted_message = individual_chars.map do |letter|
      if !characters.include?(letter)
        message_index += 1
        letter
      else
        rotate_number = characters.index(individual_chars[message_index]) + modify[message_index % 4]
        message_index += 1
        characters.rotate(rotate_number)[0]
      end
    end.join('')
    { encryption: encrypted_message, date: date, key: key }
    # binding.pry
  end

  def decrypt(message, key, date = today_ddmmyy)
    # generate a-d keys
    downcased_message = message.downcase
    modify = offset_and_key(key, date)
    individual_chars = downcased_message.split('')
    message_index = 0
    encrypted_message = individual_chars.map do |letter|
      if !characters.include?(letter)
        message_index += 1
        letter
      else
        rotate_number = characters.index(individual_chars[message_index]) - modify[message_index % 4]
        message_index += 1
        characters.rotate(rotate_number)[0]
      end
    end.join('')
    # binding.pry
    { encryption: encrypted_message, date: date, key: key }
  end

  def crack(message, date = today_ddmmyy)
    message_length_mod = message.length % 4
    message_end = message.slice(-4..-1).split('')
    last_chars = [26, 4, 13, 3]
    message_end_index = message_end.map do |letter|
      characters.index(letter)
    end
    match_end = message_end_index.zip(last_chars)
    jumps = match_end.flat_map do |(cipher_text, end_text)|
      (cipher_text + 27 - end_text) % 27
    end
    crack_offset = Offset.new(date)
    date_offset = crack_offset.last_four
    wip_keys = jumps.rotate(-message_length_mod)
    start_point = wip_keys.zip(date_offset)
    bad_var_name = start_point.flat_map do |(first, last)|
      first - last
    end
    four_by_four = []
    bad_var_name.each do |starter|
      array = [starter.to_s]
      sum = starter
      while sum + 27 < 99
        sum += 27
        array.push(sum.to_s)
      end
      four_by_four.push(array)
    end
    parts = four_by_four.map do |number_array|
      number_array.map do |sub_array|
        sub_array.split('')
      end
    end
    a = four_by_four[0][0]
    b = four_by_four[1][0]
    c = four_by_four[2][0]
    d = four_by_four[3][0]
    binding.pry
    # date_offset = crack_offset.last_four.rotate(message_length_mod)
    # ' ' > 26, e > 4, n > 13, d > 3
  end
end
