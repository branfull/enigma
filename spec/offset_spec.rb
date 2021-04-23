require './lib/offset'

RSpec.describe Offset do
  describe '#initialize' do
    offset = Offset.new('040895')
    it 'exists' do
      expect(offset).to be_an_instance_of(Offset)
    end
  end
end
