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

  describe Dotify::CLI, "#dotfile_list" do
    it "should yield the correct filenames" do
      Thor.no_tasks do
        files = ['.', '..', '.vimrc', '.gemrc']
        Dir.stub!(:[]) { files }
        expectation = cli.any_instance.should_receive(:dotfile_list)
        files.each { |f| expectation.and_yield(f) unless File.directory?(f) }
        cli.new.dotfile_list { |file| }
      end
    end
  end

end
