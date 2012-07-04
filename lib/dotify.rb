require 'dotify/config'
require 'dotify/version'
require "fileutils"

module Dotify
  def self.installed?
    Config.installed?
  end

  def self.version
    VERSION
  end
end
