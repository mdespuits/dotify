require 'spec_helper'
require 'dotify/files'
require 'fileutils'

describe Dotify::Files do
  let(:fixtures) { File.join(%x{pwd}.chomp, 'spec/fixtures') }
  before do
    Fake.tearup
    #Dotify::Config.stub(:config_file) { File.join(fixtures, '.dotrc-default') }
    Dotify::Config.stub(:home) { Fake.root_path }
    Dotify::Config.load_config!
  end
  after do
    Fake.teardown
  end
  it "should respond to the right methods" do
    Dotify::Files.should respond_to :dots
    Dotify::Files.should respond_to :installed
  end

  it "should split a file_name correct" do
    Dotify::Files.file_name("some/random/path/to/file.txt").should == 'file.txt'
    Dotify::Files.file_name("another/path/no_extension").should == 'no_extension'
  end

  describe Dotify::Files, "#dotfile" do
    it "should return the path to the file when it is linked in the root" do
      Dotify::Files.dotfile(".vimrc").should == File.join(Dotify::Config.home, ".vimrc")
      Dotify::Files.dotfile("/spec/home/.bashrc").should == File.join(Dotify::Config.home, ".bashrc")
    end
  end

  describe Dotify::Files, "#dotify" do
    it "should return the path to the file when it is linked in the root" do
      Dotify::Files.dotify(".vimrc").should == File.join(Dotify::Config.path, ".vimrc")
      Dotify::Files.dotify("/spec/home/.bashrc").should == File.join(Dotify::Config.path, ".bashrc")
    end
  end

  describe Dotify::Files, "#dots" do
    before do
      Dotify::Files.stub(:file_list) do
        ['/spec/test/.vimrc', '/spec/test/.bashrc', '/spec/test/.zshrc']
      end
    end
    it "should return the list of dotfiles in the dotify path" do
      files = Dotify::Files.dots.map { |f| Dotify::Files.file_name(f) }
      files.should include '.vimrc'
      files.should include '.bashrc'
      files.should include '.zshrc'
      files.should_not include '.' # current and upper directories
      files.should_not include '..'
    end
    it "shoud yield the files if a block is given" do
      files = Dotify::Files.dots.map { |d| [d, Dotify::Files.file_name(d)] }
      expect { |b| Dotify::Files.dots(&b) }.to yield_successive_args(*files)
    end
  end

  describe Dotify::Files, "#installed" do
    before do
      fake_root, dotify = Fake.paths
      FileUtils.touch File.join(fake_root, '.vimrc')
      FileUtils.touch File.join(fake_root, '.bashrc')
    end
    it "should return the list of installed dotfiles in the root path" do
      installed = Dotify::Files.installed.map { |i| Dotify::Files.file_name(i) }
      installed.should include '.vimrc'
      installed.should include '.bashrc'
      installed.should_not include '.zshrc'
      installed.should_not include '.dotify'
    end
    it "shoud yield the installed files if a block is given" do
      installed = Dotify::Files.installed.map { |i| [i, Dotify::Files.file_name(i)] }
      expect { |b| Dotify::Files.installed(&b) }.to yield_successive_args(*installed)
    end
  end

  describe Dotify::Files, "#template?" do
    it "should return true if the string given is a .tt or .erb template" do
      Dotify::Files.template?("testing.erb").should == true
      Dotify::Files.template?("testing.tt").should == true
      Dotify::Files.template?("/Users/fake/path/to/testing.tt").should == true
      Dotify::Files.template?("/Users/another/fake/path/to/testing.erb").should == true
    end
    it "should return false if the string given is not a .tt or .erb template" do
      Dotify::Files.template?(".tt.testing").should == false
      Dotify::Files.template?("erbit.txt").should == false
      Dotify::Files.template?(".erb.erbit.txt").should == false
      Dotify::Files.template?("/Users/fake/path/to/testing.txt").should == false
      Dotify::Files.template?("/Users/another/fake/path/to/testing.rb").should == false
    end
  end

  describe Dotify::Files, "#link_dotfile" do
    it "should receive a file and link it into the root path" do
      first = File.join(Dotify::Config.path, ".vimrc")
      FileUtils.should_receive(:ln_s).with(Dotify::Files.file_name(first), Dotify::Config.home).once
      Dotify::Files.link_dotfile first
    end
  end

  describe Dotify::Files, "#unlink_dotfile" do
    it "should receive a file and remove it from the root" do
      first = "/spec/test/.file"
      FileUtils.stub(:rm_rf).with(File.join(Dotify::Config.home, Dotify::Files.file_name(first))).once
      Dotify::Files.unlink_dotfile first
      FileUtils.unstub(:rm_rf)
    end
  end
end
