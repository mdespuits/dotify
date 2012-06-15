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
    DOTIFY_PATH = "#{Thor::Util.user_home}/#{DOTIFY_DIR_NAME}"

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
          say "It's a template!", :blue
        else
          create_link "#{Thor::Util.user_home}/#{filename(file)}", file
        end
      end
    end

    desc :unlink, "Unlink individual dotfiles"
    def unlink
    end

    desc :backup, "Backup your dotfiles for quick recovery if something goes wrong"
    def backup
    end

    desc :restore, "Restore your backed-up dotfiles"
    def restore
    end

    no_tasks do

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
