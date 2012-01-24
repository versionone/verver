require 'verver/iis/app_pool'

describe Verver::IIS::AppPool do
  describe "A new AppPool" do
    let(:iis_automation) { stub("WIN32OLE - WebAdministration") }

    it "is tied to the named pool" do
      iis_automation.should_receive(:get).with("ApplicationPool.Name='Bob\'s Pool'")
      app_pool = Verver::IIS::AppPool.new("Bob's Pool", iis_automation)
      #app_pool.name.should == "Bob's Pool"
    end
  end
end

