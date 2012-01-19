require 'verver/jenkins'

describe Verver::Jenkins do

  describe ".job_name" do
    it "defaults to 'local-job'" do
      ENV.stub(:[]).with('JOB_NAME').and_return(nil)
      Verver::Jenkins.job_name.should == 'local-job'
    end

    it "is overridden by JOB_NAME ENV variable" do
      ENV.stub(:[]).with('JOB_NAME').and_return('bob-job')
      Verver::Jenkins.job_name.should == 'bob-job'
    end
  end

  describe ".build_number" do
    it "defaults to 0" do
      ENV.stub(:[]).with('BUILD_NUMBER').and_return(nil)
      Verver::Jenkins.build_number.should == 0
    end

    it "is overridden by BUILD_NUMBER ENV variable" do
      ENV.stub(:[]).with('BUILD_NUMBER').and_return(42)
      Verver::Jenkins.build_number.should == 42
    end
  end

end
