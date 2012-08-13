module Dotify
  class FileList

    def self.pointers
      @pointers ||= []
    end

    def self.add pointer
      pointers << pointer
    end

    def self.destinations
    end

    def self.complete
    end

  end
end