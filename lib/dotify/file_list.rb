module Dotify
  class FileList

    def self.pointers
      @pointers ||= []
    end

    # Add the list of Pointers from the dotfiles every time.
    # Whether they are linked or not initially makes no
    # difference.
    def self.dotfile_pointers
      Dir["#{Configure.root}/.*"].each do |file|
        self.add Pointer.new(Configure.path(File.basename(file)), file)
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