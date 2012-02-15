require('verver/loader/path_builder')

describe Verver::Loader::PathBuilder do

  it "can build a path to query meta for an asset by one of its attribute values" do
     subject.search_path(:chicken, {'Name' => 'Foghorn'}).should == "/Chicken?where=Name='Foghorn'"
   end

   it "can build a path to post a new asset" do
     subject.create_path(:member).should == '/Member'
   end

   it "can build a path to retrieve an asset by oid" do
     subject.item_path(:member, 'Member:20').should == '/Member/20'
   end

end