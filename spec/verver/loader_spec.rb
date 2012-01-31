require 'verver/loader'

describe Verver::Loader::FindOrCreateOperation do

  context "when rendered" do
    subject do
      op = Verver::Loader::FindOrCreateOperation.new(:asset) { |op| }
      op.render
    end
    its([:data]) { should include('Attribute') }
    its([:data]) { should include('Relation') }
    its([:data]) { should include('MVR') }
  end

  context "looking up an existing asset" do
    subject do
      Verver::Loader::FindOrCreateOperation.new :an_asset do |op|
        op.lookup :title, 'fizz buzz'
      end
    end
    its('attribute_name') { should eql('Title') }
    its('attribute_value') { should eql('fizz buzz') }
  end

  context "attributes" do
    subject do
      order = Verver::Loader::FindOrCreateOperation.new :an_asset do |op|
        op.attributes do |a|
          a.first_name 'bob'
        end
      end
      order.render[:data]['Attribute'][0]
    end

    it { should include('name') }
    it { should include('content') }
    it { should include('act') }

    its(['name']) { should eql('FirstName') } # TODO: make API responsible for translating case
    its(['content']) { should eql('bob') }
    its(['act']) { should eql('set') } # TODO: API should set this key/value

    context "when the lookup attribute is specified in the attributes collection" do
      subject do
        order = Verver::Loader::FindOrCreateOperation.new :an_asset do |op|
          op.lookup :title, 'foo'
          op.attributes do |a|
            a.title 'bar'
          end
        end
        order.render[:data]['Attribute'][0]
      end

      it "the lookup attribute value wins" do
        subject['content'].should eql('foo')
      end
    end
  end

  context "relations" do
    context "via string oids" do

      subject do
        order = Verver::Loader::FindOrCreateOperation.new :an_asset do |op|
          op.relations do |r|
            r.default_role 'Role:100'
          end
        end
        order.render[:data]['Relation'][0]
      end

      it "name should be 'DefaultRole'" do
        subject['name'].should eql('DefaultRole')
      end

      it "should contain a single asset, 'Role:100'" do
        subject['Asset'][0]["idref"].should eql('Role:100')
      end

      it "should contain an act key with the value set" do
        subject['act'].should eql('set')
      end

    end

    context "via Asset objects" do

      subject do

        asset = double("Asset")
        asset.stub(:oid) { 'Role:200' }

        order = Verver::Loader::FindOrCreateOperation.new :an_asset do |op|
          op.relations do |r|
            r.default_role asset
          end
        end

        order.render[:data]['Relation'][0]

      end

      it "should contain a single asset, 'Role:200'" do
        subject['Asset'][0]["idref"].should eql('Role:200')
      end

    end

  end

  context "mvrs" do
    context "of one asset" do
      subject do
        asset1 = double("Asset")
        asset1.stub(:oid) { 'Role:200' }

        order = Verver::Loader::FindOrCreateOperation.new :an_asset do |op|
          op.mvrs do |m|
            m.children asset1
          end
        end

        order.render[:data]['MVR'][0]
      end

      its(['name']) {should include("Children")}

      it "should contain a single asset" do
        subject['Asset'].should
      end

      it "the asset should have an oid 'Role:200'" do

      end

      it "the asset should have the add action" do

      end

    end
    context "of multiple assets" do

    end
  end

end
