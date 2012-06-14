require 'dotify/version'
require 'thor'

module Dotify
  class CLI < Thor
    include Thor::Actions
    default_task :help

    map "-l" => "link"
    map "-u" => "unlink"
    map "-b" => "backup"
    map "-r" => "restore"

    DOTIFY_PATH = '.dotify'

    desc :setup, "Get your system setup for dotfile management"
    def setup
    end

    desc :link, "Link up your dotfiles"
    def link
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

  end
end
