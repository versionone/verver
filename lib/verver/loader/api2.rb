require 'httparty'
require 'verver/loader/config'

module Verver
  module Loader

    class API2

      include HTTParty
      base_uri "#{Verver::Loader::Config.app_url.sub(/\/$/, '')}/rest-1.v1/Data/"

      def lookup(asset, oid)
        self.class.get("/#{asset.to_s.capitalize}", {basic_auth: {username: 'admin', password: 'admin'}})
      end

    end

  end
end