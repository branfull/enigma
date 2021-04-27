require_relative 'spec_helper'
require './lib/enigma'
require './lib/conversion'
require 'pry'

RSpec.describe Enigma do
  enigma = Enigma.new
  conversion = Conversion.new
  describe '#initialize' do
    it 'exists' do
      expect(enigma).to be_an_instance_of(Enigma)
    end
  end
  describe '#characters' do
    it 'returns a list of all lower case letters and space' do
      expect(enigma.characters[26]).to eq(' ')
      expect(enigma.characters[0]).to eq('a')
    end
  end
  describe '#rotated_character' do
    it 'returns a charachter that has been rotated by a given number' do
      expect(enigma.rotated_character(4)).to eq('e')
    end
  end
  describe '#manipulate' do
    it 'encrypts or decrypts a message based on the operator argument' do
      actual = enigma.manipulate(:+, 'hello world', '02715', '040895')
      expected = 'keder ohulw'
      expect(actual).to eq(expected)
      actual2 = enigma.manipulate(:-, 'keder ohulw', '02715', '040895')
      expected2 = 'hello world'
      expect(actual2).to eq(expected2)
    end
  end
  describe '#encrypt' do
    it 'returns a hash with encryption, key, and date' do
      actual = enigma.encrypt('hello world', '02715', '040895')
      actual2 = enigma.encrypt('Hello world!', '02715', '040895')
      actual3 = enigma.encrypt('Hello world end', '43912', '250421')
      allow(Date).to receive(:today).and_return(Date.new(2021, 02, 25))
      actual4 = enigma.encrypt('Hello world end', '43912')
      allow(Conversion).to receive(:random_key).and_return('28432')
      actual5 = enigma.encrypt('Hello world end')
      expected = {
        encryption: 'keder ohulw',
        key: '02715',
        date: '040895'
      }
      expected2 = {
        encryption: 'keder ohulw!',
        key: '02715',
        date: '040895'
      }
      expected3 = {
        encryption: 'dszyknjanzrmaar',
        key: '43912',
        date: '250421'
      }
      expected4 = {
        encryption: 'eyzyltjaoermbgr',
        key: '43912',
        date: '250221'
      }
      expected5 = {
        encryption: 'qperxkpu wxfnyx',
        key: '28432',
        date: '250221'
      }
      expect(actual).to eq(expected)
      expect(actual2).to eq(expected2)
      expect(actual3).to eq(expected3)
      expect(actual4).to eq(expected4)
      expect(actual5).to eq(expected5)
    end
  end
  describe '#decrypt' do
    it 'returns a hash with encryption, key, and date' do
      actual = enigma.decrypt('keder ohulw', '02715', '040895')
      actual2 = enigma.decrypt('Keder ohulw!', '02715', '040895')
      actual3 = enigma.decrypt('dszyknjanzrmaar', '43912', '250421')
      allow(Date).to receive(:today).and_return(Date.new(2021, 02, 25))
      actual4 = enigma.decrypt('eyzyltjaoermbgr', '43912')
      expected = {
        decryption: 'hello world',
        key: '02715',
        date: '040895'
      }
      expected2 = {
        decryption: 'hello world!',
        key: '02715',
        date: '040895'
      }
      expected3 = {
        decryption: 'hello world end',
        key: '43912',
        date: '250421'
      }
      expected4 = {
        decryption: 'hello world end',
        key: '43912',
        date: '250221'
      }
      expect(actual).to eq(expected)
      expect(actual2).to eq(expected2)
      expect(actual3).to eq(expected3)
      expect(actual4).to eq(expected4)
    end
  end
  describe '#to_double_digit' do
    it 'ensures a string is a double digit number' do
      expect(enigma.to_double_digit('4')).to eq('04')
    end
  end
  describe '#character_count' do
    it 'determines the number of letters and spaces in a message' do
      expect(enigma.character_count('hello, world!')).to eq(11)
    end
  end
  describe '#last_four_of_message' do
    it 'returns the last four characters of a message' do
      expected = [' ','e', 'n', 'd']
      expect(enigma.last_four_of_message('hello world end')).to eq(expected)
    end
  end
  describe '#index_of_last_four' do
    it 'returns the index of the character array for each of the last 4' do
      expect(enigma.index_of_last_four(' end')).to eq([26, 4, 13, 3])
    end
  end
  describe '#variation_from_original_message' do
    it 'returns the variation between indexes of original and encrypted' do
      expected = [13, 23, 14, 14]
      expect(enigma.variation_from_original_message('maar')).to eq(expected)
    end
  end
  describe '#ordered_variation' do
    it 'returns an array of the variation in abcd order' do
      expected = [23, 14, 14, 13]
      expect(enigma.ordered_variation('dszyknjanzrmaar')).to eq(expected)
    end
  end
  describe '#variation_less_offset' do
    it 'returns an array of the variation in abcd order' do
      actual = enigma.variation_less_offset('dszyknjanzrmaar', '250421')
      expected = [16, 12, 10, 12]
      expect(actual).to eq(expected)
    end
  end
  describe '#cipher_hash' do
    it 'returns an array of arrays of all possible cipher keys' do
      actual = enigma.cipher_hash('dszyknjanzrmaar', '250421')
      expected = {
        first: ["16", "43", "70", "97"],
        second: ["12", "39", "66", "93"],
        third: ["10", "37", "64", "91"],
        fourth: ["12", "39", "66", "93"]
      }
      expect(actual).to eq(expected)
    end
  end
  describe '#crack' do
    it 'decrypts the message without being given a key' do
      actual = enigma.crack('dszyknjanzrmaar', '250421')
      allow(Date).to receive(:today).and_return(Date.new(2021, 04, 27))
      actual2 = enigma.crack('rsdxyno azwloaw')
      expected = {
        decryption: 'hello world end',
        key: '43912',
        date: '250421'
      }
      expected2 = {
        decryption: 'hello world end',
        key: '03965',
        date: '270421'
      }
      expect(actual).to eq(expected)
      expect(actual2).to eq(expected2)
    end
  end
end
