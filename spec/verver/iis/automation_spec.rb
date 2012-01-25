require 'verver/iis/automation'

describe Verver::IIS::Automation do
  let(:win32ole_fake) { stub("WIN32OLE") }
  let(:iis_automation) { stub("WIN32OLE - WebAdministration") }

  describe "a new IIS Automation" do
    it "attaches to the IIS Automation object" do
      win32ole_fake.should_receive(:connect).
        with(Verver::IIS::Automation::ADMIN_MONIKER) { iis_automation }

      Verver::IIS::Automation.new(win32ole_fake)
    end
  end

  describe "using an IIS Automation" do
    it "passes messages onto the Win32ole-based IIS Administration object" do
      win32ole_fake.stub(:connect) { iis_automation }
      iis_automation.should_receive(:get).with("SomeKey='MyValue'")

      Verver::IIS::Automation.new(win32ole_fake).get("SomeKey='MyValue'")
    end

  end
end

