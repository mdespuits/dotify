require 'spec_helper'
require 'dotify/errors'
require 'dotify/config'

describe Dotify::Config do
  let(:fixtures) { File.join(%x{pwd}.chomp, 'spec/fixtures') }
  before do
    Fake.tearup
    Dotify::Config.stub(:home) { Fake.root_path }
    Dotify::Config.stub(:config_file) { File.join(fixtures, '.dotrc-default') }
    Dotify::Config.load_config!
  end
  after do
    Fake.teardown
  end
  describe "setters" do
    it "should be able to set the current shell (not actually yet used)" do
      Dotify::Config.shell = 'zsh'
      Dotify::Config.shell.should == 'zsh'
      Dotify::Config.shell = 'bash'
      Dotify::Config.shell.should == 'bash'
    end
    it "should raise an error if the shell specified does not exist" do
      expect { Dotify::Config.shell = 'fake' }.to raise_error Dotify::NonValidShell
    end
    it "should be able to set the current profile name (not actually yet used)" do
      Dotify::Config.profile = 'james'
      Dotify::Config.profile.should == 'james'
    end
    it "should be able to show the dotify path" do
      Dotify::Config.path.should == File.join(Dotify::Config.home, '.dotify')
    end
    it "should be able to show the dotify backup path" do
      Dotify::Config.backup.should == File.join(Dotify::Config.path, '.backup')
    end
  end
  describe "config files" do
    before do
      Dotify::Config.stub(:home) { Fake.root_path }
      Dotify::Config.stub(:config_file) { File.join(fixtures, '.dotrc-mattbridges') }
    end
    it "should not try to assign improper config values" do
      Dotify::Config.should_receive(:profile=)
      Dotify::Config.should_receive(:shell=)
      Dotify::Config.should_not_receive(:something_fake=)
      Dotify::Config.load_config!
    end
    it "should load the config and set the variables" do
      Dotify::Config.load_config!
      Dotify::Config.profile.should == 'mattdbridges'
      Dotify::Config.shell.should == 'zsh'
    end
  end
end
