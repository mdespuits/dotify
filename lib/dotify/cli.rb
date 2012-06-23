require 'thor'
require 'thor/util'
require 'dotify'
require 'dotify/version'
require 'dotify/config'
require 'dotify/files'
require 'erb'
require 'fileutils'

Dotify::Config.load_config!

module Dotify
  class CLI < Thor
    include Thor::Actions
    default_task :help

    map "-l" => "link"
    map "-u" => "unlink"
    map "-b" => "backup"
    map "-r" => "restore"

    def self.source_root
      Config.home
    end

    desc :setup, "Get your system setup for dotfile management"
    def setup
      ::FileUtils.mkdir_p Config.path
    end

    desc :link, "Link up your dotfiles"
    method_option :force, :default => false, :type => :boolean, :aliases => '-f', :desc => "Definitely link all dotfiles"
    def link
      Files.dots do |file, dot|
        if File.template? file
          template file, dotfile_location(no_extension(dot))
        else
          if options.force?
            replace_link dotfile_location(file), file
          else
            create_link dotfile_location(file), file
          end
        end
      end
    end

    desc :unlink, "Unlink all of your dotfiles"
    method_option :force, :default => false, :type => :boolean, :aliases => '-f', :desc => "Definitely remove all dotfiles"
    def unlink
      Files.installed do |file, dot|
        if options.force? || yes?("Are you sure you want to remove ~/#{dot}? [Yn]", :blue)
          remove_file dotfile_location(file), :verbose => true
        end
      end
    end

    no_tasks do

      def dotfile_location(file)
        "#{home}/#{Files.file_name(file)}"
      end

      def no_extension(file)
        file = file.split('.')
        file.pop
        file.join('.')
      end

      def home
        Thor::Util.user_home
      end

      def replace_link(dotfile, file)
        remove_file dotfile
        create_link dotfile, file
      end

    end

  end
end
