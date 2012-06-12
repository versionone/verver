require('uri')
require('verver/loader/utility')

module Verver
  module Loader

    module PathBuilder

      extend Verver::Loader::Utility

      def self.search_path(asset, query)
        path = "/#{meta_friendly_name(asset)}"
        if query.is_a? String
          path += '?where=#{query}'
        elsif query.is_a? Hash
          path += '?where='
          path += query.map {|key,value| "#{key}='#{value}'"}.join(';')
        end
        URI.escape(path)
      end

      def self.create_path(asset)
        "/#{meta_friendly_name(asset)}"
      end

    end

  end
end