# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tillless-uikit/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "tillless-uikit"
  spec.version       = TilllessUIKit::VERSION
  spec.authors       = ["Matthew Sinclair"]
  spec.email         = ["me@matthew-sinclair.com"]
  spec.description   = %q{iOS UIKit views for Tillless Apps}
  spec.summary       = %q{iOS UIKit views for Tillless Apps}
  spec.homepage      = "http://www.tillless.com"
  spec.license       = ""

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'cocoapods',           '~> 0.35.0'
  spec.add_dependency 'xcodeproj',           '~> 0.20.2'
  spec.add_dependency 'motion-cocoapods',    '~> 1.7.0'
  spec.add_dependency 'bubble-wrap',         '~> 1.7.1'
  spec.add_dependency 'ib',                  '~> 0.7.1'
  spec.add_dependency 'cdq',                 '~> 0.1.11'
  spec.add_dependency 'ProMotion',           '~> 2.2.0'
  spec.add_dependency 'sugarcube',           '~> 3.0.2'
  spec.add_dependency 'motion-layout',       '~> 0.0.2'
  spec.add_dependency 'motion-kit',          '~> 0.17.0'
  spec.add_dependency 'motion-kit-events',   '~> 0.3.1'

  spec.add_development_dependency 'bundler', '~> 1.7.9'
  spec.add_development_dependency 'rake',    '~> 10.4.2'

end
