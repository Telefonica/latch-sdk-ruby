# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require File.join(lib, 'Latch')

Gem::Specification.new do |gem|
  gem.name          = "latch-sdk"
  gem.version       = Latch::API_VERSION
  gem.authors       = ["ElevenPaths"]
  gem.email         = ["support@11paths.com"]
  gem.description   = "With this gem you can access the Latch API" 
  gem.summary       = "SDK for the to consume the Latch API" 
  gem.homepage      = "https://latch.elevenpaths.com"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.homepage    = 'https://www.elevenpaths.com'
  gem.add_runtime_dependency 'json_pure', '~> 1.8.2'
end
