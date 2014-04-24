#!/usr/bin/env ruby
require 'ted/recorder'
require 'awesome_print'

# Open the data stream
open("../test-data.bin", "r") { |f|

  while record = f.read(11)
    msg = Ted::Recorder::Ted1000Message.new(record)
    #puts msg.inspect
    if msg.verify?
      #printf "Checksum good\n"
      printf "%.2fKW\n", msg.power/1000
      printf "%.2fKV\n", msg.voltage/1000
    else
      puts "FAILED CHECKSUM"
    end

    puts "------"
  end
}
