require 'spec_helper'
require 'dotify/cli'
require 'thor'

describe Dotify::CLI do

  let(:fixtures) { File.join(%x{pwd}.chomp, 'spec/fixtures') }
  let(:cli) { Dotify::CLI.new }

  before do
    Fake.tearup
    Dotify::Config.stub(:home) { Fake.root_path }
    Dotify::Config.stub(:config_file) { File.join(fixtures, '.dotifyrc-default') }
    Dotify::Config.load_config!
  end

  after do
    Fake.teardown
  end

  describe Dotify::CLI, "#setup" do
    it "it should create the right directory if it does not exist" do
      FileUtils.rm_rf Dotify::Config.path
      cli.invoke :setup
      File.directory?(Dotify::Config.path).should be_true
    end
  end

  describe Dotify::CLI, "#link" do
    it "should link up all the files properly" do
      count = Dotify::Files.dots.size
      cli.invoke :link
      count.should == Dotify::Files.installed.size
    end
  end

end
