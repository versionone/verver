module Verver
  module Loader

    module Config

      def self.app_url
        (ENV['APP_URL'] || 'http://localhost/VersionOne.Web').sub(/\/$/, '')
      end

      def self.login
        ENV['LOGIN'] || 'admin'
      end

      def self.password
        ENV['PASSWORD'] || 'admin'
      end

    end

  end
end
