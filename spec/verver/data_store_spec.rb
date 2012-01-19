require 'verver/data_store'

describe Verver::DataStore do

  describe ".server" do
    let(:data_store) { Verver::DataStore }
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

end
