require 'verver/loader'

describe Verver::Loader::FindOrCreateOperation do

  context "when rendered" do
    subject do
      op = Verver::Loader::FindOrCreateOperation.new :asset do |op|

      end
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
  end

  context "specifying relations"
  context "specifying mvrs"

end
