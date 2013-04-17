module Dotify
  module Path

    DOTIFY_DIR = '.dotify'

    extend self

    def home
      Pathname.new(Dir.home)
    end

    def dotify
      home + DOTIFY_DIR
    end

    def dotify_path(path)
      dotify + path
    end

    def home_path(path)
      home + path
    end

  end
end
