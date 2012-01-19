require 'verver/data_store'
require 'verver/jenkins'

describe Verver::DataStore do
  let(:data_store) { Verver::DataStore }

  describe ".server" do
    let(:stub_server) { ENV.stub(:[]).with('SQL_SERVER') }

    it "defaults to '.'" do
      stub_server.and_return(nil)
      data_store.server.should == '.'
    end

    it "is overridden by SQL_SERVER ENV variable" do
      stub_server.and_return('BobsServerName')
      data_store.server.should == 'BobsServerName'
    end
  end

  describe ".db_name" do
    it "is the Jenkins job name + build number" do
      Verver::Jenkins.stub(:job_name) { "BobsJob" }
      Verver::Jenkins.stub(:build_number) { 42 }
      data_store.db_name.should == "BobsJob_42"
    end
  end

end
