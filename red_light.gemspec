# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'red_light/version'

Gem::Specification.new do |spec|
  spec.name          = "red_light"
  spec.version       = RedLight::VERSION
  spec.authors       = ["Hao Liu"]
  spec.email         = ["leomayleomay@gmail.com"]
  spec.description   = %q{a gem used to add fancy login to your rails application}
  spec.summary       = %q{fancy login it is}
  spec.homepage      = "https://github.com/leomayleomay/red_light"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
