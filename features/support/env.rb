require 'rubygems'
require 'thor/util'
require 'fileutils'

$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'dotify'
require 'cucumber/rspec/doubles'
require 'aruba/cucumber'

Before do
  @__orig_home = ENV["HOME"]

  # Stub CLI say method
  @cli = Dotify::CLI::Base.new
  @cli.stub(:say)

  @tmp_home = "/tmp/dotify-test"
  @dirs = [@tmp_home]
  ENV["HOME"] = @tmp_home
  `rm -rf #{File.join(ENV["HOME"], '.bash_profile')}`
  `rm -rf #{File.join(ENV["HOME"], '.gemrc')}`
end

After do
  FileUtils.rm_rf @tmp_home
  ENV["HOME"] = @__orig_home
end
