require 'date'
require 'pry'

class Enigma
  def initialize
  end

  def characters
    ('a'..'z').to_a.push(' ')
  end

  def four_cipher_keys(key)
    a, b, c, d = key.slice(0..1),
    key.slice(1..2),
    key.slice(2..3),
    key.slice(3..4)
    [a.to_i, b.to_i, c.to_i, d.to_i]
  end

  def last_four(date)
    date_squared = date.to_i**2
    date_squared_as_string = date_squared.to_s
    string = date_squared_as_string.slice(-4..-1)
    array = string.split('')
    array.map do |number|
      number.to_i
    end
  end

  def offset_and_key(key, date)
    zipped = four_cipher_keys(key).zip(last_four(date))
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
    { decryption: encrypted_message, date: date, key: key }
  end

  def to_double_digit(string)
    if string.length < 2
      string.prepend('0')
    else
      string
    end
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
    until a[1] == b[0] && b[1] == c[0] && c[1] == d[0]
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
