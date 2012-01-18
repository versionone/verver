require 'verver/jenkins'

describe Jenkins do

  describe ".job_name" do
    it "defaults to 'local-job'" do
      Jenkins.job_name.should == 'local-job'
    end

    it "is overridden by JOB_NAME ENV variable" do
      ENV.stub(:[]).and_return('bob-job')
      Jenkins.job_name.should == 'bob-job'
    end
  end

end
