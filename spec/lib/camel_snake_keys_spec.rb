require 'test_helper'
require 'hashie/mash'

using CamelSnakeKeys

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
      hash.class.should eq Hash
      hash.should eq snaked
    end

    it "should camel case keys of hashes" do
      hash = snaked.with_camel_keys
      hash.class.should eq Hash
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
      hash.class.should eq HashWithIndifferentAccess
      hash.should eq snaked.with_indifferent_access
      hash[:foo_bar].should eq hash["foo_bar"]
    end

    it "should camel case keys of hashes with indifference" do
      hash = snaked.with_camel_keys(true)
      hash.class.should eq HashWithIndifferentAccess
      hash.should eq camelized.with_indifferent_access
      hash["fooBar"].should eq hash[:fooBar]
    end

  end

  context "hashes with indifferent access" do 
    let(:snaked) { {1.2=>1, 1=>1.2, nil=>2, :foo_bar=>1, "dark_matter"=>[{:dark_energy=>"aBc", "baz_qux"=>"Frob."}]}.with_indifferent_access }
    let(:camelized) { { 1.2=>1, 1=>1.2, nil=>2, :fooBar=>1, "darkMatter"=>[{:darkEnergy=>"aBc", "bazQux"=>"Frob."}]}.with_indifferent_access }

    it "should snake case keys of hashes" do
      hash = camelized.with_snake_keys
      hash.class.should eq HashWithIndifferentAccess
      hash.should eq snaked
    end

    it "should camel case keys of hashes" do
      hash = snaked.with_camel_keys
      hash.class.should eq HashWithIndifferentAccess
      hash.should eq camelized
    end

    it "should snake case keys of hashes with indifference" do
      hash = camelized.with_snake_keys(true)
      hash.class.should eq HashWithIndifferentAccess
      hash.should eq snaked
    end

    it "should camel case keys of hashes with indifference" do
      hash = snaked.with_camel_keys(true)
      hash.class.should eq HashWithIndifferentAccess
      hash.should eq camelized
    end

  end

  context "mashes" do 
    let(:snaked) { Hashie::Mash.new({1.2=>1, 1=>1.2, nil=>2, :foo_bar=>1, "dark_matter"=>[{:dark_energy=>"aBc", "baz_qux"=>"Frob."}]}) }
    let(:camelized) { Hashie::Mash.new({ 1.2=>1, 1=>1.2, nil=>2, :fooBar=>1, "darkMatter"=>[{:darkEnergy=>"aBc", "bazQux"=>"Frob."}]}) }

    it "should snake case keys of hashes" do
      hash = camelized.with_snake_keys
      hash.class.should eq Hashie::Mash
      hash.should eq snaked
      hash["fooBar"].should eq hash[:fooBar]
    end

    it "should camel case keys of hashes" do
      hash = snaked.with_camel_keys
      hash.class.should eq Hashie::Mash
      hash.should eq camelized
      hash["foo_bar"].should eq hash[:foo_bar]
    end
 
    it "should snake case keys of hashes with redundant indifference" do
      hash = camelized.with_snake_keys(true)
      hash.class.should eq Hashie::Mash
      hash.should eq snaked
      hash["foo_bar"].should eq hash[:foo_bar]
    end

    it "should camel case keys of hashes with redundant indifference" do
      hash = snaked.with_camel_keys(true)
      hash.class.should eq Hashie::Mash
      hash.should eq camelized
      hash["foo_bar"].should eq hash[:foo_bar]
    end
 
  end

  context "hash merge conflicts should be resolved predictably" do
    it "should give camel case key values priority when snake casing" do
      hash   = { foo_bar: 1, fooBar: 2 }
      result = { foo_bar: 2 }
      hash.with_snake_keys.should eq result

      hash = { fooBar: 2, foo_bar: 1 }
      hash.with_snake_keys.should eq result
    end

    it "should give snake case key values priority when camel casing" do
      hash   = { foo_bar: 1, fooBar: 2 }
      result = { fooBar: 1 }
      hash.with_camel_keys.should eq result

      hash = { fooBar: 2, foo_bar: 1 }
      hash.with_camel_keys.should eq result
    end
  end

  context "it should pass indifference down deeply nested structures" do
    it "camelizing an array of hashes" do
      camelized = [ a: { b: [{c: :d}] } ].with_camel_keys(true)
      camelized.first[:a].kind_of?(HashWithIndifferentAccess).should be_truthy
      camelized.first[:a][:b].first.kind_of?(HashWithIndifferentAccess).should be_truthy
    end

    it "cazemlizing a hashes of arrays" do
      camelized = { a: [{b: {c: :d}}]}.with_camel_keys(true)
      camelized.kind_of?(HashWithIndifferentAccess).should be_truthy
      camelized[:a].first[:b].kind_of?(HashWithIndifferentAccess).should be_truthy
    end

    it "snaking an array of hashes" do
      snaked = [ a: { b: [{c: :d}] } ].with_snake_keys(true)
      snaked.first[:a].kind_of?(HashWithIndifferentAccess).should be_truthy
      snaked.first[:a][:b].first.kind_of?(HashWithIndifferentAccess).should be_truthy
    end

    it "snaking a hashes of arrays" do
      snaked = { a: [{b: {c: :d}}]}.with_snake_keys(true)
      snaked.kind_of?(HashWithIndifferentAccess).should be_truthy
      snaked[:a].first[:b].kind_of?(HashWithIndifferentAccess).should be_truthy
    end

  end
end
