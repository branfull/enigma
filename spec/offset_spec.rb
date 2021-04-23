require './lib/offset'

RSpec.describe Offset do
  describe '#initialize' do
    offset = Offset.new('040895')
    it 'exists' do
      expect(offset).to be_an_instance_of(Offset)
    end
  end
  describe '#date_as_integer' do
    offset = Offset.new('040895')
    it 'converts the date from a string to an integer' do
      expect(offset.date_as_integer).to eq(40_895)
    end
  end
  describe '#date_squared' do
    offset = Offset.new('040895')
    it 'squares the date' do
      expect(offset.date_squared).to eq(1_672_401_025)
    end
  end
  describe '#date_squared_as_string' do
    offset = Offset.new('040895')
    it 'returns the date squared as a string' do
      expect(offset.date_squared_as_string).to eq("1672401025")
    end
  end
end
