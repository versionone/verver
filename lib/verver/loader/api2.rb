require 'httparty'
require 'verver/loader/config'

module Verver
  module Loader

    class API2

      include HTTParty

      base_uri Verver::Loader::Config.app_url

    end

  end
end