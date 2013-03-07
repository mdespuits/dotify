require 'fileutils'

module Dotify
  class LinkBuilder

    include FileUtils

    attr_reader :pointer, :source, :destination
    def initialize(file_pointer)
      @pointer = file_pointer
      @source = file_pointer.source
      @destination = file_pointer.destination
    end

    # Linking from source links the destination file
    # to the source file (the file stored within Dotify)
    # given the source file is in existence and the destination
    # is or is being overwritten.
    def link_from_source
      remove_destination
      link!
    end

    def link_to_source
      remove_source
      move_to_source
      link!
    end

    def move_to_source
      transport(destination, source)
    end

    def move_to_destination
      transport(source, destination)
    end

    def remove_source
      remove(source)
    end

    def remove_destination
      remove(destination)
    end

    def link!
      touch source, destination
      ln_sf source, destination
    end

    def touch(*files)
      files.map { |f| mkdir_p File.dirname(f) }
      super files
    end

    private

      def transport(beginning, ending)
        touch beginning
        move beginning, ending
      end

      def remove(file)
        touch file
        rm_rf file
      end

  end
end
