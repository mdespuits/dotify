require 'dotify/version'
require 'dotify/errors'

require 'fileutils'

module Dotify

  autoload :Config,   'dotify/config'
  autoload :Files,    'dotify/files'
  autoload :List,     'dotify/list'
  autoload :Unit,     'dotify/unit'
  autoload :CLI,      'dotify/cli'

  def self.installed?
    Config.installed?
  end

  def self.version
    VERSION
  end
end
