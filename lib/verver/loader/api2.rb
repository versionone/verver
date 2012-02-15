require 'httparty'
require 'nokogiri'
require 'verver/loader/config'
require 'verver/loader/utility'
require 'verver/loader/asset'
require 'verver/loader/path_builder'

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
        return false if total_assets_found(xml) == 0
        build_asset_from_lookup(xml)
      end

      def create(operation)
        asset = operation.asset
        xml = format_post(operation.render()[:data])
        path = Verver::Loader::PathBuilder.create_path(asset)
        response = self.class.post(path, {basic_auth: {username: login, password: password}, body: xml})
        xml = Nokogiri::XML::Document.parse(response.body)
        build_asset_from_create(xml)
      end

      private

      def total_assets_found(xml)
        xml.xpath('//Assets').first()['total'].to_i
      end

      def build_asset_from_lookup(xml)
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

      def format_post(order)
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.Asset {
            order["Attribute"].each do |attr|
              xml.Attribute(:name => attr["name"], :act => 'set') {
                xml.text(attr["content"])
              }
            end
            order["Relation"].each do |attr|
              xml.Relation(:name => attr["name"], :act => attr["act"]) {
                attr["Asset"].each do |asset|
                  xml.Asset(:idref=> asset["idref"])
                end
              }
            end
            order["MVR"].each do |attr|
              xml.Relation(:name => attr["name"]) {
                attr["Asset"].each do |asset|
                  xml.Asset(:idref=> asset["idref"], :act=>asset["act"])
                end
              }
            end
          }
        end
        builder.to_xml
      end

      def build_asset_from_create(xml)
        oid = ''
        attributes = {}
        relations = {}

        assetNode = xml.css('Asset').first()

        oid = assetNode["id"]

        assetNode.css('Attribute').each do |attributeNode|
          attribute_key = ruby_friendly_name(attributeNode['name'])
          attributes[attribute_key] = attributeNode.content
        end

        Asset.new(oid, attributes, relations)
      end

    end

  end
end
