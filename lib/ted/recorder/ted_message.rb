require 'bit-struct'
require 'bitwise'

module Ted
  module Recorder
    class TedMessage < BitStruct
      attr_accessor :sum

      unsigned    :lead_in,          8,     "Lead-in byte", :endian => :big
      unsigned    :mtu_address,      8,     "MTU (sender) address"
      unsigned    :packet_counter,   8,     "Packet counter"
      unsigned    :power,           24,     "Power"
      unsigned    :voltage,         24,     "Voltage"
      unsigned    :unknown,          8,     "Random stuff"
      unsigned    :checksum,         8,     "Checksum (all bytes minus unknown summed and mod 256)"

      # Intercept the initialization to sum the individual bytes while they are
      # easy to get access
      def initialize(value=nil)
        self.sum = (value.bytes[0..8] << value.bytes[10]).reduce(0, :+)
        super
      end

      # Verify that the packet checksum is valid
      def verify?
        return true if sum % 256 == 0
        Ted::Recorder.logger("Checksum didn't check out. Got #{sum % 256}, should be 0")
        return false
      end
    end
  end
end
