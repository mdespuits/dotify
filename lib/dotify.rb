require 'fileutils'

require 'dotify/core_ext/dir'
require 'dotify/null_object'

# Everything else
require 'dotify/configure'
require 'dotify/link_builder'
require 'dotify/pointer'
require 'dotify/file_list'
require 'dotify/version'
require 'dotify/cli'
require 'dotify/version/checker'

module Dotify

  def self.installed?
    File.exists?(Configure.dir)
  end

  def self.config
    @config ||= Configure.new
  end

  def self.version
    @version ||= Version.build.level
  end

  def self.collection
    @collection ||= Collection.home
  end
end
