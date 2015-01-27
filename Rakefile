# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'motion/project/template/gem/gem_tasks'

require 'bundler'
require 'bundler/gem_tasks'

begin
  if ARGV.join(' ') =~ /spec/
    Bundler.require :default, :spec
  else
    Bundler.require
  end
rescue Exception => e
  puts "Exception processing Bundler.require:"
  puts e
end

require 'ib'
require 'cdq'
require 'rubygems'
require 'motion-cocoapods'
require 'bubble-wrap'
require 'bubble-wrap/all'
require 'sugarcube-all'
require 'motion-support/inflector'
require 'webstub'
require 'restikle'

Motion::Project::App.setup do |app|
  app.name                 = 'Restikle'
  app.identifier           = 'com.tillless.restikle-R100'
  app.codesign_certificate = 'iPhone Developer: Matthew Sinclair (J9CF96HZ49)'
  app.provisioning_profile = 'provisioning/iOS_Team_Provisioning_Profile_.mobileprovision'

  app.frameworks += [
    'CoreData'
  ]
  app.detect_dependencies    = true
  app.interface_orientations = [:portrait]

  if ARGV.include? 'spec'
    app.name = 'Restikle Spec'
  end

  app.pods do
    pod 'AFNetworking', '~> 1.3.4'
    pod 'RestKit'
  end
end
task :"build:simulator" => :"schema:build"
