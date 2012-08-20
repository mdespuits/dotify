require 'thor/util'
module Dotify
  module Path

    DOTIFY_DIR = ".dotify"

    extend self

    def home
      user_home
    end

    def dotify
      File.join(home, DOTIFY_DIR)
    end

    def dotify_path(path)
      File.join(dotify, path)
    end

    def home_path(path)
      File.join(home, path)
    end

    private

      def user_home
        Thor::Util.user_home
      end
  end
end