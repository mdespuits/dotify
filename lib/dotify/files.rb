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
        @dots.each {|d| yield(d, filename(d)) }
      end

      def installed
        dots = self.dots.map { |f| filename(f) }
        installed = FileList.home.select do |d|
          dots.include?(filename(d))
        end
        return installed unless block_given?
        installed.each {|i| yield(i, filename(i)) }
      end

      def unlinked
        dots = self.dots.map { |d| filename(d) }
        installed = self.installed.map {|i| filename(i)}
        unlinked = (dots - installed).map{|f| dotfile(f) }
        return unlinked unless block_given?
        unlinked.each {|u| yield(u, filename(u)) }
      end

      def filename(file)
        %r{([^<>:"\/\\\|\?\*]*)\Z}.match(file).to_s
      end

      def template?(file)
        filename(file).match(/(tt|erb)\Z/) ? true : false
      end

      def dotfile(file)
        File.join(Config.home, filename(file))
      end

      def dotify(file)
        File.join(Config.path, filename(file))
      end

      def link_dotfile(file)
        FileUtils.ln_s(filename(file), Config.home) == 0 ? true : false
      end

      def unlink_dotfile(file)
        FileUtils.rm_rf File.join(Config.home, filename(file))
      end

    end
  end
end
