require 'verver/instance'

describe Verver::Instance do
  describe "options for a new instance" do
    let(:options) { Hash.new }
    let(:instance) { Verver::Instance.new(options) }
    before do
      Verver::Jenkins.stub(job_name: 'Bobs-Job', build_number: 42)
    end

    describe "#name" do
      it "defaults to Jenkins job name and build number" do
        instance.name.should == "Bobs-Job_42"
      end

      it "can be overridden" do
        options[:name] = 'Alices_old_thing'
        instance.name.should == 'Alices_old_thing'
      end
    end

    describe "#path" do
      it 'defaults to C:\inetpub\wwwroot\ + instance name' do
        instance.path.should == 'C:\inetpub\wwwroot\Bobs-Job_42'
      end

      it "can be overridden" do
        options[:path] = 'D:\the_internets\are\here\my-instance'
        instance.path.should == 'D:\the_internets\are\here\my-instance'
      end
    end

    describe "#database_name" do
      it "defaults to #name" do
        instance.database_name.should == instance.name
      end

      it "can be overridden" do
        options[:database_name] = 'the-dater-base'
        instance.database_name.should == 'the-dater-base'
      end
    end

    describe "#database_server" do
      it "defaults to (local)" do
        instance.database_server.should == "(local)"
      end

      it "can be overridden" do
        options[:database_server] = "server_of_data"
        instance.database_server.should == "server_of_data"
      end
    end

    describe "#installer" do
      it "defaults to the first VersionOne.Setup*.exe it finds in the working directory" do
        installer = 'VersionOne.Setup-FooBar-12.3.4.5678.exe'
        transient_file(File.join(Verver.root, installer)) do
          instance.installer.should be_end_with(installer)
        end
      end

      it "can be overridden" do
        options[:installer] = "~/install_it.exe"
        instance.installer.should == "~/install_it.exe"
      end
    end

    describe "#license" do
      it "defaults to the first license it finds in the working directory" do
        license = File.join(Verver.root, 'VersionOne.Dev.lic')
        transient_file(license) do
          instance.license.should == license
        end
      end

      it "can be overridden" do
        options[:license] = "~/licenses/bob.lic"
        instance.license.should == "~/licenses/bob.lic"
      end
    end

  end

  describe "#install!" do
    let(:instance) { Verver::Instance.new }
    let(:installer_cmd) { 'VersionOne-Setup.exe -quiet -DBServer=(local) -WebDir=C:\inetpub\wwwroot\Bobs-Job_42 Bobs-Job_42' }
    let(:success) { true }

    it "shells out to the installer" do
      instance.stub(installer: "VersionOne-Setup.exe", name: "Bobs-Job_42")
      instance.should_receive(:system).with(installer_cmd) { success }

      instance.install!
    end

    it "copies the license file after successful install" do
      instance.stub(:system) { success }
      instance.stub(:license) { "some/path/Bob.lic" }
      instance.stub(:path) { "instance/path" }
      FileUtils.should_receive(:copy).with("some/path/Bob.lic", "instance/path/bin")

      instance.install!
    end

    it "does not copy the file when install fails" do
      instance.stub(:system) { not success }
      instance.stub(:license) { "some/path/Bob.lic" }
      FileUtils.should_not_receive(:copy)

      instance.install!
    end
  end

  describe "#uninstall!" do
    let(:instance) { Verver::Instance.new }
    let(:uninstaller_cmd) { 'VersionOne-Setup.exe -U -quiet -DeleteDatabase Bobs-Job_42' }

    it "shells out to the uninstaller" do
      instance.stub(installer: "VersionOne-Setup.exe", name: "Bobs-Job_42")
      instance.should_receive(:system).with(uninstaller_cmd)
      instance.uninstall!
    end
  end
end
