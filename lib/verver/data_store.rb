module Verver
  module DataStore

    def self.server
      ENV['SQL_SERVER'] || '.'
    end

  end
end
