require 'rubygems'
require 'thor/util'
require 'fileutils'

$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'dotify'
require 'cucumber/rspec/doubles'

Before do
  @__orig_home = ENV["HOME"]

  # Stub CLI say method
  @cli = Dotify::CLI.new
  @cli.stub(:say)

  ENV["HOME"] = "/tmp"
  `rm -rf #{File.join(ENV["HOME"], '.bash_profile')}`
  `rm -rf #{File.join(ENV["HOME"], '.gemrc')}`
end

After do
  ENV["HOME"] = @__orig_home
end
