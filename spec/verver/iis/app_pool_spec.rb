require 'rspec-spies'
require 'verver/iis/app_pool'

describe Verver::IIS::AppPool do
  let(:iis_automation) { stub("WIN32OLE - WebAdministration") }
  let(:app_pool_wrapper) { stub("WIN32OLE - AppPool") }
  before do
    iis_automation.stub(:get) { app_pool_wrapper }
    app_pool_wrapper.stub(:ole_respond_to?) { true }
  end

  let!(:app_pool) { Verver::IIS::AppPool.new("Bob's Pool", iis_automation) }

  it "is tied to the named pool" do
    iis_automation.should have_received(:get).with("ApplicationPool.Name='Bob\'s Pool'")
  end

  it "passes messages onto the Win32ole-based IIS Administration object" do
    app_pool_wrapper.should_receive(:start)
    app_pool.start
  end

  describe "checking status" do
    it "is starting when state = 0" do
      app_pool_wrapper.stub(:getstate) { 0 }
      app_pool.should be_starting
    end

    it "is started when state = 1" do
      app_pool_wrapper.stub(:getstate) { 1 }
      app_pool.should be_started
    end

    it "is stopping when state = 2" do
      app_pool_wrapper.stub(:getstate) { 2 }
      app_pool.should be_stopping
    end

    it "is stopped when state = 3" do
      app_pool_wrapper.stub(:getstate) { 3 }
      app_pool.should be_stopped
    end

    it "is unknown when state = 4" do
      app_pool_wrapper.stub(:getstate) { 4 }
      app_pool.should be_unknown
    end
  end
end

