require 'httparty'
require 'nokogiri'
require 'verver/loader/config'
require 'verver/loader/utility'
require 'verver/loader/asset'
require 'verver/loader/path_builder'
require 'verver/loader/creation_exception'

module Verver
  module Loader

    # retrieves and creates assets from the versionone rest api
    # maps assets into ruby objects {Verver::Loader::Asset}
    class API

      include HTTParty
      include Config
      include Utility

      def initialize(base_asset_type = Asset)
        @base_asset_type = base_asset_type
        # set base_uri and get ready to HTTParty!
        self.class.base_uri "#{app_url.sub(/\/$/, '')}/rest-1.v1/Data/"
      end

      def lookup(asset, attribute_name, attribute_value)
        xml = get_xml(asset, {:where => {attribute_name => attribute_value}})
        return false if total_assets_found(xml) == 0
        build_asset_from_lookup(xml.xpath("//Assets/Asset").first)
      end

      def lookup_all(asset, options = {})
        xml = get_xml(asset, options)
        xml.xpath("//Assets/Asset").map { |a| build_asset_from_lookup(a) }
      end

      def create(operation)
        asset = operation.asset
        xml = format_post(operation.render()[:data])
        path = Verver::Loader::PathBuilder.create_path(asset)
        response = self.class.post(path, {basic_auth: {username: login, password: password}, body: xml})
        raise StandardError, "Could not create execute operation.\n\n#{response.body}\n\n" unless response.success?
        xml = Nokogiri::XML::Document.parse(response.body)
        oid = parse_oid_from(xml)
        lookup(operation.asset, 'ID', oid)
      end

      private

      def parse_oid_from(xml)

        if (xml.xpath('//Error//Message').count > 0)
          error_message = xml.xpath('//Error//Message').text()
          raise Verver::Loader::CreationException.new(error_message)
        end

        xml.css('Asset').first()["id"]
      end

      def get_xml(asset, query)
        path = Verver::Loader::PathBuilder.search_path(asset, query)
        response = self.class.get(path, {basic_auth: {username: login, password: password}})
        raise StandardError, "Could not create execute operation.\n\n#{response.body}\n\n" unless response.success?
        Nokogiri::XML::Document.parse(response.body)
      end


      def total_assets_found(xml)
        xml.xpath('//Assets').first()['total'].to_i
      end

      def build_asset_from_lookup(asset)
        oid = asset['id']

        attributes = asset.xpath('./Attribute').map do |attribute|
          key = ruby_friendly_name(attribute['name']).to_sym
          value = (attribute.xpath("./Value").length > 0) ? attribute.xpath("./Value").map { |x| x.content } : attribute.content
          [key, value]
        end

        relations = asset.xpath("./Relation").select do |relation|
          relation.xpath("./Asset/@idref").any?
        end.map do |relation|
          rel_name = relation["name"]
          id = relation.xpath("./Asset/@idref").map { |x| x.value }

          rel_values = asset.xpath("./Attribute[starts-with(@name,'#{rel_name}.')]").select do |attribute|
            attribute['name'] =~ /^#{rel_name}\.[^.]+$/
          end.map do |attribute|
            key = ruby_friendly_name(attribute['name'].gsub(/^#{rel_name}\./, "")).to_sym
            value = (attribute.xpath("./Value").length > 0) ? attribute.xpath("./Value").map { |x| x.content } : [attribute.content]
            [key, value]
          end << [:id, id]

          keys, values = rel_values.transpose

          result = (0...values.first.length).map do |x| #size of array of hashes to end with
            obj = {}
            keys.each_with_index do |key, y|
              obj[key] = values[y][x]
            end
            obj
          end

          asset_list = result.map { |r| Asset.new(r[:id], r) }

          [ruby_friendly_name(rel_name).to_sym, asset_list]
        end

        @base_asset_type.new(oid, Hash[[*attributes]].merge(Hash[[*relations]]))
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
                  xml.Asset(:idref => asset["idref"])
                end
              }
            end
            order["MVR"].each do |attr|
              xml.Relation(:name => attr["name"]) {
                attr["Asset"].each do |asset|
                  xml.Asset(:idref => asset["idref"], :act => asset["act"])
                end
              }
            end
          }
        end
        builder.to_xml
      end


    end

  end
end
