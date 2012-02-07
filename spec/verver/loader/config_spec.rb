require "verver/loader/config"

describe Verver::Loader::Config do

  subject { Verver::Loader::Config }

  context "when environment variables are not specified" do

    it "Config#app_url should equal the default 'http://localhost/VersionOne.Web'" do
      subject.app_url.should eql('http://localhost/VersionOne.Web')
    end

    it "Config#login should equal the default 'admin'" do
      subject.login.should eql('admin')
    end

    it "Config#password should equal the default 'admin'" do
      subject.password.should eql('admin')
    end

  end

  context "when a complete set of environment variables are available" do

    before do
      ENV['APP_URL'] = "http://testsite.com/app"
      ENV['LOGIN'] = "bob"
      ENV['PASSWORD'] = "passw0rd"
    end

    it "Config#app_url reads the APP_URL environment variable" do
      subject.app_url.should eql('http://testsite.com/app')
    end

    it "Config#login reads the LOGIN environment variable" do
      subject.login.should eql('bob')
    end

    it "Config#app_url reads the PASSWORD environment variable" do
      subject.password.should eql('passw0rd')
    end

    describe "when specifying an app_url with a trailing slash" do
      it "removes the trailing slash" do
        ENV['APP_URL'] = "http://alltheslashes/"
        subject.app_url.should eql("http://alltheslashes")
      end
    end

  end

end