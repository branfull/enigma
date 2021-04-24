require './lib/enigma'

RSpec.describe Enigma do
  enigma = Enigma.new
  describe '#initialize' do
    it 'exists' do
      expect(enigma).to be_an_instance_of(Enigma)
    end
  end
end
