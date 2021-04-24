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
      expected = {
        encryption: 'hello world',
        key: '02715',
        date: '040895'
      }
      expected2 = {
        encryption: 'hello world!',
        key: '02715',
        date: '040895'
      }
      expect(actual).to eq(expected)
      expect(actual2).to eq(expected2)
    end
  end
end
