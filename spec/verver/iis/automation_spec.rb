require 'verver/iis/automation'

describe Verver::IIS::Automation do
  describe "a new IIS Automation" do
    let(:win32ole) { stub("WIN32OLE") }
    let(:iis_automation) { stub("WIN32OLE - WebAdministration") }

    it "attaches to the IIS Automation object" do
      win32ole.should_receive(:connect).
        with(Verver::IIS::Automation::ADMIN_MONIKER) { iis_automation }

      Verver::IIS::Automation.new(win32ole)
    end

  end
end

