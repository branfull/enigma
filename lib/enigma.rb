require 'date'
require 'pry'

class Enigma
  def initialize
  end

  def characters
    ('a'..'z').to_a.push(' ')
  end

  def rotated_character(rotate_by)
    rotate_all_characters = characters.rotate(rotate_by)
    rotate_all_characters[0]
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

  def today_ddmmyy
    today = Date.today
    date_components = today.to_s.split('-')
    date_components.map do |element|
      element[-2..-1]
    end.reverse.join
  end

  def random_key
    numbers = ('0'..'9').to_a
    key = ''
    5.times do
      key += numbers.sample
    end
    key
  end

  def manipulate(operator, message, key, date)
    modify_by = offset_and_key(key, date)
    individual_chars = message.downcase.split('')
    message_index = 0
    individual_chars.map do |letter|
      if !characters.include?(letter)
        message_index += 1
        letter
      else
        character_index =characters.index(individual_chars[message_index])
        cipher_key_offset_sum = modify_by[message_index % 4]
        rotate_number = character_index.send(operator, cipher_key_offset_sum)
        message_index += 1
        rotated_character(rotate_number)
      end
    end.join('')
  end

  def encrypt(message, key = random_key, date = today_ddmmyy)
    manipulated_message = manipulate(:+, message, key, date)
    { encryption: manipulated_message, date: date, key: key }
  end

  def decrypt(message, key, date = today_ddmmyy)
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

  def character_count(message)
    message.split('').count do |letter|
      characters.include?(letter)
    end
  end

  def crack(message, date = today_ddmmyy)
    message_length_mod = character_count(message) % 4
    message_end = message.slice(-4..-1).split('')
    last_chars = [26, 4, 13, 3]
    message_end_index = message_end.map do |letter|
      characters.index(letter)
    end
    match_end = message_end_index.zip(last_chars)
    jumps = match_end.flat_map do |(cipher_text, end_text)|
      (cipher_text + 27 - end_text) % 27
    end
    wip_keys = jumps.rotate(-message_length_mod)
    start_point = wip_keys.zip(offset_from_date(date))
    bad_var_name = start_point.flat_map do |(first, last)|
      first - last
    end
    four_by_four = []
    bad_var_name.each do |starter|
      array = [to_double_digit(starter.to_s)]
      sum = starter
      while sum + 27 < 99
        sum += 27
        array.push(to_double_digit(sum.to_s))
      end
      four_by_four.push(array)
    end
    first = four_by_four[0]
    second = four_by_four[1]
    third = four_by_four[2]
    fourth = four_by_four[3]
    index_of_a = 0
    a = first[index_of_a]
    b = second[0]
    c = third[0]
    d = fourth[0]
    until (a[1] == b[0] && b[1] == c[0] && c[1] == d[0]) || index_of_a > 4
      b = second.find do |second_element|
        second_element[0] == a[1]
      end
      if b.nil?
        index_of_a += 1
        a = first[index_of_a]
      else
        c = third.find do |third_element|
          third_element[0] == b[1]
        end
        if c.nil?
          index_of_a += 1
          a = first[index_of_a]
        else
          d = fourth.find do |fourth_element|
            fourth_element[0] == c[1]
          end
          if d.nil?
            index_of_a += 1
            a = first[index_of_a]
          end
        end
      end
    end
    encryption_key = "#{a}#{b[1]}#{c[1]}#{d[1]}"
    super_hash = decrypt(message, encryption_key, date)
  end
end
