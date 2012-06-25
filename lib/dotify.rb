module Dotify
end
require 'bundler/setup'
require "fileutils"

path = File.expand_path(File.dirname(__FILE__))
Dir[File.join(path, 'lib/*.rb')].each {|file| require file }
