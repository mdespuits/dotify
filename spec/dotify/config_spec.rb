require 'spec_helper'

module Dotify
  describe Config do
    before {
      Config.unstub(:home)
      Thor::Util.stub(:user_home).and_return '/tmp/home'
    }
    describe Config, "#installed?" do
      it "should return true if Dotify has been setup" do
        File.should_receive(:exists?).with(Config.path).and_return(true)
        File.should_receive(:directory?).with(Config.path).and_return(true)
        Config.installed?.should == true
      end
      it "should return false if Dotify has not been setup" do
        File.should_receive(:exists?).with(Config.path).and_return(true)
        File.should_receive(:directory?).with(Config.path).and_return(false)
        Config.installed?.should == false
      end
    end

    describe Config, "#home" do
      it "should return the home directory when called without a filename" do
        Config.home.should == Thor::Util.user_home
      end
      it "should return the home directory with appended path" do
        Config.home(".vimrc").should == '/tmp/home/.vimrc'
      end
    end
    describe Config, "#path" do
      it "should be able to show the dotify path when not passed any arguments" do
        Config.path.should == '/tmp/home/.dotify'
      end
      it "should be able to show the dotify path" do
        Config.path('.vimrc').should == '/tmp/home/.dotify/.vimrc'
      end
    end

    describe "options" do
      before do
        Config.stub(:config)  do
          { :ignore => { :dotfiles => %w[.gemrc], :dotify => %w[.gitmodule] } }
        end
      end
      it "should set a default editor" do
        Config.editor.should == Config::EDITOR
      end
      it "should allow a custom editor" do
        Config.stub(:config)  do
          { :editor => 'subl' }
        end
        Config.editor.should == 'subl'
      end
    end

    describe Config, "#file" do
      it "should return the right page" do
        Config.file.should == '/tmp/home/.dotrc'
      end
    end

    describe "ignore files" do
      before do
        Config.stub(:config)  do
          { :ignore => { :dotfiles => %w[.gemrc], :dotify => %w[.gitmodule] } }
        end
      end
      it "should have a default set of dotfiles" do
        Config.stub(:config).and_return({})
        Config.ignore(:dotify).should include '.git'
        Config.ignore(:dotify).should include '.gitmodule'
        Config.ignore(:dotfiles).should include '.dropbox'
        Config.ignore(:dotfiles).should include '.Trash'
        Config.ignore(:dotfiles).should include '.dotify'
      end
      it "should retrieve the list of dotfiles to ignore in the home directory" do
        Config.ignore(:dotfiles).should include '.gemrc'
      end
      it "should retrieve the list of dotify files to ignore" do
        Config.ignore(:dotify).should include '.gitmodule'
      end
    end
  end
end
