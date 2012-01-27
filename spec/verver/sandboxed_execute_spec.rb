require 'verver/sandboxed_execute'

describe Verver::SandboxedExecute do
  class FakeApp
    extend Verver::SandboxedExecute
  end

  describe ".execute" do
    let(:instance) { stub("Instance") }
    let(:install_result) { true }
    before do
      FakeApp.stub(:new) { instance }
      instance.stub(:install!) { install_result }
      instance.stub(:uninstall!)
    end

    it "passes options on to the installable object" do
      options = stub
      FakeApp.should_receive(:new).with(options)
      FakeApp.execute(options) {}
    end

    it "runs install!" do
      instance.should_receive(:install!)
      FakeApp.execute {}
    end

    context "successful install" do
      it "runs the block" do
        safe_block = ->(inst) { }
        safe_block.should_receive(:call).with(instance)
        FakeApp.execute(nil, &safe_block)
      end

      it "runs uninstall! even when there is an error in the block" do
        instance.should_receive(:uninstall!)
        expect do
          FakeApp.execute { fail "Oh noes!" }
        end.to raise_error
      end
    end

    context "install fails" do
      let(:install_result) { false }

      it "does not run the block" do
        safe_block = ->(inst) { }
        safe_block.should_not_receive(:call)
        FakeApp.execute(nil, &safe_block)
      end

      it "does not run the uninstaller" do
        instance.should_not_receive(:uninstall!)
        FakeApp.execute {}
      end
    end

  end
end
