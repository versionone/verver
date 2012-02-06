module Verver
  module Loader

    class Config

      def app_url
        ENV['APP_URL'] || 'http://localhost/VersionOne.Web/'
      end

      def login
        ENV['LOGIN'] || 'admin'
      end

      def password
        ENV['PASSWORD'] || 'admin'
      end
    end

  end
end
