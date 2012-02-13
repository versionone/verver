require 'verver/loader/api2'
require 'verver/loader/asset'

describe Verver::Loader::API2 do

  subject { Verver::Loader::API2.new }

  it "can build a path to query meta for an asset by one of its attribute values" do
    subject.send(:build_query_for, :chicken, {'Name' => 'Foghorn'}).should == "/Chicken?where=Name='Foghorn'"
  end

  it "can build a path to post a new asset" do
    subject.send(:build_post_for, :member).should == '/Member'
  end

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
    it "posts to the webserver" do
      pending('tbd')
      # operation = FindOrCreateOperation.new(:member) do |f|
      #   f.attributes(
      # end
    end
  end

end
