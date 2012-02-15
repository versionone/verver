require('verver/loader/utility')

module Verver
  module Loader

    module PathBuilder

      extend Verver::Loader::Utility

      def self.search_path(asset, query)
        path = "/#{meta_friendly_name(asset)}"
        path += '?where=' if query
        query.each {|key,value| path += "#{key}='#{value}'"}
        path
      end

      def self.create_path(asset)
        "/#{meta_friendly_name(asset)}"
      end

    end

  end
end