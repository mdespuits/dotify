module Dotify
  MAJOR = 0
  MINOR = 6
  PATCH = 6
  PRE   = nil

  class Version

    def self.build
      @built ||= Version.new
    end

    # Build Dotify's the Semantic Version for Rubygems and Bundler
    def level
      [MAJOR, MINOR, PATCH, PRE].compact.join(".")
    end

    def current?
      !!Checker.check_latest_release!
    end

    def out_of_date?
      !current?
    end
    alias :old? :out_of_date?

    def latest
      Checker.latest
    end

  end
end
