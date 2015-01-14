# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'motion/project/template/gem/gem_tasks'
require 'rubygems'
require 'bundler'
require 'ib'
require 'motion-cocoapods'
require 'bubble-wrap'
require 'bubble-wrap/all'
require 'sugarcube-all'
require './lib/tillless-restikle'

begin
  Bundler.require
rescue Exception => e
  puts "Exception processing Bundler.require:"
  puts e
end

Motion::Project::App.setup do |app|
  app.name                 = 'T-Restikle'
  app.identifier           = 'com.tillless.tillless-restikle-R100'
  app.codesign_certificate = 'iPhone Developer: Matthew Sinclair (J9CF96HZ49)'
  app.provisioning_profile = 'provisioning/iOS_Team_Provisioning_Profile_.mobileprovision'

  app.frameworks += [
    'AddressBook',
    'AddressBookUI',
    'AudioToolbox',
    'AVFoundation',
    'CoreMedia',
    'CoreVideo',
    'CoreLocation',
    'CoreBluetooth',
    'QuartzCore',
    'CoreData',
    'MessageUI',
    'MobileCoreServices',
    'OpenGLES',
    'Security',
    'UIKit',
    'SystemConfiguration'
  ]
  app.detect_dependencies    = true
  app.interface_orientations = [:portrait]

  if ARGV.include? 'spec'
    app.name = 'T-Restikle Spec'
  end

  app.pods do
  end
end
