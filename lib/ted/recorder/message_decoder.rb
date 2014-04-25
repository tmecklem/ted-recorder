module Ted
  module Recorder
    class MessageDecoder

      attr_accessor :file

      def initialize file
        @file = file
      end

      def start &block
        while !@file.eof do
          begin
            byte = @file.readbyte
          end until !byte.nil? && 0xaa == byte

          bytes = [byte]
          10.times do bytes << @file.readbyte end

          message = Ted::Recorder::Ted1000Message.new(bytes.pack('C*'))

          yield message

        end
      end

    end
  end
end