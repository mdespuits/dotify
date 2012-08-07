require 'spec_helper'

module Psych
  class SyntaxError < ::SyntaxError
    def initialize(*args)
      # do nothing. This is for testing
    end
  end
end

module Dotify
  describe Config do
    subject { Config }
    describe "defaults" do
      before { subject.stub(:get).and_return({}) }
      its(:home) { should == Thor::Util.user_home }
      its(:path) { should == '/tmp/home/.dotify' }
      its(:file) { should == '/tmp/home/.dotify/.dotrc' }
      its(:editor) { should == 'vim' }
    end

    describe "#load_config!" do
      it "should not raise a TypeError if the .dotrc file is empty (this is a problem with Psych not liking loading empty files)" do
        c = Config.dup
        def c.file; Config.path(".fake-dotrc"); end
        system "mkdir -p #{c.path}"
        system "touch #{c.path(".fake-dotrc")}"
        expect { c.get }.not_to raise_error TypeError
      end
      context "dot tests" do
        before do
          subject.instance_variable_set('@hash', nil)
          File.stub(:exists?).with(Config.file).and_return true
        end
        it "#loader should not return false" do
          File.stub(:exists?).and_return true
          YAML.stub(:load_file).and_return false
          Config.loader(Config.file).should == {}
        end
        it "should return an empty hash" do
          Config.stub(:loader).with(Config.file).and_return({})
          Config.get.should == {}
        end
        it "should catch the TypeError and return an empty hash" do
          YAML.stub(:load_file).with(Config.file).and_raise(TypeError)
          Config.get.should == {}
        end
        it "should catch the Psych::SyntaxError and return an empty hash" do
          null = double.as_null_object
          YAML.stub(:load_file).with(Config.file) { raise ::Psych::SyntaxError.new(null, null, null, null, null, null) }
          Config.get.should == {}
        end
        it "should return an empty hash if the config file does not exist" do
          File.stub(:exists?).with(Config.file).and_return false
          YAML.stub(:load_file).with(Config.file).and_raise({})
          Config.get.should == {}
        end
        it "should return an the hash returned by YAML#load_file" do
          Config.stub(:loader).with(Config.file).and_return({:test => 'example'})
          Config.get.should == { :test => 'example' }
        end
        it "should symbolize the keys returned" do
          Config.stub(:loader).with(Config.file).and_return({'test' => 'example'})
          Config.get.should == { :test => 'example' }
        end
        it "should only try to set config from the config file once" do
          Config.stub(:loader).with(Config.file).and_return({})
          5.times { Config.get }
        end
      end
    end

    describe "installation check" do
      context "when Dotify has been setup" do
        before do
          File.should_receive(:exists?).with(Config.path).and_return(true)
          File.should_receive(:directory?).with(Config.path).and_return(true)
        end
        its(:installed?) { should be_true }
      end
      context "when Dotify has not been setup" do
        before do
          File.should_receive(:exists?).with(Config.path).and_return(true)
          File.should_receive(:directory?).with(Config.path).and_return(false)
        end
        its(:installed?) { should be_false }
      end
    end

    describe "file paths" do
      it "should return the home directory with appended path" do
        Config.home(".vimrc").should == '/tmp/home/.vimrc'
      end
      it "should be able to show the dotify path" do
        Config.path('.vimrc').should == '/tmp/home/.dotify/.vimrc'
      end
    end

    describe "setting a custom editor" do
      subject { Config.dup }
      before do
        def subject.get
          { :editor => 'subl' }
        end
      end
      its(:editor) { should == 'subl' }
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
