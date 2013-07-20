# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kickstapi/version'

Gem::Specification.new do |spec|
  spec.name          = "kickstapi"
  spec.version       = Kickstapi::VERSION
  spec.authors       = ["Kristof Vannotten"]
  spec.email         = ["kristof@vannotten.be"]
  spec.description   = %q{Ruby gem that offers an API for kickstarter}
  spec.summary       = %q{This gem offers an API for Kickstarter}
  spec.homepage      = "https://github.com/kvannotten/kickstapi"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  
  ["mechanize"].each do |gem_name|
    spec.add_dependency gem_name
  end
end
