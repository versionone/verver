require 'verver/loader/api2'
#require 'verver/loader/config'

describe Verver::Loader::API2 do

  subject { Verver::Loader::API2 }

  its(:ancestors) { should include(HTTParty) }
  its(:base_uri) { should eql(Verver::Loader::Config.app_url.sub(/\/$/,'')) }

  # GET and POST come as part of including HTTParty
  # but thought it might be helpful to specify our
  # basic public interfaces

  it "should respond to get" do
    subject.respond_to?(:get).should be_true
  end

  it "should respond to post" do
    subject.respond_to?(:post).should be_true
  end

end