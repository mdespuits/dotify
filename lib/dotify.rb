require 'fileutils'

# Everything else
require 'dotify/config'
require 'dotify/version'
require 'dotify/cli'


module Dotify

  def self.installed?
    Config.installed?
  end

  def self.version
    @version ||= Version.build.level
  end

  def self.collection
    @collection ||= Collection.home
  end
end
