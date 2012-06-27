require 'dotify'

module Dotify
  class FileList
    class << self

      def list(glob)
        list = filenames(Dir[glob])
        filter_dot_directories!(list)
      end

      def filter_dot_directories!(files)
        files.select { |f| !['.', '..'].include? f }
      end

      def filenames(files)
        files.map { |f| Dotify::Files.file_name(f) }
      end

    end
  end
end
