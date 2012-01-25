require 'verver'

describe Verver do

  describe ".root" do
    it "is the working directory when Verver was loaded" do
      bobs_app_path = "/Users/bob/some/other/dir/here"
      Verver.stub(:original_dir) { bobs_app_path }
      Verver.root.should == bobs_app_path
    end
  end
end
