require 'spec_helper'
require 'ted/recorder'

describe Ted::Recorder::MessageDecoder do
  
  let(:fixture_file) { File.new(File.expand_path(File.dirname(__FILE__)) + "/fixtures/message01.bin", "r") }
  let!(:message_decoder) { Ted::Recorder::MessageDecoder.new(fixture_file) }

  describe "#initialize" do
    it "accepts an io object and sets it as the file" do
      expect(message_decoder.file).to be fixture_file
    end
  end

  describe "#start" do
    it "should yield with the message object" do
      expected_message = Ted::Recorder::Ted1000Message.new
      expected_message.lead_in = 0x55
      expected_message.mtu_address = 176
      expected_message.packet_counter = 229
      expected_message.raw_power = 0x18f3fe
      expected_message.raw_voltage= 0x61056b
      expected_message.unknown = 251
      expected_message.checksum = 60

      expect { |b| message_decoder.start(&b) }.to yield_with_args expected_message
    end
  end

end
