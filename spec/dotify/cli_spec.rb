require 'spec_helper'
require 'dotify/cli'

describe Dotify::CLI do

  let(:fixtures) { File.join(%x{pwd}.chomp, 'spec/fixtures') }

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
    let(:cli) { Dotify::CLI.new }
    it "it should create the right directory if it does not exist" do
      Dir.stub(:exists?).with(Dotify::Config.path).and_return(false)
      cli.should_receive(:empty_directory).with(Dotify::Config.path)
      cli.setup
    end
    it "it should not try to create the right directory if it exists" do
      Dir.stub(:exists?).with(Dotify::Config.path).and_return(true)
      cli.should_not_receive(:empty_directory).with(Dotify::Config.path)
      cli.setup
    end
  end

end
