require 'spec_helper'
require 'dotify/errors'
require 'dotify/configuration'

describe Dotify::Configuration do
  let(:here) { %x{pwd}.chomp }
  describe "setters" do
    it "should be able to set the current shell (not actually yet used)" do
      Dotify::Configuration.shell = :zsh
      Dotify::Configuration.shell.should == :zsh
      Dotify::Configuration.shell = :bash
      Dotify::Configuration.shell.should == :bash
    end
    it "should raise an error if the shell specified does not exist" do
      expect { Dotify::Configuration.shell = :fake }.to raise_error Dotify::NonValidShell
    end
    it "should be able to set the current profile name (not actually yet used)" do
      Dotify::Configuration.profile = :james
      Dotify::Configuration.profile.should == 'james'
    end
    it "should be able to set the directory name to store .dotify files" do
      Dotify::Configuration.directory.should == '.dotify'
      Dotify::Configuration.directory = '.dotify2'
      Dotify::Configuration.directory.should == '.dotify2'
      Dotify::Configuration.directory = '.dotify' # for resetting in other tests
    end
    it "should be able to show the dotify path" do
      Dotify::Configuration.stub(:home) { '/Users/dotify-test' }
      Dotify::Configuration.directory = '.dotify'
      Dotify::Configuration.path.should == '/Users/dotify-test/.dotify'
    end
    it "should be able to show the dotify backup path" do
      Dotify::Configuration.stub(:home) { '/Users/dotify-test' }
      Dotify::Configuration.directory = '.dotify'
      Dotify::Configuration.backup.should == '/Users/dotify-test/.dotify/.backup'
    end
    it "should be able to customize the backup path" do
      Dotify::Configuration.backup_dirname = '.backup2'
      Dotify::Configuration.stub(:path) { '/Users/dotify-test/.dotify' }
      Dotify::Configuration.backup_dirname = '.backup2'
      Dotify::Configuration.backup.should == '/Users/dotify-test/.dotify/.backup2'
      Dotify::Configuration.backup_dirname = '.backup' # resetting settings
    end
  end
  describe "configuration files" do
    it "should load the config file" do
      Dotify::Configuration.stub(:config_file) { "#{here}/spec/fixtures/.dotifyrc-mattbridges" }
      config = Dotify::Configuration.load_config_file!
      config['shell'].should == :zsh
      config['profile'].should == 'mattdbridges'
    end
  end
end
