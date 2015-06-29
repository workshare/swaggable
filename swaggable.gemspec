# coding: utf-8
gem_name = "swaggable"

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "#{gem_name}/version"

Gem::Specification.new do |spec|
  spec.name          = gem_name
  spec.version       = Swaggable::VERSION
  spec.authors       = ["Manuel Morales"]
  spec.email         = ['manuelmorales@gmail.com']
  spec.description   = "Flexible Swagger documentation for Rack and Grape"
  spec.summary       = "Allows you to generate Swagger documentation from Grape endpoints and expose it as a Rack app."
  spec.homepage      = "https://github.com/workshare/#{spec.name.gsub('_','-')}"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "forwarding_dsl", '~> 1.0'
  spec.add_runtime_dependency "json-schema", '~> 2.5'

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", '~> 10.4'
end
