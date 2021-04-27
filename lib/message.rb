class Message
  def initialize
  end

  def characters
    ('a'..'z').to_a.push(' ')
  end

  def letter_included?(letter)
    characters.include?(letter)
  end

  def rotated_character(rotate_by)
    rotate_all_characters = characters.rotate(rotate_by)
    rotate_all_characters[0]
  end

  def character_count(message)
    message.split('').count do |letter|
      characters.include?(letter)
    end
  end

  def last_four_of_message(message)
    message.slice(-4..-1).split('')
  end

  def index_of_last_four(message)
    last_four_of_message(message).map do |letter|
      characters.index(letter)
    end
  end

  def variation_from_original_message(message)
    combined_ends = index_of_last_four(message).zip(index_of_last_four(' end'))
    combined_ends.flat_map do |(cipher_text, end_text)|
      (cipher_text + 27 - end_text) % 27
    end
  end

  def ordered_variation(message)
    message_length_mod = character_count(message) % 4
    variation_from_original_message(message).rotate(-message_length_mod)
  end
end
