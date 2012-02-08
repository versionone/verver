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

  it "converts meta style symbols to ruby friendly names" do
    subject.ruby_friendly_name("StoryState").should == "story_state"
  end

end