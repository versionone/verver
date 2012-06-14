require 'httparty'
require 'nokogiri'

module Verver
  module Loader

    class Meta
      include HTTParty
      include Config
      include Utility

      def initialize(name)
        self.class.base_uri "#{app_url.sub(/\/$/, '')}/meta.v1/#{name}"
      end

      def xml
        update_xml unless @xml
        @xml
      end

      def reset
        @xml = nil
      end

      def simple_attributes
        all_attributes.select { |key,attr| (attr[:type] != "Relation") && (!attr[:multivalue]) }
      end

      def relation_attributes
        all_attributes.select { |key,attr| (attr[:type] == "Relation") && (!attr[:multivalue]) }
      end

      def all_attributes
        update_xml unless @xml
        @attributes
      end

      private

      def update_xml
        response = self.class.get('', {basic_auth: {username: login, password: password}})
        @xml = Nokogiri::XML::Document.parse(response.body)

        @attributes = Hash[[*xml.xpath("//AttributeDefinition").map { |e|
          [ruby_friendly_name(e["name"]), {actual_name: e["name"], type: e["attributetype"], multivalue: e["ismultivalue"] == "True", required: e["isrequired"] == "True", custom: e["iscustom"] == "True", token: e["token"], display_name: e["displayname"]}]
        }]]
      end

    end

    module AssetHelpers
      module ClassMethods
        def meta
          @meta
        end

        def create(options)
          operation = Verver::Loader::FindOrCreateOperation.new(@asset_name) do |asset|

            # simple attributes
            asset.attributes do |asset_attributes|
              options.select { |k, v| @meta.simple_attributes.include?(k.to_s) }.each do |k, v|
                asset_attributes.send k, v
              end
            end

            # simple relations
            asset.relations do |asset_relations|
              options.select { |k, v| @meta.relation_attributes.include?(k.to_s) }.each do |k, v|
                asset_relations.send k, v
              end
            end

          end

          operation.render
          api = Verver::Loader::API.new(self)
          api.create(operation)
        end

        def method_missing(symbol, *args)
          if (symbol =~ /^find_all_by_(.*)$/) && (attr = @meta.all_attributes[$1])
            Verver::Loader::API.new(self).lookup_all(@asset_name, {attr[:actual_name] => args[0]})
          elsif (symbol =~ /^find_by_(.*)$/) && (attr = @meta.all_attributes[$1])
            Verver::Loader::API.new(self).lookup(@asset_name, attr[:actual_name], args[0])
          else
            raise NoMethodError, "No method `#{symbol}` on `#{self}`"
          end

        end

      end

        class << self
          def included(base)
            base.instance_variable_set :@meta, Meta.new(base.name)
            base.instance_variable_set :@asset_name, base.name
            base.extend(ClassMethods)
          end
        end
    end
  end
end