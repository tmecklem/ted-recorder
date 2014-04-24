require 'bit-struct'

module Ted
  module Recorder
    class TedMessage < BitStruct

      unsigned    :lead_in,     8,     "Lead-in byte"
      unsigned    :mtu_address,    8,     "MTU (sender) address"
      unsigned    :packet_counter,   8,     "Packet counter"
      unsigned    :power,  24,     "Power"
      unsigned    :voltage,   24,     "Voltage"
      unsigned    :unknown,  8,     "Random stuff"
      unsigned    :checksum,   8,     "Checksum (all bytes minus unknown summed and mod 256)"

    end

  end
end