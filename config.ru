require 'bundler'
Bundler.require

ENV["RACK_ENV"] ||= "development"

require 'spiral-galaxy'

# Metaserver Setup
if !ENV['RACK_ENV'] || ENV['RACK_ENV'] == 'development'
  ENV['QS_OAUTH_CLIENT_ID'] ||= 'nwwd7pi7lqoiw3utuy1qawgl920xw10'
  ENV['QS_OAUTH_CLIENT_SECRET'] ||= 'kaqrs5nnau2tjnmo4r2w2q86wue3bo7'
end

# Password protection on production
if ENV['RACK_ENV'] == 'production'
  use Rack::Auth::Basic, "Sample Dev App" do |username, password|
      'redwoodpho' == password
  end
end

# QS Auth
use Rack::Session::Cookie, key: 'qs_spiral_galaxy'
use OmniAuth::Builder do
  provider Spiral::Galaxy::AuthBackend, ENV['QS_OAUTH_CLIENT_ID'], ENV['QS_OAUTH_CLIENT_SECRET']
end

map "/auth/auth_backend/callback" do
  run Proc.new { |env|
    response = Rack::Response.new('', 301, 'Location' => '/')
    response.set_cookie('qs_authentication', value: JSON.dump(env['omniauth.auth']), path: '/')

    response
  }
end

# Actual app
ENV_KEYS_TO_EXPOSE = ['QS_DEVCENTER_BACKEND_URL', 'QS_PLAYERCENTER_BACKEND_URL', 'QS_CANVAS_APP_URL', 'QS_S3_HOST', 'QS_AUTH_BACKEND_URL']

root = File.dirname(__FILE__)
brochure = Brochure.app(root)
use Angular::Commons::Middleware

run brochure
