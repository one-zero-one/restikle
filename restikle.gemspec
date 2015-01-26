# -*- encoding: utf-8 -*-
require File.expand_path('../lib/restikle/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "restikle"
  spec.version       = Restikle::VERSION
  spec.authors       = ["tillless", "matthewsinclair"]
  spec.email         = ["matthew.sinclair@tillless.com"]
  spec.description   = %q{Easily work with Rails routes and schemas in an iOS RestKit+CDQ project.}
  spec.summary       = %q{Easily work with Rails routes and schemas in an iOS RestKit+CDQ project.}
  spec.homepage      = "http://www.tillless.com"
  spec.license       = "MIT"

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  files.concat(Dir.glob('motion/**/*.rb'))
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
  spec.add_dependency 'sugarcube'            #, '~> 3.1.1'

  spec.add_development_dependency 'bundler'        #, '~> 1.7.9'
  spec.add_development_dependency 'rake'           #, '~> 10.4.2'
  spec.add_development_dependency 'activesupport'  #, '~> 4.2.0'
  spec.add_development_dependency 'webstub'        #, '~> 1.1.2'
end
