require_relative 'spec_helper'
require './lib/conversion'

RSpec.describe Conversion do
  conversion = Conversion.new
  describe '#initialize' do
    it 'exists' do
      expect(conversion).to be_an_instance_of(Conversion)
    end
  end
  describe 'four_cipher_keys' do
    it 'creates an array of the cipher_keys' do
      expected = [2, 27, 71, 15]
      expect(conversion.four_cipher_keys('02715')).to eq(expected)
    end
  end
  describe '#offset_from_date' do
    it 'returns the last four digits of the squared date as a string' do
      expect(conversion.offset_from_date('040895')).to eq([1, 0, 2, 5])
    end
  end
  describe '#offset_and_key' do
    it 'adds the offset and keys together' do
      expect(conversion.offset_and_key('02715', '040895')).to eq([3, 27, 73, 20])
    end
  end
  describe '#today_ddmmyy' do
    it 'returns today\'s date in ddmmyy format' do
      allow(Date).to receive(:today).and_return(Date.new(2021, 04, 25))
      expect(Conversion.today_ddmmyy).to eq('250421')
    end
  end
  describe '#random_key' do
    it 'creates a string of 5 random digits' do
      expect(Conversion.random_key.length).to eq(5)
      expect(Conversion.random_key).to be_an_instance_of(String)
    end
  end
end
