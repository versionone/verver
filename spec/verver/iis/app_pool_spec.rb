require 'verver/iis/app_pool'

describe Verver::IIS::AppPool do
  let(:iis_automation) { stub("WIN32OLE - WebAdministration") }

  describe "A new AppPool" do
    it "is tied to the named pool" do
      iis_automation.should_receive(:get).with("ApplicationPool.Name='Bob\'s Pool'")
      Verver::IIS::AppPool.new("Bob's Pool", iis_automation)
    end
  end

  describe "using an AppPool" do
    let(:app_pool) { stub("WIN32OLE - AppPool") }
    it "passes messages onto the Win32ole-based IIS Administration object" do
      iis_automation.stub(:get) { app_pool }
      app_pool.stub(:ole_respond_to?) { true }
      app_pool.should_receive(:start)

      Verver::IIS::AppPool.new("Bob's Pool", iis_automation).start
    end
  end
end

