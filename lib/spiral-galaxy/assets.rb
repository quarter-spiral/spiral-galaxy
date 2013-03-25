require 'sprockets'
require 'angular-commons-middleware'

module Spiral
  module Galaxy
    class Assets < Sprockets::Environment
      class AssetUrlBuilder
        def initialize(environment)
          @environment = environment
        end

        def asset_url(asset)
          asset_parts = asset.split('.')
          extension = asset_parts.pop
          asset_name = asset_parts.join('.')

          "#{asset_name}-#{@environment.find_asset(asset).digest}.#{extension}"
        end
      end

      attr_reader :rack_env

      def initialize
        super
        append_path File.expand_path('../../../assets', __FILE__)
        append_path File.join(Angular::Commons::Middleware.root, 'templates')

        reference_to_self = self

        context_class.class_eval do
          def asset_url(asset)
            @asset_url_builder ||= AssetUrlBuilder.new(environment)
            @asset_url_builder.asset_url(asset)
          end

          def rack_env
            if environment.kind_of?(Sprockets::Index)
              environment.instance_variable_get('@environment').rack_env
            else
              environment.rack_env
            end
          end
        end
      end

      def call(env)
        @rack_env = env
        super(env)
      end
    end
  end
end