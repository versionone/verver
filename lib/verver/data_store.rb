module Verver
  module DataStore

    #test

    def self.server
      ENV['DB_SERVER'] || '.'
    end

    def self.db_name
      "#{Verver::Jenkins.job_name}_#{Verver::Jenkins.build_number}"
    end

    def self.user
      ENV['DB_SERVER_USER'] || 'pub'
    end

    def self.create_sql
      File.join(File.expand_path('..', __FILE__), %w[support create_db.sql])
    end

    def self.drop_sql
      File.join(File.expand_path('..', __FILE__), %w[support drop_db.sql])
    end

  end
end
