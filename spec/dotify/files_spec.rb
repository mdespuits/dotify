require 'spec_helper'
require 'dotify/files'
require 'fileutils'

describe Dotify::Files do
  before do
    Fake.tearup
    Dotify::Files.stub(:path) { Fake.root_path }
    Dotify::Files.stub(:dotify_path) { Fake.dotify_path }
  end
  after do
    Fake.teardown
  end
  it "should respond to the right methods" do
    Dotify::Files.should respond_to :dots
    Dotify::Files.should respond_to :installed
    Dotify::Files.should respond_to :templates
  end

  it "should split a file_name correct" do
    Dotify::Files.file_name("some/random/path/to/file.txt").should == 'file.txt'
    Dotify::Files.file_name("another/path/no_extension").should == 'no_extension'
  end

  describe Dotify::Files, "#dots" do
    it "should return the list of dotfiles in the dotify path" do
      files = Dotify::Files.dots.map { |f| Dotify::Files.file_name(f) }
      files.should include '.vimrc'
      files.should include '.bashrc'
      files.should include '.zshrc'
      files.should_not include '.' # current and upper directories
      files.should_not include '..'
    end
    it "shoud yield the files if a block is given" do
      files = Dotify::Files.dots
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
      installed = Dotify::Files.installed
      expect { |b| Dotify::Files.installed(&b) }.to yield_successive_args(*installed)
    end
  end

  describe Dotify::Files, "#installed" do
    it "should return the list of templates in the dotify directory" do
      templates = Dotify::Files.templates.map { |i| Dotify::Files.file_name(i) }
      templates.should include '.irbrc.erb'
      templates.should include '.fake.erb'
      templates.should_not include '.zshrc'
    end
    it "should yield the templates in the dotify directory" do
      templates = Dotify::Files.templates
      expect { |b| Dotify::Files.templates(&b) }.to yield_successive_args(*templates)
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
      Dotify::Files.template?("erbit.txt").should == false
      Dotify::Files.template?("/Users/fake/path/to/testing.txt").should == false
      Dotify::Files.template?("/Users/another/fake/path/to/testing.rb").should == false
    end
  end

  describe Dotify::Files, "#link_dotfile" do
    it "should receive a file and link it into the root path" do
      Dotify::Files.link_dotfile(Dotify::Files.dots.first)
      installed = Dotify::Files.installed.map { |i| Dotify::Files.file_name(i) }
      installed.count.should == 1
      installed.should include Dotify::Files.file_name(Dotify::Files.dots.first)
    end
  end

  describe Dotify::Files, "#unlink_dotfile" do
    it "should receive a file and remove it from the root" do
      Dotify::Files.link_dotfile(Dotify::Files.dots.first)
      dotfile_path = File.join(Dotify::Files.send(:path), \
                            Dotify::Files.file_name(Dotify::Files.dots.first))
      Dotify::Files.installed.should include dotfile_path
      Dotify::Files.unlink_dotfile Dotify::Files.dots.first
      Dotify::Files.installed.should_not include dotfile_path
    end
  end
end
