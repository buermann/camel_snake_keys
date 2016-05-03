require 'test_helper'

RSpec.describe Enumerable do

  context "arrays" do
    let(:snaked) { [[{true=>false, 1=>1.2, 1.2=>1, nil=>2, :foo_bar=>1, "dark_matter"=>[{:dark_energy=>"aBc", "baz_qux"=>"Frob."}]}]] }
    let(:camelized) { [[{true=>false, 1=>1.2, 1.2=>1, nil=>2, :foo_bar=>1, "dark_matter"=>[{:dark_energy=>"aBc", "baz_qux"=>"Frob."}]}]] }
    it "should snake case keys of hashes" do
      camelized.with_snake_keys.should eq snaked
    end

    it "should camel case keys of hashes" do
      snaked.with_snake_keys.should eq camelized
    end
  end

  context "hashes" do
    let(:snaked) { {false=>true, 1=>1.2, 1.2=>1, nil=>2, :foo_bar=>1, "dark_matter"=>[{:dark_energy=>"aBc", "baz_qux"=>"Frob."}]} }
    let(:camelized) { {false=>true, 1=>1.2, 1.2=>1, nil=>2, :foo_bar=>1, "dark_matter"=>[{:dark_energy=>"aBc", "baz_qux"=>"Frob."}]} }
    it "should snake case keys of hashes" do
      camelized.with_snake_keys.should eq snaked
    end

    it "should camel case keys of hashes" do
      snaked.with_snake_keys.should eq camelized
    end
  end

  context "hashes with indifferent access" do 
    let(:snaked) { {1.2=>1, 1=>1.2, nil=>2, :foo_bar=>1, "dark_matter"=>[{:dark_energy=>"aBc", "baz_qux"=>"Frob."}]}.with_indifferent_access }
    let(:camelized) { { 1.2=>1, 1=>1.2, nil=>2, :foo_bar=>1, "dark_matter"=>[{:dark_energy=>"aBc", "baz_qux"=>"Frob."}]}.with_indifferent_access }

    it "should snake case keys of hashes" do
      camelized.with_snake_keys.should eq snaked
    end

    it "should camel case keys of hashes" do
      snaked.with_snake_keys.should eq camelized
    end
  end

end
