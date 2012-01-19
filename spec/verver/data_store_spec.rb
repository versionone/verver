require 'verver/data_store'
require 'verver/jenkins'

describe Verver::DataStore do
  let(:data_store) { Verver::DataStore }

  describe ".server" do
    let(:stub_server) { ENV.stub(:[]).with('DB_SERVER') }

    it "defaults to '.'" do
      stub_server.and_return(nil)
      data_store.server.should == '.'
    end

    it "is overridden by DB_SERVER ENV variable" do
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

  describe ".user" do
    let(:stub_user) { ENV.stub(:[]).with('DB_SERVER_USER')}

    it "defaults to 'pub'" do
      stub_user.and_return(nil)
      data_store.user.should == 'pub'
    end

    it "is overridden by DB_SERVER_USER ENV variable" do
      stub_user.and_return('corp\bob')
      data_store.user.should == 'corp\bob'
    end
  end

  describe ".create_sql" do
    let(:lib_root) { File.join(File.expand_path("../../..", __FILE__), 'lib') }
    let(:create_file) { File.join(lib_root, %w[verver support create_db.sql]) }

    it "is the path to support/create_db.sql" do
      data_store.create_sql.should == create_file
    end

    specify { File.exists?(create_file).should be_true }
  end

end
