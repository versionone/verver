module Verver
  module Loader

    class Asset

      attr_reader :name, :oid

      def initialize(name, oid, attributes={}, relations={})
        @name = name
        @oid = remove_moment_from(oid)
        attributes.each do |key, value|
          define_singleton_method key.to_sym do
            return value
          end
        end
        @relations = relations
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
