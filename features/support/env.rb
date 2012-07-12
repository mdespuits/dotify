require 'rubygems'
require 'thor/util'
require 'fileutils'

$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'dotify'

Before do
  @__orig_home = ENV["HOME"]
  ENV["HOME"] = "/tmp"
  `rm -rf #{File.join(ENV["HOME"], '.bash_profile')}`
  `rm -rf #{File.join(ENV["HOME"], '.gemrc')}`
end

After do
  ENV["HOME"] = @__orig_home
end
