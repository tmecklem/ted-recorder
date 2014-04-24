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

      def initialize(value=nil)
        # Sum the individual bytes while it's real easy to get to them
        self.sum = (value.bytes[0..8] << value.bytes[10]).reduce(0, :+)
        super
      end

      def verify?
        return true if sum % 256 == 0
        Ted::Recorder.logger("Checksum didn't check out. Got #{sum % 256}, should be 0")
        return false
      end
    end

    class Ted1000Message < TedMessage
      def initialize(value=nil)
        msg = Bitwise.string_not value
        super(msg)
      end

      def verify?
        retval = false
        unless self.lead_in == 0x55
          Ted::Recorder.logger "Lead in value is not correct! Got #{self.lead_in} expected 0x55."
          # Don't return here, so we can get all of the errors
        end

        retval = super
        return retval
      end
    end
  end
end
