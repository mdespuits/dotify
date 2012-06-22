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
      Files.dots do |file|
        if File.template? file
          template file, dotfile_location(no_extension(Files.file_name(file)))
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
      Files.installed do |file|
        destination = Files.file_name(file)
        if options.force? || yes?("Are you sure you want to remove ~/#{destination}? [Yn]", :blue)
          remove_file dotfile_location(file), :verbose => true
        end
      end
    end

    desc :backup, "Backup your dotfiles for quick recovery if something goes wrong"
    def backup
      Files.dots do |file|
        file = Files.file_name(file)
        backup = "#{Config.backup}/#{file}"
        if File.exists?(dotfile_location(file))
          remove_file backup, :verbose => false if File.exists?(backup)
          copy_file dotfile_location(file), backup, :verbose => false
          say "Backing up ~/#{file}", :blue
        end
      end
    end

    desc :restore, "Restore your backed-up dotfiles"
    method_option :force, :default => false, :type => :boolean, :aliases => '-f', :desc => "Backup existing dotfiles"
    def restore
      backup_list do |file|
        filename = Files.file_name(file)
        if options.force? || yes?("Are you sure you want to restore ~/#{filename}? [Yn]", :red)
          if File.exists?(dotfile_location(filename))
            remove_file dotfile_location(filename), :verbose => false
          end
          copy_file file, dotfile_location(filename), :verbose => false
          say "Restoring up ~/#{filename}", :blue
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

      def backup_list
        files = Dir["#{Config.backup}/.*"]
        files.delete_if { |f| File.directory? f }
        if block_given?
          files.each { |f| yield f }
        else
          files
        end
      end

    end

  end
end
