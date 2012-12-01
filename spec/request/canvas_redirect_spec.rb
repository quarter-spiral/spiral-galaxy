#encoding: utf-8

require_relative '../spec_helper'

require 'base64'
require 'openssl'
require 'cgi'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
include Capybara::DSL

# Make sure Capybara fucks itself and actually shows errors happening in our webapp.
require 'rack/handler/thin'
Thin::Logging
module Thin::Logging
  def self.silent?
  end
end

ENV['QS_AUTH_BACKEND_URL'] = 'http://auth-backend.dev'

def login(uuid, name)
  Capybara.current_session.driver.set_cookie('qs_authentication', CGI::escape(JSON.dump(info: {uuid: uuid, name: name, token: "some-token-#{Time.now.to_f}"})))
end

# Methods to decode signed requests taken from https://github.com/nsanta/fbgraph/blob/master/lib/fbgraph/canvas.rb
def parse_signed_request(secret_id, request)
  encoded_sig, payload = request.split('.', 2)

  sig = urldecode64(encoded_sig)
  data = JSON.parse(urldecode64(payload))
  if data['algorithm'].to_s.upcase != 'HMAC-SHA256'
    raise "Bad signature algorithm: %s" % data['algorithm']
  end
  expected_sig = OpenSSL::HMAC.digest('sha256', secret_id, payload)
  if expected_sig != sig
    raise "Bad signature"
  end
  data
end

def urldecode64(str)
  encoded_str = str.tr('-_', '+/')
  encoded_str += '=' while !(encoded_str.size % 4).zero?
  Base64.decode64(encoded_str)
end

APP = Rack::Builder.new {
  map '/fake-canvas' do
    run lambda {|env|
      request = Rack::Request.new(env)

      raise "Signed Request must be posted!" unless request.request_method == 'POST'
      [200, {"Content-Type" => "text/plain"}, [request.params['signed_request']]]
    }
  end

  map '/fake-devcenter' do
    run DEVCENTER_APP
  end

  run App.new
}

Capybara.default_driver = :poltergeist

Capybara.app = APP

describe CanvasRedirect do
  before do
    Capybara.current_session.driver.set_cookie('qs_authentication', nil)

    visit '/'

    uri = URI.parse(page.current_url)
    ENV['QS_CANVAS_APP_URL'] = "http://localhost:#{uri.port}/fake-canvas"
    ENV['QS_DEVCENTER_BACKEND_URL'] = "http://localhost:#{uri.port}/fake-devcenter"

    @developer = UUID.new.generate
    connection.graph.add_role(@developer, APP_TOKEN, 'developer')

    @player = AUTH_HELPERS.user_data
    @player['name'] = "Thorben Schröder"
    connection.graph.add_role(@player['uuid'], APP_TOKEN, 'player')

    @game_options = {:name => "Test Game 1", :description => "Good game", :configuration => {'type' => 'html5', 'url' => 'http://example.com'},:developers => [@developer], :venues => {"spiral-galaxy" => {"enabled" => true}}}
    @game = Devcenter::Backend::Game.create(APP_TOKEN, @game_options)
  end

  after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  it "redirects testo the canvas-app with the uuid set" do
    secret = @game.secret
    login(@player['uuid'], @player['name'])

    visit "/play/#{@game.uuid}"

    page.has_no_selector?('form').must_equal true

    signed_request = page.evaluate_script('document.getElementsByTagName("html")[0].innerText')
    result = parse_signed_request(secret, signed_request)
    result['uuid'].must_equal @player['uuid']
    result['name'].must_equal @player['name']
    result['oauth_token'].wont_be_nil
  end

  it "redirects to the spiral-galaxy index if not logged in" do
    visit "/play/#{@game.uuid}"
    page.current_path.gsub(/#.*$/, '').must_equal "/"
  end
end