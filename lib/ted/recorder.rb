require "ted/recorder/version"
require "ted/recorder/ted_message"
require "ted/recorder/ted_1000_message"

module Ted
  module Recorder
    def self.logger(msg=nil)
      puts msg
    end
  end
end
