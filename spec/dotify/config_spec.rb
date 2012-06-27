require 'spec_helper'
require 'dotify/errors'
require 'dotify/config'

describe Dotify::Config do
  before do
    Fake.tearup
    Dotify::Config.stub(:user_home) { Fake.root_path }
  end
  after do
    Fake.teardown
  end
  describe "options" do
    it "should be able to show the home path" do
      Dotify::Config.home.should == Thor::Util.user_home
    end
    it "should be able to show the dotify path" do
      Dotify::Config.path.should == File.join(Dotify::Config.home, '.dotify')
    end
  end
  describe "ignoring files" do
    before do
      Dotify::Config.stub(:config)  do
        { :ignore => { :dotfiles => %w[.gemrc], :dotify => %w[.gitmodule] } }
      end
    end
    it "should retrieve the list of dotfiles to ignore in the home directory" do
      Dotify::Config.ignoring(:dotfiles).should include '.gemrc'
    end
    it "should retrieve the list of dotify files to ignore" do
      Dotify::Config.ignoring(:dotify).should include '.gitmodule'
    end
  end
end
