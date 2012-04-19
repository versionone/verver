require 'verver/loader/asset'

describe Verver::Loader::Asset do

  subject do
    attributes = {rank: 'General', full_name: 'Robert E. Lee', favorite_ice_cream: 'chocolate'}
    Verver::Loader::Asset.new('Member:42:99', attributes)
  end

  describe '#oid' do
    it "removes the moment from the oid" do
      subject.oid.should == "Member:42"
    end
  end

  describe '#to_s' do
    it "returns the oid of the asset" do
      subject.to_s.should == subject.oid
    end
  end


  it "provides reader methods for attributes" do
    subject.rank.should == 'General'
    subject.full_name.should == 'Robert E. Lee'
    subject.favorite_ice_cream.should == 'chocolate'
  end

  describe "using an attribute hash with non-symbolic keys with mixed case" do

    subject do
      attributes = { 'one' => 1, "TwoThreeFour" => 234}
      Verver::Loader::Asset.new('Member:42:99', attributes)
    end

    it "will normalize the method names within ruby idiom" do
      subject.respond_to?(:one).should be_true
      subject.respond_to?(:two_three_four).should be_true
    end

  end

  describe "retrieving dotted attributes" do
    subject {Verver::Loader::Asset.new('Epic:42',{'scope.name' => 'System Project'}) }

    it "can be found through an indexer" do
      subject.fetch('scope.name').should == 'System Project'
    end
  end

end
