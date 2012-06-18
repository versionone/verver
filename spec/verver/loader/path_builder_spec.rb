require('verver/loader/path_builder')

describe Verver::Loader::PathBuilder do

  it "should fail" do
    subject.search_path(:epic_status, {:where=>{'Name'=>'donedonedone'}}).should == "/EpicStatus?where=Name%3D%27donedonedone%27"
  end

  it "can build a path to query meta for an asset by one of its attribute values" do
    subject.search_path(:chicken, {:where=>{'Name' => 'Foghorn'}}).should == "/Chicken?where=Name%3D%27Foghorn%27"
  end

  it "will URL escape queries" do
    subject.search_path(:"folk musician", {:where=>{'Name' => 'Yim Yames'}}).should == "/Folk%20musician?where=Name%3D%27Yim+Yames%27"
  end

  it "can build a path to post a new asset" do
    subject.create_path(:member).should == '/Member'
  end


end