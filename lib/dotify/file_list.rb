require 'dotify'
require 'dotify/config'

module Dotify
  class FileList
    class << self

      def home
        list(File.join(Config.home, '.*'))
      end

      def dotify
        list(File.join(Config.path, '.*'))
      end

      def list(glob)
        filenames(paths(glob))
      end

      def paths(glob)
        filter_dot_directories!(Dir[glob])
      end

      def filter_dot_directories!(files)
        files.select { |f| !['.', '..'].include?(Files.filename(f)) }
      end

      def filenames(files)
        files.map { |f| Files.filename(f) }
      end

    end
  end
end
