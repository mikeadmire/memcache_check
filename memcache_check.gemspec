# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'memcache_check/version'

Gem::Specification.new do |spec|
  spec.name          = "memcache_check"
  spec.version       = MemcacheCheck::VERSION
  spec.authors       = ["Mike Admire"]
  spec.email         = ["mike@mikeadmire.com"]
  spec.description   = %q{Ruby gem to test the speed of a Memcached server and verify that it's working correctly.}
  spec.summary       = %q{MemcacheCheck runs a series of set and get commands against a Memcache host to validate data integrity, verify that the host is responding correctly, and benchmark host speed.}
  spec.homepage      = "https://github.com/mikeadmire/memcache_check"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "ZenTest", "~> 4.9.2"

  spec.add_runtime_dependency "dalli"
  spec.add_runtime_dependency "faker"
end
