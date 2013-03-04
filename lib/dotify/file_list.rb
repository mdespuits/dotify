module Dotify
  class FileList
    class << self

      def pointers
        @pointers ||= []
      end

      # Add the list of Pointers from the dotfiles every time.
      # Whether they are linked or not initially makes no
      # difference.
      def dotfile_pointers
        home_dotfiles.each do |file|
          add(Pointer.new(Path.dotify_path(File.basename(file)), file))
        end
      end

      def add(*new_pointers)
        new_pointers.each do |p|
          # Only add the new pointer if the source has not already been taken to avoid conflicts
          pointers << p unless sources.include? p.source
        end
      end

      def destinations
        pointers.map(&:destination)
      end

      def sources
        pointers.map(&:source)
      end

      def home_dotfiles
        Dir["#{Path.home}/.*"].reject { |file| /\.{1,2}\z/ =~ File.basename(file) }
      end

    end
  end
end
