require 'verver/document'

describe Verver::Document do

  describe "#interpolate" do
    let(:document) { Verver::Document.new('some/template.erb') }
    let(:stub_file_read) { File.stub(:read).with('some/template.erb') }

    it "returns empty when the template is empty" do
      stub_file_read.and_return('')
      document.interpolate().should be_empty
    end

    context "template has content" do
      it "returns the content as-is when there is no embedded ruby" do
        content = "Hello, Bob!"
        stub_file_read.and_return(content)
        document.interpolate(:name => 'Alice').should == content
      end

      it "replaces the embedded ruby with given params" do
        stub_file_read.and_return("Hello, <%= name %>!")
        document.interpolate(:name => 'Bob').should == "Hello, Bob!"
      end
    end
  end
end
