#!/usr/bin/env ruby

require 'serialport'
require 'ted/recorder'
require 'influxdb'

username = 'ted'
password = '1001'
database = 'energy'

sp = SerialPort.new ARGV[0], 1200
influxdb = InfluxDB::Client.new database, :username => username, :password => password

while true do
  begin
    byte = sp.read(1)
  end until ["aa"] == byte.unpack('H*')

  bytes = "#{byte}#{sp.read(10)}"

  message = Ted::Recorder::Ted1000Message.new(bytes)
  if message.verify?
    influxdb.write_point("power", {:value => message.power})
    influxdb.write_point("voltage", {:value => message.voltage})
    puts "Wrote power:#{message.power} and voltage:#{message.voltage} to influxdb"
  end

end