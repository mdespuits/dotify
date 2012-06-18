require 'thor'
require 'thor/util'
require 'dotify'
require 'dotify/version'
require 'erb'
require 'fileutils'

module Dotify
  class CLI < Thor
    include Thor::Actions
    default_task :help

    map "-l" => "link"
    map "-u" => "unlink"
    map "-b" => "backup"
    map "-r" => "restore"

    DOTIFY_DIR_NAME = ENV['DOTIFY_DIR_NAME'] || '.dotify'
    DOTIFY_PATH = ENV['DOTIFY_PATH'] || "#{Thor::Util.user_home}/#{DOTIFY_DIR_NAME}"

    def self.source_root
      DOTIFY_PATH
    end

    desc :setup, "Get your system setup for dotfile management"
    def setup
      ::FileUtils.mkdir_p DOTIFY_PATH
    end

    desc :link, "Link up your dotfiles"
    def link
      dotfile_list do |file|
        if template? file
          template file, dotfile_location(no_extension(filename(file)))
        else
          create_link dotfile_location(file), file
        end
      end
    end

    desc :unlink, "Unlink individual dotfiles"
    method_option :force, default: false, type: :boolean, aliases: '-f', desc: "Definitely remove all dotfiles"
    def unlink
      dotfile_list do |file|
        destination = filename(file)
        if yes? "Are you sure you want to remove ~/#{destination}? [Yn]", :blue
          remove_file dotfile_location(file), verbose: true
        end
      end
    end

    desc :backup, "Backup your dotfiles for quick recovery if something goes wrong"
    def backup
    end

    desc :restore, "Restore your backed-up dotfiles"
    def restore
    end

    no_tasks do

      def dotfile_location(file)
        "#{home}/#{filename(file)}"
      end

      def no_extension(file)
        file = file.split('.')
        file.pop
        file.join('.')
      end

      def home
        Thor::Util.user_home
      end

      def dotfile_list
        files = Dir["#{DOTIFY_PATH}/.*"]
        files.delete_if { |f| File.directory? f }
        if block_given?
          files.each { |f| yield f }
        else
          files
        end
      end

      def filename(file)
        file.split("/").last
      end

      def template?(file)
        filename(file).match(/(tt|erb)$/)
      end

    end

  end
end
