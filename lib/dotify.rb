require 'fileutils'

require 'dotify/core_ext/dir'

# Everything else
require 'dotify/config'
require 'dotify/pointer'
require 'dotify/file_list'
require 'dotify/version'
require 'dotify/cli'
require 'dotify/version/checker'


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
