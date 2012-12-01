require 'uri'
require 'json'
require 'base64'
require 'openssl'
require 'erb'

module Spiral::Galaxy
  class CanvasRedirect
    class ViewModel < Struct.new(:canvas_url, :signed_request)
      def render(template)
        ERB.new(template).result(binding)
      end
    end

    class TokenStore
      def self.token(connection)
        @token ||= connection.auth.create_app_token(ENV['QS_OAUTH_CLIENT_ID'], ENV['QS_OAUTH_CLIENT_SECRET'])
      end

      def self.reset!
        @token = nil
      end
    end

    def call(env)
      request = Rack::Request.new(env)
      game = request.path.split('/').last
      secret = connection.devcenter.get_game(token, game)['secret']
      player = logged_in_player(request)

      if player
        body = ViewModel.new(canvas_url(game, player), sign_player_info(player, secret)).render(template)

        [200, {'Content-Type' => 'text/html'}, [body]]
      else
        redirect_to '/'
      end
    rescue Exception => e
      require 'pp'
      p e.message
      pp e.backtrace
      raise e
    end

    protected
    def canvas_url(game, player)
      File.join(ENV['QS_CANVAS_APP_URL'], 'v1/games', game, "spiral-galaxy")
    end

    def logged_in_player(request)
      cookie = request.cookies['qs_authentication']
      return nil unless cookie
      cookie = JSON.parse(cookie)
      (cookie['info'] || {})
    end

    def sign_player_info(player, secret)
      player_info = {
        'algorithm' => 'HMAC-SHA256',
        'uuid' => player['uuid'],
        'name' => player['name']
      }
      player_info = JSON.dump(player_info)
      player_info = Base64.urlsafe_encode64(player_info)

      signature = OpenSSL::HMAC.digest('sha256', secret, player_info)

      signature.force_encoding('UTF-8')
      player_info.encode!('utf-8')
      signature.encode!('utf-8')

      signature = Base64.urlsafe_encode64(signature)

      "#{signature}.#{player_info}"
    end

    def template
      @template ||= File.read(File.expand_path('../../../templates/play.html.erb', __FILE__))
    end

    def redirect_to(url)
      [302, {'Content-Type' => 'text/plain', 'Location' => url}, ['']]
    end

    def connection
      @connection ||= Connection.create
    end

    def token
      TokenStore.token(connection)
    end

    def try_twice_and_avoid_token_expiration
      yield
    rescue Service::Client::ServiceError => e
      raise e unless e.error == 'Unauthenticated'
      TokenStore.reset!
      yield
    end
  end
end