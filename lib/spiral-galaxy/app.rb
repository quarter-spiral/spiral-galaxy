ENV_KEYS_TO_EXPOSE = ['QS_DEVCENTER_BACKEND_URL', 'QS_PLAYERCENTER_BACKEND_URL', 'QS_CANVAS_APP_URL', 'QS_S3_HOST', 'QS_AUTH_BACKEND_URL']

module Spiral::Galaxy
  class App
    def initialize
      auth_callback = auth_callback_handler

      @app = Rack::Builder.new do
        # QS Auth
        use Rack::Session::Cookie, key: 'qs_spiral_galaxy'
        use OmniAuth::Builder do
          provider AuthBackend, ENV['QS_OAUTH_CLIENT_ID'], ENV['QS_OAUTH_CLIENT_SECRET']
        end

        map "/auth/auth_backend/callback" do
          run auth_callback
        end

        map "/play/" do
          run CanvasRedirect.new
        end

        root = File.expand_path('../../../', __FILE__)
        brochure = Brochure.app(root)
        use Angular::Commons::Middleware

        run brochure
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