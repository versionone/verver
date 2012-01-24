require 'delegate'

begin require 'win32ole'
rescue LoadError # FUCKING HACKY! Must be on UNIX, just fake it.
  module ::WIN32OLE; end
end

module Verver
  module IIS

    class Automation < SimpleDelegator
      ADMIN_MONIKER = 'winmgmts:root\\WebAdministration'.freeze

      def initialize(win_automation=WIN32OLE)
        iis_automation = win_automation.connect(ADMIN_MONIKER)
        super(iis_automation)
      end

    end

  end
end
