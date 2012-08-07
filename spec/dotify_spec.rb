require 'spec_helper'

describe Dotify do
  it "#installed? should be a shortcut method to Config#installed?" do
    Dotify::Config.stub(:installed?).and_return true
    Dotify.installed?.should be_true
    Dotify::Config.stub(:installed?).and_return false
    Dotify.installed?.should be_false
  end

  it "version is a shortcut method to Dotify::VERSION" do
    Dotify::Version.build.should_receive(:level)
    Dotify.version
  end

  it "version is a shortcut method to Dotify::VERSION" do
    Dotify.collection.should be_instance_of Dotify::Collection
  end
end
