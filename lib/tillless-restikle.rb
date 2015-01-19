# encoding: utf-8
unless defined?(Motion::Project::App)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  parent = File.join(File.dirname(__FILE__), '..')
  app.files.unshift(Dir.glob(File.join(parent, "motion/tillless-restikle/**/*.rb")))
  app.files.unshift(Dir.glob(File.join(parent, "motion/*.rb")))
  app.frameworks += %w{ CoreData }
end



# lib_dir_path = File.dirname(File.expand_path(__FILE__))
# Motion::Project::App.setup do |app|
#   app.resources_dirs << File.join(File.dirname(__FILE__), '../resources')
#   app.files.concat(Dir.glob(File.join(lib_dir_path, "tillless-restikle/**/*.rb")))
#   app.frameworks += %w{ CoreData }
# end
#
