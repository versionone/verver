module Verver
  module IIS
    class Components

      KEYNAME = 'SOFTWARE\\Microsoft\\InetStp\\Components'.freeze

      def initialize(hive=Win32::Registry::HKEY_LOCAL_MACHINE)
        @registry = hive.open(KEYNAME)
      end

      def installed?(component_key)
        @registry[titleize(component_key)] == 1
      end

      private
      def titleize(word)
        word.to_s.split('_').map(&:capitalize).join
      end

    end
  end
end
