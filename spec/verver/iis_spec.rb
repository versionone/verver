require 'verver/iis'

describe Verver::IIS do
  describe ".ensure_iis_management_scripting_tools_installed!" do
    let(:components) { stub("Verver::IIS::Components") }

    it "returns true when installed" do
      components.stub(:installed?).with(:management_scripting_tools) { true }
      Verver::IIS.ensure_management_scripting_tools_installed!(components).should == true
    end

    it "fails when not installed" do
      components.stub(:installed?).with(:management_scripting_tools) { false }

      expect { Verver::IIS.ensure_management_scripting_tools_installed!(components) }.
        to raise_error(Verver::IIS::ComponentNotInstalled)
    end

  end
end
