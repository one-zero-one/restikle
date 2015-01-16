# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tillless-restikle/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "tillless-restikle"
  spec.version       = TilllessRestikle::VERSION
  spec.authors       = ["Matthew Sinclair"]
  spec.email         = ["matthew.sinclair@tillless.com"]
  spec.description   = %q{Takes the output of 'rails routes' and builds all necessary RestKit cruftage.}
  spec.summary       = %q{Takes the output of 'rails routes' and builds all necessary RestKit cruftage.}
  spec.homepage      = "http://www.tillless.com"
  spec.license       = ""

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'motion-support'       #, '~> 0.2.6'
  # spec.add_dependency 'cocoapods'            #, '~> 0.35.0'
  spec.add_dependency 'cocoapods'            , '~> 0.36.0.beta.1'
  spec.add_dependency 'xcodeproj'            #, '~> 0.20.2'
  spec.add_dependency 'motion-cocoapods'     #, '~> 1.7.0'
  spec.add_dependency 'bubble-wrap'          #, '~> 1.7.1'
  spec.add_dependency 'ib'                   #, '~> 0.7.1'
  spec.add_dependency 'cdq'                  #, '~> 0.1.11'
  spec.add_dependency 'sugarcube'            #, '~> 3.0.6'

  spec.add_development_dependency 'bundler'  #, '~> 1.7.9'
  spec.add_development_dependency 'rake'     #, '~> 10.4.2'

end
