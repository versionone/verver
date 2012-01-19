require 'verver/jenkins'

describe Verver::Jenkins do
  let(:jenkins) { Verver::Jenkins }

  describe ".job_name" do
    let(:stub_job_name) { ENV.stub(:[]).with('JOB_NAME') }

    it "defaults to 'local-job'" do
      stub_job_name.and_return(nil)
      jenkins.job_name.should == 'local-job'
    end

    it "is overridden by JOB_NAME ENV variable" do
      stub_job_name.and_return('bob-job')
      jenkins.job_name.should == 'bob-job'
    end
  end

  describe ".build_number" do
    let(:stub_build_number) { ENV.stub(:[]).with('BUILD_NUMBER') }

    it "defaults to 0" do
      stub_build_number.and_return(nil)
      jenkins.build_number.should == 0
    end

    it "is overridden by BUILD_NUMBER ENV variable" do
      stub_build_number.and_return(42)
      jenkins.build_number.should == 42
    end
  end

end
