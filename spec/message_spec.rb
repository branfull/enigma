require_relative 'spec_helper'
require './lib/message'

RSpec.describe Message do
  message = Message.new
  describe '#initialize' do
    it 'exists' do
      expect(message).to be_an_instance_of(Message)
    end
  end
  describe '#characters' do
    it 'returns a list of all lower case letters and space' do
      expect(message.characters[26]).to eq(' ')
      expect(message.characters[0]).to eq('a')
    end
  end
  describe '#letter_included?' do
    it 'returns false if a character is not in the character array' do
      expect(message.letter_included?('.')).to eq(false)
      expect(message.letter_included?('b')).to eq(true)
    end
  end
  describe '#rotated_character' do
    it 'returns a charachter that has been rotated by a given number' do
      expect(message.rotated_character(4)).to eq('e')
    end
  end
  describe '#character_count' do
    it 'determines the number of letters and spaces in a message' do
      expect(message.character_count('hello, world!')).to eq(11)
    end
  end
  describe '#last_four_of_message' do
    it 'returns the last four characters of a message' do
      expected = [' ','e', 'n', 'd']
      expect(message.last_four_of_message('hello world end')).to eq(expected)
    end
  end
  describe '#index_of_last_four' do
    it 'returns the index of the character array for each of the last 4' do
      expect(message.index_of_last_four(' end')).to eq([26, 4, 13, 3])
    end
  end
  describe '#variation_from_original_message' do
    it 'returns the variation between indexes of original and encrypted' do
      expected = [13, 23, 14, 14]
      expect(message.variation_from_original_message('maar')).to eq(expected)
    end
  end
  describe '#ordered_variation' do
    it 'returns an array of the variation in abcd order' do
      expected = [23, 14, 14, 13]
      expect(message.ordered_variation('dszyknjanzrmaar')).to eq(expected)
    end
  end
end
