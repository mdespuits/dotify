require 'dotify/config'

Dotify::Config.load_config!

module Dotify
  class Files
    class << self

      def dots
        @dots ||= file_list("#{path}/.dotify/.*")
        return @dots unless block_given?
        @dots.each {|d| yield(d) }
      end

      def installed
        dots = self.dots.map { |f| file_name(f) }
        installed = file_list("#{path}/.*")
        installed.select { |i| dots.include?(file_name(i)) }
      end

      def templates
        dots = self.dots.select { |f| file_name(f) =~ /\.erb$/ }
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
          Config.path
        end
    end
  end
end
