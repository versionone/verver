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
    # iis_automation = Verver::IIS::Automation.new
    # app_pool = iis_automation.get("ApplicationPool.name='DefaultAppPool'")
    class Automation < SimpleDelegator
      ADMIN_MONIKER = 'winmgmts:root\\WebAdministration'.freeze

      def initialize(win_automation=WIN32OLE)
        iis_automation = win_automation.connect(ADMIN_MONIKER)
        super(iis_automation)
      end

      def method_missing(name, *args)
        if __getobj__.ole_respond_to?(name)
          __getobj__.send(name, *args)
        else
          super(name, *args)
        end
      end

      def respond_to_missing?(name, include_private)
        ole_respond_to?(name) || super(name, include_private)
      end

    end

  end
end

