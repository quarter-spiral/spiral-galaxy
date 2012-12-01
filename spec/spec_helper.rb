ENV['RACK_ENV'] ||= 'test'

Bundler.require

require 'minitest/autorun'
require 'rack/client'
require 'uuid'

require 'datastore-backend'
require 'auth-backend'
require 'graph-backend'
require 'devcenter-backend'

require 'spiral-galaxy'

include Spiral::Galaxy

GRAPH_BACKEND = Graph::Backend::API.new
module Auth::Backend
  class Connection
    alias raw_initialize initialize
    def initialize(*args)
      result = raw_initialize(*args)

      graph_adapter = Service::Client::Adapter::Faraday.new(adapter: [:rack, GRAPH_BACKEND])
      @graph.client.raw.adapter = graph_adapter

      result
    end
  end
end

DATASTORE_BACKEND = Datastore::Backend::API.new
module Devcenter::Backend
  class Connection
    alias raw_initialize initialize
    def initialize(*args)
      result = raw_initialize(*args)

      graph_adapter = Service::Client::Adapter::Faraday.new(adapter: [:rack, GRAPH_BACKEND])
      @graph.client.raw.adapter = graph_adapter

      datastore_adapter = Service::Client::Adapter::Faraday.new(adapter: [:rack, DATASTORE_BACKEND])
      @datastore.client.raw.adapter = datastore_adapter

      result
    end
  end
end

AUTH_APP = Auth::Backend::App.new(test: true)
module Auth
  class Client
    alias raw_initialize initialize
    def initialize(url, options = {})
      raw_initialize(url, options.merge(adapter: [:rack, AUTH_APP]))
    end
  end
end

DEVCENTER_APP = Devcenter::Backend::API.new
module Devcenter
  class Client
    alias raw_initialize initialize
    def initialize(url)
      raw_initialize(url)
      adapter = Service::Client::Adapter::Faraday.new(adapter: [:rack, DEVCENTER_APP])
      client.raw.adapter = adapter
    end
  end
end

require 'auth-backend/test_helpers'
AUTH_HELPERS = Auth::Backend::TestHelpers.new(AUTH_APP)
OAUTH_APP = AUTH_HELPERS.create_app!
ENV['QS_OAUTH_CLIENT_ID'] = OAUTH_APP[:id]
ENV['QS_OAUTH_CLIENT_SECRET'] = OAUTH_APP[:secret]

def connection
  @connection ||= Devcenter::Backend::Connection.create
end
APP_TOKEN = connection.auth.create_app_token(OAUTH_APP[:id], OAUTH_APP[:secret])