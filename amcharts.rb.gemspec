# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amcharts/version'

Gem::Specification.new do |spec|
  spec.name          = 'amcharts.rb'
  spec.version       = AmCharts::VERSION
  spec.authors       = ['Daniel Vandersluis']
  spec.email         = ['dvandersluis@selfmgmt.com']
  spec.description   = %q{Ruby wrapper for Amcharts}
  spec.summary       = %q{Wrapper for Amcharts 3 Javascript charts}
  spec.homepage      = 'https://github.com/dvandersluis/amcharts.rb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  if RUBY_VERSION >= '2.2.2'
    spec.add_dependency 'rails', '> 3.0.0'
  else
    spec.add_dependency 'rails', '> 3.0.0', '< 5'
  end

  spec.add_dependency 'collection_of', '>= 1.0.3'

  spec.add_development_dependency 'rake', '> 11.0.1', '< 12'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec', '2.14.1'
  spec.add_development_dependency 'nokogiri', '~> 1.6.8'
  spec.add_development_dependency 'thor'
  spec.add_development_dependency 'mechanize', '2.7.4'
  spec.add_development_dependency 'rubyzip', '1.1.0'
end
