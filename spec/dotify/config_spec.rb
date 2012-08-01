require 'spec_helper'

module Dotify
  describe Config do

    describe Config, "#load_config!" do
      it "should not raise a TypeError if the .dotrc file is empty (this is a problem with Psych not liking loading empty files)" do
        c = Config.dup
        def c.file; Config.home(".fake-dotrc"); end
        system "mkdir -p #{c.home}"
        system "touch #{c.home(".fake-dotrc")}"
        expect { c.get }.not_to raise_error TypeError
      end
      context "dot tests" do
        before do
          Config.instance_variable_set("@hash", nil)
          File.stub(:exists?).with(Config.file).and_return true
        end
        it "should return an empty hash" do
          YAML.stub(:load_file).with(Config.file).and_return({})
          Config.get.should == {}
        end
        it "should catch the TypeError and return an empty hash" do
          YAML.stub(:load_file).with(Config.file).and_raise(TypeError)
          Config.get.should == {}
        end
        it "should return an empty hash if the config file does not exist" do
          File.stub(:exists?).with(Config.file).and_return false
          Config.get.should == {}
        end
        it "should return an the hash returned by YAML#load_file" do
          YAML.stub(:load_file).and_return({ :test => 'example' })
          Config.get.should == { :test => 'example' }
        end
        it "should symbolize the keys returned" do
          YAML.stub(:load_file).and_return({ 'test' => 'example' })
          Config.get.should == { :test => 'example' }
        end
        it "should return an empty hash if YAML#load_file returns false (commented out config in .dotrc)" do
          YAML.stub(:load_file).with(Config.file).and_return false
          Config.get.should == {}
        end
        it "should only try to set config from the config file once" do
          YAML.should_receive(:load_file).with(Config.file).once.and_return({ 'test' => 'example' })
          5.times { Config.get }
        end
      end
    end

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
      let(:c) { Config.dup }
      before do
        def c.get
          { :ignore => { :dotfiles => %w[.gemrc], :dotify => %w[.gitmodule] } }
        end
      end
      it "should set a default editor" do
        c.editor.should == c::DEFAULTS[:editor]
      end
      it "should allow a custom editor" do
        def c.get
          { :editor => 'subl' }
        end
        c.editor.should == 'subl'
      end
    end

    describe Config, "#file" do
      it "should return the right page" do
        Config.file.should == '/tmp/home/.dotrc'
      end
    end

    describe "ignore files" do
      let(:c) { Config.dup }
      before do
        def c.get
          { :ignore => { :dotfiles => %w[.gemrc], :dotify => %w[.gitmodule] } }
        end
      end
      it "should have a default set of dotfiles" do
        def c.get; {}; end
        c.ignore(:dotify).should include '.git'
        c.ignore(:dotify).should include '.gitmodule'
        c.ignore(:dotfiles).should include '.dropbox'
        c.ignore(:dotfiles).should include '.Trash'
        c.ignore(:dotfiles).should include '.dotify'
      end
      it "should get the list of dotfiles to ignore in the home directory" do
        c.ignore(:dotfiles).should include '.gemrc'
      end
      it "should get the list of dotify files to ignore" do
        c.ignore(:dotify).should include '.gitmodule'
      end
    end
  end
end
