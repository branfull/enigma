require './lib/offset'

RSpec.describe Offset do
  offset = Offset.new('040895')
  describe '#initialize' do
    it 'exists' do
      expect(offset).to be_an_instance_of(Offset)
    end
  end
  describe '#date_as_integer' do
    it 'converts the date from a string to an integer' do
      expect(offset.date_as_integer).to eq(40_895)
    end
  end
  describe '#date_squared' do
    it 'squares the date' do
      expect(offset.date_squared).to eq(1_672_401_025)
    end
  end
  describe '#date_squared_as_string' do
    it 'returns the date squared as a string' do
      expect(offset.date_squared_as_string).to eq("1672401025")
    end
  end
  describe '#last_four' do
    it 'returns the last four digits of the squared date as a string' do
      expect(offset.last_four).to eq([1, 0, 2, 5])
    end
  end
  describe '#create_hash_keys' do
    it 'creates an array of keys to be used for a hash' do
      expected = ['offset_a', 'offset_b', 'offset_c', 'offset_d']
      expect(offset.create_hash_keys('offset')).to eq(expected)
    end
  end
  describe '#offsets' do
    it 'creates a hash of offsets' do
      expected = {
        'offset_a' => 1,
        'offset_b' => 0,
        'offset_c' => 2,
        'offset_d' => 5
      }
      expect(offset.offsets).to eq(expected)
    end
  end
end
