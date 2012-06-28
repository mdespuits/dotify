require 'spec_helper'
require 'dotify/errors'
require 'dotify/config'

describe Dotify::Config do
  describe Dotify::Config, "#installed?" do
    it "should return false if Dotify has not been setup" do
      File.should_receive(:directory?).with(File.join(Dotify::Config.home, Dotify::Config.dirname)).and_return(false)
      Dotify::Config.installed?.should == false
    end
    it "should return true if Dotify has been setup" do
      File.should_receive(:directory?).with(File.join(Dotify::Config.home, Dotify::Config.dirname)).and_return(true)
      Dotify::Config.installed?.should == true
    end
  end
  describe "options" do
    it "should be able to show the home path" do
      Dotify::Config.home.should == Thor::Util.user_home
    end
    it "should be able to show the dotify path" do
      Dotify::Config.path.should == File.join(Dotify::Config.home, '.dotify')
    end
  end
  describe "ignore files" do
    before do
      Dotify::Config.stub(:config)  do
        { :ignore => { :dotfiles => %w[.gemrc], :dotify => %w[.gitmodule] } }
      end
    end
    it "should retrieve the list of dotfiles to ignore in the home directory" do
      Dotify::Config.ignore(:dotfiles).should include '.gemrc'
    end
    it "should retrieve the list of dotify files to ignore" do
      Dotify::Config.ignore(:dotify).should include '.gitmodule'
    end
  end
end
