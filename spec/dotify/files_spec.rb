require 'spec_helper'
require 'dotify/files'
require 'fileutils'

describe Dotify::Files do
  before do
    Fake.tearup
    Dotify::Files.stub(:path) { Fake.root_path }
  end
  after do
    Fake.teardown
  end
  it "should respond to the right methods" do
    Dotify::Files.should respond_to :dots
    Dotify::Files.should respond_to :installed
    Dotify::Files.should respond_to :templates
  end

  it "should return the list of dotfiles in the dotify path" do
    files = Dotify::Files.dots.map { |f| Dotify::Files.file_name(f) }
    files.should include '.vimrc'
    files.should include '.bashrc'
    files.should include '.zshrc'
    files.should_not include '.' # current and upper directories
    files.should_not include '..'
  end

  it "should return the list of installed dotfiles in the root path" do
    fake_root, dotify = Fake.paths
    FileUtils.touch File.join(fake_root, '.vimrc')
    FileUtils.touch File.join(fake_root, '.bashrc')
    installed = Dotify::Files.installed.map { |i| Dotify::Files.file_name(i) }
    installed.should include '.vimrc'
    installed.should include '.bashrc'
    installed.should_not include '.zshrc'
  end

  it "should return the list of templates in the dotify directory" do
    templates = Dotify::Files.templates.map { |i| Dotify::Files.file_name(i) }
    templates.should include '.irbrc.erb'
    templates.should include '.fake.erb'
    templates.should_not include '.zshrc'
  end
end
