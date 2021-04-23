require './lib/key'

RSpec.describe CipherKey do
  describe '#initialize' do
    cipher_key = CipherKey.new('02715')
    it 'exists' do
      expect(cipher_key).to be_an_instance_of(CipherKey)
    end
  end
end
