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
end

