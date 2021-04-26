require './lib/enigma'

RSpec.describe Enigma do
  enigma = Enigma.new
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
  describe 'four_cipher_keys' do
    it 'creates an array of the cipher_keys' do
      expected = [2, 27, 71, 15]
      expect(enigma.four_cipher_keys('02715')).to eq(expected)
    end
  end
  describe '#offset_from_date' do
    it 'returns the last four digits of the squared date as a string' do
      expect(enigma.offset_from_date('040895')).to eq([1, 0, 2, 5])
    end
  end
  describe '#offset_and_key' do
    it 'adds the offset and keys together' do
      expect(enigma.offset_and_key('02715', '040895')).to eq([3, 27, 73, 20])
    end
  end
  describe '#today_ddmmyy' do
    it 'returns today\'s date in ddmmyy format' do
      allow(Date).to receive(:today).and_return(Date.new(2021, 04, 25))
      expect(enigma.today_ddmmyy).to eq('250421')
    end
  end
  describe '#random_key' do
    it 'creates a string of 5 random digits' do
      expect(enigma.random_key.length).to eq(5)
      expect(enigma.random_key).to be_an_instance_of(String)
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
      expect(actual).to eq(expected)
      expect(actual2).to eq(expected2)
      expect(actual3).to eq(expected3)
    end
  end
  describe '#decrypt' do
    it 'returns a hash with encryption, key, and date' do
      actual = enigma.decrypt('keder ohulw', '02715', '040895')
      actual2 = enigma.decrypt('Keder ohulw!', '02715', '040895')
      actual3 = enigma.decrypt('dszyknjanzrmaar', '43912', '250421')
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
      expect(actual).to eq(expected)
      expect(actual2).to eq(expected2)
      expect(actual3).to eq(expected3)
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
  describe '#crack' do
    it 'decrypts the message without being given a key' do
      actual = enigma.crack('dszyknjanzrmaar', '250421')
      expected = {
        decryption: 'hello world end',
        key: '43912',
        date: '250421'
      }
      expect(actual).to eq(expected)
    end
  end
end
