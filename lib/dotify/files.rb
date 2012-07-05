require 'dotify'
require 'thor/actions'
require 'thor/shell'

Dotify::Config.load_config!

module Dotify
  class Files
    class << self
      include Thor::Shell
      include Thor::Actions

      def linked
        @linked ||= List.dotify
        return @linked unless block_given?
        @linked.each {|d| yield(d, filename(d)) }
      end

      def unlinked
        linked = self.linked.map { |d| filename(d) }
        installed = self.installed.map {|i| filename(i)}
        unlinked = (linked - installed).map{|f| dotfile(f) }
        return unlinked unless block_given?
        unlinked.each {|u| yield(u, filename(u)) }
      end

      def installed
        linked = self.linked.map { |f| filename(f) }
        installed = List.home.select do |d|
          linked.include?(filename(d))
        end
        return installed unless block_given?
        installed.each {|i| yield(i, filename(i)) }
      end

      def uninstalled
        linked = self.linked.map { |f| filename(f) }
        installed = List.home.select do |d|
          !linked.include?(filename(d))
        end
        return installed unless block_given?
        installed.each {|i| yield(i, filename(i)) }
      end

      def filename(file)
        %r{([^<>:"\/\\\|\?\*]*)\Z}.match(file).to_s
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
