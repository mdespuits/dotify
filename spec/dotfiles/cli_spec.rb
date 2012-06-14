ENV['DOTIFY_DIR_NAME'] = '.dotify-test'

require File.expand_path('../../../lib/dotify/cli.rb', __FILE__)

describe Dotify::CLI do

  let(:cli) { Dotify::CLI }
  let(:dotify_path) { cli::DOTIFY_PATH }

  before do
    FileUtils.rm_rf dotify_path
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

end
