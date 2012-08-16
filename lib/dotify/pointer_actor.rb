require 'fileutils'

module Dotify
  class PointerActor

    include FileUtils

    def link_from_source
    end
    alias :link_to_destination :link_from_source

    def link_to_source
    end
    alias :link_from_destination :link_to_source

    def move_to_source
    end

    def move_to_destination
    end

    def remove_source
    end

    def remove_destination
    end

  end
end