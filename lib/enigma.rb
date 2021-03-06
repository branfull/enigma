require 'date'
require_relative 'conversion'

class Enigma
  def initialize
  end

  def manipulate(operator, message, key, date)
    conversion = Conversion.new
    text = Message.new
    modify_by = conversion.offset_and_key(key, date)
    individual_chars = message.downcase.split('')
    message_index = 0
    individual_chars.map do |letter|
      if !text.letter_included?(letter)
        message_index += 1
        letter
      else
        character_index = text.characters.index(individual_chars[message_index])
        cipher_key_offset_sum = modify_by[message_index % 4]
        rotate_number = character_index.send(operator, cipher_key_offset_sum)
        message_index += 1
        text.rotated_character(rotate_number)
      end
    end.join('')
  end

  def encrypt(message, key = Conversion.random_key, date = Conversion.today_ddmmyy)
    manipulated_message = manipulate(:+, message, key, date)
    { encryption: manipulated_message, date: date, key: key }
  end

  def decrypt(message, key, date = Conversion.today_ddmmyy)
    manipulated_message = manipulate(:-, message, key, date)
    { decryption: manipulated_message, date: date, key: key }
  end

  def to_double_digit(string)
    if string.length < 2
      string.prepend('0')
    else
      string
    end
  end

  def variation_less_offset(message, date)
    conversion = Conversion.new
    text = Message.new
    variation_offset = text.ordered_variation(message).zip(conversion.offset_from_date(date))
    variation_offset.flat_map do |(variation, offset)|
      variation - offset
    end
  end

  def cipher_hash(message, date)
    four_by_four = []
    possible_cipher_key_names = [:first, :second, :third, :fourth]
    variation_less_offset(message, date).each do |minimum_possible_key|
      all_possible_keys = [to_double_digit(minimum_possible_key.to_s)]
      next_possible_key = minimum_possible_key
      while next_possible_key + 27 < 99
        next_possible_key += 27
        all_possible_keys.push(to_double_digit(next_possible_key.to_s))
      end
      four_by_four.push(all_possible_keys)
    end
    possible_cipher_key_names.zip(four_by_four).to_h
  end

  def crack(message, date = Conversion.today_ddmmyy)
    index_of_first = 0
    first = cipher_hash(message, date)[:first][index_of_first]
    second = cipher_hash(message, date)[:second][0]
    third = cipher_hash(message, date)[:third][0]
    fourth = cipher_hash(message, date)[:fourth][0]
    until ((first[1] == second[0] &&
      second[1] == third[0] &&
      third[1] == fourth[0]) ||
      index_of_first > 4)
      second = cipher_hash(message, date)[:second].find do |second_element|
        second_element[0] ==first[1]
      end
      if second.nil?
        index_of_first += 1
        first = cipher_hash(message, date)[:first][index_of_first]
      else
        third = cipher_hash(message, date)[:third].find do |third_element|
          third_element[0] == second[1]
        end
        if third.nil?
          index_of_first += 1
          first = cipher_hash(message, date)[:first][index_of_first]
        else
          fourth = cipher_hash(message, date)[:fourth].find do |fourth_element|
            fourth_element[0] == third[1]
          end
          if fourth.nil?
            index_of_first += 1
            first = cipher_hash(message, date)[:first][index_of_first]
          end
        end
      end
    end
    encryption_key = "#{first}#{second[1]}#{third[1]}#{fourth[1]}"
    decrypt(message, encryption_key, date)
  end
end
