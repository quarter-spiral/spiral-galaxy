# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spiral-galaxy/version'

Gem::Specification.new do |gem|
  gem.name          = "spiral-galaxy"
  gem.version       = Spiral::Galaxy::VERSION
  gem.authors       = ["Thorben Schröder"]
  gem.email         = ["stillepost@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'brochure'
  gem.add_dependency 'therubyracer'
  gem.add_dependency 'coffee-script'
  gem.add_dependency 'less'
  gem.add_dependency 'omniauth-oauth2'

  gem.add_dependency 'angular-commons-middleware', '>= 0.0.2'
  gem.add_dependency 'thin'
end
