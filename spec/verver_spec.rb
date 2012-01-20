require 'verver'

describe Verver do

  describe ".root" do
    it "is the Rake application's dir" do
      bobs_app_path = "/Users/bob/some/other/dir/here"
      Rake.stub_chain(:application, :original_dir) { bobs_app_path }
      Verver.root.should == bobs_app_path
    end
  end
end
