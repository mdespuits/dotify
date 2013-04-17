require 'dotify/symlink'

module Dotify
  class Configure < Object

    CONFIG_FILE = "config.rb"

    def ignore(&blk)
      @ignore ||= []
      @ignore.concat Array(blk.call) if block_given?
      @ignore.uniq!
      @ignore
    end

    def symlink(source, destination)
      symlinks << Symlink.new(source, Path.dotify_path(destination))
    end

    def symlinks
      @symlinks ||= []
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
