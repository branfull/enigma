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
  describe 'four_cipher_keys' do
    it 'creates an array of the cipher_keys' do
      expected = [2, 27, 71, 15]
      expect(enigma.four_cipher_keys('02715')).to eq(expected)
    end
  end
  describe '#last_four' do
    it 'returns the last four digits of the squared date as a string' do
      expect(enigma.last_four('040895')).to eq([1, 0, 2, 5])
    end
  end
  describe '#encrypt' do
    it 'returns a hash with encryption, key, and date' do
      actual = enigma.encrypt('hello world', '02715', '040895')
      actual2 = enigma.encrypt('Hello world!', '02715', '040895')
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
      expect(actual).to eq(expected)
      expect(actual2).to eq(expected2)
    end
  end
  describe '#decrypt' do
    it 'returns a hash with encryption, key, and date' do
      actual = enigma.decrypt('keder ohulw', '02715', '040895')
      actual2 = enigma.decrypt('Keder ohulw!', '02715', '040895')
      actual3 = enigma.decrypt('buzyipjalarmzcr', '43912', '042521')
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
        date: '042521'
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
end
