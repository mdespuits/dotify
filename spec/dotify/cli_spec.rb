require 'spec_helper'
require 'dotify/cli'

describe Dotify::CLI do

  let(:cli) { Dotify::CLI }
  let(:dotify_path) { Dotify::Config.path }

  before do
    Dotify::Config.stub(:config_file) { "#{here}/spec/fixtures/.dotifyrc-default" }
    Fake.tearup
  end

  after do
    Fake.teardown
  end

  describe Dotify::CLI, "#setup" do
    it "it should create the right directory" do
      FileUtils.should_receive(:mkdir_p).with(dotify_path)
      cli.new.setup
    end
  end

end
