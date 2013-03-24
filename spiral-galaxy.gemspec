# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spiral-galaxy/version'

Gem::Specification.new do |gem|
  gem.name          = "spiral-galaxy"
  gem.version       = Spiral::Galaxy::VERSION
  gem.authors       = ["Thorben Schröder"]
  gem.email         = ["stillepost@gmail.com"]
  gem.description   = %q{The Quarter Spiral game portal}
  gem.summary       = %q{The Quarter Spiral game portal}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'less'
  gem.add_dependency 'omniauth-oauth2'

  gem.add_dependency 'angular-commons-middleware', '>= 0.0.4'
  gem.add_dependency 'thin'

  gem.add_dependency 'devcenter-client', '>= 0.0.4'
  gem.add_dependency 'auth-client', '>= 0.0.14'
  gem.add_dependency 'newrelic_rpm'
  gem.add_dependency 'ping-middleware', '~> 0.0.2'
  gem.add_dependency 'sprockets', '~> 2.0'
  gem.add_dependency 'rack', '~> 1.4.5'
  gem.add_dependency 'rack-cache', '~> 1.2'
end
