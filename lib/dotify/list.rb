require 'dotify'

module Dotify
  class List
    class << self

      def home
        result = units(Files.dotfile('.*'))
        filter_ignore_files!(result, :dotfiles)
      end

      def dotify
        result = units(Files.dotify('.*'))
        filter_ignore_files!(result, :dotify)
      end

      def units(glob)
        filter_dot_directories! Dir[glob].map{ |file| Unit.new(file) }
      end

      def filter_dot_directories!(units)
        [*units].delete_if { |f| %w[. ..].include? f.filename }
      end

      def filter_ignore_files!(units, ignore)
        ignoring = Config.ignore(ignore)
        [*units].delete_if { |f| ignoring.include?(f.filename) }
      end

      def filenames(units)
        units.map(&:filename)
      end

    end
  end
end
