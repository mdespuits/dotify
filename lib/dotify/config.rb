require 'dotify'
require 'thor/util'
require 'yaml'

module Dotify
  class Config

    DOTIFY_DIRNAME = '.dotify'
    DOTIFY_CONFIG = '.dotrc'

    class << self

      def dirname
        @dirname ||= DOTIFY_DIRNAME
      end

      def installed?
        File.directory?(File.join(home, dirname))
      end

      def path
        File.join(home, dirname)
      end

      def editor
        config.fetch(:editor, 'vi')
      end

      def load_config!
        config = File.exists?(config_file) ? (YAML.load_file(config_file) || {}) : {}
        symbolize_keys!(config)
      end

      def ignore(what)
        config.fetch(:ignore, {}).fetch(what, [])
      end

      def config
        @config || load_config!
      end

      def home
        Thor::Util.user_home
      end

      private

        def config_file
          File.join(home, DOTIFY_CONFIG)
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
