require 'spec_helper'

describe Dotify do
  it "#installed? should be a shortcut method to Config#installed?" do
    Dotify::Config.stub(:installed?).and_return true
    Dotify.installed?.should == true
    Dotify::Config.stub(:installed?).and_return false
    Dotify.installed?.should == false
  end

  it "version is a shortcut method to Dotify::VERSION" do
    Dotify.version.should == Dotify::VERSION
  end

  it "version is a shortcut method to Dotify::VERSION" do
    Dotify.collection.should be_instance_of Dotify::Collection
  end
end
