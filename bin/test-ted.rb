#!/usr/bin/env ruby

require 'serialport'
require 'ted/recorder'

sp = SerialPort.new "/dev/tty.usbserial-A4003wYd", 1200


while true do
  begin
    byte = 0xFF ^ sp.readbyte
  end until !byte.nil? && 0x55 == byte

  bytes = [byte]
  (1..10).each do
    bytes << (0xFF ^ sp.readbyte)
  end

  checksum = 0
  bytes.each_with_index do |byte, i|
    if i < 9 || i == 10 then 
      checksum = (checksum + byte) % 256 
    end
  end
  #puts "checksum (should be 0): #{checksum}"

  if checksum == 0 
    message = Ted::Recorder::TedMessage.new(bytes.pack('C*'))
    puts message.inspect
  end

  #while true do print "%02x" % ~(sp.readbyte) end
end