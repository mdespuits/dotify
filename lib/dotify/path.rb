require 'thor/util'
module Dotify
  module Path

    DOTIFY_DIR = ".dotify"

    extend self

    def home
      Thor::Util.user_home
    end

    def dotify
      build_path home, DOTIFY_DIR
    end

    def dotify_path(path)
      build_path dotify, path
    end

    def home_path(path)
      build_path home, path
    end

    private

      def build_path(*args)
        File.join *args
      end

  end
end