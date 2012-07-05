require 'rubygems'
require 'thor'
require 'fileutils'
require 'git'
require 'net/http'

require 'dotify'
require 'dotify/version_checker'

Dotify::Config.load_config!

module Dotify

  class Git
    include ::Git
  end
  class CLI < Thor
    include Thor::Actions
    default_task :help

    map %w[-v --version] => :version
    map "-s" => :setup
    map "-a" => :add
    map "-r" => :remove
    map "-l" => :link
    map "-u" => :unlink

    def self.source_root
      File.expand_path("../../../templates", __FILE__)
    end

    desc :save, "Save Dotify files and push to Github."
    method_option :message, :aliases => '-m', :type => :string, :required => false, :desc => "Git commit message to send to Github"
    method_option :force,   :aliases => '-f', :type => :boolean, :default => false, :desc => "Do not ask for confirmation when adding files to the staging area."
    method_option :debug,   :aliases => '-d', :type => :boolean, :default => false, :desc => "Show error messages if there is a Git failure."
    method_option :verbose, :aliases => '-v', :type => :boolean, :default => true,  :desc => "Display file creation and status updates."
    method_option :push,    :aliases => '-p', :type => :boolean, :default => false, :desc => "Force the push to the remote repository."
    def save
      if File.exists? Files.dotify('.git') # if the Dotify directory has been made a git repo
        repo = ::Git.open(Config.path)
        changed = repo.status.changed
        if changed.size > 0
          changed.each_pair do |file, status|
            say_status :changed, status.path, :verbose => options[:verbose]
            if options[:force] || yes?("Do you want to add '#{status.path}' to the Git index? [Yn]", :blue)
              repo.add status.path
              say_status :added, status.path, :verbose => options[:verbose]
            end
          end
          message = !options[:message].nil? ? options[:message] : ask("Commit message:", :blue)
          say message, :yellow, :verbose => options[:verbose]
          repo.commit(message)
        else
          say "No files have been changed in Dotify.", :blue
          @push = true
        end
        if @push == true || options[:push] || yes?("Would you like to push these changed to Github (or wherever your remote repo is located)? [Yn]", :blue)
          say 'Pushing up to Github...', :blue
          begin
            repo.push
          rescue Exception => e
            say "There was a problem pushing to your remote repo.", :red
            say("Git Error: #{e.message}", :red) if options[:debug]
            return
          end
          say "Successfully pushed!", :blue
        end
      else
        say 'Dotify has nothing to save.', :blue
      end
    end

    desc 'edit [FILE]', "Edit a dotify file"
    method_option :save, :aliases => '-s', :default => false, :type => :boolean, :require => true, :desc => "Save Dotify files and push to Github"
    def edit(file)
      file = Unit.new(file)
      if file.linked?
        exec "#{Config.editor} #{file.dotify}"
        save if options[:save] == true
      else
        say "'#{file}' has not been linked by Dotify. Please run `dotify link #{file}` to edit this file.", :blue
      end
    end

    desc :version, "Check your Dotify version"
    method_option :verbose, :aliases => '-v', :default => false, :type => :boolean, :desc => "Output any errors that occur during the Version check."
    def version
      if VersionChecker.out_of_date?
        say "Your version of Dotify is out of date.", :yellow
        say "  Your Version:   #{Dotify.version}", :blue
        say "  Latest Version: #{VersionChecker.version}", :blue
        say "I recommend that you uninstall Dotify completely before updating", :yellow
      else
        say "Your version of Dotify is up to date: #{Dotify::VERSION}", :blue
      end
    rescue Exception => e
      say "There was an error checking your Dotify version. Please try again.", :red
      say VersionChecker.handle_error(e) if options[:verbose] == true
    end

    desc :setup, "Setup your system for Dotify to manage your dotfiles"
    method_option :install, :type => :boolean, :default => true, :desc => "Install Dotify after setup"
    method_option "edit-config", :type => :boolean, :default => true, :desc => "Edit Dotify's configuration."
    method_options :verbose => true
    def setup
      # Warn if Dotify is already setup
      if Dotify.installed?
        say "Dotify is already setup", :blue
      end

      # Create the Dotify directory unless it already exists
      unless File.exists?(Config.path)
        empty_directory(Config.path, :verbose => options[:verbose])
      end

      # Create the Dotify config file unless it already exists
      unless File.exists?(Config.file)
        template '.dotrc', Config.file, :verbose => options[:verbose]
      end

      say "Editing config file...", :blue
      sleep 0.5 # Give a little time for reading the message
      invoke :edit, [Config.file]
      say "Config file updated.", :blue

      # Run install task if specified
      invoke :install if options[:install] == true
    end

    desc :install, "Install files from your home directory into Dotify"
    def install
      invoke :setup unless Dotify.installed?
      invoke :link
    end

    desc 'link [[FILENAME]]', "Link up one or all of your dotfiles (FILENAME is optional)"
    long_desc <<-DESC
      This task takes a file from the home directory, \
      moves it into Dotify, and symlinks the file in the \
      home directory to the corresponding file in Dotify.
    DESC
    method_option :force,   :default => false, :type => :boolean, :aliases => '-f', :desc => "Link dotfiles without confirmation"
    method_option :relink,  :default => false, :type => :boolean, :aliases => '-r', :desc => "Relink files already in the"
    def link(file = nil)
      return not_setup_warning unless Dotify.installed?
      # Link a single file
      return link_file Unit.new(file), options unless file.nil?
      # Relink the files
      return Files.linked { |file| link_file(file, options) } if options[:relink]
      # Link the files
      Files.unlinked { |file| link_file(file, options) }
    end

    desc 'unlink [[FILENAME]]', "Unlink one or all of your dotfiles (FILENAME is optional)"
    long_desc <<-DESC
      This task unlinks the dotfile from Dotify and \
      moves it back into the home directory. This will \
      only be run if the file is symlinked to the corresponsing \
      file in Dotify.
    DESC
    method_option :force, :default => false, :type => :boolean, :aliases => '-f', :desc => 'Remove all installed dotfiles without confirmation'
    def unlink(file = nil)
      return not_setup_warning unless Dotify.installed?
      # Unlink a single file
      return unlink_file Unit.new(file), options unless file.nil?
      # Unlink the files
      Files.linked { |file| unlink_file(file, options) }
    end

    no_tasks do

      def not_setup_warning
        say "Dotify has not been setup yet! You need to run 'dotify setup' first.", :yellow
      end

      def unlink_file(file, options = {})
        say "'#{file}' does not exist in Dotify.", :blue unless file.linked?
        if options[:force] == true || yes?("Do you want to unlink #{file} from the home directory? [Yn]", :blue)
          file.unlink
          say_status :unlinked, file.dotfile
        end
      end

      def link_file(file, options = {})
        return say_status :linked, file.dotfile if file.linked?
        return say "'#{file}' does not exist in the home directory.", :blue unless file.in_home_dir?
        if options[:force] == true || yes?("Do you want to link #{file} to the home directory? [Yn]", :blue)
          file.link
          say_status :linked, file.dotfile
        end
      end

    end

  end
end
