require 'verver/document'

describe Verver::Document do

  describe "interpolating a template" do
    it "returns empty when the template is empty" do
      File.stub(:read).with('some/template.erb').and_return('')
      Verver::Document.new('some/template.erb').interpolate().should be_empty
    end

    context "template has content" do
      it "returns the content when there is no embedded ruby" do
        content = "Hello, Bob!"
        File.stub(:read).with('some/template.erb').and_return(content)
        Verver::Document.new('some/template.erb').interpolate().should == content
      end
    end
  end
end
