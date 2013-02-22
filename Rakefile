require "bundler/gem_tasks"

require 'rake/testtask'


Rake::TestTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end

require 'rake/sprocketstask'
require 'spiral-galaxy/assets'
Rake::SprocketsTask.new do |t|
  t.environment = Spiral::Galaxy::Assets.new
  t.name        = 'assets:precompile'
  t.output      = "./public"
  t.assets      = %w( javascripts/application.js javsacripts/vendor.js javascripts/application.css)
end

task :default => :test