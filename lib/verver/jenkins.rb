class Jenkins

  def self.job_name
    ENV['JOB_NAME'] || 'local-job'
  end
end
