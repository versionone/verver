require 'httparty'
require 'verver/loader/config'

module Verver
  module Loader

    class API2

      include HTTParty

      #.sub(/\/$/, '')

      base_uri "#{Verver::Loader::Config.app_url.sub(/\/$/, '')}/rest-1.v1/Data"

    end

  end
end