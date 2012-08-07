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
  def jruby?
    defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'
  end

  @aruba_io_wait_seconds = jruby? ? 6 : 2
  @aruba_timeout_seconds = jruby? ? 25 : 5
end
