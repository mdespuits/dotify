require 'rubygems'
require 'thor/util'
require 'fileutils'

$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'cucumber/rspec/doubles'
require 'aruba/cucumber'

unless ENV["CI"]
  require 'simplecov'
  SimpleCov.start do
    coverage_dir 'coverage/cuke'
    load_adapter 'test_frameworks'
  end
end

require 'dotify'

Before('@interactive') do
  @aruba_io_wait_seconds = 15
  @aruba_timeout_seconds = 15
end

Before('@long_process') do
  @aruba_io_wait_seconds = 15
  @aruba_timeout_seconds = 15
end

Before do
  @__orig_home = ENV["HOME"]
  @tmp_home = "/tmp/dotify-test"

  ## Aruba config ##
  @aruba_io_wait_seconds = 1
  @aruba_timeout_seconds = 5
  @dirs = [@tmp_home]
  ENV["PATH"] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

  FileUtils.mkdir_p @tmp_home
  ENV["HOME"] = @tmp_home
end

After do
  FileUtils.rm_rf @tmp_home
  ENV["HOME"] = @__orig_home
end
