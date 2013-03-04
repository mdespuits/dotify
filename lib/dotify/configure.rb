require 'thor/util'

module Dotify
  class Configure < Object

    CONFIG_FILE = "config.rb"

    def editor(&blk)
      @editor ||= 'vim'
      @editor = blk.call.to_s if block_given?
      @editor
    end

    def ignore(&blk)
      @ignore ||= ['.DS_Store', '.git']
      @ignore += Array(blk.call) if block_given?
      @ignore.uniq
    end

    def platform(name = nil)
      raise ArgumentError, "You must define an operating system name when using the `platform` option in configuration" unless name
      if name.to_s == OperatingSystem.guess.to_s
        yield self if block_given?
      end
    end

    def self.start
      yield instance = new
      instance
    end

  end
end
