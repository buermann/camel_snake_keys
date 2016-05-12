require 'test_helper'
require 'hashie/mash'

RSpec.describe Enumerable do

  context "arrays" do
    let(:snaked) { [[{true=>false, 1=>1.2, 1.2=>1, nil=>2, :foo_bar=>1, "dark_matter"=>[{:dark_energy=>"aBc", "baz_qux"=>"Frob."}]}]] }
    let(:camelized) { [[{true=>false, 1=>1.2, 1.2=>1, nil=>2, :fooBar=>1, "darkMatter"=>[{:darkEnergy=>"aBc", "bazQux"=>"Frob."}]}]] }

    it "should snake case keys of hashes" do
      camelized.with_snake_keys.should eq snaked
    end

    it "should camel case keys of hashes" do
      snaked.with_camel_keys.should eq camelized
    end

  end

  context "hashes" do
    let(:snaked) { {false=>true, 1=>1.2, 1.2=>1, nil=>2, :foo_bar=>1, "dark_matter"=>[{:dark_energy=>"aBc", "baz_qux"=>"Frob."}]} }
    let(:camelized) { {false=>true, 1=>1.2, 1.2=>1, nil=>2, :fooBar=>1, "darkMatter"=>[{:darkEnergy=>"aBc", "bazQux"=>"Frob."}]} }

    it "should snake case keys of hashes" do
      hash = camelized.with_snake_keys
      hash.class.should == Hash
      hash.should eq snaked
    end

    it "should camel case keys of hashes" do
      hash = snaked.with_camel_keys
      hash.class.should == Hash
      hash.should eq camelized
    end

    it "should preserve symbol keys" do 
      camelized.with_snake_keys[:foo_bar].should_not be_nil
      camelized.with_snake_keys['foo_bar'].should be_nil
      snaked.with_camel_keys[:fooBar].should be_present
      snaked.with_camel_keys['fooBar'].should be_nil
    end

    it "should preserve string keys" do 
      camelized.with_snake_keys['dark_matter'].should be_present
      camelized.with_snake_keys[:dark_matter].should be_nil
      snaked.with_camel_keys['darkMatter'].should be_present
      snaked.with_camel_keys[:darkMatter].should be_nil
    end

    it "should snake case keys of hashes with indifference" do
      hash = camelized.with_snake_keys(true)
      hash.class.should == HashWithIndifferentAccess
      hash.should eq snaked.with_indifferent_access
      hash[:foo_bar].should eq hash["foo_bar"]
    end

    it "should camel case keys of hashes with indifference" do
      hash = snaked.with_camel_keys(true)
      hash.class.should == HashWithIndifferentAccess
      hash.should eq camelized.with_indifferent_access
      hash["fooBar"].should eq hash[:fooBar]
    end

  end

  context "hashes with indifferent access" do 
    let(:snaked) { {1.2=>1, 1=>1.2, nil=>2, :foo_bar=>1, "dark_matter"=>[{:dark_energy=>"aBc", "baz_qux"=>"Frob."}]}.with_indifferent_access }
    let(:camelized) { { 1.2=>1, 1=>1.2, nil=>2, :fooBar=>1, "darkMatter"=>[{:darkEnergy=>"aBc", "bazQux"=>"Frob."}]}.with_indifferent_access }

    it "should snake case keys of hashes" do
      hash = camelized.with_snake_keys
      hash.class.should == HashWithIndifferentAccess
      hash.should eq snaked
    end

    it "should camel case keys of hashes" do
      hash = snaked.with_camel_keys
      hash.class.should == HashWithIndifferentAccess
      hash.should eq camelized
    end

    it "should snake case keys of hashes with indifference" do
      hash = camelized.with_snake_keys(true)
      hash.class.should == HashWithIndifferentAccess
      hash.should eq snaked
    end

    it "should camel case keys of hashes with indifference" do
      hash = snaked.with_camel_keys(true)
      hash.class.should == HashWithIndifferentAccess
      hash.should eq camelized
    end

  end

  context "mashes" do 
    let(:snaked) { Hashie::Mash.new({1.2=>1, 1=>1.2, nil=>2, :foo_bar=>1, "dark_matter"=>[{:dark_energy=>"aBc", "baz_qux"=>"Frob."}]}) }
    let(:camelized) { Hashie::Mash.new({ 1.2=>1, 1=>1.2, nil=>2, :fooBar=>1, "darkMatter"=>[{:darkEnergy=>"aBc", "bazQux"=>"Frob."}]}) }

    it "should snake case keys of hashes" do
      hash = camelized.with_snake_keys
      hash.class.should == Hashie::Mash
      hash.should eq snaked
      hash["fooBar"].should == hash[:fooBar]
    end

    it "should camel case keys of hashes" do
      hash = snaked.with_camel_keys
      hash.class.should == Hashie::Mash
      hash.should eq camelized
      hash["foo_bar"].should == hash[:foo_bar]
    end
 
    it "should snake case keys of hashes with redundant indifference" do
      hash = camelized.with_snake_keys(true)
      hash.class.should == Hashie::Mash
      hash.should eq snaked
      hash["foo_bar"].should == hash[:foo_bar]
    end

    it "should camel case keys of hashes with redundant indifference" do
      hash = snaked.with_camel_keys(true)
      hash.class.should == Hashie::Mash
      hash.should eq camelized
      hash["foo_bar"].should == hash[:foo_bar]
    end
 
  end

end
