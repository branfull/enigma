require './lib/cipher_key'

RSpec.describe CipherKey do
  cipher_key = CipherKey.new('02715')
  describe '#initialize' do
    it 'exists' do
      expect(cipher_key).to be_an_instance_of(CipherKey)
    end
  end
  describe 'four_cipher_keys' do
    it 'creates an array of the cipher_keys' do
      expected = [2, 27, 71, 15]
      expect(cipher_key.four_cipher_keys).to eq(expected)
    end
  end
  describe '#create_hash_keys' do
    it 'creates an array of keys to be used for a hash' do
      expected = ['key_a', 'key_b', 'key_c', 'key_d']
      expect(cipher_key.create_hash_keys('key')).to eq(expected)
    end
  end
  describe '#cipher_keys' do
    it 'creates a hash of keys' do
      expected = {
        'key_a' => 2,
        'key_b' => 27,
        'key_c' => 71,
        'key_d' => 15
      }
      expect(cipher_key.cipher_keys).to eq(expected)
    end
  end
end
