require 'thor/util'
module Dotify
  module Path

    Dir = ".dotify"

    extend self

    def home
      user_home
    end

    def dotify
      File.join(home, Dir)
    end

    def dotify_path(path)
      File.join(home, Dir, path)
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