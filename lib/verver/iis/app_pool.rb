require 'delegate'

module Verver
  module IIS

    # Manage an IIS AppPool
    #
    # app_pool = Verver::IIS::AppPool.new('DefaultAppPool')
    # app_pool.stop
    # app_pool.start
    # app_pool.recycle
    class AppPool < SimpleDelegator

      def initialize(name, iis_automation=Automation.new)
        app_pool = iis_automation.get(app_pool_key(name))
        super(app_pool)
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

      private

      def app_pool_key(name)
        "ApplicationPool.Name='#{name}'"
      end

    end

  end
end

