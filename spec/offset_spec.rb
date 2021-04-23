require './lib/offset'

RSpec.describe Offset do
  describe '#initialize' do
    offset = Offset.new('040895')
    it 'exists' do
      expect(offset).to be_an_instance_of(Offset)
    end
  end
  describe '#date_as_integer' do
    it 'converts the date from a string to an integer' do
      expect(offset.date_as_integer).to eq(40895)
    end
  end
end
