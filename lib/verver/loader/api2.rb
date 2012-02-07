require 'httparty'
require 'verver/loader/config'

module Verver
  module Loader

    class API2

      include HTTParty
      include Config

      def lookup(asset, attribute_name, attribute_value)

        self.class.base_uri "#{app_url.sub(/\/$/, '')}/rest-1.v1/Data/"

        path = "/#{asset.to_s.capitalize}?where=#{attribute_name}='#{attribute_value}'"
        self.class.get(path, {basic_auth: {username: login, password: password}})

      end

    end

  end
end