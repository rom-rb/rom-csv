# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rom/csv/version'

Gem::Specification.new do |spec|
  spec.name          = 'rom-csv'
  spec.version       = ROM::CSV::VERSION.dup
  spec.authors       = ['Don Morrison']
  spec.email         = ['don@elskwid.net']
  spec.summary       = 'CSV support for Ruby Object Mapper'
  spec.description   = spec.summary
  spec.homepage      = 'http://rom-rb.org'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rom', '~> 5.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop', '~> 0.28.0'
end
