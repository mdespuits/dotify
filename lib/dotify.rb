require 'fileutils'

require 'dotify/core_ext/dir'
require 'dotify/null_object'

# Everything else
require 'dotify/pointer'
require 'dotify/path'
require 'dotify/configure'
require 'dotify/link_builder'
require 'dotify/file_list'
require 'dotify/version'
require 'dotify/cli'
require 'dotify/version/checker'

module Dotify

  def self.in_instance(instance)
    @instance = instance
    result = yield
    @instance = nil
    result
  end

  def self.setup(&blk)
    @instance.instance_eval &blk
  end

  def self.installed?
    File.exists?(Path.dotify)
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
