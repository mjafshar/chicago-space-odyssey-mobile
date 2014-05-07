# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bubble-wrap'
require 'twittermotion'
require 'map-kit-wrapper'
require 'rubygems'
require 'motion-pixatefreestyle'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'CSO'
  app.frameworks += ['Social', 'Twitter']
  app.pixatefreestyle.framework = 'vendor/PixateFreestyle.framework'
  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false
  app.interface_orientations = [:portrait]
  app.icons = ["logo.png", "logo@2x.png"]
end
