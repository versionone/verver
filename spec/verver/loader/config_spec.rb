require "verver/loader/config"

describe Verver::Loader::Config do

  context "when a complete set of environment variables are available" do

    subject { Verver::Loader::Config.new() }

    before do
      ENV['APP_URL'] = "http://testsite.com/app/"
      ENV['USERNAME'] = "bob"
      ENV['PASSWORD'] = "passw0rd"
    end

    it "Config#app_url reads the APP_URL environment variable" do
      subject.app_url.should eql('http://testsite.com/app/')
    end

    it "Config#username reads the USERNAME environment variable" do
      subject.username.should eql('bob')
    end

    it "Config#app_url reads the PASSWORD environment variable" do
      subject.password.should eql('passw0rd')
    end

  end

end