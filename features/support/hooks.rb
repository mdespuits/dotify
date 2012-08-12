Before do
  @__orig_home = ENV["HOME"]
  @tmp_home = "/tmp/dotify-test"

  ## Aruba config ##
  @dirs = [@tmp_home]
  ENV["PATH"] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

  FileUtils.mkdir_p @tmp_home
  ENV["HOME"] = @tmp_home
end

After do
  FileUtils.rm_rf @tmp_home
  ENV["HOME"] = @__orig_home
end

Before('@long_process, @interactive') do
  @aruba_io_wait_seconds = 2
  @aruba_timeout_seconds = 4
end

Before('@abnoxiously_long') do
  @aruba_io_wait_seconds = 2
  @aruba_timeout_seconds = 20
end
