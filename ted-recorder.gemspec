# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ted/recorder/version'

Gem::Specification.new do |spec|
  spec.name          = "ted-recorder"
  spec.version       = Ted::Recorder::VERSION
  spec.authors       = ["Timothy Mecklem"]
  spec.email         = ["timothy@mecklem.com"]
  spec.summary       = %q{A gem to help capture and record the data from a TED 1001.}
  spec.description   = %q{A gem to help capture and record the data from a TED 1001.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "serialport"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "rspec"

  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"

  spec.add_dependency "bit-struct"
  spec.add_dependency "bitwise"
  spec.add_dependency "influxdb"
end
