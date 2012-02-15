require 'verver/loader/api2'
require 'verver/loader/dsl'

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

    before(:all) do

      api = Verver::Loader::API2.new

      operation = Verver::Loader::FindOrCreateOperation.new(:member) do |o|
        o.attributes do |a|
          a.name 'bobname'
          a.username 'bobuid'
          a.nickname 'bobnick'
          a.password 'bobpwd'
        end
        o.relations do |r|
          r.default_role 'Role:1'
        end
      end

      VCR.use_cassette('create-member', :match_requests_on => [:uri, :body, :headers]) do
        @created_asset = subject.create(operation)
      end

    end

    it "maps the member to an asset" do
      @created_asset.should be_an_instance_of(Verver::Loader::Asset)
    end

  end

end
