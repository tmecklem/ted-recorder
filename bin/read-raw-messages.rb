#!/usr/bin/env ruby

require 'serialport'
require 'ted/recorder'

sp = SerialPort.new ARGV[0], 1200
file = File.open(ARGV[1], 'wb') do |f|

  ARGV[2].to_i.times do
    
    bytes = sp.read(11)
    f.write bytes

  end
end