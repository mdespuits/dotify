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

    map "-l" => :link
    map "-u" => :unlink
    map "-s" => :setup
    map "-a" => :add
    map "-r" => :remove

    def self.source_root
      Config.home
    end

    desc :setup, "Setup your system for Dotify to manage your dotfiles"
    method_option :link, :default => false, :type => :boolean, :aliases => '-l', :desc => "Link dotfiles when setup is complete"
    def setup
      empty_directory(Config.path) unless File.directory?(Config.path)
      Files.unlinked do |path, file|
        add(file) unless Config.dirname == file
      end
      say "Dotify has been successfully setup.", :blue
      if options[:link]
        say "Linking up the new dotfiles...", :blue
        invoke :link, nil, { :all => true } if options[:link]
      end
    end

    desc "add [FILENAME]", "Add a single dotfile to the Dotify directory"
    method_option :force, :default => false, :type => :boolean, :aliases => '-f', :desc => "Add file without confirmation"
    def add(file)
      file = Files.filename(file)
      dotfile = Files.dotfile(file)
      dotify_file = Files.dotify(file)
      case
      when !File.exist?(dotfile)
        say "'~/#{file}' does not exist", :blue
      when File.identical?(dotfile, dotify_file)
        say "'~/#{file}' is already identical to '~/.dotify/#{file}'", :blue
      else
        if options[:force] == true || yes?("Do you want to add #{file} to Dotify? [Yn]", :yellow)
          if File.directory?(dotfile)
            FileUtils.rm_rf dotify_file
            FileUtils.cp_r dotfile, dotify_file
            say_status :create, dotify_file
          else
            copy_file dotfile, dotify_file
          end
        end
      end
    end

    desc "remove [FILENAME]", "Remove a single dotfile from Dotify"
    long_desc <<-STRING
      `dotify remove [FILENAME]` removes the dotfiles from the Dotify directory
      and moves it back into the home directory. If you decide you want Dotify
      to manage that file again, you can simply run `dotify add [FILENAME]` to
      add it back again.
    STRING
    method_option :force, :default => false, :type => :boolean, :aliases => '-f', :desc => "Remove file without confirmation"
    method_option :quiet, :default => false, :type => :boolean, :aliases => '-q', :desc => "Don't output anything"
    def remove(file)
      if !File.exists?(Files.dotify(file))
        say "Dotify is not currently managing ~/#{file}.", :blue unless options.quiet?
        return
      end
      if options[:force] == true || yes?("Are you sure you want to remove #{file} from Dotify? [Yn]", :yellow)
        remove_file Files.dotfile(file), :verbose => false
        copy_file Files.dotify(file), Files.dotfile(file), :verbose => false
        remove_file Files.dotify(file), :verbose => false
        say_status :removed, Files.dotify(file) unless options.quiet?
      end
    end

    desc :link, "Link up all of your dotfiles"
    method_option :all, :default => false, :type => :boolean, :aliases => '-a', :desc => "Link dotfiles without confirmation"
    def link
      count = 0
      Files.dots do |file, dot|
        if options[:all]
          if File.exists? Files.dotfile(file)
            replace_link Files.dotfile(file), file
          else
            create_link Files.dotfile(file), file
          end
          count += 1
        else
          if yes?("Do you want to link ~/#{dot}? [Yn]", :yellow)
            create_link Files.dotfile(file), file
            count += 1
          end
        end
      end
      say "No files were linked.", :blue if count == 0
    end

    desc :unlink, "Unlink all of your dotfiles"
    long_desc <<-STRING
      `dotify unlink` removes the dotfiles from the home directory and preserves the
      files in the Dotify directory. This allows you to simply run `dotify link` again
      should you decide you want to relink anything to the Dotify files.
    STRING
    method_option :all, :default => false, :type => :boolean, :aliases => '-a', :desc => 'Remove all installed dotfiles without confirmation'
    def unlink
      count = 0
      Files.installed do |file, dot|
        if options[:all] || yes?("Are you sure you want to remove ~/#{dot}? [Yn]", :yellow)
          remove_file Files.dotfile(file)
          count += 1
        end
      end
      say "No files were unlinked.", :blue if count == 0
    end

    no_tasks do

      def replace_link(dotfile, file)
        remove_file dotfile, :verbose => false
        create_link dotfile, file, :verbose => false
        say_status :replace, dotfile
      end

    end

  end
end
