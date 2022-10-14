require 'test_helper'
require 'byebug'
require 'hashie/mash'
require 'active_support/core_ext/hash/indifferent_access'

using CamelSnakeKeys

RSpec.describe Enumerable do
  context 'arrays' do
    let(:snaked) do
      [[{ true => false, 1 => 1.2, 1.2 => 1, nil => 2, :foo_bar => 1,
          'dark_matter' => [{ :dark_energy => 'aBc', 'baz_qux' => 'Frob.' }] }]]
    end
    let(:camelized) do
      [[{ true => false, 1 => 1.2, 1.2 => 1, nil => 2, :fooBar => 1,
          'darkMatter' => [{ :darkEnergy => 'aBc', 'bazQux' => 'Frob.' }] }]]
    end

    it 'should snake case keys of hashes' do
      camelized.with_snake_keys.should eq snaked
    end

    it 'should camel case keys of hashes' do
      snaked.with_camel_keys.should eq camelized
    end
  end

  context 'hashes' do
    let(:snaked) do
      { false => true, 1 => 1.2, 1.2 => 1, nil => 2, :foo_bar => 1,
        'dark_matter' => [{ :dark_energy => 'aBc', 'baz_qux' => 'Frob.' }] }
    end
    let(:camelized) do
      { false => true, 1 => 1.2, 1.2 => 1, nil => 2, :fooBar => 1,
        'darkMatter' => [{ :darkEnergy => 'aBc', 'bazQux' => 'Frob.' }] }
    end

    it 'should snake case keys of hashes' do
      hash = camelized.with_snake_keys
      hash.class.should eq Hash
      hash.should eq snaked
    end

    it 'should camel case keys of hashes' do
      hash = snaked.with_camel_keys
      hash.class.should eq Hash
      hash.should eq camelized
    end

    it 'should preserve symbol keys' do
      camelized.with_snake_keys[:foo_bar].should_not be_nil
      camelized.with_snake_keys['foo_bar'].should be_nil
      snaked.with_camel_keys[:fooBar].should be_present
      snaked.with_camel_keys['fooBar'].should be_nil
    end

    it 'should preserve string keys' do
      camelized.with_snake_keys['dark_matter'].should be_present
      camelized.with_snake_keys[:dark_matter].should be_nil
      snaked.with_camel_keys['darkMatter'].should be_present
      snaked.with_camel_keys[:darkMatter].should be_nil
    end

    it 'should snake case keys of hashes with indifference' do
      hash = camelized.with_indifferent_access.with_snake_keys
      hash.class.should eq HashWithIndifferentAccess
      hash.should eq snaked.with_indifferent_access
      hash[:foo_bar].should eq hash['foo_bar']
    end

    it 'should camel case keys of hashes with indifference' do
      hash = snaked.with_indifferent_access.with_camel_keys
      hash.class.should eq HashWithIndifferentAccess
      hash.should eq camelized.with_indifferent_access
      hash['fooBar'].should eq hash[:fooBar]
    end
  end

  context 'hashes with indifferent access' do
    let(:snaked) do
      { 1.2 => 1, 1 => 1.2, nil => 2, :foo_bar => 1,
        'dark_matter' => [{ :dark_energy => 'aBc', 'baz_qux' => 'Frob.' }] }.with_indifferent_access
    end
    let(:camelized) do
      { 1.2 => 1, 1 => 1.2, nil => 2, :fooBar => 1,
        'darkMatter' => [{ :darkEnergy => 'aBc', 'bazQux' => 'Frob.' }] }.with_indifferent_access
    end

    it 'should snake case keys of hashes' do
      hash = camelized.with_snake_keys
      hash.class.should eq HashWithIndifferentAccess
      hash.should eq snaked
    end

    it 'should camel case keys of hashes' do
      hash = snaked.with_camel_keys
      hash.class.should eq HashWithIndifferentAccess
      hash.should eq camelized
    end

    it 'should snake case keys of hashes with indifference' do
      hash = camelized.with_indifferent_access.with_snake_keys
      hash.class.should eq HashWithIndifferentAccess
      hash.should eq snaked
    end

    it 'should camel case keys of hashes with indifference' do
      hash = snaked.with_indifferent_access.with_camel_keys
      hash.class.should eq HashWithIndifferentAccess
      hash.should eq camelized
    end
  end

  context 'mashes' do
    let(:snaked) do
      Hashie::Mash.new({ 1.2 => 1, 1 => 1.2, nil => 2, :foo_bar => 1,
                         'dark_matter' => [{ :dark_energy => 'aBc', 'baz_qux' => 'Frob.' }] })
    end
    let(:camelized) do
      Hashie::Mash.new({ 1.2 => 1, 1 => 1.2, nil => 2, :fooBar => 1,
                         'darkMatter' => [{ :darkEnergy => 'aBc', 'bazQux' => 'Frob.' }] })
    end

    it 'should snake case keys of hashes' do
      hash = camelized.with_snake_keys
      hash.class.should eq Hashie::Mash
      hash.should eq snaked
      hash['fooBar'].should eq hash[:fooBar]
    end

    it 'should camel case keys of hashes' do
      hash = snaked.with_camel_keys
      hash.class.should eq Hashie::Mash
      hash.should eq camelized
      hash['foo_bar'].should eq hash[:foo_bar]
    end

    it 'should snake case keys of hashes with redundant indifference' do
      hash = Hashie::Mash.new(camelized.with_snake_keys.with_indifferent_access)
      hash.class.should eq Hashie::Mash
      hash.should eq snaked
      hash['foo_bar'].should eq hash[:foo_bar]
    end

    it 'should camel case keys of hashes with redundant indifference' do
      hash = Hashie::Mash.new(snaked.with_camel_keys.with_indifferent_access)
      hash.class.should eq Hashie::Mash
      hash.should eq camelized
      hash['foo_bar'].should eq hash[:foo_bar]
    end
  end

  context 'hash merge conflicts should be resolved predictably' do
    it 'should give camel case key values priority when snake casing' do
      hash   = { foo_bar: 1, fooBar: 2 }
      result = { foo_bar: 2 }
      hash.with_snake_keys.should eq result

      hash = { fooBar: 2, foo_bar: 1 }
      hash.with_snake_keys.should eq result
    end

    it 'should give snake case key values priority when camel casing' do
      result = { fooBar: 1 }

      hash   = { foo_bar: 1, fooBar: 2 }
      hash.with_camel_keys.should eq result

      hash = { fooBar: 2, foo_bar: 1 }
      hash.with_camel_keys.should eq result
    end
  end

  context 'it should pass indifference down deeply nested structures' do
    it 'camelizing an array of hashes' do
      camelized = [a: { b: [{ c: :d }] }].with_camel_keys.map(&:with_indifferent_access)
      camelized.first[:a].is_a?(HashWithIndifferentAccess).should be_truthy
      camelized.first[:a][:b].first.is_a?(HashWithIndifferentAccess).should be_truthy
    end

    it 'cazemlizing a hashes of arrays' do
      camelized = { a: [{ b: { c: :d } }] }.with_camel_keys.with_indifferent_access
      camelized.is_a?(HashWithIndifferentAccess).should be_truthy
      camelized[:a].first[:b].is_a?(HashWithIndifferentAccess).should be_truthy
    end

    it 'snaking an array of hashes' do
      snaked = [a: { b: [{ c: :d }] }].with_snake_keys.map(&:with_indifferent_access)
      snaked.first[:a].is_a?(HashWithIndifferentAccess).should be_truthy
      snaked.first[:a][:b].first.is_a?(HashWithIndifferentAccess).should be_truthy
    end

    it 'snaking a hashes of arrays' do
      snaked = { a: [{ b: { c: :d } }] }.with_snake_keys.with_indifferent_access
      snaked.is_a?(HashWithIndifferentAccess).should be_truthy
      snaked[:a].first[:b].is_a?(HashWithIndifferentAccess).should be_truthy
    end
  end
end
