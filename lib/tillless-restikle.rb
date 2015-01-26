# encoding: utf-8
unless defined?(Motion::Project::App)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  parent = File.join(File.dirname(__FILE__), '..')
  app.files.unshift(Dir.glob(File.join(parent, "lib/tillless-restikle/concepts/**/*.rb")))
  app.files.unshift(Dir.glob(File.join(parent, "motion/tillless-restikle/**/*.rb")))
  app.files.unshift(Dir.glob(File.join(parent, "motion/*.rb")))
  app.frameworks += %w{ CoreData }
end
