module Dotify
  class Configure
    def self.reset!
      @options = {}
      @host = nil
    end
    def reset!
      @options = {}
    end
  end
end

Before do
  @__orig_home = ENV["HOME"]
  @__root = "/tmp/dotify-test"

  ## Aruba config ##
  @dirs = [@__root]
  ENV["PATH"] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

  FileUtils.mkdir_p @__root
  ENV["HOME"] = @__root
end

Before('@reset_configuration') do
  Dotify::Configure.reset!
  Dotify.config.reset!
end

After do
  FileUtils.rm_rf @__root
  ENV["HOME"] = @__orig_home
end

Before('@long_process, @interactive') do
  @aruba_io_wait_seconds = 0.5
  @aruba_timeout_seconds = 1
end

Before('@abnoxiously_long') do
  @aruba_io_wait_seconds = 2
  @aruba_timeout_seconds = 20
end
