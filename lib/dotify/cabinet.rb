require 'dotify/errors'
require 'dotify/files'

module Dotify
  class Cabinet

    # Attributes on the file itself
    attr_accessor :filename, :dotify, :dotfile

    # Attributes about the file's status in the filesystem
    attr_accessor :linked, :added, :in_dotify, :in_dotfiles

    def initialize(file)
      basic_file_info(file)
    end

    def basic_file_info(file)
      @filename = Files.filename(file)
      @dotify = Files.dotify(@filename)
      @dotfile = Files.dotfile(@filename)
      added?
      linked?
      in_dotify?
      in_home?
    end

    def added?
      @added ||= in_dotify? && !dotfile_linked_to_dotify?
    end

    def linked?
      @linked ||= in_dotify? && dotfile_linked_to_dotify?
    end

    def in_dotify?
      @in_dotify ||= File.exists?(@dotify)
    end

    def in_home?
      @in_dotfiles ||= File.exists?(@dotfile)
    end

    def to_s
      "#<Dotify::Cabinet @filename='#{@filename}' @dotify='#{@dotify}' @dotfile='#{@dotfile}' @added='#{added?}' @linked='#{linked?}'>"
    end

    def dotfile_linked_to_dotify?
      File.readlink(@dotfile) == @dotify
    rescue
      false
    end

  end
end
