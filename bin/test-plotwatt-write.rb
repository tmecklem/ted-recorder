#!/usr/bin/env ruby

require 'serialport'
require 'ted/recorder'
require 'influxdb'
require 'rest_client'

username = 'ted'
password = '1001'
database = 'energy'
api_key = ARGV[1]
meter_id = ARGV[2]

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

    kw_power = message.power / 1000.0
    plotwatt_message = "#{meter_id},#{kw_power},#{Time.new.to_i}"
    RestClient.post "http://#{api_key}:@plotwatt.com/api/v2/push_readings", plotwatt_message
  end

end