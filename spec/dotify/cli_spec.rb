require 'spec_helper'
require 'dotify/cli'

describe Dotify::CLI do

  let(:cli) { Dotify::CLI }
  let(:dotify_path) { Dotify::Config.path }

  before do
    Dotify::Config.stub(:config_file) { "#{here}/spec/fixtures/.dotifyrc-default" }
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

end
