#!/usr/bin/env ruby

require 'serialport'
require 'ted/recorder'

sp = SerialPort.new ARGV[0], 1200


while true do
  begin
    byte = sp.read(1)
  end until ["aa"] == byte.unpack('H*')

  bytes = "#{byte}#{sp.read(10)}"
  puts bytes.unpack('H*')

  message = Ted::Recorder::Ted1000Message.new(bytes)
  puts message.inspect if message.verify?

end