require 'dotify/version'
require 'dotify/errors'

require 'fileutils'

module Dotify

  # Yeah, I know. Ruby 2.0 is not supporting autoload.
  # Well, I'm keeping it here for now because I feel like
  # it and I don't want to require all of the files from
  # the start if I can avoid it.
  #
  # Anyway, I'll fix it eventually, I just am feeling a bit
  # lazy right now.
  autoload :Config,     'dotify/config'
  autoload :Collection, 'dotify/collection'
  autoload :Filter,     'dotify/filter'
  autoload :Dot,        'dotify/dot'
  autoload :CLI,        'dotify/cli'

  module CLI
    autoload :Base,        'dotify/cli'
    autoload :Utilities,   'dotify/cli/utilities'
  end

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
