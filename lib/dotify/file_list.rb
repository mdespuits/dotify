module Dotify
  class FileList

    def self.pointers
      @pointers ||= []
    end

    # Add the list of Pointers from the dotfiles every time.
    # Whether they are linked or not initially makes no
    # difference.
    def self.dotfile_pointers
      Dir["#{Path.home}/.*"].each do |file|
        self.add Pointer.new(Path.dotify_path(File.basename(file)), file)
      end
    end

    def self.add pointer
      pointers << pointer
    end

    def self.destinations
      pointers.map(&:destination)
    end

    def self.sources
      pointers.map(&:source)
    end

  end
end