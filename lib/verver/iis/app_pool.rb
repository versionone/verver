module Verver
  module IIS

    # app_pool.stop
    # app_pool.start
    # app_pool.recycle
    class AppPool

      def initialize(name, iis_automation=Automation.new)
        @app_pool = iis_automation.get(app_pool_key(name))
      end

      private

      def app_pool_key(name)
        "ApplicationPool.Name='#{name}'"
      end

    end

  end
end
