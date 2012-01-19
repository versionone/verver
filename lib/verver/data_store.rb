module Verver
  module DataStore

    def self.server
      ENV['DB_SERVER'] || '.'
    end

    def self.db_name
      "#{Verver::Jenkins.job_name}_#{Verver::Jenkins.build_number}"
    end

    def self.user
      ENV['DB_SERVER_USER'] || 'pub'
    end

  end
end
