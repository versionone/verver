require 'verver/loader/api2'
require 'verver/loader/asset'

describe Verver::Loader::API2 do

  subject { Verver::Loader::API2.new }

  context "when looking up the default 'administrator' member" do

    before(:all) do
      VCR.use_cassette('member-found', :match_requests_on => [:uri, :body, :headers] ) do
        @member = subject.lookup(:member, 'Name', 'Administrator')
      end
    end

    it "return a Verver::Loader::Asset" do
      @member.should be_an_instance_of(Verver::Loader::Asset)
    end

    it "the Asset should contain the attributes and values of administrator" do
      @member.asset_type.should == 'Member'
      @member.name.should == 'Administrator'
      @member.oid.should == "Member:20"
      @member.username.should == "admin"
    end

  end

  context "when looking up up a member that doesn't exist'" do

    before(:all) do
      VCR.use_cassette('member-not-found', :match_requests_on => [:uri, :body, :headers] ) do
        @member = subject.lookup(:member, 'Name', 'LeeroyJenkins')
      end
    end

    it "should be false" do
      @member.should be_false
    end

  end

  context "when creating a member" do

    it "posts to the webserver"

    context "after successfully creating a member" do

      it "will retrieve the member, returning an asset"

    end

  end

end
