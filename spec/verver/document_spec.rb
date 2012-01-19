require 'verver/document'

describe Verver::Document do

  describe "interpolating a template" do
    let(:document) { Verver::Document.new('some/template.erb') }
    let(:stub_file_read) { File.stub(:read).with('some/template.erb') }

    it "returns empty when the template is empty" do
      stub_file_read.and_return('')
      document.interpolate().should be_empty
    end

    context "template has content" do
      it "returns the content when there is no embedded ruby" do
        content = "Hello, Bob!"
        stub_file_read.and_return(content)
        document.interpolate().should == content
      end
    end
  end
end
