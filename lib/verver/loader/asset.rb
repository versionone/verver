require('verver/loader/utility')

module Verver
  module Loader

    class Asset

      attr_reader :oid
      include Utility

      def initialize(oid, attributes={}, relations={})

        @attributes = attributes

        @oid = remove_moment_from(oid)

        attributes.each do |key, value|
          normalized_key = ruby_friendly_name(key)
          define_singleton_method normalized_key.to_sym do
            return value
          end
        end

        @relations = relations
      end

      def fetch(key)
        @attributes[key]
      end

      def remove_moment_from(oid)
        oid.split(':')[0..1].join(':')
      end

      def to_s
        return @oid
      end

    end

  end
end
