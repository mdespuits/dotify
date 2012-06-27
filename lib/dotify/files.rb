require 'dotify'
require 'thor/actions'
require 'thor/shell'

Dotify::Config.load_config!

module Dotify
  class Files
    class << self
      include Thor::Shell
      include Thor::Actions

      def dots
        @dots ||= FileList.dotify
        return @dots unless block_given?
        @dots.each {|d| yield(d, file_name(d)) }
      end

      def installed
        dots = self.dots.map { |f| file_name(f) }
        installed = FileList.home.select do |d|
          dots.include?(file_name(d))
        end
        return installed unless block_given?
        installed.each {|i| yield(i, file_name(i)) }
      end

      def unlinked
        dots = self.dots.map { |d| file_name(d) }
        installed = self.installed.map {|i| file_name(i)}
        unlinked = (dots - installed).map{|f| dotfile(f) }
        return unlinked unless block_given?
        unlinked.each {|u| yield(u, file_name(u)) }
      end

      def file_name(file)
        file.split("/").last
      end

      def template?(file)
        file_name(file).match(/(tt|erb)$/) ? true : false
      end

      def dotfile(file)
        File.join(Config.home, file_name(file))
      end

      def dotify(file)
        File.join(Config.path, file_name(file))
      end

      def link_dotfile(file)
        FileUtils.ln_s(file_name(file), Config.home) == 0 ? true : false
      end

      def unlink_dotfile(file)
        FileUtils.rm_rf File.join(Config.home, file_name(file))
      end

      protected

        def list_of_dotify_files
          FileList.dotify
        end

        def list_of_dotfiles
          FileList.home
        end

    end
  end
end
