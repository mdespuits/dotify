require 'bundler/setup'
require 'dotify/config'
require "fileutils"

module Dotify
  def self.installed?
    Config.installed?
  end
end
