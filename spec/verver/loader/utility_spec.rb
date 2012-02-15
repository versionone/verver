require 'verver/loader'

describe Verver::Loader::Utility do

  subject do
    Class.new do
      extend Verver::Loader::Utility
    end
  end

  context "#meta_friendly_name" do

    it "converts :blah to Blah" do
      subject.meta_friendly_name(:blah).should == 'Blah'
    end

    it "converts :blah_blah to BlahBlah" do
      subject.meta_friendly_name(:blah_blah).should == 'BlahBlah'
    end

    it "converts BlahBlah to BlahBlah" do
      subject.meta_friendly_name('BlahBlah').should == 'BlahBlah'
    end

    it "converts :Blah_BlahBLAHBLAHblah_blah_yourmom to BlahBlahBLAHBLAHblahBlahYourmom" do
      subject.meta_friendly_name(:Blah_BlahBLAHBLAHblah_blah_yourmom).should == 'BlahBlahBLAHBLAHblahBlahYourmom'
    end

  end

  context "#ruby_friendly_name" do

    it "converts meta style strings to ruby friendly names" do
      subject.ruby_friendly_name("StoryState").should == "story_state"
    end

    it "will leave already-ruby friendly names alone" do
      subject.ruby_friendly_name("chicken_butts").should == "chicken_butts"
    end

    it "converts single words in title case properly" do
      subject.ruby_friendly_name("Bob").should == "bob"
    end

  end

end