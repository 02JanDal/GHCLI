lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ghcli/version'

Gem::Specification.new do |spec|
  spec.name          = "ghcli"
  spec.version       = Ghcli::VERSION
  spec.authors       = ['Jan Dalheimer']
  spec.email         = ['jan@dalheimer.de']
  spec.description   = ''
  spec.summary       = ''
  spec.homepage      = 'https://github.com/02JanDal/ghcli'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'pry'
  spec.add_dependency 'ansi'
  spec.add_dependency 'colorize'
  spec.add_dependency 'octokit'
  spec.add_dependency 'faraday-http-cache'
  spec.add_dependency 'configliere'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'launchy'
end
