require 'verver/iis'

describe "A wee little iisreset wrapper" do

  let (:system_call) { double() }

  subject do
    Verver::IIS.new(system_call)
  end

  it "resets!" do
    system_call.should_receive(:call).with('iisreset')
    subject.reset
  end

  it "stops!" do
    system_call.should_receive(:call).with('iisreset /stop')
    subject.stop
  end

  it "starts!" do
    system_call.should_receive(:call).with('iisreset /start')
    subject.start
  end

end
