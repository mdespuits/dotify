require 'thor/util'
require 'yaml'

module Dotify
  class Config

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
        @profile = name.to_s
      end

      def profile
        @profile
      end

      def directory=(dir)
        @directory = dir
      end

      def directory
        !@directory.nil? ? @directory : DEFAULT_DIR
      end

      def path
        File.join(home, directory)
      end

      def backup
        File.join(path, backup_dirname)
      end

      def backup_dirname
        !@backup_dirname.nil? ? @backup_dirname : DEFAULT_BACKUP
      end

      def backup_dirname=(backup)
        @backup_dirname = backup
      end

      def load_config!
        config = File.exists?(config_file) ? (YAML.load_file(config_file) || {}) : {}
        @config = symbolize_keys!(config)
        @config.each do |key, value|
          self.__send__("#{key}=", value) unless value.nil?
        end
        @config
      end

      def config
        @config || load_config!
      end

      def home
        Thor::Util.user_home
      end

      private

        def config_file
          location = File.join(home, '.dotifyrc')
        end

        def symbolize_keys!(opts)
          sym_opts = {}
          opts.each do |key, value|
            sym_opts[key.to_sym] = value.is_a?(Hash) ? symbolize_keys!(value) : value
          end
          sym_opts
        end

    end
  end
end
