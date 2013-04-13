ENV_KEYS_TO_EXPOSE = ['QS_DEVCENTER_BACKEND_URL', 'QS_PLAYERCENTER_BACKEND_URL', 'QS_CANVAS_APP_URL', 'QS_S3_HOST', 'QS_AUTH_BACKEND_URL']

require 'sprockets'
require 'rack/cache'
require 'rack/ssl-enforcer'

module Spiral::Galaxy
  class App
    def initialize
      auth_callback = auth_callback_handler

      @app = Rack::Builder.new do
        use Rack::SslEnforcer if ENV['RACK_ENV'] == 'production'

        # QS Auth
        use Rack::Session::Cookie, secret: ENV['QS_COOKIE_SECRET'] || 'some-secret', key: 'qs_spiral_galaxy', :expire_after => 2592000
        use OmniAuth::Builder do
          provider AuthBackend, ENV['QS_OAUTH_CLIENT_ID'], ENV['QS_OAUTH_CLIENT_SECRET']
        end

        map "/auth/auth_backend/callback" do
          run auth_callback
        end

        if ENV['RACK_ENV'] == 'production'
          memcached_base_url = "memcached://#{ENV['MEMCACHIER_USERNAME']}:#{ENV['MEMCACHIER_PASSWORD']}@#{ENV['MEMCACHIER_SERVERS']}"
          use Rack::Cache,
            :metastore   => "#{memcached_base_url}/meta",
            :entitystore => "#{memcached_base_url}/body"
        end

        map "/play/" do
          run CanvasRedirect.new
        end

        sprockets_environment = Assets.new
        index_url = Assets::AssetUrlBuilder.new(sprockets_environment).asset_url('index.html')

        app = lambda do |env|
          env['PATH_INFO'] = index_url if env['PATH_INFO'] == '/'
          sprockets_environment.call(env)
        end
        run app
      end
    end

    def call(env)
      @app.call(env)
    end

    protected
    def auth_callback_handler
      Proc.new { |env|
        response = Rack::Response.new('', 301, 'Location' => env['omniauth.origin'] || '/')
        response.set_cookie('qs_authentication', value: JSON.dump(env['omniauth.auth']), path: '/')

        response
      }
    end
  end
end