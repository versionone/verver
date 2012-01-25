require 'delegate'

begin require 'win32ole'
rescue LoadError # FUCKING HACKY! Must be on UNIX, just fake it.
  module ::WIN32OLE; end
end

module Verver
  module IIS

    # A thin wrapper around a WIN32OLE object that will automate
    # management of IIS.
    #
    # iis_automation = Automation.new
    # app_pool = iis_automation.get("ApplicationPool.name='DefaultAppPool'")
    class Automation < SimpleDelegator
      ADMIN_MONIKER = 'winmgmts:root\\WebAdministration'.freeze

      def initialize(win_automation=WIN32OLE)
        iis_automation = win_automation.connect(ADMIN_MONIKER)
        super(iis_automation)
      end

    end

  end
end
