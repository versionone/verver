require('uri')
require('verver/loader/utility')
require 'active_support/core_ext'

module Verver
  module Loader

    module PathBuilder

      extend Verver::Loader::Utility

      def self.search_path(asset, options)

        path = "/#{meta_friendly_name(asset)}"
        where = options[:where]
        select = options[:select]

        query = {}

        if where.is_a? String
          query[:where] = where
        elsif where.is_a? Hash
          query[:where] = where.map {|key,value| "#{key}='#{value}'"}.join(';')
        end

        if select.is_a? String
          query[:sel] = select
        elsif select.is_a? Array
          query[:sel] = select.join(',')
        end

        URI.escape(path) + "?" + query.to_query
      end

      def self.create_path(asset)
        "/#{meta_friendly_name(asset)}"
      end

    end

  end
end