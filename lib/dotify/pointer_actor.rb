require 'fileutils'

module Dotify
  class PointerActor

    include FileUtils

    attr_accessor :pointer, :source, :destination
    def initialize(pointer)
      @pointer = pointer
      @source = pointer.source
      @destination = pointer.destination
    end

    # Linking from source links the destination file
    # to the source file (the file stored within Dotify)
    # given the source file is in existence and the destination
    # is or is being overwritten.
    def link_from_source
      touch source
      remove_destination
      link!
    end
    alias :link_to_destination :link_from_source

    def link_to_source
      remove_source
      move_to_source
      link!
    end
    alias :link_from_destination :link_to_source

    def move_to_source
      touch destination
      move destination, source
    end

    def move_to_destination
      touch source
      move source, destination
    end

    def remove_source
      rm_rf source, :secure => true
    end

    def remove_destination
      rm_rf destination, :secure => true
    end

    def link!
      ln_sf source, destination
    end

  end
end