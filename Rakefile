# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'motion/project/template/gem/gem_tasks'
require 'rubygems'
require 'bundler'
# require 'ib'
# require 'motion-cocoapods'
# require 'bubble-wrap'
# require 'bubble-wrap/all'
# require 'sugarcube-all'
# require 'motion-layout'
# require 'motion-kit'
# require 'motion-kit-events'
# require 'ProMotion'
# require './lib/tillless-uikit'

begin
  Bundler.require
rescue Exception => e
  puts "Exception processing Bundler.require:"
  puts e
end

Motion::Project::App.setup do |app|
  app.name                 = 'T-UIKit'
  app.identifier           = 'com.tillless.tillless-uikit-R100'
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
    app.name = 'T-UIKit Spec'
  end

  app.pods do
    pod 'NSData+MD5Digest'
    pod 'NSData+Base64'
    pod 'SVProgressHUD'
    pod 'JMImageCache'
    pod 'SVProgressHUD'
    pod 'TSMessages'
    pod 'ABPadLockScreen'
  end
end
