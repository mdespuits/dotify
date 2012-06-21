require 'dotify/configuration'

Dotify::Configuration.load_config!

module Dotify
  class Files
    class << self

      def dots
        @dots ||= file_list("#{path}/.dotify/.*")
      end

      def installed
        dots = self.dots.map { |f| file_name(f) }
        installed = file_list("#{path}/.*")
        installed.keep_if { |i| dots.include?(file_name(i)) }
      end

      def templates
        dots = self.dots.keep_if { |f| file_name(f) =~ /\.erb$/ }
      end

      def file_name(file)
        file.split("/").last
      end

      private

        def file_list(dir_glob)
          filter_dot_directories!(Dir[dir_glob])
        end

        def filter_dot_directories!(files)
          files.select { |f| !['.', '..'].include?(file_name(f)) }
        end

        def path
          Configuration.path
        end
    end
  end
end
