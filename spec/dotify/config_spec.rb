require 'spec_helper'
require 'dotify/errors'
require 'dotify/config'

describe Dotify::Config do
  let(:here) { %x{pwd}.chomp }
  describe "setters" do
    before do
      Fake.tearup
      Dotify::Config.stub(:config_file) { "#{here}/spec/fixtures/.dotifyrc-default" }
      Dotify::Config.stub(:home) { Fake.root_path }
      Dotify::Config.load_config!
      Dotify::Config.directory = '.dotify'
      Dotify::Config.backup_dirname = '.backup'
    end
    after do
      Fake.teardown
    end
    it "should be able to set the current shell (not actually yet used)" do
      Dotify::Config.shell = :zsh
      Dotify::Config.shell.should == :zsh
      Dotify::Config.shell = :bash
      Dotify::Config.shell.should == :bash
    end
    it "should raise an error if the shell specified does not exist" do
      expect { Dotify::Config.shell = :fake }.to raise_error Dotify::NonValidShell
    end
    it "should be able to set the current profile name (not actually yet used)" do
      Dotify::Config.profile = :james
      Dotify::Config.profile.should == 'james'
    end
    it "should be able to show the dotify path" do
      Dotify::Config.path.should == File.join(Dotify::Config.home, '.dotify')
    end
    it "should be able to set the directory name to store .dotify files" do
      Dotify::Config.directory = '.dotify2'
      Dotify::Config.directory.should == '.dotify2'
      Dotify::Config.path.should == File.join(Dotify::Config.home, '.dotify2')
    end
    it "should be able to show the dotify backup path" do
      Dotify::Config.backup.should == File.join(Dotify::Config.path, '.backup')
    end
    it "should be able to customize the backup path" do
      Dotify::Config.backup_dirname = '.backup2'
      Dotify::Config.backup.should == File.join(Dotify::Config.path, '.backup2')
    end
  end
  describe "config files" do
    before do
      Dotify::Config.stub(:config_file) { "#{here}/spec/fixtures/.dotifyrc-mattbridges" }
      Dotify::Config.load_config!
    end
    it "should load the config file" do
      config = Dotify::Config.config
      config[:shell].should == :zsh
      config[:profile].should == 'mattdbridges'
    end
    it "should load the config and set the variables" do
      Dotify::Config.profile.should == 'mattdbridges'
      Dotify::Config.shell.should == :zsh
    end
  end
end
