module Verver
  class Jenkins

    def self.job_name
      ENV['JOB_NAME'] || 'local-job'
    end

    def self.build_number
      ENV['BUILD_NUMBER'] || 0
    end
  end
end
