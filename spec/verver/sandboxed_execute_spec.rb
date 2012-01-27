require 'verver/sandboxed_execute'

describe Verver::SandboxedExecute do
  class FakeApp
    extend Verver::SandboxedExecute
  end

  describe ".execute" do
    let(:instance) { stub("Instance") }
    before do
      FakeApp.stub(:new) { instance }
      instance.stub(:install!)
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

    it "runs the block if install! succeeds" do
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
end
