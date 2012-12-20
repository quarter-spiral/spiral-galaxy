require 'bundler'
Bundler.require

ENV["RACK_ENV"] ||= "development"

require 'spiral-galaxy'

# Metaserver Setup
if !ENV['RACK_ENV'] || ENV['RACK_ENV'] == 'development'
  ENV['QS_OAUTH_CLIENT_ID'] ||= 'nwwd7pi7lqoiw3utuy1qawgl920xw10'
  ENV['QS_OAUTH_CLIENT_SECRET'] ||= 'kaqrs5nnau2tjnmo4r2w2q86wue3bo7'
end

require 'newrelic_rpm'
require 'new_relic/agent/instrumentation/rack'
require 'ping-middleware'

class NewRelicMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  end
  include NewRelic::Agent::Instrumentation::Rack
end

use NewRelicMiddleware
use Ping::Middleware

# Password protection on production
if ENV['RACK_ENV'] == 'production'
  use Rack::Auth::Basic, "Sample Dev App" do |username, password|
      'redwoodpho' == password
  end
end

run Spiral::Galaxy::App.new