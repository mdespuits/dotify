require 'fileutils'

require 'dotify/config'
require 'dotify/errors'
require 'dotify/version'
require 'dotify/cli/utilities'
require 'dotify/cli/github'
require 'dotify/dot'
require 'dotify/collection'
require 'dotify/filter'
require 'dotify/cli'


module Dotify

  def self.installed?
    Config.installed?
  end

  def self.version
    VERSION
  end

  def self.collection
    @collection ||= Collection.new
  end
end
