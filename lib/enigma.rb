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

  def decrypt(message, key = random_key, date)
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
end
