require 'dotify/errors'
require 'dotify/files'

module Dotify

  class Cabinet

    # Attributes on the file itself
    attr_accessor :filename, :dotify, :dotfile

    # Attributes about the file's status in the filesystem
    attr_accessor :linked, :added

    def initialize(file)
      basic_file_info(file)
      check_file_existence! self.dotfile
      return self
    end

    def basic_file_info(file)
      @filename = Files.filename(file)
      @dotify = Files.dotify(@filename)
      @dotfile = Files.dotfile(@filename)
    end

    def added?
      @added ||= file_in_dotify? && readlink(@dotfile) != @dotify
    end

    def linked?
      @linked ||= file_in_dotify? && readlink(@dotfile) == @dotify
    end

    def file_in_dotify?
      File.exists?(@dotify)
    end

    def to_s
      "#<Dotify::Cabinet @filename='#{@filename}' @dotify='#{@dotify}' @dotfile='#{@dotfile}' @added='#{added?}' @linked='#{linked?}'>"
    end

    def readlink(dotfile)
      File.readlink(dotfile)
    rescue
      false
    end

    private

      def check_file_existence!(file)
        if !File.exists?(file)
          raise CabinetDoesNotExist, "The file #{file} does not exist"
        end
      end

  end
end
