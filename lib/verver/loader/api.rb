module Verver

  module Loader

    class API

      include Verver::Loader::Utility

      def initialize(config)
        api_url = "#{config.app_url}rest-1.v1/Data"
        @data_connection = RestClient::Resource.new(api_url, config.login, config.password)
      end

      def post(asset, xml)
        begin
          response = @data_connection[asset].post(xml.to_s, :content_type => 'text/xml')
        rescue => e
          puts e.response
        end
        return Nokogiri::XML::Document.parse(response.to_s)
      end

      def lookup(asset, attribute_name, attribute_value, data)
        query = URI.encode("#{asset}?where=#{attribute_name}='#{attribute_value}'")
        xml = Nokogiri::XML::Document.parse(@data_connection[query].get())

        if need_to_create?(xml)
          post(asset, format_post(data))
          return lookup(asset, attribute_name, attribute_value, data)
        end

        return build_asset_from_lookup(asset, xml)

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

      def build_asset_from_lookup(asset, xml)
        oid = ''
        attributes = {}
        relations = {}

        xml.xpath('//Assets/Asset').each do |asset|
          oid = asset['id']
          asset.xpath('Attribute').each do |attribute|
            attribute_key = ruby_friendly_name(attribute['name']).to_sym
            attributes[attribute_key] = attribute.content
          end
        end

        Asset.new(asset, oid, attributes, relations)
      end

      def need_to_create?(xml)
        xml.xpath('//Assets').first()['total'].to_i == 0
      end

    end

  end

end
