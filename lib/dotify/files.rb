require 'thor/actions'
require 'thor/shell'

Dotify::Config.load_config!

module Dotify
  class Files
    class << self
      # All
      #
      # Pulls an array of Units from the home
      # directory.
      def all
        @all ||= List.home
      end

      # Linked files are those files which have a
      # symbolic link pointing to the Dotify file.
      def linked
        links = self.all.select { |f| f.linked? }
        return links unless block_given?
        links.each {|u| yield u }
      end

      # Unlinked files are, of course, the opposite
      # of linked files. These are Dotify files which
      # Have no home dir files that are linked to them.
      def unlinked
        unl = self.all.select { |f| !f.linked? }
        return unl unless block_given?
        unl.each {|u| yield u }
      end

      # Uninstalled dotfiles are the dotfiles in the home
      # directory that have not been loaded into Dotify or
      # linked to the corresponding Dotify path.
      def uninstalled
        uni = self.all.select { |f| !f.added? && !f.linked? }
        return uni unless block_given?
        uni.each {|u| yield u }
      end

      def filename(file)
        File.basename(file)
      end

      def dotfile(file = nil)
        file.nil? ? Config.home : File.join(Config.home, filename(file))
      end
      alias :home :dotfile

      def dotify(file = nil)
        file.nil? ? Config.path : File.join(Config.path, filename(file))
      end

      def link_dotfile(file)
        FileUtils.ln_s(filename(file), Config.home) == 0 ? true : false
      end

      def unlink_dotfile(file)
        FileUtils.rm_rf dotfile(file)
      end

    end
  end
end
