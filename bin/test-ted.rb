#!/usr/bin/env ruby

require 'serialport'
require 'ted/recorder'

sp = SerialPort.new ARGV[0], 1200


while true do
  begin
    byte = sp.readbyte
  end until !byte.nil? && 0xaa == byte

  bytes = [byte]
  10.times do
    bytes << sp.readbyte
  end

  message = Ted::Recorder::Ted1000Message.new(bytes.pack('C*'))
  puts message.inspect if message.verify?

  #while true do print "%02x" % ~(sp.readbyte) end
end