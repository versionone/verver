begin require 'win32console'
rescue LoadError
  puts "[WARN] RubyGem 'win32console' not installed. Are you on UNIX?"
end

module Verver
  module IIS

    # A wrapper over the IIS Components Registry Hive.
    #
    # components = Verver::ISS:Components.new
    # components.installed?(:management_scripting_tools) #=> true/false
    class Components

      KEYNAME = 'SOFTWARE\\Microsoft\\InetStp\\Components'.freeze

      def initialize(hive=::Win32::Registry::HKEY_LOCAL_MACHINE)
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
