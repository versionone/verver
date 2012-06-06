require 'verver/loader/api'
require 'verver/loader/dsl'

describe Verver::Loader::API do

  subject { Verver::Loader::API.new }

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

  context "after creating a member" do

    before(:all) do

      api = Verver::Loader::API.new

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

      subject.stub(:lookup) { Verver::Loader::Asset.new('Asset:42', {}, {}) }

      VCR.use_cassette('create-member', :match_requests_on => [:uri, :body, :headers]) do
        @created_asset = subject.create(operation)
      end

    end

    it "looks up the newly created member" do
      @created_asset.oid.should == 'Asset:42'
    end

  end

  context "when looking up multiple members" do

    before(:all) do
      VCR.use_cassette('multiple-members-found', :match_requests_on => [:uri, :body, :headers] ) do
        @members = subject.lookup_all(:member, 'Nickname', 'bob')
      end
    end

    it "should return multiple results" do
      @members.count.should == 3
    end

    it "should only contain assets" do
      @members.each { |member| member.should be_an_instance_of(Verver::Loader::Asset) }
    end

  end
end
