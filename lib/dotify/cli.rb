require 'rubygems'
require 'thor'
require 'fileutils'
require 'net/http'

require 'dotify'

module Dotify
  module CLI
    class Base < Thor

      include Thor::Actions

      default_task :help

      map %w[-v --version] => :version
      map "-s" => :setup
      map "-l" => :link
      map "-u" => :unlink

      def self.source_root
        File.expand_path("../../../templates", __FILE__)
      end

      desc :save, "Save Dotify files and push to Repo."
      def save
      end

      desc 'github [USERNAME]/[REPO]', "Install the dotfiles from a GitHub repo into Dotify. (Backs up any files that would be overwritten)"
      def github(repo)
      end

      desc 'repo [URL]', "Install the dotfiles from a repo into Dotify. (Backs up any files that would be overwritten)"
      def repo(repo)
      end

      desc :list, "List the installed dotfiles"
      def list
      end

      desc 'edit [FILE]', "Edit a dotify file"
      def edit(file)
      end

      desc :version, "Check your Dotify version"
      def version
      end

      desc :setup, "Setup your system for Dotify to manage your dotfiles"
      def setup
      end

      desc :install, "Install files from your home directory into Dotify"
      def install
      end

      desc 'link [[FILENAME]]', "Link up one or all of your dotfiles (FILENAME is optional)"
      def link(file = nil)
      end

      desc 'unlink [[FILENAME]]', "Unlink one or all of your dotfiles (FILENAME is optional)"
      def unlink(file = nil)
      end

    end
  end
end
