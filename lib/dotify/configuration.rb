require 'dotify/errors'
require 'thor/util'
require 'yaml'

module Dotify
  class Configuration

    DEFAULT_DIR = '.dotify'
    DEFAULT_BACKUP = '.backup'
    SHELLS = {
      :zsh => '/bin/zsh',
      :bash => '/bin/bash',
      :sh => '/bin/sh'
    }

    class << self

      def shell=(shell)
        if !SHELLS.keys.include?(shell)
          raise NonValidShell, "You must specify a valid shell: #{SHELLS.keys.map(&:inspect).join(", ")}"
        end
        @shell = shell
      end

      def shell
        @shell
      end

      def profile=(name)
        @name = name.to_s
      end

      def profile
        @name
      end

      def directory=(dir)
        @directory = dir
      end

      def directory
        !@directory.nil? ? @directory : DEFAULT_DIR
      end

      def path
        "#{home}/#{directory}"
      end

      def backup
        "#{path}/#{backup_dirname}"
      end

      def backup_dirname
        !@backup_dirname.nil? ? @backup_dirname : DEFAULT_BACKUP
      end

      def backup_dirname=(backup)
        @backup_dirname = backup
      end

      def load_config_file!
        config = File.exists?(config_file) ? YAML.load_file(config_file) : {}
      end

      private

        def home
          Thor::Util.user_home
        end

        def config_file
          location = File.join(home, '.dotifyrc')
        end

    end
  end
end
