require 'spec_helper'
require 'verver/instance'

describe Verver::Instance do
  describe "defaults for a new instance" do
    let(:instance) { Verver::Instance.new }
    before do
      Verver::Jenkins.stub(job_name: 'Bobs-Job', build_number: 42)
    end

    it "#name is built from Jenkins job name and build number" do
      instance.name.should == "Bobs-Job_42"
    end

    it '#path is C:\inetpub\wwwroot\ + instance name' do
      instance.path.should == 'C:\inetpub\wwwroot\Bobs-Job_42'
    end

    it "#database_name is the same as name" do
      instance.database_name.should == instance.name
    end

    it "#database_server is (local)" do
      instance.database_server.should == "(local)"
    end

    it "#installer uses the first VersionOne.Setup*.exe it finds in the workding directory" do
      installer = 'VersionOne.Setup-FooBar-12.3.4.5678.exe'
      transient_file(File.join(Verver.root, installer)) do
        instance.installer.should be_end_with(installer)
      end
    end

    it "#license is the Dev license" do
      instance.license.should == "VersionOne.Dev.lic"
    end

  end

  describe "#install!" do
    let(:instance) { Verver::Instance.new }
    let(:installer_cmd) { 'VersionOne-Setup.exe -quiet -DBServer=(local) -WebDir=C:\inetpub\wwwroot\Bobs-Job_42 Bobs-Job_42' }

    it "shells out to the installer" do
      instance.stub(installer: "VersionOne-Setup.exe", name: "Bobs-Job_42")
      instance.should_receive(:system).with(installer_cmd) { 1 }

      instance.install!
    end
  end
end
