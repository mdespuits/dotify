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
        @dots ||= file_list(File.join(dotify_path, "/.*"))
        return @dots unless block_given?
        @dots.each {|d| yield(d, file_name(d)) }
      end

      def installed
        dots = self.dots.map { |f| file_name(f) }
        installed = file_list(File.join(Config.home, ".*")).select do |i|
          dots.include?(file_name(i))
        end
        return installed unless block_given?
        installed.each {|i| yield(i, file_name(i)) }
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

      private

        def file_list(dir_glob)
          filter_dot_directories!(Dir[dir_glob])
        end

        def filter_dot_directories!(files)
          files.select { |f| !['.', '..'].include?(file_name(f)) }
        end

        def dotify_path
          Config.path
        end

    end
  end
end
