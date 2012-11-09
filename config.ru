require 'bundler'
Bundler.require

ENV["RACK_ENV"] = "development"

require 'brochure'

root = File.dirname(__FILE__)
brochure = Brochure.app(root)

run brochure
