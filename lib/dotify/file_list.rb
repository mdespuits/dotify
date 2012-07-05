require 'dotify'
require 'dotify/config'

module Dotify
  class List
    class << self

      def home
        result = paths(File.join(Config.home, '.*'))
        filter_ignore_files!(result, :dotfiles)
      end

      def dotify
        result = paths(File.join(Config.path, '.*'))
        filter_ignore_files!(result, :dotify)
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

      def filter_ignore_files!(files, ignore)
        ignoring = Config.ignore(ignore)
        files.select { |f| !ignoring.include?(Files.filename(f)) }
      end

      def filenames(files)
        files.map { |f| Files.filename(f) }
      end

    end
  end
end
