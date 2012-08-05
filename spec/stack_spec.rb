#
# Author: Sean Nolen (<sean.m.nolen@gmail.com>)
# Copyright: (c) 2012 Sean Nolen
# License: Apache License, Version 2.0
#

require 'chef'
require 'chef/mixin/stack'
include Chef::Mixin::Stack


describe Chef::Mixin::Stack do

  before(:each) do
    @data_bag_item = Chef::DataBagItem.new
    @data_bag_item.data_bag("smegheads")
    @data_bag_item.raw_data = {"id" => "Lister", "name" => "Lister"}
    @rest = mock("Chef::REST")
    Chef::REST.stub!(:new).and_return(@rest)
  end

  describe "when there is an error" do

    it "tries to load specified data bags" do
      @rest.should_receive(:get_rest).with("data/smegheads/Lister").and_return(@data_bag_item.to_hash)
      data_bag_stack({"smegheads" => ["Lister"]})
    end

    it "returns error when no input is given" do
      lambda { data_bag_stack(Hash.new) }.should raise_error ArgumentError
    end

    it "returns error when input is not a hash" do
      [String, Array, Mash].each do |input|
        lambda { data_bag_stack(input.new) }.should raise_error ArgumentError
      end
    end

  end

  describe "when one data bag" do

    describe "when one item" do

      it "returns the same data bag item when only one is given as string" do
        @rest.should_receive(:get_rest).with("data/smegheads/Lister").and_return(@data_bag_item.to_hash)
        data_bag_stack({"smegheads" => "Lister"})["name"].should == "Lister"
      end
      it "returns the same data bag item when only one is given as array" do
        @rest.should_receive(:get_rest).with("data/smegheads/Lister").and_return(@data_bag_item.to_hash)
        data_bag_stack({"smegheads" => ["Lister"]})["name"].should == "Lister"
      end

    end #one-item

    describe "when two or more items" do

      before do
        @data_bag_item2 = Chef::DataBagItem.new
        @data_bag_item2.data_bag("smegheads")
        @data_bag_item2.raw_data = {"id" => "Rimmer", "name" => "Rimmer"}
      end

      it "returns the merged data bag item when two are given" do
        @rest.should_receive(:get_rest).with("data/smegheads/Lister").and_return(@data_bag_item.to_hash)
        @rest.should_receive(:get_rest).with("data/smegheads/Rimmer").and_return(@data_bag_item2.to_hash)
        data_bag_stack({"smegheads" => ["Lister","Rimmer"]})["name"].should == "Rimmer"
      end
    end #two-or-more-items
  end #one-bag

  describe "when multiple data bags" do
    before do
      @data_bag_item3 = Chef::DataBagItem.new
      @data_bag_item3.data_bag("computers")
      @data_bag_item3.raw_data = {"id" => "Holly", "name" => "Holly", "IQ" => 6000}
    end

    it "returns the merged data bag item when two are given and second is string" do
      @rest.should_receive(:get_rest).with("data/smegheads/Lister").and_return(@data_bag_item.to_hash)
      @rest.should_receive(:get_rest).with("data/computers/Holly").and_return(@data_bag_item3.to_hash)
      data_bag_stack({"smegheads" => ["Lister"], "computers" => "Holly"})["name"].should == "Holly"
    end
    it "returns the merged data bag item when two are given and second is array" do
      @rest.should_receive(:get_rest).with("data/smegheads/Lister").and_return(@data_bag_item.to_hash)
      @rest.should_receive(:get_rest).with("data/computers/Holly").and_return(@data_bag_item3.to_hash)
      out = data_bag_stack({"smegheads" => ["Lister"], "computers" => ["Holly"] })
      out["name"].should == "Holly"
      out["IQ"].should == 6000
    end


  end #multiple-bags

end
