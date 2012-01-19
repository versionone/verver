module Verver
  module DataStore

    def self.server
      ENV['DB_SERVER'] || '.'
    end

    def self.db_name
      "#{Verver::Jenkins.job_name}_#{Verver::Jenkins.build_number}"
    end

  end
end
