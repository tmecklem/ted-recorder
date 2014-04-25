require 'spec_helper'
require 'ted/recorder'

describe Ted::Recorder::Ted1000Message do
  
  let(:raw_data) { [0xAA,0x4F,0x56,0x4B,0x6A,0x05,0x64,0xAD,0x95,0x05,0x47].pack('C*') }
  let!(:ted_message) { Ted::Recorder::Ted1000Message.new(raw_data) }

  describe "#initialize" do
    it "accepts a string of raw data and deconstructs it" do
      expect(ted_message.verify?).to be true
    end
  end

  describe '#voltage' do
    it "calculates the voltage correctly" do
      expect(ted_message.voltage).to be 121.777
    end
  end

  describe '#power' do
    it "calculates the power correctly" do
      expect(ted_message.power).to be 5718.8235
    end
  end

end
