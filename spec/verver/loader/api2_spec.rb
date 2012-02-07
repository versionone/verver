require 'verver/loader/api2'

describe Verver::Loader::API2 do

  subject { Verver::Loader::API2 }

  #let(:expected_app_url) { "#{Verver::Loader::Config.app_url.sub(/\/$/, '')}/rest-1.v1/Data" }

  #its(:ancestors) { should include(HTTParty) }
  #its(:base_uri) { should eql(expected_app_url) }

  # GET and POST come as part of including HTTParty
  # but thought it might be helpful to specify our
  # basic public interfaces

  context "looking up assets" do

    subject { Verver::Loader::API2.new() }

    before do
      # subject.stub(:get).and_return('Called Get')

    end

    it "returns members" do

      VCR.use_cassette('member-lookup', :match_requests_on => [:uri, :body, :headers] ) do
        member = subject.lookup(:member, 'ID', 'Scope:32')
      end

      #member.class.name.should == 'Asset'

    end

  end

end