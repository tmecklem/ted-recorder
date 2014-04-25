require 'bit-struct'
require 'bitwise'

module Ted
  module Recorder
    class TedMessage < BitStruct
      attr_accessor :sum

      unsigned    :lead_in,          8,     "Lead-in byte"
      unsigned    :mtu_address,      8,     "MTU (sender) address"
      unsigned    :packet_counter,   8,     "Packet counter"
      char        :raw_power,       24,     "Uncalculated Power bytes"
      char        :raw_voltage,     24,     "Uncalculated Voltage bytes"
      unsigned    :unknown,          8,     "Random stuff"
      unsigned    :checksum,         8,     "Checksum"

      # Intercept the initialization to sum the individual bytes while they are
      # easy to get access
      def initialize(value=nil)
        self.sum = (value.bytes[0..8] << value.bytes[10]).reduce(0, :+) unless value.nil?
        super
      end

      # Verify that the packet checksum is valid
      def verify?
        return true if sum % 256 == 0
        Ted::Recorder.logger("Checksum didn't check out. Got #{sum % 256}, should be 0")
        return false
      end

      # Calculations from http://gangliontwitch.com/ted/
      # TODO: Document the maths

      def power
        bytes = self.raw_power.bytes
        pwr  = bytes[2].to_i << 16
        pwr += bytes[1].to_i << 8
        pwr += bytes[0].to_i

        pwr = 1.19 + 0.84 * ( ( pwr - 288.0 ) / 204.0 )
      end

      def voltage
        bytes = self.raw_voltage.bytes
        volt  = bytes[2].to_i << 16
        volt += bytes[1].to_i << 8
        volt += bytes[0].to_i

        volt = 123.6 + ( volt - 27620 ) / 85 * 0.4;
      end
    end
  end
end
