require 'verver/jenkins'

describe Jenkins do

  describe ".job_name" do
    it "defaults to 'local-job'" do
      Jenkins.job_name.should == 'local-job'
    end

    it "is overridden by JOB_NAME ENV variable" do
      ENV.stub(:[]).with('JOB_NAME').and_return('bob-job')
      Jenkins.job_name.should == 'bob-job'
    end
  end

  describe ".build_number" do
    it "defaults to 0" do
      Jenkins.build_number.should == 0
    end

    it "is overridden by BUILD_NUMBER ENV variable" do
      ENV.stub(:[]).with('BUILD_NUMBER').and_return(42)
      Jenkins.build_number.should == 42
    end
  end

end
