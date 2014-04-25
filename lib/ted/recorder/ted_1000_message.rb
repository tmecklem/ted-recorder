require "ted/recorder/ted_message"
require 'bitwise'

module Ted
  module Recorder
    class Ted1000Message < TedMessage
      # Intercept the initialization to bitwise flip the packet
      def initialize(value=nil)
        msg = Bitwise.string_not value unless value.nil?
        super(msg)
      end

      # Verify that the lead-in value is correct for the TED1000
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
