require 'httparty'
require 'nokogiri'
require 'verver/loader/config'
require 'verver/loader/utility'
require 'verver/loader/asset'

module Verver
  module Loader

    # retrieves and creates assets from the versionone rest api
    # maps assets into ruby objects {Verver::Loader::Asset}
    class API2

      include HTTParty
      include Config
      include Utility

      def initialize()
        # set base_uri and get ready to HTTParty!
        self.class.base_uri "#{app_url.sub(/\/$/, '')}/rest-1.v1/Data/"
      end

      def lookup(asset, attribute_name, attribute_value)
        path = Verver::Loader::PathBuilder.search_path(asset, {attribute_name => attribute_value})
        response = self.class.get(path, {basic_auth: {username: login, password: password}})
        xml = Nokogiri::XML::Document.parse(response.body)

        total_assets_found = xml.xpath('//Assets').first()['total'].to_i
        return false if total_assets_found == 0

        attributes = {}
        oid = ''

        xml.xpath('//Assets/Asset').each do |found_asset|
          oid = found_asset['id']
          found_asset.xpath('Attribute').each do |attribute|
            attribute_key = ruby_friendly_name(attribute['name']).to_sym
            attributes[attribute_key] = attribute.content
          end
        end

        Asset.new(oid, attributes, {})
      end

      def create; end

    end

  end
end
