require 'dotify/errors'

module Dotify

  class NoSymlink; end

  module Actions

    # Link the file from the home directory into Dotify
    def link
      return false if !in_home_dir? || linked?
      if in_home_dir? && !in_dotify?
        FileUtils.cp_r(self.dotfile, self.dotify, :verbose => false)
      end
      FileUtils.rm_rf(self.dotfile, :verbose => false)
      FileUtils.ln_sf(self.dotify, self.dotfile, :verbose => false)
      return true
    end

    # Unlink the file from Dotify and replace it into the home directory.
    def unlink
      return false unless linked?
      FileUtils.rm_rf(self.dotfile, :verbose => false)
      FileUtils.cp_r(self.dotify, self.dotfile, :verbose => false)
      FileUtils.rm_rf(self.dotify, :verbose => false)
      return true
    end

  end

  class Unit

    include Actions

    # Attributes on the file itself
    attr_accessor :filename, :dotify, :dotfile

    # Attributes about the file's status in the filesystem
    attr_accessor :linked, :added

    def initialize(file)
      @filename = File.basename(file)
      self
    end

    def dotify
      @dotify ||= File.join(Config.path, @filename)
    end

    def dotfile
      @dotfile ||= File.join(Config.home, @filename)
    end
    alias :home :dotfile

    def added?
      in_dotify? && !linked_to_dotify?
    end

    def linked?
      in_dotify? && linked_to_dotify?
    end

    def in_dotify?
      File.exists?(dotify)
    end

    def in_home_dir?
      File.exists?(dotfile)
    end

    def to_s
      self.filename
    end

    def inspect
      "#<Dotify::Unit @filename='#{@filename}' @added=#{added?} @linked=#{linked?}>"
    end

    def linked_to_dotify?
      self.symlink == dotify
    end

    def symlink
      begin
        File.readlink dotfile
      rescue
        NoSymlink
      end
    end

  end
end
