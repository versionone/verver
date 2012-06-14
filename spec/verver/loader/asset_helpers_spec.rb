require 'verver/loader'
require 'vcr'

describe "Finding an epic" do

  class Epic < Verver::Loader::Asset
    include Verver::Loader::AssetHelpers

  end

  context "when trying to find one by name" do
    before do
      VCR.use_cassette('epic-find-by-name-test', :match_requests_on => [:uri, :body, :headers]) do
        @epic = Epic.find_by_name "test"
      end
    end

    it "should return something" do
      @epic.should_not be_nil
    end

    it "should return an epic whose name is 'test'" do
      @epic.name.should == "test"
    end

    it "should return an Epic" do
      @epic.should be_instance_of Epic
    end
  end

  context "when trying to find multiples by name" do
    before do
      VCR.use_cassette('epic-find-all-by-name-test', :match_requests_on => [:uri, :body, :headers]) do
        @epics = Epic.find_all_by_name "test"
      end
    end

    it "it should return something" do
      @epics.should have(2).epics
    end

    it "it should return an epic whose name is 'test'" do
      @epics.each { |e| e.name.should == "test" }
    end

    it "should return an Epic" do
      @epics.each { |e| e.should be_instance_of Epic }
    end
  end

  context "when trying to create an asset" do
    before do
      VCR.use_cassette('simple_create_an_epic', :match_requests_on => [:uri, :body, :headers]) do
        @epic = Epic.create({name: 'test_4', scope: 'Scope:0'})
      end
    end

    it "should have an oid" do
      @epic.oid.should_not be_empty
    end

    it "should have the correct name" do
      @epic.name.should == 'test_4'
    end

    it "should return an Epic" do
      @epic.should be_instance_of Epic
    end
  end

end

describe "Creating a member using the helpers" do

  class Member < Verver::Loader::Asset
    include Verver::Loader::AssetHelpers

    def self.create_simple(name, email=nil, create_login = true)
      attrs = {
          name: name,
          nickname: name,
          email: email,
          notify_via_email: true,
          default_role: "Role:1",
          scopes: "Scope:1041"
      }

      attrs.merge!({username: name, password: name}) if create_login
      create(attrs)
    end
  end

  context "doing a simple create" do

    before do
      VCR.use_cassette('create-member-2', :match_requests_on => [:uri, :body, :headers]) do
        @member = Member.create_simple("Bobby")
      end
    end

    it "should have the correct name" do
      @member.name.should == "Bobby"
    end

  end


end