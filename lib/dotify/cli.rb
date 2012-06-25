require 'thor'
require 'dotify'
require 'dotify/config'
require 'dotify/files'
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

    desc :setup, "Setup your system for Dotify to manage your dotfiles"
    def setup
      empty_directory(Config.path, :verbose => false) unless File.directory?(Config.path)
      Dir[File.join(Config.home, ".*")].each do |file|
        filename = Files.file_name(file)
        dotify_file = File.join(Config.path, filename)
        unless ['.', '..', Config.dirname].include? filename
          if yes?("Do you want to add #{filename} to Dotify? [Yn]")
            if File.directory?(Files.dotfile(file))
              FileUtils.rm_rf dotify_file
              FileUtils.cp_r Files.dotfile(file), dotify_file
              say_status :create, dotify_file, :verbose => false
            else
              copy_file Files.dotfile(file), dotify_file, :verbose => false
            end
          end
        end
      end
    end

    desc :link, "Link up all of your dotfiles"
    method_option :all, :default => false, :type => :boolean, :aliases => '-a', :desc => "Link dotfiles without confirmation"
    def link
      Files.dots do |file, dot|
        if options.all?
          replace_link Files.dotfile(file), file
        else
          create_link Files.dotfile(file), file, :verbose => false
        end
      end
    end

    desc :unlink, "Unlink all of your dotfiles"
    method_option :all, :default => false, :type => :boolean, :aliases => '-a', :desc => 'Remove all installed dotfiles without confirmation'
    def unlink
      Files.installed do |file, dot|
        if options.all? || yes?("Are you sure you want to remove ~/#{dot}? [Yn]", :blue)
          remove_file Files.dotfile(file), :verbose => true
        end
      end
    end

    no_tasks do

      def replace_link(dotfile, file)
        remove_file dotfile, :verbose => false
        create_link dotfile, file, :verbose => false
      end

    end

  end
end
