require 'verver/loader'

describe Verver::Loader::Utility do

  subject do
    Class.new do
      extend Verver::Loader::Utility
    end
  end

  it "converts ruby style symbols to meta friendly names" do
    subject.meta_friendly_name(:story_state).should == "StoryState"
  end

  context "when converting to ruby-friendly names" do

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