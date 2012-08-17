require 'fileutils'

module Dotify
  class LinkBuilder

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
      remove_destination
      link!
    end

    def link_to_source
      remove_source
      move_to_source
      link!
    end

    def move_to_source
      touch destination
      move destination, source
    end

    def touch(*files)
      files.each do |f|
        mkdir_p File.dirname(f)
        super f
      end
    end

    def rm_rf(*files)
      files.each { |f| super(f, :secure => true)}
    end

    def move_to_destination
      touch source
      move source, destination
    end

    def remove_source
      touch source
      rm_rf source
    end

    def remove_destination
      touch destination
      rm_rf destination
    end

    def link!
      touch source, destination
      ln_sf source, destination
    end

  end
end