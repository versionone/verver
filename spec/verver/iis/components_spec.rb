require 'verver/iis/components'

describe Verver::IIS::Components do
  describe 'Management Scripts and Tools' do
    let(:hive) { stub("Win32::Registry::HKEY_LOCAL_MACHINE") }
    let(:registry) { stub("Registry") }
    let(:components) { Verver::IIS::Components.new(hive) }

    before do
      hive.stub(:open).with(Verver::IIS::Components::KEYNAME) { registry }
    end

    it "reports installed when their registry value is 1" do
      registry.stub(:[]).with("ManagementScriptingTools") { 1 }
      components.should be_installed(:management_scripting_tools)
    end

    it "reports not installed when their registry value is 0" do
      registry.stub(:[]).with("ManagementScriptingTools") { 0 }
      components.should_not be_installed(:management_scripting_tools)
    end
  end
end
