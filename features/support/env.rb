require 'rubygems'
require 'thor/util'
require 'fileutils'

$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'dotify'
require 'cucumber/rspec/doubles'

Before do
  @__orig_home = ENV["HOME"]

  # Stub CLI say method
  @cli = Dotify::CLI::Base.new
  @cli.stub(:say)

  FileUtils.mkdir_p "/tmp/dotify-test"
  ENV["HOME"] = "/tmp/dotify-test"
  `rm -rf #{File.join(ENV["HOME"], '.bash_profile')}`
  `rm -rf #{File.join(ENV["HOME"], '.gemrc')}`
end

After do
  FileUtils.rm_rf "/tmp/dotify-test"
  ENV["HOME"] = @__orig_home
end
