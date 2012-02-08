require 'verver/loader/api2'

describe Verver::Loader::API2 do

  subject { Verver::Loader::API2 }

  context "looking up assets" do

    subject { Verver::Loader::API2.new() }

    it "returns members" do

      VCR.use_cassette('member-lookup', :match_requests_on => [:uri, :body, :headers] ) do
        member = subject.lookup(:member, 'ID', 'Scope:32')
      end

    end

  end

end