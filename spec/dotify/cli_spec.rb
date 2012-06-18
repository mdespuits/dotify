require 'spec_helper'
require 'dotify/cli'

describe Dotify::CLI do

  let(:cli) { Dotify::CLI }
  let(:dotify_path) { cli::DOTIFY_PATH }

  before do
    FileUtils.mkdir_p dotify_path
  end

  after do
    FileUtils.rm_rf dotify_path
  end

  describe Dotify::CLI, "#setup" do
    it "it should create the right directory" do
      FileUtils.should_receive(:mkdir_p).with(dotify_path)
      cli.new.setup
    end
  end

  describe Dotify::CLI, "#dotfile_list" do
    let(:c) { cli.new }
    it "should pull the correct set of files" do
      list = c.dotfile_list
      list.count.should == 0
    end
  end

  describe Dotify::CLI, "#filename" do
    it "should return only the filename given a path" do
      c = cli.new
      c.filename("/Users/johndoe/filename").should == "filename"
      c.filename("/Users/johndoe/..").should == ".."
      c.filename("/Users/johndoe/.vimrc").should == ".vimrc"
    end
  end

  describe Dotify::CLI, "#template?" do
    it "should return true if the file ends in tt or erb" do
      c = cli.new
      c.template?("title.tt").should be_true
      c.template?("title.erb").should be_true
      c.template?("title.rb").should_not be_true
      c.template?("title.rb").should_not be_true
      c.template?("#{dotify_path}/title.rb").should_not be_true
      c.template?("#{dotify_path}/tt.rb").should_not be_true
      c.template?("#{dotify_path}/.vimrc.erb").should be_true
    end
  end

end
