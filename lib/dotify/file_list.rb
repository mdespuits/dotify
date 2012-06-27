require 'dotify'

module Dotify
  class FileList
    class << self

      def list(glob)
        filenames(paths(glob))
      end

      def paths(glob)
        filter_dot_directories!(Dir[glob])
      end

      def filter_dot_directories!(files)
        files.select { |f| !['.', '..'].include?(Files.file_name(f)) }
      end

      def filenames(files)
        files.map { |f| Files.file_name(f) }
      end

    end
  end
end
